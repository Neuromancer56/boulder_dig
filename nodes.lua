--manual changes: 
--give yourself a torch & wield it.

if minetest.get_modpath("animalworld") then
	local bat_def = minetest.registered_entities["animalworld:bat"]
	assert(bat_def, "animalworld:bat not found")
	-- Override some properties of the bat entity
			bat_def.passive = false
			bat_def.type = "monster"
			bat_def.runaway = false
			bat_def.runaway_from = nil
end



local function add_fall_damage(node, damage)

	if minetest.registered_nodes[node] then

		local group = minetest.registered_nodes[node].groups

		group.falling_node_damage = damage

		minetest.override_item(node, {groups = group})
	else
		print (node .. " not found to add falling_node_damage to")
	end
end





function default.node_sound_gem_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "default_hard_footstep", gain = 0.25}
	table.dig = table.dig or
			{name = "default_dig_cracky", gain = 0.35}
	table.dug = table.dug or
			{name = "default_hard_footstep", gain = 1.0}
	table.place = table.place or
			{name = "sound_effect_twinkle_sparkle", gain = 1.0}
	default.node_sound_defaults(table)
	return table
end


minetest.register_node("boulder_dig:gemstone", {
	description = ("Gemtstone"),
	--tiles = {"default_stone.png^default_mineral_diamond.png"},
	tiles = {"amethyst_star.png"},
	groups = {cracky = 2, falling_node = 1, falling_node_hurt =1},
	drop = "boulder_dig:gemstone",
	sounds = default.node_sound_gem_defaults(),
	on_construct = function(pos, node)
		check_for_tumbling(pos,"boulder_dig:gemstone",{"boulder_dig:gemstone","boulders:boulder"},"sound_effect_twinkle_sparkle")
		end,
	light_source = 5, 
	use_texture_alpha = true,
	drawtype = "glasslike",
	--sunlight_propagates = true,
})



local function enableExitNode()
	local script_table = exit_script_table[currentLevel]
	--minetest.log("x", "level_start_pos")
	--logTable(level_start_pos)
	run_script(level_start_pos, script_table)
end

local function gemstoneTouchAction(player)
	local pos = player:get_pos()
	--minetest.swap_node(pos, {name = "hero_mines:broken_mese_post_light", param2 = node.param2})
	local got_gem = false
	
	local x_offset, z_offset= get_direction_offsets(player)
	--minetest.log("x","x_start:"..x_start..", x_end:"..x_end)	
	--minetest.log("x","z_start:"..z_start..", z_end:"..z_end)	
	for dx = x_offset, x_offset do
		--minetest.log("x","dx:"..dx)	
		for dy = 0, 1 do
			for dz = z_offset, z_offset do
				--minetest.log("x","dz:"..dz)	
				local neighbor_pos = {x = pos.x + dx, y = pos.y + dy, z = pos.z + dz}
				local node = minetest.get_node(neighbor_pos)
				
				if (node.name == "boulder_dig:gemstone" )then
					minetest.set_node(neighbor_pos, {name = "air", param2 = node.param2})
					minetest.check_for_falling(neighbor_pos)
					got_gem = true	
				end
			end
		end
	end
	
	if got_gem then
		levelGemsCollected = levelGemsCollected + 1
		if (levelGemsCollected == levelInfo.gems_needed ) then
			minetest.sound_play("sonic-wave-75405x", {pos = pos, gain = 0.5, max_hear_distance = 10})
			enableExitNode()
		end
		minetest.sound_play("diamond_found", {pos = pos, gain = 0.5, max_hear_distance = 10})		
		if (levelGemsCollected >levelInfo.gems_needed ) then
			currentGemValue = levelInfo.gem_points_bonus
		else 
			currentGemValue = levelInfo.gem_points_regular
		end
		
		
		score = score + currentGemValue
		if (score > high_score) then
			high_score= score
		end
		minetest.log("x", "Lvl:"..currentLevel.." Gem:"..levelGemsCollected.."of"..levelInfo.gems_needed.." Val:"..currentGemValue .." S:"..score.." HS:"..high_score)
	end
end

minetest.register_node("boulder_dig:magic_wall", {
    description = "Magic Wall",
    tiles = {"default_diamond_block.png"},
    is_ground_content = false,
    walkable = true, -- Make the wall non-walkable so nodes can fall through
    pointable = true,
    diggable = true,
    buildable_to = false,
    sunlight_propagates = true,
    paramtype = "light",
    groups = {cracky = 3, stone = 1, not_in_creative_inventory = 1}, -- Added not_in_creative_inventory to avoid cluttering the inventory
    sounds = default.node_sound_stone_defaults(),
})


-- Function to handle conversion when a node falls through the magic wall
local function convert_node(pos, node)
    local below_pos = {x = pos.x, y = pos.y - 1, z = pos.z}
    local below_node = minetest.get_node(below_pos)
	minetest.log("x","below_node"..below_node.name)
    if below_node.name == "boulder_dig:magic_wall" then
        local new_node_name

        if node.name == "boulders:boulder" then
            new_node_name = "boulder_dig:gemstone"
        elseif node.name == "boulder_dig:gemstone" then
            new_node_name = "boulders:boulder"
        else
            return
        end

        minetest.set_node(pos, {name = "air"})
        local target_pos = {x = pos.x, y = pos.y - 2, z = pos.z}
        minetest.set_node(target_pos, {name = new_node_name})
		minetest.check_for_falling(target_pos)
    end
end


-- Override the on_falling callback for boulder and gemstone to also do convert_node
minetest.override_item("boulders:boulder", {
		on_construct = function(pos, node)
			convert_node(pos, minetest.get_node(pos))
			check_for_tumbling(pos,"boulders:boulder",{"boulder_dig:gemstone","boulders:boulder"},"falling_boulder")
		end,
})

minetest.override_item("boulder_dig:gemstone", {
	on_construct = function(pos, node)
		convert_node(pos, minetest.get_node(pos))
		check_for_tumbling(pos,"boulder_dig:gemstone",{"boulder_dig:gemstone","boulders:boulder"},"sound_effect_twinkle_sparkle")
	end,
})


registerNodeTouchAction("boulder_dig:gemstone", gemstoneTouchAction)
add_fall_damage("boulder_dig:gemstone", 4)

dirt = {"default:dirt","default:dry_dirt"}
minetest.register_ore({
    ore_type = "scatter",
    ore = "boulder_dig:gemstone",
    wherein = dirt,
	--7>11>9
    --clust_scarcity = 7 * 7 * 7,
	clust_scarcity = 9 * 9 * 9,
    clust_num_ores = 8,
    clust_size = 4,
    height_min = -31000,
    height_max = 1000,
})


local portal_animationRed = {
	name = "nether_portal_alt.png^[colorize:red:120",
	animation = {
		type = "vertical_frames",
		aspect_w = 16,
		aspect_h = 16,
		length = 0.5,
	},
}

local portal_animationGreen = {
	name = "nether_portal_alt.png^[colorize:green:120",
	animation = {
		type = "vertical_frames",
		aspect_w = 16,
		aspect_h = 16,
		length = 0.5,
	},
}



------------
function create_and_enter_level(level, pos, player)
	minetest.sound_play("teleport", {pos = pos, gain = 0.5, max_hear_distance = 10})
	currentLevel = level
	levelGemsCollected  = 0
	if(currentLevel>#levels) then
		minetest.log("x","Congratulations!  All levels successfully completed.")
		currentLevel = 1
		level = 1
	end
	levelInfo = getLevelInfo(currentLevel)
	currentGemValue = levelInfo.gem_points_regular
	local script_table = script_tables[level]
	run_script(pos, script_table)
	teleportPlayer(player, pos)
end

local function exitTouchAction(player)
	if (levelGemsCollected < levelInfo.gems_needed ) then
		minetest.sound_play("teleport-error", {pos = pos, gain = 0.5, max_hear_distance = 10})
	else
		minetest.sound_play("teleport", {pos = pos, gain = 0.5, max_hear_distance = 10})
		currentLevel = currentLevel +1
		create_and_enter_level(currentLevel, level_start_pos, player)
	end
end



-- Register the node
minetest.register_node("boulder_dig:exit_dormant", {
    description = "Dormant Exit",
   -- tiles = {"nether_portal.png"}, -- Path to first frame
   	tiles = {
		portal_animationRed
	},
	post_effect_color = {
		-- hopefully blue enough to work with blue portals, and green enough to
		-- work with cyan portals.
		a = 120, r = 188,  g = 0, b = 0
	},
   -- groups = {cracky = 3, oddly_breakable_by_hand = 3},
    paramtype = "light",
    light_source = 5,
})


-- Register the node
minetest.register_node("boulder_dig:exit", {
    description = "Exit",
   -- tiles = {"nether_portal.png"}, -- Path to first frame
   	tiles = {
		portal_animationGreen
	},
	post_effect_color = {
		-- hopefully blue enough to work with blue portals, and green enough to
		-- work with cyan portals.
		a = 120, r = 0, g = 128, b = 188
	},
   -- groups = {cracky = 3, oddly_breakable_by_hand = 3},
    paramtype = "light",
    light_source = 5,
})

--[[
-- Function to update node texture
local function update_texture(pos)
    local meta = minetest.get_meta(pos)
    local frame = tonumber(meta:get_string("frame")) or 1
    local num_frames = 10 -- Total number of frames
    frame = (frame % num_frames) + 1
    meta:set_string("frame", tostring(frame))
    minetest.get_node_timer(pos):start(0.5) -- Adjust time interval as needed
    minetest.swap_node(pos, {name = "boulder_dig:exit", param2 = frame})
end

-- Register globalstep to update texture
minetest.register_globalstep(function(dtime)
    for _, player in ipairs(minetest.get_connected_players()) do
        local pos = player:get_pos()
        if pos then
            local node_pos = {x = math.floor(pos.x), y = math.floor(pos.y), z = math.floor(pos.z)}
            local node = minetest.get_node(node_pos)
            if node.name == "boulder_dig:exit" then
                update_texture(node_pos)
            end
        end
    end
end)
]]
registerNodeTouchAction("boulder_dig:exit", exitTouchAction)
registerNodeTouchAction("boulder_dig:exit_dormant", exitTouchAction)







