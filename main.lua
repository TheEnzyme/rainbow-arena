--[[
	Rainbow Arena, a game by LegoSpacy
]]

--[[
	Stuff to do:
		Graphics: background
		Content: weapons, powerups?
		Matches: Actual match/level logic

		TODO:
			Make player rotation limited by a turn rate.

		Weapons to make:
			Beam laser
			Sticky bomb launcher
			Rocket launcher
			Guided missile launcher
			Turret deployer
			Sonic (dubstep) gun
			Gravity ball launcher
]]

local gs = require("lib.hump.gamestate")

local state_game = require("states.game")

function love.load()
	gs.registerEvents()

	gs.switch(state_game)
end
