--manual changes: 
--give yourself a torch & wield it.

local score = 0

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
		minetest.sound_play("diamond_found", {pos = pos, gain = 0.5, max_hear_distance = 10})
		score = score + 10
		minetest.log("x", "score:"..score)
	end
end

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