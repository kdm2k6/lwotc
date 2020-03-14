class X2Effect_PrecisionShotCritDamage extends X2Effect_Persistent config(LW_SoldierSkills);

var config float PRECISION_SHOT_CRIT_DAMAGE_MODIFIER;
var config int PRECISION_SHOT_CRIT_DAMAGE_FLAT;

var int BASE_PIERCE;
var int PIERCE_ON_CRIT;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
    local float ExtraDamage;
	
    if(AbilityState.GetMyTemplateName() == 'PrecisionShot')
    {
		//`LOG ("Checking PS");
		if(AppliedData.AbilityResultContext.HitResult == eHit_Crit)
		{
			ExtraDamage = Max(1, (float(CurrentDamage + default.PRECISION_SHOT_CRIT_DAMAGE_FLAT) * default.PRECISION_SHOT_CRIT_DAMAGE_MODIFIER));
			//`LOG ("Precision Shot Current/Extra Damage" @ CurrentDamage @ ExtraDamage);
		}
    }
    return ExtraDamage;
}

function int GetExtraArmorPiercing(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData)
{
    local XComGameState_Item SourceWeapon;

	if(AbilityState.GetMyTemplateName() == 'PrecisionShot')
    {
		SourceWeapon = AbilityState.GetSourceWeapon();
		if(SourceWeapon != none) 
		{
			//`LOG ("Checking PS");
			if(AppliedData.AbilityResultContext.HitResult == eHit_Crit)
			{
				return (default.BASE_PIERCE + default.PIERCE_ON_CRIT);
			}

	        return default.BASE_PIERCE;
		}
    }

    return 0;
}

defaultproperties
{
    EffectName="PrecisionShotCritDamage"
}