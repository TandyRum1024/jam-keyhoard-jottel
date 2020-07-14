#define ent_init
vx = 0;
vy = 0;
velDamp     = 0.75;
velGravAcc  = 0.5;
velGravMax  = 8;

// Collision info
colL = false;
colR = false;
colT = false;
colB = false;

contactL = false;
contactR = false;
contactT = false;
contactB = false;

#define ent_move_x
/// ent_move_x(vel)
colL = false;
colR = false;

var _sv         = sign(vx);
var _maxstep    = sprite_width;
if (place_meeting(x + vx, y, oTileCollision))
{
    while (!place_meeting(x + _sv, y, oTileCollision) && _maxstep > 0)
    {
        x += _sv;
        _maxstep--;
    }
    
    vx = 0;
    
    // Update collision info
    if (_sv > 0)
    {
        colL = false;
        colR = true;
    }
    else if (_sv < 0)
    {
        colL = true;
        colR = false;
    }
    else
    {
        // Stuck?
        colL = true;
        colR = true;
    }
}

x += vx;

#define ent_move_y
/// ent_move_y(vel)
colT = false;
colB = false;

var _sv         = sign(vy);
var _maxstep    = sprite_height;
if (place_meeting(x, y + vy, oTileCollision))
{
    while (!place_meeting(x, y + _sv, oTileCollision) && _maxstep > 0)
    {
        y += _sv;
        _maxstep--;
    }
    
    vy = 0;
    
    // Update collision info
    if (_sv > 0)
    {
        colT = false;
        colB = true;
    }
    else if (_sv < 0)
    {
        colT = true;
        colB = false;
    }
    else
    {
        // Stuck?
        colT = true;
        colB = true;
    }
}

y += vy;

#define ent_update_contact
contactL = place_meeting(x - 1, y, oTileCollision);
contactR = place_meeting(x + 1, y, oTileCollision);
contactT = place_meeting(x, y - 1, oTileCollision);
contactB = place_meeting(x, y + 1, oTileCollision);

#define ent_update
/// Update entity position
ent_move_x(vx);
ent_move_y(vy);

/// Update entity contact flag
ent_update_contact();