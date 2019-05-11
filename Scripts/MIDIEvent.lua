local ffi = require("ffi")
ffi.cdef[[
typedef struct {
	const uint64_t time;
	const uint8_t type;
	const uint8_t msg1;
	bool played;
	uint8_t msg2[?];
} MIDIEvent;
]]

MIDIEvent = ffi.metatype("MIDIEvent", {
	__index = {
		getTime = function (self)
			return tonumber(self.time)
		end,
		
		getType = function (self)
			return tonumber(self.type)
		end,
		
		getMsg1 = function (self)
			return tonumber(self.msg1)
		end,
		
		getMsg2 = function (self)
			if self.msg2 == nil then
				return nil
			end
		
			if self.type >= 0xF0 then
				return ffi.string(self.msg2)
			else
				return self.msg2[0]
			end
		end,
		
		getPlayed = function (self)
			return self.played
		end,
		
		setPlayed = function (self, played)
			self.played = played
		end,
	}
})