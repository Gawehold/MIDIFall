class "MIDISong" {
	new = function (self, formatType, timeDivision)
		self.formatType = formatType
		self.timeDivision = timeDivision
		
		self.tracks = {}
		self.sortedTracks = {}
		self.tempoChanges = {}
		self.timeSignatures = {}
		self.measures = {}
		
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
	
	addMeasure = function (self, measure)
		self.measures[#self.measures+1] = measure
	end,
	
	getMeasures = function (self)
		return self.measures
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
			
			-- Set the default tracks colour
			track.customColourHSV = {(i-1)/(#self:getTracks()-1),0.8,0.8}
		end
		
		-- Initialize the measures
		local currentMeasureTime = 0
		local currentMeasureLength = 0
		local currentTimeSignature = TimeSignature(0, 0x58, string.char(4,2))
		
		for measureID = 1, math.huge do
			for tsID, ts in ipairs(self.timeSignatures) do
				local tsTime = ts:getTime()
				
				if currentMeasureTime >= tsTime then
					currentTimeSignature = ts
				else
					break
				end
			end
			
			currentMeasureLength = 4 * self.timeDivision * (currentTimeSignature:getNumerator() / currentTimeSignature:getDenominator())
			self:addMeasure(Measure(currentMeasureTime))
			
			currentMeasureTime = currentMeasureTime + currentMeasureLength
			
			if currentMeasureTime > self.endTime then
				break
			end
		end
		
		-- Initialize the sorted tracks list
		self:sortTracks()
	end,
	
	getSortedTracks = function (self)
		return self.sortedTracks
	end,
	
	sortTracks = function (self)
		for i, track in ipairs(self.tracks) do
			self.sortedTracks[i] = track
		end
		
		table.sort(self.sortedTracks, function (a, b)
			return a.priority < b.priority
		end)
	end,
	
	setTrackPriority = function (self, trackID, priority)
		self.tracks[trackID]:setPriority(priority)
		
		self:sortTracks()
	end,
}