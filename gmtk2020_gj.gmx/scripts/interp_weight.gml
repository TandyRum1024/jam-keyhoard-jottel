/// interp_weight(_val, _maxval, _weightbegin, _weightend)
/*
    Calculates interpolation factor
    Used for lerp-based animations
*/
var _val = argument0, _maxval = argument1, _weightbegin = argument2, _weightend = argument3;
return power(1.0 - power(1.0 - clamp(_val / _maxval, 0, 1), _weightend), _weightbegin);
