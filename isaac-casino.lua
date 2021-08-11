obs = obslua

my_settings = nil

characters = {}
extras = {}
bosses = {}
local img =
    "data:image/png;base64,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"
-- Description displayed in the Scripts dialog window
function script_description()
    return [[<center><h2>Isaac Casino</h2><center>
            <center><img src=']] .. img .. [['></center>
            <center><a href="https://github.com/saarsc/IsaacCasinoOBS">GitHub Repo</a></center>
            <p>Isaac Casino path generator </p> ]]
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
    obslua.obs_properties_add_float(properties, "xscale", "x size", 0, 100, 10)
    obslua.obs_properties_add_float(properties, "yscale", "y size", 0, 100, 10)
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
