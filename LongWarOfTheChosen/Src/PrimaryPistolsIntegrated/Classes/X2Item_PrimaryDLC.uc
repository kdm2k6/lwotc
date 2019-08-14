class X2Item_PrimaryDLC extends X2Item config(PrimaryPistols);

var config WeaponDamageValue HUNTERPISTOL_CONVENTIONAL_BASEDAMAGE;
var config WeaponDamageValue HUNTERPISTOL_MAGNETIC_BASEDAMAGE;
var config WeaponDamageValue HUNTERPISTOL_BEAM_BASEDAMAGE;
var config WeaponDamageValue CHOSENSNIPERPISTOL_XCOM_BASEDAMAGE;

var config int HUNTERPISTOL_CONVENTIONAL_AIM;
var config int HUNTERPISTOL_CONVENTIONAL_CRITCHANCE;
var config int HUNTERPISTOL_CONVENTIONAL_ICLIPSIZE;
var config int HUNTERPISTOL_CONVENTIONAL_ISOUNDRANGE;
var config int HUNTERPISTOL_CONVENTIONAL_IENVIRONMENTDAMAGE;
var config int HUNTERPISTOL_CONVENTIONAL_IPOINTS;

var config int HUNTERPISTOL_MAGNETIC_AIM;
var config int HUNTERPISTOL_MAGNETIC_CRITCHANCE;
var config int HUNTERPISTOL_MAGNETIC_ICLIPSIZE;
var config int HUNTERPISTOL_MAGNETIC_ISOUNDRANGE;
var config int HUNTERPISTOL_MAGNETIC_IENVIRONMENTDAMAGE;
var config int HUNTERPISTOL_MAGNETIC_IPOINTS;

var config int HUNTERPISTOL_BEAM_AIM;
var config int HUNTERPISTOL_BEAM_CRITCHANCE;
var config int HUNTERPISTOL_BEAM_ICLIPSIZE;
var config int HUNTERPISTOL_BEAM_ISOUNDRANGE;
var config int HUNTERPISTOL_BEAM_IENVIRONMENTDAMAGE;
var config int HUNTERPISTOL_BEAM_IPOINTS;

var config int CHOSENSNIPERPISTOL_XCOM_AIM;
var config int CHOSENSNIPERPISTOL_XCOM_CRITCHANCE;
var config int CHOSENSNIPERPISTOL_XCOM_ICLIPSIZE;
var config int CHOSENSNIPERPISTOL_XCOM_ISOUNDRANGE;
var config int CHOSENSNIPERPISTOL_XCOM_IENVIRONMENTDAMAGE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateTemplate_AlienHunterPistol_Conventional_Primary());
	Templates.AddItem(CreateTemplate_AlienHunterPistol_Magnetic_Primary());
	Templates.AddItem(CreateTemplate_AlienHunterPistol_Beam_Primary());
	Templates.AddItem(CreateTemplate_HunterPistol_CV_Primary_Schematic());
	Templates.AddItem(CreateTemplate_HunterPistol_MG_Primary_Schematic());
	Templates.AddItem(CreateTemplate_HunterPistol_BM_Primary_Schematic());
	Templates.AddItem(CreateTemplate_ChosenSniperPistol_XCOM());

	return Templates;
}

static function X2DataTemplate CreateTemplate_AlienHunterPistol_Conventional_Primary()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AlienHunterPistol_CV');
	Template.GameplayInstanceClass = class'XGWeaponPatched';
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'pistol';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///UILibrary_DLC2Images.ConvShadowKeeper";
	Template.EquipSound = "Secondary_Weapon_Equip_Conventional";
	Template.EquipNarrative = "DLC_60_NarrativeMoments.DLC2_S_Hunters_Pistol_Equipped";
	Template.Tier = 0;

	Template.RangeAccuracy = class'X2Item_PrimaryPistols'.default.MIDSHORT_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.HUNTERPISTOL_CONVENTIONAL_BASEDAMAGE;
	Template.Aim = default.HUNTERPISTOL_CONVENTIONAL_AIM;
	Template.CritChance = default.HUNTERPISTOL_CONVENTIONAL_CRITCHANCE;
	Template.iClipSize = default.HUNTERPISTOL_CONVENTIONAL_ICLIPSIZE;
	Template.iSoundRange = default.HUNTERPISTOL_CONVENTIONAL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.HUNTERPISTOL_CONVENTIONAL_IENVIRONMENTDAMAGE;

	Template.InfiniteAmmo = false;
	Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('PistolStandardShot');
	Template.Abilities.AddItem('PrimaryPistolsBonusCV');
	Template.Abilities.AddItem('PistolOverwatch');
	Template.Abilities.AddItem('PistolOverwatchShot');
	Template.Abilities.AddItem('PistolReturnFire');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('Quickdraw');
	Template.Abilities.AddItem('Gunslinger');
	Template.Abilities.AddItem('ReturnFire');
	Template.Abilities.AddItem('Shadowfall');

	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Item_PrimaryPistols'.default.PISTOL_CONVENTIONAL_MOVEMENT_BONUS);

	Template.SetAnimationNameForAbility('FanFire', 'FF_FireMultiShotConvA');
	Template.SetAnimationNameForAbility('HailofBullets', 'FF_FireMultiShotConvA');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "DLC_60_WP_HunterPistol_CV.WP_HunterPistol_CV";

	Template.iPhysicsImpulse = 5;

	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = false;

	Template.DamageTypeTemplateName = 'Projectile_Conventional';

	Template.bHideClipSizeStat = false;

	return Template;
}

static function X2DataTemplate CreateTemplate_AlienHunterPistol_Magnetic_Primary()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AlienHunterPistol_MG');
	Template.GameplayInstanceClass = class'XGWeaponPatched';
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'pistol';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_DLC2Images.MagShadowKeeper";
	Template.EquipSound = "Secondary_Weapon_Equip_Magnetic";
	Template.EquipNarrative = "DLC_60_NarrativeMoments.DLC2_S_Hunters_Pistol_Equipped";
	Template.Tier = 3;

	Template.RangeAccuracy = class'X2Item_PrimaryPistols'.default.MIDSHORT_MAGNETIC_RANGE;
	Template.BaseDamage = default.HUNTERPISTOL_MAGNETIC_BASEDAMAGE;
	Template.Aim = default.HUNTERPISTOL_MAGNETIC_AIM;
	Template.CritChance = default.HUNTERPISTOL_MAGNETIC_CRITCHANCE;
	Template.iClipSize = default.HUNTERPISTOL_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = default.HUNTERPISTOL_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.HUNTERPISTOL_MAGNETIC_IENVIRONMENTDAMAGE;

	Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
	Template.InfiniteAmmo = false;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('PistolStandardShot');
	Template.Abilities.AddItem('PrimaryPistolsBonusMG');
	Template.Abilities.AddItem('PistolOverwatch');
	Template.Abilities.AddItem('PistolOverwatchShot');
	Template.Abilities.AddItem('PistolReturnFire');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('Quickdraw');
	Template.Abilities.AddItem('Gunslinger');
	Template.Abilities.AddItem('ReturnFire');
	Template.Abilities.AddItem('Lightninghands');
	Template.Abilities.AddItem('ClutchShot');
	Template.Abilities.AddItem('Shadowfall');

	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Item_PrimaryPistols'.default.PISTOL_MAGNETIC_MOVEMENT_BONUS);

	Template.SetAnimationNameForAbility('FanFire', 'FF_FireMultiShotMagA');
	Template.SetAnimationNameForAbility('HailofBullets', 'FF_FireMultiShotConvA');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "DLC_60_WP_HunterPistol_MG.WP_HunterPistol_MG";

	Template.iPhysicsImpulse = 5;

	Template.CreatorTemplateName = 'HunterPistol_MG_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'AlienHunterPistol_CV'; // Which item this will be upgraded from

	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = false;

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';

	Template.bHideClipSizeStat = false;

	return Template;
}

static function X2DataTemplate CreateTemplate_AlienHunterPistol_Beam_Primary()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AlienHunterPistol_BM');
	Template.GameplayInstanceClass = class'XGWeaponPatched';
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'pistol';
	Template.WeaponTech = 'beam';
	Template.strImage = "img:///UILibrary_DLC2Images.BeamShadowKeeper";
	Template.EquipSound = "Secondary_Weapon_Equip_Beam";
	Template.EquipNarrative = "DLC_60_NarrativeMoments.DLC2_S_Hunters_Pistol_Equipped";
	Template.Tier = 5;

	Template.RangeAccuracy = class'X2Item_PrimaryPistols'.default.MIDSHORT_BEAM_RANGE;
	Template.BaseDamage = default.HUNTERPISTOL_BEAM_BASEDAMAGE;
	Template.Aim = default.HUNTERPISTOL_BEAM_AIM;
	Template.CritChance = default.HUNTERPISTOL_BEAM_CRITCHANCE;
	Template.iClipSize = default.HUNTERPISTOL_BEAM_ICLIPSIZE;
	Template.iSoundRange = default.HUNTERPISTOL_BEAM_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.HUNTERPISTOL_BEAM_IENVIRONMENTDAMAGE;

	Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
	Template.InfiniteAmmo = false;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('PistolStandardShot');
	Template.Abilities.AddItem('PrimaryPistolsBonusBM');
	Template.Abilities.AddItem('PistolOverwatch');
	Template.Abilities.AddItem('PistolOverwatchShot');
	Template.Abilities.AddItem('PistolReturnFire');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('Quickdraw');
	Template.Abilities.AddItem('Gunslinger');
	Template.Abilities.AddItem('ReturnFire');
	Template.Abilities.AddItem('Lightninghands');
	Template.Abilities.AddItem('ClutchShot');
	Template.Abilities.AddItem('Faceoff');
	Template.Abilities.AddItem('FanFire');
	Template.Abilities.AddItem('Shadowfall');

	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Item_PrimaryPistols'.default.PISTOL_BEAM_MOVEMENT_BONUS);

	Template.SetAnimationNameForAbility('FanFire', 'FF_FireMultiShotBeamA');
	Template.SetAnimationNameForAbility('HailofBullets', 'FF_FireMultiShotConvA');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "DLC_60_WP_HunterPistol_BM.WP_HunterPistol_BM";

	Template.iPhysicsImpulse = 5;

	Template.CreatorTemplateName = 'HunterPistol_BM_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'AlienHunterPistol_MG'; // Which item this will be upgraded from

	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = false;

	Template.DamageTypeTemplateName = 'Projectile_BeamXCom';

	Template.bHideClipSizeStat = false;

	return Template;
}

static function X2DataTemplate CreateTemplate_ChosenSniperPistol_XCOM()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'ChosenSniperPistol_XCOM');
	Template.GameplayInstanceClass = class'XGWeaponPatched';
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'pistol';
	Template.WeaponTech = 'beam';
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_Chosen_Pistol";
	Template.EquipSound = "Secondary_Weapon_Equip_Beam";
	Template.Tier = 6;

	Template.RangeAccuracy = class'X2Item_PrimaryPistols'.default.MIDSHORT_BEAM_RANGE;
	Template.BaseDamage = default.CHOSENSNIPERPISTOL_XCOM_BASEDAMAGE;
	Template.Aim = default.CHOSENSNIPERPISTOL_XCOM_AIM;
	Template.CritChance = default.CHOSENSNIPERPISTOL_XCOM_CRITCHANCE;
	Template.iClipSize = default.CHOSENSNIPERPISTOL_XCOM_ICLIPSIZE;
	Template.iSoundRange = default.CHOSENSNIPERPISTOL_XCOM_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.CHOSENSNIPERPISTOL_XCOM_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 0;

	Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
	Template.InfiniteAmmo = false;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('PistolOverwatch');
	Template.Abilities.AddItem('PistolOverwatchShot');
	Template.Abilities.AddItem('PrimaryPistolsBonusBM');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('Quickdraw');
	Template.Abilities.AddItem('Gunslinger');
	Template.Abilities.AddItem('ReturnFire');
	Template.Abilities.AddItem('Lightninghands');
	Template.Abilities.AddItem('ClutchShot');
	Template.Abilities.AddItem('Faceoff');
	Template.Abilities.AddItem('FanFire');
	Template.Abilities.AddItem('HotLoadAmmo');

	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Item_PrimaryPistols'.default.PISTOL_BEAM_MOVEMENT_BONUS);

	Template.SetAnimationNameForAbility('FanFire', 'FF_FireMultiShotMagA');
	Template.SetAnimationNameForAbility('HailofBullets', 'FF_FireMultiShotConvA');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_ChosenPistol.WP_ChosenPistol_XCOM";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = false;

	Template.DamageTypeTemplateName = 'Projectile_MagAdvent';

	Template.bHideClipSizeStat = true;
	
	Template.SetUIStatMarkup(class'XLocalizedData'.default.PierceLabel, eStat_ArmorPiercing, default.CHOSENSNIPERPISTOL_XCOM_BASEDAMAGE.Pierce);

	return Template;
}

static function X2DataTemplate CreateTemplate_HunterPistol_CV_Primary_Schematic()
{
	local X2SchematicTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'HunterPistol_CV_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = "img:///UILibrary_DLC2Images.ConvShadowKeeper";
	Template.PointsToComplete = 0;
	Template.Tier = 0;
	Template.OnBuiltFn = GiveItems;
	Template.bSquadUpgrade = false;

	// Items to Reward
	Template.ItemRewards.AddItem('AlienHunterPistol_CV_Primary');
	Template.ReferenceItemTemplate = 'AlienHunterPistol_CV_Primary';

	// Requirements
	Template.Requirements.SpecialRequirementsFn = IsAlienHuntersNarrativeDisabled;
	
	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 25;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateTemplate_HunterPistol_MG_Primary_Schematic()
{
	local X2SchematicTemplate Template;
	local StrategyRequirement AltReq;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'HunterPistol_MG_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = "img:///UILibrary_DLC2Images.MagShadowKeeper";
	Template.PointsToComplete = 0;
	Template.Tier = 1;
	Template.OnBuiltFn = UpgradeItems;
	Template.bSquadUpgrade = false;

	// Reference Item
	Template.ReferenceItemTemplate = 'AlienHunterPistol_MG';
	Template.HideIfPurchased = 'HunterPistol_BM_Schematic';

	// Narrative Requirements
	Template.Requirements.RequiredTechs.AddItem('MagnetizedWeapons');
	Template.Requirements.RequiredEquipment.AddItem('AlienHunterPistol_CV');
	Template.Requirements.RequiredEngineeringScore = 10;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	//Template.Requirements.SpecialRequirementsFn = IsAlienHuntersNarrativeContentComplete;

	// Non-Narrative Requirements
	AltReq.RequiredItems.AddItem('HunterPistol_CV_Schematic');
	AltReq.RequiredEquipment.AddItem('AlienHunterPistol_CV');
	AltReq.RequiredTechs.AddItem('MagnetizedWeapons');
	AltReq.RequiredEngineeringScore = 10;
	AltReq.bVisibleIfPersonnelGatesNotMet = true;
	Template.AlternateRequirements.AddItem(AltReq);

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 45;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateTemplate_HunterPistol_BM_Primary_Schematic()
{
	local X2SchematicTemplate Template;
	local StrategyRequirement AltReq;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'HunterPistol_BM_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = "img:///UILibrary_DLC2Images.BeamShadowKeeper";
	Template.PointsToComplete = 0;
	Template.Tier = 3;
	Template.OnBuiltFn = UpgradeItems;
	Template.bSquadUpgrade = false;

	// Reference Item
	Template.ReferenceItemTemplate = 'AlienHunterPistol_BM_Primary';

	// Narrative Requirements
	Template.Requirements.RequiredTechs.AddItem('PlasmaRifle');
	Template.Requirements.RequiredEquipment.AddItem('AlienHunterPistol_CV');
	Template.Requirements.RequiredEquipment.AddItem('AlienHunterPistol_MG');
	Template.Requirements.bDontRequireAllEquipment = true;
	Template.Requirements.RequiredEngineeringScore = 20;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
//	Template.Requirements.SpecialRequirementsFn = IsAlienHuntersNarrativeContentComplete;

	// Non-Narrative Requirements
	AltReq.RequiredItems.AddItem('HunterPistol_CV_Schematic');
	AltReq.RequiredEquipment.AddItem('AlienHunterPistol_CV');
	AltReq.RequiredEquipment.AddItem('AlienHunterPistol_MG');
	AltReq.bDontRequireAllEquipment = true;
	AltReq.RequiredTechs.AddItem('PlasmaRifle');
	AltReq.RequiredEngineeringScore = 20;
	AltReq.bVisibleIfPersonnelGatesNotMet = true;
	Template.AlternateRequirements.AddItem(AltReq);

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 100;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 10;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

// **************************************************************************
// ***                       Delegate Functions                           ***
// **************************************************************************
function bool IsAlienHuntersNarrativeEnabled()
{
	local XComGameStateHistory History;
	local XComGameState_CampaignSettings CampaignSettings;

	History = class'XComGameStateHistory'.static.GetGameStateHistory();
	CampaignSettings = XComGameState_CampaignSettings(History.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings'));

	// Return true if the Narrative content is enabled
	if (CampaignSettings != none)
	    return CampaignSettings.HasOptionalNarrativeDLCEnabled('DLC_2');
	return false;
}

function bool IsAlienHuntersNarrativeDisabled()
{
	return !IsAlienHuntersNarrativeEnabled();
}

// Only returns true if narrative content is enabled AND completed
function bool IsAlienHuntersNarrativeContentComplete()
{
	if (IsAlienHuntersNarrativeEnabled())
	{
		if (class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('DLC_HunterWeapons') &&
		class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('DLC_AlienNestMissionComplete'))
		{
			return true;
		}
	}

	return false;
}

function GiveItems(XComGameState NewGameState, XComGameState_Item ItemState)
{
	local X2ItemTemplateManager ItemTemplateManager;
	local X2SchematicTemplate SchematicTemplate;
	local X2ItemTemplate ItemTemplate;
	local name ItemName;

	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	SchematicTemplate = X2SchematicTemplate(ItemState.GetMyTemplate());

	foreach SchematicTemplate.ItemRewards(ItemName)
	{
		ItemTemplate = ItemTemplateManager.FindItemTemplate(ItemName);
		class'XComGameState_HeadquartersXCom'.static.GiveItem(NewGameState, ItemTemplate);
	}
}

static function UpgradeItems(XComGameState NewGameState, XComGameState_Item ItemState)
{
	class'XComGameState_HeadquartersXCom'.static.UpgradeItems(NewGameState, ItemState.GetMyTemplateName());
}