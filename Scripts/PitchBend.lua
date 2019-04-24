class "PitchBend" {
	private {
		time = NULL,
		signedValue = NULL,
	},
	
	public {
		__construct = function (self, time, signedValue)
			self.time = time
			self.signedValue = signedValue
		end,
		
		getTime = function (self)
			return self.time
		end,
		
		getSignedValue = function (self)
			return self.signedValue
		end,
	},
}