/// ui_draw_keyslots(_x, _y, _highlightslot, _itemflicker, _highlightitemtype, _col, _alpha, _halign = 0, _valign = 0)
var _x = argument[0], _y = argument[1], _highlightslot = argument[2], _itemflicker = argument[3], _highlightitemtype = argument[4], _col = argument[5], _alpha = argument[6];
var _halign; if (argument_count > 7) _halign = argument[7]; else _halign = 0;
var _valign; if (argument_count > 8) _valign = argument[8]; else _valign = 0;
var _height = 0;
var _layoutdata = oUI.UIInputLayoutCurrentData;
if (_layoutdata != undefined)
{
    // Get layout data
    var _layoutitemsize     = UIInputLayoutItemScale * global.gameUIZoom;
    var _layouttextsize     = UIInputLayoutTextScale * global.gameUIZoom;
    var _layoutgriditemsize = UIInputLayoutItemSize * _layoutitemsize;
    var _layoutconfig    = _layoutdata[@ eKEYLAYOUT.CONFIG];
    var _layoutspriteset = UIInputSprSets[? _layoutconfig[@ eKEYLAYOUT_CONFIG.SPRITESET]];
    var _layoutwid       = _layoutconfig[@ eKEYLAYOUT_CONFIG.GRIDW] * _layoutgriditemsize + UIInputLayoutItemMarginH * _layoutitemsize;
    var _layouthei       = _layoutconfig[@ eKEYLAYOUT_CONFIG.GRIDH] * _layoutgriditemsize + UIInputLayoutItemMarginV * _layoutitemsize;
    
    var _layoutgridstepx = _layoutgriditemsize + UIInputLayoutItemMarginH * global.gameUIZoom;
    var _layoutgridstepy = _layoutgriditemsize + UIInputLayoutItemMarginV * global.gameUIZoom;
    
    // Display keyslots according to layout
    var _drawx = _x - _layoutwid * _halign * 0.5;
    var _drawy = _y - _layouthei * _valign * 0.5;
    var _itemsprhalfwid = sprite_get_width(sprPickup) * _layoutitemsize * 0.5;
    var _itemsprhalfhei = sprite_get_height(sprPickup) * _layoutitemsize * 0.5;
    
    var _itemflickeralpha = _alpha * (sin(current_time * 0.004 * pi) * 0.5 + 0.5);
    var _itemflickerslot = _itemflicker[@ 0];
    var _itemflickertype = _itemflicker[@ 1];
    
    draw_set_halign(1); draw_set_valign(2);
    var _layoutinputs = _layoutdata[@ eKEYLAYOUT.INPUTS];
    for (var i=0; i<array_length_1d(_layoutinputs); i++)
    {
        var _inputdata = _layoutinputs[@ i];
        var _inputstr = _inputdata[@ eKEYLAYOUT_KEY.DISPLAY_STR];
        var _inputid = _inputdata[@ eKEYLAYOUT_KEY.INPUT_ID];
        var _inputgx = _inputdata[@ eKEYLAYOUT_KEY.GRIDX];
        var _inputgy = _inputdata[@ eKEYLAYOUT_KEY.GRIDY];
        var _inputox = _inputdata[@ eKEYLAYOUT_KEY.OFFX];
        var _inputoy = _inputdata[@ eKEYLAYOUT_KEY.OFFY];
        var _inputspr    = _layoutspriteset[@ _inputdata[@ eKEYLAYOUT_KEY.SPRIDX]];
        var _inputspridx = 0;
        var _inputsprwid = sprite_get_width(_inputspr) * _layoutitemsize;
        var _inputsprhei = sprite_get_height(_inputspr) * _layoutitemsize;
        
        // Determine sprite index from keyslot data
        var _inputkeyslotdata = inv_key_get(_inputid);
        var _inputkeyslotitem = _inputkeyslotdata[@ eINVKEY.ITEM];
        if (_inputid == _highlightslot || _inputid == _itemflickerslot || _inputkeyslotitem == _highlightitemtype)
            _inputspridx = 1;
        else if (!_inputkeyslotdata[@ eINVKEY.AVAILABLE])
            _inputspridx = 3;
        else if (_inputkeyslotitem != eITEM.NONE)
            _inputspridx = 2;
        
        // Draw keyslot
        var _sprx = _drawx + _inputgx * _layoutgridstepx + _inputox * _layoutitemsize;
        var _spry = _drawy + _inputgy * _layoutgridstepy + _inputoy * _layoutitemsize;
        var _sprcenterx = _sprx + (_inputsprwid >> 1);
        var _sprcentery = _spry + (_inputsprhei >> 1);
        draw_sprite_ext(_inputspr, _inputspridx, _sprx, _spry, _layoutitemsize, _layoutitemsize, 0, _col, _alpha);
        ui_draw_text(_sprcenterx, _spry, _inputstr, _layouttextsize, 0, _col, _alpha);
        
        // Draw items
        var _itemalpha = _alpha;
        if (_inputid == _itemflickerslot)
            _inputkeyslotitem = _itemflickertype;
        if (_inputkeyslotitem != eITEM.NONE)
        {
            if (_inputid == _itemflickerslot)
                _itemalpha = _itemflickeralpha;
            
            draw_sprite_ext(sprPickup, _inputkeyslotitem, _sprcenterx - _itemsprhalfwid, _sprcentery - _itemsprhalfhei, _layoutitemsize, _layoutitemsize, 0, _col, _itemalpha);
        }
    }
}

return _height;
