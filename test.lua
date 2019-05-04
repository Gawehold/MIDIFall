-- require "Libraries/SIMPLOO/dist/simploo"
-- simploo.config["production"] = true
-- simploo.config["exposeSyntax"] = false

-- class "Foo1" {
	-- public {
		-- x = 0,
		
		-- __construct = function (self)
			
		-- end,
		
		-- bar = function (self)
			-- if math.floor(self.x) % 2 == 0 then
				-- self.x = self.x + 1
			-- else
				-- self.x = self.x + 2
			-- end
		-- end,
	-- },
-- }
------------------------------------------------
local pie = require "Libraries/lua-pie/init"
local class = pie.class
local public = pie.public
local private = pie.private

class "Foo1" {
	public {
		constructor = function (self)
			self.x = 0
		end,
		
		bar = function (self)
			if math.floor(self.x) % 2 == 0 then
				self.x = self.x + 1
			else
				self.x = self.x + 2
			end
		end,
	},
}
local Foo1 = pie.import("Foo1")
---------------------------------------------

local Object = require "Libraries/Classic/classic"
local Foo2 = Object:extend()

function Foo2:new()
	self.x = 0
end

function Foo2:bar()
	if math.floor(self.x) % 2 == 0 then
		self.x = self.x + 1
	else
		self.x = self.x + 2
	end
end
--------------------------------
local ffi = require("ffi")
ffi.cdef("typedef struct { int x;} Foo3;")

local mt = {
	__index = {
		bar = function (self)
			if math.floor(self.x) % 2 == 0 then
				self.x = self.x + 1
			else
				self.x = self.x + 2
			end
		end,
	},
}
Foo3 = ffi.metatype("Foo3", mt)

-----------------------------------------

local events = {}



for i = 1, 5e5 do
	-- events[i] = Foo2()
	events[i] = Foo1()
	-- events[i] = Foo3(0)
	-- events[1]:bar()
	
	-- events[i] = {x=0, new = function(self) self.x=0 end, bar = function (self) print(self.x) end}
end

local x = os.clock()
for i = 1, 5e5 do
	events[i]:bar()
end

-- events[1].str = ffi.new("char[3]", "ah")
-- print(ffi.sizeof(events[1]))
-- print(events[1].x)
-- print(ffi.string(events[1].str))
print(string.format("elapsed time: %.2f\n", os.clock() - x))

-- while true do end

--[[
5e5 instances
Lib		SIMPLOO			lua-pie		Classic		FFI
Time	4.87s			0.11s		0.07s		0.02s
RAM		1,141,944K		98,512K		51,628K		20,376K
]]