--manual changes: 
--E:\games\minetest-5.8.0-win64\games\minetest_game\mods\default\mapgen.lua L:7  minetest.register_alias("mapgen_stone", "default:stone") > minetest.register_alias("mapgen_stone", "default:dirt")
--give yourself a torch & wield it.
--[[minetest.override_item("default:gravel", {
    groups = {
        floored = 1,
        -- Keep any other existing groups
        crumbly = 2,
        falling_node = 1,
        -- etc.
    }
})]]

--[[minetest.register_biome({
    name = "boulder",
    node_top = "default:dirt",
    depth_top = 1,
    node_filler = "default:dirt",
    depth_filler = 3,
    node_riverbed = "swamp:mud",
    depth_riverbed = 2,
    node_dungeon = "swamp:mud_brick",
    node_dungeon_alt = "swamp:mud_block",
    y_max = 10,
    y_min = -20,
    heat_point = 80,
    humidity_point = 98,
})]]

-- Loop through all registered biomes
for name, def in pairs(minetest.registered_biomes) do
    -- Check if the biome has a depth_filler parameter
--	minetest.log("x","name:"..name.." filler:"..def.depth_filler)
    if def.depth_filler then
        -- Override the depth_filler parameter
        def.depth_filler = 30
        
        -- Unregister and re-register the biome with the new parameter
        minetest.unregister_biome(name)
        minetest.register_biome(def)
    end
end

--minetest.register_alias("mapgen_stone", "default:dirt")
local score = 0



minetest.register_node("boulder_dig:gemstone", {
	description = ("Gemtstone"),
	tiles = {"default_stone.png^default_mineral_diamond.png"},
	groups = {cracky = 1},
	drop = "default:diamond",
	sounds = default.node_sound_stone_defaults(),
})


local function gemstoneTouchAction(player)
	local pos = player:get_pos()
	--minetest.swap_node(pos, {name = "hero_mines:broken_mese_post_light", param2 = node.param2})
	local got_gem = false
	for dx = -2, 2 do
		for dy = -2, 2 do
			for dz = -2, 2 do
				local neighbor_pos = {x = pos.x + dx, y = pos.y + dy, z = pos.z + dz}
				local node = minetest.get_node(neighbor_pos)
				
				if node.name == "boulder_dig:gemstone" then
					minetest.swap_node(neighbor_pos, {name = "air", param2 = node.param2})
					got_gem = true
				end
			end
		end
	end
	if got_gem then
		minetest.sound_play("default_break_glass", {pos = pos, gain = 0.5, max_hear_distance = 10})
		score = score + 10
		minetest.log("x", "score:"..score)
	end
end

--default_dug_node.1, default_dig_choppy.3

local function dirtTouchAction(player)
	local pos = player:get_pos()
	--minetest.swap_node(pos, {name = "hero_mines:broken_mese_post_light", param2 = node.param2})
	

local yaw = player:get_look_horizontal()
local yaw_degrees = (yaw + 2 * math.pi) % (2 * math.pi) * 180 / math.pi
--minetest.log("x","yaw_degrees:"..yaw_degrees)	

local x_start = 0
local x_end = 0

local z_start = 0
local z_end = 0

if yaw_degrees >= 225 and yaw_degrees < 315 then
    x_end = 1
	x_start = 1
elseif yaw_degrees >= 45 and yaw_degrees < 135 then
    x_start = -1
	x_end = -1
end

if yaw_degrees >= 315 or yaw_degrees < 45 then
       z_end = 1
	z_start = 1
elseif yaw_degrees >= 135 and yaw_degrees < 225 then
       z_end = -1
	z_start = -1
end

--minetest.log("x","x_start:"..x_start..", x_end:"..x_end)	
--minetest.log("x","z_start:"..z_start..", z_end:"..z_end)	
local dirt_dug = false

	for dx = x_start, x_end do
		--minetest.log("x","dx:"..dx)	
		for dy = 0, 1 do
			for dz = z_start, z_end do
				--minetest.log("x","dz:"..dz)	
				local neighbor_pos = {x = pos.x + dx, y = pos.y + dy, z = pos.z + dz}
				local node = minetest.get_node(neighbor_pos)
				
				if (node.name == "default:dirt" or node.name == "default:dry_dirt" )then
					minetest.set_node(neighbor_pos, {name = "air", param2 = node.param2})
					dirt_dug = true
							
				end
			end
		end
	end
    if dirt_dug then 
		minetest.sound_play("default_dig_crumbly", {pos = pos, gain = 0.5, max_hear_distance = 10}) 
		
	for dx = x_start, x_end do
		--minetest.log("x","dx:"..dx)	
		for dy = 1, 2 do
			for dz = z_start, z_end do
				--minetest.log("x","dz:"..dz)	
				local neighbor_pos = {x = pos.x + dx, y = pos.y + dy, z = pos.z + dz}
				local node = minetest.get_node(neighbor_pos)
				minetest.check_for_falling(neighbor_pos)
			end
		end
	end
	end
		--minetest.log("x","x:"..neighbor_pos.x ..",z:"..neighbor_pos.z)		
	
end

registerNodeTouchAction("default:dirt", dirtTouchAction)
registerNodeTouchAction("default:dry_dirt", dirtTouchAction)
registerNodeTouchAction("boulder_dig:gemstone", gemstoneTouchAction)

dirt = {"default:dirt","default:dry_dirt"}
minetest.register_ore({
    ore_type = "scatter",
    ore = "boulder_dig:gemstone",
    wherein = dirt,
    clust_scarcity = 4 * 4 * 4,
    clust_num_ores = 8,
    clust_size = 3,
    height_min = -31000,
    height_max = 1000,
})