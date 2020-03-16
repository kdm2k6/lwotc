//---------------------------------------------------------------------------------------
//  FILE:	 X2Effect_PredictiveAlgorithms, based on XMBEffect_RevealUnit.uc
//  AUTHOR:  xylthixlm (modified by Peter Ledbrook and Christopher Hogrefe)
//  PURPOSE: Displays units in visual range but out of line of sight as if they
//           have Target Definition on them. The Target Definition outline
//           disappears when the unit is in line of sight or the effect is
//           removed from the unit.
//
// Original behavior:
//  Causes a unit to be visible on the map but does not display flyovers or apply
//  to concealed units. Intended for use with Holotargeters. If a
//  revealed unit is in the fog of war it may be difficult to actually see.
//
//---------------------------------------------------------------------------------------
class X2Effect_PredictiveAlgorithms extends X2Effect_Persistent;

var localized string TrackingEffectName;

////////////////////
// Implementation //
////////////////////

//Implements Predictive Algorithms
simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local X2Action_TargetDefinition OutlineAction;
	local XComGameState_Unit UnitState;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit SourceState;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;

	AbilityContext = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	if( AbilityContext != None )
	{
		SourceState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex));
		if( SourceState != None )
		{
			if(SourceState.FindAbility('IndependentTracking').ObjectID > 0)
			{
				UnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);
				if (EffectApplyResult == 'AA_Success' && UnitState != none)
				{
					OutlineAction = X2Action_TargetDefinition(class'X2Action_TargetDefinition'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
					OutlineAction.bEnableOutline = true;
				}
			}
		}
	}

	super.AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, EffectApplyResult);
}

simulated function AddX2ActionsForVisualization_Removed(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult, XComGameState_Effect RemovedEffect)
{
	local X2Action_TargetDefinition OutlineAction;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit SourceState;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;

	AbilityContext = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	if( AbilityContext != None )
	{
		SourceState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex));
		if( SourceState != None )
		{
			if(SourceState.FindAbility('IndependentTracking').ObjectID > 0)
			{
				if (XComGameState_Unit(ActionMetadata.StateObject_NewState) != none)
				{
					OutlineAction = X2Action_TargetDefinition(class'X2Action_TargetDefinition'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
					OutlineAction.bEnableOutline = false;
				}
			}
		}
	}

	super.AddX2ActionsForVisualization_Removed(VisualizeGameState, ActionMetadata, EffectApplyResult, RemovedEffect);
}

simulated function AddX2ActionsForVisualization_Sync( XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata )
{
	local X2Action_TargetDefinition OutlineAction;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit SourceState;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;

	AbilityContext = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	if( AbilityContext != None )
	{
		SourceState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex));
		if( SourceState != None )
		{
			if(SourceState.FindAbility('IndependentTracking').ObjectID > 0)
			{
				if (XComGameState_Unit(ActionMetadata.StateObject_NewState) != none)
				{
					OutlineAction = X2Action_TargetDefinition(class'X2Action_TargetDefinition'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
					OutlineAction.bEnableOutline = true;
				}
			}
		}
	}

	super.AddX2ActionsForVisualization_Sync(VisualizeGameState, ActionMetadata);
}

DefaultProperties
{
	EffectName="LWHolotargetTracking"
	DuplicateResponse=eDupe_Ignore
}
