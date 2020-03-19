//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_LW_ShinobiAbilitySet.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Defines all Long War Shinobi-specific abilities
//---------------------------------------------------------------------------------------

class X2Ability_LW_ShinobiAbilitySet extends X2Ability
	dependson (XComGameStateContext_Ability) config(LW_SoldierSkills);

var config int WHIRLWIND_COOLDOWN;
var config int COUP_DE_GRACE_COOLDOWN;
var config int COUP_DE_GRACE_DISORIENTED_CHANCE;
var config int COUP_DE_GRACE_STUNNED_CHANCE;
var config int COUP_DE_GRACE_UNCONSCIOUS_CHANCE;
var config int TARGET_DAMAGE_CHANCE_MULTIPLIER;

var config int COUP_DE_GRACE_2_HIT_BONUS;
var config int COUP_DE_GRACE_2_CRIT_BONUS;
var config int COUP_DE_GRACE_2_DAMAGE_BONUS;

var config int TRADECRAFT_LONE_AIM_BONUS;
var config int TRADECRAFT_LONE_DEF_BONUS;
var config int TRADECRAFT_LONE_CRIT_BONUS;
var config int TRADECRAFT_LONE_DODGE_BONUS;
var config int TRADECRAFT_LONE_MIN_DIST_TILES;

var config int SILENT_TAKEDOWN_DURATION;
var config int SILENT_TAKEDOWN_CHARGES;
var config bool REFRESH_TAKEDOWN_ON_CONCEAL;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	`Log("LW_ShinobiAbilitySet.CreateTemplates --------------------------------");

	Templates.AddItem(AddWhirlwind());
	Templates.AddItem(AddWhirlwindPassive());
	Templates.AddItem(AddCoupDeGraceAbility());
	Templates.AddItem(AddCoupDeGracePassive());
	Templates.AddItem(AddCoupDeGrace2Ability());
	Templates.AddItem(AddTradecraft());
	Templates.AddItem(AddSilentTakedown());
	Templates.AddItem(AddSilentTakedownDamage()); //Additional Ability
	Templates.AddItem(AddSilentTakedownCharges()); //Additional Ability
	return Templates;
}


static function X2AbilityTemplate AddCoupDeGrace2Ability()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_CoupdeGrace2				CoupDeGraceEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'CoupDeGrace2');
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityCoupDeGrace";
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	CoupDeGraceEffect = new class'X2Effect_CoupDeGrace2';
	CoupDeGraceEffect.To_Hit_Modifier=default.COUP_DE_GRACE_2_HIT_BONUS;
	CoupDeGraceEffect.Crit_Modifier=default.COUP_DE_GRACE_2_CRIT_BONUS;
	CoupDeGraceEffect.Damage_Bonus=default.COUP_DE_GRACE_2_DAMAGE_BONUS;
	CoupDeGraceEffect.Half_for_Disoriented=true;
	CoupDeGraceEffect.BuildPersistentEffect (1, true, false);
	CoupDeGraceEffect.SetDisplayInfo (ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(CoupDeGraceEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

//based on Slash_LW and Kubikuri
static function X2AbilityTemplate AddCoupDeGraceAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2Condition_UnitProperty			UnitCondition;
	local X2AbilityCooldown                 Cooldown;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'CoupDeGrace');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityCoupDeGrace";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.bCrossClassEligible = false;
	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.DisplayTargetHitChance = true;
	Template.bShowActivation = true;
	Template.bSkipFireAction = false;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = StandardMelee;

    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.COUP_DE_GRACE_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	Template.AddShooterEffectExclusions();

	// Target Conditions
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
	UnitCondition = new class'X2Condition_UnitProperty';
	UnitCondition.RequireWithinRange = true;
	UnitCondition.WithinRange = 144; //1.5 tiles in Unreal units, allows attacks on the diag
	UnitCondition.ExcludeRobotic = true;
	Template.AbilityTargetConditions.AddItem(UnitCondition);
	Template.AbilityTargetConditions.AddItem(new class'X2Condition_CoupDeGrace'); // add condition that requires target to be disoriented, stunned or unconscious

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.bAllowBonusWeaponEffects = true;

	// VGamepliz matters

	Template.ActivationSpeech = 'CoupDeGrace';
	Template.SourceMissSpeech = 'SwordMiss';

	Template.AdditionalAbilities.AddItem('CoupDeGracePassive');

	Template.CinescriptCameraType = "Ranger_Reaper";
    Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	return Template;
}

static function X2AbilityTemplate AddCoupDeGracePassive()
{
	local X2AbilityTemplate						Template;
	local X2Effect_CoupDeGrace				CoupDeGraceEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'CoupDeGracePassive');
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityCoupDeGrace";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	//Template.bIsPassive = true;

	// Coup de Grace effect
	CoupDeGraceEffect = new class'X2Effect_CoupDeGrace';
	CoupDeGraceEffect.DisorientedChance = default.COUP_DE_GRACE_DISORIENTED_CHANCE;
	CoupDeGraceEffect.StunnedChance = default.COUP_DE_GRACE_STUNNED_CHANCE;
	CoupDeGraceEffect.UnconsciousChance = default.COUP_DE_GRACE_UNCONSCIOUS_CHANCE;
	CoupDeGraceEffect.TargetDamageChanceMultiplier = default.TARGET_DAMAGE_CHANCE_MULTIPLIER;
	CoupDeGraceEffect.BuildPersistentEffect (1, true, false);
	Template.AddTargetEffect(CoupDeGraceEffect);

	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate AddWhirlwind()
{
	local X2AbilityTemplate					Template;
	local X2Effect_Whirlwind2				WhirlwindEffect;
	
	// LWOTC: For historical and backwards compatibility reasons, this is called
	// Whirlwind2 rather than Whirlwind, even though the original Whirlwind has
	// been removed.
	`CREATE_X2ABILITY_TEMPLATE(Template, 'Whirlwind2');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_riposte";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	WhirlwindEffect = new class'X2Effect_Whirlwind2';
	WhirlwindEffect.BuildPersistentEffect(1, true, false, false);
	WhirlwindEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,, Template.AbilitySourceName);
	WhirlwindEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(WhirlwindEffect);

	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.bShowActivation = true;
	Template.bShowPostActivation = false;

	return Template;
}

static function X2AbilityTemplate AddWhirlwindPassive()
{
	local X2AbilityTemplate Template;

	Template = PurePassive('WhirlwindPassive', "img:///UILibrary_PerkIcons.UIPerk_riposte", , 'eAbilitySource_Perk');

	return Template;
}

static function X2AbilityTemplate AddTradecraft()
{
	local X2AbilityTemplate					Template;
	local X2Effect_LoneWolf					AimandDefModifiers;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Tradecraft');
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityTradecraft";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	AimandDefModifiers = new class 'X2Effect_LoneWolf';
	AimandDefModifiers.EffectName = 'Tradecraft';
	AimandDefModifiers.AIM_BONUS = default.TRADECRAFT_LONE_AIM_BONUS;
	AimandDefModifiers.DEF_BONUS = default.TRADECRAFT_LONE_DEF_BONUS;
	AimandDefModifiers.CRIT_BONUS = default.TRADECRAFT_LONE_CRIT_BONUS;
	AimandDefModifiers.CRIT_BONUS = default.TRADECRAFT_LONE_DODGE_BONUS;
	AimandDefModifiers.MIN_DIST_TILES = default.TRADECRAFT_LONE_MIN_DIST_TILES;
	AimandDefModifiers.BuildPersistentEffect (1, true, false);
	AimandDefModifiers.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (AimandDefModifiers);
	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;	
	//no visualization
	return Template;		
}

static function X2AbilityTemplate AddSilentTakedown()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityCost_Charges				ChargeCost;
	local X2AbilityCharges					Charges;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_GrantActionPoints		GrantActionPoints;
	local X2Effect_PreventDetection			NoDetectionRadiusEffect;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2Condition_RequireConcealed		ConcealmentCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SilentTakedown_LW');
	`LOG("Creating Silent Takedown ability");

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityKubikuri";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SERGEANT_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.bCrossClassEligible = false;

	//Only lose concealment if you dont kill the primary target
	Template.ConcealmentRule = eConceal_KillShot;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Charges = new class 'X2AbilityCharges';
	Charges.InitialCharges = default.SILENT_TAKEDOWN_CHARGES;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = StandardMelee;

	Template.AbilityTargetStyle = new class'X2AbilityTarget_MovingMelee';
	Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Target Conditions
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	//ConcealmentCondition = new class'X2Condition_RequireConcealed';
	//Template.AbilityShooterConditions.AddItem(ConcealmentCondition);

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bBypassSustainEffects = true; //FUCK PRIESTS
	Template.AddTargetEffect(WeaponDamageEffect);

	// Movement Effect
	GrantActionPoints = new class'X2Effect_GrantActionPoints';
	GrantActionPoints.bApplyOnMiss = true;
	GrantActionPoints.NumActionPoints = 1;
	GrantActionPoints.PointType = class'X2CharacterTemplateManager'.default.MoveActionPoint;
	Template.AddShooterEffect(GrantActionPoints);

	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	
	// Voice events
	Template.SourceMissSpeech = 'SwordMiss';

	Template.BuildNewGameStateFn = SilentTakedown_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	Template.AdditionalAbilities.AddItem('SilentTakedownDamage_LW');
	if(default.REFRESH_TAKEDOWN_ON_CONCEAL)
	{
		Template.AdditionalAbilities.AddItem('SilentTakedownCharges_LW');
	}

	return Template;
}

static function X2AbilityTemplate AddSilentTakedownDamage()
{
    local X2AbilityTemplate Template;
    local X2Effect_SilentTakedownDamage DamageEffect;

    `CREATE_X2ABILITY_TEMPLATE (Template, 'SilentTakedownDamage_LW');
    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_momentum";
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = 2;
    Template.Hostility = 2;
    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
    DamageEffect = new class'X2Effect_SilentTakedownDamage';
    DamageEffect.BuildPersistentEffect(1, true, false, false);
    DamageEffect.SetDisplayInfo(0, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,, Template.AbilitySourceName);
    Template.AddTargetEffect(DamageEffect);
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    return Template;
}

static function X2AbilityTemplate AddSilentTakedownCharges()
{
	local X2AbilityTemplate						Template;
	local X2AbilityTrigger_EventListener		Trigger;
	local X2Effect_RestoreTakedownCharges		ChargeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SilentTakedownCharges_LW');

	//	Icon
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_Interrupt";
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.bDisplayInUITacticalText = false;
	Template.bDisplayInUITooltip = false;
	Template.bDontDisplayInAbilitySummary = true;
	Template.bHideOnClassUnlock = true;

	//	Targeting and Triggering
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'UnitConcealmentEntered';
	Trigger.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(Trigger);

	ChargeEffect = new class'X2Effect_RestoreTakedownCharges';
	ChargeEffect.OriginalCharges = default.SILENT_TAKEDOWN_CHARGES;
	Template.AddShooterEffect(ChargeEffect);
	
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

//Used by charging melee attacks to perform a move and an attack.
static function XComGameState SilentTakedown_BuildGameState(XComGameStateContext Context)
{
	local XComGameState NewGameState;
	local XComGameStateHistory History;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit SourceObject_OriginalState;
	local XComGameState_Unit SourceObject_NewState;
	local XComGameState_Ability AbilityState;
	local EffectResults EffectResults;
	local X2Effect_PreventDetection DetectionEffect;
	local EffectAppliedData ApplyData;
	local StateObjectReference NoWeapon;
	local X2AbilityTemplate AbilityTemplate;
	local name Result;

	local float OldValue;

	History = `XCOMHISTORY;	
	NewGameState = History.CreateNewGameState(true, Context);
	
	AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext());
	`assert(AbilityContext != None);

	AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));
	AbilityTemplate = AbilityState.GetMyTemplate();

	SourceObject_OriginalState = History.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID);	
	SourceObject_NewState = NewGameState.ModifyStateObject(SourceObject_OriginalState.Class, AbilityContext.InputContext.SourceObject.ObjectID);
	
	/*ApplyData.AbilityInputContext = AbilityContext.InputContext;
	ApplyData.AbilityResultContext = AbilityContext.ResultContext;
	ApplyData.AbilityResultContext.HitResult = AbilityContext.ResultContext.HitResult; 
	ApplyData.AbilityResultContext.ArmorMitigation = AbilityContext.ResultContext.ArmorMitigation;
	ApplyData.AbilityStateObjectRef = AbilityState.GetReference();
	ApplyData.SourceStateObjectRef = SourceObject_OriginalState.GetReference();
	ApplyData.TargetStateObjectRef = SourceObject_OriginalState.GetReference();	
	ApplyData.ItemStateObjectRef = AbilityState.GetSourceWeapon() == none ? NoWeapon : AbilityState.GetSourceWeapon().GetReference();	
	ApplyData.EffectRef.SourceTemplateName = AbilityTemplate.DataName;
	ApplyData.EffectRef.LookupType = TELT_AbilityShooterEffects;

	// No detection radius effect
	DetectionEffect = new class'X2Effect_PreventDetection';
	DetectionEffect.EffectName = 'NoDetectionRadius';
	DetectionEffect.BuildPersistentEffect(default.SILENT_TAKEDOWN_DURATION, false, true, false, eGameRule_PlayerTurnEnd);
	DetectionEffect.bRemoveWhenTargetConcealmentBroken = true;
	DetectionEffect.DuplicateResponse = eDupe_Refresh;
	
	//Apply the effect that prevents detection
	Result = DetectionEffect.ApplyEffect(ApplyData, SourceObject_NewState, NewGameState);
	`LOG("Applying Silent Takedown Effect with result" @ Result);
	EffectResults.ApplyResults.AddItem(Result);*/

	OldValue = SourceObject_NewState.GetCurrentStat(eStat_DetectionModifier);
	SourceObject_NewState.SetCurrentStat(eStat_DetectionModifier, 0);

	// finalize the movement portion of the ability
	class'X2Ability_DefaultAbilitySet'.static.MoveAbility_FillOutGameState(NewGameState, false); //Do not apply costs at this time.

	// build the "fire" animation for the slash
	class'X2Ability'.static.TypicalAbility_FillOutGameState(NewGameState); //Costs applied here.

	SourceObject_NewState.SetCurrentStat(eStat_DetectionModifier, OldValue);

	return NewGameState;
}