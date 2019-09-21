class "StatisticComponent" {
	extends "DisplayComponent",
	
	-- Override
	new = function (self)
		DisplayComponent.instanceMethods.new(self)
		
		self.colorHSVA = {1,0,1,1}
		
		self.textScale = 0.03
		self.textOffsets = {0.005,0.01}
		
		self.fontSize = 0
		self.fontPath = love.filesystem.getSource() .. "/Assets/MODERNE SANS.ttf"
		self.font = love.graphics.getFont()
		
		self.needToUpdateFont = true
	end,
	
	-- Implement
	update = function (self, dt)
	end,
	
	-- Implement
	draw = function (self, screenWidth,screenHeight)
		if not self.enabled then
			return
		end
		
		local previousFont = love.graphics.getFont()
		
		local text =
			"FPS: " .. love.timer.getFPS() .. "\n" ..
			"Time: " .. string.format("%.2f", player:getTimeManager():getTime()) .. "\n" ..
			"Tempo: " .. string.format("%.2f", player:getSong():getTempoChanges()[player:getTimeManager().currentTempoChangeID]:getTempo())
		
		love.graphics.setColor(vivid.HSVtoRGB(self.colorHSVA))
		love.graphics.setFont(self.font)
		
		love.graphics.print(text, screenWidth*self.textOffsets[1], screenHeight*self.textOffsets[2])
		
		love.graphics.setFont(previousFont)
		
		if self.orientation == 1 or self.orientation == 3 then
			screenWidth, screenHeight = screenHeight, screenWidth
		end
		self:loadFontIfNecessary(screenHeight)
	end,
	
	-- setFont = function (self, font)
		-- self.font = font
	-- end,
	
	loadFontIfNecessary = function (self, screenHeight)
		local newFontSize = self.textScale * screenHeight
		if self.needToUpdateFont or self.fontSize ~= newFontSize then
			self.fontSize = newFontSize
		
			local file = io.open(self.fontPath, "rb")
			local fileData = love.filesystem.newFileData(file:read("*a"), "")
			self.font = love.graphics.newFont(fileData, self.fontSize)
			file:close()
			
			self.needToUpdateFont = false
		end
	end,
	
	setFontPath  = function (self, fontPath)
		self.fontPath = fontPath
		self.needToUpdateFont = true
	end,
}