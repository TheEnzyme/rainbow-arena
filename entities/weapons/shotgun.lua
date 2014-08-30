local class = require("lib.hump.class")
local util = require("lib.self.util")
local util = require("lib.self.util")

---

local map = util.math.map

---

local w_projectile = require("entities.weapons.projectile")
local w_shotgun = class{__includes = w_projectile}

function w_shotgun:init(arg)
	
	w_projectile.init(self, arg)

end

function w_shotgun:start(host, world, pos, dir)
	w_projectile.start(host, world, pos, dir)
end



function w_shotgun:fire(host, world, pos, dir) 
	for x = 0, (math.pi / 36), (math.pi / 180) do
		local dir = dir:rotated(x)
		w_projectile.fire(self, host, world, pos, dir)
		local dir = dir:rotated(-x)
		w_projectile.fire(self, host, world, pos, dir)
	end
end

return w_shotgun
