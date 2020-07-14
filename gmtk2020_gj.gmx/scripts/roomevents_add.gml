#define roomevents_add
/// roomevents_add(event_type, arg1, arg2, arg3...)
/*
    Adds event for current room
*/
// Build args
var _event = -1;
for (var i=0; i<argument_count; i++)
{
    _event[i] = argument[i];
}

// Check if current room doesn't have any room events
var _eventslist = oGamevars.roomEvents[? room];
if (_eventslist == undefined)
{
    _eventslist = ds_list_create();
    
    // add event & assign it to room event map entry
    ds_list_add(_eventslist, _event);
    oGamevars.roomEvents[? room] = _eventslist;
}
else
{
    // add event & assign it to room event map entry
    ds_list_add(_eventslist, _event);
}

#define roomevents_get
/// roomevents_get()
/*
    Fetches list of events for current room
*/
return oGamevars.roomEvents[? room];

#define roomevents_destroy
/*
    Free the room event structure fro memory
*/
var _map = oGamevars.roomEvents;
if (ds_exists(_map, ds_type_map))
{
    var _key = ds_map_find_first(_map);
    while (_key != undefined)
    {
        var _events = _map[? _key];
        ds_list_destroy(_events);
        _key = ds_map_find_next(_map, _key);
    }
}

ds_map_destroy(_map);