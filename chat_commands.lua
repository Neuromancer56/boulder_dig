
local function level(name, param)
local player = minetest.get_player_by_name(name)
        if player then
            local level_number = tonumber(param) -- Convert the parameter to a number

            -- Check if the parameter is a valid number
            if level_number and level_number >= 1 and level_number <= 20 then
                local item_name = "boulder_dig:level_"..level_number

                -- Clear the inventory
                local inventory = player:get_inventory()

                -- Give the specified level item block
                inventory:add_item("main", item_name)
                
                --minetest.chat_send_player(name, "Your inventory has been given the block to create hero mine level "..level_number..".")
            else
                minetest.chat_send_player(name, "Invalid level number. Please specify a level between 1 and 20.")
            end
        else
            minetest.chat_send_player(name, "Player not found.")
        end
end
--[[
local function clear_inv(name, param)
        local player = minetest.get_player_by_name(name)
        if player then
            -- Clear the inventory
            local inventory = player:get_inventory()
            --inventory:set_list("main", {})

            -- Give basic items blocks
			inventory:add_item("main", "default:torch 99")
            inventory:add_item("main", "default:sword_diamond")
			
            minetest.chat_send_player(name, "Your inventory has had the essential items added to it.")
        else
            minetest.chat_send_player(name, "Player not found.")
        end
end]]

local function prep_inv(name, param)
    local player = minetest.get_player_by_name(name)
    if player then
        local inventory = player:get_inventory()
        --inventory:set_list("main", {}) -- Uncomment if you want to clear the entire inventory

        -- Check if the player already has a diamond sword
        local has_diamond_sword = false
        local main_list = inventory:get_list("main")
        for _, item in ipairs(main_list) do
            if item:get_name() == "default:sword_diamond" then
                has_diamond_sword = true
                break
            end
        end
        -- If the player doesn't have a diamond sword, add one
        if not has_diamond_sword then
            inventory:add_item("main", "default:sword_diamond")
        end

        -- Check for existing torch stack
        local torch_index
        for index, item in ipairs(main_list) do
            if item:get_name() == "default:torch"  then
                torch_index = index
                break
            end
        end
        -- If found, set the count to 99, else add a new stack
        if torch_index then
            local stack = inventory:get_stack("main", torch_index)
            stack:set_count(99)
            inventory:set_stack("main", torch_index, stack)
        else
            inventory:add_item("main", "default:torch 99")
        end

        minetest.chat_send_player(name, "Your inventory has had the essential items added to it.")
    else
        minetest.chat_send_player(name, "Player not found.")
    end
end



minetest.register_chatcommand("level", {
    params = "<level_number>",
    description = "Prepares inventory and health for boulder dig level.",
    privs = {interact = true},
    func = function(name, param)
       prep_inv(name, param)
	   level(name, param)
    end,
})

minetest.register_chatcommand("give_level", {
    params = "<level_number>",
    description = "Gives you a script block to create a boulder dig area for the specified level.",
    privs = {interact = true},
    func = function(name, param)
	   level(name, param)
    end,
})

minetest.register_chatcommand("prep_inv", {
    params = "",
    description = "Clears inventory and replaces it with the only items you should use at start of hero mine level",
    privs = {interact = true},
    func = function(name, param)
       prep_inv(name, param)
    end,
})
