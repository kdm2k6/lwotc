class X2StrategyElement_WOTC_PistolSlot extends CHItemSlotSet config (PistolSlot);

var localized string strPistolFirstLetter;
var config bool ABILITY_EXCLUDES_SLOT;
var config array<name> AbilityInteractsWithPistolSlot;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	Templates.AddItem(CreatePistolSlotTemplate());
	return Templates;
}

static function X2DataTemplate CreatePistolSlotTemplate()
{
	local CHItemSlot Template;

	`CREATE_X2TEMPLATE(class'CHItemSlot', Template, 'PistolSlot');

	Template.InvSlot = eInvSlot_Pistol;
	Template.SlotCatMask = Template.SLOT_WEAPON | Template.SLOT_ITEM;
	// Unused for now
	Template.IsUserEquipSlot = true;
	// Uses unique rule
	Template.IsEquippedSlot = false;
	// Does not bypass unique rule
	Template.BypassesUniqueRule = false;
	Template.IsMultiItemSlot = false;
	Template.IsSmallSlot = false;
	Template.NeedsPresEquip = true;
	Template.ShowOnCinematicPawns = true;

	Template.CanAddItemToSlotFn = CanAddItemToPistolSlot;
	Template.UnitHasSlotFn = HasPistolSlot;
	Template.GetPriorityFn = PistolGetPriority;
	Template.ShowItemInLockerListFn = ShowPistolItemInLockerList;
	Template.ValidateLoadoutFn = VestValidateLoadout;
	Template.GetSlotUnequipBehaviorFn = PistolGetUnequipBehavior;

	return Template;
}

static function bool CanAddItemToPistolSlot(CHItemSlot Slot, XComGameState_Unit Unit, X2ItemTemplate Template, optional XComGameState CheckGameState, optional int Quantity = 1, optional XComGameState_Item ItemState)
{
     local X2WeaponTemplate WeaponTemplate;
     local string strDummy;
     
     
   `LOG("Trying to equip " @ Template.DataName @ " on: " @ Unit.GetFullName(),, 'PISTOL_SLOT');
   
    if (!Slot.UnitHasSlot(Unit, strDummy, CheckGameState) || Unit.GetItemInSlot(Slot.InvSlot, CheckGameState) != none)
    {
        return false;
    }

    WeaponTemplate = X2WeaponTemplate(Template);

    if(WeaponTemplate != none)
    {
		return (class'X2DownloadableContentInfo_WOTC_PistolSlot'.default.PistolCategories.Find(WeaponTemplate.WeaponCat) != INDEX_NONE);
    }
    
    return false;
}


static function bool HasPistolSlot(CHItemSlot Slot, XComGameState_Unit UnitState, out string LockedReason, optional XComGameState CheckGameState)
{
	local name Ability;

	if (default.AbilityInteractsWithPistolSlot.Length == 0)
	{
		return UnitState.IsSoldier() && !UnitState.IsRobotic();
	}

	foreach default.AbilityInteractsWithPistolSlot(Ability)
	{
		if (UnitState.HasSoldierAbility(Ability, true))
		{
			if (default.ABILITY_EXCLUDES_SLOT == true)
			{
				return false;
			}
			if (default.ABILITY_EXCLUDES_SLOT == false)
			{
				return true;
			}
		}
	}
	return true;
}

static function int PistolGetPriority(CHItemSlot Slot, XComGameState_Unit UnitState, optional XComGameState CheckGameState)
{
	return 45; // Ammo Pocket is 110 
}

static function bool ShowPistolItemInLockerList(CHItemSlot Slot, XComGameState_Unit Unit, XComGameState_Item ItemState, X2ItemTemplate ItemTemplate, XComGameState CheckGameState)
{
    local X2WeaponTemplate WeaponTemplate;
    WeaponTemplate = X2WeaponTemplate(ItemTemplate);
    if(WeaponTemplate != none)
    {
		if(WeaponTemplate.InventorySlot == eInvSlot_SecondaryWeapon)
		  {
			return (class'X2DownloadableContentInfo_WOTC_PistolSlot'.default.PistolCategories.Find(WeaponTemplate.WeaponCat) != INDEX_NONE);
		  }
		return false;
	  }
}

static function string GetPistolDisplayLetter(CHItemSlot Slot)
{
	return default.strPistolFirstLetter;
}

static function VestValidateLoadout(CHItemSlot Slot, XComGameState_Unit Unit, XComGameState_HeadquartersXCom XComHQ, XComGameState NewGameState)
{
	local XComGameState_Item EquippedVest;
	local string strDummy;
	local bool HasSlot;
	EquippedVest = Unit.GetItemInSlot(Slot.InvSlot, NewGameState);
	HasSlot = Slot.UnitHasSlot(Unit, strDummy, NewGameState);
	
	if(EquippedVest == none && HasSlot)
	{
		//EquippedSecondaryWeapon = GetBestSecondaryWeapon(NewGameState);
		//AddItemToInventory(EquippedSecondaryWeapon, eInvSlot_SecondaryWeapon, NewGameState);
	}
	else if(EquippedVest != none && !HasSlot)
	{
		EquippedVest = XComGameState_Item(NewGameState.ModifyStateObject(class'XComGameState_Item', EquippedVest.ObjectID));
		Unit.RemoveItemFromInventory(EquippedVest, NewGameState);
		XComHQ.PutItemInInventory(NewGameState, EquippedVest);
		EquippedVest = none;
	}
}

function ECHSlotUnequipBehavior PistolGetUnequipBehavior(CHItemSlot Slot, ECHSlotUnequipBehavior DefaultBehavior, XComGameState_Unit Unit, XComGameState_Item ItemState, optional XComGameState CheckGameState)
{
	return eCHSUB_AllowEmpty;
}
