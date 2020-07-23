/// input_check_gamepad_anybutton(_padindex)
// Returns if there was any key pressed on the gamepad with given index
var _padindex = argument0;
for (var _btn = 32769; _btn < 32789; _btn++)
{
    if (gamepad_button_check_pressed(_padindex, _btn))
    {
        return true;
    }
}

return false;
