//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_BringEmOn
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Sets up damage bonuses for BEO
//---------------------------------------------------------------------------------------
class X2Effect_BringEmOn extends X2Effect_Persistent config (LW_SoldierSkills);

var float CritDmgPerEnemy;
var int MaxCritDmgBonus;
var bool ApplySquadsight;
var bool ApplyToExplosives;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
    local XComGameState_Item SourceWeapon;
    local XComGameState_Unit TargetUnit;
	local array<StateObjectReference> arrSSEnemies;
	local int BadGuys;
	local X2AbilityToHitCalc_StandardAim StandardHit;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;

    if(AppliedData.AbilityResultContext.HitResult == eHit_Crit)
    {
        SourceWeapon = AbilityState.GetSourceWeapon();
        if(SourceWeapon != none) 
        {
			if(	AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
			{
				return 0;
			}
			if (!ApplyToExplosives)
			{
				if (X2WeaponTemplate(AbilityState.GetSourceWeapon().GetMyTemplate()).WeaponCat == 'grenade')
				{
					return 0;
				}
				if (AbilityState.GetMyTemplateName() == 'LWRocketLauncher' || AbilityState.GetMyTemplateName() == 'LWBlasterLauncher' || AbilityState.GetMyTemplateName() == 'MicroMissiles')
				{
					return 0;
				}
				StandardHit = X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc);
				if(StandardHit != none && StandardHit.bIndirectFire) 
				{
					return 0;
				}
			}
			WeaponDamageEffect = X2Effect_ApplyWeaponDamage(class'X2Effect'.static.GetX2Effect(AppliedData.EffectRef));
			if (WeaponDamageEffect != none)
			{
				if (WeaponDamageEffect.bIgnoreBaseDamage)
				{
					return 0;
				}
			}
			TargetUnit = XComGameState_Unit(TargetDamageable);
            if(TargetUnit != none)
            {
                BadGuys = Attacker.GetNumVisibleEnemyUnits (true, false, false, -1, false, false);
				if (Attacker.HasSquadsight() && ApplySquadsight)
				{
					class'X2TacticalVisibilityHelpers'.static.GetAllSquadsightEnemiesForUnit(Attacker.ObjectID, arrSSEnemies, -1, false);
					BadGuys += arrSSEnemies.length;
				}
				if (BadGuys > 0)
				{
					return clamp (BadGuys * CritDmgPerEnemy, 0,MaxCritDmgBonus);
				}
            }
        }
    }
    return 0;
}

