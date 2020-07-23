#define inv_key_add
/// inv_key_add(_keystate, _available, _id)
var _keystate = argument0, _available = argument1, _id = argument2;

var _data = -1;
_data[eINVKEY.KEY]          = _keystate;
_data[eINVKEY.AVAILABLE]    = _available;
_data[eINVKEY.ID]           = _id;
_data[eINVKEY.ITEM]         = eITEM.NONE;

ds_list_add(oGamevars.invSlots, _data);

#define inv_key_get
/// inv_key_get(_keycode)
var _keycode = argument0;

var _data = noone;
var _slots = oGamevars.invSlots;
for (var i=0; i<ds_list_size(_slots); i++)
{
    var _data = _slots[| i];
    if (_data[@ eINVKEY.ID] == _keycode)
        return _data;
}

return _data;

#define inv_key_set_available
/// inv_key_set_available(_keycode, _available)
var _keycode = argument0, _available = argument1;
var _key = inv_key_get(_keycode);
_key[@ eINVKEY.AVAILABLE] = _available;

#define inv_add_item
/// inv_add_item(_item, _available)
var _item = argument0, _available = argument1;
var _data = -1;
_data[eINV.ITEM] = _item;
_data[eINV.AVAILABLE] = _available;

ds_list_add(oGamevars.invItems, _data);