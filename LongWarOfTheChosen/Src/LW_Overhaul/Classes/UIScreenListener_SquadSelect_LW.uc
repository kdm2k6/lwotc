//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener
//  AUTHOR:  Amineri / Pavonis Interactive
//
//  PURPOSE: Adds additional functionality to SquadSelect_LW (from Toolbox)
//			 Provides support for squad-editting without launching mission
//--------------------------------------------------------------------------------------- 

class UIScreenListener_SquadSelect_LW extends UIScreenListener config(LW_Overhaul);

var localized string strSave;
var localized string strSquad;

var localized string strStart;
var localized string strInfiltration;

var localized string strAreaOfOperations;

var bool bInSquadEdit;
var GeneratedMissionData MissionData;

var config float SquadInfo_DelayedInit;
var const array<string> PlotTypes;

event OnInit(UIScreen Screen)
{
	local float RequiredInfiltrationPct;
	local string BriefingString;
	local UISquadContainer SquadContainer;
	local UISquadSelect SquadSelect;
	local UISquadSelect_InfiltrationPanel InfiltrationInfo;
	local UITextContainer InfilRequirementText, MissionBriefText;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_LWSquadManager SquadMgr;
	local XComGameState_MissionSite MissionState;
	
	if (!Screen.IsA('UISquadSelect'))
	{
		return;
	}

	`Log("UIScreenListener_SquadSelect_LW: Initializing");
	
	SquadSelect = UISquadSelect(Screen);
	if (SquadSelect == none)
	{
		return;
	}

	// KDM : This button need not be added if a controller is active.
	if (!`ISCONTROLLERACTIVE)
	{
		class'LWHelpTemplate'.static.AddHelpButton_Std('SquadSelect_Help', SquadSelect, 1057, 12);
	}

	XComHQ = `XCOMHQ;
	SquadMgr = `LWSQUADMGR;

	// LW : Pause and resume all headquarter's projects in order to refresh the state. This is needed because exiting squad select without 
	// going on a mission can result in projects being resumed without being paused, and they may be stale.
	XComHQ.PauseProjectsForFlight();
	XComHQ.ResumeProjectsPostFlight();

	XComHQ = `XCOMHQ;
	// LW : Refresh the squad select's XComHQ since it has been updated.
	SquadSelect.XComHQ = XComHQ;

	MissionData = XComHQ.GetGeneratedMissionData(XComHQ.MissionRef.ObjectID);

	UpdateMissionDifficulty(SquadSelect);

	// LW : Check if we got here from the SquadBarracks.
	// KDM : This has been updated to also check for my controller capable squad barracks class on the stack.
	bInSquadEdit = (`SCREENSTACK.IsInStack(class'UIPersonnel_SquadBarracks') || class'UIScreenListener_LWOfficerPack'.static.ControllerCapableSquadBarracksIsOnStack());
	
	if (bInSquadEdit)
	{
		if (!`ISCONTROLLERACTIVE)
		{
			SquadSelect.LaunchButton.OnClickedDelegate = OnSaveSquad;
			SquadSelect.LaunchButton.SetText(strSquad);
			SquadSelect.LaunchButton.SetTitle(strSave);
		}
		else
		{
			// KDM : If a controller is active, we don't want the save button shown.
			SquadSelect.LaunchButton.Hide();
		}

		SquadSelect.m_kMissionInfo.Remove();
	} 
	else 
	{
		`Log("UIScreenListener_SquadSelect_LW: Arrived from mission");
		
		if (SquadMgr.IsValidInfiltrationMission(XComHQ.MissionRef))
		{
			`Log("UIScreenListener_SquadSelect_LW: Setting up for infiltration mission");
			
			SquadSelect.LaunchButton.SetText(strStart);
			SquadSelect.LaunchButton.SetTitle(strInfiltration);

			InfiltrationInfo = SquadSelect.Spawn(class'UISquadSelect_InfiltrationPanel', SquadSelect);
			InfiltrationInfo.MCName = 'SquadSelect_InfiltrationInfo_LW';
			InfiltrationInfo.MissionData = MissionData;
			InfiltrationInfo.SquadSoldiers = SquadSelect.XComHQ.Squad;
			InfiltrationInfo.DelayedInit(default.SquadInfo_DelayedInit);

			// LW : Check if we need to infiltrate to 100%, and display a message if so.
			MissionState = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(`XCOMHQ.MissionRef.ObjectID));
			RequiredInfiltrationPct = class'XComGameState_LWPersistentSquad'.static.GetRequiredPctInfiltrationToLaunch(MissionState);
			if (RequiredInfiltrationPct > 0.0)
			{
				InfilRequirementText = SquadSelect.Spawn(class'UITextContainer', SquadSelect);
				InfilRequirementText.MCName = 'SquadSelect_InfiltrationRequirement_LW';
				InfilRequirementText.bAnimateOnInit = false;
				InfilRequirementText.InitTextContainer('',, 725, 100, 470, 50, true, /* class'UIUtilities_Controls'.const.MC_X2Background */, /* true */);
				InfilRequirementText.bg.SetColor(class'UIUtilities_Colors'.const.BAD_HTML_COLOR);
				InfilRequirementText.SetHTMLText(RequiredInfiltrationString(RequiredInfiltrationPct));
				InfilRequirementText.SetAlpha(66);
			}
		}

		// KDM : If a controller is active, we don't want to show the SquadContainer.
		if (!`ISCONTROLLERACTIVE)
		{
			// LW : Create the SquadContainer on a timer, to avoid creation issues that can arise when creating it immediately, when no pawn loading is present.
			SquadContainer = SquadSelect.Spawn(class'UISquadContainer', SquadSelect);
			SquadContainer.CurrentSquadRef = SquadMgr.LaunchingMissionSquad;
			SquadContainer.DelayedInit(default.SquadInfo_DelayedInit);
		} 

		MissionState = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(XComHQ.MissionRef.ObjectID));

		MissionBriefText = SquadSelect.Spawn (class'UITextContainer', SquadSelect);
		MissionBriefText.MCName = 'SquadSelect_MissionBrief_LW';
		MissionBriefText.bAnimateOnInit = false;
		MissionBriefText.InitTextContainer('',, 35, 375, 400, 300, false);
		BriefingString = "<font face='$TitleFont' size='22' color='#a7a085'>" $ CAPS(class'UIMissionIntro'.default.m_strMissionTitle) $ "</font>\n";
		BriefingString $= "<font face='$NormalFont' size='22' color='#" $ class'UIUtilities_Colors'.const.NORMAL_HTML_COLOR $ "'>";
		BriefingString $= class'UIUtilities_LW'.static.GetMissionTypeString (XComHQ.MissionRef) $ "\n";
		if (class'UIUtilities_LW'.static.GetTimerInfoString (MissionState) != "")
		{
			BriefingString $= class'UIUtilities_LW'.static.GetTimerInfoString (MissionState) $ "\n";
		}
		BriefingString $= class'UIUtilities_LW'.static.GetEvacTypeString (MissionState) $ "\n";
		if (class'UIUtilities_LW'.static.HasSweepObjective(MissionState))
		{
			BriefingString $= class'UIUtilities_LW'.default.m_strSweepObjective $ "\n";
		}
		if (class'UIUtilities_LW'.static.FullSalvage(MissionState))
		{
			BriefingString $= class'UIUtilities_LW'.default.m_strGetCorpses $ "\n";
		}
		BriefingString $= class'UIUtilities_LW'.static.GetMissionConcealStatusString (XComHQ.MissionRef) $ "\n";
		BriefingString $= "\n";
		BriefingString $= "<font face='$TitleFont' size='22' color='#a7a085'>" $ CAPS(strAreaOfOperations) $ "</font>\n";
		BriefingString $= "<font face='$NormalFont' size='22' color='#" $ class'UIUtilities_Colors'.const.NORMAL_HTML_COLOR $ "'>";
		BriefingString $= GetPlotTypeFriendlyName(MissionState.GeneratedMission.Plot.strType);
		BriefingString $= "\n";
		BriefingString $= "</font>";
		MissionBriefText.SetHTMLText (BriefingString);
	}
}

static function string GetPlotTypeFriendlyName(string PlotType)
{
	local int i;

	// LW : Use the multiplayer localisation to get the friendly name for a given plot type.
	i = default.PlotTypes.Find(PlotType);

	if (i == INDEX_NONE)
	{
		`REDSCREEN("Unknown plot type '" $ PlotType $ "' encountered in GetPlotTypeFriendlyName()");
		return "???";
	}
	else
	{
		return class'X2MPData_Shell'.default.arrMPMapFriendlyNames[i];
	}
}

simulated function string RequiredInfiltrationString(float RequiredValue)
{
	local string ReturnString;
	local XGParamTag ParamTag;
	
	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.IntValue0 = Round(RequiredValue);
	ReturnString = `XEXPAND.ExpandString(class'UIMission_LWLaunchDelayedMission'.default.m_strInsuffientInfiltrationToLaunch);

	return "<p align='CENTER'><font face='$TitleFont' size='20' color='#000000'>" $ ReturnString $ "</font>";
}


function UpdateMissionDifficulty(UISquadSelect SquadSelect)
{
	local string Text;
	local XComGameState_MissionSite MissionState;
	
	MissionState = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(`XCOMHQ.MissionRef.ObjectID));
	Text = class'UIUtilities_Text_LW'.static.GetDifficultyString(MissionState);
	SquadSelect.m_kMissionInfo.MC.ChildSetString("difficultyValue", "htmlText", Caps(Text));
}

function OnSquadManagerClicked(UIButton Button)
{
	local UIPersonnel_SquadBarracks kPersonnelList;
	local XComHQPresentationLayer HQPres;

	HQPres = `HQPRES;

	// KDM : This has been updated to also check for my controller capable squad barracks class on the stack.
	if (HQPres.ScreenStack.IsNotInStack(class'UIPersonnel_SquadBarracks') &&
		(!class'UIScreenListener_LWOfficerPack'.static.ControllerCapableSquadBarracksIsOnStack()))
	{
		kPersonnelList = HQPres.Spawn(class'UIPersonnel_SquadBarracks', HQPres);
		kPersonnelList.bSelectSquad = true;
		HQPres.ScreenStack.Push(kPersonnelList);
	}
}

// KDM : Since this function is never called when a controller is active, due to its button being hidden, I don't need to worry about it.
// If this was not the case, I would have to worry about it since it deals with UIPersonnel_SquadBarracks, but not my custom, UIScreen derived,
// UIPersonnel_SquadBarracks_ForControllers class.
simulated function OnSaveSquad(UIButton Button)
{
	local UIPersonnel_SquadBarracks Barracks;
	local UIScreenStack ScreenStack;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_LWSquadManager SquadMgr;
	
	XComHQ = `XCOMHQ;
	ScreenStack = `SCREENSTACK;
	SquadMgr = `LWSQUADMGR;
	Barracks = UIPersonnel_SquadBarracks(ScreenStack.GetScreen(class'UIPersonnel_SquadBarracks'));
	SquadMgr.GetSquad(Barracks.CurrentSquadSelection).SquadSoldiers = XComHQ.Squad;
	GetSquadSelect().CloseScreen();
	ScreenStack.PopUntil(Barracks);
}

simulated function UISquadSelect GetSquadSelect()
{
	local int Index;
	local UIScreenStack ScreenStack;
	
	ScreenStack = `SCREENSTACK;
	for (Index = 0; Index < ScreenStack.Screens.Length; ++Index)
	{
		if (UISquadSelect(ScreenStack.Screens[Index]) != none)
		{
			return UISquadSelect(ScreenStack.Screens[Index]);
		}
	}
	return none; 
}

event OnReceiveFocus(UIScreen Screen)
{
	local UISquadSelect SquadSelect;
	local UISquadSelect_InfiltrationPanel InfiltrationInfo;

	if (!Screen.IsA('UISquadSelect'))
	{
		return;
	}

	SquadSelect = UISquadSelect(Screen);
	if (SquadSelect == none)
	{
		return;
	}

	`Log("UIScreenListener_SquadSelect_LW: Received focus");
	
	// LW : Workaround for bug in currently published version of squad select
	SquadSelect.bDirty = true; 
	SquadSelect.UpdateData();
	SquadSelect.UpdateNavHelp();

	UpdateMissionDifficulty(SquadSelect);

	InfiltrationInfo = UISquadSelect_InfiltrationPanel(SquadSelect.GetChildByName('SquadSelect_InfiltrationInfo_LW', false));
	if (InfiltrationInfo != none)
	{
		`Log("UIScreenListener_SquadSelect_LW: Found infiltration panel");
		
		// LW : Remove and recreate infiltration info in order to prevent issues with Flash text updates not getting processed.
		InfiltrationInfo.Remove();

		InfiltrationInfo = SquadSelect.Spawn(class'UISquadSelect_InfiltrationPanel', SquadSelect).InitInfiltrationPanel();
		InfiltrationInfo.MCName = 'SquadSelect_InfiltrationInfo_LW';
		InfiltrationInfo.MissionData = MissionData;
		InfiltrationInfo.Update(SquadSelect.XComHQ.Squad);
	}
}

event OnLoseFocus(UIScreen Screen);

event OnRemoved(UIScreen Screen)
{
	local StateObjectReference SquadRef, NullRef;
	local UISquadSelect SquadSelect;
	local XComGameState NewGameState;
	local XComGameState_LWPersistentSquad SquadState;
	local XComGameState_LWSquadManager SquadMgr;
	
	if(!Screen.IsA('UISquadSelect'))
	{
		return;
	}

	SquadSelect = UISquadSelect(Screen);

	// Need to move camera back to the hangar, if was in SquadManagement
	if (bInSquadEdit)
	{
		`HQPRES.CAMLookAtRoom(`XCOMHQ.GetFacilityByName('Hangar').GetRoom(), `HQINTERPTIME);
	}

	SquadMgr = `LWSQUADMGR;
	SquadRef = SquadMgr.LaunchingMissionSquad;
	if (SquadRef.ObjectID != 0)
	{
		SquadState = XComGameState_LWPersistentSquad(`XCOMHISTORY.GetGameStateForObjectID(SquadRef.ObjectID));
		if (SquadState != none)
		{
			if (SquadState.bTemporary && !SquadSelect.bLaunched)
			{
				SquadMgr.RemoveSquadByRef(SquadRef);
				NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Clearing LaunchingMissionSquad");
				SquadMgr = XComGameState_LWSquadManager(NewGameState.CreateStateObject(class'XComGameState_LWSquadManager', SquadMgr.ObjectID));
				NewGameState.AddStateObject(SquadMgr);
				SquadMgr.LaunchingMissionSquad = NullRef;
				`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
			}
		}
	}
}

defaultproperties
{
	ScreenClass = none;

	PlotTypes[0]="Duel"
	PlotTypes[1]="Facility"
	PlotTypes[2]="SmallTown"
	PlotTypes[3]="Shanty"
	PlotTypes[4]="Slums"
	PlotTypes[5]="Wilderness"
	PlotTypes[6]="CityCenter"
	PlotTypes[7]="Rooftops"
	PlotTypes[8]="Abandoned"
	PlotTypes[9]="Tunnels_Sewer"
	PlotTypes[10]="Tunnels_Subway"
	PlotTypes[11]="Stronghold"
}
