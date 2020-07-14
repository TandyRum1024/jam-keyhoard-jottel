// Update horizontal / vertical input
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
    
// Update jump input
inputJump = makearray(
    keyboard_check(inputBindJump),
    keyboard_check_pressed(inputBindJump),
    keyboard_check_released(inputBindJump),
    );

// Update sprint input
inputSprint = makearray(
    keyboard_check(inputBindSprint),
    keyboard_check_pressed(inputBindSprint),
    keyboard_check_released(inputBindSprint),
    );

// Update shoot input
inputShoot = makearray(
    keyboard_check(inputBindShoot),
    keyboard_check_pressed(inputBindShoot),
    keyboard_check_released(inputBindShoot),
    );
