/// string_escape_newline(_str)
// Returns the newline-escaped string
var _str = argument0;
// return string_replace(string_replace(_str, "#", "\#"), "\\#", "\#");
return string_replace(_str, "#", "\#");
