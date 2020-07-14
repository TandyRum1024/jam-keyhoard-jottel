#define fx_emit_dust
/// fx_emit_dust(_x, _y, _vx, _vy, _damp, _life)
var _x = argument0, _y = argument1, _vx = argument2, _vy = argument3, _damp = argument4, _life = argument5;
var _fx = instance_create(_x, _y, oFXDust);
_fx.vx = _vx;
_fx.vy = _vy;
_fx.velDamp = _damp;
_fx.life = _life;
return _fx;

#define fx_emit_pomf
/// fx_emit_pomf(_x, _y)
var _x = argument0, _y = argument1;
var _fx = instance_create(_x, _y, oFXPomf);
_fx.image_xscale = 0.25;
_fx.image_yscale = 0.25;
return _fx;

#define fx_emit_spark
/// fx_emit_spark(_x, _y, _angle)
var _x = argument0, _y = argument1, _angle = argument2;
var _fx = instance_create(_x, _y, oFXSpark);
_fx.image_angle = _angle;
return _fx;