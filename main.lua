local menu = require("menu")
local last_print_time = 0
local print_interval = 0.5

local function follow_ally()
    local local_player = get_local_player()
    local player_position = get_player_position()

    if not local_player or not player_position then
        console.print("Local player or position is invalid.")
        return
    end

    local allies = actors_manager.get_ally_actors()

    if not allies or #allies == 0 then
        console.print("No ally players retrieved.")
        return
    end

    local specific_ally_id = tonumber(menu.elements.ally_id_input:get()) 

    if not specific_ally_id then
        console.print("Invalid ally ID input.")
        return
    end

    local specific_ally = nil

    for _, ally in ipairs(allies) do
        local ally_id = ally:get_id()
        if ally_id == specific_ally_id then
            specific_ally = ally
            break 
        end
    end

    if specific_ally then
        local ally_position = specific_ally:get_position()

        if not ally_position then
            return
        end

        local move_target = nil
        if specific_ally:is_moving() then
            move_target = specific_ally:get_move_destination()
        else
            move_target = ally_position
        end

        if move_target then
            local distance_to_ally = player_position:dist_to(move_target)
            if distance_to_ally > 1 then
                pathfinder.request_move(move_target)  
            else
            end
        end
    else
        local current_time = get_gametime()  
        if current_time - last_print_time >= print_interval then
            console.print("No ally with the specific ID found.")
            last_print_time = current_time
        end
    end
end

-- Keybind Prints ally ID within 1 unit of mouse cursor
local function print_ally_id_near_cursor()
    local cursor_position = get_cursor_position()
    if not cursor_position then
        console.print("Cursor position is invalid.")
        return
    end

    local allies = actors_manager.get_ally_actors()
    local local_player = get_local_player()

    if not allies or #allies == 0 then
        console.print("No ally players found.")
        return
    end

    for _, ally in ipairs(allies) do
        local ally_position = ally:get_position()

        if ally:get_id() ~= local_player:get_id() then
            local distance_to_cursor = cursor_position:dist_to(ally_position)
            if distance_to_cursor <= 1 then
                console.print("Ally ID within 1 units of cursor: ", ally:get_id())
            end
        else
        end
    end
end

on_key_press(function(key)
    if key == 0x52 then -- you can change the keybind for nearby ally print here
        print_ally_id_near_cursor()
    end
end)


on_update(function()
    local local_player = get_local_player()

    if not local_player or not menu.elements.main_toggle:get() then
        return
    end

    if menu.elements.follow_toggle:get() then
        follow_ally()
    end
end)

on_render_menu(menu.render)
