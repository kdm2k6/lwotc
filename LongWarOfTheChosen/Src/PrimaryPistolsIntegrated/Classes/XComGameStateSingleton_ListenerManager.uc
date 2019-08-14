class XComGameStateSingleton_ListenerManager extends XComGameState_BaseObject;
 
static function EnsurePresenceOfSingleton(optional XComGameState NewGameState)
{
    local XComGameState_BaseObject Listener;
    local XComGameStateHistory History;
    local bool bShouldSubmit;
 
    History = `XCOMHISTORY;
    // check a): is there already one in the history?
    Listener = History.GetSingleGameStateObjectForClass(default.Class, true);
    if (Listener != none)
    {
        RegisterForEvents(Listener);
        return;
    }
 
    // check b): does our passed game state already contain us? (rare case, should never happen)
    if (NewGameState != none)
    {
        foreach NewGameState.IterateByClassType(class'XComGameState_BaseObject', Listener)
        {
            if (Listener.IsA(default.Class.Name))
            {
                RegisterForEvents(Listener);
                return;
            }
        }
    }
    else
    {
        // we don't have a gamestate, so we need to create one
        NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Add Listener");
        // remember to submit (well, add)
        bShouldSubmit = true;
    }
 
    Listener = NewGameState.CreateStateObject(default.Class);
 
    NewGameState.AddStateObject(Listener);
   
    RegisterForEvents(Listener);
    if (bShouldSubmit)
    {
        History.AddGameStateToHistory(NewGameState);
    }
}
 
static function RegisterForEvents(XComGameState_BaseObject TriggerObj)
{
	local Object ThisObj;

	ThisObj = TriggerObj;
	`XEVENTMGR.RegisterForEvent(ThisObj, 'HunterWeaponsViewed', OnHunterWeaponsViewed, ELD_OnStateSubmitted);
	`Log("RegisterForEvent HunterWeaponsViewed",, 'PrimaryPistols');
}

function EventListenerReturn OnHunterWeaponsViewed(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local array<name> TemplateNames;
	
	TemplateNames.AddItem('AlienHunterPistol_CV_Primary');
	class'X2DownloadableContentInfo_PrimaryPistols'.static.UpdateStorage(TemplateNames);
	`Log("HunterWeaponsViewed Event fired, add AlienHunterPistol_CV_Primary",, 'PrimaryPistols');
}