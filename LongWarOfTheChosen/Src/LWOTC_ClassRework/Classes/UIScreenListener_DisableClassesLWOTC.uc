class UIScreenListener_DisableClassesLWOTC extends UIScreenListener config(ClassData);

var config array<name> LegacyClasses;
var config array<name> ReworkClasses;

event OnInit(UIScreen Screen)
{
    if (Screen.IsA('UIFacility') || Screen.IsA('UIArmory') || Screen.IsA('UIAfterAction') || Screen.IsA('UISquadSelect') || Screen.IsA('UIPersonnel'))
    {
		CheckXComHQSoldierClassDeck();
	}
	else if (Screen.IsA('UIStrategyMap') || Screen.IsA('UIMission') || Screen.IsA('UIRecruitSoldiers'))
	{
		CheckResistanceHQSoldierClassDeck();
	}
}

static function CheckXComHQSoldierClassDeck()
{
	local XComGameState								NewGameState;
	local XComGameState_HeadquartersXCom			XComHQ;
	local name										ClassName;
	local bool										UpdatedHQ;
	local bool										TrimRequired;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Evaluate XCom HQ class deck");
	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();

	`LOG("Checking Xcom HQ class deck...");

	`LOG("Class Rework is enabled: " @ string(`SecondWaveEnabled('EnableClassRework')));

	// The XCom HQ soldier class deck is not empty. Check if it needs to be trimmed
	foreach XComHQ.SoldierClassDeck(ClassName)
	{
		if (IsDisabledClass(ClassName))
		{
			TrimRequired = true;

			break;
		}
	}

	if(TrimRequired)
	{
		XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(XComHQ.Class, XComHQ.ObjectID));
		NewGameState.AddStateObject(XComHQ);
		UpdatedHQ = true;

		// Trim the XCom HQ soldier class deck
		TrimXComHQSoldierClassDeck(XComHQ);
		`LOG("Trimmed Xcom HQ class deck.");
	}

	// If the Xcom HQ soldier class deck is empty, re-build and trim it
	if (XComHQ.SoldierClassDeck.Length == 0)
	{
		if (!UpdatedHQ)
		{
			XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(XComHQ.Class, XComHQ.ObjectID));
			NewGameState.AddStateObject(XComHQ);
		}

		// Clear the soldier class distribution so that things aren't weighted heavily towards new classes if added
		XComHQ.SoldierClassDistribution.Length = 0;
		// Clear the soldier class deck so that it will contain only the rebuilt deck
		XComHQ.SoldierClassDeck.Length = 0;
	
		// Rebuild the normal deck for the Xcom HQ
		XComHQ.BuildSoldierClassDeck();

		`LOG("Rebuilt Xcom HQ class deck.");

		// Trim any disabled class names from the rebuilt deck
		TrimXComHQSoldierClassDeck(XComHQ);
		`LOG("Trimmed Xcom HQ class deck.");
	}

	if (NewGameState.GetNumGameStateObjects() > 0)
		`GAMERULES.SubmitGameState(NewGameState);
	else
		`XCOMHISTORY.CleanupPendingGameState(NewGameState);
}

static function TrimXComHQSoldierClassDeck(XComGameState_HeadquartersXCom XComHQ)
{
	local array<name> DisabledClassNames;
	local name ClassName;
	local SoldierClassCount ClassCount;
	local int i;

	if(`SecondWaveEnabled('EnableClassRework'))
	{
		DisabledClassNames = default.LegacyClasses;
	}
	else
	{
		DisabledClassNames = default.ReworkClasses;
	}
	
	// Trim disabled class names from the soldier class deck
	for (i = XComHQ.SoldierClassDeck.Length - 1; i >= 0; i--)
	{
		ClassName = XComHQ.SoldierClassDeck[i];
		if (DisabledClassNames.Find(ClassName) != INDEX_NONE)
		{
			XComHQ.SoldierClassDeck.Remove(i, 1);

			`LOG("Trimmed disabled class " @ ClassName @ " from XCom HQ deck.");
		}
	}

	// Trim the soldier class distribution list to prevent weighting from re-building the deck on us afterwards
	for (i = XComHQ.SoldierClassDistribution.Length - 1; i >= 0; i--)
	{
		ClassName = XComHQ.SoldierClassDistribution[i].SoldierClassName;
		if (DisabledClassNames.Find(ClassName) != INDEX_NONE)
		{
			XComHQ.SoldierClassDistribution.Remove(i, 1);

			`LOG("Removed class " @ ClassName @ " from XCom HQ distribution.");
		}
	}
}

static function CheckResistanceHQSoldierClassDeck()
{
	local XComGameState								NewGameState;
	local XComGameState_HeadquartersResistance		ResistanceHQ;
	local name										ClassName;
	local bool										UpdatedHQ;
	local bool										TrimRequired;
	
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Disable Any Class evaluate Resistance HQ class deck");
	ResistanceHQ = class'UIUtilities_Strategy'.static.GetResistanceHQ();

	`LOG("Checking Resistance HQ class deck...");

	`LOG("Class Rework is enabled: " @ string(`SecondWaveEnabled('EnableClassRework')));

	// Check if the Resistance HQ soldier class deck needs to be trimmed
	foreach ResistanceHQ.SoldierClassDeck(ClassName)
	{
		if (IsDisabledClass(ClassName))
		{
			TrimRequired = true;

			break;
		}
	}

	if(TrimRequired)
	{
		ResistanceHQ = XComGameState_HeadquartersResistance(NewGameState.CreateStateObject(ResistanceHQ.Class, ResistanceHQ.ObjectID));
		NewGameState.AddStateObject(ResistanceHQ);
		UpdatedHQ = true;

		// Trim the Resistance HQ soldier class deck
		TrimResistanceHQSoldierClassDeck(ResistanceHQ);
		`LOG("Trimmed Resistance HQ class deck.");
	}

	// If the Resistance HQ soldier class deck is empty, re-build and trim it
	if (ResistanceHQ.SoldierClassDeck.Length == 0)
	{
		if (!UpdatedHQ)
		{
			ResistanceHQ = XComGameState_HeadquartersResistance(NewGameState.CreateStateObject(ResistanceHQ.Class, ResistanceHQ.ObjectID));
			NewGameState.AddStateObject(ResistanceHQ);
		}

		// Clear the soldier class deck so that it will contain only the rebuilt deck
		ResistanceHQ.SoldierClassDeck.Length = 0;

		// Rebuild the normal deck for the Resistance HQ
		ResistanceHQ.BuildSoldierClassDeck();

		`LOG("Rebuilt Resistance HQ class deck.");
	
		// Trim any disabled class names from the rebuilt deck
		TrimResistanceHQSoldierClassDeck(ResistanceHQ);
		`LOG("Trimmed Resistance HQ class deck.");
	}
	
	if (NewGameState.GetNumGameStateObjects() > 0)
		`GAMERULES.SubmitGameState(NewGameState);
	else
		`XCOMHISTORY.CleanupPendingGameState(NewGameState);
}

static function TrimResistanceHQSoldierClassDeck(XComGameState_HeadquartersResistance ResistanceHQ)
{
	local array<name> DisabledClassNames;
	local name ClassName;
	local int i;

	if(`SecondWaveEnabled('EnableClassRework'))
	{
		DisabledClassNames = default.LegacyClasses;
	}
	else
	{
		DisabledClassNames = default.ReworkClasses;
	}
	
	for (i = ResistanceHQ.SoldierClassDeck.Length - 1; i >= 0; i--)
	{
		ClassName = ResistanceHQ.SoldierClassDeck[i];
		if (DisabledClassNames.Find(ClassName) != INDEX_NONE)
		{
			ResistanceHQ.SoldierClassDeck.Remove(i, 1);

			`LOG("Removed class " @ ClassName @ " from Resistance HQ deck.");
		}
	}
}

static function bool IsDisabledClass(name ClassName)
{
	if(`SecondWaveEnabled('EnableClassRework'))
	{
		//Class rework is ENABLED, check whether the class in question is legacy
		if(default.LegacyClasses.Find(ClassName) != INDEX_NONE) 
		{
			return true;
		}
	}
	else
	{
		//Class rework is DISABLED, check whether the class in question is from the rework
		if(default.ReworkClasses.Find(ClassName) != INDEX_NONE) 
		{
			return true;
		}
	}
}

DefaultProperties
{
    ScreenClass = none;
}