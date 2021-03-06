#define sfx_init
global.sfxVolume       = 1.0;
global.musicVolume     = 0.75;
global.musicSoundIndex = -1;
global.musicMusic      = -1;

#define sfx_play
/// sfx_play(_snd, _vol, _pitch)
var _snd = argument0, _vol = argument1, _pitch = argument2;
var _fx = audio_play_sound(_snd, 0, false);
audio_sound_gain(_fx, _vol * global.sfxVolume, 0);
audio_sound_pitch(_fx, _pitch);
return _fx;

#define music_play
/// music_play(_mus, _vol = 1.0, _fadeintime = room_speed)
var _mus = argument[0];
var _vol; if (argument_count > 1) _vol = argument[1]; else _vol = 1.0;
var _fadeintime; if (argument_count > 2) _fadeintime = argument[2]; else _fadeintime = room_speed;
if (_mus != global.musicMusic)
{
    if (audio_is_playing(global.musicSoundIndex))
        audio_stop_sound(global.musicSoundIndex);
    global.musicSoundIndex = audio_play_sound(_mus, 0, true);
    global.musicMusic = _mus;
    audio_sound_gain(global.musicSoundIndex, 0, 0);
    audio_sound_gain(global.musicSoundIndex, global.musicVolume * _vol, _fadeintime);
}
else
{
    audio_sound_gain(global.musicSoundIndex, global.musicVolume * _vol, _fadeintime);
}

#define music_update_volume
/// music_update_volume(_vol = 1.0, _fadeintime = room_speed)
var _vol; if (argument_count > 0) _vol = argument[0]; else _vol = 1.0;
var _fadeintime; if (argument_count > 1) _fadeintime = argument[1]; else _fadeintime = room_speed;
audio_sound_gain(global.musicSoundIndex, global.musicVolume * _vol, _fadeintime);