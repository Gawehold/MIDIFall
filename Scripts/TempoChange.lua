class "TempoChange" extends "Event"{
	private {
		tempo = NULL,
	},
	
	public {
		__construct = function (self, time, type, msg1, msg2)
			self.Event(time, type, msg1, msg2)
			
			local str = ""
			for i = 1, string.len(msg2) do	-- should be 1 to 3
				str = str .. string.format("%02X", string.byte(msg2, i,i))
			end
			self.tempo = 60000000.0 / tonumber(str, 16)	-- 60000000.0 is amount of microsecond per minute
		end,
		
		getTempo = function (self)
			return self.tempo
		end,
	},
}
