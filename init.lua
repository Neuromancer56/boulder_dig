levels = {
    [0] = {gems_needed = 1000, gem_points_regular = 0, gem_points_bonus = 0, x_start_loc= 0, y_start_loc=0 , z_start_loc = 0},
	[1] = {gems_needed = 10, gem_points_regular = 20, gem_points_bonus = 50, x_start_loc= 10, y_start_loc=17 , z_start_loc = 10},
    [2] = {gems_needed = 24, gem_points_regular = 15, gem_points_bonus = 0, x_start_loc= 10, y_start_loc=17 , z_start_loc = 10},
    -- Add more levels as needed
}
high_score= 0
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