#define ui_draw_rect_text
/// ui_draw_rect_text(_x, _y, _w, _h, _rectcolour, _rectalpha, _str, _strscale, _strmarginh, _strmarginv, _halign, _valign, _strcolour, _stralpha)
var _x = argument0, _y = argument1, _w = argument2, _h = argument3, _rectcolour = argument4, _rectalpha = argument5, _str = argument6, _strscale = argument7, _strmarginh = argument8, _strmarginv = argument9, _halign = argument10, _valign = argument11, _strcolour = argument12, _stralpha = argument13;

// Calculate position to draw text from align
var _textx = _x + _w * (_halign * 0.5), _texty = _y + _h * (_valign * 0.5);
draw_set_halign(_halign); draw_set_valign(_valign);
ui_draw_rect(_x - _strmarginh, _y - _strmarginv, _w + _strmarginh * 2, _h + _strmarginv * 2, _rectcolour, _rectalpha);
ui_draw_text(_textx, _texty, _str, _strscale, 0, _strcolour, _stralpha);

#define ui_draw_rect_text_bbs_format
/// ui_draw_rect_text_bbs_format(_x, _y, _rectcolour1, _rectcolour2, _rectalpha, _decosize, _format, _formatargs, _strscale, _halign, _valign, _strcolour, _stralpha)
/*
    Draws ANSI GUI-like decorated box with text in it
*/
var _x = argument0, _y = argument1, _rectcolour1 = argument2, _rectcolour2 = argument3, _rectalpha = argument4, _decosize = argument5, _format = argument6, _formatargs = argument7, _strscale = argument8, _halign = argument9, _valign = argument10, _strcolour = argument11, _stralpha = argument12;

var _decosize2 = _decosize * 2;
var _boxw = ui_draw_text_format_get_width(_format, _formatargs) * _strscale + _decosize * 6;
var _boxh = ui_draw_text_format_get_height(_format, _formatargs) * _strscale + _decosize * 6;
var _boxx = _x - _boxw * _halign * 0.5;
var _boxy = _y - _boxh * _valign * 0.5;
// (rect w/ decoration)
ui_draw_rect(_boxx + _decosize * 3, _boxy + _decosize * 3, _boxw, _boxh, c_black, _rectalpha); // shadow
ui_draw_rect(_boxx, _boxy, _boxw, _boxh, _rectcolour1, _rectalpha); // 1st outline
ui_draw_rect(_boxx + _decosize, _boxy + _decosize, _boxw - _decosize2, _boxh - _decosize2, _rectcolour2, _rectalpha); // 2nd outline
ui_draw_rect(_boxx + _decosize2, _boxy + _decosize2, _boxw - _decosize2 * 2, _boxh - _decosize2 * 2, _rectcolour1, _rectalpha); // 3rd inner rect

// (text)
var _textx = _boxx + (_boxw * 0.5), _texty = _boxy + (_boxh * 0.5);
ui_draw_text_format(_textx, _texty, _format, _strscale, _strcolour, _stralpha, 1, 1, _formatargs);