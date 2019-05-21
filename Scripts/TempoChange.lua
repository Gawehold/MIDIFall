class "TempoChange" {
	new = function (self, time, msg1, msg2)
		self.time = time
		
		local str = ""
		
		for i = 1, 3 do	-- should be 1 to 3
			str = str .. string.format("%02X", string.byte(msg2, i,i))
		end
		
		self.tempo = 60000000.0 / tonumber(str, 16)	-- 60000000.0 is amount of microsecond per minute
	end,
	
	getTime = function (self)
		return self.time
	end,
	
	getTempo = function (self)
		return self.tempo
	end,
}
