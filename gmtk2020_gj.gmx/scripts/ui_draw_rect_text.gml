/// ui_draw_rect_text(_x, _y, _w, _h, _rectcolour, _rectalpha, _str, _strscale, _strmarginh, _strmarginv, _halign, _valign, _strcolour, _stralpha)
var _x = argument0, _y = argument1, _w = argument2, _h = argument3, _rectcolour = argument4, _rectalpha = argument5, _str = argument6, _strscale = argument7, _strmarginh = argument8, _strmarginv = argument9, _halign = argument10, _valign = argument11, _strcolour = argument12, _stralpha = argument13;

// Calculate position to draw text from align
var _textx = _x + _w * (_halign * 0.5), _texty = _y + _h * (_valign * 0.5);
draw_set_halign(_halign); draw_set_valign(_valign);
ui_draw_rect(_x - _strmarginh, _y - _strmarginv, _w + _strmarginh * 2, _h + _strmarginv * 2, _rectcolour, _rectalpha);
ui_draw_text(_textx, _texty, _str, _strscale, 0, _strcolour, _stralpha);
