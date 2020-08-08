#define enemy_anim_move
/// Move animation
if (!fsmStateInit)
{
    event_user(0);
    
    owner.sprite_index = sprEnemy;
    owner.image_index  = 0;
}

// Animate wiggly animation
animFXSqueeze = sin(oGamevars.animEnemyMoveOscFreq * fsmStateCtr) * oGamevars.animEnemyMoveSqueezeAmp;
y = sprite_get_height(owner.sprite_index) * animFXSqueeze * 0.5;

#define enemy_anim_attack_windup
/// Attack windup
if (!fsmStateInit)
{
    event_user(0);
    
    owner.sprite_index = sprEnemy;
    owner.image_index  = 2;
}

// Animate windup animation
var _interp = interp_weight(fsmStateCtr, owner.attackWindupFrames, oGamevars.animEnemyWindupWeight, 1.0);
animFXShake = oGamevars.animEnemyMoveSqueezeAmp * _interp;

#define enemy_anim_attack
/// Attack
if (!fsmStateInit)
{
    event_user(0);
    
    owner.sprite_index = sprEnemy;
    owner.image_index  = 1;
}

// Animate attack animation
var _interp = 1.0 - interp_weight(fsmStateCtr, owner.attackDamageFrames, oGamevars.animEnemyAttackWeight, 1.0);
animFXShake     = oGamevars.animEnemyAttackShakeAmp * _interp;
animFXSqueeze   = oGamevars.animEnemyAttackSqueezeAmp * _interp;

#define enemy_anim_hurt
/// Hurt
if (!fsmStateInit)
{
    event_user(0);
    
    owner.sprite_index = sprEnemy;
    owner.image_index  = 2;
}

// Animate attack animation
var _interp = 1.0 - interp_weight(fsmStateCtr, owner.hurtStunFrames, oGamevars.animEnemyHurtWeight, 1.0);
animFXShake = oGamevars.animEnemyHurtShakeAmp * _interp;