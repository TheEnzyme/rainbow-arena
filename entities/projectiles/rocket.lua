local class = require("lib.hump.class")
local timer = require("lib.hump.timer")

---

local e_proj_physical = require("entities.projectiles.physical")
local e_proj_rocket = class{__includes = e_proj_physical}

function e_proj_rocket:init(arg)
	arg = arg or {}
	self.damage = arg.damage or 5	

	self.Timer = arg.timer or 0

	e_proj_physical.init(self, arg)
end

function e_proj_rocket:on_collision(world, target, mtv)
	endPosition = self.Position


	local explosion = world:spawnEntity(require("entities.effects.explosion"){
			position = endPosition,
			force = 2*10^6,
			damage = 10,
			radius = 100
	})
	
	world:destroyEntity(self)	
	e_proj_physical.on_collision(self, world, target, mtv)
	timer.add(self.Timer, function() world:spawnEntity(explosion) end)
end

return e_proj_rocket
