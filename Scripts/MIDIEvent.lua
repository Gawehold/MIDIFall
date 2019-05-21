ffi.cdef[[
typedef struct {
	const uint64_t time;
	const uint8_t type;
	const uint8_t msg1;
	const uint8_t msg2Size;
	const uint8_t *msg2;
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
		
		getMsg2Size = function (self)
			return tonumber(self.msg2Size)
		end,
		
		getMsg2 = function (self)
			if self.msg2 == nil then
				return nil
			end
		
			if self.type >= 0xF0 then
				return ffi.string(self.msg2, self.msg2Size)
			else
				return self.msg2[0]
			end
		end,
	}
})