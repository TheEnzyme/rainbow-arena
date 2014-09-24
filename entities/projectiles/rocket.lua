local class = require("lib.hump.class")
local timer = require("lib.hump.timer")

---

local e_proj_bullet = require("entities.projectiles.bullet")
local e_proj_rocket = class{__includes = e_proj_bullet}

function e_proj_rocket:init(arg)
	arg = arg or {}
	
	self.damage = arg.damage or 5	
	self.Timer = arg.timer or 0

	e_proj_bullet.init(self, arg)
end

function e_proj_rocket:on_collision(world, target, mtv)
	local endPosition = self.Position

	local explosion = world:spawnEntity(require("entities.effects.explosion"){
			position = endPosition,
			force = 2*10^6,
			damage = self.damage/2,
			radius = 100
	})
	self.damage = self.damage/2
	world:spawnEntity(explosion)
	world:destroyEntity(self)	
	e_proj_bullet.on_collision(self, world, target, mtv)

end

return e_proj_rocket
