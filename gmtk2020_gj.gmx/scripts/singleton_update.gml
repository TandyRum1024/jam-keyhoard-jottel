if (instance_number(object_index) > 1)
{
    objectInitialized = false;
    debug_log("SINGLETON > DELETED DUPLICATE OBJECT ", object_get_name(object_index), " (NOW : ", instance_number(object_index), " OBJECTS)");
    instance_destroy(id);
    return false;
}

objectInitialized = true;
return true;
