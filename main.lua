-- Load global libraries
bit = require "bit"
ffi = require "ffi"
require "Libraries/SIMPLOO/dist/simploo"
-- simploo.config["production"] = true
midi = require "luamidi"

ffi.cdef[[
char *malloc(size_t size);
void free(void *ptr);
]]

-- Define global variables
NULL = {}

-- Load scripts
require "Scripts/Queue"
require "Scripts/Stack"

require "Scripts/MIDIEvent"
require "Scripts/MIDITrack"
require "Scripts/MIDISong"
require "Scripts/MIDIParser"

require "Scripts/Event"
require "Scripts/TempoChange"
require "Scripts/TimeSignature"
require "Scripts/Note"
require "Scripts/PitchBend"
require "Scripts/Track"
require "Scripts/Song"

require "Scripts/Player"
require "Scripts/TimeManager"

require "Scripts/DisplayComponent"
require "Scripts/NotesComponent"

local midiSong = MIDIParser:parse(love.filesystem.read("Assets/indeterminateuniverse-wip.mid"))
local song = Song.new(midiSong)
local player = Player.new(song, midiSong)

-- local notesComponents = {}
-- for i = 1, #song:getTracks() do
	-- notesComponents[i] = NotesComponent.new()
	-- notesComponents[i]:setNotes(song:getTrack(i):getNotes())
-- end

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
	love.graphics.print(tonumber(player:getTimeManager():getTime()), 0,20, 0, 2)
end

function love.quit()
	midi.gc()
end