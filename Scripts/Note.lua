class "Note" {
	private {
		time = NULL,
		length = NULL,
		pitch = NULL,
		velocity = NULL,
	},
	
	public {
		__construct = function (self, time, endTime, pitch, velocity)
			self.time = time
			self.length = endTime - time
			self.pitch = pitch
			self.velocity = velocity
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
	},
}