local vector = require("lib.hump.vector")

---

return {
	systems = {
		{
			name = "UpdateWeapon",
			requires = {"Weapon"},
			update = function(entity, world, dt)
				local weapon = entity.Weapon

				weapon.heat = weapon.heat - dt
				if weapon.heat < 0 then
					weapon.overheat = false
					weapon.heat = 0
				end

				if entity.Firing then
					if weapon.heat >= weapon.max_heat then
						weapon.overheat = true

						if weapon.cease then
							weapon:cease(entity, world)
						end
					end

					if not weapon.overheat then
						local direction_vector = vector.new(
							math.cos(entity.Rotation), math.sin(entity.Rotation))
						local position_vector = entity.Position:clone()
							+ (direction_vector * (entity.Radius))

						-- start: called first when the weapon starts firing.
						if not weapon._fired then
							weapon:start(entity, world, position_vector, direction_vector)
							weapon._fired = true
						end

						-- firing: called every frame while firing.
						if weapon.firing then
							weapon:firing(dt, entity, world, position_vector, direction_vector)
						end
					end

				else -- if not entity.Firing then
					if weapon._fired then
						-- cease: called when the weapon ceases firing.
						if weapon.cease then
							weapon:cease(entity, world)
						end
						weapon._fired = false
					end
				end

				-- updateL called every frame.
				if weapon.update then
					weapon:update(dt, entity, world)
				end
			end
		}
	},

	events = {

	}
}
