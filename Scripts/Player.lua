class "Player" {
	private {
		song = NULL,
		midiSong = NULL,
		
		timeManager = NULL,
		
		playbackSpeed = NULL,
	},
	
	public {
		__construct = function (self, song, midiSong)
			self.song = song
			self.midiSong = midiSong
			self.timeManager = TimeManager.new(self)
			
			self.playbackSpeed = 1.0
		end,
		
		update = function (self, dt)
			local time = self.timeManager:getTime()
			-- TODO: Set the intial index of the searching (i.e. j = ?) as the next one of the last played event
			for i = 1, #self.midiSong:getTracks() do
				local track = self.midiSong:getTrack(i)
				
				for j = track:getLastPlayedEventID()+1, #track:getEvents() do
					local event = track:getEvent(j)
					
					if time >= event:getTime() then
						if event:getType() < 0xF0 and not event:getPlayed() then
							midi.sendMessage(0, event:getType(), event:getMsg1(), event:getMsg2() or 0)
							
							track:setLastPlayedEventID(j)
							event:setPlayed(true)
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
	},
}