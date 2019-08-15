class "Player" {
	new = function (self, song)
		self.song = song
		
		self.paused = true
		self.isMovingForward = true
		
		self.initialTime = 0
		self.endTime = self.song:getEndTime()
		
		self.timeManager = TimeManager(self)
		
		self.playbackSpeed = 1
		
		self.lastPlayedEventIDs = {}
		self.firstNonPlayedNoteIDInTracks = {}
		self.firstNonFinishedNoteIDInTracks = {}
		self.currentPitchBendIDInTracks = {}
		self.previousPitchBendValueInTracks = {}
		self.currentPitchBendValueInTracks = {}
		self.isPitchBendValueInTracksIncreasing = {}
		self.firstNonStartedMeasureID = nil
		
		self:initialzeStates()
	end,
	
	loadSongFromFile = function (self, file)
		file:open("r")
		
		self:pause()
		self.song = MIDIParser:parse(file:read(file:getSize()))
		self.timeManager = TimeManager(self)
		self.initialTime = 0
		self.endTime = self.song:getEndTime()
		self:initialzeStates()
		self:moveToBeginning()
		
		file:close()
	end,
	
	loadSongFromPath = function (self, path)
		-- local file = io.open(path, "rb")
	end,
	
	sendMIDIMessage = function (self, event)
		if event:getType() < 0xF0 then
			-- not to send meta events
			
			if not displayComponentsRenderer:getIsExportingVideo() then
				-- no need to send MIDI message if it is rendering
				
				local eventType = event:getType()
				if not (self.paused and eventType >= 0x80 and eventType <= 0x9F) then
					midi.sendMessage(0, eventType, event:getMsg1(), event:getMsg2() or 0)
				end
			end
		end
	end,
	
	getIsMovingForward = function (self)
		return self.isMovingForward
	end,
	
	update = function (self, dt)
		---------- Playback the MIDI song and update the last played event ID of each track
		local time = self.timeManager:getTime()
		-- TODO: Set the intial index of the searching (i.e. j = ?) as the next one of the last played event
		
		for i = 1, #self.song:getTracks() do
			local track = self.song:getTrack(i)
			
			if track:getEnabled() then
				if self.isMovingForward then
					for j = self.lastPlayedEventIDs[i]+1, #track:getRawEvents() do
						local event = track:getRawEvent(j)
						
						if time >= event:getTime() then
							self:sendMIDIMessage(event)
							self.lastPlayedEventIDs[i] = j
						else
							break
						end
					end
				else
					for j = self.lastPlayedEventIDs[i], 1, -1 do
						local event = track:getRawEvent(j)
						
						if time <= event:getTime() then
							self.lastPlayedEventIDs[i] = j - 1
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
			
			if self.isMovingForward then
				for pbID = self.currentPitchBendIDInTracks[trackID], #pitchBends do
					local pitchBend = pitchBends[pbID]
					
					local pbTime = pitchBend:getTime()
					
					if time >= pbTime then
						self.currentPitchBendIDInTracks[trackID] = pbID
					else
						break
					end
				end
			else
				
				for pbID = self.currentPitchBendIDInTracks[trackID]-1, 1, -1 do
					local pitchBend = pitchBends[pbID]
					
					local pbTime = pitchBend:getTime()
					
					if time <= pbTime then
						self.currentPitchBendIDInTracks[trackID] = pbID
					else
						break
					end
				end
			end
			
			if #pitchBends > 0 then
				local curPBID = self.currentPitchBendIDInTracks[trackID]
				local curPB = pitchBends[curPBID]
				
				self.currentPitchBendValueInTracks[trackID] = curPB:getSignedValue()
			end
		end
		
		------------- Update first non-played note ID of each track
		for trackID = 1, #tracks do
			local notes = tracks[trackID]:getNotes()
			
			if self.isMovingForward then
				for noteID = self.firstNonPlayedNoteIDInTracks[trackID], #notes do
					local note = notes[noteID]
					local noteTime = note:getTime()
					
					if noteTime <= time then
						self.firstNonPlayedNoteIDInTracks[trackID] = math.max(noteID+1, self.firstNonPlayedNoteIDInTracks[trackID])
					else
						break
					end
				end
			else
			
				for noteID = self.firstNonPlayedNoteIDInTracks[trackID]-1, 1, -1 do
					local note = notes[noteID]
					local noteTime = note:getTime()
					
					if noteTime >= time then
						self.firstNonPlayedNoteIDInTracks[trackID] = noteID
					else
						break
					end
				end
			end
		end
		
		------------- Update first non-finished note ID of each track
		for trackID = 1, #tracks do
			local notes = tracks[trackID]:getNotes()
			
			if self.isMovingForward then
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
			else
			
				for noteID = self.firstNonFinishedNoteIDInTracks[trackID]-1, 1, -1 do
					local note = notes[noteID]
						
					local noteTime = note:getTime()
					local noteLength = note:getLength() or 0
					
					if noteTime + noteLength >= time then
						self.firstNonFinishedNoteIDInTracks[trackID] = noteID
					else
						break
					end
				end
			end
		end
		
		---------- Update lastStartedMeasure
		local measures = song:getMeasures()
		
		if self.isMovingForward then
			for measureID = self.firstNonStartedMeasureID, #measures do
				if time < measures[measureID]:getTime() then
					self.firstNonStartedMeasureID = measureID
					break
				end
			end
		else
			
			for measureID = self.firstNonStartedMeasureID, 1, -1 do
				if time < measures[measureID]:getTime() then
					self.firstNonStartedMeasureID = measureID
				else
					break
				end
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
	
	initialzeStates = function (self)
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
	
	finalizeStates = function (self)
		local tracks = self.song:getTracks()
		
		for i = 1, #tracks do
			self.lastPlayedEventIDs[i] = #self.song:getTrack(i):getRawEvents()
			self.firstNonPlayedNoteIDInTracks[i] = #self.song:getTrack(i):getNotes() + 1
			self.firstNonFinishedNoteIDInTracks[i] = #self.song:getTrack(i):getNotes() + 1
			self.currentPitchBendIDInTracks[i] = math.max(#self.song:getTrack(i):getPitchBends(), 1)
			self.previousPitchBendValueInTracks[i] = 0	-- TODO: Need to revise if this state will be used in the future
			self.currentPitchBendValueInTracks[i] = 0	-- TODO: Need to revise if this state will be used in the future
			self.isPitchBendValueInTracksIncreasing[i] = 0	-- TODO: Need to revise if this state will be used in the future
			self.firstNonStartedMeasureID = math.max(#self.song:getMeasures(), 1)
		end
	end,
	
	pause = function (self)
		self.paused = true
		self:mute()
	end,
	
	resume = function (self)
		self.paused = false
		self.isMovingForward = true
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
		self:moveToTime(self.initialTime)
		self:initialzeStates()
	end,
	
	moveToEnd = function (self)
		self:moveToTime(self.endTime)
		self:finalizeStates()
	end,
	
	moveToTime = function(self, time)
		self:pause()
		self.isMovingForward = ( time >= self.timeManager:getTime() )
		self.timeManager:setTime(time)
	end,
	
	getInitialTime = function (self)
		return self.initialTime
	end,
	
	getEndTime = function (self)
		return self.endTime
	end,
}