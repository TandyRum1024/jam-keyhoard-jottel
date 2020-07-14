/// debug_log(a, b, c, d..)
var _str = "";
for (var i=0; i<argument_count; i++)
{
    _str += string(argument[i]);
}

show_debug_message(_str);
return _str;
