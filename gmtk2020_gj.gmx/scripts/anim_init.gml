#define anim_init
animator = instance_create(0, 0, oAnim);
animator.owner = id;

#define anim_add_anim
/// anim_add_anim(anim, updatescr)
with (animator)
{
    fsm_add_state(argument0, argument1);
}

#define anim_fire
/// anim_fire(anim)
with (animator)
{
    fsm_set(argument0);
}

#define anim_destroy
instance_destroy(animator);