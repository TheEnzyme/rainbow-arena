local util = require("lib.self.util")

-- Only affect the target if: the projectile and the target both
-- have a Team component and they are on different teams; or
-- one or both do not have a team component.
local function collision_eligible(projectile, target)
	if projectile.Team and target.Team then
		if projectile.Team == target.Team then
			return false
		else
			return true
		end
	else
		return true
	end
end

---

return function()
	return {
		Projectile = true,

		ArenaBounded = 0,

		CollisionExcludeComponents = {"Projectile"},

		OnProjectileCollision = {},
		OnEntityCollision = function(self, world, target, mtv)
			if collision_eligible(self, target) then
				if target.Color then target.ColorPulse = 1 end

				for _, func in ipairs(self.OnProjectileCollision) do
					func(self, world, target, mtv)
				end
			end
		end
	}
end
