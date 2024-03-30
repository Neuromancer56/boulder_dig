
local function dirtTouchAction(player)
	local pos = player:get_pos()
	--minetest.swap_node(pos, {name = "hero_mines:broken_mese_post_light", param2 = node.param2})
	

local yaw = player:get_look_horizontal()
local yaw_degrees = (yaw + 2 * math.pi) % (2 * math.pi) * 180 / math.pi
minetest.log("x","yaw_degrees:"..yaw_degrees)	



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
	
	for dx = x_start, x_end do
		minetest.log("x","dx:"..dx)	
		for dy = -1, 1 do
			for dz = z_start, z_end do
				minetest.log("x","dz:"..dz)	
				local neighbor_pos = {x = pos.x + dx, y = pos.y + dy, z = pos.z + dz}
				local node = minetest.get_node(neighbor_pos)
				
				if node.name == "default:dirt" then
					minetest.swap_node(neighbor_pos, {name = "air", param2 = node.param2})
							
				end
			end
		end
	end
    minetest.sound_play("default_break_glass", {pos = pos, gain = 0.5, max_hear_distance = 10})
		--minetest.log("x","x:"..neighbor_pos.x ..",z:"..neighbor_pos.z)		
end

-- Register global step action for magma nodes
registerNodeTouchAction("default:dirt", dirtTouchAction)

