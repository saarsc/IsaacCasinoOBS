obs = obslua
my_settings = nil

characters = {}
extras = {}
bosses = {}
loaded = false
-- Description displayed in the Scripts dialog window
function script_description()
    return [[Isaac Casino
            Isaac Casino overlay]]
end
function script_update(settings)
    -- Keep track of current settings
    my_settings = settings
end
function script_load(settings)
    function loadFilesIntoArr(arr, path)
        local dir = obs.os_opendir(script_path() .. "/Imges/" .. path)
        local entry
        repeat
            entry = obs.os_readdir(dir)
            if entry and not entry.directory then
                print(entry.d_name)
                table.insert(arr, string.sub(entry.d_name, 0, -5))
            end
        until not entry
    end
    loadFilesIntoArr(characters, "Characters")
    -- loadFilesIntoArr(extras, "Extras")
    -- loadFilesIntoArr(bosses, "Bosses")

    -- obs.obs_frontend_add_event_callback(on_event)
    print("Done loading")
    loaded = true
end

-- Create the sources for the images
function create_image(file_location, name, scene, xpos, ypos, xscale, yscale)

    local pos = obs.vec2()
    local scale = obs.vec2()

    local image_settings = obs.obs_data_create()
    obs.obs_data_set_string(image_settings, "file", script_path() .. file_location)
    print(file_location)
    if (obs.obs_scene_find_source(scene, name)) then
        local image_source = obs.obs_scene_find_source(scene, name)
        obs.obs_sceneitem_remove(image_source)
        print(name .. " source exists")
    end
    local image_source = obs.obs_source_create("image_source", name, image_settings, nil)
    obs.obs_scene_add(scene, image_source)

    local image_sceneitem = obs.obs_scene_find_source(scene, name)
    local image_location = pos
    local image_scale = scale
    if image_sceneitem then
        image_location.x = xpos
        image_location.y = ypos
        image_scale.x = xscale
        image_scale.y = yscale
        obs.obs_sceneitem_set_pos(image_sceneitem, image_location)
        obs.obs_sceneitem_set_scale(image_sceneitem, image_scale)
    end

    obs.obs_source_update(image_source, image_settings)
    obs.obs_data_release(image_settings)
    obs.obs_source_release(image_source)

end
-- Generate new run
function button()

    local current_scene = obs.obs_frontend_get_current_scene()
    local scene = obs.obs_scene_from_source(current_scene)
    obs.obs_scene_release(scene)

    create_image("Imges\\Result\\character.png", "Character", scene, 0, 0, 10, 10)
end

function script_properties()

    function generateProperties(arr, properties)
        for _, val in ipairs(arr) do
            obslua.obs_properties_add_int(properties, val, "Chances of " .. val .. " (%)", 0, 100, 1)
        end
    end
    local properties = obs.obs_properties_create()

    -- Combo list filled with the options from MY_OPTIONS
    local p = obslua.obs_properties_add_list(properties, "mode", "My list", obslua.OBS_COMBO_TYPE_LIST,
        obslua.OBS_COMBO_FORMAT_INT)
    MY_OPTIONS = {"Characters", "Extras", "Final Bosses"}
    for i, v in ipairs(MY_OPTIONS) do
        obslua.obs_property_list_add_int(p, v, i)
    end

    -- Sets callback upon modification of the list
    obslua.obs_property_set_modified_callback(p, set_visibility)

    -- Integer option to be displayed in Mode 1
    if (loaded == true) then
        print("props gen")
        generateProperties(characters, properties)
    end

    -- Calls the callback once to set-up current visibility
    obslua.obs_properties_apply_settings(properties, my_settings)
    -- Generate Run
    obslua.obs_properties_add_int(properties, "xpos", "X location start", 0, 4000, 10)
    obslua.obs_properties_add_int(properties, "ypos", "X location start", 0, 4000, 10)
    obslua.obs_properties_add_int(properties, "xscale", "x size", 0, 100, 10)
    obslua.obs_properties_add_int(properties, "yscale", "y size", 0, 100, 10)
    local button = obs.obs_properties_add_button(properties, "generate_run", "Generate Run", button)
    return properties

end

-- Callback on list modification
function set_visibility(props, property, settings)
    function updateVisability(arr, mode)
        for _, val in ipairs(arr) do
            obslua.obs_property_set_visible(obslua.obs_properties_get(props, val), mode)
        end
    end
    -- Retrieves value selected in list
    local mode = obslua.obs_data_get_int(settings, "mode")

    -- Preset parameters
    updateVisability(characters, mode == 1)
    updateVisability(extras, mode == 2)
    updateVisability(bosses, mode == 3)

    -- IMPORTANT: returns true to trigger refresh of the properties
    return true
end
