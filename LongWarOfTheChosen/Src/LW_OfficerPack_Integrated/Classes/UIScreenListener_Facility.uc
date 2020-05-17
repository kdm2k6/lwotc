//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_Facility
//  AUTHOR:  KDM
//  PURPOSE: Controller navigation for UIFacilities acts quite strangely at times. Here are just a few examples :
//	1.] If the rightmost staff slot is selected, and you hit D-Pad right, suddenly the room button, if one exists, becomes selected.
//	It would be better if selection looped within the staff slot container.
//	2.] If you press the right or left bumper, the Avenger shortcuts, at the bottom of the screen, become selected. You have to press
//	the D-Pad down to move it back up to the room button. Furthemore, when the Avenger shorcuts are selected, pressing the D-Pad left
//	and right can result in all sorts of weird behaviour.
//
//	The solution : Kill the finnicky navigation system and create it anew. Note that we could have modified UIFacility via hooks instead; 
//	however, navigation code is strewn throughout the class so re-creation is likely the better option.
//--------------------------------------------------------------------------------------- 

class UIScreenListener_Facility extends UIScreenListener;

event OnInit(UIScreen Screen)
{
	local UIFacility FacilityScreen;

	// KDM : We are only concerned with UIFacility and its subclasses.
	if (Screen.IsA('UIFacility'))
	{
		FacilityScreen = UIFacility(Screen);
		ReconstructNavigationSystem(FacilityScreen);
		PerformInitialSelection(FacilityScreen);
	}
}

static function ReconstructNavigationSystem(UIFacility FacilityScreen)
{
	local bool StaffSlotContainerIsUsable;
	local UIRoomContainer RoomContainer;
	local UIStaffContainer StaffSlotContainer;

	if (FacilityScreen == none)
	{
		return;
	}

	RoomContainer = FacilityScreen.m_kRoomContainer;
	StaffSlotContainer = FacilityScreen.m_kStaffSlotContainer;
	StaffSlotContainerIsUsable = (StaffSlotContainer != none && StaffSlotContainer.NumChildren() > 0) ? true : false;
	
	// KDM : The UIFacility screen should ignore D-Pad left/right; its subcomponents will deal with them. 
	FacilityScreen.Navigator.HorizontalNavigation = false;
	if (StaffSlotContainerIsUsable)
	{
		// KDM : The staff slot container should navigate via D-Pad left/right, since its staff slots are positioned horizontally.
		StaffSlotContainer.Navigator.HorizontalNavigation = true;
		// KDM : Staff slot selection should loop; this also prevents the facility screen from transferring selection from the staff
		// slots to the room button via D-Pad left/right.
		StaffSlotContainer.Navigator.LoopSelection = true;
	}

	// KDM : Remove all focus, just in case any existed beforehand.
	FacilityScreen.Navigator.ClearSelectionHierarchy();
	// KDM : Remove all navigable controls.
	FacilityScreen.Navigator.Clear();
	// KDM : Remove all navigation targets.
	FacilityScreen.Navigator.ClearAllNavigationTargets();
	
	if (StaffSlotContainerIsUsable)
	{
		// KDM : Remove all focus, just in case any existed beforehand.
		StaffSlotContainer.Navigator.ClearSelectionHierarchy();
		// KDM : Remove all navigation targets.
		StaffSlotContainer.Navigator.ClearAllNavigationTargets();
		// KDM : We don't call StaffSlotContainer.Navigator.Clear() because staff slots have already been added, as navigable controls, to
		// the staff slot container, and we don't want to undo this.
		
		FacilityScreen.Navigator.AddControl(StaffSlotContainer);
		if (RoomContainer != none)
		{
			// KDM : If the staff slot container is selected, and you hit D-Pad down, select the room button container below it.
			StaffSlotContainer.Navigator.AddNavTargetDown(RoomContainer);
		}
	}

	if (RoomContainer != none)
	{
		// KDM : Remove all focus, just in case any existed beforehand.
		RoomContainer.Navigator.ClearSelectionHierarchy();
		// KDM : Remove all navigation targets.
		RoomContainer.Navigator.ClearAllNavigationTargets();
		// KDM : We don't call RoomContainer.Navigator.Clear() because we want the room container's navigable controls, which have already
		// been setup, to remain unaltered.
		
		FacilityScreen.Navigator.AddControl(RoomContainer);
		if (StaffSlotContainerIsUsable)
		{
			// KDM : If the room button container is selected, and you hit D-Pad up, select the staff slot container above it.
			RoomContainer.Navigator.AddNavTargetUp(StaffSlotContainer);
		}
	}

	// KDM : When you hit the left and right bumper buttons, the navigation system moves down to the Avenger shortcut bar. 
	// We want to be able to escape the shortcut bar, and move back to the facility's buttons, with D-Pad up; however, this escape
	// depends upon what is available. If possible, we will choose the room container, since it is closest to the shortcut bar; however,
	// if it isn't available, we will go with the staff slot container.
	if (RoomContainer != none)
	{
		FacilityScreen.Navigator.AddNavTargetUp(RoomContainer);
	}
	else if (StaffSlotContainerIsUsable)
	{
		FacilityScreen.Navigator.AddNavTargetUp(StaffSlotContainer);
	}
}

static function PerformInitialSelection(UIFacility FacilityScreen)
{
	local bool StaffSlotContainerIsUsable;
	local UIRoomContainer RoomContainer;
	local UIStaffContainer StaffSlotContainer;

	if (FacilityScreen == none)
	{
		return;
	}

	RoomContainer = FacilityScreen.m_kRoomContainer;
	StaffSlotContainer = FacilityScreen.m_kStaffSlotContainer;
	StaffSlotContainerIsUsable = (StaffSlotContainer != none && StaffSlotContainer.NumChildren() > 0) ? true : false;

	// KDM : If the staff slot container exists, and has at least 1 staff slot, select the 1st available staff slot.
	if (StaffSlotContainerIsUsable)
	{
		// KDM : The staff slot container has bCascadeFocus set to false, so we need to select the 1st available slot as well as the container, itself.
		StaffSlotContainer.Navigator.SelectFirstAvailable();
		FacilityScreen.Navigator.SetSelected(StaffSlotContainer);
	}
	// KDM : If the room container exists, then select it.
	else if (RoomContainer != none)
	{
		FacilityScreen.Navigator.SetSelected(RoomContainer);
	}
}


defaultproperties
{
	// KDM : This is being left empty so we are able to listen to all subclasses of UIFacility.
}

