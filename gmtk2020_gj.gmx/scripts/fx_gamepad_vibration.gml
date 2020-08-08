#define fx_gamepad_vibration
/// fx_gamepad_vibration(_amt)
var _amt = argument0;
oInput.inputVibration = clamp(oInput.inputVibration + _amt, 0.0, 1.0);

#define fx_gamepad_vibration_set
/// fx_gamepad_vibration_set(_amt)
var _amt = argument0;
oInput.inputVibration = clamp(_amt, 0.0, 1.0);