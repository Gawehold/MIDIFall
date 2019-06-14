ffi.cdef[[
typedef struct {
	const uint64_t time;
} Measure;
]]

Measure = ffi.metatype("Measure", {
	__index = {
		getTime = function (self)
			return tonumber(self.time)
		end,
	}
})