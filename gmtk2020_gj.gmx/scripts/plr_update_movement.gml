/// Update sprint movement
if (upgradeSprint)
{
    var _sprinthld = inputSprint[@ eINPUT.HLD];
    if (_sprinthld)
    {
        moveVelAcc = moveVelAccSprint;
        moveVelMax = moveVelMaxSprint;
        
        isSprinting = true;
    }
    else
    {
        moveVelAcc = moveVelAccDefault;
        moveVelMax = moveVelMaxDefault;
        
        isSprinting = false;
        
        // Clip velocity
        vx = clamp(vx, -moveVelMax, moveVelMax);
    }
}
else
{
    isSprinting = false;
}

/// Update basic movement
if (upgradeMove)
{
    var _inputh      = inputH[@ eINPUT.HLD];
    var _inputhpress = inputH[@ eINPUT.PRS];
    
    // Apply initial boost
    if (_inputhpress != 0)
    {
        var _accel = clamp(moveVelMax - vx * _inputh, 0, moveVelInit);
        vx += _accel * _inputhpress;
    }
    
    // Apply movement
    if (_inputh != 0)
    {
        var _accel = clamp(moveVelMax - vx * _inputh, 0, moveVelAcc);
        vx += _accel * _inputh;
        isMoving = true;
    }
    else
    {
        isMoving = false;
    }
    
    // Fall down faster by holding down
    /*
    if (!contactB && inputV[@ eINPUT.HLD] == 1)
    {
        isFastfalling = true;
        // velGravAcc = velGravAccFastfall;
    }
    else
    {
        isFastfalling = false;
    }
    */
}
else
{
    // isFastfalling = false;
    // Update very simple & inferior movement : crawling
    var _inputh      = inputH[@ eINPUT.HLD];
    if (_inputh != 0)
    {
        var _accel = clamp(moveVelMaxCrawl - vx * _inputh, 0, moveVelAccCrawl);
        vx += _accel * _inputh;
        isMoving = true;
    }
    else
    {
        isMoving = false;
    }
}

/// Update kick movement
if (upgradeKick)
{
    if (!contactB && fsmState != "kick_knockback" && inputJump[@ eINPUT.PRS])
    {
        var _inputh = inputH[@ eINPUT.HLD];
        var _inputv = inputV[@ eINPUT.HLD];
        if (_inputv = 1) // Down kick
        {
            // Switch to divekick state
            fsm_set("kick_down");
            
            // Fire kick animation
            anim_fire("kick_down");
        }
        else // Left / right kick
        {
            // Calculate kick direction
            if (_inputh != 0)
            {
                // Kick with 'desired' direction
                kickDashDirX = _inputh;
                kickDashDirY = 0;
            }
            else
            {
                // Calculate direction from player's facing direction
                kickDashDirX = moveFacing;
                kickDashDirY = 0;
            }
            
            // Calculate kick velocity
            if (isSprinting)
                kickDashVel = kickDashVelSprint;
            else
                kickDashVel = kickDashVelDefault;
            
            // Instantly face the kicking direction
            if (sign(kickDashDirX) != 0)
                moveFacing = sign(kickDashDirX);
            
            // Switch to kick state
            fsm_set("kick_dash");
            
            // Fire kick animation
            anim_fire("kick_dash");
        }
        
        return 0;
    }
}

/// Update jump movement
if (upgradeJump)
{
    var _jumprel    = inputJump[@ eINPUT.REL];
    var _jumphld    = inputJump[@ eINPUT.HLD];
    if (_jumphld)
    {
        if (!isJumping && jumpFrames > 0)
        {
            // Initial jump
            isJumping = true;
            vy -= jumpVelInit;
            
            // Fire anim
            anim_fire("jump");
        }
        else if (jumpFrames > 0)
        {
            jumpFrames--;
            vy -= lerp(jumpVelAccMin, jumpVelAccMax, jumpFrames / (jumpFramesMax - 1));
        }
    }
    else
    {
        if (contactB)
        {
            // Recharge jump
            jumpFrames = jumpFramesMax;
        }
        else
        {
            // Stop jump
            jumpFrames = 0;
        }
        
        isJumping = false;
    }
}

/// Update attack movement
if (upgradeWeapon)
{
    var _shoothld = inputShoot[@ eINPUT.HLD];
    var _shootrel = inputShoot[@ eINPUT.REL];
    
    if (shootCooldownFrames > 0)
    {
        shootCooldownFrames--;
    }
    
    if (_shoothld)
    {
        if (shootCooldownFrames <= 0)
        {
            shootChargeCtr++;
            isCharging = true;
            
            // Play sound
            var _interp = clamp(shootChargeCtr / shootChargeMax, 0.0, 1.0);
            if (!audio_is_playing(shootChargeSnd))
            {
                shootChargeSnd = audio_play_sound(sndWeaponCharge, 0, true);
            }
            else
            {
                audio_sound_pitch(shootChargeSnd, lerp(1.0, 2.0, _interp));
                audio_sound_gain(shootChargeSnd, lerp(0.25, 0.5, _interp), 0);
            }
        }
    }
    else if (_shootrel & isCharging)
    {
        shootCooldownFrames = shootCooldownFramesMax;
        
        // Stop sound & play shoot sound
        if (audio_is_playing(shootChargeSnd))
        {
            audio_stop_sound(shootChargeSnd);
        }
        sfx_play(sndWeaponShoot, 1.0, random_range(1.7, 2.3));
        
        // TODO : Emit weapon attack
        var _inputh = inputH[@ eINPUT.HLD];
        var _inputv = inputV[@ eINPUT.HLD];
        var _interp = clamp(shootChargeCtr / shootChargeMax, 0, 1);
        
        var _projectile = instance_create(x, y, oPlayerAttack);
        if (_inputv != 0)
        {
            _projectile.vx = 0;
            _projectile.vy = _inputv;
            _projectile.image_angle = _inputv * -90;
        }
        else if (_inputh != 0)
        {
            _projectile.vx = _inputh;
            _projectile.vy = 0;
            _projectile.image_angle = 90 - _inputh * 90;
        }
        else
        {
            _projectile.vx = moveFacing;
            _projectile.vy = 0;
            _projectile.image_angle = 90 - moveFacing * 90;
        }
        
        // Set thickness & damage
        _projectile.image_yscale = lerp(shootThickMin, shootThickMax, _interp);
        _projectile.damage       = floor(lerp(shootDamageMin, shootDamageMax, _interp));
        
        // Reset gun flags
        shootChargeCtr = 0;
        isCharging = false;
    }
}
else
{
    isCharging = false;
}

// Calculate final gravity acceleration
if (isFastfalling)
{
    velGravAcc = velGravAccFastfall;
}
else if (isJumping)
{
    velGravAcc = velGravAccJump;
}
else
{
    velGravAcc = velGravAccDefault;
}
