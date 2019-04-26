class "TimeSignature" extends "Event"{
	private {
		numerator = NULL,
		denominator = NULL,
	},
	
	public {
		__construct = function (self, time, type, msg1, msg2)
			self.Event(time, type, msg1, msg2)
			
			self.numerator = string.byte(string.sub(msg2, 1,1))
			self.denominator = 2^string.byte(string.sub(msg2, 2,2))
		end,
		
		getNumerator = function (self)
			return self.numerator
		end,
		
		getDenominator = function (self)
			return self.denominator
		end,
	},
}
