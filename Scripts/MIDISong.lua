MIDISong = Object:extend()

function MIDISong:new(formatType, timeDivision)
	self.formatType = formatType
	self.timeDivision = timeDivision
	
	self.tracks = {}
	self.tempoChanges = {}
	self.timeSignatures = {}
	
	self.initialTime = 0
	self.endTime = 0
end

function MIDISong:getFormatType()
	return self.formatType
end

function MIDISong:getTimeDivision()
	return self.timeDivision
end

function MIDISong:getTracks()
	return self.tracks
end

function MIDISong:getTrack(trackID)
	return self.tracks[trackID]
end

function MIDISong:addTrack(track)
	self.tracks[#self.tracks+1] = track
end

function MIDISong:getTempoChanges()
	return self.tempoChanges
end

function MIDISong:getTimeSignatures()
	return self.timeSignatures
end

function MIDISong:getTempoChange(eventID)
	return self.tempoChanges[eventID]
end

function MIDISong:getTimeSignature(eventID)
	return self.timeSignatures[eventID]
end

function MIDISong:addTempoChange(tempoChange)
	self.tempoChanges[#self.tempoChanges+1] = tempoChange
end

function MIDISong:addTimeSignature(timeSignature)
	self.timeSignatures[#self.timeSignatures+1] = timeSignature
end

function MIDISong:intialize()
	-- Search for the last event and set it as the end time of the song
	for i = 1, #self:getTracks() do
		local lastEventTime = self:getTrack(i):getRawEvent(#self:getTrack(i):getRawEvents()):getTime()
		if  lastEventTime > self.endTime then
			self.endTime = lastEventTime
		end
	end
	
	for i = 1, #self:getTracks() do
		local track = self:getTrack(i)
		
		track:processRawEvents()
		
		for j = 1, #track:getRawEvents() do
			local midiEvent = track:getRawEvent(j)
			local time = midiEvent:getTime()
			local type = midiEvent:getType()
			local msg1 = midiEvent:getMsg1()
			local msg2 = midiEvent:getMsg2()
			
			local typeFirstByte = math.floor(type/16)
			local typeSecondByte = type - typeFirstByte
			
			
			if type == 0xF0 then
				-- System Exclusive Event
			elseif type == 0xFF then	-- Meta Event
				if msg1 == 0x51 then	-- Set Tempo
					local event = TempoChange.new(time, type, msg1, msg2)
					self:addTempoChange(event)
					
				elseif msg1 == 0x58 then	-- Time Signature
					local event = TimeSignature.new(time, type, msg1, msg2)
					self:addTimeSignature(event)
				end
			end
		end
	end
end