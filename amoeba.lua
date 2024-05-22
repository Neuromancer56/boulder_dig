local function swap_node(pos, name)
  local node = minetest.get_node(pos)
  if node.name == name then
    return
  end
  node.name = name
  minetest.swap_node(pos, node)
end


minetest.register_node("boulder_dig:amoeba", {
  description = "Amoeba",
  tiles = {
    "mykota_mykota.png"
  },
  waving = 1,
  drawtype = "nodebox",
  groups = {
    choppy = 3,
  },
  on_construct = function(pos)
    local meta = minetest.get_meta(pos)
    local fertility_settings = minetest.settings:get("amoeba_fertility") or 5
    meta:set_int("fertility", fertility_settings)

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
  end,
})

minetest.register_node("boulder_dig:dry_amoeba", {
  description = "Dry Amoeba",
  tiles = {
    "mykota_dry_mykota.png"
  },
  groups = {
    choppy = 2,
    falling_node = 1,
  }
})

minetest.register_craft({
  type = "cooking",
  recipe = "boulder_dig:amoeba",
  output = "boulder_dig:dry_amoeba",
  cooktime = 10,
})


minetest.register_abm({
  label = "auto grow Amoeba",
  nodenames = {
    "boulder_dig:amoeba",
  },
  neighbours = { "air", "default:dirt" },
  interval = 5,
  chance = 3,
  action = function(pos)
    local meta = minetest.get_meta(pos)
    local cur_fertility = meta:get_int("fertility") or 0
    local free_dir = {}

    if pos == nil then
      return
    end

    local mx_pos = table.copy(pos)
    mx_pos.x = mx_pos.x - 1
    local mx_node = minetest.get_node(mx_pos)
    if mx_node.name == "air" or mx_node.name == "default:dirt" then
      table.insert(free_dir, mx_pos)
    end

    local px_pos = table.copy(pos)
    px_pos.x = px_pos.x + 1
    local px_node = minetest.get_node(px_pos)
    if px_node.name == "air" or px_node.name == "default:dirt" then
      table.insert(free_dir, px_pos)
    end

    local mz_pos = table.copy(pos)
    mz_pos.z = mz_pos.z - 1
    local mz_node = minetest.get_node(mz_pos)
    if mz_node.name == "air" or mz_node.name == "default:dirt" then
      table.insert(free_dir, mz_pos)
    end

    local pz_pos = table.copy(pos)
    pz_pos.z = px_pos.z + 1
    local pz_node = minetest.get_node(pz_pos)
    if pz_node.name == "air" or pz_node.name == "default:dirt" then
      table.insert(free_dir, pz_pos)
    end

    local new_pos = nil
    if cur_fertility > 0 and #free_dir > 0 then
      if #free_dir == 1 then
        new_pos = free_dir[1]
      else
        math.randomseed(os.time())
        random_pos = math.random(1, #free_dir)
        new_pos = free_dir[random_pos]
      end

      meta:set_int("fertility", cur_fertility - 1)
      minetest.set_node(new_pos, {name="boulder_dig:amoeba"})
      minetest.spawn_falling_node(new_pos)
      local new_meta = minetest.get_meta(new_pos)
      new_meta:set_int("fertility", cur_fertility - 1)
    else
		if cur_fertility <= 0 then
			swap_node(pos, "boulders:boulder")
		else 
			swap_node(pos, "boulder_dig:gemstone")
		end
    end
  end,
})

--[[
minetest.register_craft({
  type = "fuel",
  recipe = "mykota:dry_mykota",
  burntime = 18
})
]]