class "Player" {
	new = function (self, song)
		self.song = song
		self.timeManager = TimeManager(self)
		
		self.playbackSpeed = 1.0
		
		local tracks = self.song:getTracks()
		
		self.lastPlayedEventIDs = {}
		for i = 1, #tracks do
			self.lastPlayedEventIDs[i] = 0
		end
		
		self.firstNonFinishedNoteIDInTracks = {}
		for i = 1, #tracks do
			self.firstNonFinishedNoteIDInTracks[i] = 1
		end
		
		self.lastPitchBendIDInTracks = {}
		self.currentPitchBendValueInTracks = {}
		for i = 1, #tracks do
			self.lastPitchBendIDInTracks[i] = 1
			self.currentPitchBendValueInTracks[i] = 0
		end
	end,

	update = function (self, dt)
		---------- Playback the MIDI song and update the last played event ID of each track
		local time = self.timeManager:getTime()
		-- TODO: Set the intial index of the searching (i.e. j = ?) as the next one of the last played event
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
		
		---------- Update the last pitch bend event ID and current pitch bend value of each track
		local song = player:getSong()
		local tracks = song:getTracks()
		
		for trackID = 1, #tracks do
			local pitchBends = tracks[trackID]:getPitchBends()
			
			for pbID = self.lastPitchBendIDInTracks[trackID], #pitchBends do
				local pitchBend = pitchBends[pbID]
				
				local pbTime = pitchBend:getTime()
				
				if time >= pbTime then
					self.lastPitchBendIDInTracks[trackID] = pbID
				else
					break
				end
			end
			
			if #pitchBends > 0 then
				local curPBID = self.lastPitchBendIDInTracks[trackID]
				local curPB = pitchBends[curPBID]
				
				if #pitchBends >= self.lastPitchBendIDInTracks[trackID] + 1 then	
					local nextPB = pitchBends[curPBID+1]
					
					-- Linear Interpolation
					self.currentPitchBendValueInTracks[trackID] = ((time-curPB:getTime())*pitchBends[curPBID]:getSignedValue() + (nextPB:getTime()-time)*pitchBends[curPBID+1]:getSignedValue()) / (nextPB:getTime()-curPB:getTime())
				else
					self.currentPitchBendValueInTracks[trackID] = curPB:getSignedValue()
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
				
				if noteTime + noteLength < time then
					self.firstNonFinishedNoteIDInTracks[trackID] = math.max(noteID+1, self.firstNonFinishedNoteIDInTracks[trackID])
					break
				end
			end
		end
		
		------------ Update the time --------
		self.timeManager:update(dt)
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
	
	getfirstNonFinishedNoteIDInTracks = function (self)
		return self.firstNonFinishedNoteIDInTracks
	end,
	
	getCurrentPitchBendValueInTracks = function (self)
		return self.currentPitchBendValueInTracks
	end,
}