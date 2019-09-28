class "UpdateManager" {
	new = function (self)
		self.checking = false
		self.result = nil
		self.func = nil
		self.checkBeforeStart = true
		self.threadCode = [[
		local fp = io.popen("java -jar " .."\""..select(1, ...).."\"")
		local result = nil
		
		local str = fp:lines()()
		if str == nil then
			result = "Failed to open the update log."
		else
			local verifyStr = "MIDIFall VERSION"
			if (string.sub(str, 0, string.len(verifyStr)) == verifyStr) then
				result = tonumber(string.sub(str, string.len(verifyStr)+2))
			else
				result = "Failed to extract the version info from the update log."
			end
		end
		
		fp:close()
		love.thread.getChannel("info"):push(result)
		]]
	end,

	fetch = function (self, func)
		if not self.checking then
			self.func = func
			self.checking = true
			
			local thread = love.thread.newThread(self.threadCode)
			thread:start( getDirectory().."/MIDIFall_UpdateChecker.jar" )
		end
	end,

	check = function (self)
		if type(self.result) == "number" then
			if (self.result > VERSION) then
				print(string.format("New version available: MIDIFall v%.1f", self.result))
			else
				print("You are using the latest version.")
			end
			
			self.func(self.result)
		else
			print("Failed to check for updates.")
		end
		
		self.checking = false
	end,

	update = function (self, dt)
		if self.checking then
			if self.result then
				self:check()
			else
				self.result = love.thread.getChannel("info"):pop()
			end
		end
	end,
	
	draw = function (self)
	end,
}