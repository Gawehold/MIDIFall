class "StatisticComponent" {
	extends "DisplayComponent",
	
	-- Override
	new = function (self)
		DisplayComponent.instanceMethods.new(self)
		
		-- self.enabled = false
		
		self.colorHSVA = {1,0,1,1}
		
		self.textScale = 0.03
		self.textOffsets = {0.01,0.01}
		
		self.usingDefaultFont = true
		self.defaultFontPath = "Assets/NotoSansCJKtc-Medium_1.otf"
		self.fontPath = ""
		self.font = love.graphics.getFont()
		
		self:updateFont()
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
	end,
	
	updateFont = function (self, screenHeight)
		local newFontSize = math.round(self.textScale * (screenHeight or love.graphics.getHeight()))
		if self.usingDefaultFont then
			local fileData = love.filesystem.newFileData(self.defaultFontPath)
			self.font = love.graphics.newFont(fileData, newFontSize)
		else
			local file = io.open(self.fontPath, "rb")
			local fileData = love.filesystem.newFileData(file:read("*a"), "")
			self.font = love.graphics.newFont(fileData, newFontSize)
			file:close()
		end
		
		self.font:setLineHeight(0.75)
	end,
	
	setFontPath = function (self, fontPath)
		self.fontPath = fontPath
		self.usingDefaultFont = false
		
		self:updateFont()
	end,
	
	useDefaultFont = function (self)
		self.usingDefaultFont = true
		
		self:updateFont()
	end,
	
	resize = function (self, w, h)
		self:updateFont(h)
	end,
}