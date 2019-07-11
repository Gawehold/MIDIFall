class "Player" {
	new = function (self, song)
		self.song = song
		self.timeManager = TimeManager(self)
		
		self.paused = true
		
		self.playbackSpeed = 1
		
		self.lastPlayedEventIDs = {}
		self.firstNonPlayedNoteIDInTracks = {}
		self.firstNonFinishedNoteIDInTracks = {}
		self.currentPitchBendIDInTracks = {}
		self.previousPitchBendValueInTracks = {}
		self.currentPitchBendValueInTracks = {}
		self.isPitchBendValueInTracksIncreasing = {}
		self.firstNonStartedMeasureID = nil
		
		self:initiailzeStates()
	end,

	update = function (self, dt)
		---------- Playback the MIDI song and update the last played event ID of each track
		local time = self.timeManager:getTime()
		-- TODO: Set the intial index of the searching (i.e. j = ?) as the next one of the last played event
		
		if not self.paused then
			for i = 1, #self.song:getTracks() do
				local track = self.song:getTrack(i)
				
				if track:getEnabled() then			
					for j = self.lastPlayedEventIDs[i]+1, #track:getRawEvents() do
						local event = track:getRawEvent(j)
						
						if time >= event:getTime() then
							if event:getType() < 0xF0 then
								midi.sendMessage(0, event:getType(), event:getMsg1(), event:getMsg2() or 0)
								
								self.lastPlayedEventIDs[i] = j
							end
						else
							break
						end
					end
				end
			end
		end
		
		---------- Update the last pitch bend event ID and current pitch bend value of each track
		local song = player:getSong()
		local tracks = song:getTracks()
		
		for trackID = 1, #tracks do
			local pitchBends = tracks[trackID]:getPitchBends()
			
			for pbID = self.currentPitchBendIDInTracks[trackID], #pitchBends do
				local pitchBend = pitchBends[pbID]
				
				local pbTime = pitchBend:getTime()
				
				if time >= pbTime then
					self.currentPitchBendIDInTracks[trackID] = pbID
				else
					break
				end
			end
			
			if #pitchBends > 0 then
				local curPBID = self.currentPitchBendIDInTracks[trackID]
				local curPB = pitchBends[curPBID]
				
				if #pitchBends >= self.currentPitchBendIDInTracks[trackID] + 1 then	
					local nextPB = pitchBends[curPBID+1]
					
					-- Linear Interpolation
					self.currentPitchBendValueInTracks[trackID] = ((time-curPB:getTime())*pitchBends[curPBID]:getSignedValue() + (nextPB:getTime()-time)*pitchBends[curPBID+1]:getSignedValue()) / (nextPB:getTime()-curPB:getTime())
				else
					self.currentPitchBendValueInTracks[trackID] = curPB:getSignedValue()
				end
			end
			
			-- Check whether the pitchbend value is increasing or decreasing
			-- local difference = self.currentPitchBendValueInTracks[trackID] - self.previousPitchBendValueInTracks[trackID]
			-- if math.abs(difference) > 0.1 then
				-- if difference > 0 then
					-- self.isPitchBendValueInTracksIncreasing[trackID] = 1
				-- else
					-- self.isPitchBendValueInTracksIncreasing[trackID] = -1
				-- end
			-- else
				-- self.isPitchBendValueInTracksIncreasing[trackID] = 0
			-- end
			-- -- print(self.previousPitchBendValueInTracks[trackID],self.currentPitchBendValueInTracks[trackID],self.currentPitchBendValueInTracks[trackID] > self.previousPitchBendValueInTracks[trackID])
			
			-- self.previousPitchBendValueInTracks[trackID] = self.currentPitchBendValueInTracks[trackID]
		end
		
		------------- Update first non-played note ID of each track
		for trackID = 1, #tracks do
			local notes = tracks[trackID]:getNotes()
			for noteID = self.firstNonPlayedNoteIDInTracks[trackID], #notes do
				local note = notes[noteID]
				local noteTime = note:getTime()
				
				if noteTime <= time then
					self.firstNonPlayedNoteIDInTracks[trackID] = math.max(noteID+1, self.firstNonPlayedNoteIDInTracks[trackID])
				else
					break
				end
			end
		end
		
		------------- Update first non-finished note ID of each track
		for trackID = 1, #tracks do
			local notes = tracks[trackID]:getNotes()
			for noteID = self.firstNonFinishedNoteIDInTracks[trackID], #notes do
				local note = notes[noteID]
					
				local noteTime = note:getTime()
				local noteLength = note:getLength() or 0
				
				if noteTime + noteLength <= time then
					self.firstNonFinishedNoteIDInTracks[trackID] = math.max(noteID+1, self.firstNonFinishedNoteIDInTracks[trackID])
				else
					break
				end
			end
		end
		
		---------- Update lastStartedMeasure
		local measures = song:getMeasures()
		
		self.firstNonStartedMeasureID = #measures + 1
		for measureID = self.firstNonStartedMeasureID, #measures do
			if time < measures[measureID]:getTime() then
				self.firstNonStartedMeasureID = measureID
				break
			end
		end
		
		------------ Update the time --------
		if not self.paused then
			self.timeManager:update(dt)
		end
	end,

	getSong = function (self)
		return self.song
	end,

	getMIDISong = function (self)
		return self.midiSong
	end,

	getTimeManager = function (self)
		return self.timeManager
	end,

	getPlaybackSpeed = function (self)
		return self.playbackSpeed
	end,
	
	getFirstNonPlayedNoteIDInTracks = function (self)
		return self.firstNonPlayedNoteIDInTracks
	end,
	
	getFirstNonFinishedNoteIDInTracks = function (self)
		return self.firstNonFinishedNoteIDInTracks
	end,
	
	getCurrentPitchBendValueInTracks = function (self)
		return self.currentPitchBendValueInTracks
	end,
	
	getIsPitchBendValueInTracksIncreasing = function (self)
		return self.isPitchBendValueInTracksIncreasing
	end,
	
	getFirstNonStartedMeasureID = function (self)
		return self.firstNonStartedMeasureID
	end,
	
	initiailzeStates = function (self)
		local tracks = self.song:getTracks()
		
		for i = 1, #tracks do
			self.lastPlayedEventIDs[i] = 0
			self.firstNonPlayedNoteIDInTracks[i] = 1
			self.firstNonFinishedNoteIDInTracks[i] = 1
			self.currentPitchBendIDInTracks[i] = 1
			self.previousPitchBendValueInTracks[i] = 0
			self.currentPitchBendValueInTracks[i] = 0
			self.isPitchBendValueInTracksIncreasing[i] = 0
			self.firstNonStartedMeasureID = 1
		end
	end,
	
	pause = function (self)
		self.paused = true
		self:mute()
	end,
	
	resume = function (self)
		self.paused = false
	end,
	
	pauseOrResume = function (self)
		if self.paused then
			self:resume()
		else
			self:pause()
		end
	end,
	
	mute = function (self)
		for chID = 0, 15 do
			midi.sendMessage(0, 0xB0+chID, 120, 0)
		end
	end,
	
	moveToBeginning = function (self)
		self:moveToTime(0)
	end,
	
	moveToEnd = function (self)
		self:moveToTime(self.song:getEndTime())
	end,
	
	moveToTime = function(self, time)
		local needToResetStates = false
		
		if time < self.timeManager:getTime() then
			needToResetStates = true
		end
		
		self.timeManager:setTime(time)
		
		if needToResetStates then
			self:initiailzeStates()
		end
	end,
}