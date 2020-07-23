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
    
    /// Check for powercell deposit request
    if (ingamePowercellDepositRequest)
    {
        // Switch state to room change
        debug_log("oKNT > SWITCH TO STATE_OBJECTIVE_POWERCELL_DEPOSIT");
        knt_transition("objective_powercell_deposit", 4);
        
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
        knt_transition("ending");
        
        // Play sound
        sfx_play(sndPrompt, 1.0, 1.0);
    }
    
    /// Check for player dead
    if (oPlayer.fsmState == "dead")
    {
        if (keyboard_check_pressed(vk_enter))
        {
            // Respawn at hub
            knt_transition("hub_respawn");
            
            // Play sound
            sfx_play(sndPrompt, 1.0, 1.0);
        }
    }
    
    /// Check for pause request
    if (keyboard_check_pressed(vk_escape))
    {
        // Switch state to paused state
        knt_transition("paused_main", room_speed * 0.25);
        
        // Play sound
        sfx_play(sndPrompt, 1.0, 1.0);
    }
    
    // Unpause the game
    global.isPhysicsPaused = false;
}
else
{
    // Force-pause the game
    global.isPhysicsPaused = true;
}

#define knt_state_transition
/// Game's transition state
/*
if (!fsmStateInit)
{
    // Set the UI
    with (oUI)
    {
        fsm_set("nothing");
    }
    
    // Set up the transition variables
    transitionIsHappening = true;
    transitionIsFadeout = true;
    transitionCtr = 0;
    
    // Pause the game's physics
    global.isPhysicsPaused = true;
}

/// Update transition
if (transitionIsFadeout)
{
    // If enough frames has elapsed, switch to fadeout
    if (transitionCtr > transitionTime)
    {
        transitionCtr = 0;
        transitionIsFadeout = false;
    }
    else
    {
        transitionCtr++;
    }
}
else
{
    // If enough frames has elapsed, stop transitioning
    if (transitionCtr > transitionTime)
    {
        transitionCtr = 0;
        fsm_set(transitionDest);
    }
    else
    {
        transitionCtr++;
    }
}

/// Check for state switch
if (fsmStateNext != "transition")
{
    // Set up the transition variables
    transitionIsHappening = false;
    transitionIsFadeout = false;
    
    // Unpause the game's physics
    global.isPhysicsPaused = false;
}
*/

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
}


if (!transitionIsHappening)
{
    /// Check for inputs
    var _inputv = keyboard_check_pressed(vk_down) - keyboard_check_pressed(vk_up);
    var _inputconfirm = keyboard_check_pressed(vk_enter);
    
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
    else if (keyboard_check_pressed(vk_escape)) /// Unpause request
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
}


if (!transitionIsHappening)
{
    /// Check for inputs
    var _inputh = keyboard_check_pressed(vk_right) - keyboard_check_pressed(vk_left);
    var _inputv = keyboard_check_pressed(vk_down) - keyboard_check_pressed(vk_up);
    var _inputconfirm = keyboard_check_pressed(vk_enter);
    
    if (!oUI.pausedSettingsAdjusting) /// Wait for users to select the settings item
    {
        if (_inputconfirm) /// Select settings item
        {
            oUI.pausedSettingsAdjusting = true;
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
        else if (keyboard_check_pressed(vk_escape)) /// Unpause request
        {
            // Switch state to paused menu state
            knt_transition("paused_main", 4);
            
            // Play sound
            sfx_play(sndNo, 1.0, random_range(0.95, 1.05));
        }
    }
    else
    {
        if (_inputconfirm || keyboard_check_pressed(vk_escape)) /// Confirm
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
                    music_update_volume(room_speed * 0.5);
                    
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

#define knt_state_paused_respawn
/// Game's paused respawn menu state
if (!fsmStateInit)
{
    with (oUI)
    {
        fsm_set("paused_respawn");
    }
}


if (!transitionIsHappening)
{
    /// Check for inputs
    var _inputconfirm   = keyboard_check_pressed(ord('Y'));
    var _inputdeny      = keyboard_check_pressed(ord('N')) || keyboard_check_pressed(vk_escape);
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
            hp -= hpMax;
            
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


if (!transitionIsHappening)
{
    /// Check for inputs
    var _inputconfirm   = keyboard_check_pressed(ord('Y'));
    var _inputdeny      = keyboard_check_pressed(ord('N')) || keyboard_check_pressed(vk_escape);
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
        fsm_set("nothing");
    }
}

/// Set all the room's background properties
for (var i=room_first; i<=room_last; i++)
{
    room_set_background_color(i, c_black, false);
}

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
if (!transitionIsHappening)
{
    if (global.postprocessSupport)
    {
        // fsm_set("title");
        knt_transition("title");
    }
    else
    {
        // fsm_set("no_filter_warning");
        knt_transition("no_filter_warning");
    }
}

#define knt_state_nofilter_warn
/// Game's title screen state
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
if (keyboard_check_pressed(vk_enter))
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
    if (keyboard_check_pressed(vk_enter))
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
        fsm_set("hub_respawn");
    }
    
    /// Set game begin date
    playtimeBeginDate = date_current_datetime();
}

if (fsmStateCtr > introCutsceneWaitFrames)
{
    introCutsceneReady = true;
    
    if (keyboard_check_pressed(vk_enter) && !transitionIsHappening)
    {
        fsmStateCtr = 0;
        introCutsceneIdx++;
        if (introCutsceneIdx >= sprite_get_number(sprUICutsceneBegin))
        {
            introCutsceneIdx = clamp(introCutsceneIdx, 0, sprite_get_number(sprUICutsceneBegin) - 1);
            
            // Switch to next state
            // fsm_set("hub_respawn");
            knt_transition("hub_respawn");
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
    music_play(musNoise, room_speed * 3.0);
}

/// Check for state switch
if (fsmStateCtr > room_speed)
{
    if (keyboard_check_pressed(vk_enter)) // Return to menu
    {
        game_end();
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
    music_play(musIngame, room_speed * 6.0);
    
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

#define knt_state_powercell_deposit
/// Game's power-cell deposit state
if (!fsmStateInit)
{
    with (oUI)
    {
        fsm_set("powercell_deposit");
    }
    
    // Pause the game's physics
    global.isPhysicsPaused = true;
}

/// Update deposit mechanic
var _keyslots = oGamevars.invSlots;
var _assigned = false;
if (keyboard_check_pressed(vk_escape)) // User pressed the escape key
{
    // Switch state to normal state and disable the request flag
    fsm_set("default");
    ingamePowercellDepositRequest = false;
    
    // Play sound
    sfx_play(sndNo, 1.0, random_range(0.9, 1.1));
    
    // Reset players state & fire default animation
    with (oPlayer)
    {
        fsm_set("default");
        anim_fire("idle");
    }
    
    // Unpause the game's physics
    global.isPhysicsPaused = false;
}
else
{
    for (var i=0; i<ds_list_size(_keyslots); i++)
    {
        var _keydata = _keyslots[| i];
        if (keyboard_check_pressed(_keydata[@ eINVKEY.KEYCODE]) && _keydata[@ eINVKEY.ITEM] == eITEM.ITEM_POWERCELL)
        {
            // Deposit the powercell & increment objective progress
            oGamevars.progress++;
            
            // 'Delete' the item from inventory
            _keydata[@ eINVKEY.ITEM] = eITEM.NONE;
            
            // Play sound
            sfx_play(sndYes, 1.0, random_range(0.9, 1.1));
            
            /*
            // Switch state to normal state and disable the request flag
            fsm_set("default");
            ingamePowercellDepositRequest = false;
            
            // Reset players state & fire default animation
            with (oPlayer)
            {
                fsm_set("default");
                anim_fire("idle");
            }
            */
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
/// Game's room entering state
// For now just show message & instantly switch to next state
debug_log("oKNT > SWITCH TO DEFAULT");

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

/// Check for state switch
// Certain time has passed & user pressed the continue input
if (fsmStateCtr > oGamevars.animUIItemGetWaitFrames)
{
    if (keyboard_check_pressed(vk_enter))
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
            oGamevars.invKeysLevel = clamp(oGamevars.invKeysLevel + 1, 0, array_length_1d(oGamevars.invKeysUnlock) - 1);
            
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
            with (oGamevars)
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

/// Update assigning mechanic
var _keyslots = oGamevars.invSlots;
var _assigned = false;
if (!ingameItemAssignSelected) // Check for each key slots input
{
    if (keyboard_check_pressed(vk_escape)) // User pressed the escape key
    {
        // Switch state to normal state and disable the request flag
        fsm_set("default");
        ingameItemPickupRequest = false;
        
        // Play sound
        sfx_play(sndNo, 1.0, random_range(0.9, 1.1));
    }
    else
    {
        for (var i=0; i<ds_list_size(_keyslots); i++)
        {
            var _keydata = _keyslots[| i];
            if (keyboard_check_pressed(_keydata[@ eINVKEY.KEYCODE]) && _keydata[@ eINVKEY.AVAILABLE])
            {
                ingameItemAssignSelected    = true;
                ingameItemAssignSelectedIdx = i;
            }
        }
    }
}
else // Confirm the assigning
{
    // Check for cancel
    if (keyboard_check_pressed(vk_escape)) // User pressed the escape key
    {
        // Cancel selecting
        ingameItemAssignSelected = false;
        
        // Play sound
        sfx_play(sndNo, 1.0, random_range(0.9, 1.1));
    }
    else
    {
        var _keydata = _keyslots[| ingameItemAssignSelectedIdx];
        if (keyboard_check_pressed(_keydata[@ eINVKEY.KEYCODE]))
        {
            // Check if the keyslot is already occupied
            var _originalitem = _keydata[@ eINVKEY.ITEM];
            if (_originalitem != eITEM.NONE)
            {
                // Assign the item to key & spawn new pickup instance
                _keydata[@ eINVKEY.ITEM] = ingameItemAssignItemType;
                
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
                _keydata[@ eINVKEY.ITEM] = ingameItemAssignItemType;
                
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

/// Update teleport selecting mechanic
var _teleportlist       = oGamevars.teleportList;
var _teleportlistsize   = ds_list_size(_teleportlist);
if (keyboard_check_pressed(vk_escape)) // User pressed the escape key
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
    var _inputv = keyboard_check_pressed(vk_down) - keyboard_check_pressed(vk_up);
    if (_inputv != 0)
    {
        ingameTeleportSelectIdx = (ingameTeleportSelectIdx + _teleportlistsize + _inputv) % _teleportlistsize;
    }
    
    // Check for confirm
    if (keyboard_check_pressed(vk_enter))
    {
        fsm_set("teleport");
        
        // Pass value for teleportation state
        var _tpdata = _teleportlist[| ingameTeleportSelectIdx];
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