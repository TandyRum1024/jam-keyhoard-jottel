#define inv_key_add
/// inv_key_add(_id, _keystate)
var _id = argument0, _keystate = argument1;

var _data = -1;
_data[eINVKEY.KEYSTATE]     = _keystate;
_data[eINVKEY.AVAILABLE]    = false;
_data[eINVKEY.ITEM]         = eITEM.NONE;
oInput.invKeyslots[? _id] = _data;

ds_list_add(invKeyslotsIDList, _id);

#define inv_key_get
/// inv_key_get(_id)
var _id = argument0;
var _data = oInput.invKeyslots[? _id];
return _data;

#define inv_key_get_keystate
/// inv_key_get_keystate(_id)
var _id = argument0;
var _data       = oInput.invKeyslots[? _id];
var _keystate   = _data[@ eINVKEY.KEYSTATE];
return _keystate;

#define inv_key_set_available
/// inv_key_set_available(_id, _available)
var _id = argument0, _available = argument1;
var _data = inv_key_get(_id);
_data[@ eINVKEY.AVAILABLE] = _available;