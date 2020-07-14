#define enemy_state_normal
/// Enemy normal state
if (!fsmStateInit)
{
    isDamaging = false;
    anim_fire("move");
}

// Move back & forth
var _accel = min(moveVelAcc, moveVelMax - vx * moveDir);
vx += _accel * moveDir; // vel moveDir;
moveFacing = moveDir;

/// Update physics
// (gravity)
if (vy < velGravMax && !contactB)
{
    vy += velGravAcc;
}

mask_index = bboxPlayer; // Set mask
ent_update();

// Turn around if there's wall in front of the enemy
if (colL)
{
    moveDir = 1;
}
else if (colR)
{
    moveDir = -1;
}

// Check vs projectile
var _projectile = instance_place(x, y, oPlayerAttack);
if (instance_exists(_projectile))
{
    fsm_set("hurt");
    
    // apply damage
    hp -= _projectile.damage;
    
    // apply knockback
    vx = lengthdir_x(_projectile.knockback, _projectile.image_angle);
    vy = lengthdir_y(_projectile.knockback, _projectile.image_angle) - _projectile.knockback;
}
else if (place_meeting(x, y, oPlayer)) // Check if player is colliding
{
    var _dir = sign(oPlayer.x - x);
    if (_dir != 0)
    {
        moveFacing = _dir;
    }
    
    fsm_set("attack_windup");
}

#define enemy_state_attack_windup
/// Enemy attack windup state
if (!fsmStateInit)
{
    isDamaging = false;
    anim_fire("attack_windup");
}

// (gravity)
if (vy < velGravMax && !contactB)
{
    vy += velGravAcc;
}

mask_index = bboxPlayer; // Set mask
ent_update();

// (damp velocity)
vx *= velDamp;

/// Check attack windup done
if (fsmStateCtr > attackWindupFrames)
{
    fsm_set("attack");
}

#define enemy_state_attack
/// Enemy attacking state
if (!fsmStateInit)
{
    isDamaging = true;
    anim_fire("attack");
}

/// Update damage flag
if (fsmStateCtr > attackDamageFrames)
{
    isDamaging = false;
}

// (gravity)
if (vy < velGravMax && !contactB)
{
    vy += velGravAcc;
}

mask_index = bboxPlayer; // Set mask
ent_update();

// (damp velocity)
vx *= velDamp;

// Check vs projectile
var _projectile = instance_place(x, y, oPlayerAttack);
if (instance_exists(_projectile))
{
    fsm_set("hurt");
    
    // apply damage
    hp -= _projectile.damage;
    
    // apply knockback
    vx = lengthdir_x(_projectile.knockback, _projectile.image_angle);
    vy = lengthdir_y(_projectile.knockback, _projectile.image_angle) - _projectile.knockback;
}
else
{
    /// Check attack end
    if (fsmStateCtr > attackFrames)
    {
        fsm_set("normal");
    }
}

#define enemy_state_hurt
/// Enemy hurt state
if (!fsmStateInit)
{
    isDamaging = false;
    anim_fire("hurt");
    
    // Play sound
    sfx_play(sndFleshImpact, 1.0, random_range(0.9, 1.1));
    
    // Emit particles
    repeat (irandom_range(4, 16))
    {
        var _x = random_range(bbox_left, bbox_right);
        var _y = random_range(bbox_top, bbox_bottom);
        fx_emit_dust(_x, _y, random_range(-4, 4), random_range(-4, 4), 0.95, room_speed);
    }
}

/// Check stun end
if (fsmStateCtr > hurtStunFrames)
{
    if (hp > 0)
    {
        fsm_set("normal");
    }
    else
    {
        instance_destroy(id);
    }
}