local class = require("lib.hump.class")

---

local e_proj_physical = require("entities.projectiles.physical")
local e_proj_rocket = class{__includes = e_proj_physical}

function e_proj_rocket:on_collision(world, target, mtv)
	endPosition = self.Position

	local explosion = world:spawnEntity(require("entities.explosion")){
			position = endPosition,
			radius = 25,
			force = 6*10^4
		}
	world:spawnEntity(explosion)
	world:destroyEntity(self)	

	e_proj_physical.on_collision(self, world, target, mtv)
end

return e_proj_rocket
