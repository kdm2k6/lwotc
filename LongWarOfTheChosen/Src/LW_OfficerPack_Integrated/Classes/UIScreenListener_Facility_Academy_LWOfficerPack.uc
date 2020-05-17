//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_Academy_StaffSlot_LWOfficerPack
//  AUTHOR:  Amineri
//  PURPOSE: Implements hooks to setup officer Staff Slot 
//--------------------------------------------------------------------------------------- 

class UIScreenListener_Facility_Academy_LWOfficerPack extends UIScreenListener dependsOn(UIScreenListener_Facility);

var UIButton OfficerButton;
var UIFacility_LWOfficerSlot Slot;
var localized string strOfficerTrainButton;
var UIPersonnel PersonnelSelection;
var XComGameState_StaffSlot StaffSlot;

event OnInit(UIScreen Screen)
{
	local int i, QueuedDropDown;
	local UIFacility_Academy ParentScreen;

	// Default is no dropdown
	QueuedDropDown = -1;

	ParentScreen = UIFacility_Academy(Screen);

	// Check for queued dropdown, and cache it if find one
	for (i = 0; i < ParentScreen.m_kStaffSlotContainer.StaffSlots.Length; i++)
	{
		if (ParentScreen.m_kStaffSlotContainer.StaffSlots[i].m_QueuedDropDown)
		{
			QueuedDropDown = i;
			break;
		}
	}

	ParentScreen.RealizeNavHelp();

	// Get rid of existing staff slots
	for (i = ParentScreen.m_kStaffSlotContainer.StaffSlots.Length-1; i >= 0; i--)
	{
		ParentScreen.m_kStaffSlotContainer.StaffSlots[i].Remove();
		ParentScreen.m_kStaffSlotContainer.StaffSlots[i].Destroy();
	}

	// Get rid of the existing staff slot container
	ParentScreen.m_kStaffSlotContainer.Hide();
	ParentScreen.m_kStaffSlotContainer.Destroy();

	// Create the new staff slot container that correctly handles the second soldier officer slot
	ParentScreen.m_kStaffSlotContainer = ParentScreen.Spawn(class'UIFacilityStaffContainer_LWOTS', ParentScreen);
	ParentScreen.m_kStaffSlotContainer.InitStaffContainer();
	ParentScreen.m_kStaffSlotContainer.SetMessage("");
	ParentScreen.RealizeStaffSlots();

	// Re-queue the dropdown if there was one
	if (QueuedDropDown >= 0)
	{
		ParentScreen.ClickStaffSlot(QueuedDropDown);
	}


	// KDM : UIScreenListener_Facility fixes the finnicky UIFacility controller navigation system via OnInit(); unfortunately,
	// its functions need to be called last, after the facility screen has been setup. Since we can't determine screen listener ordering, 
	// make sure these functions are called last no matter what.
	class'UIScreenListener_Facility'.static.ReconstructNavigationSystem(UIFacility(Screen));
	class'UIScreenListener_Facility'.static.PerformInitialSelection(UIFacility(Screen));
	// KDM : Navigation selection done in UIFacility --> InitScreen() has been contaminated since the staff slot container, as well as
	// its staff slots, have been destroyed and replaced with custom variants. Consequently, redo initial selection.
	//ParentScreen.Navigator.SelectFirstAvailable();
	//ReconstructNavigation(ParentScreen);
	// KDM TO DO : I'm thinking the navigation system has been screwed up since m_kStaffSlotContainer's navigation had already been
	// setup before it was destroyed and replaced with a custom variant.
}

// UIFacility has :
// m_kRoomContainer (UIRoomContainer --> UIPanel) stores array of UIFacility_RoomFunc's (UPanel's basically)
// m_kStaffSlotContainer (UIFacilityStaffContainer --> UIStaffContainer --> UIPanel) has an array of UIStaffSlot's (or subclasses) and
// an UIPersonnel_DropDown. UIPersonnel_DropDown is a UIPanel and UIStaffSlot is a UIPanel.

function ReconstructNavigation(UIFacility_Academy FacilityScreen)
{
	local bool StaffSlotContainerIsUsable;
	local UIRoomContainer RoomContainer;
	local UIStaffContainer StaffSlotContainer;

	RoomContainer = FacilityScreen.m_kRoomContainer;
	StaffSlotContainer = FacilityScreen.m_kStaffSlotContainer;
	StaffSlotContainerIsUsable = (StaffSlotContainer != none && StaffSlotContainer.NumChildren() > 0) ? true : false;
	
	// KDM : We want the UIFacility to ignore D-Pad left/right; it's subcomponents will do that. 
	FacilityScreen.Navigator.HorizontalNavigation = false;
	if (StaffSlotContainerIsUsable)
	{
		// KDM : Staff slots are placed horizontally, so we want the container to work horizontally.
		StaffSlotContainer.Navigator.HorizontalNavigation = true;
		// KDM : We want staff slot selection to loop around with D-Pad left/right; this also prevents situations in which D-Pad left/right 
		// are sent up to the facility screen, which will then select the next/previous UI element, like the room container.
		StaffSlotContainer.Navigator.LoopSelection = true;
	}

	// KDM : Remove all focus, just in case any existed beforehand
	FacilityScreen.Navigator.ClearSelectionHierarchy();
	// KDM : Remove all navigable controls
	FacilityScreen.Navigator.Clear();
	// KDM : Remove all navigation targets
	FacilityScreen.Navigator.ClearAllNavigationTargets();
	
	if (StaffSlotContainerIsUsable)
	{
		// KDM : Remove all focus, just in case any existed beforehand
		StaffSlotContainer.Navigator.ClearSelectionHierarchy();
		// KDM : Remove all navigation targets, just in case they were set beforehand
		StaffSlotContainer.Navigator.ClearAllNavigationTargets();
		
		FacilityScreen.Navigator.AddControl(StaffSlotContainer);
		if (RoomContainer != none)
		{
			// KDM : If the staff slot container is selected and you hit D-Pad down, select the room button container below it.
			StaffSlotContainer.Navigator.AddNavTargetDown(RoomContainer);
		}
	}

	if (RoomContainer != none)
	{
		// KDM : Remove all focus, just in case any existed beforehand
		RoomContainer.Navigator.ClearSelectionHierarchy();
		// KDM : Remove all navigation targets, just in case they were set beforehand
		RoomContainer.Navigator.ClearAllNavigationTargets();

		FacilityScreen.Navigator.AddControl(RoomContainer);
		if (StaffSlotContainerIsUsable)
		{
			// KDM : If the room button container is selected and you hit D-Pad up, select the staff slot container above it.
			RoomContainer.Navigator.AddNavTargetUp(StaffSlotContainer);
		}
	}

	// KDM : When you hit the left and right bumper buttons, the navigation system moves down to the Avenger shortcut bar. 
	// We want to be able to escape the shortcut bar, and move back to the facility's buttons, with D-Pad up; however, this escape
	// depends upon what is available. If possible, we will choose the room container, since it is closest the shortcut bar; however,
	// if it isn't available, we will go with the staff slot container.
	if (RoomContainer != none)
	{
		FacilityScreen.Navigator.AddNavTargetUp(RoomContainer);
	}
	else if (StaffSlotContainerIsUsable)
	{
		FacilityScreen.Navigator.AddNavTargetUp(StaffSlotContainer);
	}

	// KDM : Navigation has been set up; it's now time for initial selection
	if (StaffSlotContainerIsUsable)
	{
		// KDM : The staff slot container has bCascadeFocus set to false, so we need to select the 1st available slot as well as itself.
		StaffSlotContainer.Navigator.SelectFirstAvailable();
		FacilityScreen.Navigator.SetSelected(StaffSlotContainer);
	}
	else if (RoomContainer != none)
	{
		FacilityScreen.Navigator.SetSelected(RoomContainer);
	}
}

event OnReceiveFocus(UIScreen Screen)
{
	UIFacility_Academy(Screen).m_kStaffSlotContainer.Show();
}

event OnLoseFocus(UIScreen Screen)
{
	UIFacility_Academy(Screen).m_kStaffSlotContainer.Hide();
}

event OnRemoved(UIScreen Screen)
{
	// KDM : This did nothing so it probably doesn't need to be here; leaving it, for the moment, just in case.
}

simulated function OnSoldierSelected(StateObjectReference _UnitRef)
{
	local UIArmory_LWOfficerPromotion OfficerScreen;
	local XComHQPresentationLayer HQPres;

	HQPres = `HQPRES;
	OfficerScreen = UIArmory_LWOfficerPromotion(HQPres.ScreenStack.Push(HQPres.Spawn(class'UIArmory_LWOfficerPromotion', HQPres), HQPres.Get3DMovie()));
	OfficerScreen.InitPromotion(_UnitRef, false);
	OfficerScreen.CreateSoldierPawn();
}

defaultproperties
{
	ScreenClass = UIFacility_Academy;
}