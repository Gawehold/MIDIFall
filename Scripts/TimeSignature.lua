class "TimeSignature" {
	new = function (self, time, msg1, msg2)
		self.time = time
		
		self.numerator = string.byte(string.sub(msg2, 1,1))
		self.denominator = 2^string.byte(string.sub(msg2, 2,2))
	end,
	
	getTime = function (self)
		return self.time
	end,
	
	getNumerator = function (self)
		return self.numerator
	end,
	
	getDenominator = function (self)
		return self.denominator
	end,
}
