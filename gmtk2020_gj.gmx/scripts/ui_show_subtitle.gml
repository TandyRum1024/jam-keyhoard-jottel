/// ui_show_subtitle(_str, _time = oUI.UISubtitleShowFramesDefault)
var _str = argument[0];
var _time; if (argument_count > 1) _time = argument[1]; else _time = oUI.UISubtitleShowFramesDefault;
with (oUI)
{
    if (UISubtitle != _str)
    {
        UISubtitle = _str;
        UISubtitleShowAnimFrames = 0;
    }
    UISubtitleShowFrames = _time;
}
