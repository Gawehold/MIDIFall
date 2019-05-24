local namespace = _G

local objectMetaTable = {
	__index = function (self, key)
		local field = self.fields[key]
		local method = self.methods[key]
		
		if method == nil then
			if key == "new" then
				error(string.format("Class %s do not has a constructor.", self.class.name))
			end
			
			if field == nil then
				error(string.format("Non-static member \"%s\" does not exist in class \"%s\".", key, self.class.name))
			else
				return field
			end
		else
			return method
		end
	end,
	
	__newindex = function (self, key, value)
		local field = self.fields[key]
		local method = self.method[key]
		
		if type(value) == "function" then
			error("You cannot define a new method.")
		end
		
		if method ~= nil then
			error("You cannot modify a method.")
		end
		
		if field == nil then
			error("You cannot define a new member.")
		end
		
		self.field[key] = value
	end,
	
	-- __tostring = function (self)
		-- return string.format("%s: %s", self.class, (self.__rawtostring:match("%d.+")))
	-- end,
}

function extends(parentName)
	return {"extends", namespace[parentName]}
end

function static(t)
	return {"static", t}
end

function buildClass(className, classDefinition)
	for k, v in pairs(classDefinition) do
		if type(v) == "table" then
			if v[1] ~= "extends" and v[1] ~= "static" then
				error("You can only define functions in a class definition.")
			end
		elseif type(v) ~= "function" then
			error("You can only define functions in a class definition.")
		end
	end
	
	classDefinition.parent = namespace["Object"]
	classDefinition.static = {}
	
	for k, v in ipairs(classDefinition) do
		if type(v) == "table" and v[1] == "extends" then
			classDefinition.parent = v[2]
			classDefinition[k] = nil
			break
		end
		
		if type(v) == "table" and v[1] == "static" then
			classDefinition.static = v[2]
			classDefinition[k] = nil
			break
		end
	end
	
	local instanceMethods = {}
	if classDefinition.parent then
		for k, v in pairs(classDefinition.parent.classDefinition) do
			if k ~= "static" then
				if k == "new" then
					instanceMethods.super = v
				else
					instanceMethods[k] = v
				end
			end
		end
	end
	
	for k, v in pairs(classDefinition) do
		instanceMethods[k] = v
	end
	
	namespace[className] = setmetatable(
		{
			name = className,
			-- __rawtostring = tostring(self),
			classDefinition = classDefinition,
			instanceMethods = instanceMethods,
		},
		{
			__index = function (self, key)
				if key == "parent" then
					return self.classDefinition.parent or self
				elseif key == "static" then
					return self.classDefinition.static
				else
					return self.static[key] or self.parent.static[key] or error(string.format("Static member \"%s\" does not exist in class \"%s\".", key, self.name))
				end
			end,
			
			__newindex = function (self, key, value)
				if type(value) == "function" then
					error("You cannot define a new method.")
				end
				
				if self.static[key] ~= nil then
					if type(self.static[key]) == "function" then
						error("You cannot modify a method.")
					else
						self.static[key] = value
					end
				elseif self.parent.static[key] ~= nil then
					if type(self.parent.static[key]) == "function" then
						error("You cannot modify a method.")
					else
						self.parent.static[key] = value
					end
				end
			end,
			
			__call = function(self, ...)
				local obj = {
					class = self,
					-- __rawtostring = tostring(self),
					fields = {},
					methods = self.instanceMethods,
				}
				instanceMethods.new(obj, ...)
				
				setmetatable(obj, objectMetaTable)
				
				return obj
			end
		}
	)
end

function class(className)
	return function (classDefinition)
		buildClass(className, classDefinition)
	end
end

class "Object" {
	new = function (self)
	end,
}

-- class "Foo" {
	-- static {
		-- y = 123,
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
	-- extends "Foo",
	
	-- new = function (self)
		-- self:super()
	-- end,
-- }

-- local q = Qoo()
-- Qoo:hahaha()

-- local f1 = Foo()
-- f1.x = 1

-- local f2 = Foo()

-- print(f1.x)

-- local events = {}

-- local x = os.clock()
-- for i = 1, 5e5 do
	-- events[i] = Foo()
-- end

-- print(events[1].x)

-- for i = 1, 5e5 do
	-- events[i]:bar()
-- end
-- print(string.format("elapsed time: %.2f", os.clock() - x))