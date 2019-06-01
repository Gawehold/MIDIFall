local ffi = require "ffi"

ffi.cdef[[
typedef struct {
	const uint64_t time;
	const uint64_t length;
	const uint8_t pitch;
	const uint8_t velocity;
	const uint8_t channel;
} Note;
]]

Note = ffi.metatype("Note", {
	__index = {
		getTime = function (self)
			return tonumber(self.time)
		end,
		
		getLength = function (self)
			return tonumber(self.length)
		end,
		
		getPitch = function (self)
			return tonumber(self.pitch)
		end,
		
		getVelocity = function (self)
			return tonumber(self.velocity)
		end,
		
		getChannel = function (self)
			return tonumber(self.channel)
		end,
	}
})