local barF = function (self)
	if math.floor(self.x) % 2 == 0 then
		self.x = self.x + 1
	else
		self.x = self.x + 2
	end
end

local ObjectMetaTable = {
	__index = function(self, key)
		if self.__public[key] == nil then
			if self.__private[key] ~= nil then
				error("You are not allowed to access private fields.")
			else
				error("Doesn't have this field.")
			end
		else
			return rawget(self.__public, key)
		end
	end,
	
	__newindex = function(self, key, value)
		if self.__public[key] == nil then
			if self.__private[key] ~= nil then
				error("You are not allowed to access private fields.")
			else
				error("Doesn't have this field.")
			end
		else
			rawset(self.__public, key, value)
		end
	end,
}

local function Foo()
	local obj = {
		__private = {},
		__public = {x=0, bar = barF},
	}
	return setmetatable(obj, ObjectMetaTable)
end

-- local david = setmetatable(DeepCopy(Object), ObjectMetaTable)
-- local peter = setmetatable(DeepCopy(Object), ObjectMetaTable)

local events = {}

local x = os.clock()

for i = 1, 5e5 do
	events[i] = Foo()
	events[1]:bar()
end
print(events[1].x)
print(string.format("elapsed time: %.2f\n", os.clock() - x))
print(events[1].bar == events[2].bar)

print(math.mininteger)

-- while true do end