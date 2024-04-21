
local function teleportPlayer(player, pos)
    --local pos = player:get_pos() -- Get the player's current position
    pos.x = pos.x + levelInfo.x_start_loc  
    pos.y = pos.y + levelInfo.y_start_loc  
    pos.z = pos.z + levelInfo.z_start_loc
    player:set_pos(pos) -- Teleport the player to the new position
end


--https://www.youtube.com/watch?v=bpzN0fagzi8&t=42s
--levels
--"defaultx:mese_post_lightx" > "hero_minesx:working_mese_post_lightx"
local script_tables = {
	--level 2
	{
		{"build_level", 38, 20, 21, .1, .05,7,.7,7,.7,7,.7},
		{"move", "x", 10},
		{"move", "y", 17},
		{"move", "z", 10},
		{"fill_box", 2, 2, 2, "X", "air", "default:torch", "T", 1},
	},
	--level 3
	{
		{"build_level", 38, 21, 21, .18, .09,2,.07,2,.07,2,.07},
		{"move", "x", 10},
		{"move", "y", 17},
		{"move", "z", 10},
		{"fill_box", 2, 2, 2, "X", "air", "default:torch", "T", 1},
	}
}

--https://www.youtube.com/watch?v=bpzN0fagzi8&t=42s
--levels

for level = 1, #script_tables do
    minetest.register_node("boulder_dig:level_" .. level, {
        description = "Script Runner Level " .. level,
        tiles = {"script_runner.png"},
        groups = {cracky = 3, oddly_breakable_by_hand = 1},
        on_punch = function(pos, node, puncher)
			currentLevel = level
			levelGemsCollected  = 0
			levelInfo = getLevelInfo(currentLevel)
			currentGemValue = levelInfo.gem_points_regular
            local script_table = script_tables[level]
            run_script(pos, script_table)
			teleportPlayer(puncher, pos)
        end,
    })
end




--[[
local levelNumber = 1
local levelInfo = getLevelInfo(levelNumber)
if levelInfo then
    print("Level:", levelNumber)
    print("Gems Needed:", levelInfo.gems_needed)
    print("Regular Gem Points:", levelInfo.gem_points_regular)
    print("Bonus Gem Points:", levelInfo.gem_points_bonus)
else
    print("Level information not found for level:", levelNumber)
end
]]