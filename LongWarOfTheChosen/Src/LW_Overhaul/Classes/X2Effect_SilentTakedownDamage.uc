class X2Effect_SilentTakedownDamage extends X2Effect_Persistent config(LW_SoldierSkills);

var config float SILENT_TAKEDOWN_DAMAGE_MODIFIER;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
    local float ExtraDamage;

    if(AbilityState.GetMyTemplateName() == 'SilentTakedown_LW')
    {
		if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
		{
			ExtraDamage = -1 * (float(CurrentDamage) * default.SILENT_TAKEDOWN_DAMAGE_MODIFIER);
		}
    }
    return int(ExtraDamage);
}