//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_PrecisionShotPierce
//  AUTHOR:  Chris the Thin Mint
//  PURPOSE: Sets up conditional pierce bonus for Precision Shot (based on X2Effect_SlugShot)
//--------------------------------------------------------------------------------------- 

class X2Effect_PrecisionShotPierce extends X2Effect_Persistent config (LW_SoldierSkills);

var int BASE_PIERCE;
var int PIERCE_ON_CRIT;

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
    EffectName="PrecisionShotPierce"
}