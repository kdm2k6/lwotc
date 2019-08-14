class X2Ability_PrimaryPistols extends X2Ability
	dependson (XComGameStateContext_Ability) config(PrimaryPistols);
			
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(PrimaryPistolsBonus('PrimaryPistolsBonusCV', class'X2Item_PrimaryPistols'.default.PISTOL_CONVENTIONAL_MOVEMENT_BONUS, class'X2Item_PrimaryPistols'.default.PISTOL_CONVENTIONAL_DETECTIONRADIUS_MODIFER));
	Templates.AddItem(PrimaryPistolsBonus('PrimaryPistolsBonusLS', class'X2Item_PrimaryPistols'.default.PISTOL_LASER_MOVEMENT_BONUS, class'X2Item_PrimaryPistols'.default.PISTOL_LASER_DETECTIONRADIUS_MODIFER));
	Templates.AddItem(PrimaryPistolsBonus('PrimaryPistolsBonusMG', class'X2Item_PrimaryPistols'.default.PISTOL_MAGNETIC_MOVEMENT_BONUS, class'X2Item_PrimaryPistols'.default.PISTOL_MAGNETIC_DETECTIONRADIUS_MODIFER));
	Templates.AddItem(PrimaryPistolsBonus('PrimaryPistolsBonusCG', class'X2Item_PrimaryPistols'.default.PISTOL_COIL_MOVEMENT_BONUS, class'X2Item_PrimaryPistols'.default.PISTOL_COIL_DETECTIONRADIUS_MODIFER));
	Templates.AddItem(PrimaryPistolsBonus('PrimaryPistolsBonusBM', class'X2Item_PrimaryPistols'.default.PISTOL_BEAM_MOVEMENT_BONUS, class'X2Item_PrimaryPistols'.default.PISTOL_BEAM_DETECTIONRADIUS_MODIFER));

	return Templates;
}

static function X2AbilityTemplate PrimaryPistolsBonus(name TemplateName, int Bonus, float DetectionModifier)
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_item_nanofibervest";

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false, , Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, Bonus);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_DetectionModifier, DetectionModifier);
	Template.AddTargetEffect(PersistentStatChangeEffect);
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	
	return Template;
}