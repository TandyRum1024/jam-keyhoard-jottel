#define ui_draw_text_format
/// ui_draw_text_format(_x, _y, _format, _scale, _col, _alpha, _halign, _valign, _formatargs)
var _x = argument0, _y = argument1, _format = argument2, _scale = argument3, _col = argument4, _alpha = argument5, _halign = argument6, _valign = argument7, _formatargs = argument8;
var _em = string_height('M') * _scale;

if (_format == "")
    return false;

// Calculate the string's width
var _currentline = 0;
var _strtokens  = ui_draw_text_format_process(_format);
var _strwid     = ui_draw_text_format_get_width_line(_format, _formatargs, _currentline) * _scale;
var _strhei     = ui_draw_text_format_get_height(_format, _formatargs) * _scale;
var _strwidlist = global.strfmtCachedStrWid[? _format];

// Begin drawing
draw_set_halign(0); draw_set_valign(0);
var _strdrawx = _x - (_strwid * _halign * 0.5);
var _strdrawy = _y - (_strhei * _valign * 0.5);
var _strstepy = _em;

// draw_circle_colour(_strdrawx, _strdrawy, 2, c_red, c_red, false);

for (var i=0; i<ds_list_size(_strtokens); i++)
{
    var _currenttoken = _strtokens[| i];
    switch (_currenttoken[@ eSTRTOKEN.TYPE])
    {
        case eSTRTOKEN_TYPE.STRING:
            var _currentstr = string_escape_newline(_currenttoken[@ eSTRTOKEN.DATA]);
            var _currentwid = _strwidlist[| i + 1];
            ui_draw_text(_strdrawx, _strdrawy, _currentstr, _scale, 0, _col, _alpha);
            
            _strdrawx += _currentwid * _scale;
            break;
            
        case eSTRTOKEN_TYPE.INPUT:
            // var _currentinput   = "[" + _currenttoken[@ eSTRTOKEN.DATA] + "]";
            var _inputspr   = ui_get_input_icon(_currenttoken[@ eSTRTOKEN.DATA]);
            var _currentwid = 0;
            if (is_array(_inputspr))
            {
                var _spr = _inputspr[@ 0];
                var _idx = _inputspr[@ 1];
                _currentwid = sprite_get_width(_spr) + 1;
                draw_sprite_ext(_spr, _idx, _strdrawx, _strdrawy, _scale, _scale, 0, c_orange, _alpha);
            }
            else
            {
                _currentinput = "[" + _currenttoken[@ eSTRTOKEN.DATA] + "]";
                _currentwid   = string_width(_currentinput);
                ui_draw_text(_strdrawx, _strdrawy, _currentinput, _scale, 0, c_orange, _alpha);
            }
            
            _strdrawx += _currentwid * _scale;
            break;
        
        case eSTRTOKEN_TYPE.PLACEHOLDER:
            var _currentstr = string(_formatargs[@ _currenttoken[@ eSTRTOKEN.DATA]]);
            var _currentwid = string_width(_currentstr);
            var _currenthei = string_height(_currentstr);
            // ui_draw_text(_strdrawx, _strdrawy, _currentstr, _scale, 0, c_yellow, _alpha);
            // ui_draw_text(_strdrawx, _strdrawy, _currentstr, _scale, 0, c_yellow, _alpha);
            ui_draw_rect_text(_strdrawx, _strdrawy, _currentwid * _scale, _currenthei * _scale, c_orange, _alpha, _currentstr, _scale, _scale, _scale, 0, 0, c_black, _alpha);
            
            _strdrawx += _currentwid * _scale;
            break;
            
        case eSTRTOKEN_TYPE.NEWLINE:
            _currentline++;
            _strwid = ui_draw_text_format_get_width_line(_format, _formatargs, _currentline) * _scale;
            
            _strdrawx = _x - (_strwid * _halign * 0.5);
            _strdrawy += _strstepy;
            break;
    }
}

#define ui_draw_text_format_process
/// ui_draw_text_format_process(_format)
/*  
    processes the formatted text into list of tokens if there's no cached data
    and stores it into the cache
*/
var _format = argument0;
var _originalformat = _format;

var _tokens = global.strfmtCachedStrTokens[? _format];
if (_tokens == undefined || !ds_exists(_tokens, ds_type_list))
{
    // There's no cached tokens; process a new one
    // debug_log("=] FMTSTR : PROCESSTOKEN > NO CACHED DATA FOR FORMAT [", _format, "] FOUND, PROCESSING ONE...");
    _tokens = ds_list_create();
    
    var _currentbuffer = ""; // buffer string that contains current 'chunk' of strings
    var _tokenpos = string_pos('$', _format);
    // consume format string until there's no more string to consume
    while (string_length(_format) > 0 && _tokenpos != 0)
    {
        // Get the string containing the part after the '$' character
        var _strafter = string_delete(_format, 1, _tokenpos);
        
        // Check for pairing brackets
        var _bracketstartpos    = string_pos('{', _strafter);
        var _bracketstrafter    = string_delete(_strafter, 1, _bracketstartpos);
        var _bracketlength      = string_pos('}', _bracketstrafter);
        var _tokentype           = -1;
        var _tokendata           = -1;
        var _tokencodesuccessful = false;
        if (_bracketstartpos != 0 && _bracketlength != 0)
        {
            // Pairing brackets were found; find the inner code and process it
            // Get the inner code part of the token
            var _code = string_copy(_bracketstrafter, 1, _bracketlength - 1);
            
            // Parse the inner code
            if (_code == "") // Check if the code is blank
            {
                // wow. just treat them as a normal character
                _tokencodesuccessful = false;
            }
            else if (string(real(_code)) == _code) // Check if the code is numeric value such as ${0}, ${2} etc..
            {
                // treat them as a placeholder token
                _tokentype = eSTRTOKEN_TYPE.PLACEHOLDER;
                _tokendata = real(_code); // placeholder data index (used for fetching the format arguments array)
                _tokencodesuccessful = true;
            }
            else // Check if the code fits in none of the above type
            {
                // parse the code
                var _codecommapos   = string_pos(',', _code);
                var _codecmd        = _code;
                var _codeargs       = "";
                
                // if the comma is present in the control code,
                // then split them into command part and the argument part
                if (_codecommapos != 0)
                {
                    _codecmd    = string_copy(_code, 1, _codecommapos - 1);
                    _codeargs   = string_trim_whitespace(string_delete(_code, 1, _codecommapos));
                }
                
                // debug_log(" > DETECTED TOKEN : [CMD : `", _codecmd, "`, ARGS : `", _codeargs, "`] (FULL CODE : `", _code, "`)");
                
                switch (_codecmd)
                {
                    case "key":
                        // treat them as an input button token
                        // debug_log(" > TOKEN TYPE : KEY");
                        
                        _tokentype = eSTRTOKEN_TYPE.INPUT;
                        _tokendata = _codeargs;
                        _tokencodesuccessful = true;
                        break;
                    
                    case "br":
                    case "n":
                        // treat them as an newline token
                        // debug_log(" > TOKEN TYPE : NEWLINE");
                        
                        _tokentype = eSTRTOKEN_TYPE.NEWLINE;
                        _tokencodesuccessful = true;
                        break;
                }
            }
        }
        
        if (_tokencodesuccessful)
        {
            _currentbuffer += string_copy(_format, 1, _tokenpos - 1);
            _format = string_delete(_strafter, 1, _bracketstartpos + _bracketlength);
            
            // Code was successfully consumed
            // Add the buffer string to the token list as a string
            if (_currentbuffer != "")
            {
                ds_list_add(_tokens, ui_draw_text_format_new_token(eSTRTOKEN_TYPE.STRING, _currentbuffer));
            }
            
            // Clear the buffer string
            _currentbuffer = "";
            
            // Add the control token to the token list
            ds_list_add(_tokens, ui_draw_text_format_new_token(_tokentype, _tokendata));
        }
        else
        {
            // Code wasn't successfully consumed
            _currentbuffer += string_copy(_format, 1, _tokenpos);
            _format = _strafter;
        }
        
        // Update token position
        _tokenpos = string_pos('$', _format);
    }
    
    // If there's still some string left in the format text unconsumed,
    // then add it to the token list as a string
    if (_format != "" || _currentbuffer != "")
        ds_list_add(_tokens, ui_draw_text_format_new_token(eSTRTOKEN_TYPE.STRING, _currentbuffer + _format));

    // debug_log("=] FMTSTR : PROCESSTOKEN > PROCESSING FORMAT [", _originalformat, "] DONE, DUMPING...");
    // ui_draw_text_format_dump_tokens(_tokens);

    // Cache the resulting token list
    global.strfmtCachedStrTokens[? _originalformat] = _tokens;
}
return _tokens;

#define ui_draw_text_format_new_token
/// ui_draw_text_format_new_token(_type, _data)
// returns the array with token data filled in
var _type = argument0, _data = argument1;
var _arr = -1;
_arr[eSTRTOKEN.TYPE] = _type;
_arr[eSTRTOKEN.DATA] = _data;
return _arr;

#define ui_draw_text_format_dump_tokens
/// ui_draw_text_format_dump_tokens(_tokenlist)
// dumps the text format token list into the debug log
var _tokenlist = argument0;

if (ds_exists(_tokenlist, ds_type_list))
{
    debug_log("=] FMTSTR : DUMPTOKEN > TOKEN LIST DUMP (size : ", ds_list_size(_tokenlist), ")");
    for (var i=0; i<ds_list_size(_tokenlist); i++)
    {
        var _token = _tokenlist[| i];
        var _tokentype = _token[@ eSTRTOKEN.TYPE];
        var _tokendata = _token[@ eSTRTOKEN.DATA];
        var _tokentypestr = "";
        if (_tokentype < 0 || _tokentype >= array_length_1d(global.strfmtLUTTokenType))
            _tokentypestr = "??? " + string(_tokentype);
        else
            _tokentypestr = global.strfmtLUTTokenType[@ _tokentype];
        
        debug_log(" >> TOKEN ", i, " : ");
        debug_log("  + TYPE : `", _tokentypestr, "`");
        debug_log("  + DATA : `", _tokendata, "`");
    }
}
else
{
    debug_log("!!] FMTSTR : DUMPTOKEN > TOKEN LIST DOESN'T EXIST");
}

#define ui_draw_text_format_get_width
/// ui_draw_text_format_get_width(_format, _formatargs)
// returns formatted text's unscaled width with format arguments placed in
var _format = argument0, _formatargs = argument1;

// Get the tokens list of format
var _tokens = ui_draw_text_format_process(_format);

/// Check for cached token width list
var _linewidthlist = -1;
var _widlist = global.strfmtCachedStrWid[? _format];
if (_widlist == undefined || !ds_exists(_widlist, ds_type_list))
{
    // No cached list found; compute a new one
    _widlist = ds_list_create();
    
    // (reserve the first item in the list for precalculated width of every single lines excluding non-string tokens)
    _linewidthlist = ds_list_create();
    ds_list_add(_widlist, _linewidthlist);
    
    // Iterate through the tokens & calculate the width of every line of string excluding nonstring stuffs
    var _linewidth = 0; // stores the width of current line
    var _newlinetokenoffset = 0;
    for (var i=0; i<ds_list_size(_tokens); i++)
    {
        var _currenttoken = _tokens[| i];
        switch (_currenttoken[@ eSTRTOKEN.TYPE])
        {
            case eSTRTOKEN_TYPE.STRING:
                // Calculate string's width and store it to the list
                var _string = _currenttoken[@ eSTRTOKEN.DATA];
                var _strwid = string_width(string_escape_newline(_string));
                
                ds_list_add(_widlist, _strwid);
                _linewidth += _strwid;
                break;
            
            case eSTRTOKEN_TYPE.NEWLINE:
                // No predetermined width; just store 0
                // But also break current line & store the line width
                ds_list_add(_widlist, 0);
                ds_list_add(_linewidthlist, makearray(_linewidth, _newlinetokenoffset));
                _linewidth = 0;
                _newlinetokenoffset = i;
                break;
            
            default:
                // No predetermined width; just store 0
                ds_list_add(_widlist, 0);
                break;
        }
    }
    ds_list_add(_linewidthlist, makearray(_linewidth, _newlinetokenoffset));
    
    // Cache the resulting width list
    global.strfmtCachedStrWid[? _format] = _widlist;
}
else
{
    // Fetch the precalculated width list
    _linewidthlist = _widlist[| 0];
}

/// Calculate the maximum width of string
var _currentline = 0;
var _currentlinedata = _linewidthlist[| _currentline];
var _maxwidth = _currentlinedata[@ 0]; // this contains the maximum width of formatted string
var _width = 0; // this contains the width of non-string tokens on current line

// Iterate through the tokens
for (var i=0; i<ds_list_size(_tokens); i++)
{
    var _currenttoken = _tokens[| i];
    switch (_currenttoken[@ eSTRTOKEN.TYPE])
    {
        case eSTRTOKEN_TYPE.PLACEHOLDER:
            var _argidx = _currenttoken[@ eSTRTOKEN.DATA];
            var _argstr = string(_formatargs[@ _argidx]);
            _width += string_width(_argstr);
            break;
        
        case eSTRTOKEN_TYPE.INPUT:
            var _inputspr   = ui_get_input_icon(_currenttoken[@ eSTRTOKEN.DATA]);
            var _currentwid = 0;
            if (is_array(_inputspr))
            {
                var _spr = _inputspr[@ 0];
                _currentwid = sprite_get_width(_spr) + 1;
            }
            else
            {
                var _currentinput = "[" + _currenttoken[@ eSTRTOKEN.DATA] + "]";
                _currentwid   = string_width(_currentinput);
            }
            _width += _currentwid;
            break;
        
        case eSTRTOKEN_TYPE.NEWLINE:
            // Line break : Calculate maximum width of string
            // and increment current line index
            var _currentlinedata = _linewidthlist[| _currentline];
            _maxwidth = max(_maxwidth, _currentlinedata[@ 0] + _width);
            _width = 0;
            
            _currentline++;
            break;
    }
}

// Return the calculated maximum width
return _maxwidth;

#define ui_draw_text_format_get_width_line
/// ui_draw_text_format_get_width_line(_format, _formatargs, _line)
// returns unscaled width of single line from formatted text with format arguments placed in
var _format = argument0, _formatargs = argument1, _line = argument2;

// Get the tokens list of format
var _tokens = ui_draw_text_format_process(_format);

/// Check for cached token width list
var _linewidthlist = -1;
var _widlist = global.strfmtCachedStrWid[? _format];
if (_widlist == undefined || !ds_exists(_widlist, ds_type_list))
{
    // No cached list found; compute a new one
    _widlist = ds_list_create();
    
    // (reserve the first item in the list for precalculated width of every single lines excluding non-string tokens)
    _linewidthlist = ds_list_create();
    ds_list_add(_widlist, _linewidthlist);
    
    // Iterate through the tokens & calculate the width of every line of string excluding nonstring stuffs
    var _linewidth = 0; // stores the width of current line
    var _newlinetokenoffset = 0;
    for (var i=0; i<ds_list_size(_tokens); i++)
    {
        var _currenttoken = _tokens[| i];
        switch (_currenttoken[@ eSTRTOKEN.TYPE])
        {
            case eSTRTOKEN_TYPE.STRING:
                // Calculate string's width and store it to the list
                var _string = _currenttoken[@ eSTRTOKEN.DATA];
                var _strwid = string_width(string_escape_newline(_string));
                
                ds_list_add(_widlist, _strwid);
                _linewidth += _strwid;
                break;
            
            case eSTRTOKEN_TYPE.NEWLINE:
                // No predetermined width; just store 0
                // But also break current line & store the line width
                ds_list_add(_widlist, 0);
                ds_list_add(_linewidthlist, makearray(_linewidth, _newlinetokenoffset));
                _linewidth = 0;
                _newlinetokenoffset = i + 1;
                break;
            
            default:
                // No predetermined width; just store 0
                ds_list_add(_widlist, 0);
                break;
        }
    }
    ds_list_add(_linewidthlist, makearray(_linewidth, _newlinetokenoffset));
    
    // Cache the resulting width list
    global.strfmtCachedStrWid[? _format] = _widlist;
}
else
{
    // Fetch the precalculated width list
    _linewidthlist = _widlist[| 0];
}

/// Calculate the width of line
var _currentlinedata = _linewidthlist[| _line];
var _width       = _currentlinedata[@ 0]; // this contains the width of current line
var _tokenoffset = _currentlinedata[@ 1]; // this contains the index of first token from current line

// Iterate through the tokens
var _break = false;
for (var i=_tokenoffset; i<ds_list_size(_tokens); i++)
{
    var _currenttoken = _tokens[| i];
    switch (_currenttoken[@ eSTRTOKEN.TYPE])
    {
        case eSTRTOKEN_TYPE.PLACEHOLDER:
            var _argidx = _currenttoken[@ eSTRTOKEN.DATA];
            var _argstr = string(_formatargs[@ _argidx]);
            _width += string_width(_argstr);
            break;
        
        case eSTRTOKEN_TYPE.INPUT:
            var _inputspr   = ui_get_input_icon(_currenttoken[@ eSTRTOKEN.DATA]);
            var _currentwid = 0;
            if (is_array(_inputspr))
            {
                var _spr = _inputspr[@ 0];
                _currentwid = sprite_get_width(_spr) + 1;
            }
            else
            {
                _currentinput = "[" + _currenttoken[@ eSTRTOKEN.DATA] + "]";
                _currentwid   = string_width(_currentinput);
            }
            _width += _currentwid;
            break;
        
        case eSTRTOKEN_TYPE.NEWLINE:
            // Line break : Stop calculating the width of line
            _break = true;
            break;
    }
    
    if (_break)
        break;
}

return _width;

#define ui_draw_text_format_get_height
/// ui_draw_text_format_get_height(_format, _formatargs)
// returns formatted text's unscaled height with format arguments placed in
var _format = argument0, _formatargs = argument1;
var _em = string_height('M');

// Get the tokens list of format
var _tokens = ui_draw_text_format_process(_format);

// Check for cached token height
var _height = global.strfmtCachedStrHei[? _format];
if (_height == undefined)
{
    // No cached list found; compute a new one
    _height = _em;
    
    // Calculate the height of the formatted string
    for (var i=0; i<ds_list_size(_tokens); i++)
    {
        var _currenttoken = _tokens[| i];
        switch (_currenttoken[@ eSTRTOKEN.TYPE])
        {
            case eSTRTOKEN_TYPE.NEWLINE:
                _height += _em;
                break;
        }
    }
    
    // Cache the resulting height
    global.strfmtCachedStrHei[? _format] = _height;
}

return _height;

#define ui_draw_text_format_init
// initializes formatted text cache
enum eSTRTOKEN
{
    TYPE = 0,
    DATA
}

enum eSTRTOKEN_TYPE
{
    STRING = 0,
    NEWLINE,
    INPUT,
    PLACEHOLDER
}

// (debug) Table of string to convert token type index to string representation of type
global.strfmtLUTTokenType = -1;
global.strfmtLUTTokenType[eSTRTOKEN_TYPE.STRING]      = "STR";
global.strfmtLUTTokenType[eSTRTOKEN_TYPE.NEWLINE]     = "NEWLINE";
global.strfmtLUTTokenType[eSTRTOKEN_TYPE.INPUT]       = "INPUT";
global.strfmtLUTTokenType[eSTRTOKEN_TYPE.PLACEHOLDER] = "PLACEHOLDER";

global.strfmtCachedStrTokens = ds_map_create(); // cached string token data
global.strfmtCachedStrWid = ds_map_create(); // cached string raw width
global.strfmtCachedStrHei = ds_map_create(); // cached string raw height

#define ui_draw_text_format_destroy
// destroys formatted text cache
if (ds_exists(global.strfmtCachedStrTokens, ds_type_map))
{
    var _key = ds_map_find_first(global.strfmtCachedStrTokens);
    while (_key != undefined)
    {
        var _value = global.strfmtCachedStrTokens[? _key];
        if (ds_exists(_value, ds_type_list))
            ds_list_destroy(_value);
        
        _key = ds_map_find_next(global.strfmtCachedStrTokens, _key);
    }
    
    ds_map_destroy(global.strfmtCachedStrTokens);
}

if (ds_exists(global.strfmtCachedStrWid, ds_type_map))
{
    var _key = ds_map_find_first(global.strfmtCachedStrWid);
    while (_key != undefined)
    {
        var _value = global.strfmtCachedStrWid[? _key];
        if (ds_exists(_value, ds_type_list))
        {
            var _precalculatedwidths = _value[| 0];
            
            if (ds_exists(_precalculatedwidths, ds_type_list))
                ds_list_destroy(_precalculatedwidths);
            ds_list_destroy(_value);
        }
        
        _key = ds_map_find_next(global.strfmtCachedStrWid, _key);
    }
    
    ds_map_destroy(global.strfmtCachedStrWid);
}

if (ds_exists(global.strfmtCachedStrHei, ds_type_map))
    ds_map_destroy(global.strfmtCachedStrHei);