class X2Item_PrimaryPistols extends X2Item config(PrimaryPistols);

var config WeaponDamageValue PISTOL_CONVENTIONAL_BASEDAMAGE;
var config WeaponDamageValue PISTOL_LASER_BASEDAMAGE;
var config WeaponDamageValue PISTOL_MAGNETIC_BASEDAMAGE;
var config WeaponDamageValue PISTOL_COIL_BASEDAMAGE;
var config WeaponDamageValue PISTOL_BEAM_BASEDAMAGE;


var config int PISTOL_CONVENTIONAL_AIM;
var config int PISTOL_CONVENTIONAL_CRITCHANCE;
var config int PISTOL_CONVENTIONAL_ICLIPSIZE;
var config int PISTOL_CONVENTIONAL_ISOUNDRANGE;
var config int PISTOL_CONVENTIONAL_IENVIRONMENTDAMAGE;

var config int PISTOL_MAGNETIC_AIM;
var config int PISTOL_MAGNETIC_CRITCHANCE;
var config int PISTOL_MAGNETIC_ICLIPSIZE;
var config int PISTOL_MAGNETIC_ISOUNDRANGE;
var config int PISTOL_MAGNETIC_IENVIRONMENTDAMAGE;

var config int PISTOL_LASER_AIM;
var config int PISTOL_LASER_CRITCHANCE;
var config int PISTOL_LASER_ICLIPSIZE;
var config int PISTOL_LASER_ISOUNDRANGE;
var config int PISTOL_LASER_IENVIRONMENTDAMAGE;

var config int PISTOL_COIL_AIM;
var config int PISTOL_COIL_CRITCHANCE;
var config int PISTOL_COIL_ICLIPSIZE;
var config int PISTOL_COIL_ISOUNDRANGE;
var config int PISTOL_COIL_IENVIRONMENTDAMAGE;

var config int PISTOL_BEAM_AIM;
var config int PISTOL_BEAM_CRITCHANCE;
var config int PISTOL_BEAM_ICLIPSIZE;
var config int PISTOL_BEAM_ISOUNDRANGE;
var config int PISTOL_BEAM_IENVIRONMENTDAMAGE;

var config int PISTOL_CONVENTIONAL_MOVEMENT_BONUS;	
var config int PISTOL_LASER_MOVEMENT_BONUS;		
var config int PISTOL_MAGNETIC_MOVEMENT_BONUS;	
var config int PISTOL_COIL_MOVEMENT_BONUS;	
var config int PISTOL_BEAM_MOVEMENT_BONUS;

var config int PISTOL_CONVENTIONAL_UPGRADE_SLOTS;	
var config int PISTOL_LASER_UPGRADE_SLOTS;		
var config int PISTOL_MAGNETIC_UPGRADE_SLOTS;	
var config int PISTOL_COIL_UPGRADE_SLOTS;	
var config int PISTOL_BEAM_UPGRADE_SLOTS;

var config float PISTOL_CONVENTIONAL_DETECTIONRADIUS_MODIFER;
var config float PISTOL_LASER_DETECTIONRADIUS_MODIFER;
var config float PISTOL_MAGNETIC_DETECTIONRADIUS_MODIFER;
var config float PISTOL_COIL_DETECTIONRADIUS_MODIFER;
var config float PISTOL_BEAM_DETECTIONRADIUS_MODIFER;

var config array<int> MIDSHORT_CONVENTIONAL_RANGE;
var config array<int> MIDSHORT_LASER_RANGE;
var config array<int> MIDSHORT_MAGNETIC_RANGE;
var config array<int> MIDSHORT_COIL_RANGE;
var config array<int> MIDSHORT_BEAM_RANGE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Weapons;

	Weapons.AddItem(CreateTemplate_Pistol_Conventional());
	Weapons.AddItem(CreateTemplate_Pistol_Laser());
	Weapons.AddItem(CreateTemplate_Pistol_Magnetic());
	Weapons.AddItem(CreateTemplate_Pistol_Coil());
	Weapons.AddItem(CreateTemplate_Pistol_Beam());

	return Weapons;
}

// **************************************************************************
// ***                          Pistol                                    ***
// **************************************************************************
static function X2DataTemplate CreateTemplate_Pistol_Conventional()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Pistol_CV_Primary');
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'pistol';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///PrimaryPistolsMod.UI.ConvPistol_Base";
	Template.EquipSound = "Secondary_Weapon_Equip_Conventional";
	Template.Tier = 0;

	Template.RangeAccuracy = default.MIDSHORT_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.PISTOL_CONVENTIONAL_BASEDAMAGE;
	Template.Aim = default.PISTOL_CONVENTIONAL_AIM;
	Template.CritChance = default.PISTOL_CONVENTIONAL_CRITCHANCE;
	Template.iClipSize = default.PISTOL_CONVENTIONAL_ICLIPSIZE;
	Template.iSoundRange = default.PISTOL_CONVENTIONAL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.PISTOL_CONVENTIONAL_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = default.PISTOL_CONVENTIONAL_UPGRADE_SLOTS;

	Template.InfiniteAmmo = false;
	Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.StowedLocation = eSlot_RearBackPack;
	Template.Abilities.AddItem('PistolStandardShot');
	Template.Abilities.AddItem('PistolOverwatch');
	Template.Abilities.AddItem('PistolOverwatchShot');
	Template.Abilities.AddItem('PistolReturnFire');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('PrimaryPistolsBonusCV');
	Template.Abilities.AddItem('Quickdraw');
	Template.Abilities.AddItem('Gunslinger');
	Template.Abilities.AddItem('ReturnFire');
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, default.PISTOL_CONVENTIONAL_MOVEMENT_BONUS);

	Template.SetAnimationNameForAbility('FanFire', 'FF_FireMultiShotConvA');
	Template.SetAnimationNameForAbility('HailofBullets', 'FF_FireMultiShotConvA');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "PrimaryPistolsMod.Archetype.WP_Pistol_CV";

	Template.iPhysicsImpulse = 5;
	
	Template.StartingItem = true;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Projectile_Conventional';

	Template.bHideClipSizeStat = false;

	return Template;
}

static function X2DataTemplate CreateTemplate_Pistol_Laser()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Pistol_LS_Primary');
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'pistol';
	Template.WeaponTech = 'pulse';
	Template.strImage = "img:///UILibrary_LW_LaserPack.Inv_Laser_Pistol";
	Template.EquipSound = "Secondary_Weapon_Equip_Magnetic";
	Template.Tier = 2;

	Template.RangeAccuracy = default.MIDSHORT_LASER_RANGE;
	Template.BaseDamage = default.PISTOL_LASER_BASEDAMAGE;
	Template.Aim = default.PISTOL_LASER_AIM;
	Template.CritChance = default.PISTOL_LASER_CRITCHANCE;
	Template.iClipSize = default.PISTOL_LASER_ICLIPSIZE;
	Template.iSoundRange = default.PISTOL_LASER_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.PISTOL_LASER_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = default.PISTOL_LASER_UPGRADE_SLOTS;

	Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
	Template.InfiniteAmmo = false;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.StowedLocation = eSlot_RearBackPack;
	Template.Abilities.AddiTem('PistolStandardShot');
	Template.Abilities.AddItem('PistolOverwatch');
	Template.Abilities.AddItem('PistolOverwatchShot');
	Template.Abilities.AddItem('PistolReturnFire');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('PrimaryPistolsBonusLS');
	Template.Abilities.AddItem('Quickdraw');
	Template.Abilities.AddItem('Gunslinger');
	Template.Abilities.AddItem('ReturnFire');
	Template.Abilities.AddItem('Lightninghands');
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, default.PISTOL_LASER_MOVEMENT_BONUS);

	Template.SetAnimationNameForAbility('FanFire', 'FF_FireMultiShotMagA');
	Template.SetAnimationNameForAbility('HailofBullets', 'FF_FireMultiShotConvA');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "PrimaryPistolsMod.Archetype.WP_Pistol_LS";

	Template.iPhysicsImpulse = 5;

	Template.CreatorTemplateName = 'Pistol_LS_Primary_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'Pistol_MG_Primary'; // Which item this will be upgraded from

	Template.CanBeBuilt = true;
	Template.bInfiniteItem = false;

	Template.DamageTypeTemplateName = 'Projectile_BeamXCom';  

	Template.bHideClipSizeStat = false;

	return Template;
}

static function X2DataTemplate CreateTemplate_Pistol_Magnetic()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Pistol_MG_Primary');
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'pistol';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///PrimaryPistolsMod.UI.MagPistol_Base";
	Template.EquipSound = "Secondary_Weapon_Equip_Magnetic";
	Template.Tier = 3;

	Template.RangeAccuracy = default.MIDSHORT_MAGNETIC_RANGE;
	Template.BaseDamage = default.PISTOL_MAGNETIC_BASEDAMAGE;
	Template.Aim = default.PISTOL_MAGNETIC_AIM;
	Template.CritChance = default.PISTOL_MAGNETIC_CRITCHANCE;
	Template.iClipSize = default.PISTOL_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = default.PISTOL_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.PISTOL_MAGNETIC_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = default.PISTOL_MAGNETIC_UPGRADE_SLOTS;

	Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
	Template.InfiniteAmmo = false;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.StowedLocation = eSlot_RearBackPack;
	Template.Abilities.AddiTem('PistolStandardShot');
	Template.Abilities.AddItem('PistolOverwatch');
	Template.Abilities.AddItem('PistolOverwatchShot');
	Template.Abilities.AddItem('PistolReturnFire');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('PrimaryPistolsBonusMG');
	Template.Abilities.AddItem('Quickdraw');
	Template.Abilities.AddItem('Gunslinger');
	Template.Abilities.AddItem('ReturnFire');
	Template.Abilities.AddItem('Lightninghands');
	Template.Abilities.AddItem('ClutchShot');
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, default.PISTOL_MAGNETIC_MOVEMENT_BONUS);

	Template.SetAnimationNameForAbility('FanFire', 'FF_FireMultiShotMagA');
	Template.SetAnimationNameForAbility('HailofBullets', 'FF_FireMultiShotConvA');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "PrimaryPistolsMod.Archetype.WP_Pistol_MG";

	Template.iPhysicsImpulse = 5;

	Template.CreatorTemplateName = 'Pistol_MG_Primary_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'Pistol_CV_Primary'; // Which item this will be upgraded from

	Template.CanBeBuilt = true;
	Template.bInfiniteItem = false;

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';

	Template.bHideClipSizeStat = false;

	return Template;
}

static function X2DataTemplate CreateTemplate_Pistol_Coil()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Pistol_CG_Primary');
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'pistol';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///PrimaryPistolsMod.UI.CoilPistol_Base";
	Template.EquipSound = "Secondary_Weapon_Equip_Magnetic";
	Template.Tier = 4;

	Template.RangeAccuracy = default.MIDSHORT_COIL_RANGE;
	Template.BaseDamage = default.PISTOL_COIL_BASEDAMAGE;
	Template.Aim = default.PISTOL_COIL_AIM;
	Template.CritChance = default.PISTOL_COIL_CRITCHANCE;
	Template.iClipSize = default.PISTOL_COIL_ICLIPSIZE;
	Template.iSoundRange = default.PISTOL_COIL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.PISTOL_COIL_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = default.PISTOL_COIL_UPGRADE_SLOTS;

	Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
	Template.InfiniteAmmo = false;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.StowedLocation = eSlot_RearBackPack;
	Template.Abilities.AddiTem('PistolStandardShot');
	Template.Abilities.AddItem('PistolOverwatch');
	Template.Abilities.AddItem('PistolOverwatchShot');
	Template.Abilities.AddItem('PistolReturnFire');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('PrimaryPistolsBonusMG');
	Template.Abilities.AddItem('Quickdraw');
	Template.Abilities.AddItem('Gunslinger');
	Template.Abilities.AddItem('ReturnFire');
	Template.Abilities.AddItem('Lightninghands');
	Template.Abilities.AddItem('ClutchShot');
	Template.Abilities.AddItem('Faceoff');
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, default.PISTOL_COIL_MOVEMENT_BONUS);

	Template.SetAnimationNameForAbility('FanFire', 'FF_FireMultiShotMagA');
	Template.SetAnimationNameForAbility('HailofBullets', 'FF_FireMultiShotConvA');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "PrimaryPistolsMod.Archetype.WP_Pistol_CG";

	Template.iPhysicsImpulse = 5;

	Template.CreatorTemplateName = 'LWPistol_CG_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'Pistol_MG_Primary'; // Which item this will be upgraded from

	Template.CanBeBuilt = true;
	Template.bInfiniteItem = false;

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';  

	Template.bHideClipSizeStat = false;

	return Template;
}

static function X2DataTemplate CreateTemplate_Pistol_Beam()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Pistol_BM_Primary');
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'pistol';
	Template.WeaponTech = 'beam';
	Template.strImage = "img:///PrimaryPistolsMod.UI.BeamPistol_Base";
	Template.EquipSound = "Secondary_Weapon_Equip_Beam";
	Template.Tier = 5;

	Template.RangeAccuracy = default.MIDSHORT_BEAM_RANGE;
	Template.BaseDamage = default.PISTOL_BEAM_BASEDAMAGE;
	Template.Aim = default.PISTOL_BEAM_AIM;
	Template.CritChance = default.PISTOL_BEAM_CRITCHANCE;
	Template.iClipSize = default.PISTOL_BEAM_ICLIPSIZE;
	Template.iSoundRange = default.PISTOL_BEAM_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.PISTOL_BEAM_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = default.PISTOL_BEAM_UPGRADE_SLOTS;

	Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
	Template.InfiniteAmmo = false;
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.StowedLocation = eSlot_RearBackPack;
	Template.Abilities.AddiTem('PistolStandardShot');
	Template.Abilities.AddItem('PistolOverwatch');
	Template.Abilities.AddItem('PistolOverwatchShot');
	Template.Abilities.AddItem('PistolReturnFire');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('PrimaryPistolsBonusMG');
	Template.Abilities.AddItem('Quickdraw');
	Template.Abilities.AddItem('Gunslinger');
	Template.Abilities.AddItem('ReturnFire');
	Template.Abilities.AddItem('Lightninghands');
	Template.Abilities.AddItem('ClutchShot');
	Template.Abilities.AddItem('Faceoff');
	Template.Abilities.AddItem('FanFire');
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, default.PISTOL_BEAM_MOVEMENT_BONUS);


	Template.SetAnimationNameForAbility('FanFire', 'FF_FireMultiShotBeamA');
	Template.SetAnimationNameForAbility('HailofBullets', 'FF_FireMultiShotConvA');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "PrimaryPistolsMod.Archetype.WP_Pistol_BM";

	Template.iPhysicsImpulse = 5;

	Template.CreatorTemplateName = 'Pistol_BM_Primary_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'Pistol_MG_Primary'; // Which item this will be upgraded from

	Template.CanBeBuilt = true;
	Template.bInfiniteItem = false;
	
	Template.DamageTypeTemplateName = 'Projectile_BeamXCom';

	Template.bHideClipSizeStat = false;

	return Template;
}


defaultproperties
{
	bShouldCreateDifficultyVariants = true
}