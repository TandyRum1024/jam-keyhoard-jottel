/// knt_relocate_select_room(_roomidx)
/// knt_relocate_select_room
var _roomidx = argument0;
with (oKNT)
{
    itemRelocateRoomCurrentIdx  = _roomidx;
    itemRelocateRoomCurrent     = oGamevars.roomVisited[| _roomidx];
    itemRelocateRoomCurrentData = oGamevars.roomDatas[? itemRelocateRoomCurrent];
    
    // Add all items in roomdata to the available items 
    ds_list_clear(itemRelocateRoomCurrentItems);
    var _roomentities = itemRelocateRoomCurrentData[@ eROOMDATA.ENTITYLIST];
    for (var i=0; i<array_length_1d(_roomentities); i++)
    {
        var _entdata      = _roomentities[@ i];
        var _itemdataprev = _entdata[@ eROOMDATA_ENTITY.DATA];
        
        if (_entdata[@ eROOMDATA_ENTITY.TYPE] == eROOMDATA_ENTITY_TYPE.PICKUP)
        {
            // [item type], [unlocked], [original index]
            _entdata[eROOMDATA_ENTITY.DATA] = makearray(_itemdataprev[@ 0], false, ds_list_size(itemRelocateRoomCurrentItems));
            ds_list_add(itemRelocateRoomCurrentItems, _entdata);
        }
    }
    
    // Iterate through all room events and 'simulate' the events
    var _roomevents = roomevents_get_from(itemRelocateRoomCurrent);
    if (_roomevents != undefined)
    {
        // debug_log("ROOM SELECT_ROOM() > READING EVENTS FOR ", room_get_name(itemRelocateRoomCurrent), " [", ds_list_size(_roomevents), " EVENTS]");
        for (var i=0; i<ds_list_size(_roomevents); i++)
        {
            var _event = _roomevents[| i];
            // debug_log("RELOCATE SELECT_ROOM() > EVENT #", i, " : ", _event);
            switch (_event[@ 0])
            {
                case eEVENT.DELETE_OBJ:
                    var _obj = _event[@ 1], _x = _event[@ 2], _y = _event[@ 3];
                    if (_obj == oPickup || object_get_parent(_obj) == oPickup)
                    {
                        // debug_log("RELOCATE SELECT_ROOM() > DELETE EVENT : PICKUP @ [", _x, ", ", _y, "]");
                        for (var j=0; j<ds_list_size(itemRelocateRoomCurrentItems); j++)
                        {
                            var _ent = itemRelocateRoomCurrentItems[| j];
                            if (_x == _ent[@ eROOMDATA_ENTITY.X] && _y == _ent[@ eROOMDATA_ENTITY.Y])
                            {
                                // delete this pickup
                                ds_list_delete(itemRelocateRoomCurrentItems, j);
                                j--;
                                break;
                            }
                        }
                    }
                    break;
                    
                case eEVENT.CREATE_OBJ:
                    var _obj = _event[@ 1], _x = _event[@ 2], _y = _event[@ 3];
                    if (_obj == oPickup || object_get_parent(_obj) == oPickup)
                    {
                        // Create pickup
                        var _ent = -1;
                        _ent[eROOMDATA_ENTITY.TYPE] = eROOMDATA_ENTITY_TYPE.PICKUP;
                        _ent[eROOMDATA_ENTITY.X]    = _x;
                        _ent[eROOMDATA_ENTITY.Y]    = _y;
                        _ent[eROOMDATA_ENTITY.DATA] = makearray(eITEM.NONE, false);
                        ds_list_add(itemRelocateRoomCurrentItems, _ent);
                    }
                    break;
                
                case eEVENT.SWAP_PICKUP_ITEM:
                    var _type = _event[@ 1], _x = _event[@ 2], _y = _event[@ 3];
                    for (var j=0; j<ds_list_size(itemRelocateRoomCurrentItems); j++)
                    {
                        var _ent = itemRelocateRoomCurrentItems[| j];
                        if (_x == _ent[@ eROOMDATA_ENTITY.X] && _y == _ent[@ eROOMDATA_ENTITY.Y])
                        {
                            // swap this pickup's type
                            var _entdata = _ent[@ eROOMDATA_ENTITY.DATA];
                            _entdata[@ 0] = _type;
                            // _ent[@ eROOMDATA_ENTITY.DATA] = _entdata;
                        }
                    }
                    break;
                    
                case eEVENT.UNLOCK_ITEM:
                    var _x = _event[@ 1], _y = _event[@ 2];
                    for (var j=0; j<ds_list_size(itemRelocateRoomCurrentItems); j++)
                    {
                        var _ent = itemRelocateRoomCurrentItems[| j];
                        if (_x == _ent[@ eROOMDATA_ENTITY.X] && _y == _ent[@ eROOMDATA_ENTITY.Y])
                        {
                            // swap this pickup's type
                            var _entdata = _ent[@ eROOMDATA_ENTITY.DATA];
                            _entdata[@ 1] = true;
                            // _ent[@ eROOMDATA_ENTITY.DATA] = _entdata;
                        }
                    }
                    break;
            }
        }
    }
    
    // Itereate through all the items in the items list
    // and add the unlocked items to the available item list
    ds_list_clear(itemRelocateRoomCurrentItemsAvailable);
    for (var i=0; i<ds_list_size(itemRelocateRoomCurrentItems); i++)
    {
        var _entdata      = itemRelocateRoomCurrentItems[| i];
        var _emiscdata    = _entdata[@ eROOMDATA_ENTITY.DATA];
        var _pickupunlock = _emiscdata[@ 1];
        if (_pickupunlock)
        {
            // Update original list index
            _emiscdata[@ 2] = i;
            
            ds_list_add(itemRelocateRoomCurrentItemsAvailable, _entdata);
        }
    }
}
