/// ui_draw_subtitle
if (UISubtitleShowFrames > 0)
{
    var _showinterp = interp_weight(UISubtitleShowAnimFrames, UISubtitleShowFramesFade, 3.0, 1.5);
    var _hideinterp = interp_weight(UISubtitleShowFrames, UISubtitleShowFramesFade, 2.0, 2.0);
    
    var _subtitlex = global.winCenterX;
    var _subtitley = global.winHei * 0.9;
    var _subtitlescale = 2 * global.gameUIZoom;
    var _subtitledecoscale = 2 * _subtitlescale;
    var _subtitledecoscale2= 2 * _subtitledecoscale;
    var _subtitlemaxwid = global.winWid * 0.9;
    var _subtitlestr    = string_copy(UISubtitle, 1, _showinterp * string_length(UISubtitle));
    var _subtitlewid    = string_width_ext(_subtitlestr, -1, _subtitlemaxwid / _subtitlescale) * _subtitlescale + 6 * _subtitledecoscale;
    var _subtitlehei    = string_height_ext(_subtitlestr, -1, _subtitlemaxwid / _subtitlescale) * _subtitlescale + 6 * _subtitledecoscale;
    var _subtitlealpha  = 1.0 * _hideinterp;
    
    // (backdrop)
    var _subtitleboxx = _subtitlex - _subtitlewid * 0.5;
    var _subtitleboxy = _subtitley - _subtitlehei * 0.5;
    ui_draw_rect(_subtitleboxx + _subtitledecoscale, _subtitleboxy + _subtitledecoscale, _subtitlewid, _subtitlehei, c_black, _subtitlealpha);
    ui_draw_rect(_subtitleboxx, _subtitleboxy, _subtitlewid, _subtitlehei, c_blue, _subtitlealpha);
    ui_draw_rect(_subtitleboxx + _subtitledecoscale, _subtitleboxy + _subtitledecoscale, _subtitlewid - _subtitledecoscale2, _subtitlehei - _subtitledecoscale2, c_ltgray, _subtitlealpha);
    ui_draw_rect(_subtitleboxx + _subtitledecoscale2, _subtitleboxy + _subtitledecoscale2, _subtitlewid - _subtitledecoscale2 * 2, _subtitlehei - _subtitledecoscale2 * 2, c_blue, _subtitlealpha);
    
    // (text)
    draw_set_halign(1); draw_set_valign(1);
    ui_draw_text_ext(_subtitlex, _subtitley, _subtitlestr, -1, _subtitlemaxwid, _subtitlescale, 0, c_white, _subtitlealpha);
}
