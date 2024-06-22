-- Register the firefly node
minetest.register_node("boulder_dig:firefly", {
    description = "Firefly",
    drawtype = "normal",
    tiles = {"default_coral_orange.png"},
    inventory_image = "default_coral_orange.png",
    wield_image = "default_coral_orange.png",
    paramtype = "light",
    sunlight_propagates = true,
    walkable = true,
    groups = {flammable = 2},
    on_construct = function(pos)
        minetest.get_node_timer(pos):start(0.4)
    end,
    on_timer = function(pos, elapsed)
        local direction = minetest.get_meta(pos):get_int("direction") or 0
        local air_node = "air"

        -- Define relative positions based on direction
        local left_pos = {x = pos.x, y = pos.y, z = pos.z}
        local forward_pos = {x = pos.x, y = pos.y, z = pos.z}
        local right_pos = {x = pos.x, y = pos.y, z = pos.z}
        local back_pos = {x = pos.x, y = pos.y, z = pos.z}

        if direction == 0 then  -- north
            left_pos.x = left_pos.x - 1
            forward_pos.z = forward_pos.z - 1
            right_pos.x = right_pos.x + 1
            back_pos.z = back_pos.z + 1
        elseif direction == 1 then  -- east
            left_pos.z = left_pos.z - 1
            forward_pos.x = forward_pos.x + 1
            right_pos.z = right_pos.z + 1
            back_pos.x = back_pos.x - 1
        elseif direction == 2 then  -- south
            left_pos.x = left_pos.x + 1
            forward_pos.z = forward_pos.z + 1
            right_pos.x = right_pos.x - 1
            back_pos.z = back_pos.z - 1
        elseif direction == 3 then  -- west
            left_pos.z = left_pos.z + 1
            forward_pos.x = forward_pos.x - 1
            right_pos.z = right_pos.z - 1
            back_pos.x = back_pos.x + 1
        end

		local amoeba = "boulder_dig:amoeba"
		if minetest.get_node(left_pos).name == amoeba or minetest.get_node(right_pos).name == amoeba or minetest.get_node(forward_pos).name == amoeba or minetest.get_node(back_pos).name == amoeba then
			firefly_died(pos)
		end
		
        -- Check and move   Priority: Left>forward>right> backwards
        if minetest.get_node(left_pos).name == air_node then
            direction = (direction - 1) % 4
            minetest.set_node(pos, {name = air_node})
            minetest.set_node(left_pos, {name = "boulder_dig:firefly"})
            minetest.get_meta(left_pos):set_int("direction", direction)
        elseif minetest.get_node(forward_pos).name == air_node then
            minetest.set_node(pos, {name = air_node})
            minetest.set_node(forward_pos, {name = "boulder_dig:firefly"})
            minetest.get_meta(forward_pos):set_int("direction", direction)
        elseif minetest.get_node(right_pos).name == air_node then
            direction = (direction + 1) % 4
            minetest.set_node(pos, {name = air_node})
            minetest.set_node(right_pos, {name = "boulder_dig:firefly"})
            minetest.get_meta(right_pos):set_int("direction", direction)
        elseif minetest.get_node(back_pos).name == air_node then
            direction = (direction + 2) % 4
            minetest.set_node(pos, {name = air_node})
            minetest.set_node(back_pos, {name = "boulder_dig:firefly"})
            minetest.get_meta(back_pos):set_int("direction", direction)
        else
            minetest.get_node_timer(pos):start(0.4)
        end

        return false
    end,
})


-- Register the firefly node
minetest.register_node("boulder_dig:firefly_right", {
    description = "Firefly Right",
    drawtype = "normal",
    tiles = {"default_coral_orange.png^[colorize:yellow:128"},
    inventory_image = "default_coral_orange.png^[colorize:yellow:128",
    wield_image = "default_coral_orange.png^[colorize:yellow:128",
    paramtype = "light",
    sunlight_propagates = true,
    walkable = true,
    groups = {flammable = 2},
    on_construct = function(pos)
        minetest.get_node_timer(pos):start(0.4)
    end,
    on_timer = function(pos, elapsed)
        local direction = minetest.get_meta(pos):get_int("direction") or 0
        local air_node = "air"

        -- Define relative positions based on direction
        local left_pos = {x = pos.x, y = pos.y, z = pos.z}
        local forward_pos = {x = pos.x, y = pos.y, z = pos.z}
        local right_pos = {x = pos.x, y = pos.y, z = pos.z}
        local back_pos = {x = pos.x, y = pos.y, z = pos.z}

        if direction == 0 then  -- north
            left_pos.x = left_pos.x - 1
            forward_pos.z = forward_pos.z - 1
            right_pos.x = right_pos.x + 1
            back_pos.z = back_pos.z + 1
        elseif direction == 1 then  -- east
            left_pos.z = left_pos.z - 1
            forward_pos.x = forward_pos.x + 1
            right_pos.z = right_pos.z + 1
            back_pos.x = back_pos.x - 1
        elseif direction == 2 then  -- south
            left_pos.x = left_pos.x + 1
            forward_pos.z = forward_pos.z + 1
            right_pos.x = right_pos.x - 1
            back_pos.z = back_pos.z - 1
        elseif direction == 3 then  -- west
            left_pos.z = left_pos.z + 1
            forward_pos.x = forward_pos.x - 1
            right_pos.z = right_pos.z - 1
            back_pos.x = back_pos.x + 1
        end

		local amoeba = "boulder_dig:amoeba"
		if minetest.get_node(left_pos).name == amoeba or minetest.get_node(right_pos).name == amoeba or minetest.get_node(forward_pos).name == amoeba or minetest.get_node(back_pos).name == amoeba then
			firefly_died(pos)
		end
		
-- Check and move  Priority Right > forward > Left > reverse direction
        if minetest.get_node(right_pos).name == air_node then
            direction = (direction + 1) % 4
            minetest.set_node(pos, {name = air_node})
            minetest.set_node(right_pos, {name = "boulder_dig:firefly_right"})
            minetest.get_meta(right_pos):set_int("direction", direction)
        elseif minetest.get_node(forward_pos).name == air_node then
            minetest.set_node(pos, {name = air_node})
            minetest.set_node(forward_pos, {name = "boulder_dig:firefly_right"})
            minetest.get_meta(forward_pos):set_int("direction", direction)
        elseif minetest.get_node(left_pos).name == air_node then
            direction = (direction - 1) % 4
            minetest.set_node(pos, {name = air_node})
            minetest.set_node(left_pos, {name = "boulder_dig:firefly_right"})
            minetest.get_meta(left_pos):set_int("direction", direction)
        elseif minetest.get_node(back_pos).name == air_node then
            direction = (direction + 2) % 4
            minetest.set_node(pos, {name = air_node})
            minetest.set_node(back_pos, {name = "boulder_dig:firefly_right"})
            minetest.get_meta(back_pos):set_int("direction", direction)
        else
            minetest.get_node_timer(pos):start(0.4)
        end

        return false
    end,
})


-- Register the firefly egg for creative mode
minetest.register_craftitem("boulder_dig:firefly_egg", {
    description = "firefly Egg",
    inventory_image = "firefly_egg.png",
    on_place = function(itemstack, placer, pointed_thing)
        if pointed_thing.type ~= "node" then
            return itemstack
        end
        local pos = pointed_thing.above
        minetest.set_node(pos, {name = "boulder_dig:firefly"})
        minetest.get_meta(pos):set_int("direction", math.random(0, 3))
        itemstack:take_item()
        return itemstack
    end,
})
local function fireflyTouchAction(player)
    player:set_hp(player:get_hp() - 1, "firefly")
end
registerNodeTouchAction("boulder_dig:firefly", fireflyTouchAction)


function firefly_died(pos)
	local sound = "tnt_explode"
	minetest.sound_play(sound, {pos = pos, gain = .5,
			max_hear_distance = 30}, true)
	replace_nodes_with_air(pos)
end

-- Function to replace nodes in a 3x3x3 cube with air
function replace_nodes_with_air(pos)
    -- Loop through the 3x3x3 cube surrounding the given position
    for x = -1, 1 do
        for y = -1, 1 do
            for z = -1, 1 do
                -- Calculate the current position in the cube
                local current_pos = {x = pos.x + x, y = pos.y + y, z = pos.z + z}
                
                -- Get the current node at this position
                local current_node = minetest.get_node(current_pos)
                
                -- Skip replacement if the current node is "xpanes:bar_flat" or "default:steelblock"
                if current_node.name ~= "xpanes:bar_flat" and current_node.name ~= "default:steelblock" then
                    -- Set the node at the current position to air
                    minetest.set_node(current_pos, {name = "air"})
                end
            end
        end
    end
end





