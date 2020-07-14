#define fsm_init
/// fsm_init()
/*
    Sets up the FSM for caller instance
*/

fsmMap = ds_map_create();
fsmState        = undefined;
fsmStateNext    = "default";
fsmStatePrev    = "default";
fsmStateCtr     = 0;
fsmStateInit    = false;
fsmStateScript  = undefined;

#define fsm_set
fsmStateNext = argument0;

#define fsm_add_state
/// fsm_add_state(state, script)
fsmMap[? argument0] = argument1;

#define fsm_update
/// Check for state switch
if (fsmStateNext != fsmState)
{
    fsmStatePrev    = fsmState;
    fsmState        = fsmStateNext;
    fsmStateCtr     = 0;
    fsmStateInit    = false;
    
    // Fetch state's script
    fsmStateScript = fsmMap[? fsmState];
    if (fsmStateScript == undefined || !script_exists(fsmStateScript))
    {
        debug_log("FSM > STATE [", fsmState, "] HAS NO VALID SCRIPT ASSIGNED TO!!");
        fsmStateScript = undefined;
    }
}

/// Execute state script
if (fsmStateScript != undefined)
{
    script_execute(fsmStateScript);
}

/// Update state init flag & state counter
fsmStateInit = true;
fsmStateCtr++;