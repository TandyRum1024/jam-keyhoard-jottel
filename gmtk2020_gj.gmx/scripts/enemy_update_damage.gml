/// enemy_update_damage
var _projectile = instance_place(x, y, oPlayerAttack);
if (instance_exists(_projectile))
{
    fsm_set("hurt");
    
    // apply damage
    hp -= _projectile.damage;
    
    // apply knockback
    vx = lengthdir_x(_projectile.knockback, _projectile.image_angle);
    vy = lengthdir_y(_projectile.knockback, _projectile.image_angle) - _projectile.knockback;
    
    return true;
}
return false;
