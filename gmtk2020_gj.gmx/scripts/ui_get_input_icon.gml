/// ui_get_input_icon(_inputid)
var _inputid = argument0;
var _spr = -1;
var _inputiconsprset = UIInputIconSprTable[? UIInputLayoutCurrentSpriteset];
if (_inputiconsprset != undefined)
{
    var _inputicon = _inputiconsprset[? _inputid];
    if (_inputicon != undefined)
    {
        _spr = _inputicon;
    }
}

return _spr;
