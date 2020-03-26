class X2Effect_SoulSteal_LW extends X2Effect_PersistentStatChange;

var int BaseShieldHPIncrease;
var int AmpMGShieldHPBonus;
var int AmpBMShieldHPBonus;

protected simulated function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local StatChange			ShieldHPChange;
	local XComGameState_Unit	Caster, Target;
	local XComGameState_Item	SourceItem;

	ShieldHPChange.StatType = eStat_ShieldHP;

	Caster = XComGameState_Unit (NewGameState.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	Target = XComGameState_unit (kNewTargetState);
    if(Caster == none)
    {
        Caster = XComGameState_Unit(class'XComGameStateHistory'.static.GetGameStateHistory().GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
    }
	SourceItem = XComGameState_Item(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.ItemStateObjectRef.ObjectID));
	if(SourceItem == none)
    {
        SourceItem = XComGameState_Item(class'XComGameStateHistory'.static.GetGameStateHistory().GetGameStateForObjectID(ApplyEffectParameters.ItemStateObjectRef.ObjectID));
    }
	
	ShieldHPChange.StatAmount = BaseShieldHPIncrease;
    
	if (SourceItem.GetMyTemplateName() == 'PsiAmp_MG')
	{
		ShieldHPChange.StatAmount += AmpMGShieldHPBonus;
	}
	if (SourceItem.GetMyTemplateName() == 'PsiAmp_BM')
	{
		ShieldHPChange.StatAmount += AmpBMShieldHPBonus;
	}

    NewEffectState.StatChanges.AddItem(ShieldHPChange);
    
	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}


simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata BuildTrack, name EffectApplyResult)
{
	local XComGameState_Unit OldUnitState, NewUnitState;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local string Msg;

	`LOG ("Soul Steal 2 activated");
	if (EffectApplyResult == 'AA_Success')
	{
		OldUnitState = XComGameState_Unit(BuildTrack.StateObject_OldState);
		NewUnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);
		if (OldUnitState != none && NewUnitState != none)
		{
			SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext(), false, BuildTrack.LastActionAdded));
			Msg = class'XGLocalizedData'.Default.ShieldedMessage;
			SoundAndFlyOver.SetSoundAndFlyOverParameters(None, Msg, '', eColor_Good);
		}
	}
}