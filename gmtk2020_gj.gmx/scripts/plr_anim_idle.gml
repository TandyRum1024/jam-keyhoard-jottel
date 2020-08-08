#define plr_anim_idle
if (!fsmStateInit)
{
    // Reset the animation
    event_user(0);
    owner.image_index = 0;
    owner.image_speed = 0;
}

// Update player sprite animation
with (owner)
{
    var _inputv = inputV[@ eINPUT.HLD];
    if (upgradeMove)
    {
        // Set sprite
        if (isCharging)
        {
            sprite_index = sprPlayerIdleCharge;
            if (_inputv < -0.5)
                image_index = 1;
            else
                image_index = 0;
        }
        else
        {
            sprite_index = sprPlayerIdle;
            image_index = 0;
        }
    }
    else
    {
        if (isCharging)
        {
            if (_inputv < -0.5)
                sprite_index = sprPlayerMoveCrawlChargeUp;
            else
                sprite_index = sprPlayerMoveCrawlCharge;
        }
        else
        {
            sprite_index = sprPlayerMoveCrawl;
        }
        image_index  = 0;
    }
}

// Update player facing
if (sign(owner.vx) != 0)
    owner.moveFacing = sign(owner.vx);

/// Check for state switches
if (!owner.contactB) // Fall
{
    fsm_set("midair");
}
else if (abs(owner.vx) >= oGamevars.animPlrMoveVelMin) // Move
{
    if (owner.upgradeMove)
        fsm_set("move");
    else
        fsm_set("move_crawl");
}

#define plr_anim_spawn_fall
if (!fsmStateInit)
{
    // Reset the animation
    event_user(0);
    
    // Set sprite
    owner.sprite_index = sprPlayerHurt;
    
    // Animate sprite animation
    owner.image_index = 1;
    owner.image_speed = 0;
    
    // Flip sprite y to make the player 'fall on head'
    image_angle = 270;
}

/// Animate movements
// Tilt sprite according to velocity
image_angle -= angle_difference(image_angle, point_direction(0, 0, owner.vx, owner.vy)) * 0.1;

// Set shake
animFXShake = 4;

if (owner.colB)
{
    // Play sound
    sfx_play(sndFleshImpact, 0.75, random_range(0.9, 1.1));
    sfx_play(sndHeavyImpact, 0.5, random_range(0.9, 1.1));
    
    // Emit some dust & particles
    with (owner)
    {
        var _particle = fx_emit_pomf(random_range(bbox_left, bbox_right), bbox_bottom);
        _particle.vx = sign(_particle.x - x);
        _particle.vy = random_range(-0.5, 2);
        
        var _movedir = sign(vx);
        // debug_log("VX : ", vx, " | MOVEDIR : ", _movedir);
        repeat (irandom_range(4, 8))
        {
            if (_movedir != 0)
                fx_emit_dust(lerp(bbox_left, bbox_right, _movedir * 0.5 + 0.5), bbox_bottom - vy, _movedir * random_range(-3, -1), random_range(-1, -0.25), 0.95, room_speed);
            else
                fx_emit_dust(lerp(bbox_left, bbox_right, random_range(-0.1, 0.1) + 0.5), bbox_bottom - vy, random_range(-1, 1), random_range(-1, -0.1), 0.95, room_speed);
        }
    }
    
    // Apply screenshake and gamepad vibration
    fx_camera_shake(32);
    fx_gamepad_vibration(1.0);
}

#define plr_anim_move
if (!fsmStateInit)
{
    // Reset the animation
    event_user(0);
    
    // Animate sprite animation
    owner.image_index = 0;
    owner.image_speed = 0;
    
    owner.moveFootstepPlayed = false;
}

// Update player sprite animation
with (owner)
{
    var _inputv = inputV[@ eINPUT.HLD];
    if (isSprinting)
    {
        // Set sprite
        if (isCharging)
        {
            if (_inputv < -0.5)
                sprite_index = sprPlayerMoveSprintChargeUp;
            else
                sprite_index = sprPlayerMoveSprintCharge;
        }
        else
        {
            sprite_index = sprPlayerMoveSprint;
        }
    }
    else
    {
        // Set sprite
        if (isCharging)
        {
            if (_inputv < -0.5)
                sprite_index = sprPlayerMoveChargeUp;
            else
                sprite_index = sprPlayerMoveCharge;
        }
        else
        {
            sprite_index = sprPlayerMove;
        }
    }
}

// Animate some bouncy movements
moveCtr += abs(owner.vx);
var _velfactor  = clamp(abs(owner.vx) / owner.moveVelMax, 0, 1);
var _osc        = sin(moveCtr * oGamevars.animPlrMoveOscFreq);
y           = power(abs(_osc), oGamevars.animPlrMoveBounceWeight) * -oGamevars.animPlrMoveBounceAmp * _velfactor;
image_angle = _osc * oGamevars.animPlrMoveWiggleAmp * _velfactor;

owner.image_index = (moveCtr * oGamevars.animPlrMoveUnit) * owner.image_number;

// Play sound on each step
if (abs(_osc) < 0.5)
{
    with (owner)
    {
        if (!moveFootstepPlayed)
        {
            moveFootstepPlayed = true;
            moveFootstepFlip *= -1;
            
            if (isSprinting)
            {
                sfx_play(sndWallImpact, 0.5 + moveFootstepFlip * 0.1, 0.7 + moveFootstepFlip * 0.3 + random_range(-0.1, 0.1));
                sfx_play(choose(sndFootstep1, sndFootstep2), 0.5 + moveFootstepFlip * 0.1, 0.7 + moveFootstepFlip * 0.2 + random_range(-0.1, 0.1));
            }
            else
            {
                sfx_play(choose(sndFootstep1, sndFootstep2), 0.5 + moveFootstepFlip * 0.1, 0.7 + moveFootstepFlip * 0.2 + random_range(-0.1, 0.1));
            }
            
            // emit some dust
            fx_emit_pomf(random_range(bbox_left, bbox_right), bbox_bottom);
        }
    }
}
else
{
    owner.moveFootstepPlayed = false;
}

// Update player facing
if (sign(owner.vx) != 0)
    owner.moveFacing = sign(owner.vx);

/// Check for state switches
if (!owner.upgradeMove) // If player has no longer upgraded movements, switch to crawl counterpart
{
    fsm_set("move_crawl");
}
else
{
    if (!owner.contactB) // Falling : switch to midair state
    {
        fsm_set("midair");
    }
    else if (abs(owner.vx) < oGamevars.animPlrMoveVelMin) // Idle
    {
        fsm_set("idle");
    }
}

#define plr_anim_move_crawl
if (!fsmStateInit)
{
    // Reset the animation
    event_user(0);
    
    // Set sprite
    owner.sprite_index = sprPlayerMoveCrawl;
    owner.image_index = 0;
    owner.image_speed = 0;
    
    moveCtr = 0;
    
    owner.moveFootstepPlayed = false;
}

// Animate movements
moveCtr += abs(owner.vx);
var _velfactor  = clamp(abs(owner.vx) / owner.moveVelMaxCrawl, 0, 1);
var _osc        = sin(moveCtr * oGamevars.animPlrMoveUnit);
image_angle     = _osc * oGamevars.animPlrMoveWiggleAmp * 0.5 * _velfactor;


// Animate sprite
with (owner)
{
    var _inputv = inputV[@ eINPUT.HLD];
    if (isCharging)
    {
        if (_inputv < -0.5)
            sprite_index = sprPlayerMoveCrawlChargeUp;
        else
            sprite_index = sprPlayerMoveCrawlCharge;
    }
    else
    {
        sprite_index = sprPlayerMoveCrawl;
    }
    image_index = (other.moveCtr * oGamevars.animPlrMoveUnit) * image_number;
}

// Play sound on each step
if (abs(_osc) < 0.1)
{
    if (!owner.moveFootstepPlayed)
    {
        owner.moveFootstepPlayed = true;
        owner.moveFootstepFlip *= -1;
        sfx_play(sndCrawl, 0.7 + owner.moveFootstepFlip * 0.1, 0.7 + owner.moveFootstepFlip * 0.2 + random_range(-0.1, 0.1));
    }
}
else
{
    owner.moveFootstepPlayed = false;
}

// Update player facing
if (sign(owner.vx) != 0)
    owner.moveFacing = sign(owner.vx);

/// Check for state switches
if (owner.upgradeMove) // If player has upgraded movements, switch to upgraded counterpart
{
    fsm_set("move");
}
else
{
    if (!owner.contactB) // Falling : switch to midair state
    {
        fsm_set("midair_crawl");
    }
    else if (abs(owner.vx) < oGamevars.animPlrMoveVelMin) // Idle
    {
        fsm_set("idle");
    }
}

#define plr_anim_midair_crawl
if (!fsmStateInit)
{
    // Reset the animation
    event_user(0);
    
    // Set sprite
    owner.sprite_index = sprPlayerKick;
    
    // Animate sprite animation
    owner.image_index = 3;
    owner.image_speed = 0;
    image_yscale = -1;
}

var _ownervel = 0;

// Animate sprite animation
with (owner)
{
    _ownervel = vx - vy * moveFacing;
}

// Animate movements
var _interp = interp_weight(fsmStateCtr, oGamevars.animPlrJumpSqueezeFrames, oGamevars.animPlrJumpSqueezeWeight, oGamevars.animPlrJumpSqueezeWeight);

// Tilt sprite according to velocity
image_angle = clamp(_ownervel / oGamevars.animPlrJumpMaxVel, -1, 1) * oGamevars.animPlrJumpTiltAmp * _interp;

/// Check for state switches
if (owner.upgradeMove) // If player has upgraded movements, switch to upgraded counterpart
{
    fsm_set("midair");
}
else
{
    if (owner.contactB) // Landed : Switch to idle / move
    {
        if (abs(owner.vx) < oGamevars.animPlrMoveVelMin)
        {
            fsm_set("idle");
        }
        else
        {
            fsm_set("move_crawl");
        }
        
        // Play sound
        sfx_play(sndWallImpact, 0.75, random_range(0.9, 1.1));
        sfx_play(sndHeavyImpact, 0.5, random_range(0.9, 1.1));
        
        // Apply screenshake and gamepad vibration
        fx_camera_shake(8);
        fx_gamepad_vibration(0.75);
        
        // Emit some dust & particles
        with (owner)
        {
            var _particle = fx_emit_pomf(random_range(bbox_left, bbox_right), bbox_bottom);
            _particle.vx = sign(_particle.x - x);
            _particle.vy = random_range(-0.5, 2);
            
            var _movedir = sign(vx);
            // debug_log("VX : ", vx, " | MOVEDIR : ", _movedir);
            repeat (irandom_range(4, 8))
            {
                if (_movedir != 0)
                    fx_emit_dust(lerp(bbox_left, bbox_right, _movedir * 0.5 + 0.5), bbox_bottom - vy, _movedir * random_range(-3, -1), random_range(-1, -0.25), 0.95, room_speed);
                else
                    fx_emit_dust(lerp(bbox_left, bbox_right, random_range(-0.1, 0.1) + 0.5), bbox_bottom - vy, random_range(-1, 1), random_range(-1, -0.1), 0.95, room_speed);
            }
        }
    }
}

#define plr_anim_jump
if (!fsmStateInit)
{
    // Reset the animation
    event_user(0);
    
    // Set sprite
    owner.sprite_index = sprPlayerJump;
    owner.image_index = 0;
    owner.image_speed = 0;
    
    // Play sound
    sfx_play(sndFootstepJump, 1.0, random_range(0.9, 1.1));
    
    // Apply screenshake and gamepad vibration
    fx_camera_shake(4);
    fx_gamepad_vibration(0.25);
    
    // Emit particle
    with (owner)
    {
        var _movedir = sign(vx);
        // debug_log("VX : ", vx, " | MOVEDIR : ", _movedir);
        repeat (irandom_range(8, 16))
        {
            if (_movedir != 0)
                fx_emit_dust(lerp(bbox_left, bbox_right, _movedir * 0.5 + 0.5), bbox_bottom - vy, _movedir * random_range(-3, -1), random_range(-1, -0.25), 0.95, room_speed);
            else
                fx_emit_dust(lerp(bbox_left, bbox_right, random_range(-0.1, 0.1) + 0.5), bbox_bottom - vy, random_range(-1, 1), random_range(-1, -0.1), 0.95, room_speed);
        }
    }
}

var _ownervel = 0;

// Animate sprite animation
with (owner)
{
    if (isCharging)
    {
        var _inputv = inputV[@ eINPUT.HLD];
        if (_inputv < -0.5)
            sprite_index = sprPlayerJumpChargeUp;
        else if (_inputv > 0.5)
            sprite_index = sprPlayerJumpChargeDown;
        else
            sprite_index = sprPlayerJumpCharge;
    }
    else
    {
        sprite_index = sprPlayerJump;
    }
    
    _ownervel = vy * moveFacing; // vx - vy * moveFacing;
}

var _interp = interp_weight(fsmStateCtr, oGamevars.animPlrJumpSqueezeFrames, 1.0, oGamevars.animPlrJumpSqueezeWeight);
var _interpinv = 1.0 - _interp;

// Tilt sprite according to velocity
image_angle = clamp(_ownervel / oGamevars.animPlrJumpMaxVel, -1, 1) * oGamevars.animPlrJumpTiltAmp * _interp;

// Apply squeeze
animFXSqueeze = -cos(fsmStateCtr * (0.1) * 2 * pi) * oGamevars.animPlrJumpSqueezeAmp * _interpinv;

/// Check for state switches
if (owner.contactB) // Landed : Switch to idle / move
{
    if (abs(owner.vx) < oGamevars.animPlrMoveVelMin)
        fsm_set("idle");
    else
        fsm_set("move");
        
    // Play sound
    sfx_play(sndFootstepLand, 0.75, random_range(0.9, 1.1));
    
    // Shake camera
    fx_camera_shake_add(1);
    
    // Emit some dust
    with (owner)
    {
        var _particle = fx_emit_pomf(random_range(bbox_left, bbox_right), bbox_bottom);
        _particle.vx = sign(_particle.x - x);
        _particle.vy = random_range(-0.5, 2);
    }
}
else if (sign(owner.vy) > 0) // Falling : switch to midair state
{
    fsm_set("midair");
}

#define plr_anim_midair
if (!fsmStateInit)
{
    // Reset the animation
    event_user(0);
    
    // Update player sprite info
    owner.image_speed = 0;
}

var _ownervel = 0;

// Animate sprite animation
with (owner)
{
    if (isCharging)
    {
        var _inputv = inputV[@ eINPUT.HLD];
        if (_inputv < -0.5)
            sprite_index = sprPlayerJumpChargeUp;
        else if (_inputv > 0.5)
            sprite_index = sprPlayerJumpChargeDown;
        else
            sprite_index = sprPlayerJumpCharge;
    }
    else
    {
        sprite_index = sprPlayerJump;
    }
    
    if (sign(vy) > 0)
    {
        image_index = 1;
    }
    else
    {
        image_index = 0;
    }
    
    _ownervel = vy * moveFacing; // vx - vy * moveFacing;
}

// Update player facing
if (sign(owner.vx) != 0)
    owner.moveFacing = sign(owner.vx);

var _interp = interp_weight(fsmStateCtr, oGamevars.animPlrJumpSqueezeFrames, 1.0, oGamevars.animPlrJumpSqueezeWeight);

// Tilt sprite according to velocity
image_angle = clamp(_ownervel / oGamevars.animPlrJumpMaxVel, -1, 1) * oGamevars.animPlrJumpTiltAmp * _interp;

/// Check for state switches
if (!owner.upgradeMove) // If player has no longer upgraded movements, switch to crawl counterpart
{
    fsm_set("midair_crawl");
}
else if (owner.contactB) // Landed : Switch to idle / move
{
    if (abs(owner.vx) < oGamevars.animPlrMoveVelMin)
    {
        fsm_set("idle");
    }
    else
    {
        fsm_set("move");
    }
    
    // Play sound
    sfx_play(sndFootstepLand, 0.75, random_range(0.9, 1.1));
    sfx_play(sndHeavyImpact, 0.5, random_range(0.9, 1.1));
    
    // Emit some dust
    with (owner)
    {
        var _particle = fx_emit_pomf(random_range(bbox_left, bbox_right), bbox_bottom);
        _particle.vx = sign(_particle.x - x);
        _particle.vy = random_range(-0.5, 2);
    }
    
    // Apply gamepad vibration
    fx_gamepad_vibration(1.0);
}

#define plr_anim_interact
if (!fsmStateInit)
{
    // Reset the animation
    event_user(0);
    
    // Set sprite
    owner.sprite_index  = sprPlayerInteract;
    owner.image_index   = 0;
    owner.image_speed = 0;
    
    // Play sound
    // sfx_play(sndYes, 1.0, random_range(0.9, 1.1));
}

/// Check for state switches
if (owner.fsmStateNext != "interact") // Ended interacting : switch to idle
{
    fsm_set("idle");
}

#define plr_anim_kick_down
if (!fsmStateInit)
{
    // Reset the animation
    event_user(0);
    
    // Set sprite
    owner.sprite_index = sprPlayerKick;
    owner.image_speed = 0;
    
    // Play sound
    sfx_play(sndKickInit, 1.0, random_range(1.0, 1.2));
}

// Animate sprite animation
var _windup = fsmStateCtr < oGamevars.animPlrKickWindupFrames;
with (owner)
{
    if (_windup)
        image_index = 0;
    else
        image_index = 3;
}

#define plr_anim_kick_dash
if (!fsmStateInit)
{
    // Reset the animation
    event_user(0);
    
    // Set sprite
    owner.sprite_index = sprPlayerKick;
    owner.image_speed = 0;
    
    // Play sound
    sfx_play(sndKickInit, 1.0, random_range(0.95, 1.05));
}

// Animate sprite animation
var _windup = fsmStateCtr < oGamevars.animPlrKickWindupFrames;
with (owner)
{
    if (_windup)
        image_index = 0;
    else
        image_index = 1;
}

var _interp = 1.0 - interp_weight(fsmStateCtr, oGamevars.animPlrKickSqueezeFrames, oGamevars.animPlrKickSqueezeWeight, 1.0);

// Apply squeeze
animFXSqueeze = oGamevars.animPlrKickSqueezeAmp * _interp;

/// Check for state switches
if (fsmStateCtr > owner.kickDashFrames) // Dash ended : switch to normal kick animation
{
    fsm_set("kick");
}

#define plr_anim_kick
if (!fsmStateInit)
{
    // Reset the animation
    event_user(0);
    
    // Set sprite
    owner.sprite_index = sprPlayerKick;
    
    // Animate sprite animation
    owner.image_index = 1;
    owner.image_speed = 0;
}

// Apply tilt
var _interp = owner.vy / owner.velGravMax;
image_angle = oGamevars.animPlrKickTiltAmp * _interp;

/// Check for state switches
if (owner.fsmStateNext != "kick" &&
    owner.fsmStateNext != "kick_knockback") // Kick ended
{
    if (!owner.contactB) // Fall
    {
        fsm_set("midair");
    }
    else
    {
        if (abs(owner.vx) < oGamevars.animPlrMoveVelMin)
            fsm_set("idle");
        else
            fsm_set("move");
    }
}

#define plr_anim_kick_knockback
if (!fsmStateInit)
{
    // Reset the animation
    event_user(0);
    
    // Set sprite
    owner.sprite_index = sprPlayerKick;
    
    // Animate sprite animation
    owner.image_index = 2;
    owner.image_speed = 0;
    
    // Play sound
    sfx_play(sndKickHit, 1.0, random_range(0.9, 1.1));
    sfx_play(sndWallImpact, 1.0, random_range(0.9, 1.1));
    
    // Apply screenshake and gamepad vibration
    fx_camera_shake(8);
    fx_gamepad_vibration(0.25);
    
    // Emit particle
    with (owner)
    {
        repeat (irandom_range(8, 16))
        {
            fx_emit_dust(lerp(bbox_left, bbox_right, moveFacing * 0.5 + 0.5), y, moveFacing * random_range(-3, -1), random_range(-2, 2), 0.95, room_speed);
        }
    }
}

// Apply shake
var _interp = 1.0 - interp_weight(fsmStateCtr, oGamevars.animPlrKickKnockbackShakeFrames, oGamevars.animPlrKickKnockbackShakeWeight, 1.0);
animFXShake = oGamevars.animPlrKickKnockbackShakeAmp * _interp;

// Apply tilt
_interp = owner.vy / owner.velGravMax;
image_angle = oGamevars.animPlrKickTiltAmp * _interp;

/// Check for state switches
if (owner.fsmStateNext != "kick_knockback") // Knockback ended
{
    if (!owner.contactB) // Fall
    {
        fsm_set("midair");
    }
    else
    {
        if (abs(owner.vx) < oGamevars.animPlrMoveVelMin)
            fsm_set("idle");
        else
            fsm_set("move");
    }
}

#define plr_anim_hurt
if (!fsmStateInit)
{
    // Reset the animation
    event_user(0);
    
    // Set sprite
    owner.sprite_index = sprPlayerHurt;
    
    // Animate sprite animation
    owner.image_index = 2;
    owner.image_speed = 0;
    
    // Play sound
    if (owner.hp > 0)
    {
        sfx_play(sndHurt, 0.75, random_range(0.9, 1.1));
        sfx_play(sndFleshImpact, 1.0, random_range(0.9, 1.1));
    }
    
    // Apply screenshake and gamepad vibration
    fx_camera_shake(16);
    fx_gamepad_vibration(1.0);
}

var _interp = 1.0 - interp_weight(fsmStateCtr, owner.hurtStunFrames, oGamevars.animPlrHurtWeight, 1.0);

/// Update sprite
if (fsmStateCtr < owner.hurtStunFrames) // show knockback sprite for first few frames
{
    // Set sprite & frame
    owner.sprite_index = sprPlayerHurt;
    owner.image_index = 0;
    
    // Update sprite angle
    if (owner.contactB)
        image_angle = oGamevars.animPlrHurtTiltAmpGround * owner.moveFacing * _interp;
    else
        image_angle = oGamevars.animPlrHurtTiltAmpMidair * owner.moveFacing * _interp;
}
else // show state-dependant hurt sprite afterwards
{
    // Set sprite & frame
    owner.sprite_index = sprPlayerHurt;
    owner.image_index = 0;
}

// Apply shake
animFXShake = oGamevars.animPlrHurtShakeAmp * _interp;

/// Check for state switches
if (fsmStateCtr > owner.hurtFrames) // Knockback ended
{
    if (!owner.contactB) // Fall
    {
        fsm_set("midair");
    }
    else
    {
        if (abs(owner.vx) < oGamevars.animPlrMoveVelMin)
            fsm_set("idle");
        else
            fsm_set("move");
    }
}

#define plr_anim_dead
if (!fsmStateInit)
{
    // Reset the animation
    event_user(0);
    
    // Play sound
    sfx_play(sndDead, 1.0, random_range(0.9, 1.1));
    sfx_play(sndFleshImpact, 1.0, random_range(0.9, 1.1));
}

/// Update sprite
if (owner.contactB)
{
    // Set sprite
    owner.sprite_index = sprPlayerHurt;
    
    // Animate sprite animation
    if (owner.image_index != 2)
    {
        owner.image_index = 2;
        image_angle = 0;
        
        // Play sound
        sfx_play(sndWallImpact, 0.75, random_range(0.9, 1.1));
        sfx_play(sndHeavyImpact, 0.5, random_range(0.9, 1.1));
    }
}
else
{
    // Set sprite
    owner.sprite_index = sprPlayerHurt;
    
    // Animate sprite animation
    owner.image_index = 1;
    image_angle -= angle_difference(image_angle, point_direction(0, 0, owner.vx, owner.vy)) * 0.1;
}