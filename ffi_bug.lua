local ffi = require("ffi")

ffi.cdef[[
void *malloc(size_t size);
void free(void *ptr);
]]

bit = require "bit"
NULL = {}

require "Libraries/SIMPLOO/dist/simploo"
require "Scripts/Queue"
require "Scripts/Stack"
require "Scripts/MIDIEvent"
require "Scripts/MIDITrack"
require "Scripts/MIDISong"

			-- Convert a string which contains bytes in ASCII encoding to a number
			-- e.g. bytes2number("MThd", 1,4) => 4D546864 = 1297377380
			bytes2number = function (str, i, j)
				local hexStr = ""
				
				for u = i, j do
					hexStr = hexStr .. string.format("%02X", string.byte(str,u))
				end
				
				return tonumber(hexStr, 16)
			end
			
			parse = function (dataStr)
				local smf = {}
				
				-- Check if it is a proper MIDI file
				if string.sub(dataStr, 1, 4) ~= "MThd" then
					assert(false, "It is not a proper MIDI file.")
				end
				
				-- Save the header information 
				local headerSize = bytes2number(dataStr, 5, 8)
				local formatType = bytes2number(dataStr, 9, 10)
				local trackAmount = bytes2number(dataStr, 11, 12)
				local timeDivision = bytes2number(dataStr, 13, 14)	-- ticks per quarter note OR called Pulses Per Quarter Note (PPQN)
				
				-- Check if the format type is 2
				if formatType == 2 then
					assert(false, "Format 2 files are not supported.")
				end
				
				-- Create the MIDISong
				local midiSong = MIDISong.new(formatType, timeDivision)
				
				-- Find the tracks
				local systemEvents = {}
				local metaEvents = {}
				
				for i = 15, string.len(dataStr) do	-- i stand for the text position
					if string.sub(dataStr, i, i+3) == "MTrk" then
						-- Track found
						
						local id = #midiSong:getTracks() + 1	-- the number of the track
						
						-- Save the header information of the track
						midiSong:addTrack(MIDITrack.new(i, bytes2number(dataStr, i+4, i+7)))
						
						-- Variable for checking the bytes of each event AND what last event is
						local timeByte = 1
						local timeComfirmed = false
						local skipTo = 0
						local lastMidiEvent = nil
						
						-- Find the events
						-- the hex number before i+8 is just track header
						for j = i+8, i+8 + midiSong:getTrack(id):getBinSize() - 1 do	-- i stand for the text position start from the beginning of each track
							-- Pass if still scanning the previous event
							if j >= skipTo then
								-- HEX number of current MIDI event type
								local hex = bytes2number(dataStr, j, j)
								
								-- Check if 1 byte for time stamp
								if not timeComfirmed then
									if hex >= 0x80 then
										timeByte = timeByte + 1	-- next byte is still time byte
									else
										timeComfirmed = true	-- so next byte should be the event content
									end
								else	-- Scanning the byte after the time stamp
									-- Define the event id of the current track
									local message1 = bytes2number(dataStr, j+1, j+1)
									local message2 = nil
									
									-- Find the (delta-)time
									local t = bytes2number(dataStr, j-1, j-1)
									if timeByte > 1 then
										for k = 1, timeByte-1 do
											local v = bytes2number(dataStr, j - (k+1), j - (k+1))
											v = (v - 128) * math.pow(128, k)
											t = t + v
										end
									end
									--print(t, string.format("%02X", hex), string.sub(dataStr, j+2, j+3))
									
									if hex == 0xF0 or hex == 0xFF then	-- System exclusive AND event Meta event
										local u
										if hex == 0xF0 then
											u = j - 1	-- SysEx event: 0xF0 SIZE CONTENT
										else
											u = j		-- Meta event: 0xFF ID SIZE CONTENT
										end

										local size = bytes2number(dataStr, u+2, u+2)
										
										-- Find and save the message 2 if it has
										if size > 0 then
											message2 = string.sub(dataStr, u+3, u+3 + size - 1)
										end
										
										-- Define the table which carry on the above data
										local time = t
										local numOfEvent = #midiSong:getTrack(id):getEvents()
										if numOfEvent > 0 then
											-- Convert delta-time to actual time
											time = time + midiSong:getTrack(id):getEvent(numOfEvent):getTime()
										end
										
										local event = MIDIEvent(time, hex, message1, message2)
										midiSong:getTrack(id):addEvent(event)
										if midiSong:getTrack(1):getEvent(2) ~= nil then
											print(id, #midiSong:getTrack(id):getEvents(), midiSong:getTrack(1):getEvent(2).msg2[0], midiSong:getTrack(1):getEvent(2):getMsg2())
										end
										
										-- Tell the program to jump to the next event but not next bytes
										skipTo = u+3 + size
										
									elseif hex <= 0xEF then	-- MIDI event
										local u
										if hex >= 0x80 then
											-- this event has the event type byte
											u = j	-- Current byte is the event type, so no need to adjust
											lastMidiEvent = hex	-- Set the current event as the latest MIDI event
										else
											-- this event has not the event type byte (i.e. repeat the last event)
											u = j - 1	-- Current byte is the first parameter instead of type
											hex = lastMidiEvent	-- Follow the last event
											
											message1 = bytes2number(dataStr, u+1, u+1)	-- Update the message 1 to the next byte (the original message 1 is actually the message 2 since the even type byte is missed)
										end
										
										-- Check if second parameter needed
										if (hex >= 0x80 and hex <= 0xBF) or (hex >= 0xE0 and hex <= 0xEF) then
											message2 = bytes2number(dataStr, u+2, u+2)	-- save the message 2
										end
										
										-- Save the event
										local time = t
										local numOfEvent = #midiSong:getTrack(id):getEvents()
										if numOfEvent > 0 then
											-- Convert delta-time to actual time
											time = time + midiSong:getTrack(id):getEvent(numOfEvent):getTime()
										end
										
										local cmsg2 = nil
										if message2 ~= nil then
											cmsg2 = ffi.new("unsigned char[1]", message2)
										end
										-- local event = MIDIEvent(time, hex, message1, cmsg2)
										-- midiSong:getTrack(id):addEvent(event)
										
										-- Tell the program to jump to the next event but not next bytes
										if message2 then
											skipTo = u + 3
										else
											skipTo = u + 2
										end
										
									else
										assert(false, "Event Error")
									end
									
									-- Reset variable
									timeComfirmed = false
									timeByte = 1
								end
							end
						end
					end
				end
				
				-- Check if the track amount announced in the header chunk match with the actual tracks found
				-- assert(trackAmount == #midiSong:getTracks(), "Track amount not match with the .mid file header")
				
				-- Debug
				return midiSong
			end

local file = io.open("Assets/ll.mid", "rb")
local midiSong = parse(file:read("*a"))
file:close()
print(midiSong:getTrack(1):getEvent(2).msg2[0], midiSong:getTrack(1):getEvent(2):getMsg2())
-- local events = {}
-- for i = 1, 100 do
	-- events[i] = MIDIEvent(i, 0xFF, 0x52, tostring(i))
	-- local a
-- end

-- print(events[50]:getMsg2())