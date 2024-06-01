-- Register the butterfly node
minetest.register_node("boulder_dig:butterfly", {
    description = "Butterfly",
    drawtype = "plantlike",
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
			butterfly_died(pos)
		end
		
        -- Check and move
        if minetest.get_node(left_pos).name == air_node then
            direction = (direction - 1) % 4
            minetest.set_node(pos, {name = air_node})
            minetest.set_node(left_pos, {name = "boulder_dig:butterfly"})
            minetest.get_meta(left_pos):set_int("direction", direction)
        elseif minetest.get_node(forward_pos).name == air_node then
            minetest.set_node(pos, {name = air_node})
            minetest.set_node(forward_pos, {name = "boulder_dig:butterfly"})
            minetest.get_meta(forward_pos):set_int("direction", direction)
        elseif minetest.get_node(right_pos).name == air_node then
            direction = (direction + 1) % 4
            minetest.set_node(pos, {name = air_node})
            minetest.set_node(right_pos, {name = "boulder_dig:butterfly"})
            minetest.get_meta(right_pos):set_int("direction", direction)
        elseif minetest.get_node(back_pos).name == air_node then
            direction = (direction + 2) % 4
            minetest.set_node(pos, {name = air_node})
            minetest.set_node(back_pos, {name = "boulder_dig:butterfly"})
            minetest.get_meta(back_pos):set_int("direction", direction)
        else
            minetest.get_node_timer(pos):start(0.4)
        end

        return false
    end,
})

-- Register the butterfly egg for creative mode
minetest.register_craftitem("boulder_dig:butterfly_egg", {
    description = "Butterfly Egg",
    inventory_image = "butterfly_egg.png",
    on_place = function(itemstack, placer, pointed_thing)
        if pointed_thing.type ~= "node" then
            return itemstack
        end
        local pos = pointed_thing.above
        minetest.set_node(pos, {name = "boulder_dig:butterfly"})
        minetest.get_meta(pos):set_int("direction", math.random(0, 3))
        itemstack:take_item()
        return itemstack
    end,
})
local function butterflyTouchAction(player)
    player:set_hp(player:get_hp() - 1, "butterfly")
end
registerNodeTouchAction("boulder_dig:butterfly", butterflyTouchAction)


function butterfly_died(pos)
	local sound = "tnt_explode"
	minetest.sound_play(sound, {pos = pos, gain = .5,
			max_hear_distance = 30}, true)
	replace_nodes_with_air_and_gemstone(pos)
end

-- Function to replace nodes in a 3x3x3 cube with air, except for the center of each face
function replace_nodes_with_air_and_gemstone(pos)
    -- Define the relative positions for the center of each face of the cube
    local face_centers = {
        {x = 0, y = 1, z = 0},  -- top face center
        {x = 0, y = -1, z = 0}, -- bottom face center
        {x = 1, y = 0, z = 0},  -- right face center
        {x = -1, y = 0, z = 0}, -- left face center
        {x = 0, y = 0, z = 1},  -- front face center
        {x = 0, y = 0, z = -1}, -- back face center
    }

    -- Loop through the 3x3x3 cube surrounding the given position
    for x = -1, 1, 1 do
        for y = -1, 1, 1 do
            for z = -1, 1, 1 do
                -- Calculate the current position in the cube
                local current_pos = {x = pos.x + x, y = pos.y + y, z = pos.z + z}
                
                -- Get the current node at this position
                local current_node = minetest.get_node(current_pos)
                
                -- Skip replacement if the current node is "xpanes:bar_flat"
                if current_node.name == "xpanes:bar_flat" or current_node.name == "default:steelblock" then
                    goto continue
                end
                
                -- By default, set the node to air
                local node_name = "air"
                
                -- Check if the current position is one of the face centers
                for _, face_center in ipairs(face_centers) do
                    if x == face_center.x and y == face_center.y and z == face_center.z then
                        node_name = "boulder_dig:gemstone"
                        break
                    end
                end

                -- Set the node at the current position
                minetest.set_node(current_pos, {name = node_name})
                
                ::continue::
            end
        end
    end
end




