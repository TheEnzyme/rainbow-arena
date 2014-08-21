local vector = require("lib.hump.vector")

return {
	systems = {
		{
			name = "UpdateWeapon",
			requires = {"Weapon"},
			update = function(entity, world, dt)
				-- Cooldown.
				if not entity.Weapon.heat then entity.Weapon.heat = 0 end
				entity.Weapon.heat = entity.Weapon.heat - dt
				if entity.Weapon.heat < 0 then entity.Weapon.heat = 0 end

				-- Reset "fired" flag.
				if entity.Weapon.fired and not entity.Firing then
					if entity.Weapon.fire_end then
						entity.Weapon:fire_end(world, entity)
					end
					entity.Weapon.fired = false
				end

				-- Called every frame while firing or after fired. Useful for beam weapons.
				if entity.Firing and entity.Weapon.firing then
					entity.Weapon:firing(world, entity, position_vector, direction_vector, dt)
				end

				-- Fire if applicable.
				if entity.Firing and entity.Weapon.heat == 0 then
					local direction_vector = vector.new(
						math.cos(entity.Rotation), math.sin(entity.Rotation))
					local position_vector = entity.Position:clone()
						+ (direction_vector * (entity.Radius))

					if (entity.Weapon.type == "single" and not entity.Weapon.fired)
						or entity.Weapon.type == "repeat" then
						entity.Weapon:fire(world, entity, position_vector, direction_vector)
						entity.Weapon.fired = true
					end
				end
			end
		}
	},

	events = {

	}
}
