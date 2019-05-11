local metaTable = {
	__index = {
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
	}
}

Note = function (time, endTime, pitch, velocity, channel)
	local obj = {}
	
	obj.time = time
	obj.length = endTime - time
	obj.pitch = pitch
	obj.velocity = velocity
	obj.channel = channel
	
	obj.played = false
			
	return setmetatable(obj, metaTable)
end