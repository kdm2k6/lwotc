//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_WotC_VestSlot.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_WOTC_PistolSlot extends X2DownloadableContentInfo config (PistolSlot);

var config array<name> PistolCategories;

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{}

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed
/// </summary>
static event InstallNewCampaign(XComGameState StartState)
{}

static function bool CanAddItemToInventory_CH_Improved(out int bCanAddItem, const EInventorySlot Slot, const X2ItemTemplate ItemTemplate, int Quantity, XComGameState_Unit UnitState, optional XComGameState CheckGameState, optional out string DisabledReason, optional XComGameState_Item ItemState)
{
    local X2WeaponTemplate WeaponTemplate;

    WeaponTemplate = X2WeaponTemplate(ItemTemplate);

    if (WeaponTemplate != none)
    {
        if (Slot == eInvSlot_Pistol && TriggerIsItemValidForPistolSlot(WeaponTemplate))
        {
            DisabledReason = "";
            return false;
        }
    }
    return CanAddItemToInventory_CH(bCanAddItem, Slot, ItemTemplate, Quantity, UnitState, CheckGameState, DisabledReason);
}

// Fires an 'IsItemValidForPistolSlot' event that allows listeners to override
// the default behavior for whether a weapon is valid for the pistol slot or not.
//
// The default behavior is specified in the event's tuple as the 'IsItemValid'
// boolean before the first listener receives the event. To override the defaul
// value, listeners just need to change the value of that element in the tuple.
//
// The event takes the form:
//
//  {
//     ID: IsItemValidForPistolSlot,
//     Data: [inout bool IsItemValid],
//     Source: WeaponTemplate (X2WeaponTemplate)
//  }
//
static function bool TriggerIsItemValidForPistolSlot(X2WeaponTemplate WeaponTemplate)
{
	local XComLWTuple OverrideTuple;

	OverrideTuple = new class'XComLWTuple';
	OverrideTuple.Id = 'IsItemValidForPistolSlot';
    OverrideTuple.Data.Add(1);
    
    // Default to 'true' if the weapon's category is in the PistolCategories array
	OverrideTuple.Data[0].Kind = XComLWTVBool;
	OverrideTuple.Data[0].b = default.PistolCategories.Find(WeaponTemplate.WeaponCat) != INDEX_NONE;

	`XEVENTMGR.TriggerEvent(OverrideTuple.Id, OverrideTuple, WeaponTemplate);

	return OverrideTuple.Data[0].b;
}

static event OnPostTemplatesCreated()
{
    local X2ItemTemplateManager        ItemMgr;
    local X2WeaponTemplate            Template;
    local array<X2WeaponTemplate>    Templates; 

	class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate('PistolStandardShot').bUniqueSource = true;

    ItemMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
        
    Templates = ItemMgr.GetAllWeaponTemplates();
    
    foreach Templates(Template)
    {        
        if (Template.WeaponCat == 'pistol')
        {
            Template.Abilities.AddItem('PistolStandardShot');
        }
    }
	X2AbilityCost_QuickdrawActionPoints(class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate('PistolStandardShot').AbilityCosts[1]).DoNotConsumeAllSoldierAbilities.AddItem('Quickdraw');
}