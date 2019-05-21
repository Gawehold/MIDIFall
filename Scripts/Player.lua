class "Player" {
	new = function (self, song)
		self.song = song
		self.timeManager = TimeManager(self)
		
		self.playbackSpeed = 1.0
		
		self.lastPlayedEventIDs = {}
		for i = 1, #self.song:getTracks() do
			self.lastPlayedEventIDs[i] = 0
		end
	end,

	update = function (self, dt)
		local time = self.timeManager:getTime()
		-- TODO: Set the intial index of the searching (i.e. j = ?) as the next one of the last played event
		for i = 1, #self.song:getTracks() do
			local track = self.song:getTrack(i)
			
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
}