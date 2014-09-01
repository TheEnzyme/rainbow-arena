local class = require("lib.hump.class")
local timer = require("lib.hump.timer")

---

local e_proj_rocket = require("entities.projectiles.rocket")
local e_proj_bomb = class{__includes = e_proj_rocket}

function e_proj_bomb:init(arg)
	self.Timer = arg.Timer or 3

	e_proj_rocket.init(self)
end

function e_proj_bomb:on_collision(world, target, mtv)
	timer.add(self.Timer)
	if timer <= 0 then
		e_proj_rocket.on_collision(self, world, target, mtv)
	end
end

return e_proj_bomb
