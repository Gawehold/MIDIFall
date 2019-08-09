class "MIDITrack" {
	new = function (self, id)
		self.id = id
		self.priority = id
		
		self.rawEvents = {}
		self.notes = {}
		self.pitchBends = {}
		
		self.enabled = true
		self.customColourHSV = {0,0,0}
		self.isDiamond = false
	end,
	
	getEnabled = function (self)
		return self.enabled
	end,
	
	setEnabled = function (self, enabled)
		self.enabled = enabled
	end,
	
	getCustomColourHSV = function (self)
		return self.customColourHSV
	end,
	
	setCustomColourHSV = function (self, customColourHSV)
		self.customColourHSV = customColourHSV
	end,
	
	getIsDiamond = function (self)
		return self.isDiamond
	end,
	
	setIsDiamond = function (self, isDiamond)
		self.isDiamond = isDiamond
	end,

	getRawEvents = function (self)
		return self.rawEvents
	end,

	getRawEvent = function (self, eventID)
		return self.rawEvents[eventID]
	end,

	addRawEvent = function (self, event)
		table.insert(self.rawEvents, event)
	end,

	getNotes = function (self)
		return self.notes
	end,

	getPitchBends = function (self)
		return self.pitchBends
	end,

	getNote = function (self, noteID)
		return self.notes[noteID]
	end,

	getPitchBend = function (self, pbID)
		return self.pitchBends[pbID]
	end,

	addNote = function (self,note)
		self.notes[#self.notes+1] = note
	end,

	addPitchBend = function (self, pb)
		self.pitchBends[#self.pitchBends+1] = pb
	end,

	processRawEvents = function (self)
		local consumedNoteOffEvent = {}
		
		for j = 1, #self:getRawEvents() do
			local midiEvent = self:getRawEvent(j)
			local time = midiEvent:getTime()
			local type = midiEvent:getType()
			local msg1 = midiEvent:getMsg1()
			local msg2 = midiEvent:getMsg2()
			
			local typeFirstByte = math.floor(type/16)
			local typeSecondByte = type % 16
			
			if typeFirstByte == 0x9 and msg2 > 0 then
				-- Note on
				
				-- Search for the first note off event (which has not been used) of the note after the note on event
				-- TODO: Change the implementation of matching note on and note off by using Queue
				for k = j+1, #self:getRawEvents() do
					local noteOffEvent = self:getRawEvent(k)
					local noteOffTime = noteOffEvent:getTime()
					local noteOffType = noteOffEvent:getType()
					local noteOffMsg1 = noteOffEvent:getMsg1()
					local noteOffMsg2 = noteOffEvent:getMsg2()
			
					local noteOffTypeFirstByte = math.floor(noteOffType/16)
					local noteOffTypeSecondByte = noteOffType % 16
				
					if noteOffTypeFirstByte == 0x8 or (noteOffTypeFirstByte == 0x9 and msg2 == 0) then
						-- it is a note off event
						
						if not consumedNoteOffEvent[k] and msg1 == noteOffMsg1 and typeSecondByte == noteOffTypeSecondByte then
					
							local note = Note(time, noteOffTime-time, msg1, msg2, typeSecondByte)
							self:addNote(note)
							
							consumedNoteOffEvent[k] = true
							break
						end
					end
				end
				
			elseif typeFirstByte == 0xA then
			
			elseif typeFirstByte == 0xB then
			
			elseif typeFirstByte == 0xC then
			
			elseif typeFirstByte == 0xD then
			
			elseif typeFirstByte == 0xE then
				-- Pitch Bend,ing
				-- The format of pitch bend, event is tricky
				-- Let first and second parameters be x1x2x3x4x5x6x7x8 and y1y2y3y4y5y6y7y8
				-- The actual value is y2y3y4y5y6y7y8x2x3x4x5x6x7x8
				local MSByte = bit.rshift(bit.band(msg2, 0x7F), 1)
				local LSByte = bit.lshift(bit.band(msg2, 0x01), 7) + bit.band(msg1, 0x7F)
				local value = bit.lshift(MSByte, 8) + LSByte
				local signedValue = value - 8192
				
				local pb = PitchBend(time, signedValue)
				self:addPitchBend(pb)
			end
		end
	end,
	
	setPriority = function (self, priority)
		self.priority = priority
	end,
	
	getPriority = function (self)
		return self.priority
	end,
	
	getID = function (self)
		return self.id
	end,
}