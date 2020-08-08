#define knt_state_normal
/// Game's normal state
if (!fsmStateInit)
{
    with (oUI)
    {
        fsm_set("ingame");
    }
}

if (!transitionIsHappening)
{
    /// Update play time
    oGamevars.playtimeSecsMod += delta_time * 0.000001;
    
    if (oGamevars.playtimeSecsMod >= 1.0)
    {
        oGamevars.playtimeSecsMod -= 1.0;
        oGamevars.playtimeSecs++;
    }
    
    /// Check for room transition request
    if (ingameRoomTransitionRequest)
    {
        // Switch state to room change
        debug_log("oKNT > SWITCH TO STATE_ROOM_MOVE");
        knt_transition("room_move", 4);
        
        // Play sound
        sfx_play(sndWallImpact, 1.0, 1.0);
    }
    
    /// Check for item pickup request
    if (ingameItemPickupRequest)
    {
        // Switch state to room change
        debug_log("oKNT > SWITCH TO STATE_ITEM_GET");
        knt_transition("item_get", 4);
        
        // Play sound
        sfx_play(sndPrompt, 1.0, 1.0);
    }
    
    /// Check for objective interaction request
    if (ingameObjectiveInteractionRequest)
    {
        // Switch state to room change
        debug_log("oKNT > SWITCH TO STATE_OBJECTIVE_MAIN");
        knt_transition("objective_main", 4);
        
        // Play sound
        sfx_play(sndPrompt, 1.0, 1.0);
    }
    
    /// Check for teleport selection request
    if (ingameTeleportSelectRequest)
    {
        // Switch state to room change
        debug_log("oKNT > SWITCH TO STATE_TELEPORT_SELECT");
        knt_transition("teleport_select", 4);
        
        // Play sound
        sfx_play(sndPrompt, 1.0, 1.0);
    }
    
    /// Check for ending request
    if (ingameEndingRequest)
    {
        // Switch state to room change
        debug_log("oKNT > SWITCH TO STATE_ENDING");
        knt_transition("ingame_ending");
        
        // Play sound
        sfx_play(sndPrompt, 1.0, 1.0);
    }
    
    /// Check for player dead
    if (oPlayer.fsmState == "dead")
    {
        if (oInput.inputConfirm[@ eINPUT.PRS] || oInput.inputConfirmAlt[@ eINPUT.PRS])
        {
            // Respawn at hub
            knt_transition("hub_respawn");
            
            // Play sound
            sfx_play(sndPrompt, 1.0, 1.0);
        }
    }
    
    /// Check for pause request
    if (oInput.inputDeny[@ eINPUT.PRS] || gamepad_button_check_pressed(oInput.inputDevice, gp_start))
    {
        // Switch state to paused state
        knt_transition("paused_main", room_speed * 0.25);
        
        // Play sound
        sfx_play(sndPrompt, 1.0, 1.0);
    }
    
    /// Check for debug menu request
    if (keyboard_check_pressed(vk_f12))
    {
        // Switch state to paused state
        knt_transition("debug_main", room_speed * 0.25);
        
        // Play sound
        sfx_play(sndPrompt, 1.0, 1.0);
    }
    
    /// Update the tutorial
    if (ingameTutorialInProgress)
    {
        switch (ingameTutorialState)
        {
            case eTUTORIAL_STATE.MOVE:
                ui_show_subtitle("> [LEFT] AND [RIGHT] TO MOVE");
                ingameTutorialMoveCtr += abs(oPlayer.vx);
                
                if (ingameTutorialMoveCtr > ingameTutorialMoveCtrMax)
                    ingameTutorialState = eTUTORIAL_STATE.INTERACT;
                break;
            case eTUTORIAL_STATE.INTERACT:
                ui_show_subtitle("> [UP] TO INTERACT WITH DOORS AND STUFFS");
                
                if (ingameRoomTransitionRequest || ingameObjectiveInteractionRequest || ingameTeleportSelectRequest)
                    ingameTutorialState = eTUTORIAL_STATE.ITEMS;
                break;
            case eTUTORIAL_STATE.ITEMS:
                ui_show_subtitle("> FIND AND EQUIP UPGRADES THAT WILL AID YOUR OPERATION");
                
                if (ingameItemPickupRequest)
                    ingameTutorialState = eTUTORIAL_STATE.DEPOSIT;
                break;
            case eTUTORIAL_STATE.DEPOSIT:
                ui_show_subtitle("> COLLECT AND DEPOSIT [POWER CANISTERS] INTO THE CONTROL STATION @ THE LOBBY TO REPAIR THE SHIP");
                
                if (oGamevars.progress > 0)
                    ingameTutorialState = eTUTORIAL_STATE.DONE;
                break;
            case eTUTORIAL_STATE.DONE:
                ui_show_subtitle("> GOOD LUCK AND HAVE FUN OPERATING!");
                ingameTutorialInProgress = false;
                break;
        }
    }
    
    // Unpause the game
    global.isPhysicsPaused = false;
}
else
{
    // Force-pause the game
    global.isPhysicsPaused = true;
}

#define knt_state_paused
/// Game's paused menu state
if (!fsmStateInit)
{
    with (oUI)
    {
        fsm_set("paused_main");
    }
    
    // Pause the game's physics
    global.isPhysicsPaused = true;
    
    // Reset menu
    oUI.pausedMenuSelected = 0;
}

if (!transitionIsHappening)
{
    /// Check for inputs
    var _inputv = oInput.inputV[@ eINPUT.PRS]; // keyboard_check_pressed(vk_down) - keyboard_check_pressed(vk_up);
    var _inputconfirm   = oInput.inputConfirm[@ eINPUT.PRS] || oInput.inputConfirmAlt[@ eINPUT.PRS];
    var _inputdeny      = oInput.inputDeny[@ eINPUT.PRS] || oInput.inputDenyAlt[@ eINPUT.PRS];
    
    if (_inputconfirm) /// Select menu
    {
        var _menudata = oUI.pausedMenuList[@ oUI.pausedMenuSelected];
        knt_transition(_menudata[@ 0], 4);
        
        // Play sound
        sfx_play(sndYes, 1.0, random_range(0.95, 1.05));
    }
    else if (_inputv != 0) /// Navigate menu
    {
        with (oUI)
        {
            var _listsz = array_length_1d(pausedMenuList);
            pausedMenuSelected = (pausedMenuSelected + _inputv + _listsz) % _listsz;
            
            // Play sound
            sfx_play(sndSelect, 1.0, random_range(0.95, 1.05));
        }
    }
    else if (_inputdeny) /// Unpause request
    {
        // Switch state to main state
        knt_transition("default", room_speed * 0.25);
        
        // Unpause the game's physics
        global.isPhysicsPaused = false;
        
        // Play sound
        sfx_play(sndNo, 1.0, random_range(0.95, 1.05));
    }
}

#define knt_state_paused_settings
/// Game's paused settings menu state
if (!fsmStateInit)
{
    with (oUI)
    {
        fsm_set("paused_settings");
    }
    
    // Reset menu
    oUI.pausedSettingsSelected = 0;
}


if (!transitionIsHappening)
{
    /// Check for inputs
    var _inputh = oInput.inputH[@ eINPUT.PRS];
    var _inputv = oInput.inputV[@ eINPUT.PRS];
    var _inputconfirm   = oInput.inputConfirm[@ eINPUT.PRS] || oInput.inputConfirmAlt[@ eINPUT.PRS];
    var _inputdeny      = oInput.inputDeny[@ eINPUT.PRS] || oInput.inputDenyAlt[@ eINPUT.PRS];
    
    if (!oUI.pausedSettingsAdjusting) /// Wait for users to select the settings item
    {
        if (_inputconfirm) /// Select settings item
        {
            var _currentitem = oUI.pausedSettingsList[@ oUI.pausedSettingsSelected];
            
            // Check if destination state string is present
            var _deststate = _currentitem[@ 4];
            if (_deststate != "")
            {
                // Yes, switch to that state
                fsm_set(_deststate);
                
                // Play sound
                sfx_play(sndPrompt, 1.0, random_range(0.95, 1.05));
            }
            else
            {
                // No, switch to ordinary value adjusting
                oUI.pausedSettingsAdjusting = true;
                
                // Play sound
                sfx_play(sndPrompt, 1.0, random_range(0.95, 1.05));
            }
        }
        else if (_inputv != 0) /// Navigate settings items
        {
            with (oUI)
            {
                var _listsz = array_length_1d(pausedSettingsList);
                pausedSettingsSelected = (pausedSettingsSelected + _inputv + _listsz) % _listsz;
                
                // Play sound
                sfx_play(sndSelect, 1.0, random_range(0.95, 1.05));
            }
        }
        else if (_inputdeny) /// Unpause request
        {
            // Switch state to paused menu state
            knt_transition("paused_main", 4);
            
            // Play sound
            sfx_play(sndNo, 1.0, random_range(0.95, 1.05));
        }
    }
    else
    {
        if (_inputconfirm || _inputdeny) /// Confirm
        {
            oUI.pausedSettingsAdjusting = false;
            
            // Play sound
            sfx_play(sndNo, 1.0, random_range(0.95, 1.05));
        }
        else if (_inputh != 0)
        {
            var _currentitem        = oUI.pausedSettingsList[@ oUI.pausedSettingsSelected];
            var _currentitemvalueidx    = _currentitem[@ 1];
            var _currentitemvaluetbl    = _currentitem[@ 2];
            var _valuetblsize = array_length_1d(_currentitemvaluetbl);
            
            // Update value index
            _currentitem[@ 1] = (_currentitemvalueidx + _inputh + _valuetblsize) % _valuetblsize;
            
            // Update values
            switch (oUI.pausedSettingsSelected)
            {
                case eSETTINGS.SFX_VOL:
                    global.sfxVolume = _currentitemvaluetbl[@ _currentitem[@ 1]];
                    sfx_play(sndYes, 1.0, random_range(0.8, 1.2));
                    break;
                case eSETTINGS.MUS_VOL:
                    global.musicVolume = _currentitemvaluetbl[@ _currentitem[@ 1]];
                    music_update_volume(1.0, room_speed * 0.5);
                    
                    // Play sound
                    sfx_play(sndSelect, 1.0, random_range(0.95, 1.05));
                    break;
                case eSETTINGS.UI_FLICKER:
                    oGamevars.miscUIFlicker = _currentitemvaluetbl[@ _currentitem[@ 1]];
                    
                    // Play sound
                    sfx_play(sndSelect, 1.0, random_range(0.95, 1.05));
                    break;
                case eSETTINGS.POSTPROCESSING:
                    if (global.postprocessSupport)
                    {
                        global.postprocess = _currentitemvaluetbl[@ _currentitem[@ 1]];
                        
                        // Play sound
                        sfx_play(sndSelect, 1.0, random_range(0.95, 1.05));
                    }
                    else
                    {
                        _currentitem[@ 1] = 1;
                        global.postprocess = false;
                        
                        // Play sound
                        sfx_play(sndNo, 1.0, random_range(0.95, 1.05));
                    }
                    break;
            }
        }
    }
}

#define knt_state_paused_settings_deadzone
/// Game's deadzone settings state
if (!fsmStateInit)
{
    with (oUI)
    {
        fsm_set("paused_settings_deadzone");
    }
    
    settingsDeadzoneAdjustState = eSETTINGS_DEADZONE_STATE.TEST;
    settingsDeadzoneOld = gamepad_get_axis_deadzone(oInput.inputDevice);
    settingsDeadzoneNew = settingsDeadzoneOld;
}

var _inputconfirm   = oInput.inputConfirm[@ eINPUT.PRS] || oInput.inputConfirmAlt[@ eINPUT.PRS];
var _inputdeny      = oInput.inputDeny[@ eINPUT.PRS] || oInput.inputDenyAlt[@ eINPUT.PRS];
switch (settingsDeadzoneAdjustState)
{
    case eSETTINGS_DEADZONE_STATE.TEST:
        // Check for confirm
        if (_inputconfirm)
        {
            settingsDeadzoneAdjustState = eSETTINGS_DEADZONE_STATE.ADJUST;
            
            // set deadzone to 0
            gamepad_set_axis_deadzone(oInput.inputDevice, 0);
        }
        
        // Check for deny / exit
        if (_inputdeny)
        {
            fsm_set("paused_settings");
            
            // reset deadzone
            gamepad_set_axis_deadzone(oInput.inputDevice, settingsDeadzoneOld);
        }
        break;
    
    case eSETTINGS_DEADZONE_STATE.ADJUST:
        // Calculate new deadzone from joystick input
        settingsDeadzoneNew = min(point_distance(0, 0, oInput.inputH[@ eINPUT.HLD], oInput.inputV[@ eINPUT.HLD]), 1);
        
        // Check for confirm
        if (_inputconfirm)
        {
            settingsDeadzoneAdjustState = eSETTINGS_DEADZONE_STATE.CONFIRM;
        }
        
        // Check for deny / exit
        if (_inputdeny)
        {
            settingsDeadzoneAdjustState = eSETTINGS_DEADZONE_STATE.TEST;
            settingsDeadzoneNew = settingsDeadzoneOld;
            
            // reset deadzone
            gamepad_set_axis_deadzone(oInput.inputDevice, settingsDeadzoneOld);
        }
        break;
    
    case eSETTINGS_DEADZONE_STATE.CONFIRM:
        // Check for confirm
        if (_inputconfirm)
        {
            settingsDeadzoneAdjustState = eSETTINGS_DEADZONE_STATE.TEST;
            
            // set deadzone to new one
            settingsDeadzoneOld = settingsDeadzoneNew;
            gamepad_set_axis_deadzone(oInput.inputDevice, settingsDeadzoneNew);
        }
        
        // Check for deny / exit
        if (_inputdeny)
        {
            settingsDeadzoneAdjustState = eSETTINGS_DEADZONE_STATE.ADJUST;
            settingsDeadzoneNew = settingsDeadzoneOld;
        }
        break;
}

#define knt_state_paused_respawn
/// Game's paused respawn menu state
if (!fsmStateInit)
{
    with (oUI)
    {
        fsm_set("paused_respawn");
    }
}

var _inputconfirm   = oInput.inputConfirm[@ eINPUT.PRS] || oInput.inputConfirmAlt[@ eINPUT.PRS];
var _inputdeny      = oInput.inputDeny[@ eINPUT.PRS] || oInput.inputDenyAlt[@ eINPUT.PRS];

if (!transitionIsHappening)
{
    /// Check for inputs
    _inputconfirm   |= keyboard_check_pressed(ord('Y'));
    _inputdeny      |= keyboard_check_pressed(ord('N'));
    if (_inputdeny)
    {
        // Deny : return to paused menu
        knt_transition("paused_main");
        
        // Play sound
        sfx_play(sndNo, 1.0, random_range(0.95, 1.05));
    }
    else if (_inputconfirm)
    {
        // Confirm : kill player & return to normal/ingame state
        with (oPlayer)
        {
            // Switch to hurt state and damage player
            fsm_set("hurt");
            hp = 0;
            
            // Also apply knockback
            vx = random_range(-4, 4);
            vy = random_range(-4, -2);
        }
        knt_transition("default");
    }
}

#define knt_state_paused_exit
/// Game's paused exit menu state
if (!fsmStateInit)
{
    with (oUI)
    {
        fsm_set("paused_exit");
    }
}

var _inputconfirm   = oInput.inputConfirm[@ eINPUT.PRS] || oInput.inputConfirmAlt[@ eINPUT.PRS];
var _inputdeny      = oInput.inputDeny[@ eINPUT.PRS] || oInput.inputDenyAlt[@ eINPUT.PRS];

if (!transitionIsHappening)
{
    /// Check for inputs
    _inputconfirm = keyboard_check_pressed(ord('Y'));
    _inputdeny    |= keyboard_check_pressed(ord('N'));
    if (_inputdeny)
    {
        // Deny : return to paused menu
        knt_transition("paused_main");
        
        // Play sound
        sfx_play(sndNo, 1.0, random_range(0.95, 1.05));
    }
    else if (_inputconfirm)
    {
        // Confirm : exit game
        sfx_play(sndFleshImpact, 1.0, 0.5);
        game_end();
    }
}

#define knt_state_init
/// Game's initialize bootup state
if (!fsmStateInit)
{
    with (oUI)
    {
        fsm_set("loading");
    }
    debug_log("oKNT - INIT > READING ROOM DATA...");
    initReadingRoomCurrent = room_first;
    initIsReadingRooms = true;
}

/// Iterate through all the rooms and get their data
if (initIsReadingRooms)
{
    if (initReadingRoomCurrent != -1)
    {
        var _roomname = room_get_name(initReadingRoomCurrent);
        debug_log("==> VISITING ROOM `", _roomname, "`...");
        
        /// Move to the room
        if (room != initReadingRoomCurrent)
        {
            debug_log("  => room_goto()");
            room_goto(initReadingRoomCurrent);
        }
        else
        {
            if (instance_exists(oRoom))
            {
                if (oRoom.roomReady)
                {
                    debug_log("  => ROOM IS READY, READING & SETTING DATA...");
                    
                    // Read room's properties : title (name) & subtitle (desc) and dimensions
                    var _roomdata = -1;
                    _roomdata[eROOMDATA.NAME] = oRoom.title;
                    _roomdata[eROOMDATA.DESC] = oRoom.subtitle;
                    _roomdata[eROOMDATA.WID] = room_width;
                    _roomdata[eROOMDATA.HEI] = room_height;
                    
                    // Read tile datas and store it into the tile list
                    var _tiles = -1;
                    var _tilesidx = 0;
                    for (var i=0; i<instance_number(oTileCollision); i++)
                    {
                        var _tileinst = instance_find(oTileCollision, i);
                        var _tiledata = -1;
                        _tiledata[eROOMDATA_TILE.X] = _tileinst.x;
                        _tiledata[eROOMDATA_TILE.Y] = _tileinst.y;
                        _tiledata[eROOMDATA_TILE.OBJ_INDEX] = _tileinst.object_index;
                        _tiles[_tilesidx++] = _tiledata;
                    }
                    _roomdata[eROOMDATA.TILELIST] = _tiles;
                    // debug_log("  => TILES : ", _tilesidx);
                    
                    // Read entity datas and store it into the entity list
                    var _entities = -1;
                    var _entitiesidx = 0;
                    // (pickup items)
                    for (var i=0; i<instance_number(oPickup); i++)
                    {
                        var _entinst = instance_find(oPickup, i);
                        var _entdata = -1;
                        _entdata[eROOMDATA_ENTITY.TYPE]   = eROOMDATA_ENTITY_TYPE.PICKUP;
                        _entdata[eROOMDATA_ENTITY.X]      = _entinst.x;
                        _entdata[eROOMDATA_ENTITY.Y]      = _entinst.y;
                        _entdata[eROOMDATA_ENTITY.DATA]   = makearray(_entinst.type, _entinst.roomIndex);
                        _entities[_entitiesidx++] = _entdata;
                    }
                    // debug_log("  => PICKUPS : ", instance_number(oPickup));
                    // (doors)
                    for (var i=0; i<instance_number(oDoor); i++)
                    {
                        var _entinst = instance_find(oDoor, i);
                        var _entdata = -1;
                        _entdata[eROOMDATA_ENTITY.TYPE]   = eROOMDATA_ENTITY_TYPE.DOORS;
                        _entdata[eROOMDATA_ENTITY.X]      = _entinst.x;
                        _entdata[eROOMDATA_ENTITY.Y]      = _entinst.y;
                        _entdata[eROOMDATA_ENTITY.DATA]   = makearray(_entinst.dest, _entinst.doorID);
                        _entities[_entitiesidx++] = _entdata;
                    }
                    // debug_log("  => DOORS : ", instance_number(oDoor));
                    // (teleports)
                    for (var i=0; i<instance_number(oTeleport); i++)
                    {
                        var _entinst = instance_find(oTeleport, i);
                        var _entdata = -1;
                        _entdata[eROOMDATA_ENTITY.TYPE]   = eROOMDATA_ENTITY_TYPE.TELEPORT;
                        _entdata[eROOMDATA_ENTITY.X]      = _entinst.x;
                        _entdata[eROOMDATA_ENTITY.Y]      = _entinst.y;
                        _entdata[eROOMDATA_ENTITY.DATA]   = _entinst.roomIndex;
                        _entities[_entitiesidx++] = _entdata;
                    }
                    // debug_log("  => TELEPORT : ", instance_number(oTeleport));
                    // (objective object / control station)
                    for (var i=0; i<instance_number(oObjective); i++)
                    {
                        var _entinst = instance_find(oObjective, i);
                        var _entdata = -1;
                        _entdata[eROOMDATA_ENTITY.TYPE]   = eROOMDATA_ENTITY_TYPE.STATION;
                        _entdata[eROOMDATA_ENTITY.X]      = _entinst.x;
                        _entdata[eROOMDATA_ENTITY.Y]      = _entinst.y;
                        _entdata[eROOMDATA_ENTITY.DATA]   = _entinst.object_index;
                        _entities[_entitiesidx++] = _entdata;
                    }
                    // debug_log("  => STATIONS : ", instance_number(oObjective));
                    // (enemies)
                    for (var i=0; i<instance_number(oEnemy); i++)
                    {
                        var _entinst = instance_find(oEnemy, i);
                        var _entdata = -1;
                        _entdata[eROOMDATA_ENTITY.TYPE]   = eROOMDATA_ENTITY_TYPE.ENEMIES;
                        _entdata[eROOMDATA_ENTITY.X]      = _entinst.x;
                        _entdata[eROOMDATA_ENTITY.Y]      = _entinst.y;
                        _entdata[eROOMDATA_ENTITY.DATA]   = _entinst.object_index;
                        _entities[_entitiesidx++] = _entdata;
                    }
                    // debug_log("  => ENEMY : ", instance_number(oEnemy));
                    _roomdata[eROOMDATA.ENTITYLIST] = _entities;
                    debug_log("  =>> [TOTAL : ", _entitiesidx, " ENTITIES]");
                    
                    // Store it into the room data map
                    oGamevars.roomDatas[? initReadingRoomCurrent] = _roomdata;
                    
                    // Set the room's background properties
                    room_set_background_color(initReadingRoomCurrent, c_black, false);
                    
                    // Fetch the next room
                    initReadingRoomCurrent = room_next(initReadingRoomCurrent);
                }
                else
                {
                    debug_log("  => WAITING 'TIL THE ROOM IS READY...");
                }
            }
            else
            {
                debug_log(" !!> ROOM DOESN'T HAVE oROOM!");
                
                // Fetch the next room
                initReadingRoomCurrent = room_next(initReadingRoomCurrent);
            }
        }
    }
    else
    {
        debug_log("oKNT - INIT > READING ROOM DATA DONE...");
        initIsReadingRooms = false;
    }
    
    // Stop all sounds to prevent any entities from making noises while loading
    audio_stop_all();
}
else
{
    with (oUI)
    {
        fsm_set("nothing");
    }
    if (!transitionIsHappening)
    {
        debug_log("oKNT - INIT > CHECKING FOR SHADER SUPPORT...");
        
        /// Check for shader support
        // (ignore the global.debugForceDisablePostprocess, they're for testing the no-postFX effects warning screen)
        if (global.debugForceDisablePostprocess || !shader_is_compiled(shd_postprocessing))
        {
            global.postprocessSupport = false;
            global.postprocess = false;
        }
        else
        {
            global.postprocessSupport = true;
            global.postprocess = true;
        }
        
        /// Switch to title state or no-postFX effects warning
        if (global.postprocessSupport)
        {
            // fsm_set("title");
            knt_transition("seizure_warning");
        }
        else
        {
            // fsm_set("no_filter_warning");
            knt_transition("no_filter_warning");
        }
        debug_log("oKNT - INIT > INIT DONE!");
    }
}

#define knt_state_nofilter_warn
/// Game's no shader support screen state
if (!fsmStateInit)
{
    with (oUI)
    {
        fsm_set("screen_nofilter_warning");
    }
    
    // Go to init room
    room_goto(rm_init);
    
    // Play noise music
    music_play(musNoise, room_speed * 3.0);
}

/// If enter key was pressed, Switch to gameplay
var _inputconfirm = oInput.inputConfirm[@ eINPUT.PRS] || oInput.inputConfirmAlt[@ eINPUT.PRS] || gamepad_button_check_pressed(oInput.inputDevice, gp_start);
if (_inputconfirm)
{
    // fsm_set("title");
    knt_transition("screen_seizure_warning");
    
    // Play sound
    sfx_play(sndYes, 1.0, random_range(0.9, 1.1));
}

#define knt_state_seizure_warn
/// Game's seizure warning screen state
if (!fsmStateInit)
{
    with (oUI)
    {
        fsm_set("screen_seizure_warning");
    }
    
    // Go to init room
    room_goto(rm_init);
    
    // Play noise music
    music_play(musNoise, room_speed * 3.0);
}

/// If enter key was pressed, Switch to gameplay
var _inputconfirm = oInput.inputConfirm[@ eINPUT.PRS] || oInput.inputConfirmAlt[@ eINPUT.PRS] || gamepad_button_check_pressed(oInput.inputDevice, gp_start);
if (_inputconfirm)
{
    // fsm_set("title");
    knt_transition("title");
    
    // Play sound
    sfx_play(sndYes, 1.0, random_range(0.9, 1.1));
}

#define knt_state_title
/// Game's title screen state
if (!fsmStateInit)
{
    with (oUI)
    {
        fsm_set("title");
    }
    
    // Go to init room
    room_goto(rm_init);
    
    // Delete gameplay instances
    instance_destroy(oEntity);
    
    // Play noise music
    music_play(musNoise, room_speed * 3.0);
}

/// If enter key was pressed, Switch to gameplay
if (!transitionIsHappening)
{
    var _inputconfirm   = oInput.inputConfirm[@ eINPUT.PRS] || oInput.inputConfirmAlt[@ eINPUT.PRS] || gamepad_button_check_pressed(oInput.inputDevice, gp_start);
    var _inputdeny      = oInput.inputDeny[@ eINPUT.PRS] || oInput.inputDenyAlt[@ eINPUT.PRS];
    if (_inputconfirm)
    {
        // fsm_set("intro");
        knt_transition("intro");
        
        // Play sound
        sfx_play(sndYes, 1.0, random_range(0.9, 1.1));
    }
}

#define knt_state_intro
/// Game's intro screen state
if (!fsmStateInit)
{
    with (oUI)
    {
        fsm_set("intro");
    }
    introCutsceneReady = false;
    introCutsceneIdx = 0;
    
    /// Check for intro skip
    if (global.debugSkipIntro)
    {
        // Switch to next state
        fsm_set("ingame_intro");
    }
    
    /// Set game begin date
    playtimeBeginDate = date_current_datetime();
}

if (fsmStateCtr > introCutsceneWaitFrames)
{
    introCutsceneReady = true;
    
    var _inputconfirm = oInput.inputConfirm[@ eINPUT.PRS] || oInput.inputConfirmAlt[@ eINPUT.PRS];
    var _inputskip = keyboard_check(vk_shift);
    
    if (_inputconfirm && !transitionIsHappening)
    {
        fsmStateCtr = 0;
        introCutsceneIdx++;
        if (_inputskip || introCutsceneIdx >= sprite_get_number(sprUICutsceneBegin))
        {
            introCutsceneIdx = clamp(introCutsceneIdx, 0, sprite_get_number(sprUICutsceneBegin) - 1);
            
            // Switch to next state
            // fsm_set("hub_respawn");
            knt_transition("ingame_intro");
            
            // Enable tutorial
            ingameTutorialInProgress = true;
            ingameTutorialState = eTUTORIAL_STATE.MOVE;
        }
        
        // Play sound
        sfx_play(sndYes, 1.0, random_range(0.9, 1.1));
    }
}

#define knt_state_ending
/// Game's ending screen state
if (!fsmStateInit)
{
    with (oUI)
    {
        fsm_set("ending");
    }
    
    // Go to init room
    room_goto(rm_init);
    
    // Delete gameplay instances
    instance_destroy(oEntity);
    
    // Play noise music
    music_play(musNoise, 1.0, room_speed * 3.0);
    
    endingCutsceneReady = false;
}

/// Check for state switch
if (fsmStateCtr > room_speed)
{
    endingCutsceneReady = true;
    
    var _inputconfirm = oInput.inputConfirm[@ eINPUT.PRS] || oInput.inputConfirmAlt[@ eINPUT.PRS];
    if (_inputconfirm && !transitionIsHappening)
    {
        // Switch to next state
        knt_transition("credits");
        
        // Play sound
        sfx_play(sndPrompt, 1.0, random_range(0.9, 1.1));
    }
}

#define knt_state_credits
/// Game's credits screen state
if (!fsmStateInit)
{
    with (oUI)
    {
        fsm_set("credits");
    }
    
    // Go to init room
    room_goto(rm_init);
    
    // Delete gameplay instances
    instance_destroy(oEntity);
    
    // Play noise music
    music_play(musNoise, 0.25, room_speed * 3.0);
}

/// Check for state switch
if (fsmStateCtr > room_speed * 3)
{
    var _inputconfirm = oInput.inputConfirm[@ eINPUT.PRS] || oInput.inputConfirmAlt[@ eINPUT.PRS];
    if (_inputconfirm) // Return to menu
    {
        game_end();
    }
}

#define knt_state_ingame_ending
/// Game's ingame ending cutscene state
if (!fsmStateInit)
{
    debug_log("oKNT STATE_INGAME_ENDING() > ENDING CUTSCENE PLAY");
    with (oUI)
    {
        fsm_set("ingame_ending");
    }
    
    // Turn down the voluem
    music_update_volume(0.5, room_speed * 3.0);
    
    ingameEndingCutsceneState = eINGAMEENDING_STATE.SHOWMSG1;
    ingameEndingCutsceneStateCtr = 0;
}

// Update ending cutscene
switch (ingameEndingCutsceneState)
{
    case eINGAMEENDING_STATE.SHOWMSG1:
        ingameEndingCutsceneStateCtr++;
        if (ingameEndingCutsceneStateCtr > ingameEndingCutsceneMsgFrames)
        {
            // Switch to next state : show message #2
            ingameEndingCutsceneStateCtr = 0;
            ingameEndingCutsceneState = eINGAMEENDING_STATE.SHOWMSG2;
        }
        break;
        
    case eINGAMEENDING_STATE.SHOWMSG2:
        ingameEndingCutsceneStateCtr++;
        if (ingameEndingCutsceneStateCtr > ingameEndingCutsceneMsgFrames)
        {
            // Switch to next state : fade screen
            ingameEndingCutsceneStateCtr = 0;
            ingameEndingCutsceneState = eINGAMEENDING_STATE.FADESCREEN;
        }
        break;
    
    case eINGAMEENDING_STATE.SHOWSCREEN:
        ingameEndingCutsceneStateCtr = 0;
        ingameEndingCutsceneState = eINGAMEENDING_STATE.FADESCREEN;
        break;
        
    case eINGAMEENDING_STATE.FADESCREEN:
        ingameEndingCutsceneStateCtr++;
        if (ingameEndingCutsceneStateCtr > ingameEndingCutsceneFadeFrames)
        {
            // Switch to next state : cutscene done
            ingameEndingCutsceneState = eINGAMEENDING_STATE.DONE;
        }
        break;
        
    case eINGAMEENDING_STATE.DONE:
        // Switch to next state : ending
        if (!transitionIsHappening)
            knt_transition("ending");
        break;
}

#define knt_state_hub_firstspawn
/// Game's hub room intro cutscene state
if (!fsmStateInit)
{
    debug_log("oKNT STATE_HUB_FIRSTSPAWN() > STATE_HUB_FIRSTSPAWN INIT");
    with (oUI)
    {
        fsm_set("ingame_intro");
    }
    
    room_goto(rm_hub);
    
    // Delete player
    instance_destroy(oPlayer);
    
    // Play ambient music music
    music_play(musNoise, 1.0, room_speed * 6.0);
    
    ingameIntroCutsceneState = eINGAMEINTRO_STATE.SHOWMSG;
    ingameIntroCutsceneStateCtr = 0;
    
    // Unpause the game's physics
    global.isPhysicsPaused = false;
}
else
{
    if (oRoom.roomReady)
    {
        switch (ingameIntroCutsceneState)
        {
            case eINGAMEINTRO_STATE.SHOWMSG:
                // Set camera position
                oCamera.x = (oObjective.bbox_left + oObjective.bbox_right) * 0.5;
                oCamera.y = (oObjective.bbox_top + oObjective.bbox_bottom) * 0.5;
                oCamera.followTarget = noone;
                
                ingameIntroCutsceneStateCtr++;
                if (ingameIntroCutsceneStateCtr > ingameIntroCutsceneMsgFrames)
                {
                    debug_log("oKNT STATE_HUB_FIRSTSPAWN() > SPAWNING PLAYER");
                    
                    ingameIntroCutsceneStateCtr = 0;
                    ingameIntroCutsceneState = eINGAMEINTRO_STATE.DEPLOY;
                    
                    // Spawn player
                    // (get the spawn coordinates)
                    var _spawnx = room_width * 0.5, _spawny = room_height * 0.5; // fallback spawn coordinates : room center
                    if (instance_exists(oPlayerSpawn)) // player spawner
                    {
                        _spawnx = oPlayerSpawn.x;
                        _spawny = oPlayerSpawn.y;
                    }
                    
                    // (spawn player instance)
                    instance_create(_spawnx, _spawny, oPlayer);
                    
                    // Set players state & update upgrades stats
                    with (oPlayer)
                    {
                        fsmState = "nada";
                        fsm_set("spawn_fall");
                        event_user(1);
                        
                        // Restore player HP
                        hp = hpMax;
                    }
                    
                    // Enable hub's teleport
                    // (check for duplicate teleporter)
                    var _teleportlist = oGamevars.teleportList;
                    var _hasdupe      = false;
                    for (var i=0; i<ds_list_size(_teleportlist); i++)
                    {
                        var _tpdata = _teleportlist[| i];
                        if (_tpdata[@ eTP.ROOM] == room)
                        {
                            _hasdupe = true;
                            break;
                        }
                    }
                    
                    if (!_hasdupe)
                    {
                        var _data = -1;
                        _data[eTP.NAME] = oRoom.title;
                        _data[eTP.ROOM] = room;
                        ds_list_add(oGamevars.teleportList, _data);
                        
                        // Record the room event to ensure the teleport is active
                        roomevents_add(eEVENT.UNLOCK_TP);
                        debug_log("oKNT - TELEPORT_SELECT > ACTIVATED TP FOR ROOM ", room_get_name(room), " & WRITTEN THE ROOM EVENT");
                    }
                    else
                    {
                        debug_log("oKNT - TELEPORT_SELECT > ROOM ", room_get_name(room), " ALREADY HAS TELEPORT ENABLED");
                    }
                    oTeleport.active = true;
                }
                break;
            
            case eINGAMEINTRO_STATE.DEPLOY:
                if (oPlayer.contactB)
                {
                    // Assign camera to player
                    oCamera.followTarget = oPlayer;
                    
                    // After player has landed & few frames had passed
                    ingameIntroCutsceneStateCtr++;
                    if (ingameIntroCutsceneStateCtr > ingameIntroCutsceneDeployWaitFrames)
                    {
                        ingameIntroCutsceneState = eINGAMEINTRO_STATE.DONE;
                    }
                }
                break;
            
            case eINGAMEINTRO_STATE.DONE:
                // Switch state to room enter state
                fsm_set("room_enter");
                
                // Play ingame music
                music_play(musIngame, 1.0, room_speed * 6.0);
                break;
        }
    }
}

#define knt_state_hub_respawn
/// Game's hub room respawn state
if (!fsmStateInit)
{
    // (store current room index to source room variable)
    debug_log("oKNT > STATE_HUB_RESPAWN INIT");
    room_goto(rm_hub);
    
    // Play ingame music
    music_play(musIngame, 1.0, room_speed * 6.0);
    
    with (oUI)
    {
        fsm_set("nothing");
    }
}
else
{
    debug_log("oKNT > oROOM.roomREADY : ", oRoom.roomReady);
    if (oRoom.roomReady)
    {
        // Get the spawn coordinates
        var _spawnx = room_width * 0.5, _spawny = room_height * 0.5; // fallback spawn coordinates : room center
        if (instance_exists(oPlayerSpawn)) // player spawner
        {
            _spawnx = oPlayerSpawn.x;
            _spawny = oPlayerSpawn.y;
        }
        
        if (instance_exists(oPlayer))
        {
            // Teleport player
            oPlayer.x = _spawnx;
            oPlayer.y = _spawny;
        }
        else
        {
            // (player doesn't exists; spawn a new one)
            instance_create(_spawnx, _spawny, oPlayer);
        }
        
        // Set players state & update upgrades stats
        with (oPlayer)
        {
            fsmState = "nada";
            fsm_set("spawn_fall");
            event_user(1);
            
            // Restore player HP
            hp = hpMax;
        }
        
        
        // Assign & teleport camera to player
        oCamera.x = oPlayer.x;
        oCamera.y = oPlayer.y;
        oCamera.followTarget = oPlayer;
        
        // Switch state to room enter state
        fsm_set("room_enter");
        
        /// Enable hub's teleport
        // Check for duplicate teleporter
        var _teleportlist = oGamevars.teleportList;
        var _hasdupe      = false;
        for (var i=0; i<ds_list_size(_teleportlist); i++)
        {
            var _tpdata = _teleportlist[| i];
            if (_tpdata[@ eTP.ROOM] == room)
            {
                _hasdupe = true;
                break;
            }
        }
        
        if (!_hasdupe)
        {
            var _data = -1;
            _data[eTP.NAME] = oRoom.title;
            _data[eTP.ROOM] = room;
            ds_list_add(oGamevars.teleportList, _data);
            
            // Record the room event to ensure the teleport is active
            roomevents_add(eEVENT.UNLOCK_TP);
            debug_log("oKNT - TELEPORT_SELECT > ACTIVATED TP FOR ROOM ", room_get_name(room), " & WRITTEN THE ROOM EVENT");
        }
        else
        {
            debug_log("oKNT - TELEPORT_SELECT > ROOM ", room_get_name(room), " ALREADY HAS TELEPORT ENABLED");
        }
        oTeleport.active = true;
    }
}

#define knt_state_objective_menu
/// Game's objective menu state
if (!fsmStateInit)
{
    with (oUI)
    {
        fsm_set("objective_main");
    }
    
    // Pause the game's physics
    global.isPhysicsPaused = true;
    
    // Unflag the interaction request flag
    ingameObjectiveInteractionRequest = false;
    
    // Reset players state & fire default animation
    with (oPlayer)
    {
        fsm_set("default");
        anim_fire("idle");
    }
    
    // Reset menu
    oUI.objectiveMenuSelected = 0;
}

if (!transitionIsHappening)
{
    /// Check for inputs
    var _inputv = oInput.inputV[@ eINPUT.PRS]; // keyboard_check_pressed(vk_down) - keyboard_check_pressed(vk_up);
    var _inputconfirm   = oInput.inputConfirm[@ eINPUT.PRS] || oInput.inputConfirmAlt[@ eINPUT.PRS];
    var _inputdeny      = oInput.inputDeny[@ eINPUT.PRS] || oInput.inputDenyAlt[@ eINPUT.PRS];
    
    if (_inputconfirm) /// Select menu
    {
        var _menudata = oUI.objectiveMenuList[@ oUI.objectiveMenuSelected];
        knt_transition(_menudata[@ 0], 4);
        
        // Play sound
        sfx_play(sndYes, 1.0, random_range(0.95, 1.05));
    }
    else if (_inputv != 0) /// Navigate menu
    {
        with (oUI)
        {
            var _listsz = array_length_1d(objectiveMenuList);
            objectiveMenuSelected = (objectiveMenuSelected + _inputv + _listsz) % _listsz;
            
            // Play sound
            sfx_play(sndSelect, 1.0, random_range(0.95, 1.05));
        }
    }
    else if (_inputdeny) /// Unpause request
    {
        // Switch state to main state
        knt_transition("default", room_speed * 0.25);
        
        // Unpause the game's physics
        global.isPhysicsPaused = false;
        
        // Play sound
        sfx_play(sndNo, 1.0, random_range(0.95, 1.05));
    }
}

#define knt_state_powercell_deposit
/// Game's power-cell deposit state
if (!fsmStateInit)
{
    with (oUI)
    {
        fsm_set("powercell_deposit");
    }
}

var _inputdeny = oInput.inputDeny[@ eINPUT.PRS];

/// Update deposit mechanic
var _keyslotids = oInput.invKeyslotsIDList;
var _keyslots   = oInput.invKeyslots;
if (_inputdeny) // User pressed the escape key
{
    // Switch state to objective menu state
    fsm_set("objective_main");
    
    // Play sound
    sfx_play(sndNo, 1.0, random_range(0.9, 1.1));
    
    // Reset players state & fire default animation
    with (oPlayer)
    {
        fsm_set("default");
        anim_fire("idle");
    }
}
else
{
    for (var i=0; i<ds_list_size(_keyslotids); i++)
    {
        var _slotdata       = _keyslots[? _keyslotids[| i]];
        var _slotkeystate   = _slotdata[@ eINVKEY.KEYSTATE];
        if (_slotkeystate[@ eINPUT.PRS] && _slotdata[@ eINVKEY.ITEM] == eITEM.ITEM_POWERCELL)
        {
            // Deposit the powercell & increment objective progress
            oGamevars.progress++;
            
            // 'Delete' the item from inventory
            _slotdata[@ eINVKEY.ITEM] = eITEM.NONE;
            
            // Play sound
            sfx_play(sndYes, 1.0, random_range(0.9, 1.1));
        }
    }
}

#define knt_state_item_relocate_select_item
/// Game's item relocation selecting state
if (!fsmStateInit)
{
    with (oUI)
    {
        fsm_set("objective_item_relocate_select_inv");
    }
    
    itemRelocateSlotIsPicked = false;
    itemRelocateSlotSelected = "";
}

var _inputdeny = oInput.inputDeny[@ eINPUT.PRS];

/// Update assigning mechanic
var _keyslotids = oInput.invKeyslotsIDList;
var _keyslots   = oInput.invKeyslots;
if (!itemRelocateSlotIsPicked) // Check for each key slots input
{
    if (_inputdeny) // User pressed the escape key
    {
        // Switch state to normal state
        fsm_set("objective_main");
        
        // Play sound
        sfx_play(sndNo, 1.0, random_range(0.9, 1.1));
    }
    else
    {
        for (var i=0; i<ds_list_size(_keyslotids); i++)
        {
            var _slotid         = _keyslotids[| i];
            var _slotdata       = _keyslots[? _slotid];
            var _slotkeystate   = _slotdata[@ eINVKEY.KEYSTATE];
            if (_slotkeystate[@ eINPUT.PRS] && _slotdata[@ eINVKEY.ITEM] != eITEM.NONE)
            {
                itemRelocateSlotIsPicked = true;
                itemRelocateSlotSelected = _slotid;
                
                // Play sound
                sfx_play(sndSelect, 1.0, 1.0);
                break;
            }
        }
    }
}
else // Confirm the assigning
{
    var _otherkey = false;
    for (var i=0; i<ds_list_size(_keyslotids); i++)
    {
        var _slotid         = _keyslotids[| i];
        var _slotdata       = _keyslots[? _slotid];
        var _slotkeystate   = _slotdata[@ eINVKEY.KEYSTATE];
        if (_slotkeystate[@ eINPUT.PRS] && _slotid != itemRelocateSlotSelected)
        {
            _otherkey = true;
            break;
        }
    }
    
    // Check for cancel
    if (_inputdeny || _otherkey) // User pressed the escape key
    {
        // Cancel selecting
        itemRelocateSlotIsPicked = false;
        
        // Play sound
        sfx_play(sndNo, 1.0, random_range(0.9, 1.1));
    }
    else
    {
        var _slotdata     = _keyslots[? itemRelocateSlotSelected];
        var _slotkeystate = _slotdata[@ eINVKEY.KEYSTATE];
        var _slotitem     = _slotdata[@ eINVKEY.ITEM];
        if (_slotkeystate[@ eINPUT.PRS] && _slotitem != eITEM.NONE) // Check if the user has pressed the keyslot & the slot has item
        {
            // User has selected the item, switch state to relocation room selecting state
            knt_transition("objective_item_relocate_select_room");
            
            // Play sound
            sfx_play(sndYes, 1.0, random_range(0.9, 1.1));
        }
    }
}

#define knt_state_item_relocate_select_room
/// Game's item relocation room selecting state
if (!fsmStateInit)
{
    with (oUI)
    {
        fsm_set("objective_item_relocate_select_room");
    }
    
    knt_relocate_select_room(0);
    itemRelocateRoomIsSelecting = true;
    itemRelocateRoomCurrentItemSelectedIdx = 0;
}

/// Check for input
var _inputconfirm = oInput.inputConfirm[@ eINPUT.PRS] || oInput.inputConfirmAlt[@ eINPUT.PRS];
var _inputdeny    = oInput.inputDeny[@ eINPUT.PRS] || oInput.inputDenyAlt[@ eINPUT.PRS];
var _inputh = oInput.inputH[@ eINPUT.PRS];
if (itemRelocateRoomIsSelecting)
{
    /// Update room select
    if (_inputdeny)
    {
        // User requests exit
        if (!transitionIsHappening)
        {
            knt_transition("objective_item_relocate_select_item");
        }
    }
    else
    {
        
        // Check for display room cycle input
        if (_inputh != 0)
        {
            var _visitedrooms = oGamevars.roomVisited;
            var _nextroomidx  = (itemRelocateRoomCurrentIdx + _inputh + ds_list_size(_visitedrooms)) % ds_list_size(_visitedrooms);
            var _nextroom     = oGamevars.roomVisited[| _nextroomidx];
            
            if (_nextroom != undefined)
            {
                knt_relocate_select_room(_nextroomidx);
                
                // Play sound
                sfx_play(sndSelect, 1.0, 1.0);
            }
            else
            {
                // Play sound
                sfx_play(sndNo, 1.0, 1.0);
            }
        }
        
        // Check for confirm
        if (_inputconfirm)
        {
            if (itemRelocateRoomCurrentData != undefined && ds_list_size(itemRelocateRoomCurrentItemsAvailable) > 0)
            {
                itemRelocateRoomIsSelecting = false;
                itemRelocateRoomCurrentItemSelectedIdx = 0;
                
                // Play sound
                sfx_play(sndYes, 1.0, 1.0);
            }
            else
            {
                // Play sound
                sfx_play(sndNo, 1.0, 1.0);
            }
        }
    }
}
else
{
    /// Update item select
    if (_inputdeny)
    {
        // User requests exit
        if (!transitionIsHappening)
        {
            itemRelocateRoomIsSelecting = true;
        }
    }
    else
    {
        // Check for item selection input
        if (_inputh != 0)
        {
            var _availableitem = itemRelocateRoomCurrentItemsAvailable;
            var _nextitemidx   = (itemRelocateRoomCurrentItemSelectedIdx + _inputh + ds_list_size(_availableitem)) % ds_list_size(_availableitem);
            var _nextitem      = _availableitem[| _nextitemidx];
            
            if (_nextitem != undefined)
            {
                itemRelocateRoomCurrentItemSelectedIdx = _nextitemidx;
                
                // Play sound
                sfx_play(sndSelect, 1.0, 1.0);
            }
            else
            {
                // Play sound
                sfx_play(sndNo, 1.0, 1.0);
            }
        }
        
        // Check for confirm
        if (_inputconfirm)
        {
            // swap the item from selected keyslots and the selected item
            var _swapsuccess = false;
            
            var _selecteditem = itemRelocateRoomCurrentItemsAvailable[| itemRelocateRoomCurrentItemSelectedIdx];
            if (_selecteditem != undefined)
            {
                var _itemdata = _selecteditem[@ eROOMDATA_ENTITY.DATA];
                var _itemtype = _itemdata[@ 0];
                if (_itemtype != eITEM.NONE && _itemdata[@ 1])
                {
                    var _keyslotdata = inv_key_get(itemRelocateSlotSelected);
                    var _keyslotitemstr = oGamevars.itemStr[@ _keyslotdata[@ eINVKEY.ITEM]];
                    var _roomitemstr = oGamevars.itemStr[@ _itemtype];
                    debug_log("oKNT RELOCATE_ROOM() > SWAPPING ITEM ", _roomitemstr, " TO ", _keyslotitemstr[@ 0], " AT ROOM ", room_get_name(itemRelocateRoomCurrent));
                    
                    roomevents_add_at(itemRelocateRoomCurrent, eEVENT.SWAP_PICKUP_ITEM, _keyslotdata[@ eINVKEY.ITEM], _selecteditem[@ eROOMDATA_ENTITY.X], _selecteditem[@ eROOMDATA_ENTITY.Y]);
                    _keyslotdata[@ eINVKEY.ITEM] = _itemtype;
                    
                    // Update player upgrade status
                    with (oPlayer)
                    {
                        event_user(1);
                    }
            
                    _swapsuccess = true;
                }
            }
            
            if (_swapsuccess)
            {
                // Switch state to objective menu state
                knt_transition("objective_main");
                
                // Play sound
                sfx_play(sndPrompt, 1.0, 1.0);
            }
            else
            {
                // Play sound
                sfx_play(sndNo, 1.0, 1.0);
            }
        }
        
    }
}

#define knt_state_room_move
/// Game's room move state
// For now just instantly teleport to next room
if (!fsmStateInit)
{
    // (store current room index to source room variable)
    debug_log("oKNT > STATE_ROOM_MOVE INIT");
    ingameRoomTransitionSource = room;
    room_goto(ingameRoomTransitionDest);
    
    // (disable room transition request)
    ingameRoomTransitionRequest = false;
}
else
{
    debug_log("oKNT > oROOM.roomREADY : ", oRoom.roomReady);
    if (oRoom.roomReady)
    {
        // Teleport player to door that has same door ID
        // (find the door with desired door ID)
        var _door = noone;
        with (oDoor)
        {
            if (doorID == other.ingameRoomTransitionDoorID)
            {
                _door = id;
            }
        }
        // (if there's none then find the door where destination is same as room transition source)
        if (!instance_exists(_door))
        {
            with (oDoor)
            {
                if (dest == other.ingameRoomTransitionSource)
                {
                    _door = id;
                }
            }
        }
        
        // Get the spawn coordinates
        var _spawnx = room_width * 0.5, _spawny = room_height * 0.5; // fallback spawn coordinates : room center
        if (instance_exists(_door)) // door
        {
            _spawnx = (_door.bbox_left + _door.bbox_right) * 0.5;
            _spawny = (_door.bbox_top + _door.bbox_bottom) * 0.5;
        }
        else
        {
            // (door with destination of previous room doesn't exist; screw it, choose a random door)
            var _door = instance_find(oDoor, irandom_range(0, instance_number(oDoor) - 1));
            if (instance_exists(_door))
            {
                _spawnx = (_door.bbox_left + _door.bbox_right) * 0.5;
                _spawny = (_door.bbox_top + _door.bbox_bottom) * 0.5;
            }
        }
        
        if (instance_exists(oPlayer))
        {
            // Teleport player
            oPlayer.x = _spawnx;
            oPlayer.y = _spawny;
        }
        else
        {
            // (player doesn't exists; spawn a new one)
            instance_create(_spawnx, _spawny, oPlayer);
        }
        
        // Set players state & update upgrades stats
        with (oPlayer)
        {
            fsm_set("default");
            event_user(1);
        }
        
        // Assign & teleport camera to player
        oCamera.x = oPlayer.x;
        oCamera.y = oPlayer.y;
        oCamera.followTarget = oPlayer;
        
        // Switch state to room enter state
        fsm_set("room_enter");
    }
}

#define knt_state_room_enter
with (oUI)
{
    fsm_set("nothing");
}

/// Game's room entering state
// For now just show message & instantly switch to next state
debug_log("oKNT > SWITCH TO DEFAULT");

// Flag room as visited if the room isn't in the visited room list
if (ds_list_find_index(oGamevars.roomVisited, room) == -1)
    ds_list_add(oGamevars.roomVisited, room);

// (show message)
ui_show_message(oRoom.title, oRoom.subtitle, room_speed * 2.0);

// (switch state to normal state)
fsm_set("default");

#define knt_state_item_get
/// Game's item get cutscene
if (!fsmStateInit)
{
    with (oUI)
    {
        fsm_set("item_get");
    }
    oUI.itemGetType = ingameItemPickupType;
}

var _inputconfirm = oInput.inputConfirm[@ eINPUT.PRS] || oInput.inputConfirmAlt[@ eINPUT.PRS];

/// Check for state switch
// Certain time has passed & user pressed the continue input
if (fsmStateCtr > oGamevars.animUIItemGetWaitFrames)
{
    if (_inputconfirm)
    {
        // Play sound
        sfx_play(sndYes, 1.0, random_range(0.9, 1.1));
        
        // If the pickup isn't keyboard upgrade, continue to item assigning
        if (ingameItemPickupType != eITEM.UPGRADE_KEY_UNLOCK)
        {
            fsm_set("item_assign");
            
            // (pass the item info)
            ingameItemAssignItemType = ingameItemPickupType;
        }
        else
        {
            // Otherwise, increment key unlock level & update it
            oInput.invKeysLevel = clamp(oInput.invKeysLevel + 1, 0, array_length_1d(oInput.invKeysUnlock) - 1);
            
            if (instance_exists(ingameItemPickupInst))
            {
                // Record the room event to ensure the item is gone for good even in the next visit
                roomevents_add(eEVENT.DELETE_OBJ, ingameItemPickupInst.object_index, ingameItemPickupInst.x, ingameItemPickupInst.y);
                debug_log("oKNT - ITEM_ASSIGN > DESTROYED OG KEYSLOT UPGRADE ITEM & WRITTEN THE ROOM EVENT");
                
                instance_destroy(ingameItemPickupInst);
            }
            
            // User has used the item, switch state to normal state and disable the request flag
            fsm_set("default");
            ingameItemPickupRequest = false;
            
            // Update keyslots
            with (oInput)
            {
                event_user(1);
            }
            
            // Reset players state & fire default animation
            with (oPlayer)
            {
                fsm_set("default");
                anim_fire("idle");
            }
        }
    }
    
    oUI.itemGetReady = true;
}

#define knt_state_item_assign
/// Game's item assign-to-key-slot cutscene
if (!fsmStateInit)
{
    with (oUI)
    {
        fsm_set("item_assign");
    }
    oUI.itemGetType = ingameItemAssignItemType;
    
    ingameItemAssignSelected = false;
    ingameItemAssignSelectedIdx = 0;
}

var _inputdeny = oInput.inputDeny[@ eINPUT.PRS];

/// Update assigning mechanic
var _keyslotids = oInput.invKeyslotsIDList;
var _keyslots   = oInput.invKeyslots;
if (!ingameItemAssignSelected) // Check for each key slots input
{
    if (_inputdeny) // User pressed the escape key
    {
        // Switch state to normal state and disable the request flag
        fsm_set("default");
        ingameItemPickupRequest = false;
        
        // Play sound
        sfx_play(sndNo, 1.0, random_range(0.9, 1.1));
    }
    else
    {
        for (var i=0; i<ds_list_size(_keyslotids); i++)
        {
            var _slotid         = _keyslotids[| i];
            var _slotdata       = _keyslots[? _slotid];
            var _slotkeystate   = _slotdata[@ eINVKEY.KEYSTATE];
            if (_slotkeystate[@ eINPUT.PRS] && _slotdata[@ eINVKEY.AVAILABLE])
            {
                ingameItemAssignSelected        = true;
                ingameItemAssignSelectedSlotID  = _slotid;
                break;
                
                // Play sound
                sfx_play(sndSelect, 1.0, 1.0);
            }
        }
    }
}
else // Confirm the assigning
{
    var _otherkey = false;
    for (var i=0; i<ds_list_size(_keyslotids); i++)
    {
        var _slotid         = _keyslotids[| i];
        var _slotdata       = _keyslots[? _slotid];
        var _slotkeystate   = _slotdata[@ eINVKEY.KEYSTATE];
        if (_slotkeystate[@ eINPUT.PRS] && _slotid != ingameItemAssignSelectedSlotID)
        {
            _otherkey = true;
            break;
        }
    }
    
    // Check for cancel
    if (_inputdeny || _otherkey) // User pressed the escape key or other keyslot
    {
        // Cancel selecting
        ingameItemAssignSelected = false;
        
        // Play sound
        sfx_play(sndNo, 1.0, random_range(0.9, 1.1));
    }
    else
    {
        var _slotdata     = _keyslots[? ingameItemAssignSelectedSlotID];
        var _slotkeystate = _slotdata[@ eINVKEY.KEYSTATE];
        if (_slotkeystate[@ eINPUT.PRS])
        {
            // Check if the keyslot is already occupied
            var _originalitem = _slotdata[@ eINVKEY.ITEM];
            if (_originalitem != eITEM.NONE)
            {
                // Assign the item to key & spawn new pickup instance
                _slotdata[@ eINVKEY.ITEM] = ingameItemAssignItemType;
                
                // If the item's origin is pickup item...
                if (ingameItemPickupRequest)
                {
                    // Swap the pickup instance
                    if (instance_exists(ingameItemPickupInst))
                    {
                        debug_log("oKNT - ITEM_ASSIGN > SWAPPED OG PICKUP ITEM & WRITTEN THE ROOM EVENT [", ingameItemPickupInst.x, ", ", ingameItemPickupInst.y, "]");
                        debug_log(" > OG PICKUP ITEM : ", ingameItemPickupInst.type, " | SWAPPED TO : ", _originalitem);
                        ingameItemPickupInst.type = _originalitem;
                        
                        // Record the room event to ensure the item is swapped for good even in the next visit
                        roomevents_add(eEVENT.SWAP_PICKUP_ITEM, _originalitem, ingameItemPickupInst.x, ingameItemPickupInst.y);
                    }
                }
            }
            else
            {
                // Assign the item to key & destroy the pickup instance if there's any
                _slotdata[@ eINVKEY.ITEM] = ingameItemAssignItemType;
                
                // If the item's origin is pickup item...
                if (ingameItemPickupRequest)
                {
                    // Delete the pickup instance
                    if (instance_exists(ingameItemPickupInst))
                    {
                        // Record the room event to ensure the item is gone for good even in the next visit
                        roomevents_add(eEVENT.DELETE_OBJ, ingameItemPickupInst.object_index, ingameItemPickupInst.x, ingameItemPickupInst.y);
                        debug_log("oKNT - ITEM_ASSIGN > DESTROYED OG PICKUP ITEM & WRITTEN THE ROOM EVENT");
                        
                        instance_destroy(ingameItemPickupInst);
                    }
                }
            }

            // User has assigned the item, switch state to normal state and disable the request flag
            fsm_set("default");
            ingameItemPickupRequest = false;
            
            // Update player upgrade status
            with (oPlayer)
            {
                event_user(1);
            }
            
            // Play sound
            sfx_play(sndYes, 1.0, random_range(0.9, 1.1));
        }
    }
}

/// Check for state exit
if (fsmStateNext != "item_assign")
{
    // Reset players state & fire default animation
    with (oPlayer)
    {
        fsm_set("default");
        anim_fire("idle");
    }
}

#define knt_state_teleport_select
/// Game's teleport selecting state
if (!fsmStateInit)
{
    with (oUI)
    {
        fsm_set("teleport_select");
    }
    ingameTeleportSelectIdx = 0;
    
    // Enable teleporter & add to teleporter list
    if (instance_exists(ingameTeleportSelectRequestInst))
    {
        if (!ingameTeleportSelectRequestInst.active)
        {
            // Check for duplicate teleporter
            var _teleportlist = oGamevars.teleportList;
            var _hasdupe      = false;
            for (var i=0; i<ds_list_size(_teleportlist); i++)
            {
                var _tpdata = _teleportlist[| i];
                if (_tpdata[@ eTP.ROOM] == room)
                {
                    _hasdupe = true;
                    break;
                }
            }
            
            if (!_hasdupe)
            {
                var _data = -1;
                _data[eTP.NAME] = oRoom.title;
                _data[eTP.ROOM] = room;
                ds_list_add(oGamevars.teleportList, _data);
                
                // Record the room event to ensure the teleport is active
                roomevents_add(eEVENT.UNLOCK_TP);
                debug_log("oKNT - TELEPORT_SELECT > ACTIVATED TP FOR ROOM ", room_get_name(room), " & WRITTEN THE ROOM EVENT");
            }
            else
            {
                debug_log("oKNT - TELEPORT_SELECT > ROOM ", room_get_name(room), " ALREADY HAS TELEPORT ENABLED");
            }
            ingameTeleportSelectRequestInst.active = true;
        }
    }
}

var _inputconfirm   = oInput.inputConfirm[@ eINPUT.PRS] || oInput.inputConfirmAlt[@ eINPUT.PRS];
var _inputdeny      = oInput.inputDeny[@ eINPUT.PRS] || oInput.inputDenyAlt[@ eINPUT.PRS];

/// Update teleport selecting mechanic
var _teleportlist       = oGamevars.teleportList;
var _teleportlistsize   = ds_list_size(_teleportlist);
if (_inputdeny) // User pressed the escape key
{
    // Switch state to normal state and disable the request flag
    fsm_set("default");
    ingameTeleportSelectRequest = false;
    
    // Play sound
    sfx_play(sndNo, 1.0, random_range(0.9, 1.1));
}
else
{
    // Check for vertical input
    var _inputv = oInput.inputV[@ eINPUT.PRS]; // keyboard_check_pressed(vk_down) - keyboard_check_pressed(vk_up);
    if (_inputv != 0)
    {
        ingameTeleportSelectIdx = (ingameTeleportSelectIdx + _teleportlistsize + _inputv) % _teleportlistsize;
    }
    
    // Check for confirm
    var _tpdata = _teleportlist[| ingameTeleportSelectIdx];
    var _tproom = _tpdata[@ eTP.ROOM];
    if (_inputconfirm && _tproom != room && !transitionIsHappening)
    {
        knt_transition("teleport", room_speed * 0.5);
        
        // Pass value for teleportation state
        ingameTeleportDest = _tpdata[@ eTP.ROOM];
        
        // Play sound
        sfx_play(sndYes, 1.0, random_range(0.9, 1.1));
    }
}

/// Check for state exit
if (fsmStateNext != "teleport_select")
{
    // Reset players state & fire default animation
    with (oPlayer)
    {
        fsm_set("default");
        anim_fire("idle");
    }
}

#define knt_state_teleport
if (!fsmStateInit)
{
    // (store current room index to source room variable)
    debug_log("oKNT > STATE_TELEPORT INIT");
    room_goto(ingameTeleportDest);
    
    // (disable teleport selection request)
    ingameTeleportSelectRequest = false;
}
else
{
    debug_log("oKNT > oROOM.roomREADY : ", oRoom.roomReady);
    if (oRoom.roomReady)
    {
        var _spawnx = room_width * 0.5, _spawny = room_height * 0.5; // fallback spawn coordinates : room center
        
        // Get the teleports coordinates
        var _teleporter = instance_find(oTeleport, irandom_range(0, instance_number(oTeleport) - 1));
        if (instance_exists(_teleporter))
        {
            _spawnx = (_teleporter.bbox_left + _teleporter.bbox_right) * 0.5;
            _spawny = (_teleporter.bbox_top + _teleporter.bbox_bottom) * 0.5;
        }
        
        if (instance_exists(oPlayer)) // (player exists; teleport player)
        {
            // Teleport player
            oPlayer.x = _spawnx;
            oPlayer.y = _spawny;
        }
        else
        {
            // (player doesn't exists; spawn a new one)
            instance_create(_spawnx, _spawny, oPlayer);
        }
        
        // Set players state & update upgrades stats
        with (oPlayer)
        {
            fsm_set("default");
            event_user(1);
        }
        
        /// Switch to normal state
        fsm_set("default");
    }
}

/// Check for state exit
if (fsmStateNext != "teleport")
{
    // Reset players state & fire default animation
    with (oPlayer)
    {
        fsm_set("default");
        anim_fire("idle");
    }
    
    ingameTeleportSelectRequest = false;
}
#define knt_state_debug
/// Game's debug menu state
if (!fsmStateInit)
{
    with (oUI)
    {
        fsm_set("debug_main");
    }
    
    // Pause the game's physics
    global.isPhysicsPaused = true;
}

if (!transitionIsHappening)
{
    /// Check for inputs
    var _inputv = oInput.inputV[@ eINPUT.PRS]; // keyboard_check_pressed(vk_down) - keyboard_check_pressed(vk_up);
    var _inputconfirm   = oInput.inputConfirm[@ eINPUT.PRS] || oInput.inputConfirmAlt[@ eINPUT.PRS];
    var _inputdeny      = oInput.inputDeny[@ eINPUT.PRS] || oInput.inputDenyAlt[@ eINPUT.PRS];
    
    if (_inputconfirm) /// Select menu
    {
        var _menudata = oUI.debugMenuList[@ oUI.debugMenuSelected];
        knt_transition(_menudata[@ 0], 4);
        
        // Play sound
        sfx_play(sndYes, 1.0, random_range(0.95, 1.05));
    }
    else if (_inputv != 0) /// Navigate menu
    {
        with (oUI)
        {
            var _listsz = array_length_1d(debugMenuList);
            debugMenuSelected = (debugMenuSelected + _inputv + _listsz) % _listsz;
            
            // Play sound
            sfx_play(sndSelect, 1.0, random_range(0.95, 1.05));
        }
    }
    else if (_inputdeny) /// Unpause request
    {
        // Switch state to main state
        knt_transition("default", room_speed * 0.25);
        
        // Unpause the game's physics
        global.isPhysicsPaused = false;
        
        // Play sound
        sfx_play(sndNo, 1.0, random_range(0.95, 1.05));
    }
}

#define knt_state_debug_roomdata
/// Game's room data debug state
if (!fsmStateInit)
{
    with (oUI)
    {
        fsm_set("debug_roomdata");
        debugRoomdataCurrentRoom       = ds_map_find_first(oGamevars.roomDatas);
        debugRoomdataCurrentRoomData   = oGamevars.roomDatas[? debugRoomdataCurrentRoom];
        debugRoomdataCurrentRoomEvents = roomevents_get_from(debugRoomdataCurrentRoom);
    }
}

/// Check for input
var _inputdeny  = oInput.inputDeny[@ eINPUT.PRS] || oInput.inputDenyAlt[@ eINPUT.PRS];
if (_inputdeny)
{
    // User requests exit
    if (!transitionIsHappening)
    {
        knt_transition("debug_main");
    }
}
else
{
    var _inputh = oInput.inputH[@ eINPUT.PRS];
    var _inputv = oInput.inputV[@ eINPUT.HLD];
    
    // Check for zoom in/out input
    oUI.debugRoomdataTilesize = clamp(oUI.debugRoomdataTilesize + _inputv * 0.1, oUI.debugRoomdataTilesizeMin, oUI.debugRoomdataTilesizeMax);
    oUI.debugRoomdataScale = oUI.debugRoomdataTilesize / 32;
    
    // Check for display room cycle input
    if (_inputh != 0)
    {
        var _nextroom = oUI.debugRoomdataCurrentRoom;
        if (_inputh == -1)
            _nextroom = ds_map_find_previous(oGamevars.roomDatas, _nextroom);
        else
            _nextroom = ds_map_find_next(oGamevars.roomDatas, _nextroom);
        
        if (_nextroom != undefined)
        {
            oUI.debugRoomdataCurrentRoom       = _nextroom;
            oUI.debugRoomdataCurrentRoomData   = oGamevars.roomDatas[? oUI.debugRoomdataCurrentRoom];
            oUI.debugRoomdataCurrentRoomEvents = roomevents_get_from(oUI.debugRoomdataCurrentRoom);
            
            // Build the string representation of all roomevents in the room
            oUI.debugRoomdataCurrentRoomEventsStr = "NONE";
            if (oUI.debugRoomdataCurrentRoomEvents != undefined && ds_list_size(oUI.debugRoomdataCurrentRoomEvents) > 0)
            {
                // (iterate & add room events informations to the events string)
                oUI.debugRoomdataCurrentRoomEventsStr = "";
                for (var i=0; i<ds_list_size(oUI.debugRoomdataCurrentRoomEvents); i++)
                {
                    var _event = oUI.debugRoomdataCurrentRoomEvents[| i];
                    switch (_event[@ 0])
                    {
                        case eEVENT.CREATE_OBJ:
                            oUI.debugRoomdataCurrentRoomEventsStr += "> CREATE [" + string(_event[@ 1]) + "] @ [" + string(_event[@ 2]) + ", " + string(_event[@ 3]) + "]";
                            break;
                        case eEVENT.DELETE_OBJ:
                            oUI.debugRoomdataCurrentRoomEventsStr += "> DELETE [" + string(_event[@ 1]) + "] @ [" + string(_event[@ 2]) + ", " + string(_event[@ 3]) + "]";
                            break;
                        case eEVENT.SWAP_PICKUP_ITEM:
                            oUI.debugRoomdataCurrentRoomEventsStr += "> SWAP TO ITEMTYPE [" + string(_event[@ 1]) + "] @ [" + string(_event[@ 2]) + ", " + string(_event[@ 3]) + "]";
                            break;
                        case eEVENT.UNLOCK_TP:
                            oUI.debugRoomdataCurrentRoomEventsStr += "> UNLOCK TELEPORTER";
                            break;
                        case eEVENT.UNLOCK_ITEM:
                            oUI.debugRoomdataCurrentRoomEventsStr += "> UNLOCK ITEM @ [" + string(_event[@ 1]) + ", " + string(_event[@ 2]) + "]";
                            break;
                    }
                    
                    if (i < ds_list_size(oUI.debugRoomdataCurrentRoomEvents) - 1)
                        oUI.debugRoomdataCurrentRoomEventsStr += "#";
                }
            }
            
            // Play sound
            sfx_play(sndSelect, 1.0, 1.0);
        }
        else
        {
            // Play sound
            sfx_play(sndNo, 1.0, 1.0);
        }
    }
}
#define knt_state_debug_keylayout
/// Game's room data debug state
if (!fsmStateInit)
{
    with (oUI)
    {
        fsm_set("debug_keylayout");
    }
    ui_load_keyslot_display_layout();
    
    /// Detect keyslot/inventory layout
    ui_keyslot_display_layout_detect();
}

/// Check for input
var _inputdeny  = oInput.inputDeny[@ eINPUT.PRS] || oInput.inputDenyAlt[@ eINPUT.PRS];
if (_inputdeny)
{
    // User requests exit
    if (!transitionIsHappening)
    {
        knt_transition("debug_main");
    }
}
else
{
    if (keyboard_check_pressed(vk_enter))
    {
        ui_load_keyslot_display_layout();
        
        /// Detect keyslot/inventory layout
        ui_keyslot_display_layout_detect();
    }
        
    var _inputh = oInput.inputH[@ eINPUT.PRS];
    if (_inputh != 0)
    {
        var _nextlayout = oUI.UIInputLayoutCurrent;
        if (_inputh == -1)
            _nextlayout = ds_map_find_previous(oUI.UIInputLayouts, oUI.UIInputLayoutCurrent);
        else
            _nextlayout = ds_map_find_next(oUI.UIInputLayouts, oUI.UIInputLayoutCurrent);
        
        if (_nextlayout != undefined)
        {
            ui_set_keyslot_display_layout(_nextlayout);
            
            // Play sound
            sfx_play(sndSelect, 1.0, 1.0);
        }
        else
        {
            // Play sound
            sfx_play(sndNo, 1.0, 1.0);
        }
    }
}
#define knt_state_debug_toggleallpowerup
if (!transitionIsHappening)
{
    global.debugAllPowerups ^= 1;
    
    // Update player upgrade status
    with (oPlayer)
    {
        event_user(1);
    }
    
    knt_transition("default");
}

#define knt_state_debug_incrementobjective
if (!transitionIsHappening)
{
    oGamevars.progress++;
    knt_transition("default");
}

#define knt_state_debug_killplayer
if (!transitionIsHappening)
{
    with (oPlayer)
    {
        // Switch to hurt state and damage player
        fsm_set("hurt");
        hp = 0;
        
        // Also apply knockback
        vx = random_range(-4, 4);
        vy = random_range(-4, -2);
    }
    knt_transition("default");
}

#define knt_state_debug_upgradekeys
if (!transitionIsHappening)
{
    with (oInput)
    {
        invKeysLevel = array_length_1d(invKeysUnlock) - 1;
        event_user(1);
    }
    knt_transition("default");
}