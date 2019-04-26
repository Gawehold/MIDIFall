class "Player" {
	private {
		song = NULL,
		timeManager = NULL,
		
		playbackSpeed = NULL,
	},
	
	public {
		__construct = function (self, song)
			self.song = song
			self.timeManager = TimeManager.new(self)
			
			self.playbackSpeed = 1.0
		end,
		
		update = function (self, dt)
			self.timeManager:update(dt)
		end,
		
		getSong = function (self)
			return self.song
		end,
		
		getTimeManager = function (self)
			return self.timeManager
		end,
		
		getPlaybackSpeed = function (self)
			return self.playbackSpeed
		end,
	},
}