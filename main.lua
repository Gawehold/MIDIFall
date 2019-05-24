-- Load global libraries
bit = require "bit"
ffi = require "ffi"
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

-- require "Scripts/DisplayComponent"
-- require "Scripts/NotesComponent"

local x = os.clock()
local song = MIDIParser:parse(love.filesystem.read("Assets/U2.mid"))
player = Player(song)
print(string.format("Elapsed time: %.2fs", os.clock() - x))
-- love.event.quit()

-- Simploo -> Classic
-- All Simploo, No Classic: 44.67s
-- | MIDITrack: 23.88s
-- | MIDIParser: 19.93s
-- | MIDISong: 0.75s
-- | Player: 0.75s
-- | TimeManager: 0.74s


function love.load()
	-- table.foreach(midi.enumerateinports(), print)
	-- print( 'Receiving on device: ', luamidi.getInPortName(0))
	-- local port = midi.openout(0)
	-- port:sendMessage(0x90, 52, 127)
	-- port:noteOn(60,127, 0)
	-- port:noteOff(60,5, 0)
end

function love.update(dt)
	player:update(dt)
end

function love.draw()
	love.graphics.print(love.timer.getFPS() ,0,0 ,0, 2)
	love.graphics.print(player:getTimeManager():getTime(), 0,20, 0, 2)
end

function love.quit()
	midi.gc()
	
	-- TODO: free memory allocated by ffi.C.malloc()
end