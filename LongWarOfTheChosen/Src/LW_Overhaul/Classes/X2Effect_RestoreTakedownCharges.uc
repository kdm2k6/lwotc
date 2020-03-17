class X2Effect_RestoreTakedownCharges extends X2Effect;

var int OriginalCharges;						// Number of bonus charges to add


simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit NewUnit;
	local XComGameState_Ability AbilityState;
	local XComGameStateHistory History;
	local StateObjectReference ObjRef;
	local int Charges, NewCharges;
	
	NewUnit = XComGameState_Unit(kNewTargetState);
	if (NewUnit == none)
		return;

	History = `XCOMHISTORY;

	if (SkipForDirectMissionTransfer(ApplyEffectParameters))
		return;

	foreach NewUnit.Abilities(ObjRef)
	{
		AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(ObjRef.ObjectID));
		if (AbilityState.GetMyTemplateName() == 'SilentTakedown_LW')
		{
			Charges = AbilityState.GetCharges();
			if (Charges < OriginalCharges)
			{
				NewCharges = OriginalCharges - Charges;

				AbilityState = XComGameState_Ability(NewGameState.ModifyStateObject(AbilityState.class, AbilityState.ObjectID));
				AbilityState.iCharges += NewCharges;
			}
		}
	}
}

// Returns true if this is an on-post-begin-play trigger on the second or later part of a multi-
// part mission. Used to avoid giving duplicates of effects that naturally persist through a
// multi-part mission, such as additional ability charges.
static function bool SkipForDirectMissionTransfer(const out EffectAppliedData ApplyEffectParameters)
{
	local XComGameState_Ability AbilityState;
	local XComGameStateHistory History;
	local XComGameState_BattleData BattleData;
	local int Priority;

	History = `XCOMHISTORY;

	BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	if (!BattleData.DirectTransferInfo.IsDirectMissionTransfer)
		return false;

	AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
	if (!AbilityState.IsAbilityTriggeredOnUnitPostBeginTacticalPlay(Priority))
		return false;

	return true;
}

defaultproperties
{
	OriginalCharges = 2;
}