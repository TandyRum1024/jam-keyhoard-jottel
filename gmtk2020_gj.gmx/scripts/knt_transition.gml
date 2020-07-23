/// @function knt_transition(dest_state [, transition_time])
/// @param dest_state name of destination state
/// @param [transition_time] frames to fade out. (total transition time = transition_time * 2)
with (oKNT)
{
    var _dest = argument[0], _time = transitionTimeDefault;
    if (argument_count > 1)
        _time = argument[1];
    
    // fsm_set("transition");
    transitionIsHappening   = true;
    transitionIsFadeout     = true;
    transitionCtr   = 0;
    transitionTime  = _time;
    transitionDest  = _dest;
}
