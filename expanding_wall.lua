-- Register expanding wall nodes

minetest.register_node("boulder_dig:z_expanding_wall", {
    description = "Horizontal Expanding Wall",
    tiles = {"default_stone.png^[colorize:blue:64"},
    groups = {cracky = 3},
    on_construct = function(pos)
        minetest.after(1, check_for_expand, pos)
    end,
})

minetest.register_node("boulder_dig:x_expanding_wall", {
    description = "Vertical Expanding Wall",
    tiles = {"default_stone.png^[colorize:green:64"},
    groups = {cracky = 3},
    on_construct = function(pos)
        minetest.after(1, check_for_expand, pos)
    end,
})

minetest.register_node("boulder_dig:expanding_wall", {
    description = "Generic Expanding Wall",
    tiles = {"default_stone.png^[colorize:red:128"},
    groups = {cracky = 3},
    on_construct = function(pos)
        minetest.after(1, check_for_expand, pos)
    end,
})

-- Function to check for expansion

function check_for_expand(pos)
    local node = minetest.get_node(pos)
    local node_name = node.name

    -- Get player position to limit expansion range
    local players = minetest.get_connected_players()
    local player_pos = players[1]:get_pos()

    -- Define expansion directions based on node type
    local directions = {}
    if node_name == "boulder_dig:z_expanding_wall" then
        directions = {{x=0, y=1, z=0}, {x=0, y=-1, z=0}, {x=0, y=0, z=1}, {x=0, y=0, z=-1}}
    elseif node_name == "boulder_dig:x_expanding_wall" then
        directions = {{x=1, y=0, z=0}, {x=-1, y=0, z=0}, {x=0, y=1, z=0}, {x=0, y=-1, z=0}}
    elseif node_name == "boulder_dig:expanding_wall" then
        directions = {{x=1, y=0, z=0}, {x=-1, y=0, z=0}, {x=0, y=1, z=0}, {x=0, y=-1, z=0}, {x=0, y=0, z=1}, {x=0, y=0, z=-1}}
    end

    -- Expand in each direction
    for _, dir in ipairs(directions) do
        local new_pos = vector.add(pos, dir)
        -- Check if new position is air and within range
        if minetest.get_node(new_pos).name == "air" then
            -- Prevent expansion into player's current position and 1 above/below
            if not (
                (new_pos.x == math.floor(player_pos.x + 0.5) and new_pos.y == math.floor(player_pos.y + 0.5) and new_pos.z == math.floor(player_pos.z + 0.5)) or
                (new_pos.x == math.floor(player_pos.x + 0.5) and new_pos.y == math.floor(player_pos.y + 1.5) and new_pos.z == math.floor(player_pos.z + 0.5)) or
                (new_pos.x == math.floor(player_pos.x + 0.5) and new_pos.y == math.floor(player_pos.y - 0.5) and new_pos.z == math.floor(player_pos.z + 0.5)) or
				(new_pos.x == math.floor(player_pos.x - 0.5) and new_pos.y == math.floor(player_pos.y + 0.5) and new_pos.z == math.floor(player_pos.z + 0.5)) or
                (new_pos.x == math.floor(player_pos.x - 0.5) and new_pos.y == math.floor(player_pos.y + 1.5) and new_pos.z == math.floor(player_pos.z + 0.5)) or
                (new_pos.x == math.floor(player_pos.x - 0.5) and new_pos.y == math.floor(player_pos.y - 0.5) and new_pos.z == math.floor(player_pos.z + 0.5)) or
				(new_pos.x == math.floor(player_pos.x - 0.5) and new_pos.y == math.floor(player_pos.y + 0.5) and new_pos.z == math.floor(player_pos.z - 0.5)) or
                (new_pos.x == math.floor(player_pos.x - 0.5) and new_pos.y == math.floor(player_pos.y + 1.5) and new_pos.z == math.floor(player_pos.z - 0.5)) or
                (new_pos.x == math.floor(player_pos.x - 0.5) and new_pos.y == math.floor(player_pos.y - 0.5) and new_pos.z == math.floor(player_pos.z - 0.5)) or
				(new_pos.x == math.floor(player_pos.x + 0.5) and new_pos.y == math.floor(player_pos.y + 0.5) and new_pos.z == math.floor(player_pos.z - 0.5)) or
                (new_pos.x == math.floor(player_pos.x + 0.5) and new_pos.y == math.floor(player_pos.y + 1.5) and new_pos.z == math.floor(player_pos.z - 0.5)) or
                (new_pos.x == math.floor(player_pos.x + 0.5) and new_pos.y == math.floor(player_pos.y - 0.5) and new_pos.z == math.floor(player_pos.z - 0.5)) 
				) then
                if vector.distance(player_pos, new_pos) <= 20 then
                    minetest.set_node(new_pos, {name = node_name})
                    minetest.after(1, check_for_expand, new_pos)
                end
            end
        end
    end
end

-- Optionally, you can add ABM (Active Block Modifier) to periodically check for expansion
minetest.register_abm({
    label = "Expand Walls",
    nodenames = {"boulder_dig:z_expanding_wall", "boulder_dig:x_expanding_wall", "boulder_dig:expanding_wall"},
    interval = 1.0,
    chance = 1,
    action = function(pos)
        check_for_expand(pos)
    end,
})
