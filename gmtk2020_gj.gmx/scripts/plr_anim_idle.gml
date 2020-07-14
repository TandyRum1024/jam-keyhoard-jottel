#define plr_anim_idle
if (!fsmStateInit)
{
    // Reset the animation
    event_user(0);
    owner.image_index = 0;
}

// Update player sprite animation
if (owner.upgradeMove)
{
    // Set sprite
    if (owner.isCharging)
        owner.sprite_index = sprPlayerIdleCharge;
    else
        owner.sprite_index = sprPlayerIdle;
    owner.image_speed = 0.125;
}
else
{
    owner.sprite_index  = sprPlayerMoveCrawl;
    owner.image_index   = 0;
    owner.image_speed   = 0;
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
if (owner.isSprinting)
{
    // Set sprite
    owner.sprite_index = sprPlayerMoveSprint;
}
else
{
    // Set sprite
    if (owner.isCharging)
        owner.sprite_index = sprPlayerMoveCharge;
    else
        owner.sprite_index = sprPlayerMove;
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
    if (!owner.moveFootstepPlayed)
    {
        owner.moveFootstepPlayed = true;
        owner.moveFootstepFlip *= -1;
        sfx_play(choose(sndFootstep1, sndFootstep2), 0.5 + owner.moveFootstepFlip * 0.1, 0.7 + owner.moveFootstepFlip * 0.2 + random_range(-0.1, 0.1));
        
        // emit some dust
        with (owner)
        {
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

owner.image_index = (moveCtr * oGamevars.animPlrMoveUnit) * owner.image_number;

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
        sfx_play(sndFleshImpact, 0.75, random_range(0.9, 1.1));
    }
}

#define plr_anim_jump
if (!fsmStateInit)
{
    // Reset the animation
    event_user(0);
    
    // Set sprite
    owner.sprite_index = sprPlayerOld;
    owner.image_speed = 0;
    
    // Play sound
    sfx_play(sndFootstepJump, 1.0, random_range(0.9, 1.1));
}

var _ownervel = 0;

// Animate sprite animation
with (owner)
{
    image_index = 2;
    _ownervel = vx - vy * moveFacing;
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
    
    // emit some dust
    with (owner)
    {
        fx_emit_pomf(random_range(bbox_left, bbox_right), bbox_bottom);
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
    
    // Update player sprite
    owner.sprite_index = sprPlayerOld;
    owner.image_speed = 0;
}

var _ownervel = 0;

// Animate sprite animation
with (owner)
{
    if (sign(vy) > 0)
        image_index = 1;
    else
        image_index = 2;
    
    _ownervel = vx - vy * moveFacing;
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
    
    // emit some dust
    with (owner)
    {
        fx_emit_pomf(random_range(bbox_left, bbox_right), bbox_bottom);
    }
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
    sfx_play(sndYes, 1.0, random_range(0.9, 1.1));
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
    sfx_play(sndHurt, 1.0, random_range(0.9, 1.1));
}

/// Update sprite
if (owner.contactB)
{
    // Set sprite
    owner.sprite_index = sprPlayerHurt;
    
    // Animate sprite animation
    owner.image_index = 0;
    image_angle = 0;
}
else
{
    // Set sprite
    owner.sprite_index = sprPlayerHurt;
    
    // Animate sprite animation
    owner.image_index = 1;
    image_angle -= angle_difference(image_angle, point_direction(0, 0, owner.vx, owner.vy)) * 0.5;
}

// Apply shake
var _interp = 1.0 - interp_weight(fsmStateCtr, owner.hurtStunFrames, oGamevars.animPlrHurtWeight, 1.0);
animFXShake = oGamevars.animPlrHurtShakeAmp * _interp;

/// Check for state switches
if (fsmStateCtr != owner.hurtFrames) // Knockback ended
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
}

/// Update sprite
if (owner.contactB)
{
    // Set sprite
    owner.sprite_index = sprPlayerHurt;
    
    // Animate sprite animation
    owner.image_index = 2;
    image_angle = 0;
}
else
{
    // Set sprite
    owner.sprite_index = sprPlayerHurt;
    
    // Animate sprite animation
    owner.image_index = 1;
    image_angle -= angle_difference(image_angle, point_direction(0, 0, owner.vx, owner.vy)) * 0.1;
}