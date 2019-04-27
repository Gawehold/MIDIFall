require "Libraries/SIMPLOO/dist/simploo"
simploo.config["production"] = true
simploo.config["exposeSyntax"] = false
local Object = require "Libraries/Classic/classic"

class "Foo1" {
	private {
		x = false
	},
	
	public {
		__construct = function (self)
			self.x = 0
		end,
		
		bar = function (self)
			print(self.x)
		end,
	},
}

local Foo2 = Object:extend()

function Foo2:new()
	self.x = 0
end

function Foo2:bar()
	print(self.x)
end

local events = {}

local x = os.clock()
for i = 1, 1e5 do
	events[i] = Foo2()
	-- events[i] = Foo1.new()
	-- events[i] = {x=0, new = function(self) self.x=0 end, bar = function (self) print(self.x) end}
end
print(events[1].bar, events[2].bar)
print(string.format("elapsed time: %.2f\n", os.clock() - x))

-- while true do end