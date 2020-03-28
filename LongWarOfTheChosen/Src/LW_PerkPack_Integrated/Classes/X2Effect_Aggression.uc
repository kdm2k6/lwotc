//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_Aggression
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Sets up crit bonus from Aggression perk
//--------------------------------------------------------------------------------------- 

class X2Effect_Aggression extends X2Effect_Persistent config (LW_SoldierSkills);

var int CritBonusPerEnemy;
var int MaxCritBonus;
var bool ApplySquadsight;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local XComGameState_Item	SourceWeapon;
    local ShotModifierInfo		ShotInfo;
	local int					BadGuys;
	local array<StateObjectReference> arrSSEnemies;

    SourceWeapon = AbilityState.GetSourceWeapon();    
    if(SourceWeapon != none)	
	{
		BadGuys = Attacker.GetNumVisibleEnemyUnits (true, false, false, -1, false, false);
		if (Attacker.HasSquadsight() && ApplySquadsight)
		{
			class'X2TacticalVisibilityHelpers'.static.GetAllSquadsightEnemiesForUnit(Attacker.ObjectID, arrSSEnemies, -1, false);
			BadGuys += arrSSEnemies.length;
		}
		if (BadGuys > 0)
		{
			ShotInfo.ModType = eHit_Crit;
			ShotInfo.Reason = FriendlyName;
			ShotInfo.Value = Clamp (BadGuys * CritBonusPerEnemy, 0, MaxCritBonus);
			ShotModifiers.AddItem(ShotInfo);
		}
	}
}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
    EffectName="Aggression"
}

//TEST WITH SQUADSIGHT
