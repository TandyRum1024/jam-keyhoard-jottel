#define ui_ingame
var _centerx = global.winCenterX, _centery = global.winCenterY;
var _titlecol = make_color_hsv(random_range(0, 255), random_range(64, 100) * oGamevars.miscUIFlicker, random_range(220, 255));

if (oPlayer.fsmState != "dead")
{
    /// Draw HP
    ui_draw_hp();
}
else
{
    /// Draw retry message
    // (backdrop)
    var _backdropalpha = 0.5;
    ui_draw_rect(0, 0, global.winWid, global.winHei, c_maroon, _backdropalpha);
    
    // (text)
    var _textsize = 2 * global.gameUIZoom;
    ui_draw_text_format(16, 16, "FRAME DAMAGE......CRITICAL${br}REMOTE COMMAND LINK MODULE......UNAVAILABLE${br}EMERGENCY RE-DEPLOY MODULE......OK${br}.${br}.${br}.${br}PRESS ${key, confirm}${key, confirm_alt} TO RE-DEPLOY...", _textsize, _titlecol, 1.0, 0, 0, -1);
}

/// Draw message
ui_draw_message();

/// Draw subtitle
ui_draw_subtitle();

#define ui_ingame_intro
/// ================================================================================
///     Declare helper variables
/// ================================================================================
var _titlecol = make_color_hsv(random_range(0, 255), random_range(64, 100) * oGamevars.miscUIFlicker, random_range(220, 255));
var _interp = interp_weight(fsmStateCtr, room_speed, 2.0, 2.0);
var _interpmsg = interp_weight(fsmStateCtr, UIIntroCutsceneMsgShowFrames, 2.0, 2.0);

/// ================================================================================
///     Draw backdrop
/// ================================================================================
var _backdropalpha = 1.0; // lerp(1.0, 0.0, _interp);
if (oKNT.ingameIntroCutsceneState == eINGAMEINTRO_STATE.DEPLOY || oKNT.ingameIntroCutsceneState == eINGAMEINTRO_STATE.DONE)
    _backdropalpha = lerp(0.75, 0.0, interp_weight(oKNT.ingameIntroCutsceneStateCtr, UIIntroCutsceneMsgHideFrames, 1.5, 3.0));
else
    _backdropalpha = lerp(1.0, 0.75, _interp);
ui_draw_rect(0, 0, global.winWid, global.winHei, c_black, _backdropalpha);

/// ================================================================================
///     Draw intro message
/// ================================================================================
if (oKNT.ingameIntroCutsceneState != eINGAMEINTRO_STATE.DONE)
{
    var _intromsgscale = 2 * global.gameUIZoom;
    var _intromsg      = "SHIPMNGR> WARNING : CRITICAL SHIP DAMAGE DETECTED!!#SHIPMNGR> EXECUTING SELF-DIAGNOSIS...DONE#SHIPDIAG> DUMPING DIAGNOSIS RESULTS...#==================# => HULL INTEGRITY : WARNING (25%)# => EMERGENCY POWER SOURCE : DESTROYED (0%)# => EMERGENCY JOTTEL IS AVAILABLE FOR DEPLOYMENT#END DUMP##ADMIN@SHIP_CTRL :> SUDO DEPLOY JOTTEL --safemode -f#[SUDO] PASSWORD FOR ADMIN: **********************#EXECUTING JOTTEL DEPLOYMENT PROCESS...";
    var _intromsgfinal = string_copy(_intromsg, 1, string_length(_intromsg) * _interpmsg);
    var _intromsgalpha = 1.0;
    if (oKNT.ingameIntroCutsceneState == eINGAMEINTRO_STATE.DEPLOY)
        _intromsgalpha = 1.0 * (1.0 - interp_weight(oKNT.ingameIntroCutsceneStateCtr, UIIntroCutsceneMsgHideFrames, 1.5, 3.0));
    
    draw_set_halign(0); draw_set_valign(0);
    ui_draw_text(16, 16 + _intromsgscale, _intromsgfinal, _intromsgscale, 0, c_black, _intromsgalpha);
    ui_draw_text(16, 16, _intromsgfinal, _intromsgscale, 0, c_orange, _intromsgalpha);
}

#define ui_ingame_ending
/// ================================================================================
///     Declare helper variables
/// ================================================================================
var _titlecol = make_color_hsv(random_range(0, 255), random_range(64, 100) * oGamevars.miscUIFlicker, random_range(220, 255));
var _interp = interp_weight(fsmStateCtr, room_speed * 2.0, 2.0, 2.0);
var _screenmsg = "";
var _screenmsgalpha = 1.0;
var _screenmsginterp = 0;
var _backdropalpha = 0.0; // lerp(0.0, 0.5, _interp);

/// ================================================================================
///     Update values
/// ================================================================================
switch (oKNT.ingameEndingCutsceneState)
{
    case eINGAMEENDING_STATE.SHOWMSG1:
        // update backdrop alpha
        _backdropalpha = lerp(0.0, 0.75, _interp);
    
        // update screen message
        _screenmsg = "SHIPMNGR> ENOUGH POWER DETECTED!#SHIPMNGR> SHIP RESTORATION PROGRAM AVAILABLE FOR EXECUTION#DO YOU WANT TO EXECUTE IT? [Y/N] : Y##EXECUTING RESTRMAN, PLEASE WAIT...";
        
        // update screen message typing effect
        _screenmsginterp = interp_weight(oKNT.ingameEndingCutsceneStateCtr, UIEndingCutsceneMsgShowFrames, 2.0, 2.0);
        break;
    
    case eINGAMEENDING_STATE.SHOWMSG2:
        // update backdrop alpha
        _backdropalpha = 0.75;
        
        // update screen message
        _screenmsg = "================================================#";
        _screenmsg += "______ _____ _____ ______________  ___  ___   _   _  #";
        _screenmsg += "| ___ \  ___/  ___|_   _| ___ \  \/  | / _ \ | \ | | #";
        _screenmsg += "| |_/ / |__ \ `--.  | | | |_/ / .  . |/ /_\ \|  \| | #";
        _screenmsg += "|    /|  __| `--. \ | | |    /| |\/| ||  _  || . ` | #";
        _screenmsg += "| |\ \| |___/\__/ / | | | |\ \| |  | || | | || |\  | #";
        _screenmsg += "\_| \_\____/\____/  \_/ \_| \_\_|  |_/\_| |_/\_| \_/ #v13.5, ALL YOUR RIGHTS BELONGS TO US#";
        _screenmsg += "================================================#RESTRMAN> DETECTING REQUIRED POWER SOURCES...OK#RESTRMAN> DETECTING DESTROYED HULL PARTS...DONE#RESTRMAN> SPAWNING NEW HULL INSTANCES...........DONE#RESTRMAN> EMITTING ENGINEERS INTO SPACE...DONE#RESTRMAN> DELETING UNIDENTIFIED LIFEFORM...DONE#RESTRMAN> RETRACTING EMITTED ENGINEERS INTO THE SHIP...DONE#RESTRMAN> ALL DONE, RESTORE WAS SUCCESSFUL! (4.25s)#===================================#SHIPMNGR> LOCATING OPTIMAL ROUTE TO DESTINATION...DONE#SHIPMNGR> ENTERING REGULAR ROUTINE#SAVED INCIDENT LOG IN '/sys/report/incidents/ic0512.log'...";
        
        // update screen message typing effect
        _screenmsginterp = interp_weight(oKNT.ingameEndingCutsceneStateCtr, UIEndingCutsceneMsgShowFrames, 2.0, 2.0);
        break;
        
    case eINGAMEENDING_STATE.FADESCREEN:
        var _interp = interp_weight(oKNT.ingameEndingCutsceneStateCtr, oKNT.ingameEndingCutsceneFadeFrames, 2.0, 2.0);
        
        // update screen message alpha
        _screenmsgalpha = lerp(1.0, 0.0, _interp);
    
        // update backdrop alpha
        _backdropalpha = lerp(0.5, 1.0, _interp);
        
        // update screen message typing effect
        _screenmsginterp = 1.0;
        break;
        
    default:
        // update screen message alpha
        _screenmsgalpha = 0.0;
    
        // update backdrop alpha
        _backdropalpha = 1.0;
        break;
}

/// ================================================================================
///     Draw backdrop
/// ================================================================================
ui_draw_rect(0, 0, global.winWid, global.winHei, c_black, _backdropalpha);

/// ================================================================================
///     Draw screen message if needed
/// ================================================================================
var _screenmsgfinal = string_copy(_screenmsg, 1, round(string_length(_screenmsg) * _screenmsginterp));
var _screenmsgscale = 2 * global.gameUIZoom;

draw_set_halign(0); draw_set_valign(0);
ui_draw_text(16, 16 + _screenmsgscale, _screenmsgfinal, _screenmsgscale, 0, c_black, _screenmsgalpha);
ui_draw_text(16, 16, _screenmsgfinal, _screenmsgscale, 0, c_orange, _screenmsgalpha);

#define ui_nothing
// draw_clear(c_black);

#define ui_loading
draw_clear(c_black);
draw_set_halign(1); draw_set_valign(1);
ui_draw_text(global.winCenterX, global.winCenterY, "|", titleLogoScale, current_time * 0.0001 * 360, c_white, 1.0);

#define ui_screen_nofilter_warning
var _centerx = global.winCenterX, _centery = global.winCenterY;
var _titlecol = make_color_hsv(random_range(0, 255), random_range(64, 100) * oGamevars.miscUIFlicker, random_range(220, 255));
var _contentsmaxwid = global.winWid * 0.85;

draw_clear(c_black);

draw_set_halign(1); draw_set_valign(0);
ui_draw_text_ext(_centerx, global.winHei * 0.1, "NO SHADER SUPPORT DETECTED", -1, _contentsmaxwid, titleLogoScale, 0, c_orange, 1.0);

draw_set_halign(1); draw_set_valign(1);
ui_draw_text_ext(_centerx, _centery, "NO WORRIES; YOU CAN STILL PLAY THE GAME WITHOUT ANY PROBLEMS, BUT SINCE YOUR GRAPHICS CARD DOES NOT SUPPORT THE GAME'S SHADER EFFECTS.. THE POST-PROCESSING EFFECTS ARE DISABLED AND IT MIGHT RESULT IN LESSER ROBUST EXPERIENCE.", -1, _contentsmaxwid, 2, 0, c_white, 1.0);

// draw_set_halign(1); draw_set_valign(0);
ui_draw_text_format(_centerx, global.winHei * 0.9, "${key, confirm}${key, confirm_alt} I UNDERSTOOD.", 2, _titlecol, 1.0, 1, 2, -1);

#define ui_screen_seizure_warning
var _centerx = global.winCenterX, _centery = global.winCenterY;
var _titlecol = make_color_hsv(random_range(0, 255), random_range(64, 100) * oGamevars.miscUIFlicker, random_range(220, 255));
var _contentsmaxwid = global.winWid * 0.85;

draw_clear(c_black);

draw_set_halign(1); draw_set_valign(0);
ui_draw_text_ext(_centerx, global.winHei * 0.1, "EPILEPSY/SEIZURE WARNING", -1, _contentsmaxwid, titleLogoScale, 0, c_orange, 1.0);

draw_set_halign(1); draw_set_valign(1);
ui_draw_text_ext(_centerx, _centery, "THIS VIDEOGAME CONTAINS FLASHING IMAGES AND VISUALS THAT CAN CAUSE HARM TO SOME..##SHOULD YOU EXPERIENCE ANY SYMPTOMS OF PHOTOSENSITIVITY OR SEIZURE WHILE PLAYING, STOP AND CONSULT A DOCTOR IMMEDIATELY.#PLAY AT YOUR OWN RISK, PLAY SAFE.", -1, _contentsmaxwid, 2, 0, c_white, 1.0);

// draw_set_halign(1); draw_set_valign(0);
ui_draw_text_format(_centerx, global.winHei * 0.9, "${key, confirm}${key, confirm_alt} I UNDERSTOOD, I'M PLAYING AT MY OWN RISK.", 2, _titlecol, 1.0, 1, 2, -1);

#define ui_title
var _centerx = global.winCenterX, _centery = global.winCenterY;
var _titlecol        = make_color_hsv(random_range(0, 255), random_range(64, 100) * oGamevars.miscUIFlicker, random_range(220, 255));
var _titlecolintense = make_color_hsv(random_range(0, 255), random_range(128, 256) * oGamevars.miscUIFlicker, random_range(220, 255));
var _contentsmaxwid = global.winWid * 0.85;
var _itemscale = 2 * global.gameUIZoom;

draw_clear(c_black);

var _titlestr    = "KEYHOARD#JOTTEL";
var _titlestrhei = string_height(_titlestr) * titleLogoScale;
draw_set_halign(1); draw_set_valign(1);
ui_draw_text(_centerx, _centery * 0.5, _titlestr, titleLogoScale, 0, _titlecol, 1.0);

var _subtitlestr  = "POST-JAM STABILITY PATCH!!";
var _subtitlestry = (_centery + _titlestrhei) * 0.5 + 16;
draw_set_halign(1); draw_set_valign(0);
ui_draw_text(_centerx, _subtitlestry, _subtitlestr, _itemscale, 0, _titlecolintense, 1.0);

draw_set_halign(1); draw_set_valign(0);
ui_draw_text(_centerx, global.winHei * 0.75, "> ENTER", _itemscale, 0, _titlecol, 1.0);

draw_set_halign(1); draw_set_valign(2);
ui_draw_text_ext(_centerx, global.winHei  - 16, "ZIK @ MMXX#ORIGINALLY MADE IN 48 HOURS FOR GAME MAKERS TOOLKIT GAME JAM 2020", -1, _contentsmaxwid, _itemscale, 0, c_gray, 1.0);

#define ui_intro
var _centerx = global.winCenterX, _centery = global.winCenterY;
var _titlecol = make_color_hsv(random_range(0, 255), random_range(64, 100) * oGamevars.miscUIFlicker, random_range(220, 255));
var _itemscale = 3 * global.gameUIZoom;

draw_clear(c_black);

// Draw cutscene sprite
var _cutscenesprwid = sprite_get_width(sprUICutsceneBegin);
var _cutscenesprhei = sprite_get_height(sprUICutsceneBegin);
var _cutscenescale  = 2 * global.gameUIZoom; // max(min(floor(global.winWid / _cutscenesprwid), floor(global.winHei / _cutscenesprhei)), 1);
draw_sprite_ext(sprUICutsceneBegin, oKNT.introCutsceneIdx, _centerx, _centery, _cutscenescale, _cutscenescale, 0, c_white, 1.0);

// Draw continue msg
if (oKNT.introCutsceneReady)
{
    var _continuestr = "${key, confirm} ${key, confirm_alt} CONTINUE";
    ui_draw_text_format(_centerx, global.winHei - _itemscale * 8, _continuestr, _itemscale, _titlecol, 1.0, 1, 2, -1);
}

// Draw skip indicator
var _skipx = 4 * global.gameUIZoom;
var _skipy = 4 * global.gameUIZoom;
var _skipscale = 2 * global.gameUIZoom;
draw_set_halign(0); draw_set_valign(0);
ui_draw_text(_skipx, _skipy, "<SHIFT + ENTER> : SKIP", _skipscale, 0, c_gray, 1.0);

#define ui_ending
var _centerx = global.winCenterX, _centery = global.winCenterY;
var _titlecol = make_color_hsv(random_range(0, 255), random_range(64, 100) * oGamevars.miscUIFlicker, random_range(220, 255));
var _itemscale = 3 * global.gameUIZoom;

draw_clear(c_black);

// Draw cutscene sprite
var _cutscenesprwid = sprite_get_width(sprUICutsceneEnd);
var _cutscenesprhei = sprite_get_height(sprUICutsceneEnd);
var _cutscenescale  = 2 * global.gameUIZoom; // 6 * global.gameUIZoom;
draw_sprite_ext(sprUICutsceneEnd, 0, _centerx, _centery, _cutscenescale, _cutscenescale, 0, c_white, 1.0);

// Draw continue msg
if (oKNT.introCutsceneReady)
{
    var _continuestr = "${key, confirm} ${key, confirm_alt} CONTINUE";
    ui_draw_text_format(_centerx, global.winHei - _itemscale * 8, _continuestr, _itemscale, _titlecol, 1.0, 1, 2, -1);
}

#define ui_credits
var _centerx = global.winCenterX, _centery = global.winCenterY;
var _titlecol = make_color_hsv(random_range(0, 255), random_range(64, 100) * oGamevars.miscUIFlicker, random_range(220, 255));
var _contentsmaxwid = global.winWid * 0.9;
var _titlescale = 3 * global.gameUIZoom;
var _itemscale = 2 * global.gameUIZoom;
var _menualpha = interp_weight(fsmStateCtr, room_speed * 3.0, 2.0, 3.0);

draw_clear(c_black);

var _titlestr    = "THE END?";
var _titlemargin = 8 * global.gameUIZoom;
var _titleheight = string_height(_titlestr) * _titlescale;
draw_set_halign(1); draw_set_valign(0);
ui_draw_text(_centerx, _titlemargin, _titlestr, _titlescale, 0, _titlecol, _menualpha);

// Draw cutscene sprite
var _cutscenesprwid = sprite_get_width(sprUICutsceneEnd);
var _cutscenesprhei = sprite_get_height(sprUICutsceneEnd);
var _cutscenescale  = 2 * global.gameUIZoom; // max(min(floor(global.winWid / _cutscenesprwid), floor(global.winHei / _cutscenesprhei)), 1)
var _cutsceney      = _titlemargin * 2 + _titleheight + sprite_get_yoffset(sprUICutsceneEnd) * _cutscenescale;
draw_sprite_ext(sprUICutsceneEnd, 1, _centerx, _cutsceney, _cutscenescale, _cutscenescale, 0, c_white, _menualpha);

draw_set_halign(1); draw_set_valign(2);
ui_draw_text_ext(_centerx, global.winHei - _itemscale * 8, "GAME BY ZIK#ORIGINALLY MADE FOR GMTK GAME JAM 2020#TYSM FOR PLAYING!", -1, _contentsmaxwid, _itemscale, 0, _titlecol, _menualpha);

#define ui_paused
/// ================================================================================
///     Declare helper variables
/// ================================================================================
var _centerx = global.winCenterX, _centery = global.winCenterY;
var _titlecol = make_color_hsv(random_range(0, 255), random_range(64, 100) * oGamevars.miscUIFlicker, random_range(220, 255));
var _contentsmaxwid = global.winWid * 0.75;
var _contentsbeginx = (global.winWid - _contentsmaxwid) * 0.5;
var _contentsendx   = _contentsbeginx + _contentsmaxwid;
var _contentsitemmargin = 64 * global.gameUIZoom;
var _contentsitemwid    = _contentsmaxwid - _contentsitemmargin * 2;
var _contentsitemx      = _contentsbeginx + _contentsitemmargin;

var _interp     = interp_weight(fsmStateCtr, room_speed, 2.0, 2.0);
var _interpfast = interp_weight(fsmStateCtr, 8, 2.0, 2.0);

/// ================================================================================
///     Draw BG & information and keyslots
/// ================================================================================
// Draw backdrop
var _backdropalpha = lerp(1.0, 0.75, _interp);
ui_draw_rect(0, 0, global.winWid, global.winHei, c_black, _backdropalpha);

/// Draw paused menu
var _menualpha = _interpfast;

/// Draw information
var _infoplaytimemin = floor(oGamevars.playtimeSecs / 60);
var _infoplaytimesec = oGamevars.playtimeSecs % 60;
var _infostr   = "[SLOT LV. : " + string(oInput.invKeysLevel + 1) + "/" + string(array_length_1d(oInput.invKeysUnlock)) + "]#"
                    + "[PLAY TIME : " + string(_infoplaytimemin) + "m " + string(_infoplaytimesec) + "s]#"
                    + "[YOU'RE @ " + string(oRoom.title) + "]";
var _infoscale = 2 * global.gameUIZoom;
var _infoy     = 40 * global.gameUIZoom;
var _infohei   = string_height(_infostr) * _infoscale;

draw_set_halign(2); draw_set_valign(0);
ui_draw_text(_contentsendx, _infoy - 2, _infostr, _infoscale, 0, _titlecol, _menualpha);

/// Draw keys / inventories
var _keysdrawx      = _contentsbeginx;
var _keysdrawy      = _infoy;
ui_draw_keyslots(_keysdrawx, _keysdrawy, -1, -1, -1, c_white, 1.0, 0, 0);

/// ================================================================================
///     Draw title
/// ================================================================================
var _titlestr   = "======== PAUSED ========";
var _titlescale = 4 * global.gameUIZoom;
var _titley     = _centery * 0.6;
var _titlehei   = string_height(_titlestr) * _titlescale;

draw_set_halign(1); draw_set_valign(0);
ui_draw_rect(_contentsbeginx, _titley - _titlescale, _contentsmaxwid, _titlehei + _titlescale * 2, _titlecol, _menualpha);
ui_draw_text(_centerx, _titley, _titlestr, _titlescale, 0, c_black, 1.0);

/// ================================================================================
///     Draw menu
/// ================================================================================
var _menuitemscale  = 3 * global.gameUIZoom;
var _menuitemhei    = string_height("M") * _menuitemscale;
var _menuitemy  = _titley + _titlehei + _titlescale * 4;
var _menustepy  = _menuitemhei + _menuitemscale * 2;
draw_set_halign(0); draw_set_valign(0);
for (var i=0; i<array_length_1d(pausedMenuList); i++)
{
    var _menuitem       = pausedMenuList[@ i];
    var _menuitemstr    = _menuitem[@ 1];
    
    if (i == pausedMenuSelected)
    {
        // current item is selected, draw backdrop and text & flashy marker
        var _menuitemprefix = "   ";
        if ((fsmStateCtr >> 2) & 1 == 0)
            _menuitemprefix = " > ";
        
        ui_draw_rect(_contentsitemx, _menuitemy - _menuitemscale, _contentsitemwid, _menuitemhei + _menuitemscale * 2, _titlecol, _menualpha);
        ui_draw_text(_contentsitemx, _menuitemy, _menuitemprefix + _menuitemstr, _menuitemscale, 0, c_black, 1.0);
    }
    else
    {
        // current item isn't selected
        ui_draw_text(_contentsitemx, _menuitemy, _menuitemstr, _menuitemscale, 0, _titlecol, _menualpha);
    }
    _menuitemy += _menustepy;
}

/// ================================================================================
///     Draw bottom footer
/// ================================================================================
var _currentmenu = pausedMenuList[@ pausedMenuSelected];
var _footerstr1  = "${key, up}/${key, down} MOVE";
var _footerstr2  = "${key, confirm}${key, confirm_alt} CONFIRM${br}${key, deny}${key, deny_alt} RETURN";
var _footerstr3  = _currentmenu[@ 2];
var _footery     = _centery + _centery * 0.6;
ui_draw_footer(_contentsmaxwid, _footery, _footerstr1, _footerstr2, _footerstr3, _titlecol, _menualpha);

#define ui_paused_settings
/// ================================================================================
///     Declare helper variables
/// ================================================================================
var _centerx = global.winCenterX, _centery = global.winCenterY;
var _titlecol = make_color_hsv(random_range(0, 255), random_range(64, 100) * oGamevars.miscUIFlicker, random_range(220, 255));
var _contentsmaxwid = global.winWid * 0.75;
var _contentsbeginx = (global.winWid - _contentsmaxwid) * 0.5;
var _contentsendx   = _contentsbeginx + _contentsmaxwid;
var _contentsitemmargin = 64 * global.gameUIZoom;
var _contentsitemwid    = _contentsmaxwid - _contentsitemmargin * 2;
var _contentsitemx      = _contentsbeginx + _contentsitemmargin;
var _contentsitemendx   = _contentsitemx + _contentsitemwid;

var _interp     = interp_weight(fsmStateCtr, room_speed, 2.0, 2.0);
var _interpfast = interp_weight(fsmStateCtr, 8, 2.0, 2.0);
var _menualpha = _interpfast;

/// ================================================================================
///     Draw BG & title
/// ================================================================================
// BG fill-in
var _backdropalpha = lerp(1.0, 0.75, _interp);
ui_draw_rect(0, 0, global.winWid, global.winHei, c_black, _backdropalpha);

// Title
var _titlestr   = "======== BIOS ========";
var _titlescale = 4 * global.gameUIZoom;
var _titley     = _centery * 0.3;
var _titlehei   = string_height(_titlestr) * _titlescale;
ui_draw_rect_text(_contentsbeginx, _titley, _contentsmaxwid, _titlehei, _titlecol, _menualpha, _titlestr, _titlescale, 0, _titlescale, 1, 1, c_black, 1.0);

/// ================================================================================
///     Draw menu items
/// ================================================================================
// Calculate values needed
var _menuitemscale  = 3 * global.gameUIZoom;
var _menuitemhei    = string_height("M") * _menuitemscale;
var _menuitemy  = _titley + _titlehei + _titlescale * 4;
var _menustepy  = _menuitemhei + _menuitemscale * 2;

// Set align & begin drawing
draw_set_halign(0); draw_set_valign(0);
for (var i=0; i<array_length_1d(pausedSettingsList); i++)
{
    var _menudata       = pausedSettingsList[@ i];
    var _menuitemname   = _menudata[@ 0];
    var _menuitemvalue          = _menudata[@ 1];
    var _menuitemvaluestrings   = _menudata[@ 3];
    var _menuitemvaluedeststr   = _menudata[@ 4];
    var _menuitemvaluedisplay   = _menuitemvaluestrings[@ _menuitemvalue];
    
    var _menuvaluefinal = _menuitemvaluedisplay;
    if (_menuitemvalue > 0)
        _menuvaluefinal = "<" + _menuvaluefinal;
    if (_menuitemvalue < array_length_1d(_menudata[@ 2]) - 1)
        _menuvaluefinal = _menuvaluefinal + ">";
    
    if (i == pausedSettingsSelected)
    {
        // current item is selected, draw backdrop and text & flashy marker
        var _menuitemprefix = "   ";
        if ((fsmStateCtr >> 2) & 1 == 0 && pausedSettingsAdjusting)
            _menuitemprefix = " > ";
            
        var _menubackdropalpha = 0.5;
        if (pausedSettingsAdjusting)
            _menubackdropalpha = 1.0;
        
        // (backdrop)
        ui_draw_rect(_contentsitemx, _menuitemy - _menuitemscale, _contentsitemwid, _menuitemhei + _menuitemscale * 2, _titlecol, _menubackdropalpha * _menualpha);
        
        if (_menuitemvaluedeststr == "")
        {
            // (name)
            draw_set_halign(0);
            ui_draw_text(_contentsitemx, _menuitemy, _menuitemprefix + _menuitemname, _menuitemscale, 0, c_black, 1.0);
            
            // (value)
            draw_set_halign(2);
            ui_draw_text(_contentsitemendx, _menuitemy, _menuvaluefinal, _menuitemscale, 0, c_black, 1.0);
        }
        else
        {
            // (name)
            draw_set_halign(1);
            ui_draw_text(_centerx, _menuitemy, _menuitemprefix + _menuitemname, _menuitemscale, 0, c_black, 1.0);
        }
    }
    else
    {
        // current item isn't selected
        if (_menuitemvaluedeststr == "")
        {
            // (name)
            draw_set_halign(0);
            ui_draw_text(_contentsitemx, _menuitemy, _menuitemname, _menuitemscale, 0, _titlecol, _menualpha);
            
            // (value)
            draw_set_halign(2);
            ui_draw_text(_contentsitemendx, _menuitemy, _menuitemvaluedisplay, _menuitemscale, 0, _titlecol, _menualpha);
        }
        else
        {
            // (name)
            draw_set_halign(1);
            ui_draw_text(_centerx, _menuitemy, _menuitemname, _menuitemscale, 0, _titlecol, _menualpha);
        }
    }
    _menuitemy += _menustepy;
}

/// ================================================================================
///     Draw bottom help footer & deco footer
/// ================================================================================
var _footerstr1  = "${key, arrows} CHOOSE";
var _footerstr2  = "${key, confirm}${key, confirm_alt} CONFIRM${br}${key, deny}${key, deny_alt} RETURN";
var _footery     = _centery + _centery * 0.5;
ui_draw_footer(_contentsmaxwid, _footery, _footerstr1, _footerstr2, "", _titlecol, _menualpha);

#define ui_paused_settings_deadzone
/// ================================================================================
///     Declare helper variables
/// ================================================================================
var _centerx = global.winCenterX, _centery = global.winCenterY;
var _titlecol = make_color_hsv(random_range(0, 255), random_range(64, 100) * oGamevars.miscUIFlicker, random_range(220, 255));
var _contentsmaxwid = global.winWid * 0.75;
var _contentsbeginx = (global.winWid - _contentsmaxwid) * 0.5;
var _contentsendx   = _contentsbeginx + _contentsmaxwid;
var _contentsitemmargin = 64 * global.gameUIZoom;
var _contentsitemwid    = _contentsmaxwid - _contentsitemmargin * 2;
var _contentsitemx      = _contentsbeginx + _contentsitemmargin;
var _contentsitemendx   = _contentsitemx + _contentsitemwid;

var _interp     = interp_weight(fsmStateCtr, room_speed, 2.0, 2.0);
var _interpfast = interp_weight(fsmStateCtr, 8, 2.0, 2.0);
var _menualpha = _interpfast;

/// ================================================================================
///     Draw BG & title
/// ================================================================================
// BG fill-in
var _backdropalpha = lerp(1.0, 0.75, _interp);
ui_draw_rect(0, 0, global.winWid, global.winHei, c_black, _backdropalpha);

// Title
var _titlestr   = "====== D-ZONE ======";
var _titlescale = 4 * global.gameUIZoom;
var _titley     = _centery * 0.25;
var _titlehei   = string_height(_titlestr) * _titlescale;
ui_draw_rect_text(_contentsbeginx, _titley, _contentsmaxwid, _titlehei, _titlecol, _menualpha, _titlestr, _titlescale, 0, _titlescale, 1, 1, c_black, 1.0);

/// ================================================================================
///     Draw joystick & info
/// ================================================================================
// Calculate values needed
var _inputh = oInput.inputH[@ eINPUT.HLD];
var _inputv = oInput.inputV[@ eINPUT.HLD];
var _inputmag = point_distance(0, 0, _inputh, _inputv);
var _inputinvmag = 1;
if (_inputmag > 1)
    _inputinvmag = (1 / _inputmag);

var _menuitemscale  = 3 * global.gameUIZoom;
var _menuitemx  = _centerx;
var _menuitemy  = _titley + _titlehei + _titlescale * 4;

/// Draw joystick visualization
var _menusticksizeBG    = 64 * global.gameUIZoom;
var _menusticksizestick = 32 * global.gameUIZoom;
var _menusticksizedeadzoneold  = _menusticksizeBG * oKNT.settingsDeadzoneOld;
var _menusticksizedeadzonenew  = _menusticksizeBG * oKNT.settingsDeadzoneNew;
var _menustickbasex  = _menuitemx;
var _menustickbasey  = _menuitemy + _menusticksizeBG;
var _menustickstickx = _menustickbasex + (_inputh * _inputinvmag) * _menusticksizeBG;
var _menusticksticky = _menustickbasey + (_inputv * _inputinvmag) * _menusticksizeBG;
draw_set_circle_precision(8);

// (old deadzone)
draw_set_alpha(_menualpha * 0.5);
draw_circle_colour(_menustickbasex, _menustickbasey, _menusticksizedeadzoneold, c_orange, c_orange, true);
draw_circle_colour(_menustickbasex, _menustickbasey, _menusticksizedeadzoneold, c_orange, c_orange, false);
if (oKNT.settingsDeadzoneAdjustState != eSETTINGS_DEADZONE_STATE.TEST)
{
    // (new deadzone)
    draw_set_alpha(_menualpha * 0.25);
    draw_circle_colour(_menustickbasex, _menustickbasey, _menusticksizedeadzonenew, c_teal, c_teal, true);
    draw_circle_colour(_menustickbasex, _menustickbasey, _menusticksizedeadzonenew, c_teal, c_teal, false);
}
// (stick)
draw_set_alpha(_menualpha);
draw_circle_colour(_menustickbasex, _menustickbasey, _menusticksizeBG, _titlecol, _titlecol, true);
draw_circle_colour(_menustickstickx, _menusticksticky, _menusticksizestick, _titlecol, _titlecol, false);
draw_set_alpha(1.0);

var _footerstr1 = "";
var _footerstr2 = "";
var _menuinfoy = _menustickbasey + _menusticksizeBG + _contentsitemmargin;
switch (oKNT.settingsDeadzoneAdjustState)
{
    case eSETTINGS_DEADZONE_STATE.TEST:
        /// Draw deadzone & joystick information
        // Deadzone text
        var _deadzonestr = "DEADZONE : ${0}";
        var _deadzonearg = makearray(string(oKNT.settingsDeadzoneOld * 100) + "%");
        ui_draw_text_format(_centerx, _menuinfoy, _deadzonestr, _menuitemscale, _titlecol, _menualpha, 1, 0, _deadzonearg);
        _menuinfoy += ui_draw_text_format_get_height(_deadzonestr, _deadzonearg) * _menuitemscale;
        
        // Joystick input text
        var _inputstr = "INPUT X : ${0}${br}INPUT Y : ${1}";
        var _inputarg = makearray(string_format(_inputh * 100, 3, 6) + "%", string_format(_inputv * 100, 3, 6) + "%");
        ui_draw_text_format(_contentsitemx, _menuinfoy, _inputstr, _menuitemscale, _titlecol, _menualpha, 0, 0, _inputarg);
        
        // Set footer text
        _footerstr1 = "${key, JOYSTICK_L}${br}TEST INPUT";
        _footerstr2 = "${key, confirm}${key, confirm_alt} CONFIRM${br}${key,deny}${key,deny_alt} RETURN";
        break;
        
    case eSETTINGS_DEADZONE_STATE.ADJUST:
        /// Draw new deadzone & joystick information
        // Deadzone text
        var _deadzonestr = "OLD DEADZONE : ${0}${br}NEW DEADZONE : ${1}";
        var _deadzonearg = makearray(string(oKNT.settingsDeadzoneOld * 100) + "%", string(oKNT.settingsDeadzoneNew * 100) + "%");
        ui_draw_text_format(_centerx, _menuinfoy, _deadzonestr, _menuitemscale, _titlecol, _menualpha, 1, 0, _deadzonearg);
        _menuinfoy += ui_draw_text_format_get_height(_deadzonestr, _deadzonearg) * _menuitemscale;
        
        // Set footer text
        _footerstr1 = "${key, JOYSTICK_L}${br}ADJUST DEADZONE";
        _footerstr2 = "${key, confirm}${key, confirm_alt} CONFIRM${br}${key,deny}${key,deny_alt} CANCEL";
        break;
        
    case eSETTINGS_DEADZONE_STATE.CONFIRM:
        /// Draw new deadzone confirmation
        // Deadzone text
        var _deadzonestr = "OLD DEADZONE : ${0}${br}NEW DEADZONE : ${1}";
        var _deadzonearg = makearray(string(oKNT.settingsDeadzoneOld * 100) + "%", string(oKNT.settingsDeadzoneNew * 100) + "%");
        ui_draw_text_format(_centerx, _menuinfoy, _deadzonestr, _menuitemscale, _titlecol, _menualpha, 1, 0, _deadzonearg);
        _menuinfoy += ui_draw_text_format_get_height(_deadzonestr, _deadzonearg) * _menuitemscale;
        _menuinfoy = (_menuinfoy + _centery + _centery * 0.5) * 0.5;
        
        var _confirmstr = "CONFIRM?";
        draw_set_halign(1); draw_set_valign(1);
        ui_draw_text(_centerx, _menuinfoy, _confirmstr, _menuitemscale, 0, c_orange, _menualpha);
        
        // Set footer text
        _footerstr1 = "";
        _footerstr2 = "${key, confirm}${key, confirm_alt} CONFIRM${br}${key,deny}${key,deny_alt} CANCEL";
        break;
}

/// ================================================================================
///     Draw bottom help footer & deco footer
/// ================================================================================
var _footery = _centery + _centery * 0.5;
ui_draw_footer(_contentsmaxwid, _footery, _footerstr1, _footerstr2, "", _titlecol, _menualpha);

#define ui_paused_respawn
/// ================================================================================
///     Declare helper variables
/// ================================================================================
var _centerx = global.winCenterX, _centery = global.winCenterY;
var _titlecol = make_color_hsv(random_range(0, 255), random_range(64, 100) * oGamevars.miscUIFlicker, random_range(220, 255));
// margin & calculated position of contents
var _contentsmaxwid = global.winWid * 0.75;
var _contentsbeginx = (global.winWid - _contentsmaxwid) * 0.5;
var _contentsendx   = _contentsbeginx + _contentsmaxwid;
// margin & calculated position of contents' items
var _contentsitemmargin = 64 * global.gameUIZoom;
var _contentsitemwid    = _contentsmaxwid - _contentsitemmargin * 2;
var _contentsitemx      = _contentsbeginx + _contentsitemmargin;
var _contentsitemendx   = _contentsitemx + _contentsitemwid;

var _interp     = interp_weight(fsmStateCtr, room_speed, 2.0, 2.0);
var _interpfast = interp_weight(fsmStateCtr, 8, 2.0, 2.0);

var _menualpha = _interpfast; // alpha for UI elements

/// ================================================================================
///     Draw BG & title
/// ================================================================================
// BG fill-in
var _backdropalpha = lerp(1.0, 0.75, _interp);
ui_draw_rect(0, 0, global.winWid, global.winHei, c_black, _backdropalpha);

// Title
var _titlestr   = "====== WARNING ======";
var _titlescale = 4 * global.gameUIZoom;
var _titley     = _centery * 0.25;
var _titlehei   = string_height(_titlestr) * _titlescale;
ui_draw_rect_text(_contentsbeginx, _titley, _contentsmaxwid, _titlehei, _titlecol, _menualpha, _titlestr, _titlescale, 0, _titlescale, 1, 1, c_black, 1.0);

/// ================================================================================
///     Draw warning text
/// ================================================================================
// Calculate values needed
var _menuitemstr    = "TERMINATE CURRENTLY PILOTTING JOTTEL & RE-DEPLOY AT THE LOBBY?##[Y / N]";
var _menuitemscale  = 3 * global.gameUIZoom;
var _menuitemy      = _titley + _titlehei + _titlescale * 4;

draw_set_halign(1); draw_set_valign(0);
ui_draw_text_ext(_centerx, _menuitemy, _menuitemstr, -1, _contentsitemwid, _menuitemscale, 0, _titlecol, _menualpha);

/// ================================================================================
///     Draw bottom help footer & deco footer
/// ================================================================================
var _footerstr1  = "${key, Y}/${key, confirm}${key, confirm_alt} CHOOSE${br}${key, N}/${key, deny}${key, deny_alt} DENY & RETURN";
var _footerstr2  = "";
var _footery     = _centery + _centery * 0.5;
ui_draw_footer(_contentsmaxwid, _footery, _footerstr1, _footerstr2, "", _titlecol, _menualpha);

#define ui_paused_exit
/// ================================================================================
///     Declare helper variables
/// ================================================================================
var _centerx = global.winCenterX, _centery = global.winCenterY;
var _titlecol = make_color_hsv(random_range(0, 255), random_range(64, 100) * oGamevars.miscUIFlicker, random_range(220, 255));
// margin & calculated position of contents
var _contentsmaxwid = global.winWid * 0.75;
var _contentsbeginx = (global.winWid - _contentsmaxwid) * 0.5;
var _contentsendx   = _contentsbeginx + _contentsmaxwid;
// margin & calculated position of contents' items
var _contentsitemmargin = 64 * global.gameUIZoom;
var _contentsitemwid    = _contentsmaxwid - _contentsitemmargin * 2;
var _contentsitemx      = _contentsbeginx + _contentsitemmargin;
var _contentsitemendx   = _contentsitemx + _contentsitemwid;

var _interp     = interp_weight(fsmStateCtr, room_speed, 2.0, 2.0);
var _interpfast = interp_weight(fsmStateCtr, 8, 2.0, 2.0);

var _menualpha = _interpfast; // alpha for UI elements

/// ================================================================================
///     Draw BG & title
/// ================================================================================
// BG fill-in
var _backdropalpha = lerp(1.0, 0.75, _interp);
ui_draw_rect(0, 0, global.winWid, global.winHei, c_black, _backdropalpha);

// Title
var _titlestr   = "====== CONFIRM ======";
var _titlescale = 4 * global.gameUIZoom;
var _titley     = _centery * 0.25;
var _titlehei   = string_height(_titlestr) * _titlescale;
ui_draw_rect_text(_contentsbeginx, _titley, _contentsmaxwid, _titlehei, _titlecol, _menualpha, _titlestr, _titlescale, 0, _titlescale, 1, 1, c_black, 1.0);

/// ================================================================================
///     Draw warning text
/// ================================================================================
// Calculate values needed
var _menuitemstr    = "EXIT GAME?${br}PROGRESS WILL NOT BE SAVED.${br}${br}${0}";
var _menuitemscale  = 3 * global.gameUIZoom;
var _menuitemy      = _titley + _titlehei + _titlescale * 4;

ui_draw_text_format(_centerx, _menuitemy, _menuitemstr, _menuitemscale, _titlecol, _menualpha, 1, 0, makearray("[Y / N]"));
// draw_set_halign(1); draw_set_valign(0);
// ui_draw_text_ext(_centerx, _menuitemy, _menuitemstr, -1, _contentsitemwid, _menuitemscale, 0, _titlecol, _menualpha);

/// ================================================================================
///     Draw bottom help footer & deco footer
/// ================================================================================
var _footerstr1  = "${key, Y} CONFIRM${br}${key, N}${key, deny}${key, deny_alt} DENY & RETURN";
var _footerstr2  = "";
var _footery     = _centery + _centery * 0.5;
ui_draw_footer(_contentsmaxwid, _footery, _footerstr1, _footerstr2, "", _titlecol, _menualpha);

#define ui_item_get
if (!fsmStateInit)
{
    itemGetReady = false;
}

/// ================================================================================
///     Declare helper variables & draw backdrop
/// ================================================================================
var _centerx = global.winCenterX, _centery = global.winCenterY;
var _titlecol        = make_color_hsv(random_range(0, 255), random_range(64, 100) * oGamevars.miscUIFlicker, random_range(220, 255));
var _titlecolintense = make_color_hsv(random_range(0, 255), random_range(100, 200) * oGamevars.miscUIFlicker, random_range(220, 255));
var _contentsmaxwid = global.winWid * 0.75;
var _contentsbeginx = (global.winWid - _contentsmaxwid) * 0.5;
var _contentsendx   = _contentsbeginx + _contentsmaxwid;
var _contentsitemmargin = 64 * global.gameUIZoom;
var _contentsitemwid    = _contentsmaxwid - _contentsitemmargin * 2;
var _contentsitemx      = _contentsbeginx + _contentsitemmargin;

var _interp     = interp_weight(fsmStateCtr, room_speed, 2.0, 2.0);
var _interpfast = interp_weight(fsmStateCtr, 8, 2.0, 2.0);
var _menualpha = _interpfast;

var _itemgetstr = "";
_itemgetstr += "    __________________  ___   ____________________#";
_itemgetstr += "   /  _/_  __/ ____/  |/  /  / ____/ ____/_  __/ /#";
_itemgetstr += "   / /  / / / __/ / /|_/ /  / / __/ __/   / / / / #";
_itemgetstr += " _/ /  / / / /___/ /  / /  / /_/ / /___  / / /_/  #";
_itemgetstr += "/___/ /_/ /_____/_/  /_/   \____/_____/ /_/ (_)   #";

var _itemgetstrscale = 2 * global.gameUIZoom;
var _itemgetstrwid = string_width(_itemgetstr) * _itemgetstrscale;
var _itemgetstrhei = string_height(_itemgetstr) * _itemgetstrscale;
var _itemgetstrcol = c_yellow;

/// Draw backdrop
var _backdropalpha = _interp * 0.75;
ui_draw_rect(0, 0, global.winWid, global.winHei, c_black, _backdropalpha);

/// ================================================================================
///     Draw item get screen
/// ================================================================================
// (backdrop)
var _backdropdecoscale = 8 * global.gameUIZoom;
var _backdropdecoscale2= 2 * _backdropdecoscale;
var _backdropwid = _itemgetstrwid + _backdropdecoscale * 6;
var _backdrophei = _itemgetstrhei + _backdropdecoscale * 3; // global.winHei * 0.5;
var _backdropx = global.winCenterX - _backdropwid * 0.5;
var _backdropy = 16 * global.gameUIZoom; //  - _backdrophei * 0.5;
var _backdropshadowoff = _backdropdecoscale;
var _backdropfillcol = c_blue;
var _backdropdecocol = c_ltgray;
var _backdropitemy = _backdropy + _backdropdecoscale * 2;

ui_draw_rect(_backdropx + _backdropshadowoff, _backdropy + _backdropshadowoff, _backdropwid, _backdrophei, c_black, _menualpha); // shadow
ui_draw_rect(_backdropx, _backdropy, _backdropwid, _backdrophei, _backdropfillcol, _menualpha); // BG #1
ui_draw_rect(_backdropx + _backdropdecoscale, _backdropy + _backdropdecoscale, _backdropwid - _backdropdecoscale2, _backdrophei - _backdropdecoscale2, _backdropdecocol, _menualpha); // Deco
ui_draw_rect(_backdropx + _backdropdecoscale2, _backdropy + _backdropdecoscale2, _backdropwid - _backdropdecoscale2 * 2, _backdrophei - _backdropdecoscale2 * 2, _backdropfillcol, _menualpha); // BG #2

// (title)
var _obtaintitlestr     = _itemgetstr;
var _obtaintitley       = _backdropitemy;
var _obtaintitlecol     = _itemgetstrcol;
draw_set_halign(1); draw_set_valign(0);
ui_draw_text_ext(_centerx, _obtaintitley, _obtaintitlestr, 12, global.winWid, _itemgetstrscale, 0, _obtaintitlecol, _menualpha);

// (item icon)
var _obtainitemiconscale    = 6 * global.gameUIZoom;
var _obtainitemiconwid      = _obtainitemiconscale * sprite_get_width(sprPickup);
var _obtainitemiconhei      = _obtainitemiconscale * sprite_get_height(sprPickup);
var _obtainitemiconx        = _centerx - _obtainitemiconwid * 0.5 + sprite_get_xoffset(sprPickup) * _obtainitemiconscale;
var _obtainitemicony        = _centery * 0.75 - _obtainitemiconhei * 0.5 + sprite_get_yoffset(sprPickup) * _obtainitemiconscale;
draw_sprite_ext(sprPickup, itemGetType, _obtainitemiconx, _obtainitemicony, _obtainitemiconscale, _obtainitemiconscale, 0, c_white, _menualpha);

// (item name & description)
var _obtainitemstrwid   = global.winWid * 0.9;
var _obtainitemstr      = oGamevars.itemStr[@ itemGetType];
var _obtainitemnamestr      = _obtainitemstr[@ 0];
var _obtainitemnamescale    = 4 * global.gameUIZoom;
var _obtainitemnamey        = _centery * 0.75 + _obtainitemiconhei * 0.5 + 8 * global.gameUIZoom;
var _obtainitemnamehei      = string_height(_obtainitemnamestr) * _obtainitemnamescale;
var _obtainitemnamecol      = make_color_hsv(random_range(0, 255), random_range(0, 100) * oGamevars.miscUIFlicker, random_range(220, 255));
var _obtainitemdescstr      = _obtainitemstr[@ 1];
var _obtainitemdescscale    = 2 * global.gameUIZoom;
var _obtainitemdescy        = _obtainitemnamey + _obtainitemnamehei;
var _obtainitemdeschei      = string_height_ext(_obtainitemdescstr, -1, _obtainitemstrwid / _obtainitemdescscale) * _obtainitemdescscale;
var _obtainitemdesccol      = c_white;
var _obtainitemfuncstr      = _obtainitemstr[@ 2];
var _obtainitemfuncscale    = 2 * global.gameUIZoom;
var _obtainitemfuncy        = _obtainitemdescy + _obtainitemdeschei;
var _obtainitemfunccol      = _titlecolintense;
draw_set_halign(1); draw_set_valign(0);
ui_draw_text(_centerx, _obtainitemnamey + _obtainitemnamescale, _obtainitemnamestr, _obtainitemnamescale, 0, c_black, _menualpha);
ui_draw_text(_centerx, _obtainitemnamey, _obtainitemnamestr, _obtainitemnamescale, 0, _obtainitemnamecol, _menualpha);

ui_draw_text_ext(_centerx, _obtainitemdescy + _obtainitemdescscale, _obtainitemdescstr, -1, _obtainitemstrwid, _obtainitemdescscale, 0, c_black, _menualpha);
ui_draw_text_ext(_centerx, _obtainitemdescy, _obtainitemdescstr, -1, _obtainitemstrwid, _obtainitemdescscale, 0, _obtainitemdesccol, _menualpha);

ui_draw_text_ext(_centerx, _obtainitemfuncy + _obtainitemfuncscale, _obtainitemfuncstr, -1, _obtainitemstrwid, _obtainitemfuncscale, 0, c_black, _menualpha);
ui_draw_text_ext(_centerx, _obtainitemfuncy, _obtainitemfuncstr, -1, _obtainitemstrwid, _obtainitemfuncscale, 0, _obtainitemfunccol, _menualpha);

/// ================================================================================
///     Draw bottom footer
/// ================================================================================
var _currentmenu = objectiveMenuList[@ objectiveMenuSelected];
var _footerstr1  = "";
var _footerstr2  = "";
var _footerstr3  = "";
var _footery     = _centery + _centery * 0.75;
if (itemGetReady)
    _footerstr2 = "${key, confirm}${key, confirm_alt} CONTINUE";

ui_draw_footer(_contentsmaxwid, _footery, _footerstr1, _footerstr2, _footerstr3, _titlecol, _menualpha);

#define ui_item_assign
/// ================================================================================
///     Declare helper variables & draw backdrop
/// ================================================================================
var _centerx = global.winCenterX, _centery = global.winCenterY;
var _titlecol        = make_color_hsv(random_range(0, 255), random_range(64, 100) * oGamevars.miscUIFlicker, random_range(220, 255));
var _titlecolintense = make_color_hsv(random_range(0, 255), random_range(100, 200) * oGamevars.miscUIFlicker, random_range(220, 255));
var _contentsmaxwid = global.winWid * 0.75;
var _contentsbeginx = (global.winWid - _contentsmaxwid) * 0.5;
var _contentsendx   = _contentsbeginx + _contentsmaxwid;
var _contentsitemmargin = 64 * global.gameUIZoom;
var _contentsitemwid    = _contentsmaxwid - _contentsitemmargin * 2;
var _contentsitemx      = _contentsbeginx + _contentsitemmargin;

var _interp     = interp_weight(fsmStateCtr, room_speed, 2.0, 2.0);
var _interpfast = interp_weight(fsmStateCtr, 8, 2.0, 2.0);
var _menualpha = _interpfast;

/// Draw backdrop
var _backdropalpha = _interp * 0.75;
ui_draw_rect(0, 0, global.winWid, global.winHei, c_black, _backdropalpha);

/// ================================================================================
///     Draw title
/// ================================================================================
var _titlestr   = "====== ASSIGNING ITEM ======";
var _titlescale = 4 * global.gameUIZoom;
var _titley     = _centery * 0.25;
var _titlehei   = string_height(_titlestr) * _titlescale;

draw_set_halign(1); draw_set_valign(0);
ui_draw_rect(_contentsbeginx, _titley - _titlescale, _contentsmaxwid, _titlehei + _titlescale * 2, _titlecol, _menualpha);
ui_draw_text(_centerx, _titley, _titlestr, _titlescale, 0, c_black, 1.0);

/// ================================================================================
///     Draw keyslot / inventory
/// ================================================================================
var _keyshighlights  = -1;
var _keysitemflicker = -1;
if (oKNT.ingameItemAssignSelected)
{
    var _selectedslotid = oKNT.ingameItemAssignSelectedSlotID;
    _keyshighlights  = _selectedslotid;
    _keysitemflicker = makearray(_selectedslotid, oKNT.ingameItemAssignItemType);
}
var _keyslotsy = _centery;
ui_draw_keyslots(_centerx, _keyslotsy, _keyshighlights, _keysitemflicker, -1, c_white, 1.0, 1, 2);

/// ================================================================================
///     Draw item info
/// ================================================================================
var _selectedslotdata  = oInput.invKeyslots[? oKNT.ingameItemAssignSelectedSlotID];
var _selecteditemttype = _selectedslotdata[@ eINVKEY.ITEM];
var _itemy = _centery + 1 * global.gameUIZoom;
if (oKNT.ingameItemAssignSelected && _selecteditemttype != eITEM.NONE)
{
    // There's already an item assigned in the currently selected slot.
    // ask user if they want to swap it or not
    var _iteminfoinv   = oGamevars.itemStr[@ itemGetType];
    var _iteminfoswap  = oGamevars.itemStr[@ _selecteditemttype];
    var _itemiconscale = 4 * global.gameUIZoom;
    var _itemiconwid   = sprite_get_width(sprPickup) * _itemiconscale;
    var _itemiconhei   = sprite_get_height(sprPickup) * _itemiconscale;
    var _itemmargin    = _centerx * 0.3;
    var _itemx1 = _centerx + _itemmargin - _itemiconwid * 0.5;
    var _itemx2 = _centerx - _itemmargin - _itemiconwid * 0.5;
    
    // (draw item icons)
    draw_sprite_ext(sprPickup, itemGetType, _itemx1, _itemy, _itemiconscale, _itemiconscale, 0, c_white, _menualpha);
    draw_sprite_ext(sprPickup, _selecteditemttype, _itemx2, _itemy, _itemiconscale, _itemiconscale, 0, c_white, _menualpha);
    
    // (draw item names)
    var _itemnamewid   = _itemiconwid * 1.5;
    var _itemnamescale = 2 * global.gameUIZoom;
    var _itemnamey     = _itemy + _itemiconhei + _itemiconscale;
    draw_set_halign(1); draw_set_valign(0);
    ui_draw_text_ext(_itemx1 + _itemiconwid * 0.5, _itemnamey, _iteminfoinv[@ 0], -1, _itemnamewid, _itemnamescale, 0, c_orange, _menualpha);
    ui_draw_text_ext(_itemx2 + _itemiconwid * 0.5, _itemnamey, _iteminfoswap[@ 0], -1, _itemnamewid, _itemnamescale, 0, c_orange, _menualpha);
    
    // (draw swap text)
    var _swaptextscale = 2 * global.gameUIZoom;
    var _swaptexty = _itemy + _itemiconhei * 0.5;
    ui_draw_text(_centerx, _swaptexty, "-[SWAP?]->", _swaptextscale, 0, c_orange, _menualpha);
}
else
{
    // There's no item assigned in the currently selected slot OR
    // the user hadn't selected a slot yet
    ui_draw_item_info(_centerx * 0.5, _itemy, itemGetType, _titlecolintense, _titlecol, _menualpha);
}

/// ================================================================================
///     Draw bottom footer
/// ================================================================================
var _footerstr1 = "${key, ANY SLOT KEY}${br}SELECT";
var _footerstr2 = "${key, deny} CANCEL";
var _footerstr3 = "";

if (oKNT.ingameItemAssignSelected)
{
    if (_selecteditemttype != eITEM.NONE)
    {
        _footerstr1 = "${key, SAME SLOT KEY}${br}SWAP";
        _footerstr3 = "PRESS SAME KEY AGAIN TO CONFIRM & SWAP ITEM";
    }
    else
    {
        _footerstr1 = "${key, SAME SLOT KEY}${br}ASSIGN";
        _footerstr3 = "PRESS SAME KEY AGAIN TO CONFIRM & ASSIGN ITEM TO SELECTED SLOT";
    }
}

var _footery = _centery + _centery * 0.6;
ui_draw_footer(_contentsmaxwid, _footery, _footerstr1, _footerstr2, _footerstr3, _titlecol, _menualpha);

#define ui_item_relocate_select_inv
/// ================================================================================
///     Declare helper variables & draw backdrop
/// ================================================================================
var _centerx = global.winCenterX, _centery = global.winCenterY;
var _titlecol        = make_color_hsv(random_range(0, 255), random_range(64, 100) * oGamevars.miscUIFlicker, random_range(220, 255));
var _titlecolintense = make_color_hsv(random_range(0, 255), random_range(100, 200) * oGamevars.miscUIFlicker, random_range(220, 255));
var _contentsmaxwid = global.winWid * 0.75;
var _contentsbeginx = (global.winWid - _contentsmaxwid) * 0.5;
var _contentsendx   = _contentsbeginx + _contentsmaxwid;
var _contentsitemmargin = 64 * global.gameUIZoom;
var _contentsitemwid    = _contentsmaxwid - _contentsitemmargin * 2;
var _contentsitemx      = _contentsbeginx + _contentsitemmargin;

var _interp     = interp_weight(fsmStateCtr, room_speed, 2.0, 2.0);
var _interpfast = interp_weight(fsmStateCtr, 8, 2.0, 2.0);
var _menualpha = _interpfast;

/// Draw backdrop
var _backdropalpha = _interp * 0.75;
ui_draw_rect(0, 0, global.winWid, global.winHei, c_black, _backdropalpha);

/// ================================================================================
///     Draw title
/// ================================================================================
var _titlestr   = "====== RELOCATE... ======";
var _titlescale = 4 * global.gameUIZoom;
var _titley     = _centery * 0.25;
var _titlehei   = string_height(_titlestr) * _titlescale;

draw_set_halign(1); draw_set_valign(0);
ui_draw_rect(_contentsbeginx, _titley - _titlescale, _contentsmaxwid, _titlehei + _titlescale * 2, _titlecol, _menualpha);
ui_draw_text(_centerx, _titley, _titlestr, _titlescale, 0, c_black, 1.0);

/// ================================================================================
///     Draw keyslots / inventory
/// ================================================================================
var _keyshighlights  = -1;
if (oKNT.itemRelocateSlotIsPicked)
{
    var _selectedslotid = oKNT.itemRelocateSlotSelected;
    _keyshighlights  = _selectedslotid;
}

ui_draw_keyslots(_centerx, _centery, _keyshighlights, -1, -1, c_white, 1.0, 1, 2);

/// Draw selected key slot info
if (oKNT.itemRelocateSlotIsPicked)
{
    var _selectedslotdata   = oInput.invKeyslots[? oKNT.itemRelocateSlotSelected];
    var _selecteditemttype  = _selectedslotdata[@ eINVKEY.ITEM];
    
    // Draw item swap confirm
    var _confirmy     = _centery;
    var _confirmstr   = "CONFIRM? > ";
    var _confirmscale = 2 * global.gameUIZoom;
    var _confirmhei   = string_height(_confirmstr) * _confirmscale;
    
    draw_set_halign(1); draw_set_valign(0);
    ui_draw_text(_centerx, _confirmy, _confirmstr, _confirmscale, 0, c_orange, 1.0);
    ui_draw_item_info(_centerx * 0.5, _confirmy + _confirmhei + _confirmscale, _selecteditemttype, c_teal, _titlecol, _menualpha);
}

/// ================================================================================
///     Draw bottom footer
/// ================================================================================
var _footerstr1 = "${key, ANY SLOT KEY}${br}SELECT";
var _footerstr2 = "${key, deny} CANCEL";
var _footerstr3 = "SELECT AN ITEM YOU WANT TO SWAP WITH ITEMS IN THE OTHER ROOM";

if (oKNT.itemRelocateSlotIsPicked)
{
    _footerstr1 = "${key, SAME SLOT KEY}${br}CONTINUE";
    _footerstr3 = "CONFIRMING WILL SELECT THIS ITEM FOR SWAPPING WITH ITEMS IN OTHER ROOM!";
}

var _footery = _centery + _centery * 0.6;
ui_draw_footer(_contentsmaxwid, _footery, _footerstr1, _footerstr2, _footerstr3, _titlecol, _menualpha);

#define ui_item_relocate_select_room
/// ================================================================================
///     Declare helper variables
/// ================================================================================
var _centerx = global.winCenterX, _centery = global.winCenterY;
var _titlecol = make_color_hsv(random_range(0, 255), random_range(64, 100) * oGamevars.miscUIFlicker, random_range(220, 255));
var _contentsmaxwid = global.winWid * 0.9;
var _contentsbeginx = (global.winWid - _contentsmaxwid) * 0.5;
var _contentsendx   = _contentsbeginx + _contentsmaxwid;
var _contentsitemmargin = 64 * global.gameUIZoom;
var _contentsitemwid    = _contentsmaxwid - _contentsitemmargin * 2;
var _contentsitemx      = _contentsbeginx + _contentsitemmargin;

var _interp     = interp_weight(fsmStateCtr, room_speed, 2.0, 2.0);
var _interpfast = interp_weight(fsmStateCtr, 8, 2.0, 2.0);

/// ================================================================================
///     Draw BG & information and keyslots
/// ================================================================================
// Draw backdrop
var _backdropalpha = lerp(1.0, 0.75, _interp);
ui_draw_rect(0, 0, global.winWid, global.winHei, c_black, _backdropalpha);

/// Draw paused menu
var _menualpha = _interpfast;

/// ================================================================================
///     Draw title
/// ================================================================================
var _keyslotdata = inv_key_get(oKNT.itemRelocateSlotSelected);
var _keyslotitemstr = oGamevars.itemStr[@ _keyslotdata[@ eINVKEY.ITEM]];
var _titlestr   = "====== RELOCATE FROM WHERE ======";
var _titlescale = 4 * global.gameUIZoom;
var _titley     = 8 * global.gameUIZoom;
var _titlehei   = string_height(_titlestr) * _titlescale;

draw_set_halign(1); draw_set_valign(0);
ui_draw_rect(_contentsbeginx, _titley - _titlescale, _contentsmaxwid, _titlehei + _titlescale * 2, _titlecol, _menualpha);
ui_draw_text(_centerx, _titley, _titlestr, _titlescale, 0, c_black, 1.0);
ui_draw_text(_centerx, _titley + _titlehei + _titlescale, "[CURRENTLY RELOCATING ITEM " + _keyslotitemstr[@ 0] + "]", _titlescale * 0.5, 0, c_orange, 1.0);

_titlehei += string_height("M") * _titlescale * 0.5 + _titlescale;

/// ================================================================================
///     Draw room
/// ================================================================================
var _roomdata = oKNT.itemRelocateRoomCurrentData;
if (oKNT.itemRelocateRoomCurrentData != undefined)
{
    // Room data exists
    // (fetch room data)
    var _roomtitlestr   = _roomdata[@ eROOMDATA.NAME];
    var _roomdescstr    = _roomdata[@ eROOMDATA.DESC];
    var _roomwid        = _roomdata[@ eROOMDATA.WID];
    var _roomhei        = _roomdata[@ eROOMDATA.HEI];
    var _roomtiles      = _roomdata[@ eROOMDATA.TILELIST];
    var _roomtilesnum   = array_length_1d(_roomtiles);
    var _roomentities   = _roomdata[@ eROOMDATA.ENTITYLIST];
    var _roomentitiesnum= array_length_1d(_roomentities);
    var _roomitems      = oKNT.itemRelocateRoomCurrentItems;
    var _availableitems = oKNT.itemRelocateRoomCurrentItemsAvailable;
    
    // Draw the room
    var _roomiconscale = itemRelocateRoomIconscale * global.gameUIZoom;
    var _roomdrawwid = _roomwid * _roomiconscale;
    var _roomdrawhei = _roomhei * _roomiconscale;
    var _roomdrawx = _centerx - _roomdrawwid * 0.5;
    var _roomdrawy = _centery - _roomdrawhei * 0.5;
    
    // (room BG)
    ui_draw_rect(_roomdrawx, _roomdrawy, _roomdrawwid, _roomdrawhei, c_teal, 0.25 * _menualpha);
    // (room tiles)
    for (var i=0; i<_roomtilesnum; i++)
    {
        var _tiledata = _roomtiles[@ i];
        var _tx = _roomdrawx + _tiledata[@ eROOMDATA_TILE.X] * _roomiconscale;
        var _ty = _roomdrawy + _tiledata[@ eROOMDATA_TILE.Y] * _roomiconscale;
        draw_sprite_ext(sprUIMapIcons, 0, _tx, _ty, itemRelocateRoomIconTargetscale, itemRelocateRoomIconTargetscale, 0, c_white, _menualpha);
    }
    // (room entities)
    draw_set_halign(1); draw_set_valign(2);
    for (var i=0; i<_roomentitiesnum; i++)
    {
        var _entdata = _roomentities[@ i];
        var _etype = _entdata[@ eROOMDATA_ENTITY.TYPE];
        var _ex = _roomdrawx + _entdata[@ eROOMDATA_ENTITY.X] * _roomiconscale;
        var _ey = _roomdrawy + _entdata[@ eROOMDATA_ENTITY.Y] * _roomiconscale;
        switch (_etype)
        {
            case eROOMDATA_ENTITY_TYPE.STATION:
                draw_sprite_ext(sprUIMapIcons, 3, _ex, _ey, itemRelocateRoomIconTargetscale, itemRelocateRoomIconTargetscale, 0, c_white, _menualpha);
                ui_draw_text(_ex, _ey, "v YOU ARE HERE v", 1, 0, c_white, _menualpha);
                break;
            case eROOMDATA_ENTITY_TYPE.DOORS:
                draw_sprite_ext(sprUIMapIcons, 1, _ex, _ey, itemRelocateRoomIconTargetscale, itemRelocateRoomIconTargetscale, 0, c_white, _menualpha);
                break;
        }
    }
    
    // (pickups)
    var _selecteditem     = oKNT.itemRelocateRoomCurrentItemsAvailable[| oKNT.itemRelocateRoomCurrentItemSelectedIdx];
    var _selecteditemdata = _selecteditem[@ eROOMDATA_ENTITY.DATA];
    var _selecteditemidx  = _selecteditemdata[@ 2];
    var _itemflickeralpha = 1.0;
    if (!oKNT.itemRelocateRoomIsSelecting)
        _itemflickeralpha = sin(current_time * 0.002 * pi) * 0.5 + 0.5;
    
    draw_set_halign(0); draw_set_valign(2);
    for (var i=0; i<ds_list_size(_roomitems); i++)
    {
        var _entdata = _roomitems[| i];
        var _ex = _roomdrawx + _entdata[@ eROOMDATA_ENTITY.X] * _roomiconscale;
        var _ey = _roomdrawy + _entdata[@ eROOMDATA_ENTITY.Y] * _roomiconscale;
        
        var _emiscdata  = _entdata[@ eROOMDATA_ENTITY.DATA];
        var _pickuptype = _emiscdata[@ 0];
        var _unlocked   = _emiscdata[@ 1];
        var _itemstr    = oGamevars.itemStr[@ _pickuptype];
        var _itemalpha  = 1.0;
        
        if (!_unlocked)
            _itemalpha = 0.25;
            
        if (_selecteditemidx == i)
            _itemalpha *= _itemflickeralpha;
        
        draw_sprite_ext(sprUIMapIcons, 2, _ex, _ey, itemRelocateRoomIconTargetscale, itemRelocateRoomIconTargetscale, 0, c_white, _menualpha * _itemalpha);
        ui_draw_text(_ex, _ey, _itemstr[@ 0], 1, 0, c_white, _menualpha * _itemalpha);
    }
    
    // (draw room info)
    var _infoformat = "ADMIN@SHIP_CTRL :> RMSCAN '${0}' -item --no-verbose${br}SCANNING ROOM '${0}'.......DONE${br}" + string_repeat("=", 8) + "${br}FOUND ${1} ITEMS AVAILABLE FOR RELOCATING :";
    var _infoargs   = makearray(_roomtitlestr, ds_list_size(_availableitems));
    var _infoscale  = 2.0 * global.gameUIZoom;
    var _infohei    = ui_draw_text_format_get_height(_infoformat, _infoargs) * _infoscale;
    var _infoy      = _titley + _titlehei + 16 * global.gameUIZoom;
    ui_draw_text_format(_contentsitemmargin, _infoy + _infoscale, _infoformat, _infoscale, c_black, _menualpha, 0, 0, _infoargs);
    ui_draw_text_format(_contentsitemmargin, _infoy, _infoformat, _infoscale, c_white, _menualpha, 0, 0, _infoargs);
    
    // (draw available items in room)
    var _infostr = "";
    for (var i=0; i<ds_list_size(_availableitems); i++)
    {
        var _ent  = _availableitems[| i];
        var _data = _ent[@ eROOMDATA_ENTITY.DATA];
        var _itemstr = oGamevars.itemStr[@ _data[@ 0]];
        _infostr += "#" + _itemstr[@ 0];
    }
    
    _infoy += _infohei;
    ui_draw_text(_contentsitemmargin, _infoy + _infoscale, _infostr, _infoscale, 0, c_black, _menualpha);
    ui_draw_text(_contentsitemmargin, _infoy, _infostr, _infoscale, 0, c_white, _menualpha);
    
    if (!oKNT.itemRelocateRoomIsSelecting)
    {
        var _itemstr = "";
        var _selecteditem = oKNT.itemRelocateRoomCurrentItemsAvailable[| oKNT.itemRelocateRoomCurrentItemSelectedIdx];
        if (_selecteditem != undefined)
        {
            var _itemdata    = _selecteditem[@ eROOMDATA_ENTITY.DATA];
            var _itemstrings = oGamevars.itemStr[@ _itemdata[@ 0]];
            _itemstr = _itemstrings[@ 0];
        }
        
        // (draw item info)
        var _infoformat = "SWAP ${0} -WITH-> ${1}?";
        var _infoargs   = makearray(_keyslotitemstr[@ 0], _itemstr);
        var _infoscale  = 2 * global.gameUIZoom;
        var _infohei    = ui_draw_text_format_get_height(_infoformat, _infoargs) * _infoscale;
        var _infoy      = _centery + _centery * 0.5;
        
        ui_draw_text_format(_centerx, _infoy + _infoscale, _infoformat, _infoscale, c_black, _menualpha, 1, 1, _infoargs);
        ui_draw_text_format(_centerx, _infoy, _infoformat, _infoscale, c_white, _menualpha, 1, 1, _infoargs);
    }
}
else
{
    // Room data doesn't exist
    var _infostr = "ROOM DATA DOESN'T EXIST IN THIS ROOM";
    var _infostrwid = string_width_ext(_infostr, -1, _contentsitemwid / _titlescale) * _titlescale;
    var _infostrhei = string_height_ext(_infostr, -1, _contentsitemwid / _titlescale) * _titlescale;
    draw_set_halign(1); draw_set_valign(1);
    ui_draw_rect(_centerx - _infostrwid * 0.5 - _titlescale, _centery - _infostrhei * 0.5 - _titlescale, _infostrwid + _titlescale * 2, _infostrhei + _titlescale * 2, c_orange, _menualpha);
    ui_draw_text_ext(_centerx, _centery, _infostr, -1, _contentsitemwid, _titlescale, 0, c_black, 1.0);
}

/// ================================================================================
///     Draw bottom footer
/// ================================================================================
var _footerstr1 = "";
var _footerstr2 = "";
var _footerstr3 = "";
if (oKNT.itemRelocateRoomIsSelecting)
{
    _footerstr1  = "${key, left}/${key, right} NAVIGATE";
    _footerstr2  = "${key, confirm}${key, confirm_alt} SELECT ROOM${br}${key, deny}${key, deny_alt} RETURN";
    _footerstr3  = "SELECT THE ROOM YOU WANT TO RELOCATE ITEMS FROM";
}
else
{
    _footerstr1  = "${key, left}/${key, right} SELECT ITEM";
    _footerstr2  = "${key, confirm}${key, confirm_alt} CONFIRM${br}${key, deny}${key, deny_alt} RETURN";
    _footerstr3  = "SELECT THE ITEM YOU WANT TO RELOCATE";
}
var _footery = _centery + _centery * 0.75;
ui_draw_footer(_contentsmaxwid, _footery, _footerstr1, _footerstr2, _footerstr3, _titlecol, _menualpha);

#define ui_objective_menu
/// ================================================================================
///     Declare helper variables
/// ================================================================================
var _centerx = global.winCenterX, _centery = global.winCenterY;
var _titlecol = make_color_hsv(random_range(0, 255), random_range(64, 100) * oGamevars.miscUIFlicker, random_range(220, 255));
var _contentsmaxwid = global.winWid * 0.75;
var _contentsbeginx = (global.winWid - _contentsmaxwid) * 0.5;
var _contentsendx   = _contentsbeginx + _contentsmaxwid;
var _contentsitemmargin = 64 * global.gameUIZoom;
var _contentsitemwid    = _contentsmaxwid - _contentsitemmargin * 2;
var _contentsitemx      = _contentsbeginx + _contentsitemmargin;

var _interp     = interp_weight(fsmStateCtr, room_speed, 2.0, 2.0);
var _interpfast = interp_weight(fsmStateCtr, 8, 2.0, 2.0);

/// ================================================================================
///     Draw BG & information and keyslots
/// ================================================================================
// Draw backdrop
var _backdropalpha = lerp(1.0, 0.75, _interp);
ui_draw_rect(0, 0, global.winWid, global.winHei, c_black, _backdropalpha);
var _menualpha = _interpfast;

/// ================================================================================
///     Draw progression
/// ================================================================================
var _progressstr   = "REPAIR PROGRESS...${0}/${1}";
var _progressarg   = makearray(oGamevars.progress, oGamevars.progressMax);
var _progressscale = 4 * global.gameUIZoom;
var _progressy     = _centery * 0.5;
ui_draw_text_format(_centerx, _progressy, _progressstr, _progressscale, _titlecol, _menualpha, 1, 1, _progressarg);

/// ================================================================================
///     Draw title
/// ================================================================================
var _titlestr   = "====== CTL. STATION ======";
var _titlescale = 4 * global.gameUIZoom;
var _titley     = _centery * 0.75;
var _titlehei   = string_height(_titlestr) * _titlescale;

draw_set_halign(1); draw_set_valign(0);
ui_draw_rect(_contentsbeginx, _titley - _titlescale, _contentsmaxwid, _titlehei + _titlescale * 2, _titlecol, _menualpha);
ui_draw_text(_centerx, _titley, _titlestr, _titlescale, 0, c_black, 1.0);

/// ================================================================================
///     Draw menu
/// ================================================================================
var _menuitemscale  = 3 * global.gameUIZoom;
var _menuitemhei    = string_height("M") * _menuitemscale;
var _menuitemy  = _titley + _titlehei + _titlescale * 4;
var _menustepy  = _menuitemhei + _menuitemscale * 2;
draw_set_halign(0); draw_set_valign(0);
for (var i=0; i<array_length_1d(objectiveMenuList); i++)
{
    var _menuitem       = objectiveMenuList[@ i];
    var _menuitemstr    = _menuitem[@ 1];
    
    if (i == objectiveMenuSelected)
    {
        // current item is selected, draw backdrop and text & flashy marker
        var _menuitemprefix = "   ";
        if ((fsmStateCtr >> 2) & 1 == 0)
            _menuitemprefix = " > ";
        
        ui_draw_rect(_contentsitemx, _menuitemy - _menuitemscale, _contentsitemwid, _menuitemhei + _menuitemscale * 2, _titlecol, _menualpha);
        ui_draw_text(_contentsitemx, _menuitemy, _menuitemprefix + _menuitemstr, _menuitemscale, 0, c_black, 1.0);
    }
    else
    {
        // current item isn't selected
        ui_draw_text(_contentsitemx, _menuitemy, _menuitemstr, _menuitemscale, 0, _titlecol, _menualpha);
    }
    _menuitemy += _menustepy;
}

/// ================================================================================
///     Draw bottom footer
/// ================================================================================
var _currentmenu = objectiveMenuList[@ objectiveMenuSelected];
var _footerstr1  = "${key, up}/${key, down} MOVE";
var _footerstr2  = "${key, confirm}${key, confirm_alt} CONFIRM${br}${key, deny}${key, deny_alt} RETURN";
var _footerstr3  = _currentmenu[@ 2];
var _footery     = _centery + _centery * 0.6;
ui_draw_footer(_contentsmaxwid, _footery, _footerstr1, _footerstr2, _footerstr3, _titlecol, _menualpha);

#define ui_powercell_deposit
/// ================================================================================
///     Declare helper variables & draw backdrop
/// ================================================================================
var _centerx = global.winCenterX, _centery = global.winCenterY;
var _titlecol        = make_color_hsv(random_range(0, 255), random_range(64, 100) * oGamevars.miscUIFlicker, random_range(220, 255));
var _titlecolintense = make_color_hsv(random_range(0, 255), random_range(100, 200) * oGamevars.miscUIFlicker, random_range(220, 255));
var _contentsmaxwid = global.winWid * 0.75;
var _contentsbeginx = (global.winWid - _contentsmaxwid) * 0.5;
var _contentsendx   = _contentsbeginx + _contentsmaxwid;
var _contentsitemmargin = 64 * global.gameUIZoom;
var _contentsitemwid    = _contentsmaxwid - _contentsitemmargin * 2;
var _contentsitemx      = _contentsbeginx + _contentsitemmargin;

var _interp     = interp_weight(fsmStateCtr, room_speed, 2.0, 2.0);
var _interpfast = interp_weight(fsmStateCtr, 8, 2.0, 2.0);
var _menualpha = _interpfast;

/// Draw backdrop
var _backdropalpha = _interp * 0.75;
ui_draw_rect(0, 0, global.winWid, global.winHei, c_black, _backdropalpha);

/// ================================================================================
///     Draw title & progression
/// ================================================================================
var _titlestr   = "==== DEPOSIT CELLS ====";
var _titlescale = 4 * global.gameUIZoom;
var _titley     = _centery * 0.25;
var _titlehei   = string_height(_titlestr) * _titlescale;

draw_set_halign(1); draw_set_valign(0);
ui_draw_rect(_contentsbeginx, _titley - _titlescale, _contentsmaxwid, _titlehei + _titlescale * 2, _titlecol, _menualpha);
ui_draw_text(_centerx, _titley, _titlestr, _titlescale, 0, c_black, 1.0);

/// Draw progress
var _progressstr    = "POWER : " + string(oGamevars.progress) + " / " + string(oGamevars.progressMax) + "";
var _progressscale  = 4 * global.gameUIZoom;
var _progressy      = _titley + _titlehei + _progressscale;
draw_set_halign(1); draw_set_valign(0);
ui_draw_text(_centerx, _progressy, _progressstr, _progressscale, 0, c_orange, _menualpha);

/// ================================================================================
///     Draw keyslot / inventory
/// ================================================================================
var _keyshighlight = eITEM.ITEM_POWERCELL;
ui_draw_keyslots(_centerx, _centery, -1, -1, _keyshighlight, c_white, _menualpha, 1, 1);

/// Draw description
// var _descstr    = "> Press any slots w/ POWER CANISTER to deposit#> POWER CANISTERS are highlighted with yellow background#> ESCAPE to leave";
/// ================================================================================
///     Draw bottom footer
/// ================================================================================
var _footerstr1 = "${key, KEY SLOTS}${br}DEPOSIT";
var _footerstr2 = "${key, deny} RETURN";
var _footerstr3 = "PRESS ANY KEY SLOTS WITH [POWER CANISTER] ASSIGNED TO DEPOSIT... POWER CANISTERS ARE HIGHLIGHTED FOR YOUR CONVENIENCE";
var _footery = _centery + _centery * 0.6;
ui_draw_footer(_contentsmaxwid, _footery, _footerstr1, _footerstr2, _footerstr3, _titlecol, _menualpha);

#define ui_teleport_select
var _centerx = global.winCenterX, _centery = global.winCenterY;

/// Draw backdrop
var _backdropalpha = 0.5;
ui_draw_rect(0, 0, global.winWid, global.winHei, c_black, _backdropalpha);

/// Draw teleport select screen
// (title)
var _titlestr       = "> TELEPORT WHERE? <";
var _titlescale     = UITitleScaleSmall;
var _titley         = 16;
var _titlehei       = string_height(_titlestr) * _titlescale;
var _titlecol       = make_color_hsv(random_range(0, 255), random_range(0, 100) * oGamevars.miscUIFlicker, random_range(220, 255));
draw_set_halign(1); draw_set_valign(0);
ui_draw_text(_centerx, _titley, _titlestr, _titlescale, 0, _titlecol, 1.0);

// (list of teleports)
var _tplist     = oGamevars.teleportList;
var _tplistsz   = ds_list_size(_tplist);
// var _tplistwid  = global.winWid * 0.5;

var _tpliststrscale     = 2 * global.gameUIZoom;
var _tpliststrmargin    = 4;
var _tpliststrheight    = string_height("M") * _tpliststrscale;
var _tpliststrheightfull= _tpliststrheight + _tpliststrmargin;
var _tplistdrawy        = _centery - _tpliststrheightfull * _tplistsz * 0.5;
for (var i=0; i<_tplistsz; i++)
{
    var _tpdata = _tplist[| i];
    var _tpstrcol  = c_white;
    if (i == oKNT.ingameTeleportSelectIdx)
        _tpstrcol = c_yellow;
    else if (_tpdata[@ eTP.ROOM] == room)
        _tpstrcol = c_gray;
    
    draw_set_halign(1); draw_set_valign(0);
    ui_draw_text(_centerx, _tplistdrawy, _tpdata[@ eTP.NAME], _tpliststrscale, 0, _tpstrcol, 1.0);
    _tplistdrawy += _tpliststrheightfull;
}

/// Draw description
var _descstr    = "> UP and DOWN to navigate#> RETURN to confirm";
var _descscale  = 2 * global.gameUIZoom;
var _descy      = global.winHei - 16;
var _desccol    = c_yellow;
draw_set_halign(1); draw_set_valign(2);
ui_draw_text(_centerx, _descy + _descscale, _descstr, _descscale, 0, c_black, 1.0);
ui_draw_text(_centerx, _descy, _descstr, _descscale, 0, _desccol, 1.0);
#define ui_debug
/// ================================================================================
///     Declare helper variables
/// ================================================================================
var _centerx = global.winCenterX, _centery = global.winCenterY;
var _titlecol = make_color_hsv(random_range(0, 255), random_range(64, 100) * oGamevars.miscUIFlicker, random_range(220, 255));
var _contentsmaxwid = global.winWid * 0.75;
var _contentsbeginx = (global.winWid - _contentsmaxwid) * 0.5;
var _contentsendx   = _contentsbeginx + _contentsmaxwid;
var _contentsitemmargin = 64 * global.gameUIZoom;
var _contentsitemwid    = _contentsmaxwid - _contentsitemmargin * 2;
var _contentsitemx      = _contentsbeginx + _contentsitemmargin;

var _interp     = interp_weight(fsmStateCtr, room_speed, 2.0, 2.0);
var _interpfast = interp_weight(fsmStateCtr, 8, 2.0, 2.0);

/// ================================================================================
///     Draw BG & information and keyslots
/// ================================================================================
// Draw backdrop
var _backdropalpha = lerp(1.0, 0.75, _interp);
ui_draw_rect(0, 0, global.winWid, global.winHei, c_black, _backdropalpha);

/// Draw paused menu
var _menualpha = _interpfast;

/// ================================================================================
///     Draw title
/// ================================================================================
var _titlestr   = "======== DEBUG ========";
var _titlescale = 4 * global.gameUIZoom;
var _titley     = 16 * global.gameUIZoom;
var _titlehei   = string_height(_titlestr) * _titlescale;

draw_set_halign(1); draw_set_valign(0);
ui_draw_rect(_contentsbeginx, _titley - _titlescale, _contentsmaxwid, _titlehei + _titlescale * 2, _titlecol, _menualpha);
ui_draw_text(_centerx, _titley, _titlestr, _titlescale, 0, c_black, 1.0);

/// ================================================================================
///     Draw menu
/// ================================================================================
var _menuitemscale  = 3 * global.gameUIZoom;
var _menuitemhei    = string_height("M") * _menuitemscale;
var _menuitemy  = _titley + _titlehei + _titlescale * 4;
var _menustepy  = _menuitemhei + _menuitemscale * 2;
draw_set_halign(0); draw_set_valign(0);
for (var i=0; i<array_length_1d(debugMenuList); i++)
{
    var _menuitem       = debugMenuList[@ i];
    var _menuitemstr    = _menuitem[@ 1];
    
    if (i == debugMenuSelected)
    {
        // current item is selected, draw backdrop and text & flashy marker
        var _menuitemprefix = "   ";
        if ((fsmStateCtr >> 2) & 1 == 0)
            _menuitemprefix = " > ";
        
        ui_draw_rect(_contentsitemx, _menuitemy - _menuitemscale, _contentsitemwid, _menuitemhei + _menuitemscale * 2, _titlecol, _menualpha);
        ui_draw_text(_contentsitemx, _menuitemy, _menuitemprefix + _menuitemstr, _menuitemscale, 0, c_black, 1.0);
    }
    else
    {
        // current item isn't selected
        ui_draw_text(_contentsitemx, _menuitemy, _menuitemstr, _menuitemscale, 0, _titlecol, _menualpha);
    }
    _menuitemy += _menustepy;
}

/// ================================================================================
///     Draw bottom footer
/// ================================================================================
var _currentmenu = debugMenuList[@ debugMenuSelected];
var _footerstr1  = "${key, up}/${key, down} MOVE";
var _footerstr2  = "${key, confirm}${key, confirm_alt} CONFIRM${br}${key, deny}${key, deny_alt} RETURN";
var _footerstr3  = _currentmenu[@ 2];
var _footery     = _centery + _centery * 0.75;
ui_draw_footer(_contentsmaxwid, _footery, _footerstr1, _footerstr2, _footerstr3, _titlecol, _menualpha);


#define ui_debug_roomdata
/// ================================================================================
///     Declare helper variables
/// ================================================================================
var _centerx = global.winCenterX, _centery = global.winCenterY;
var _titlecol = make_color_hsv(random_range(0, 255), random_range(64, 100) * oGamevars.miscUIFlicker, random_range(220, 255));
var _contentsmaxwid = global.winWid * 0.75;
var _contentsbeginx = (global.winWid - _contentsmaxwid) * 0.5;
var _contentsendx   = _contentsbeginx + _contentsmaxwid;
var _contentsitemmargin = 64 * global.gameUIZoom;
var _contentsitemwid    = _contentsmaxwid - _contentsitemmargin * 2;
var _contentsitemx      = _contentsbeginx + _contentsitemmargin;

var _interp     = interp_weight(fsmStateCtr, room_speed, 2.0, 2.0);
var _interpfast = interp_weight(fsmStateCtr, 8, 2.0, 2.0);

/// ================================================================================
///     Draw BG & information and keyslots
/// ================================================================================
// Draw backdrop
var _backdropalpha = lerp(1.0, 0.75, _interp);
ui_draw_rect(0, 0, global.winWid, global.winHei, c_black, _backdropalpha);

/// Draw paused menu
var _menualpha = _interpfast;

/// ================================================================================
///     Draw title
/// ================================================================================
var _titlestr   = "====== " + room_get_name(debugRoomdataCurrentRoom) + " ======";
var _titlescale = 4 * global.gameUIZoom;
var _titley     = 8 * global.gameUIZoom;
var _titlehei   = string_height(_titlestr) * _titlescale;

draw_set_halign(1); draw_set_valign(0);
ui_draw_rect(_contentsbeginx, _titley - _titlescale, _contentsmaxwid, _titlehei + _titlescale * 2, _titlecol, _menualpha);
ui_draw_text(_centerx, _titley, _titlestr, _titlescale, 0, c_black, 1.0);

/// ================================================================================
///     Draw room data
/// ================================================================================
if (debugRoomdataCurrentRoomData != undefined)
{
    // Room data exists
    // (fetch room data)
    var _roomtitlestr   = debugRoomdataCurrentRoomData[@ eROOMDATA.NAME];
    var _roomdescstr    = debugRoomdataCurrentRoomData[@ eROOMDATA.DESC];
    var _roomwid = debugRoomdataCurrentRoomData[@ eROOMDATA.WID];
    var _roomhei = debugRoomdataCurrentRoomData[@ eROOMDATA.HEI];
    var _roomtiles      = debugRoomdataCurrentRoomData[@ eROOMDATA.TILELIST];
    var _roomtilesnum   = array_length_1d(_roomtiles);
    var _roomentities   = debugRoomdataCurrentRoomData[@ eROOMDATA.ENTITYLIST];
    var _roomentitiesnum= array_length_1d(_roomentities);
    
    if (_roomdescstr == "")
        _roomdescstr = "(NONE. NADA.)";
    
    // Draw the room
    var _roomdrawwid = _roomwid * debugRoomdataScale;
    var _roomdrawhei = _roomhei * debugRoomdataScale;
    var _roomdrawx = _centerx - _roomdrawwid * 0.5;
    var _roomdrawy = _centery - _roomdrawhei * 0.5;
    // (room BG)
    ui_draw_rect(_roomdrawx, _roomdrawy, _roomdrawwid, _roomdrawhei, c_teal, 0.25);
    // (room tiles)
    for (var i=0; i<_roomtilesnum; i++)
    {
        var _tiledata = _roomtiles[@ i];
        var _tx = _roomdrawx + _tiledata[@ eROOMDATA_TILE.X] * debugRoomdataScale;
        var _ty = _roomdrawy + _tiledata[@ eROOMDATA_TILE.Y] * debugRoomdataScale;
        ui_draw_rect(_tx, _ty, debugRoomdataTilesize, debugRoomdataTilesize, c_orange, 1.0);
    }
    // (room entities)
    draw_set_halign(0); draw_set_valign(2);
    for (var i=0; i<_roomentitiesnum; i++)
    {
        var _entdata = _roomentities[@ i];
        var _etype = _entdata[@ eROOMDATA_ENTITY.TYPE];
        var _ex = _roomdrawx + _entdata[@ eROOMDATA_ENTITY.X] * debugRoomdataScale;
        var _ey = _roomdrawy + _entdata[@ eROOMDATA_ENTITY.Y] * debugRoomdataScale;
        switch (_etype)
        {
            case eROOMDATA_ENTITY_TYPE.PICKUP:
                var _emiscdata  = _entdata[@ eROOMDATA_ENTITY.DATA];
                var _pickuptype = _emiscdata[@ 0];
                var _pickupidx  = _emiscdata[@ 1];
                draw_sprite_ext(sprPickup, _pickuptype, _ex, _ey, debugRoomdataScale, debugRoomdataScale, 0, c_white, 1.0);
                ui_draw_text(_ex, _ey, "\#" + string(_pickupidx), 1, 0, c_white, 1.0);
                break;
            case eROOMDATA_ENTITY_TYPE.ENEMIES:
                draw_sprite_ext(sprEnemy, 0, _ex, _ey, debugRoomdataScale, debugRoomdataScale, 0, c_white, 1.0);
                break;
            case eROOMDATA_ENTITY_TYPE.DOORS:
                var _emiscdata  = _entdata[@ eROOMDATA_ENTITY.DATA];
                var _doordest   = _emiscdata[@ 0];
                var _doorid     = _emiscdata[@ 1];
                draw_sprite_ext(sprTileDoor, 0, _ex, _ey, debugRoomdataScale, debugRoomdataScale, 0, c_white, 1.0);
                ui_draw_text(_ex, _ey, room_get_name(_doordest) + "#" + string(_doorid), 1, 0, c_ltgray, 1.0);
                break;
            case eROOMDATA_ENTITY_TYPE.TELEPORT:
                var _teleportidx = _entdata[@ eROOMDATA_ENTITY.DATA];
                draw_sprite_ext(sprTileDoor, 0, _ex, _ey, debugRoomdataScale, debugRoomdataScale, 0, c_white, 1.0);
                ui_draw_text(_ex, _ey, "\#" + string(_teleportidx), 1, 0, c_white, 1.0);
                break;
            case eROOMDATA_ENTITY_TYPE.STATION:
                draw_sprite_ext(sprObjective, 0, _ex, _ey, debugRoomdataScale * 2, debugRoomdataScale * 2, 0, c_white, 1.0);
                break;
        }
    }
    
    // (draw room info)
    var _infoformat = "ID : ${0}, NAME : ${1}${br}DESC : ${2}${br}DIM : [${3}, ${4}]${br}${5} TILES AND ${6} ENTITIES${br}" + string_repeat("=", 8) + "${br}ROOM EVENTS>${br}${7}";
    var _infoargs   = makearray(debugRoomdataCurrentRoom, _roomtitlestr, _roomdescstr, _roomwid, _roomhei, _roomtilesnum, _roomentitiesnum, debugRoomdataCurrentRoomEventsStr);
    var _infoy      = _titley + _titlehei + 4 * global.gameUIZoom;
    var _infoscale  = 2 * global.gameUIZoom;
    ui_draw_text_format(_contentsitemmargin, _infoy + _infoscale, _infoformat, _infoscale, c_black, _menualpha, 0, 0, _infoargs);
    ui_draw_text_format(_contentsitemmargin, _infoy, _infoformat, _infoscale, c_white, _menualpha, 0, 0, _infoargs);
}
else
{
    // Room data doesn't exist
    var _infostr = "ROOM DATA DOESN'T EXIST IN THIS ROOM";
    var _infostrwid = string_width_ext(_infostr, -1, _contentsitemwid / _titlescale) * _titlescale;
    var _infostrhei = string_height_ext(_infostr, -1, _contentsitemwid / _titlescale) * _titlescale;
    draw_set_halign(1); draw_set_valign(1);
    ui_draw_rect(_centerx - _infostrwid * 0.5 - _titlescale, _centery - _infostrhei * 0.5 - _titlescale, _infostrwid + _titlescale * 2, _infostrhei + _titlescale * 2, c_orange, _menualpha);
    ui_draw_text_ext(_centerx, _centery, _infostr, -1, _contentsitemwid, _titlescale, 0, c_black, 1.0);
}

#define ui_debug_keylayout
/// ================================================================================
///     Declare helper variables
/// ================================================================================
var _centerx = global.winCenterX, _centery = global.winCenterY;
var _titlecol = make_color_hsv(random_range(0, 255), random_range(64, 100) * oGamevars.miscUIFlicker, random_range(220, 255));
var _contentsmaxwid = global.winWid * 0.85;
var _contentsbeginx = (global.winWid - _contentsmaxwid) * 0.5;
var _contentsendx   = _contentsbeginx + _contentsmaxwid;
var _contentsitemmargin = 64 * global.gameUIZoom;
var _contentsitemwid    = _contentsmaxwid - _contentsitemmargin * 2;
var _contentsitemx      = _contentsbeginx + _contentsitemmargin;

var _interp     = interp_weight(fsmStateCtr, room_speed, 2.0, 2.0);
var _interpfast = interp_weight(fsmStateCtr, 8, 2.0, 2.0);

/// ================================================================================
///     Draw BG
/// ================================================================================
// Draw backdrop
var _backdropalpha = lerp(1.0, 0.75, _interp);
ui_draw_rect(0, 0, global.winWid, global.winHei, c_black, _backdropalpha);

/// Draw paused menu
var _menualpha = _interpfast;

/// ================================================================================
///     Draw title
/// ================================================================================
var _titlestr   = "====== KEYLAYOUT ======";
var _titlescale = 4 * global.gameUIZoom;
var _titley     = 8 * global.gameUIZoom;
var _titlehei   = string_height(_titlestr) * _titlescale;

draw_set_halign(1); draw_set_valign(0);
ui_draw_rect(_contentsbeginx, _titley - _titlescale, _contentsmaxwid, _titlehei + _titlescale * 2, _titlecol, _menualpha);
ui_draw_text(_centerx, _titley, _titlestr, _titlescale, 0, c_black, 1.0);
ui_draw_text(_centerx, _titley + _titlehei + _titlescale, "LAYOUTID : " + string(oUI.UIInputLayoutCurrent), _titlescale * 0.5, 0, _titlecol, _menualpha);

/// ================================================================================
///     Draw keyslots
/// ================================================================================
if (oUI.UIInputLayoutCurrentData != undefined)
{
    var _layoutitemsize     = oUI.UIInputLayoutItemScale * global.gameUIZoom;
    var _layoutgriditemsize = oUI.UIInputLayoutItemSize * _layoutitemsize;
    
    var _layoutconfig = oUI.UIInputLayoutCurrentData[@ eKEYLAYOUT.CONFIG];
    var _layoutname = _layoutconfig[@ eKEYLAYOUT_CONFIG.NAME];
    var _layoutwid  = _layoutconfig[@ eKEYLAYOUT_CONFIG.GRIDW] * _layoutgriditemsize + oUI.UIInputLayoutItemMarginH * _layoutitemsize;
    var _layouthei  = _layoutconfig[@ eKEYLAYOUT_CONFIG.GRIDH] * _layoutgriditemsize + oUI.UIInputLayoutItemMarginV * _layoutitemsize;
    var _layoutspr  = _layoutconfig[@ eKEYLAYOUT_CONFIG.SPRITESET];
    
    var _layoutdescy = _titley + _titlehei + _titlescale;
    var _layoutdescstr = "NAME : ${0}${br}WID, HEI : [${1},${2}]${br}SPRITESET : ${3}";
    var _layoutdescarg = makearray(_layoutname, _layoutwid, _layouthei, _layoutspr);
    ui_draw_text_format(_contentsbeginx, _layoutdescy, _layoutdescstr, 1, c_white, 1.0, 0, 0, _layoutdescarg);
    ui_draw_rect(_centerx - _layoutwid * 0.5, _centery - _layouthei * 0.5, _layoutwid, _layouthei, c_teal, 0.5);
}

var _keysdrawx = _centerx;
var _keysdrawy = _centery;
ui_draw_keyslots(_keysdrawx, _keysdrawy, -1, -1, -1, c_white, 1.0, 1, 1);

/// ================================================================================
///     Draw footer
/// ================================================================================
ui_draw_footer(_contentsmaxwid, global.winHei * 0.85, "PRESS ENTER TO RELOAD LAYOUT", "", "", _titlecol, _menualpha);