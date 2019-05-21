local ffi = require "ffi"

ffi.cdef[[
typedef struct {
	const uint64_t time;
	const uint64_t length;
	const uint8_t pitch;
	const uint8_t velocity;
	const uint8_t channel;
	bool played;
} Note;
]]

Note = ffi.metatype("Note", {
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
})