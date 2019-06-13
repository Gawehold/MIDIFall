-- Heper functions
math.clamp = function (x,a,b)
	return math.max(math.min(x,b),a)
end

-- Load global libraries
bit = require "bit"
ffi = require "ffi"
vivid = require "Libraries/vivid/vivid"
-- simploo.config["production"] = true
midi = require "luamidi"

ffi.cdef[[
char *malloc(size_t size);
void free(void *ptr);
]]

-- Define global variables
NULL = {}

-- Load scripts
require "Scripts/Class"
-- require "Scripts/Queue"
-- require "Scripts/Stack"

require "Scripts/MIDIEvent"
require "Scripts/TempoChange"
require "Scripts/TimeSignature"
require "Scripts/Note"
require "Scripts/PitchBend"
require "Scripts/MIDITrack"
require "Scripts/MIDISong"
require "Scripts/MIDIParser"

require "Scripts/Player"
require "Scripts/TimeManager"

require "Scripts/DisplayComponent"
require "Scripts/BackgroundComponent"
require "Scripts/NotesComponent"
require "Scripts/KeyboardComponent"
require "Scripts/FallsComponent"
require "Scripts/DefaultTheme"

local song = MIDIParser:parse(love.filesystem.read("Assets/indeterminateuniverse-wip.mid"))
-- local song = MIDIParser:parse(love.filesystem.read("Assets/Pitch_Bend_4.mid"))
-- local song = MIDIParser:parse(love.filesystem.read("Assets/Megalomachia2 - Track 6 - SUPER-REFLEX - ShinkoNetCavy.mid"))
-- local song = MIDIParser:parse(love.filesystem.read("Assets/Toumei Elegy [2d erin & Kanade].mid"))
player = Player(song)


local defaultTheme = DefaultTheme(0,0,0,0)

function love.load()
	-- table.foreach(midi.enumerateinports(), print)
	-- print( 'Receiving on device: ', luamidi.getInPortName(0))
	-- local port = midi.openout(0)
	-- port:sendMessage(0x90, 52, 127)
	-- port:noteOn(60,127, 0)
	-- port:noteOff(60,5, 0)
end

function love.update(dt)
	defaultTheme:update(dt)
	
	player:update(dt)
end

function love.draw()
	defaultTheme:draw()
	
	love.graphics.setColor(1,1,1,1)
	love.graphics.print(love.timer.getFPS() ,0,0 ,0, 2)
	love.graphics.print(player:getTimeManager():getTime(), 0,20, 0, 2)
end

function love.quit()
	midi.gc()
	
	-- TODO: free memory allocated by ffi.C.malloc()
end

function love.mousemoved( x, y, dx, dy, istouch )
	if love.mouse.isDown(1) then
		if dx > 0 then
			player:initiailzeStates()
		end
		
		local speed = 1
		if love.keyboard.isDown("lctrl") then speed = 1/4 end
		
		player:getTimeManager():setTime(player:getTimeManager():getTime()-dx)
	end
end