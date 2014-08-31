local class = require("lib.hump.class")
local util = require("lib.self.util")

---

local map = util.math.map

---

local w_projectile = require("entities.weapons.projectile")
local w_shotgun = class{__includes = w_projectile}

function w_shotgun:init(arg)
	self.shots = arg.shots or 8
	self.arc = arg.arc or 10
	self.shake_radius = arg.shake_radius or 100

	arg.kind = arg.kind or "single"

	w_projectile.init(self, arg)

end

function w_shotgun:fire(host, world, pos, dir)
	w_projectile.fire(self, host, world, pos, dir)
	math.randomseed(os.time())
	for x = 0, self.shots do
		local random = math.random(-1 * self.arc, self.arc)
		local dir = dir:rotated(random * (math.pi/180))
		w_projectile.fire(self, host, world, pos, dir)
	
	end
end

return w_shotgun
