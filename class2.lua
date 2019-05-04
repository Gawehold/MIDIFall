local ObjectMetaTable = {
	__index = function(self, key)
		if self.__public[key] == nil then
			if self.__private[key] ~= nil then
				error("You are not allowed to access private field.")
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
				error("You are not allowed to access private field.")
			else
				error("Doesn't have this field.")
			end
		else
			rawset(self.__public, key, value)
		end
	end,
}

local function Foo()
	local obj = {}
	return setmetatable(obj, ObjectMetaTable)
end