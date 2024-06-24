
function spawn_slime_particles(pos)
    part_id = minetest.add_particlespawner({
      amount = 20,
      time = 1,
      texture = "mykota_particle_spore.png^[colorize:#1c7932",
      minpos = {x=pos.x+1, y=pos.y+0.4, z=pos.z+1},
      maxpos = {x=pos.x-1, y=pos.y+0.2, z=pos.z-1},

      minvel = {x=-2, y=0.4, z=-2},
      maxvel = {x=2, y=1.2, z=2},

      minacc = {x=-.4, y=0.5, z=-.4},
      maxacc = {x=.4, y=4, z=.4},

      minexptime = 0.4,
      maxexptime = 0.8,

      minsize = 0.1,
      maxsize = 0.4,

      glow = 9,
      vertical = false,
      collisiondetection = true
    })
end

-- Define the slime node
minetest.register_node("boulder_dig:slime", {
  description = "Slime",
  tiles = {
    "mykota_mykota.png^[colorize:yellow:64"
  },
  waving = 1,
  drawtype = "nodebox",
  groups = {
    choppy = 3,
  },
  on_construct = function(pos)
    --local meta = minetest.get_meta(pos)
    --local fertility_settings = minetest.settings:get("amoeba_fertility") or 5
    --meta:set_int("fertility", fertility_settings)
	spawn_slime_particles(pos)

  end,
})


-- ABM to handle the behavior
minetest.register_abm({
    label = "Slime ABM",
    nodenames = {"boulder_dig:slime"},
    interval = 20.0,
    chance = 1,
    action = function(pos, node)
        local above_pos = {x = pos.x, y = pos.y + 1, z = pos.z}
        local above_node = minetest.get_node(above_pos).name
		local below_pos = {x = pos.x, y = pos.y - 1, z = pos.z}
        local below_node = minetest.get_node(below_pos).name
		
        
        if (above_node == "boulders:boulder" or above_node == "boulder_dig:gemstone") and below_node == "air" then
            if math.random() < 0.3 then  -- 30% chance
                minetest.sound_play("slime-squish-9", {pos = pos, gain = 0.3, max_hear_distance = 10})
				spawn_slime_particles(pos)
				minetest.set_node(above_pos, {name = "air"})
                minetest.set_node(below_pos, {name = above_node})
				minetest.check_for_falling(below_pos)
            end
        end
    end,
})
