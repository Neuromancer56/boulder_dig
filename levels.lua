

--https://www.youtube.com/watch?v=bpzN0fagzi8&t=42s
--levels
--"defaultx:mese_post_lightx" > "hero_minesx:working_mese_post_lightx"
local script_tables = {
	--level 2
	{
		{"build_level", 38, 21, 21, .1, .05,7,.7,7,.7,7,.7},
	},
	--level 3
	{
		{"build_level", 38, 21, 21, .18, .09,2,.07,2,.07,2,.07},
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
            local script_table = script_tables[level]
            run_script(pos, script_table)
        end,
    })
end


