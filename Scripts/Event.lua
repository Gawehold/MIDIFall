class "Event" {
	private {
		time = NULL,
		type = NULL,
		msg1 = NULL,
		msg2 = NULL,
		played = NULL,
	},
	
	public {
		__construct = function (self, time, type, msg1, msg2)
			self.time = time
			self.type = type
			self.msg1 = msg1
			self.msg2 = msg2
			
			self.played = false
			-- print(self.time,self.type,self.msg1,self.msg2)
		end,
		
		getTime = function (self)
			return self.time
		end,
		
		getType = function (self)
			return self.type
		end,
		
		getMsg1 = function (self)
			return self.msg1
		end,
		
		getMsg2 = function (self)
			return self.msg2
		end,
		
		getPlayed = function (self)
			return self.played
		end,
		
		setPlayed = function (self, played)
			self.played = played
		end,
	},
}
