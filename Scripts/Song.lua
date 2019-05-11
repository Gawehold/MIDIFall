class "Song" {
	private {
		tracks = {},
		systemEvents = {},
		metaEvents = {
			tempoChanges = {},
			timeSignatures = {},
		},
		
		
		timeDivision = NULL,
		initialTime = NULL,
		endTime = NULL,
		
		parse = function (self, midiSong)
			for i = 1, #midiSong:getTracks() do
				local midiTrack = midiSong:getTrack(i)
				local consumedNoteOffEvent = {}
				
				local track = Track.new()
				self:addTrack(track)
				
				for j = 1, #midiTrack:getEvents() do
					local midiEvent = midiTrack:getEvent(j)
					local time = midiEvent:getTime()
					local type = midiEvent:getType()
					local msg1 = midiEvent:getMsg1()
					local msg2 = midiEvent:getMsg2()
					
					local typeFirstByte = math.floor(type/16)
					local typeSecondByte = type - typeFirstByte
					
					if typeFirstByte == 0x9 and msg2 > 0 then
						-- Note on
						
						-- Search for the first note off event (which has not been used) of the note after the note on event
						-- TODO: Change the implementation of matching note on and note off by using Queue
						for k = j+1, #midiTrack:getEvents() do
							local noteOffEvent = midiTrack:getEvent(k)
							local noteOffEvent = midiTrack:getEvent(k)
							local noteOffTime = noteOffEvent:getTime()
							local noteOffType = noteOffEvent:getType()
							local noteOffMsg1 = noteOffEvent:getMsg1()
							local noteOffMsg2 = noteOffEvent:getMsg2()
					
							local noteOffTypeFirstByte = math.floor(noteOffType/16)
							local noteOffTypeSecondByte = noteOffType - noteOffTypeFirstByte
						
							if noteOffTypeFirstByte == 0x8 or (noteOffTypeFirstByte == 0x9 and msg2 == 0) and not consumedNoteOffEvent[k] and msg1 == noteOffMsg1 and typeSecondByte == noteOffTypeSecondByte then
							
								local note = Note(time, noteOffTime, msg1, msg2, typeSecondByte)
								self.tracks[i]:addNote(note)
								
								consumedNoteOffEvent[k] = true
								break
							end
						end
						
					elseif typeFirstByte == 0xA then
					
					elseif typeFirstByte == 0xB then
					
					elseif typeFirstByte == 0xC then
					
					elseif typeFirstByte == 0xD then
					
					elseif typeFirstByte == 0xE then
						-- Pitch Bending
						-- The format of pitch bend event is tricky
						-- Let first and second parameters be x1x2x3x4x5x6x7x8 and y1y2y3y4y5y6y7y8
						-- The actual value is y2y3y4y5y6y7y8x2x3x4x5x6x7x8
						local MSByte = bit.rshift(bit.band(msg2, 0x7F), 1)
						local LSByte = bit.lshift(bit.band(msg2, 0x01), 7) + bit.band(msg1, 0x7F)
						local value = bit.lshift(MSByte, 8) + LSByte
						local signedValue = value - 8192
						
						local pb = PitchBend.new(time, signedValue)
						self.tracks[i]:addPitchBend(pb)
					
					elseif type == 0xF0 then
						-- System Exclusive Event
					elseif type == 0xFF then	-- Meta Event
						if msg1 == 0x51 then	-- Set Tempo
							local event = TempoChange.new(time, type, msg1, msg2)
							self:addTempoChange(event)
							
						elseif msg1 == 0x58 then	-- Time Signature
							local event = TimeSignature.new(time, type, msg1, msg2)
							
							self:addTimeSignature(event)
						end
						
					elseif not(typeFirstByte == 0x8 or (typeFirstByte == 0x9 and msg2 == 0)) then
						-- print(string.format("Unsupported event type: 0x%.2X.", type))
					end
					
				end
			end
		end,
	},
	
	public {
		__construct = function (self, midiSong)
			self:parse(midiSong)
			
			self.timeDivision = midiSong:getTimeDivision()
			
			self.initialTime = 0
			self.endTime = 0
			
			-- Search for the last event and set it as the end time of the song
			for i = 1, #midiSong:getTracks() do
				local lastEventTime = midiSong:getTrack(i):getEvent(#midiSong:getTrack(i):getEvents()):getTime()
				if  lastEventTime > self.endTime then
					self.endTime = lastEventTime
				end
			end
		end,
		
		getTracks = function (self)
			return self.tracks
		end,
		
		getSystemEvents = function (self)
			return self.systemEvents
		end,
		
		getMetaEvents = function (self)
			return self.metaEvents
		end,
		
		getTrack = function (self, trackID)
			return self.tracks[trackID]
		end,
		
		getTimeDivision = function (self)
			return self.timeDivision
		end,
		
		getTempoChanges = function (self)
			return self.metaEvents.tempoChanges
		end,
		
		getTimeSignatures = function (self)
			return self.metaEvents.timeSignatures
		end,
		
		getTempoChange = function (self, eventID)
			return self.metaEvents.tempoChanges[eventID]
		end,
		
		getTimeSignature = function (self, eventID)
			return self.metaEvents.timeSignatures[eventID]
		end,
		
		addTrack = function (self, track)
			self.tracks[#self.tracks+1] = track
		end,
		
		addTempoChange = function (self, tempoChange)
			self.metaEvents.tempoChanges[#self.metaEvents.tempoChanges+1] = tempoChange
		end,
		
		addTimeSignature = function (self, timeSignature)
			self.metaEvents.timeSignatures[#self.metaEvents.timeSignatures+1] = timeSignature
		end,
	},
}