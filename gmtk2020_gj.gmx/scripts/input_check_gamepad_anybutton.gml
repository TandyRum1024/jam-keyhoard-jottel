#define input_check_gamepad_anybutton
/// input_check_gamepad_anybutton(_padindex)
// Returns if there was any key held on the gamepad with given index
var _padindex = argument0;
for (var _btn = 32769; _btn < 32789; _btn++)
{
    if (gamepad_button_check(_padindex, _btn))
    {
        return _btn;
    }
}

return -1;

#define input_check_gamepad_anybutton_pressed
/// input_check_gamepad_anybutton_pressed(_padindex)
// Returns if there was any key pressed on the gamepad with given index
var _padindex = argument0;
for (var _btn = 32769; _btn < 32789; _btn++)
{
    if (gamepad_button_check_pressed(_padindex, _btn))
    {
        return _btn;
    }
}

return -1;