/// @function debug_log(a, b, c, d..)
/// @param ... values to concat. into one string
var _str = "";
for (var i=0; i<argument_count; i++)
{
    var _ent = argument[i];
    if (is_array(_ent))
        _str += _ent;
    else
        _str += string(_ent);
}

show_debug_message(_str);
return _str;
