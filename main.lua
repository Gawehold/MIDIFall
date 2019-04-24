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
require "Scripts/Note"
require "Scripts/PitchBend"
require "Scripts/Track"
require "Scripts/Song"

require "Scripts/TimeManager"

require "Scripts/DisplayComponent"
require "Scripts/NotesComponent"

local midiSong = MIDIParser:parse(love.filesystem.read("Assets/Pitch_Bend_2.mid"))
local song = Song.new(midiSong)

local notesComponents = {}
for i = 1, #song:getTracks() do
	notesComponents[i] = NotesComponent.new()
	notesComponents[i]:setNotes(song:getTrack(i):getNotes())
end

function love.load()
end

function love.update(dt)
end

function love.draw()
	for i = 1, #song:getTracks() do
		for j = 1, #song:getTrack(i):getNotes() do
			local note = song:getTrack(i):getNote(j)
			local points = {note:getTime()/5, note:getPitch()*20-800}
			
			local pitchBends = song:getTrack(i):getPitchBends()
			for k = 1, #pitchBends do
				local pb = pitchBends[k]
				
				if pb:getTime() >= note:getTime() and pb:getTime() <= note:getTime() + note:getLength() then
					points[#points+1] = pb:getTime()/5
					points[#points+1] = note:getPitch()*20-800 + pb:getSignedValue()/200
				end
			end
			
			points[#points+1] = (note:getTime()+note:getLength())/5
			points[#points+1] = points[#points-1]
			
			for k = #points-1, 1, -2 do
				points[#points+1] = points[k]
				points[#points+1] = points[k+1]+20
			end
			
			local triangles = love.math.triangulate(points)
			for k = 1, #triangles do
				love.graphics.polygon("fill", triangles[k])
			end
		end
	end
	
	for i = 1, #song:getTracks() do
	end
end