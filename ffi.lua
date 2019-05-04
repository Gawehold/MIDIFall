local ffi = require("ffi")

ffi.cdef[[
void *malloc(size_t size);
void free(void *ptr);
int system(const char *command);
typedef struct {
  char *fpos;
  void *base;
  unsigned short handle;
  short flags;
  short unget;
  unsigned long alloc;
  unsigned short buffincrement;
} FILE;
FILE *popen(const char *command, const char *type); 
int pclose(FILE *stream); 
]]

local fp = ffi.C.system("dir");

os.execute("ffmpeg")

-- local N = 5e8
-- local arr = ffi.cast("double *", ffi.C.malloc(N*ffi.sizeof("double")))
-- assert(arr ~= nil, "out of memory")

-- for i = 0, N-1 do
	-- arr[i] = i
-- end

-- while true do end

-- ffi.C.free(arr)

-- local Human = {
	-- __index = function(self,key)
		-- return self.__private.key
	-- end,
-- }

-- local david = setmetatable({
	-- __private = {},
	-- __public = {},
	-- __protected = {},
	-- }, Human)
-- print(david.x)

-- local mt = {
	-- y=7,
	
	-- __index = function(self, key)
		-- if key == "x" then
			-- error("Didn't initialized")
		-- else
			-- error("Doesn't exist")
		-- end
	-- end,
	
	-- __newindex = function (self, key, value)
		-- if key == "x" then
			-- rawset(self, key, value)
		-- else
			-- error("Doesn't exist")
		-- end
	-- end,
-- }

-- local obj = setmetatable({}, mt)

-- obj.x = 50
-- print(obj.y)