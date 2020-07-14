#define ui_draw_text
/// ui_draw_text(_x, _y, _str, _scale, _angle, _col, _alpha)
var _x = argument0, _y = argument1, _str = argument2, _scale = argument3, _angle = argument4, _col = argument5, _alpha = argument6;
draw_text_transformed_color(_x, _y, _str, _scale, _scale, _angle, _col, _col, _col, _col, _alpha);

#define ui_draw_text_ext
/// ui_draw_text_ext(_x, _y, _str, _sep, _wid, _scale, _angle, _col, _alpha)
var _x = argument0, _y = argument1, _str = argument2, _sep = argument3, _wid = argument4, _scale = argument5, _angle = argument6, _col = argument7, _alpha = argument8;
draw_text_ext_transformed_color(_x, _y, _str, _sep, _wid / _scale, _scale, _scale, _angle, _col, _col, _col, _col, _alpha);