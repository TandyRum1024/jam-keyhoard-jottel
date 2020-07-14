#define ui_ingame
var _centerx = global.winCenterX, _centery = global.winCenterY;
var _titlecol = make_color_hsv(random_range(0, 255), random_range(64, 100), random_range(220, 255));

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
    draw_set_halign(1); draw_set_valign(2);
    ui_draw_text(_centerx, global.winHei - 16, "> ENTER TO RE-DEPLOY", 4, 0, _titlecol, 1.0);
}

/// Draw message
ui_draw_message();

#define ui_nothing
draw_clear(c_black);

#define ui_title
var _centerx = global.winCenterX, _centery = global.winCenterY;
var _titlecol = make_color_hsv(random_range(0, 255), random_range(64, 100), random_range(220, 255));

draw_clear(c_black);

draw_set_halign(1); draw_set_valign(1);
ui_draw_text(_centerx, _centery * 0.5, "KEYHOARD#JOTTEL", titleLogoScale, 0, _titlecol, 1.0);

draw_set_halign(1); draw_set_valign(0);
ui_draw_text(_centerx, global.winHei * 0.75, "> ENTER", 2, 0, _titlecol, 1.0);

draw_set_halign(1); draw_set_valign(2);
ui_draw_text(_centerx, global.winHei  - 16, "ZIK @ MMXX#MADE IN 48 HOURS FOR GAME MAKERS TOOLKIT GAME JAM 2020", 2, 0, c_gray, 1.0);

#define ui_intro
var _centerx = global.winCenterX, _centery = global.winCenterY;
var _titlecol = make_color_hsv(random_range(0, 255), random_range(64, 100), random_range(220, 255));

draw_clear(c_black);

// Draw cutscene sprite
var _cutscenescale = 6;
draw_sprite_ext(sprUICutsceneBegin, oKNT.introCutsceneIdx, _centerx, _centery, _cutscenescale, _cutscenescale, 0, c_white, 1.0);

// Draw continue msg
if (oKNT.introCutsceneReady)
{
    draw_set_halign(1); draw_set_valign(2);
    ui_draw_text(_centerx, global.winHei - 32, "> ENTER", 2, 0, _titlecol, 1.0);
}

#define ui_ending
var _centerx = global.winCenterX, _centery = global.winCenterY;
var _titlecol = make_color_hsv(random_range(0, 255), random_range(64, 100), random_range(220, 255));

draw_clear(c_black);

draw_set_halign(1); draw_set_valign(0);
ui_draw_text(_centerx, 16, "THE END?", titleLogoScale, 0, _titlecol, 1.0);

// Draw cutscene sprite
var _cutscenescale = 6;
draw_sprite_ext(sprUICutsceneBegin, 0, _centerx, _centery, _cutscenescale, _cutscenescale, 0, c_white, 1.0);

draw_set_halign(1); draw_set_valign(2);
ui_draw_text(_centerx, global.winHei - 16, "GAME BY ZIK#MADE FOR GMTK GAME JAM 2020#TYSM FOR PLAYING :>", 2, 0, _titlecol, 1.0);

#define ui_item_get
if (!fsmStateInit)
{
    itemGetReady = false;
}

var _centerx = global.winCenterX, _centery = global.winCenterY;

/// Draw backdrop
var _interp = interp_weight(fsmStateCtr, room_speed, 2.0, 2.0);
var _backdropalpha = _interp * 0.75;
ui_draw_rect(0, 0, global.winWid, global.winHei, c_black, _backdropalpha);

/// Draw HP
// ui_draw_hp();

/// Draw message
// ui_draw_message();
var _colintense = make_color_hsv(random_range(0, 255), random_range(100, 200), random_range(220, 255));

/// Draw item get screen
// (title)
var _obtaintitlestr     = "> ITEM GET <";
var _obtaintitlescale   = 6;
var _obtaintitley       = 16;
var _obtaintitlehei     = string_height(_obtaintitlestr) * _obtaintitlescale;
var _obtaintitlecol     = make_color_hsv(random_range(0, 255), random_range(0, 100), random_range(220, 255));
draw_set_halign(1); draw_set_valign(0);
ui_draw_text(_centerx, _obtaintitley, _obtaintitlestr, _obtaintitlescale, 0, _obtaintitlecol, 1.0);

// (item icon)
// var _obtainitemiconspr      = oGamevars.itemIcon[@ itemGetType];
var _obtainitemiconscale    = 6;
var _obtainitemiconwid      = _obtainitemiconscale * sprite_get_width(sprPickup);
var _obtainitemiconhei      = _obtainitemiconscale * sprite_get_height(sprPickup);
var _obtainitemiconx        = _centerx - _obtainitemiconwid * 0.5 + sprite_get_xoffset(sprPickup) * _obtainitemiconscale;
var _obtainitemicony        = _centery * 0.75 - _obtainitemiconhei * 0.5 + sprite_get_yoffset(sprPickup) * _obtainitemiconscale;
draw_sprite_ext(sprPickup, itemGetType, _obtainitemiconx, _obtainitemicony, _obtainitemiconscale, _obtainitemiconscale, 0, c_white, 1.0);

// (item name & description)
var _obtainitemstrwid   = global.winWid * 0.9;
var _obtainitemstr      = oGamevars.itemStr[@ itemGetType];
var _obtainitemnamestr      = _obtainitemstr[@ 0];
var _obtainitemnamescale    = 4;
var _obtainitemnamey        = _centery * 0.75 + _obtainitemiconhei * 0.5 + 32;
var _obtainitemnamehei      = string_height(_obtainitemnamestr) * _obtainitemnamescale;
var _obtainitemnamecol      = make_color_hsv(random_range(0, 255), random_range(0, 100), random_range(220, 255));
var _obtainitemdescstr      = _obtainitemstr[@ 1];
var _obtainitemdescscale    = 2;
var _obtainitemdescy        = _obtainitemnamey + _obtainitemnamehei;
var _obtainitemdeschei      = string_height_ext(_obtainitemdescstr, -1, _obtainitemstrwid / _obtainitemdescscale) * _obtainitemdescscale;
var _obtainitemdesccol      = c_white;
var _obtainitemfuncstr      = _obtainitemstr[@ 2];
var _obtainitemfuncscale    = 2;
var _obtainitemfuncy        = _obtainitemdescy + _obtainitemdeschei;
var _obtainitemfunccol      = _colintense;
draw_set_halign(1); draw_set_valign(0);
ui_draw_text(_centerx, _obtainitemnamey + _obtainitemnamescale, _obtainitemnamestr, _obtainitemnamescale, 0, c_black, 1.0);
ui_draw_text(_centerx, _obtainitemnamey, _obtainitemnamestr, _obtainitemnamescale, 0, _obtainitemnamecol, 1.0);

ui_draw_text_ext(_centerx, _obtainitemdescy + _obtainitemdescscale, _obtainitemdescstr, -1, _obtainitemstrwid, _obtainitemdescscale, 0, c_black, 1.0);
ui_draw_text_ext(_centerx, _obtainitemdescy, _obtainitemdescstr, -1, _obtainitemstrwid, _obtainitemdescscale, 0, _obtainitemdesccol, 1.0);

ui_draw_text_ext(_centerx, _obtainitemfuncy + _obtainitemfuncscale, _obtainitemfuncstr, -1, _obtainitemstrwid, _obtainitemfuncscale, 0, c_black, 1.0);
ui_draw_text_ext(_centerx, _obtainitemfuncy, _obtainitemfuncstr, -1, _obtainitemstrwid, _obtainitemfuncscale, 0, _obtainitemfunccol, 1.0);

/// Draw ready / continue text
if (itemGetReady)
{
    var _continuestr    = "> ENTER";
    var _continuescale  = 2;
    var _continuecol    = c_yellow;
    var _continuey      = global.winHei - 16;
    draw_set_halign(1); draw_set_valign(2);
    ui_draw_text(_centerx, _continuey + _continuescale, _continuestr, _continuescale, 0, c_black, 1.0);
    ui_draw_text(_centerx, _continuey, _continuestr, _continuescale, 0, _continuecol, 1.0);
}

#define ui_item_assign
var _centerx = global.winCenterX, _centery = global.winCenterY;

/// Draw backdrop
var _backdropalpha = 0.5;
ui_draw_rect(0, 0, global.winWid, global.winHei, c_black, _backdropalpha);

/// Draw item assign screen
// (title)
var _titlestr       = "> ASSIGNING <";
var _titlescale     = 4;
var _titley         = 16;
var _titlehei       = string_height(_titlestr) * _titlescale;
var _titlecol       = make_color_hsv(random_range(0, 255), random_range(0, 100), random_range(220, 255));
var _titlecolintense= make_color_hsv(random_range(0, 255), random_range(100, 200), random_range(220, 255));
draw_set_halign(1); draw_set_valign(0);
ui_draw_text(_centerx, _titley, _titlestr, _titlescale, 0, _titlecol, 1.0);

// (item)
ui_draw_item_info(_centerx * 0.5, _centery * 0.25, itemGetType, _titlecolintense, _titlecol);

/// Draw available keys
var _keyslist       = oGamevars.invSlots;
var _keyslistsz     = ds_list_size(_keyslist);
var _keyswid        = min(_keyslistsz, itemAssignDisplayMaxWid) * (itemAssignDisplayKeysize + itemAssignDisplayKeymargin);
var _keyshei        = (1 + floor(_keyslistsz / itemAssignDisplayMaxWid)) * (itemAssignDisplayKeysize + itemAssignDisplayKeymargin);
var _keysdrawx      = _centerx - _keyswid * 0.5;
var _keysdrawy      = _centery - _keyshei * 0.5;
for (var i=0; i<_keyslistsz; i++)
{
    // Draw key
    var _keydata        = _keyslist[| i];
    var _keyname        = _keydata[@ eINVKEY.DISPLAY_NAME];
    var _keyitem        = _keydata[@ eINVKEY.ITEM];
    var _keyavailable   = _keydata[@ eINVKEY.AVAILABLE];
    var _keywidth = max(itemAssignDisplayKeysize, string_width(_keyname) * 2 + 16);
    
    // TODO : Make a legit key sprite
    var _keycolour = c_white;
    if (oKNT.ingameItemAssignSelected && i == oKNT.ingameItemAssignSelectedIdx)
        _keycolour = c_yellow;
    else if (!_keyavailable || _keyitem != eITEM.NONE)
        _keycolour = c_gray;
    draw_rectangle_color(_keysdrawx - 1, _keysdrawy - 1, _keysdrawx + _keywidth + 1, _keysdrawy + itemAssignDisplayKeysize + 1, c_black, c_black, c_black, c_black, false);
    draw_rectangle_color(_keysdrawx, _keysdrawy, _keysdrawx + _keywidth, _keysdrawy + itemAssignDisplayKeysize, _keycolour, _keycolour, _keycolour, _keycolour, false);
    
    // Draw assigned item if there's any
    if (_keyitem != eITEM.NONE)
    {
        var _itemsprscale = 2;
        // var _itemspr    = oGamevars.itemIcon[@ _keyitem];
        var _itemsprwid = sprite_get_width(sprPickup) * _itemsprscale;
        var _itemsprhei = sprite_get_height(sprPickup) * _itemsprscale;
        var _itemsprx   = _keysdrawx + itemAssignDisplayKeysize * 0.5 - _itemsprwid * 0.5 + sprite_get_xoffset(sprPickup) * _itemsprscale;
        var _itemspry   = _keysdrawy + itemAssignDisplayKeysize * 0.5 - _itemsprhei * 0.5 + sprite_get_yoffset(sprPickup) * _itemsprscale;
        draw_sprite_ext(sprPickup, _keyitem, _itemsprx, _itemspry, _itemsprscale, _itemsprscale, 0, c_white, 1.0);
    }
    
    // Draw 'preview' items
    if (oKNT.ingameItemAssignSelected && i == oKNT.ingameItemAssignSelectedIdx)
    {
        var _itemsprscale = 2;
        // var _itemspr    = oGamevars.itemIcon[@ oKNT.ingameItemAssignItemType];
        var _itemsprwid = sprite_get_width(sprPickup) * _itemsprscale;
        var _itemsprhei = sprite_get_height(sprPickup) * _itemsprscale;
        var _itemsprx   = _keysdrawx + itemAssignDisplayKeysize * 0.5 - _itemsprwid * 0.5 + sprite_get_xoffset(sprPickup) * _itemsprscale;
        var _itemspry   = _keysdrawy + itemAssignDisplayKeysize * 0.5 - _itemsprhei * 0.5 + sprite_get_yoffset(sprPickup) * _itemsprscale;
        var _itemspralpha = cos(fsmStateCtr * (2 / room_speed) * pi) * 0.5 + 0.5;
        draw_sprite_ext(sprPickup, oKNT.ingameItemAssignItemType, _itemsprx, _itemspry, _itemsprscale, _itemsprscale, 0, c_white, _itemspralpha);
    }
    
    // Draw key name
    draw_set_halign(0); draw_set_valign(0);
    ui_draw_text(_keysdrawx + 4, _keysdrawy + 5, _keyname, 2, 0, c_black, 1.0);
    ui_draw_text(_keysdrawx + 4, _keysdrawy + 4, _keyname, 2, 0, c_red, 1.0);
    
    // Update draw positions & Go to next row if maximum key limit per row has been reached
    _keysdrawx += itemAssignDisplayKeysize + itemAssignDisplayKeymargin;
    if ((i + 1) % itemAssignDisplayMaxWid == 0)
    {
        _keysdrawx = _centerx - _keyswid * 0.5;
        _keysdrawy += itemAssignDisplayKeysize + itemAssignDisplayKeymargin;
    }
}

/// Draw selected key slot info
if (oKNT.ingameItemAssignSelected)
{
    var _selectedkeydata    = _keyslist[| oKNT.ingameItemAssignSelectedIdx];
    var _selecteditemttype  = _selectedkeydata[@ eINVKEY.ITEM];
    
    if (_selecteditemttype != eITEM.NONE)
    {
        // Draw item swap confirm
        var _selectedtitlestr   = "CONFIRM?> SELECTED SLOT HAS ITEM : ";
        var _selectedtitley     = global.winHei * 0.7;
        var _selectedtitlescale = 2;
        var _selectedtitlehei   = string_height(_selectedtitlestr) * _selectedtitlescale;
        var _selectedtitlecol   = _titlecol;
        
        var _selecteditemy      = _selectedtitley + _selectedtitlehei + 8;
        var _selecteditemscale  = 4;
        var _selecteditemhei    = sprite_get_height(sprPickup) * _selecteditemscale;
        
        var _selectedbottomstr      = "CONFIRMING WILL SWAP THIS WITH NEW ITEM!#(PRESS THE SAME KEY AGAIN TO CONFIRM)";
        var _selectedbottomy        = _selecteditemy + _selecteditemhei + 8;
        var _selectedbottomscale    = 2;
        var _selectedbottomcol      = c_yellow;
        
        draw_set_halign(1); draw_set_valign(0);
        ui_draw_text(_centerx, _selectedtitley, _selectedtitlestr, _selectedtitlescale, 0, _selectedtitlecol, 1.0);
        ui_draw_text(_centerx, _selectedbottomy, _selectedbottomstr, _selectedbottomscale, 0, _selectedbottomcol, 1.0);
        
        ui_draw_item_info(_centerx * 0.5, _selecteditemy, _selecteditemttype, c_white, c_ltgray);
    }
    else
    {
        // Draw normal confirm
        var _selectedtitlestr   = "> CONFIRM?#(PRESS THE SAME KEY AGAIN)";
        var _selectedtitley     = global.winHei * 0.75;
        var _selectedtitlescale = 4;
        var _selectedtitlehei   = string_height(_selectedtitlestr) * _selectedtitlescale;
        var _selectedtitlecol   = _titlecol;
        draw_set_halign(1); draw_set_valign(1);
        ui_draw_text(_centerx, _selectedtitley + _selectedtitlescale, _selectedtitlestr, _selectedtitlescale, 0, c_black, 1.0);
        ui_draw_text(_centerx, _selectedtitley, _selectedtitlestr, _selectedtitlescale, 0, _selectedtitlecol, 1.0);
    }
}
else
{
    /// Draw description
    var _descstr    = "> Press any available key to assign#> Press again to confirm#> ESCAPE to cancel";
    var _descscale  = 2;
    var _descy      = global.winHei - 16;
    var _desccol    = c_yellow;
    draw_set_halign(1); draw_set_valign(2);
    ui_draw_text(_centerx, _descy + _descscale, _descstr, _descscale, 0, c_black, 1.0);
    ui_draw_text(_centerx, _descy, _descstr, _descscale, 0, _desccol, 1.0);
}

#define ui_powercell_deposit
var _centerx = global.winCenterX, _centery = global.winCenterY;
var _titlecol = make_color_hsv(random_range(0, 255), random_range(0, 100), random_range(220, 255));

/// Draw backdrop
var _backdropalpha = 0.5;
ui_draw_rect(0, 0, global.winWid, global.winHei, c_black, _backdropalpha);

/// Draw progress
var _progressstr    = "POWER : " + string(oGamevars.progress) + " / " + string(oGamevars.progressMax) + "#(HP FULLY RESTORED!)";
var _progressy      = _centery * 0.5;
var _progressscale  = titleLogoScale;
draw_set_halign(1); draw_set_valign(1);
ui_draw_text(_centerx, _progressy + 1, _progressstr, _progressscale, 0, c_black, 1.0);
ui_draw_text(_centerx, _progressy, _progressstr, _progressscale, 0, _titlecol, 1.0);

/// Draw available keys
var _keyslist       = oGamevars.invSlots;
var _keyslistsz     = ds_list_size(_keyslist);
var _keyswid        = min(_keyslistsz, itemAssignDisplayMaxWid) * (itemAssignDisplayKeysize + itemAssignDisplayKeymargin);
var _keyshei        = (1 + floor(_keyslistsz / itemAssignDisplayMaxWid)) * (itemAssignDisplayKeysize + itemAssignDisplayKeymargin);
var _keysdrawx      = _centerx - _keyswid * 0.5;
var _keysdrawy      = _centery - _keyshei * 0.5;
for (var i=0; i<_keyslistsz; i++)
{
    // Draw key
    var _keydata        = _keyslist[| i];
    var _keyname        = _keydata[@ eINVKEY.DISPLAY_NAME];
    var _keyitem        = _keydata[@ eINVKEY.ITEM];
    var _keyavailable   = _keydata[@ eINVKEY.AVAILABLE];
    var _keywidth = max(itemAssignDisplayKeysize, string_width(_keyname) * 2 + 16);
    
    // TODO : Make a legit key sprite
    var _keycolour = c_white;
    if (_keyitem == eITEM.ITEM_POWERCELL)
        _keycolour = merge_color(c_yellow, c_yellow, cos(fsmStateCtr * (2 / room_speed) * pi) * 0.5 + 0.5);
    draw_rectangle_color(_keysdrawx - 1, _keysdrawy - 1, _keysdrawx + _keywidth + 1, _keysdrawy + itemAssignDisplayKeysize + 1, c_black, c_black, c_black, c_black, false);
    draw_rectangle_color(_keysdrawx, _keysdrawy, _keysdrawx + _keywidth, _keysdrawy + itemAssignDisplayKeysize, _keycolour, _keycolour, _keycolour, _keycolour, false);
    
    // Draw assigned item if there's any
    if (_keyitem != eITEM.NONE)
    {
        var _itemsprscale = 2;
        // var _itemspr    = oGamevars.itemIcon[@ _keyitem];
        var _itemsprwid = sprite_get_width(sprPickup) * _itemsprscale;
        var _itemsprhei = sprite_get_height(sprPickup) * _itemsprscale;
        var _itemsprx   = _keysdrawx + itemAssignDisplayKeysize * 0.5 - _itemsprwid * 0.5 + sprite_get_xoffset(sprPickup) * _itemsprscale;
        var _itemspry   = _keysdrawy + itemAssignDisplayKeysize * 0.5 - _itemsprhei * 0.5 + sprite_get_yoffset(sprPickup) * _itemsprscale;
        draw_sprite_ext(sprPickup, _keyitem, _itemsprx, _itemspry, _itemsprscale, _itemsprscale, 0, c_white, 1.0);
    }
    
    // Draw key name
    draw_set_halign(0); draw_set_valign(0);
    ui_draw_text(_keysdrawx + 4, _keysdrawy + 5, _keyname, 2, 0, c_black, 1.0);
    ui_draw_text(_keysdrawx + 4, _keysdrawy + 4, _keyname, 2, 0, c_red, 1.0);
    
    // Update draw positions & Go to next row if maximum key limit per row has been reached
    _keysdrawx += _keywidth + itemAssignDisplayKeymargin;
    if ((i + 1) % itemAssignDisplayMaxWid == 0)
    {
        _keysdrawx = _centerx - _keyswid * 0.5;
        _keysdrawy += _keywidth + itemAssignDisplayKeymargin;
    }
}

/// Draw description
var _descstr    = "> Press any slots w/ POWER CANISTER to deposit#> POWER CANISTERS are highlighted with yellow background#> ESCAPE to leave";
var _descscale  = 2;
var _descy      = global.winHei - 16;
var _desccol    = c_yellow;
draw_set_halign(1); draw_set_valign(2);
ui_draw_text(_centerx, _descy + _descscale, _descstr, _descscale, 0, c_black, 1.0);
ui_draw_text(_centerx, _descy, _descstr, _descscale, 0, _desccol, 1.0);

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
var _titlecol       = make_color_hsv(random_range(0, 255), random_range(0, 100), random_range(220, 255));
draw_set_halign(1); draw_set_valign(0);
ui_draw_text(_centerx, _titley, _titlestr, _titlescale, 0, _titlecol, 1.0);

// (list of teleports)
var _tplist     = oGamevars.teleportList;
var _tplistsz   = ds_list_size(_tplist);
// var _tplistwid  = global.winWid * 0.5;

var _tpliststrscale     = 2;
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
var _descscale  = 2;
var _descy      = global.winHei - 16;
var _desccol    = c_yellow;
draw_set_halign(1); draw_set_valign(2);
ui_draw_text(_centerx, _descy + _descscale, _descstr, _descscale, 0, c_black, 1.0);
ui_draw_text(_centerx, _descy, _descstr, _descscale, 0, _desccol, 1.0);