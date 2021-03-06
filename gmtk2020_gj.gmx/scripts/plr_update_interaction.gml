var _inputinteract = inputV[@ eINPUT.PRS] == -1 && inputV[@ eINPUT.HLD] < -0.25;

/// Update objective interaction
var _objective = instance_place(x, y, oObjective);
if (instance_exists(_objective))
{
    // Press UP to use
    if (_inputinteract)
    {
        // Request objective interaction
        oKNT.ingameObjectiveInteractionRequest = true;
        
        // Teleport player to door & switch to interaction state
        fsm_set("interact");
        
        // Heal up
        hp = hpMax;
        
        // Emit particles
        repeat (irandom_range(4, 16))
        {
            var _x = random_range(bbox_left, bbox_right);
            var _y = random_range(bbox_top, bbox_bottom);
            fx_emit_dust(_x, _y, random_range(-4, 4), random_range(-4, 4), 0.95, room_speed);
        }
        
        return true;
    }
}

/// Update door interaction
var _door = instance_place(x, y, oDoor);
if (instance_exists(_door))
{
    // Press UP to use
    if (_inputinteract)
    {
        // Request room move
        oKNT.ingameRoomTransitionRequest = true;
        oKNT.ingameRoomTransitionDest    = _door.dest;
        oKNT.ingameRoomTransitionDoorID  = _door.doorID;
        
        // Teleport player to door & switch to interaction state
        fsm_set("interact");
        return true;
    }
}

/// Update teleporter interaction
var _teleport = instance_place(x, y, oTeleport);
if (instance_exists(_teleport))
{
    // Press UP to use
    if (_inputinteract)
    {
        // Request teleportation
        oKNT.ingameTeleportSelectRequest      = true;
        oKNT.ingameTeleportSelectRequestInst  = _teleport;
        
        // Teleport player to door & switch to interaction state
        fsm_set("interact");
        return true;
    }
}

/// Update pickup interaction
var _pickup = instance_place(x, y, oPickup);
if (instance_exists(_pickup))
{
    // Press UP to collect
    if (_inputinteract)
    {
        // Request item pickup
        oKNT.ingameItemPickupRequest = true;
        oKNT.ingameItemPickupInst    = _pickup;
        oKNT.ingameItemPickupType    = _pickup.type;
        
        // Unlock pickup
        _pickup.unlocked = true;
        
        // Add roomevent
        roomevents_add(eEVENT.UNLOCK_ITEM, _pickup.x, _pickup.y);
        
        // Teleport player to door & switch to interaction state
        fsm_set("interact");
        
        // Emit particles
        repeat (irandom_range(4, 16))
        {
            var _x = random_range(bbox_left, bbox_right);
            var _y = random_range(bbox_top, bbox_bottom);
            fx_emit_dust(_x, _y, random_range(-4, 4), random_range(-4, 4), 0.95, room_speed);
        }
        return true;
    }
}

return false;
