class "PitchBend" {
	new = function (self, time, signedValue)
		self.time = time
		self.signedValue = signedValue
	end,
	
	getTime = function (self)
		return self.time
	end,
	
	getSignedValue = function (self)
		return self.signedValue
	end,
}