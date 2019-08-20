local namespace = _G

local objectMetaTable = {
	__index = function (self, key)
		local field = rawget(self.fields, key)
		local method = rawget(self.methods, key)
		
		if type(field) == "table" and rawget(field, "class") and rawget(field, "class").name == "Alias" then
			return rawget(field, "fields").table[field.key]
		end
		
		if type(field) == "table" and rawget(field, "class") and rawget(field, "class").name == "Follower" then
			return field.access()
		end
		
		if method == nil then
			if key == "new" then
				error(string.format("Class %s do not has a constructor.", self.class.name))
			else
				return field
			end
		else
			return method
		end
	end,
	
	__newindex = function (self, key, value)
		local field = rawget(self.fields, key)
		local method = rawget(self.methods, key)
		
		if type(field) == "table" and rawget(field, "class") and rawget(field, "class").name == "Alias" then
			rawget(field, "fields").table[field.key] = value
			
			return
		end
		
		if type(field) == "table" and rawget(field, "class") and rawget(field, "class").name == "Follower" and field.assign then
			field.assign(value)
			
			return
		end
		
		-- if type(value) == "function" then
			-- error("You cannot define a new method.")
		-- end
		
		if method ~= nil then
			error("You cannot modify a method.")
		end
		
		self.fields[key] = value
	end,
	
	-- __tostring = function (self)
		-- return string.format("%s: %s", self.class, (self.__rawtostring:match("%d.+")))
	-- end,
}

function abstract()
	error("Calling abstract method is not allowed. You should implement the method first.")
end

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
	
	for k, v in pairs(classDefinition) do
		
		if type(v) == "table" and #v >= 1 then
			if v[1] == "extends" then
				classDefinition.parent = v[2]
				classDefinition[k] = nil
			elseif v[1] == "static" then
				classDefinition.static = v[2]
				classDefinition[k] = nil
			end
		end
	end
	
	classDefinition.parent = classDefinition.parent or namespace["Object"]
	
	local instanceMethods = {}
	if classDefinition.parent then
		for k, v in pairs(classDefinition.parent.instanceMethods) do
			if k ~= "super" then
				if k == "new" then
					-- print(className, classDefinition.parent.name, v)
					instanceMethods.super = v
				else
					instanceMethods[k] = v
				end
			end
		end
	end
	
	for k, v in pairs(classDefinition) do
		if type(v) == "function" then
			instanceMethods[k] = v
		end
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
					if self.classDefinition.static then
						return self.classDefinition.static
					else
						error(string.format("Class %s does not contain any static members.", self.name))
					end
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
				setmetatable(obj, objectMetaTable)
				obj:new(...)
				
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

class "Alias" {
	new = function (self, t, key)
		self.table = t
		self.key = key
	end,
}

class "Follower" {
	new = function (self, access, assign)
		self.access = access
		self.assign = assign
	end,
}

-- class "A" {
	-- f = function (self)
		-- print("I am A or descendant of A.")
	-- end,
-- }

-- class "B" {
	-- extends "A",
	-- new = function (self)
		-- self.x = 1
	-- end,
-- }

-- class "C" {
	-- extends "B",
	-- new = function (self)
		-- self:super()
		-- -- B.instanceMethods.new(self)
		-- -- print(B.instanceMethods.new)
		-- -- print(self.super)
	-- end,
-- }
-- for k,v in pairs(A.instanceMethods) do
	-- print(k,v)
-- end
-- print("==========")
-- for k,v in pairs(B.instanceMethods) do
	-- print(k,v)
-- end
-- print("==========")
-- for k,v in pairs(C.instanceMethods) do
	-- print(k,v)
-- end

-- local obj = C()
-- print(obj.x)

-------------------------------------------------

-- class "B" {
	-- new = function (self)
		-- self.b = Alias(_G, "a")
	-- end,
-- }

-- a = 10
-- local obj = B()
-- print(a, obj.b)
-- obj.b = 20
-- print(a, obj.b)
-- obj.b = 40
-- print(a, obj.b)


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