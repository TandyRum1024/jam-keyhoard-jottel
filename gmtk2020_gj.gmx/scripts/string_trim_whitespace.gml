/// string_trim_whitespace(_str)
var _str = argument0;

if (_str == " " || _str == "")
    return "";

var _strlen = string_length(_str); 
var _beginpos = 1, _endpos = _strlen;
while (_beginpos < _endpos)
{
    var _beginch = string_char_at(_str, _beginpos);
    var _endch   = string_char_at(_str, _endpos);
    if (_beginch != ' ' && _endch != ' ')
    {
        break;
    }
    else
    {
        if (_beginch == ' ')
            _beginpos++;
        if (_endch == ' ')
            _endpos--;
    }
}

var _result = string_copy(_str, _beginpos, _endpos - _beginpos + 1);
return _result;
