-- Load global libraries
bit = require "bit"
require "Libraries/SIMPLOO/dist/simploo"

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

local midiSong = MIDIParser:parse(love.filesystem.read("Assets/DELTARUNE_-_Chapter_1_-_Lantern_-_ShinkoNetCavy.mid"))
local song = Song.new(midiSong)
local player = Player.new(song)

local notesComponents = {}
for i = 1, #song:getTracks() do
	notesComponents[i] = NotesComponent.new()
	notesComponents[i]:setNotes(song:getTrack(i):getNotes())
end

function love.load()
end

function love.update(dt)
	player:update(dt)
end

function love.draw()
	love.graphics.print(love.timer.getFPS() ,0,0 ,0, 2)
	love.graphics.print(player:getTimeManager():getTime(), 0,20, 0, 2)
end