if (UIMessageShowFrames > 0)
{
    var _centerx = global.winCenterX, _centery = global.winCenterY;
    var _interp = interp_weight(UIMessageShowFrames, UIMessageShowFramesMax, 2.0, 3.0);
    var _textcol1 = make_color_hsv(random_range(0, 255), random_range(0, 100), random_range(220, 255));
    var _textcol2 = make_color_hsv(random_range(0, 255), random_range(0, 100), random_range(180, 220));
    var _alpha = _interp;
    var _strwid = global.winWid * 0.75;
    
    // big message
    var _msg1y = _centery * 0.5;
    var _msg1hei = string_height(UIMessage1) * UIMessage1Scale;
    draw_set_halign(1); draw_set_valign(1);
    ui_draw_text_ext(_centerx + UIMessage1Scale, _msg1y + UIMessage1Scale, UIMessage1, -1, _strwid, UIMessage1Scale, 0, c_dkgray, _alpha);
    ui_draw_text_ext(_centerx, _msg1y, UIMessage1, -1, _strwid, UIMessage1Scale, 0, _textcol1, _alpha);
    // small message
    var _msg2y = _msg1y + _msg1hei * 0.5 + 32;
    draw_set_halign(1); draw_set_valign(0);
    ui_draw_text_ext(_centerx + UIMessage2Scale, _msg2y + UIMessage2Scale, UIMessage2, -1, _strwid, UIMessage2Scale, 0, c_dkgray, _alpha);
    ui_draw_text_ext(_centerx, _msg2y, UIMessage2, -1, _strwid, UIMessage2Scale, 0, _textcol2, _alpha);
}
