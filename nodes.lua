--manual changes: 
--E:\games\minetest-5.8.0-win64\games\minetest_game\mods\default\mapgen.lua L:7  minetest.register_alias("mapgen_stone", "default:stone") > minetest.register_alias("mapgen_stone", "default:dirt")
--E:\games\minetest-5.8.0-win64\mods\falling_item\init.lua  local L:3 function add_fall_damage(node, damage) > function add_fall_damage(node, damage)
--enable wielded light & give yourself a torch.
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



function default.node_sound_boulder_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "default_hard_footstep", gain = 0.25}
	table.dig = table.dig or
			{name = "default_dig_cracky", gain = 0.35}
	table.dug = table.dug or
			{name = "default_hard_footstep", gain = 1.0}
	table.place = table.place or
			{name = "default_dug_node", gain = 1.0}
			--{name = "default_place_node", gain = 1.0}
	default.node_sound_defaults(table)
	return table
end


minetest.register_node("boulder_dig:boulder", {
	description = "Boulder",
	tiles = {"default_gravel.png"},
	groups = {cracky = 2, falling_node = 1, falling_node_hurt =1},
	sounds = default.node_sound_boulder_defaults(),
	--sounds = default.node_sound_gravel_defaults(),
	drop = {
		max_items = 1,
		items = {
			{items = {"default:gravel"}}
		}
	}
})

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
				
				if node.name == "default:dirt" then
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

-- Register global step action for magma nodes
registerNodeTouchAction("default:dirt", dirtTouchAction)
add_fall_damage("boulder_dig:boulder", 3)

minetest.register_ore({
    ore_type = "scatter",
    ore = "boulder_dig:boulder",
    wherein = "default:dirt",
    clust_scarcity = 4 * 4 * 4,
    clust_num_ores = 8,
    clust_size = 3,
    height_min = 1,
    height_max = 31,
})
