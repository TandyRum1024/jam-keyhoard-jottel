/// ui_draw_item_info(_basex, _basey, _itemtype, _titlecol, _desccol)
var _basex = argument0, _basey = argument1, _itemtype = argument2, _titlecol = argument3, _desccol = argument4;
// (item)
var _iteminfo       = oGamevars.itemStr[@ _itemtype];
var _itemstrx       = _basex + 16;
var _itembasey      = _basey;

// var _itemiconspr    = oGamevars.itemIcon[@ _itemtype];
var _itemiconscale  = 4;
var _itemiconwid    = sprite_get_width(sprPickup) * _itemiconscale;
var _itemiconhei    = sprite_get_height(sprPickup) * _itemiconscale;
var _itemiconx      = _basex - 16 - _itemiconwid + sprite_get_xoffset(sprPickup) * _itemiconscale;
var _itemicony      = _itembasey + sprite_get_yoffset(sprPickup) * _itemiconscale;

var _itemtitlestr   = string(_iteminfo[@ 0]);
var _itemtitlescale = 2;
var _itemtitlehei   = string_height(_itemtitlestr) * _itemtitlescale;
var _itemstrtitley  = _itembasey;

var _itemdescstr    = string(_iteminfo[@ 2]);
var _itemdescscale  = 2;
var _itemstrdescy   = _itembasey + _itemtitlehei + 8;

var _strwid = global.winWid - (_basex + 32);

// (draw item text)
draw_set_halign(0); draw_set_valign(0);
ui_draw_text(_itemstrx, _itemstrtitley + _itemtitlescale, _itemtitlestr, _itemtitlescale, 0, c_black, 1.0); // item name
ui_draw_text(_itemstrx, _itemstrtitley, _itemtitlestr, _itemtitlescale, 0, _titlecol, 1.0);

ui_draw_text_ext(_itemstrx, _itemstrdescy + _itemdescscale, _itemdescstr, -1, _strwid, _itemdescscale, 0, c_black, 1.0); // desc
ui_draw_text_ext(_itemstrx, _itemstrdescy, _itemdescstr, -1, _strwid, _itemdescscale, 0, _desccol, 1.0);

// (draw item icon)
draw_sprite_ext(sprPickup, _itemtype, _itemiconx, _itemicony, _itemiconscale, _itemiconscale, 0, c_white, 1.0);
