local class = require("lib.hump.class")

---

local e_proj_physical = require("entities.projectiles.physical")
local e_proj_rocket = class{__includes = e_proj_physical}

function e_proj_rocket:on_collision(world, target, mtv)
	if target.Health then
		target.Health = target.Health - damage
	end
	endPosition = self.Position:clone()
	world:destroyEntity(self)	

	world:spawnEntity(require("entities.explosion")){
		position = endPosition
	}


	e_proj_physical.on_collision(self, world, target, mtv)
end

return e_proj_rocket
