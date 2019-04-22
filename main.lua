-- Load global libraries
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
require "Scripts/Note"
require "Scripts/Track"
require "Scripts/Song"

local midiSong = MIDIParser:parse(love.filesystem.read("Assets/debug.mid"))
local song = Song.new(midiSong)

function love.load()
end

function love.update(dt)
end

function love.draw()
	for i = 1, #song:getTracks() do
		for j = 1, #song:getTrack(i):getNotes() do
			local note = song:getTrack(i):getNote(j)
			-- print(note:getTime(), note:getLength(), note:getPitch(), note:getVelocity())
		end
	end
end