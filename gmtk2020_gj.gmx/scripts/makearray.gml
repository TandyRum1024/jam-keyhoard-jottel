/// @function makearray(v1, v2, v3...)
/// @param ... values for array
var _arr = -1;
for (var i=0; i<argument_count; i++)
{
    _arr[i] = argument[i];
}
return _arr;
