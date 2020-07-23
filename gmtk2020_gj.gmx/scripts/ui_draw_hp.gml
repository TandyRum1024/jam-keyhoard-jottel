if (instance_exists(oPlayer))
{
    var _hpinterp = clamp(oPlayer.hp / oPlayer.hpMax, 0, 1);
    var _hpstr      = "HP : " + string(oPlayer.hp) + " / " + string(oPlayer.hpMax);
    var _hpcolour   = c_white;
    var _hpscale    = 4 * global.gameUIZoom;
    
    // check if player's HP is depleted
    if (oPlayer.hp <= 0)
    {
        _hpstr = "X_X";
        _hpcolour = c_gray;
    }
    
    var _hpbarmaxwid    = global.winWid * 0.4;
    var _hpbarwid       = sprite_get_width(sprUIHealth) * _hpscale;
    var _hpbarhei       = sprite_get_height(sprUIHealth) * _hpscale;
    var _hpbarx         = global.winCenterX - _hpbarmaxwid * 0.5;
    var _hpbary         = 16;
    
    // bar BG
    draw_sprite_stretched(sprUIHealth, 1, _hpbarx, _hpbary, _hpbarmaxwid, _hpbarhei);
    
    // bar FG
    draw_sprite_stretched(sprUIHealth, 2, _hpbarx, _hpbary, _hpbarmaxwid * _hpinterp, _hpbarhei);
    
    // bar deco
    draw_sprite_ext(sprUIHealth, 0, _hpbarx - _hpbarwid, _hpbary, _hpscale, _hpscale, 0, c_white, 1.0);
    draw_sprite_ext(sprUIHealth, 3, _hpbarx + _hpbarmaxwid, _hpbary, _hpscale, _hpscale, 0, c_white, 1.0);
    
    // Health value
    draw_set_halign(1); draw_set_valign(1);
    draw_text_transformed_color(global.winCenterX, _hpbary + _hpbarhei * 0.5 + _hpscale, _hpstr, _hpscale, _hpscale, 0, c_black, c_black, c_black, c_black, 1.0);
    draw_text_transformed_color(global.winCenterX, _hpbary + _hpbarhei * 0.5, _hpstr, _hpscale, _hpscale, 0, _hpcolour, _hpcolour, _hpcolour, _hpcolour, 1.0);
}
