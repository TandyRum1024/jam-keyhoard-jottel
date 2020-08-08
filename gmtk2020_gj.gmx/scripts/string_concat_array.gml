/// string_concat_array(_array, _separator)
var _array = argument0, _separator = argument1;
var _str = "";
for (var i=0; i<array_length_1d(_array); i++)
{
    _str += string(_array[@ i]) + _separator;
}
return _str;
