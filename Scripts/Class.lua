local metaTable = {
	__index = function (self, key)
		if self.members[key] == nil then
			if key == "new" then
				error(string.format("Class %s do not has a constructor.", self.class))
			else
				error(string.format("Member \"%s\" does not exist in class \"%s\".", key, self.class))
			end
		else
			return self.members[key]
		end
	end,
	
	__newindex = function (self, key, value)
		if type(value) == "function" then
			error("You cannot define a new method.")
		end
		
		if type(self.members[key]) == "function" then
			error("You cannot modify a method.")
		end
		
		self.members[key] = value
	end,
	
	-- __tostring = function (self)
		-- return string.format("%s: %s", self.class, (self.__rawtostring:match("%d.+")))
	-- end,
}

function class(className)
	return function (classDefinition)
		_G[className] = setmetatable(
			{
				class = className,
				-- __rawtostring = tostring(self),
				static = classDefinition.static,
			},
			{
				__index = function (self, key)
					if self.static[key] == nil then
						error(string.format("Static member \"%s\" does not exist in class \"%s\".", key, self.class))
					else
						return self.static[key]
					end
				end,
				
				__newindex = function (self, key, value)
					if self.static[key] == nil then
						-- error("You cannot define new object members.")
						self.static[key] = value
					else
						-- error("You cannot modify a object member directly.")
					end
				end,
				
				__call = function(self, ...)
					local obj = setmetatable(
						{
							class = className,
							-- __rawtostring = tostring(self),
							members = {},
						},
						metaTable
					)
					
					for k, v in pairs(classDefinition) do
						obj.members[k] = v
					end
					
					obj:new(...)
					
					return obj
				end
			}
		)
	end
end

-- class "Foo" {
	-- static = {
		-- hahaha = function (self)
			-- print("hahaha")
		-- end,
	-- },

	-- new = function (self)
		-- self.x = 0
	-- end,
	
	-- bar = function (self)
		-- if math.floor(self.x) % 2 == 0 then
			-- self.x = self.x + 1
		-- else
			-- self.x = self.x + 2
		-- end
	-- end,
-- }

-- class "Qoo" {
	-- new = function (self)
	-- end,
-- }

-- local q = Qoo()
-- q.x = 19
-- print(q.x)
-- q.x = 15
-- print(q.x)

-- local f1 = Foo()
-- f1.x = 1

-- local f2 = Foo()

-- print(f1.x)

-- local events = {}

-- local x = os.clock()
-- for i = 1, 5e5 do
	-- events[i] = Foo()
-- end

-- for i = 1, 5e5 do
	-- Foo:hahaha()
-- end
-- print(string.format("elapsed time: %.2f", os.clock() - x))