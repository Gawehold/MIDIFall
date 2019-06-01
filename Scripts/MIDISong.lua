class "MIDISong" {
	new = function (self, formatType, timeDivision)
		self.formatType = formatType
		self.timeDivision = timeDivision
		
		self.tracks = {}
		self.tempoChanges = {}
		self.timeSignatures = {}
		
		self.initialTime = 0
		self.endTime = 0
	end,
	
	getFormatType = function (self)
		return self.formatType
	end,
	
	getTimeDivision = function (self)
		return self.timeDivision
	end,
	
	getTracks = function (self)
		return self.tracks
	end,
	
	getTrack = function (self, trackID)
		return self.tracks[trackID]
	end,
	
	addTrack = function (self, track)
		self.tracks[#self.tracks+1] = track
	end,
	
	getTempoChanges = function (self)
		return self.tempoChanges
	end,
	
	getTimeSignatures = function (self)
		return self.timeSignatures
	end,
	
	getTempoChange = function (self, eventID)
		return self.tempoChanges[eventID]
	end,
	
	getTimeSignature = function (self, eventID)
		return self.timeSignatures[eventID]
	end,
	
	addTempoChange = function (self, tempoChange)
		self.tempoChanges[#self.tempoChanges+1] = tempoChange
	end,
	
	addTimeSignature = function (self, timeSignature)
		self.timeSignatures[#self.timeSignatures+1] = timeSignature
	end,
	
	getInitialTime = function (self)
		return self.initialTime
	end,
	
	getEndTime = function (self)
		return self.endTime
	end,
	
	intialize = function (self)
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
						local event = TempoChange(time, msg1, msg2)
						self:addTempoChange(event)
						
					elseif msg1 == 0x58 then	-- Time Signature
						local event = TimeSignature(time, msg1, msg2)
						self:addTimeSignature(event)
					end
				end
			end
		end
		
	end,
}