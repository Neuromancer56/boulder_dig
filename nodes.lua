--manual changes: 
--give yourself a torch & wield it.

local score = 0



minetest.register_node("boulder_dig:gemstone", {
	description = ("Gemtstone"),
	--tiles = {"default_stone.png^default_mineral_diamond.png"},
	tiles = {"amethyst_star.png"},
	groups = {cracky = 1},
	drop = "boulder_dig:gemstone",
	sounds = default.node_sound_stone_defaults(),
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
		minetest.sound_play("default_break_glass", {pos = pos, gain = 0.5, max_hear_distance = 10})
		score = score + 10
		minetest.log("x", "score:"..score)
	end
end

registerNodeTouchAction("boulder_dig:gemstone", gemstoneTouchAction)

dirt = {"default:dirt","default:dry_dirt"}
minetest.register_ore({
    ore_type = "scatter",
    ore = "boulder_dig:gemstone",
    wherein = dirt,
    --clust_scarcity = 7 * 7 * 7,
	clust_scarcity = 10 * 10 * 10,
    clust_num_ores = 2,
    clust_size = 3,
    height_min = -31000,
    height_max = 1000,
})