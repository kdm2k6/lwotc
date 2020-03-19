class X2Effect_PreventDetection extends X2Effect_ModifyStats;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local StatChange NewChange;
	local XComGameState_Unit TargetUnit;
	local float CurrentDetectionModifier, DiffToMaxDetectionModifier;
	
	TargetUnit = XComGameState_Unit(kNewTargetState);
	CurrentDetectionModifier = TargetUnit.GetCurrentStat(eStat_DetectionModifier);
	DiffToMaxDetectionModifier = 1 - CurrentDetectionModifier;
	
	NewChange.StatType = eStat_DetectionModifier;
	NewChange.StatAmount = -100;
	NewChange.ModOp = MODOP_Addition;

	`LOG("Silent Takedown: Added detection modifier " @ DiffToMaxDetectionModifier @ " to unit " @ TargetUnit.GetFullName());

	NewEffectState.StatChanges.AddItem(NewChange);
	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}