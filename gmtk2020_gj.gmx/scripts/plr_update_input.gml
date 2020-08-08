// Update horizontal / vertical input
/*
inputH = makearray(
    keyboard_check(inputBindR) - keyboard_check(inputBindL),
    keyboard_check_pressed(inputBindR) - keyboard_check_pressed(inputBindL),
    keyboard_check_released(inputBindR) - keyboard_check_released(inputBindL)
    );
    
inputV = makearray(
    keyboard_check(inputBindD) - keyboard_check(inputBindU),
    keyboard_check_pressed(inputBindD) - keyboard_check_pressed(inputBindU),
    keyboard_check_released(inputBindD) - keyboard_check_released(inputBindD)
    );
*/
array_copy(inputH, 0, oInput.inputH, 0, 3);
array_copy(inputV, 0, oInput.inputV, 0, 3);

// Update jump input
array_copy(inputJump, 0, inputListenJump, 0, 3);
/*
makearray(
    keyboard_check(inputBindJump),
    keyboard_check_pressed(inputBindJump),
    keyboard_check_released(inputBindJump),
    );
*/

// Update sprint input
array_copy(inputSprint, 0, inputListenSprint, 0, 3);
/*
makearray(
    keyboard_check(inputBindSprint),
    keyboard_check_pressed(inputBindSprint),
    keyboard_check_released(inputBindSprint),
    );
*/

// Update shoot input
array_copy(inputShoot, 0, inputListenShoot, 0, 3);
/*
makearray(
    keyboard_check(inputBindShoot),
    keyboard_check_pressed(inputBindShoot),
    keyboard_check_released(inputBindShoot),
    );
*/
