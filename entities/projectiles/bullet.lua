local class = require("lib.hump.class")

---

local e_proj_physical = require("entities.projectiles.physical")
local e_proj_bullet = class{__includes = e_proj_physical}

function e_proj_bullet:on_collision(world, target, mtv)
	if target.Health then
		target.Health = target.Health - damage
	end
	world:destroyEntity(self)

	e_proj_physical.on_collision(self, world, target, mtv)
end

return e_proj_bullet
