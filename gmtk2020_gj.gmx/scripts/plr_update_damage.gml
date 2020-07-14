/// Check against mob collision & damage
var _enemy = instance_place(x, y, oEnemy);
if (instance_exists(_enemy))
{
    if (_enemy.isDamaging)
    {
        // Switch to hurt state and damage player
        fsm_set("hurt");
        hp -= _enemy.damage;
        
        // Also apply knockback
        vx = _enemy.moveFacing * hurtKnockbackX;
        vy = -hurtKnockbackY;
    }
}
