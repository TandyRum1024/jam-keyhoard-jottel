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

// Turn around if there's wall in front of the enemy or there is no ground ahead
var _frontposx = lerp(bbox_left, bbox_right, moveDir * 0.5 + 0.5) + 16 * moveDir;
var _frontposy = bbox_bottom + 16;
var _groundahead = position_meeting(_frontposx, _frontposy, oTileCollision);
if (contactB && !_groundahead)
{
    moveDir *= -1;
}
else
{
    if (colL)
    {
        moveDir = 1;
    }
    else if (colR || !_groundahead)
    {
        moveDir = -1;
    }
}

// Check vs projectile
var _hurt = enemy_update_damage();

// Check if player is colliding
if (!_hurt && place_meeting(x, y, oPlayer))
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
var _hurt = enemy_update_damage();

if (!_hurt)
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
    
    // Shake camera
    fx_camera_shake_add(8);
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