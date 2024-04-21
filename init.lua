levels = {
    [0] = {gems_needed = 1000, gem_points_regular = 0, gem_points_bonus = 0, x_start_loc= 0, y_start_loc=0 , z_start_loc = 0},
	[1] = {gems_needed = 10, gem_points_regular = 20, gem_points_bonus = 50, x_start_loc= 10, y_start_loc=17 , z_start_loc = 10},
    [2] = {gems_needed = 24, gem_points_regular = 15, gem_points_bonus = 0, x_start_loc= 10, y_start_loc=17 , z_start_loc = 10},
    -- Add more levels as needed
}
high_score= 0
level_start_pos = vector.new(0, 0, 0)
-- Function to get level information based on the provided level number
function getLevelInfo(level)
    return levels[level]
end

function initializeVariables()
currentLevel = 0
levelGemsCollected = 0
score = 0
levelInfo = getLevelInfo(currentLevel)
currentGemValue = levelInfo.gem_points_regular
end


initializeVariables()


--https://www.youtube.com/watch?v=bpzN0fagzi8&t=42s
--levels
--"defaultx:mese_post_lightx" > "hero_minesx:working_mese_post_lightx"
script_tables = {
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

function teleportPlayer(player, pos)
    --local pos = player:get_pos() -- Get the player's current position
    pos.x = pos.x + levelInfo.x_start_loc  
    pos.y = pos.y + levelInfo.y_start_loc  
    pos.z = pos.z + levelInfo.z_start_loc
    player:set_pos(pos) -- Teleport the player to the new position
end

--dofile(minetest.get_modpath("boulder_dig").."/portal_nodes.lua")
dofile(minetest.get_modpath("boulder_dig").."/nodes.lua")
dofile(minetest.get_modpath("boulder_dig").."/chat_commands.lua")
dofile(minetest.get_modpath("boulder_dig").."/levels.lua")


minetest.register_on_dieplayer(function(player)
    -- Code to run when a player dies
if score > high_score then 
	high_score = score
end
initializeVariables()
end)



minetest.log("action", "Boulder Dig Mod loaded!")