local util = require("lib.self.util")

local clamp = util.math.clamp
local range = util.math.range

---

local intensity_rate = 1.5
local max_intensity = 0.9

local pulse_intensity = 0.6
local rest_intensity = 0.3

local max_pulse_speed = 500

---

local function calculate_single_entity_pulse(entity, velocity)
	return (velocity or entity.Velocity:len()) / max_pulse_speed
end

local function calculate_double_entity_pulse(ent1, ent2)
	local diff = ent2.Position - ent1.Position

	local v1 = ent1.Velocity:projectOn(diff)
	local v2 = ent2.Velocity:projectOn(diff)

	local vf = (v1 + v2):len()

	local res1 = calculate_single_entity_pulse(ent1, vf)
	local res2 = calculate_single_entity_pulse(ent2, vf)

	return res1, res2
end

---

return {
	systems = {
		{
			name = "DrawColoredCircle",
			requires = {"Position", "Radius", "Color"},
			draw = function(entity)
				local pos = entity.Position
				local radius = entity.Radius
				local color = entity.Color

				if not entity.ColorIntensity then
					entity.ColorIntensity = rest_intensity
				end

				entity.ColorIntensity = clamp(0, entity.ColorIntensity, max_intensity)
				local v = entity.ColorIntensity

				love.graphics.setColor(color[1] * v, color[2] * v, color[3] * v)
				love.graphics.circle("fill", pos.x, pos.y, radius, 20)

				love.graphics.setColor(color)
				love.graphics.circle("line", pos.x, pos.y, radius, 20)
			end
		},

		{
			name = "RestoreCircleColor",
			requires = {"ColorIntensity"},
			update = function(entity, world, dt)
				local rate = intensity_rate
				local rest = rest_intensity

				local step = rate*dt

				if range(rest - step, entity.ColorIntensity, rest + step) then
					entity.ColorIntensity = rest
				elseif entity.ColorIntensity < rest then
					entity.ColorIntensity = entity.ColorIntensity + step
				elseif entity.ColorIntensity > rest then
					entity.ColorIntensity = entity.ColorIntensity - step
				end
			end
		},

		{ -- Pulse the circle. Value is from 0 to 1.
			name = "PulseCircleColor",
			requires = {"ColorPulse"},
			update = function(entity, world, dt)
				local intensity = rest_intensity + pulse_intensity * entity.ColorPulse

				if entity.ColorIntensity < intensity then
					entity.ColorIntensity = intensity
				end

				entity.ColorPulse = nil
			end
		}
	},

	events = {
		{
			event = "ArenaCollision",
			func = function(world, entity, pos, side)
				entity.ColorPulse = calculate_single_entity_pulse(entity)
			end
		},
		{
			event = "PhysicsCollision",
			func = function(world, ent1, ent2, mtv)
				local res1, res2 = calculate_double_entity_pulse(ent1, ent2)

				ent1.ColorPulse = res1
				ent2.ColorPulse = res2
			end
		},
		{
			event = "ProjectileCollision",
			func = function(world, projectile, target, mtv)
				target.ColorPulse = 1
			end
		},
		{
			event = "WeaponFired",
			func = function(world, entity)
				entity.ColorPulse = 1
			end
		},
		{
			event = "ExplosionHit",
			func = function(world, entity, impact)
				entity.ColorPulse = impact
			end
		}
	}
}
