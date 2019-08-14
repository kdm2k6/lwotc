class X2DownloadableContentInfo_PrimaryPistols extends X2DownloadableContentInfo config (PrimaryPistols);


struct AmmoCost
{
	var name Ability;
	var int Ammo;
};

struct WeaponAttachment {
	var string Type;
	var name AttachSocket;
	var name UIArmoryCameraPointTag;
	var string MeshName;
	var string ProjectileName;
	var name MatchWeaponTemplate;
	var bool AttachToPawn;
	var string IconName;
	var string InventoryIconName;
	var string InventoryCategoryIcon;
	var name AttachmentFn;
};

var config array<AmmoCost> AmmoCosts;
var config array<WeaponAttachment> PistolAttachements;

static function bool IsLW2Installed()
{
	return IsModInstalled('X2DownloadableContentInfo_LW_Overhaul');
}

static function bool IsModInstalled(name X2DCLName)
{
	local X2DownloadableContentInfo Mod;
	foreach `ONLINEEVENTMGR.m_cachedDLCInfos (Mod)
	{
		if (Mod.Class.Name == X2DCLName)
		{
			`Log("Mod installed:" @ Mod.Class);
			return true;
		}
	}

	return false;
}

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{
	AddStartingItems();
	class'XComGameStateSingleton_ListenerManager'.static.EnsurePresenceOfSingleton();
}

/// <summary>
/// This method is run when the player loads a saved game directly into Strategy while this DLC is installed
/// </summary>
static event OnLoadedSavedGameToStrategy()
{
	AddStartingItems();
	class'XComGameStateSingleton_ListenerManager'.static.EnsurePresenceOfSingleton();
}

static function AddStartingItems()
{
	local array<name> TemplateNames;
	TemplateNames.AddItem('Pistol_CV_Primary');
	UpdateStorage(TemplateNames);
}

static function UpdateStorage(array<name> TemplateNames)
{
	local XComGameState NewGameState;
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local X2ItemTemplateManager ItemTemplateMgr;
	local array<X2DataTemplate> ItemTemplates;
	local X2DataTemplate ItemTemplate;
	local name TemplateName;
	local XComGameState_Item NewItemState;

	History = `XCOMHISTORY;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(" Updating HQ Storage to add primary pistol variants");
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	NewGameState.AddStateObject(XComHQ);
	ItemTemplateMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();


	foreach TemplateNames(TemplateName)
	{
		ItemTemplateMgr.FindDataTemplateAllDifficulties(TemplateName, ItemTemplates);
		foreach ItemTemplates(ItemTemplate)
		{
			if(ItemTemplate != none && !XComHQ.HasItem(X2ItemTemplate(ItemTemplate)))
			{
				`Log("Adding primary version" @ ItemTemplate.DataName @ "to inventory",, 'PrimaryPistols');
				NewItemState = X2ItemTemplate(ItemTemplate).CreateInstanceFromTemplate(NewGameState);
				NewGameState.AddStateObject(NewItemState);
				XComHQ.AddItemToHQInventory(NewItemState);
			}
		}
	}

	ItemTemplate = ItemTemplateMgr.FindItemTemplate('AlienHunterPistol_CV');
	if (XComHQ.HasItem(X2ItemTemplate(ItemTemplate)))
	{
		ItemTemplate = ItemTemplateMgr.FindItemTemplate('AlienHunterPistol_CV_Primary');
		if (!XComHQ.HasItem(X2ItemTemplate(ItemTemplate)))
		{
			NewItemState = X2ItemTemplate(ItemTemplate).CreateInstanceFromTemplate(NewGameState);
			NewGameState.AddStateObject(NewItemState);
			XComHQ.AddItemToHQInventory(NewItemState);
		}
	}

	History.AddGameStateToHistory(NewGameState);
	History.CleanupPendingGameState(NewGameState);
}


static function AddAttachments()
{
	local array<name> AttachmentTypes;
	local name AttachmentType;
	
	AttachmentTypes.AddItem('CritUpgrade_Bsc');
	AttachmentTypes.AddItem('CritUpgrade_Adv');
	AttachmentTypes.AddItem('CritUpgrade_Sup');
	AttachmentTypes.AddItem('AimUpgrade_Bsc');
	AttachmentTypes.AddItem('AimUpgrade_Adv');
	AttachmentTypes.AddItem('AimUpgrade_Sup');
	AttachmentTypes.AddItem('ClipSizeUpgrade_Bsc');
	AttachmentTypes.AddItem('ClipSizeUpgrade_Adv');
	AttachmentTypes.AddItem('ClipSizeUpgrade_Sup');
	AttachmentTypes.AddItem('FreeFireUpgrade_Bsc');
	AttachmentTypes.AddItem('FreeFireUpgrade_Adv');
	AttachmentTypes.AddItem('FreeFireUpgrade_Sup');
	AttachmentTypes.AddItem('ReloadUpgrade_Bsc');
	AttachmentTypes.AddItem('ReloadUpgrade_Adv');
	AttachmentTypes.AddItem('ReloadUpgrade_Sup');
	AttachmentTypes.AddItem('MissDamageUpgrade_Bsc');
	AttachmentTypes.AddItem('MissDamageUpgrade_Adv');
	AttachmentTypes.AddItem('MissDamageUpgrade_Sup');
	AttachmentTypes.AddItem('FreeKillUpgrade_Bsc');
	AttachmentTypes.AddItem('FreeKillUpgrade_Adv');
	AttachmentTypes.AddItem('FreeKillUpgrade_Sup');

	foreach AttachmentTypes(AttachmentType)
	{
		AddAttachment(AttachmentType, default.PistolAttachements);
	}
}


static function AddAttachment(name TemplateName, array<WeaponAttachment> Attachments) 
{
	local X2ItemTemplateManager ItemTemplateManager;
	local X2WeaponUpgradeTemplate Template;
	local WeaponAttachment Attachment;
	local delegate<X2TacticalGameRulesetDataStructures.CheckUpgradeStatus> CheckFN;
	
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	Template = X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate(TemplateName));
	
	foreach Attachments(Attachment)
	{
		if (InStr(string(TemplateName), Attachment.Type) != INDEX_NONE)
		{
			switch(Attachment.AttachmentFn) 
			{
				case ('NoReloadUpgradePresent'): 
					CheckFN = class'X2Item_DefaultUpgrades'.static.NoReloadUpgradePresent; 
					break;
				case ('ReloadUpgradePresent'): 
					CheckFN = class'X2Item_DefaultUpgrades'.static.ReloadUpgradePresent; 
					break;
				case ('NoClipSizeUpgradePresent'): 
					CheckFN = class'X2Item_DefaultUpgrades'.static.NoClipSizeUpgradePresent; 
					break;
				case ('ClipSizeUpgradePresent'): 
					CheckFN = class'X2Item_DefaultUpgrades'.static.ClipSizeUpgradePresent; 
					break;
				case ('NoFreeFireUpgradePresent'): 
					CheckFN = class'X2Item_DefaultUpgrades'.static.NoFreeFireUpgradePresent; 
					break;
				case ('FreeFireUpgradePresent'): 
					CheckFN = class'X2Item_DefaultUpgrades'.static.FreeFireUpgradePresent; 
					break;
				default:
					CheckFN = none;
					break;
			}
			Template.AddUpgradeAttachment(Attachment.AttachSocket, Attachment.UIArmoryCameraPointTag, Attachment.MeshName, Attachment.ProjectileName, Attachment.MatchWeaponTemplate, Attachment.AttachToPawn, Attachment.IconName, Attachment.InventoryIconName, Attachment.InventoryCategoryIcon, CheckFN);
			//`LOG("Attachment for "@TemplateName @Attachment.AttachSocket @Attachment.UIArmoryCameraPointTag @Attachment.MeshName @Attachment.ProjectileName @Attachment.MatchWeaponTemplate @Attachment.AttachToPawn @Attachment.IconName @Attachment.InventoryIconName @Attachment.InventoryCategoryIcon,, 'PrimaryPistols');
		}
	}
}
/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed. When a new campaign is started the initial state of the world
/// is contained in a strategy start state. Never add additional history frames inside of InstallNewCampaign, add new state objects to the start state
/// or directly modify start state objects
/// </summary>
static event InstallNewCampaign(XComGameState StartState)
{
	//class'XComGameStateSingleton_ListenerManager'.static.EnsurePresenceOfSingleton(StartState);
}

/// <summary>
/// Called just before the player launches into a tactical a mission while this DLC / Mod is installed.
/// Allows dlcs/mods to modify the start state before launching into the mission
/// </summary>
static event OnPreMission(XComGameState StartGameState, XComGameState_MissionSite MissionState)
{

}

/// <summary>
/// Called when the player completes a mission while this DLC / Mod is installed.
/// </summary>
static event OnPostMission()
{

}

/// <summary>
/// Called when the player is doing a direct tactical->tactical mission transfer. Allows mods to modify the
/// start state of the new transfer mission if needed
/// </summary>
static event ModifyTacticalTransferStartState(XComGameState TransferStartState)
{

}

/// <summary>
/// Called after the player exits the post-mission sequence while this DLC / Mod is installed.
/// </summary>
static event OnExitPostMissionSequence()
{

}

/// <summary>
/// Called after the Templates have been created (but before they are validated) while this DLC / Mod is installed.
/// </summary>
static event OnPostTemplatesCreated()
{
	PatchAbilityTemplates();
	AddAttachments();
}

static function PatchAbilityTemplates()
{
	local X2AbilityTemplateManager						TemplateManager;
	local X2AbilityTemplate								Template;
	local X2AbilityCost_Ammo							NewAmmoCosts;
	local X2AbilityCost									CurrentAbilityCosts;
	local AmmoCost										AbilityAmmoCost;
	local bool											bHasAmmoCost;
	local array<name>									TemplateNames;
	local name											TemplateName;
	local array<X2AbilityTemplate>						AbilityTemplates;
	//local X2AbilityCost_QuickdrawActionPointsPatched	ActionPointCost;
	//local X2AbilityCost_ActionPoints					OldActionPointCost;
	//local int											OldActionPoint;
	
	TemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	foreach default.AmmoCosts(AbilityAmmoCost)
	{
		TemplateManager.FindAbilityTemplateAllDifficulties(AbilityAmmoCost.Ability, AbilityTemplates);
		foreach AbilityTemplates(Template)
		{
			if (Template != none)
			{
				bHasAmmoCost = false;
				foreach Template.AbilityCosts(CurrentAbilityCosts)
				{
					if (X2AbilityCost_Ammo(CurrentAbilityCosts) != none)
					{
						X2AbilityCost_Ammo(CurrentAbilityCosts).iAmmo =  AbilityAmmoCost.Ammo;
						bHasAmmoCost = true;
						break;
					}
				}
				if (!bHasAmmoCost)
				{
					NewAmmoCosts = new class'X2AbilityCost_Ammo';
					NewAmmoCosts.iAmmo = AbilityAmmoCost.Ammo;
					Template.AbilityCosts.AddItem(NewAmmoCosts);
				}
				`LOG("Patching Template" @ AbilityAmmoCost.Ability @ "adding" @ AbilityAmmoCost.Ammo @ "ammo cost",, 'PrimaryPistols');
			}
		}
	}

	//TemplateNames.AddItem('PistolStandardShot');
	//
	//foreach TemplateNames(TemplateName)
	//{
	//	Template = TemplateManager.FindAbilityTemplate(TemplateName);
	//	if (Template != none)
	//	{
	//		OldActionPointCost = X2AbilityCost_ActionPoints(Template.AbilityCosts[0]);
	//		if (OldActionPointCost != none)
	//		{
	//			`LOG("Patching Template" @ TemplateName @ "with X2AbilityCost_QuickdrawActionPointsPatched",, 'PrimaryPistols');
	//			OldActionPoint = OldActionPointCost.iNumPoints;
	//
	//			ActionPointCost = new class'X2AbilityCost_QuickdrawActionPointsPatched';
	//			ActionPointCost.iNumPoints = OldActionPoint;
	//			Template.AbilityCosts.length = 0;
	//			Template.AbilityCosts.AddItem(ActionPointCost);
	//		}
	//	}
	//}
}


/// <summary>
/// Called when the difficulty changes and this DLC is active
/// </summary>
static event OnDifficultyChanged()
{

}


/// <summary>
/// Called when viewing mission blades with the Shadow Chamber panel, used primarily to modify tactical tags for spawning
/// Returns true when the mission's spawning info needs to be updated
/// </summary>
static function bool UpdateShadowChamberMissionInfo(StateObjectReference MissionRef)
{
	return false;
}

/// <summary>
/// Called from X2AbilityTag:ExpandHandler after processing the base game tags. Return true (and fill OutString correctly)
/// to indicate the tag has been expanded properly and no further processing is needed.
/// </summary>
static function bool AbilityTagExpandHandler(string InString, out string OutString)
{
	return false;
}
/// <summary>
/// Called from XComGameState_Unit:GatherUnitAbilitiesForInit after the game has built what it believes is the full list of
/// abilities for the unit based on character, class, equipment, et cetera. You can add or remove abilities in SetupData.
/// </summary>
static function FinalizeUnitAbilitiesForInit(XComGameState_Unit UnitState, out array<AbilitySetupData> SetupData, optional XComGameState StartState, optional XComGameState_Player PlayerState, optional bool bMultiplayerDisplay)
{

}

