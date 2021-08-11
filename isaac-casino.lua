obs = obslua
my_settings = nil

characters = {}
extras = {}
bosses = {}

-- Description displayed in the Scripts dialog window
function script_description()
    return [[Isaac Casino
            Isaac Casino overlay]]
end
function script_update(settings)
    -- Keep track of current settings
    my_settings = settings
end
-- When script is loaded for the first time load all the images(options) into relevent arrays
function script_load(settings)
    -- Scanning given path and push it into given array
    function loadFilesIntoArr(arr, path)
        local dir = obs.os_opendir(script_path() .. "/Imges/" .. path)
        local entry
        repeat
            entry = obs.os_readdir(dir)
            if entry and not entry.directory then
                table.insert(arr, string.sub(entry.d_name, 0, -5))
            end
        until not entry
    end
    obslua.os_closedir(dir)

    loadFilesIntoArr(characters, "Characters")
    loadFilesIntoArr(extras, "Extras")
    loadFilesIntoArr(bosses, "Bosses")

    print("Done loading")

end

-- Create the sources for the images
function create_image(file_location, name, scene, xpos, ypos, xscale, yscale)

    local pos = obs.vec2()
    local scale = obs.vec2()

    local image_settings = obs.obs_data_create()
    obs.obs_data_set_string(image_settings, "file", script_path() .. file_location)
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
-- Takes in an array retuns a table with [option] => chance structre 
function sumChances(arr)
    local finalChances = {}
    local sum = 0
    for _, val in ipairs(arr) do
        finalChances[val] = obslua.obs_data_get_int(my_settings, val)
        sum = sum + obslua.obs_data_get_int(my_settings, val)
    end
    table.sort(finalChances)
    return finalChances, sum
end

-- Generate new run
function button()
    -- Selects random value from arr based on given chances
    function generateRandom(arr, fill)
        fill = fill or false
        local chances, totalSum = sumChances(arr)
        local accuSum = 0

        if (fill and totalSum < 100) then
            chances["none"] = 100 - totalSum
            table.sort(chances)
        end

        math.randomseed(os.time())
        local rand = math.random(totalSum)
        for key, chance in pairs(chances) do
            accuSum = accuSum + chance
            if (rand <= accuSum) then
                return key
            end
        end
    end
    -- Filters the extra options based on the path
    function generateExtra(boss)
        local extrasFiltered = {}
        for _, val in ipairs(extras) do
            if (boss == "Dogma" and val ~= "Hush") then
                table.insert(extrasFiltered, val)
            elseif (boss ~= "Dogma") then
                table.insert(extrasFiltered, val)
            end
        end
        return generateRandom(extrasFiltered, true)
    end

    local current_scene = obs.obs_frontend_get_current_scene()
    local scene = obs.obs_scene_from_source(current_scene)
    obs.obs_scene_release(scene)

    local char = generateRandom(characters)
    print(char)
    local boss = generateRandom(bosses)
    print(boss)

    local extra = generateExtra(boss)
    print(extra)
    local xpos = obslua.obs_data_get_int(my_settings, "xpos")
    local ypos = obslua.obs_data_get_int(my_settings, "ypos")
    local xscale = obslua.obs_data_get_int(my_settings, "xscale")
    local yscale = obslua.obs_data_get_int(my_settings, "yscale")

    local xoffset = 40 * xscale
    create_image("Imges\\Characters\\" .. char .. ".png", "Character", scene, xpos, ypos, xscale, yscale)
    xpos = xpos + xoffset
    create_image("Imges\\arrow.png", "fArrow", scene, xpos, ypos + 5, xscale, yscale)
    xpos = xpos + xoffset
    if (extra ~= "none") then
        create_image("Imges\\Extras\\" .. extra .. ".png", "Extra", scene, xpos, ypos + 5, xscale, yscale)
        xpos = xpos + xoffset
        create_image("Imges\\arrow.png", "sArrow", scene, xpos, ypos + 5, xscale, yscale)
        xpos = xpos + xoffset
    else
        local image_source = obs.obs_scene_find_source(scene, "sArrow")
        obs.obs_sceneitem_remove(image_source)
        image_source = obs.obs_scene_find_source(scene, "Extra")
        obs.obs_sceneitem_remove(image_source)
    end
    create_image("Imges\\Bosses\\" .. boss .. ".png", "Boss", scene, xpos, ypos + 5, xscale, yscale)

end
-- Show all properties
function script_properties()

    function generateProperties(arr, properties)
        -- Generating the properties baesd on a given array
        for _, val in ipairs(arr) do
            obslua.obs_properties_add_int(properties, val, "Chances of " .. val .. " (%)", 0, 100, 1)
        end
    end
    local properties = obs.obs_properties_create()

    -- Combo list filled with the options from MY_OPTIONS
    local p = obslua.obs_properties_add_list(properties, "mode", "Mode", obslua.OBS_COMBO_TYPE_LIST,
        obslua.OBS_COMBO_FORMAT_INT)
    MY_OPTIONS = {"Characters", "Extras", "Final Bosses"}
    for i, v in ipairs(MY_OPTIONS) do
        obslua.obs_property_list_add_int(p, v, i)
    end

    -- Sets callback upon modification of the list
    obslua.obs_property_set_modified_callback(p, set_visibility)

    -- Integer option to be displayed in Mode 1

    generateProperties(characters, properties)
    generateProperties(extras, properties)
    generateProperties(bosses, properties)

    -- Calls the callback once to set-up current visibility
    obslua.obs_properties_apply_settings(properties, my_settings)

    -- Base props
    obslua.obs_properties_add_float(properties, "xpos", "X location start", 0, 4000, 10)
    obslua.obs_properties_add_float(properties, "ypos", "Y location start", 0, 4000, 10)
    obslua.obs_properties_add_float(properties, "xscale", "x size", 1.5, 100, 10)
    obslua.obs_properties_add_float(properties, "yscale", "y size", 1.5, 100, 10)
    obslua.obs_hotkey_register_frontend("isaaccasinonewrun", "Generates a new Isaac path", button)
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
