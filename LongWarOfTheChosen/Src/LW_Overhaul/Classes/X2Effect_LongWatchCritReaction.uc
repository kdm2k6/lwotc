class X2Effect_LongWatchCritReaction extends X2Effect_Persistent;

function bool AllowReactionFireCrit(XComGameState_Unit UnitState, XComGameState_Unit TargetState) 
{ 
	local int Tiles;

	Tiles = UnitState.TileDistanceBetween(TargetState);
	//  remove number of tiles within visible range (which is in meters, so convert to units, and divide that by tile size)
	Tiles -= UnitState.GetVisibilityRadius() * class'XComWorldData'.const.WORLD_METERS_TO_UNITS_MULTIPLIER / class'XComWorldData'.const.WORLD_StepSize;
	if(Tiles > 0) //  pretty much should be since a squadsight target is by definition beyond sight range, but...
	{
		return true;
	}
	else if (Tiles == 0) //	this is right at the boundary, but squadsight IS being used so treat it like one tile
	{
		return true;
	}
	return false;
}