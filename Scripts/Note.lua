class "Note" extends "Event" {
	private {
		time = NULL,
		length = NULL,
		pitch = NULL,
		velocity = NULL,
		played = NULL,
		channel = NULL,
	},
	
	public {
		__construct = function (self, time, endTime, pitch, velocity, channel)
			self.time = time
			self.length = endTime - time
			self.pitch = pitch
			self.velocity = velocity
			self.channel = channel
			
			self.played = false
		end,
		
		getTime = function (self)
			return self.time
		end,
		
		getLength = function (self)
			return self.length
		end,
		
		getPitch = function (self)
			return self.pitch
		end,
		
		getVelocity = function (self)
			return self.velocity
		end,
		
		getChannel = function (self)
			return self.channel
		end,
		
		getPlayed = function (self)
			return self.played
		end,
		
		setPlayed = function (self, played)
			self.played = played
		end,
	},
}