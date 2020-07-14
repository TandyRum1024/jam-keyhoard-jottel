#define plr_state_normal
/// Player normal state
/// Update input
plr_update_input();

/// Update movement
plr_update_movement();

/// Update physics
// (gravity)
if (vy < velGravMax && !contactB)
{
    vy += velGravAcc;
}

// (position)
mask_index = bboxPlayer; // Set mask
ent_update();

// (damp velocity)
if (!isMoving)
{
    vx *= velDamp;
}

/// Update interaction
plr_update_interaction();

/// Update damage
plr_update_damage();

#define plr_state_spawn_fall
/// Player spawn falling state
if (!fsmStateInit)
{
    // Fire anim
    anim_fire("midair_crawl");
}

/// Update physics
// (gravity)
if (vy < velGravMax && !contactB)
{
    vy += velGravAcc;
}

// (position)
mask_index = bboxPlayer; // Set mask
ent_update();

// (damp velocity)
if (!isMoving)
{
    vx *= velDamp;
}

/// If player has landed, switch to idle state
if (contactB)
{
    fsm_set("default");
}

#define plr_state_interact
/// Player interacting state
if (!fsmStateInit)
{
    // Set movement flag to false
    isSprinting     = false;
    isJumping       = false;
    isFastfalling   = false;
    isMoving        = false;
    
    // Fire anim
    anim_fire("interact");
}

/// Update input
plr_update_input();

/// Update physics
// (gravity)
if (vy < velGravMax && !contactB)
{
    vy += velGravAcc;
}

// (position)
mask_index = bboxPlayer; // Set mask
ent_update();

// (damp velocity)
vx *= velDamp;

#define plr_state_kick_dash
/// Player kick : dashing state
if (!fsmStateInit)
{
    // Store velocity for wall boosting
    kickDashSaveVY = clamp(vy * kickDashSaveFactor, -kickDashSaveMaxVY, kickDashSaveMaxVY);
    debug_log("KICKDASH > STORED VY : ", kickDashSaveVY);
}

/// Update input
plr_update_input();

/// Update dash
var _interp = interp_weight(fsmStateCtr, kickDashFrames, 1.0, 3.0);
var _vel = lerp(kickDashVel, kickDashEndVel, _interp);
vx = _vel * kickDashDirX;
vy = _vel * kickDashDirY;

/// Update physics
// (position)
var _prevvx = vx;
mask_index = bboxPlayer; // Set mask
ent_update();

/// Check for state switch
if (colB) // If player has (somehow) landed -> go to normal state
{
    fsm_set("default");
}
else if (colL || colR) // Check if player has bonked against the wall
{
    // Stick to wall
    mask_index = bboxPlayer;
    ent_move_x(sign(_prevvx) * 16);
    
    // Apply some upwards boost
    var _dir = sign(_prevvx);
    if (_dir == 0)
        _dir = moveFacing;
    
    vy = min(kickDashSaveVY - kickWallBoostVel, -kickWallBoostVel);
    vx = -_dir * kickKnockbackVel;
    // debug_log("KICKDASH > APPLIED VY : ", vy);
    
    // Set state to kick knockback
    fsm_set("kick_knockback");
    
    // Fire anim
    anim_fire("kick_knockback");
}
else if (fsmStateCtr > kickDashFrames) // Check if dash duration has ended
{
    // Set state to normal kick
    fsm_set("kick");
}

#define plr_state_kick
/// Player kicking state
if (fsmStateInit)
{
    // Set gravity
    velGravAcc = velGravAccJump;
}

/// Update input
plr_update_input();

/// Update physics
// (gravity)
if (vy < velGravMax && !contactB)
{
    vy += velGravAcc;
}

// (position)
var _prevvx = vx;
mask_index = bboxPlayer; // Set mask
ent_update();

/// Check for state switch
if (contactB) // If player has landed -> go to normal state
{
    fsm_set("default");
}
else if (colL || colR) // Check if player has bonked against the wall
{
    // Stick to wall
    mask_index = bboxPlayer;
    ent_move_x(sign(_prevvx) * 16);
    
    // Apply some upwards boost
    var _dir = sign(_prevvx);
    if (_dir == 0)
        _dir = moveFacing;
        
    vy = min(vy - kickWallBonkVel, -kickWallBonkVel);
    vx = -_dir * kickKnockbackVel;
    
    // Set state to kick knockback
    fsm_set("kick_knockback");
    
    // Fire anim
    anim_fire("kick_knockback");
}

/// Check for state exit
if (fsmStateNext != fsmState)
{
    // Reset gravity
    velGravAcc = velGravAccDefault;
}

#define plr_state_kick_down
/// Player downwards kick state
if (fsmStateInit)
{
    // Fire anim
    anim_fire("kick_down");
}

/// Update input
plr_update_input();

/// Update movement
var _inputh      = inputH[@ eINPUT.HLD];
var _inputhpress = inputH[@ eINPUT.PRS];

// Apply movement
if (_inputh != 0)
{
    var _accel = clamp(kickDownControlVel - vx * _inputh, 0, moveVelAccSprint);
    vx += _accel * _inputh;
    isMoving = true;
}
else
{
    isMoving = false;
}

/// Update dive
vy = kickDownDiveVel;

/// Update physics
// (position)
mask_index = bboxPlayer; // Set mask
ent_update();

// (damp velocity)
if (!isMoving)
{
    vx *= velDamp;
}

/// Check for state switch
if (contactB) // If player has landed -> go to kick knockback state
{
    // (apply upwards boost)
    var _vel = kickDownBounceVel;
    if (inputJump[@ eINPUT.HLD])
        _vel = kickDownBounceVelHigh;
    vy = -_vel;
    
    // (switch state)
    fsm_set("kick_knockback");
}

#define plr_state_kick_knockback
/// Player kick knockback / stun state
if (fsmStateInit)
{
    // Set gravity
    velGravAcc = velGravAccKick;
    
    // Instantly face the kicking direction
    if (sign(vx) != 0)
        moveFacing = sign(vx);
        
    // Fire anim
    anim_fire("kick_knockback");
}

/// Update input
plr_update_input();

if (fsmStateCtr > kickKnockbackStunFrames)
{
    plr_update_movement();
}

/// Update physics
// (gravity)
if (vy < velGravMax && !contactB)
{
    vy += velGravAcc;
}

// (position)
mask_index = bboxPlayer; // Set mask
ent_update();

// (damp velocity)
if (!isMoving)
{
    vx *= kickKnockbackDamp;
}

/// Check for state switch
if (contactB) // If player has landed -> go to normal state
{
    fsm_set("default");
}
else if (fsmStateCtr > kickKnockbackFrames) // If stun duration has ended -> go to normal state
{
    fsm_set("default");
}

/// Check for state exit
if (fsmStateNext != fsmState)
{
    // Reset gravity
    velGravAcc = velGravAccDefault;
}

#define plr_state_hurt
/// Player hurt knockback / stun state
if (fsmStateInit)
{
    // Instantly face the opposite of knockback direction
    if (sign(vx) != 0)
        moveFacing = -sign(vx);
        
    // Fire anim
    anim_fire("hurt");
    
    // Emit particles
    repeat (irandom_range(4, 16))
    {
        var _x = random_range(bbox_left, bbox_right);
        var _y = random_range(bbox_top, bbox_bottom);
        fx_emit_dust(_x, _y, random_range(-4, 4), random_range(-4, 4), 0.95, room_speed);
    }
}

/// Update input
plr_update_input();

if (fsmStateCtr > hurtStunFrames)
{
    plr_update_movement();
}
else
{
    // Check for death
    if (hp <= 0)
    {
        fsm_set("dead");
    }
}

/// Update physics
// (gravity)
if (vy < velGravMax && !contactB)
{
    vy += velGravAcc;
}

// (position)
mask_index = bboxPlayer; // Set mask
ent_update();

// (damp velocity)
if (contactB && !isMoving)
{
    vx *= kickKnockbackDamp;
}

/// Check for state switch
if (fsmStateCtr > hurtFrames) // If stun duration has ended -> go to normal state
{
    fsm_set("default");
}

#define plr_state_dead
/// Player hurt knockback / stun state
if (fsmStateInit)
{
    // Instantly face the opposite of knockback direction
    if (sign(vx) != 0)
        moveFacing = -sign(vx);
        
    // Fire anim
    anim_fire("dead");
}

/// Update physics
// (gravity)
if (vy < velGravMax && !contactB)
{
    vy += velGravAcc;
}

// (position)
mask_index = bboxPlayer; // Set mask
ent_update();

// (damp velocity)
if (contactB)
{
    vx *= kickKnockbackDamp;
}