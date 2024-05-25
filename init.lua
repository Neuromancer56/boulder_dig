local function logTable(tableToLog)
    minetest.log("loggedTable", "Logging table contents:")
    
    -- Iterate over each key-value pair in the table
    for key, value in pairs(tableToLog) do
        -- Convert the value to a string for logging
        local valueString = tostring(value)
        
        -- Log the key-value pair
        minetest.log("loggedTable", key .. ": " .. valueString)
    end
    
    minetest.log("loggedTable", "End of table logging.")
end
levels = {
    [0] = {gems_needed = 1000, gem_points_regular = 0, gem_points_bonus = 0, x_start_loc= 0, y_start_loc=0 , z_start_loc = 0},
	[1] = {gems_needed = 3, gem_points_regular = 5, gem_points_bonus = 8, x_start_loc= 5, y_start_loc=6, z_start_loc = 5},
	[2] = {gems_needed = 10, gem_points_regular = 20, gem_points_bonus = 50, x_start_loc= 10, y_start_loc=17 , z_start_loc = 10},
    [3] = {gems_needed = 24, gem_points_regular = 15, gem_points_bonus = 0, x_start_loc= 10, y_start_loc=17 , z_start_loc = 10},
	[4] = {gems_needed = 24, gem_points_regular = 15, gem_points_bonus = 0, x_start_loc= 1, y_start_loc=1 , z_start_loc = 1},
	[5] = {gems_needed = 10, gem_points_regular = 20, gem_points_bonus = 50, x_start_loc= 10, y_start_loc=2 , z_start_loc = 10},
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
	--tutorial
	{
		{"build_level", 16, 9, 9, .05, .05,8,.02,10,.0,10,.0},
		{"place_node",13,2,5,"boulder_dig:exit_dormant", true},
		{"place_node",2,2,5,"boulder_dig:exit_dormant", true},
		{"move", "x", 5},
		{"move", "y", 6},
		{"move", "z", 5},
		{"fill_box", 2, 2, 2, "X", "air", "default:torch", "T", 1},
	},
	--level 2
	{
		{"build_level", 38, 20, 21, .1, .05,7,.6,7,.6,7,.6},
		{"place_node",35,2,10,"boulder_dig:exit_dormant", true},
		{"place_node",2,2,15,"boulder_dig:exit_dormant", true},
		{"move", "x", 10},
		{"move", "y", 17},
		{"move", "z", 10},
		{"fill_box", 2, 2, 2, "X", "air", "default:torch", "T", 1},
	},
	--level 3
	{
		{"build_level", 38, 21, 21, .18, .09,2,.07,2,.07,2,.07},
		{"place_node",35,2,10,"boulder_dig:exit_dormant", true},
		{"place_node",2,2,15,"boulder_dig:exit_dormant", true},
		{"move", "x", 10},
		{"move", "y", 17},
		{"move", "z", 10},
		{"fill_box", 2, 2, 2, "X", "air", "default:torch", "T", 1},
	},
	--amoeba 
	{
		{"build_level", 38, 4, 21, .18, .00,10,.00,10,.00,10,.00},
		{"place_node",35,2,10,"boulder_dig:exit_dormant", true},
		{"place_node",2,2,15,"boulder_dig:exit_dormant", true},
		{"place_node",17,1,2,"boulder_dig:amoeba", true},
		{"move", "x", 2},
		{"move", "y", 2},
		{"move", "z", 2},		
		{"fill_box", 2, 2, 2, "X", "air", "default:torch", "T", 1},		
	},
	--avalanche
	{
		{"build_level", 38, 20, 21, .5, .5,40,.0,40,.0,40,.0},
		{"place_node",35,2,10,"boulder_dig:exit_dormant", true},
		{"place_node",2,2,15,"boulder_dig:exit_dormant", true},
		{"move", "x", 2},
		{"move", "y", 1},
		{"move", "z", 2},
		{"fill_box", 14, 12, 17, "X", "default:cobble", "default:torch", "T", 5, true},
		{"move", "x", 1},
		{"move", "z", 1},		
		{"fill_box", 12, 11, 15, "X", "air", "default:torch", "T", 6,true},
		{"move", "x", 6},
		{"move", "z", 7},			
		{"fill_box", 1, 11, 1, "Y", "dirt", "default:torch", "T", 6,true},
		{"move", "x", 1},
		{"fill_box", 1, 11, 1, "X", "default:ladder", "air","T" , 11,true},
	}
}

exit_script_table = {
	--tutorial
	{
		{"place_node",13,2,5,"boulder_dig:exit", true},
		{"place_node",2,2,5,"boulder_dig:exit", true},
	},
	--level 2
	{
		{"place_node",35,2,10,"boulder_dig:exit", true},
		{"place_node",2,2,15,"boulder_dig:exit", true},
	},
	--level 3
	{
		{"place_node",35,2,10,"boulder_dig:exit", true},
		{"place_node",2,2,15,"boulder_dig:exit", true},
	},
	--amoeba 
	{
		{"place_node",35,2,10,"boulder_dig:exit", true},
		{"place_node",2,2,15,"boulder_dig:exit", true},
	},
		--avalanche
	{
		{"place_node",35,2,10,"boulder_dig:exit", true},
		{"place_node",2,2,15,"boulder_dig:exit", true},
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
dofile(minetest.get_modpath("boulder_dig").."/amoeba.lua")


minetest.register_on_dieplayer(function(player)
    -- Code to run when a player dies
if score > high_score then 
	high_score = score
end
initializeVariables()
end)



minetest.log("action", "Boulder Dig Mod loaded!")