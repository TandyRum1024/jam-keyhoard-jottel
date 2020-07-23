/// ui_draw_footer(_wid, _y, _strleft, _strright, _strtop, _colour, _alpha)
var _wid = argument0, _y = argument1, _strleft = argument2, _strright = argument3, _strtop = argument4, _colour = argument5, _alpha = argument6;
var _footerscale     = 3 * global.gameUIZoom;
var _footerdescscale = 2 * global.gameUIZoom;
var _footerx1    = (global.winWid - _wid) * 0.5;
var _footerx2    = _footerx1 + _wid;
var _footery     = _y;
var _footeritemy = _footery + _footerscale * 2;
var _footerdescy = _footery - _footerscale * 2;

// (top menu description string)
// ui_draw_text_format(_contentsbeginx + 8, _footerdescy, _footerstr3, _footerdescscale, _titlecol, _menualpha, 0, 2, -1);
draw_set_halign(0); draw_set_valign(2);
ui_draw_text_ext(_footerx1 + 8, _footerdescy, _strtop, -1, _wid, _footerdescscale, 0, _colour, _alpha);

// (horizontal ruler)
ui_draw_rect(_footerx1, _footery, _wid, _footerscale, _colour, _alpha);

// (bottom navigation help string)
ui_draw_text_format(_footerx1 + 8, _footeritemy, _strleft, _footerscale, _colour, _alpha, 0, 0, -1);
ui_draw_text_format(_footerx2 - 8, _footeritemy, _strright, _footerscale, _colour, _alpha, 2, 0, -1);
// draw_set_halign(0); draw_set_valign(0);
// ui_draw_text(_contentsbeginx + 8, _footeritemy, _footerstr1, _footerscale, 0, _titlecol, _menualpha);
// draw_set_halign(2);
// ui_draw_text(_contentsendx - 8, _footeritemy, _footerstr2, _footerscale, 0, _titlecol, _menualpha);

// Bottom deco footer
var _decostr    = "40XX+i (c) BJÖRT ELECTRONICS Ltd.";
var _decoscale  = 2 * global.gameUIZoom;
var _decohei    = string_height(_decostr) * _decoscale + 16;
var _decoy      = global.winHei - _decohei;
draw_set_halign(0); draw_set_valign(1);
ui_draw_text(4, _decoy + _decohei * 0.5, _decostr, _decoscale, 0, _colour, 0.5);
