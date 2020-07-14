if (instance_number(object_index) > 1)
{
    instance_destroy(id);
    debug_log("SINGLETONE > DELETED DUPLICATE OBJECT ", object_get_name(object_index), " (NOW : ", instance_number(object_index), " OBJECTS)");
    return false;
}

return true;
