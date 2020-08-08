#define ui_load_keyslot_display_layout
/// ui_load_keyslot_display_layout(_path = "ui/keyslotlayout.json")
var _path; if (argument_count > 0) _path = argument[0]; else _path = "ui/keyslotlayout.json";
var _contents = "";
var _FILE = file_text_open_read(_path);
if (_FILE != -1)
{
    while (!file_text_eof(_FILE))
    {
        _contents += file_text_readln(_FILE);
    }
    file_text_close(_FILE);
}
else
{
    debug_log("KEYSLOTLAYOUT - LOAD() > THE LAYOUTFILE `", _path, "` DOES NOT EXIST!");
}

with (oUI)
{
    // Destroy already existsing layout map & layout data
    if (UIInputLayoutJson != undefined && ds_exists(UIInputLayoutJson, ds_type_map))
        ds_map_destroy(UIInputLayoutJson);
    if (UIInputLayouts != undefined && ds_exists(UIInputLayouts, ds_type_map))
        ds_map_destroy(UIInputLayouts);
    
    // Parse json into layout map
    UIInputLayoutJson = json_decode(_contents);
    UIInputLayouts    = ds_map_create();
    
    // Iterate & process the layout data into the form that
    // our UI functions can easily digest
    for (var _jsonlayoutkey = ds_map_find_first(UIInputLayoutJson);
        _jsonlayoutkey != undefined;
        _jsonlayoutkey = ds_map_find_next(UIInputLayoutJson, _jsonlayoutkey))
    {
        /*
            Layout format :
            "<LAYOUT_ID_1>" : {
                "config" : {
                    "name" : <DISPLAY NAME OF LAYOUT>,
                    "spriteset" : "<SPRITE SET NAME>",
                    "gridw" <WIDTH OF GRID (for display)>,
                    "gridh" <HEIGHT OF GRID (for display)>
                },
                "inputs" : {
                    "<KEYSLOT_ID>" : {
                        "display" : "<DISPLAY_STRING>",
                        "gridx" : "<XPOS IN GRID SPACE>",
                        "gridy" : "<YPOS IN GRID SPACE>",
                        "offx" : "<OFFSET XPOS>",
                        "offy" : "<OFFSET YPOS>",
                        "spridx" : <INDEX OF SPRITE USED FOR DRAWING KEYSLOT>
                    },
                    "<KEYSLOT_ID>" : {...}
                }
            },
            "<LAYOUT_ID_2>" : {
                ...
            }
        */
        // Get JSON data of layout
        var _jsonlayoutdata = UIInputLayoutJson[? _jsonlayoutkey];
        var _layoutdata = -1;
        
        debug_log("KEYSLOTLAYOUT - LOAD() > FOUND LAYOUT : `", _jsonlayoutkey, "`");
        
        // Fill in layout data's config section
        var _jsonlayoutconfigdata = _jsonlayoutdata[? "config"];
        var _layoutconfig = -1;
        _layoutconfig[eKEYLAYOUT_CONFIG.LAYOUT_ID] = _jsonlayoutkey;
        _layoutconfig[eKEYLAYOUT_CONFIG.NAME]      = _jsonlayoutconfigdata[? "name"];
        _layoutconfig[eKEYLAYOUT_CONFIG.SPRITESET] = _jsonlayoutconfigdata[? "spriteset"];
        _layoutconfig[eKEYLAYOUT_CONFIG.GRIDW] = _jsonlayoutconfigdata[? "gridw"];
        _layoutconfig[eKEYLAYOUT_CONFIG.GRIDH] = _jsonlayoutconfigdata[? "gridh"];
        
        _layoutdata[eKEYLAYOUT.CONFIG] = _layoutconfig;
        // debug_log(" ==> LAYOUT NAME : ", _layoutconfig[eKEYLAYOUT_CONFIG.NAME], "");
        
        // Fill in layout data's key info section
        var _jsonlayoutinputs = _jsonlayoutdata[? "inputs"];
        var _layoutinputs    = -1;
        var _layoutinputidx  = 0;
        
        // (iterate through all of the keys in the _jsonlayoutinputs)
        // (and build an array of input data)
        // debug_log(" ==> KEYS :");
        for (var _jsoninputkey = ds_map_find_first(_jsonlayoutinputs);
            _jsoninputkey != undefined;
            _jsoninputkey = ds_map_find_next(_jsonlayoutinputs, _jsoninputkey))
        {
            var _jsonlayoutinputdata = _jsonlayoutinputs[? _jsoninputkey];
            var _layoutinputdata     = -1;
            _layoutinputdata[eKEYLAYOUT_KEY.INPUT_ID]    = _jsoninputkey;
            _layoutinputdata[eKEYLAYOUT_KEY.DISPLAY_STR] = _jsonlayoutinputdata[? "display"];
            _layoutinputdata[eKEYLAYOUT_KEY.GRIDX]       = _jsonlayoutinputdata[? "gridx"];
            _layoutinputdata[eKEYLAYOUT_KEY.GRIDY]       = _jsonlayoutinputdata[? "gridy"];
            _layoutinputdata[eKEYLAYOUT_KEY.OFFX]        = _jsonlayoutinputdata[? "offx"];
            _layoutinputdata[eKEYLAYOUT_KEY.OFFY]        = _jsonlayoutinputdata[? "offy"];
            _layoutinputdata[eKEYLAYOUT_KEY.SPRIDX]      = _jsonlayoutinputdata[? "spridx"];
            _layoutinputs[_layoutinputidx++] = _layoutinputdata;
            
            // debug_log("  => INPUT : `", _jsoninputkey, "`] `", _layoutinputdata[eKEYLAYOUT_KEY.DISPLAY_STR], "`");
        }
        // debug_log(" ==> TOTAL INPUTS : ", _layoutinputidx);
        
        _layoutdata[eKEYLAYOUT.INPUTS] = _layoutinputs;
        
        // Add it to the list of layouts
        UIInputLayouts[? _jsonlayoutkey] = _layoutdata;
    }
    
    debug_log("KEYSLOTLAYOUT - LOAD() > SUCCESSFULLY LOADED LAYOUTFILE `", _path, "`");
}

#define ui_set_keyslot_display_layout
/// ui_set_keyslot_display_layout(_layoutname)
var _layoutname = argument0;
with (oUI)
{
    UIInputLayoutCurrent     = _layoutname;
    UIInputLayoutCurrentData = UIInputLayouts[? _layoutname];
    
    var _conf = UIInputLayoutCurrentData[@ eKEYLAYOUT.CONFIG];
    UIInputLayoutCurrentSpriteset = _conf[@ eKEYLAYOUT_CONFIG.SPRITESET];
}

#define ui_keyslot_display_layout_detect
if (oInput.inputMethodCurrent == eINPUT_METHOD.KEYBOARD)
{
    ui_set_keyslot_display_layout("keyboard");
}
else
{
    if (oInput.inputDevice <= 3) // xbox / xinput
    {
        ui_set_keyslot_display_layout("gamepad_xbox");
        
        // switch confirm/deny button
        oInput.inputBindGamepadConfirmAlt = gp_face1; // A button
        oInput.inputBindGamepadDenyAlt    = gp_face2; // B button
    }
    else
    {
        ui_set_keyslot_display_layout("gamepad_ps");
        
        // switch confirm/deny scheme
        oInput.inputBindGamepadConfirmAlt = gp_face3; // CROSS button
        oInput.inputBindGamepadDenyAlt    = gp_face4; // CIRCLE button
    }
}