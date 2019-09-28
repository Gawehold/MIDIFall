class "MeasuresComponent" {
	extends "DisplayComponent",
	
	-- Override
	new = function (self, x,y, width,height)
		self:super(x,y, width,height)
		
		self.measureColorHSV = {0,0,0}
		self.measureAlpha = 0.8
		self.measureConcentrationRate = 0.08
		
		self.fontSize = 0
		self.usingDefaultFont = true
		self.defaultFontPath = "Assets/MODERNE SANS.ttf"
		self.fontPath = ""
		self.font = nil
		self.measureTextOffsets = {0.075, 0.025}
		self.measureTextScale = 0.05
		self.measureTextColorHSVA = {1,0,1,0.8}
		
		self.needToUpdateFont = true
	end,
	
	-- Implement
	update = function (self, dt)
	end,
	
	-- Implement
	draw = function (self, screenWidth,screenHeight, noteScale)
		if not self.enabled then
			return
		end
		
		love.graphics.push()
		
		local song = player:getSong()
		local timeDivision = song:getTimeDivision()
		local time = player:getTimeManager():getTime()
		
		if self.orientation == 1 or self.orientation == 3 then
			screenWidth, screenHeight = screenHeight, screenWidth
		end
		
		local pixelMoved = math.floor(noteScale*time)
		
		local offset = screenWidth * self.x
		
		local measures = song:getMeasures()
		
		local firstNonStartedMeasureID = player:getFirstNonStartedMeasureID()
		
		self:loadFontIfNecessary(screenHeight)
		
		local firstMeasureLength
		local lastMeasureLength
		if #measures > 1 then
			firstMeasureLength = measures[2]:getTime() - measures[1]:getTime()
			lastMeasureLength  = measures[#measures]:getTime() - measures[#measures-1]:getTime()
		else
			firstMeasureLength = 4*song:getTimeDivision()
			lastMeasureLength  = firstMeasureLength
		end
		
		for i = 0, 1 do
			-- There are two culling direction, so draw forward first, then backward
			-- i = 0: draw forward
			-- i = 1: draw backward
				
			local measureID = firstNonStartedMeasureID - i	-- just a trick to make a shortcut for making different starting points for draw forward and backward
			
			while true do
				local measure = measures[measureID]
				local nextMeasureID = measureID + (-2*i+1)
				
				if measureID >= 1 then
					nextMeasureID = measureID + 1
				end
				local nextMeasure = measures[nextMeasureID]
				
				local measureTime
				if measureID <= 0 then
					measureTime = measures[1]:getTime() + (measureID-1) * firstMeasureLength
				elseif measureID > #measures then
					measureTime = measures[1]:getTime() + (measureID-1) * lastMeasureLength
				else
					measureTime = measure:getTime()
				end
				local timeUntilMeasureStart = measureTime - time
				
				
				local nextMeasureTime
				if nextMeasureID <= 0 then
					nextMeasureTime = measures[1]:getTime() + (nextMeasureID-1) * firstMeasureLength
				elseif nextMeasureID > #measures then
					nextMeasureTime = measures[1]:getTime() + (nextMeasureID-1) * lastMeasureLength
				else
					nextMeasureTime = nextMeasure:getTime()
				end
				local timeUntilNextMeasureStart = nextMeasureTime - time
				
				
				local measureLength = nextMeasureTime - measureTime 
				
				local measureScale = ( screenWidth / 1920 ) * ( noteScale * 128 / timeDivision )	-- Multiplier for MIDI time domain to screen display domain convertion
				local measureX = offset + measureScale * timeUntilMeasureStart
				local measureWidth = math.abs((measureScale * (nextMeasureTime - measureTime)))	-- pixel distance between current and next measures
				
				-- currentMeasureLength = currentTimeSignature:getNumerator() * (self.timeDivision * currentTimeSignature:getDenominator() / 4)
				
				-- Culling
				if i == 0 then
					if measureX >= screenWidth then
						break
					end
				else
					if measureX + measureWidth < 0 then
						break
					end
				end
				
				local r,g,b = vivid.HSVtoRGB(self.measureColorHSV)
				local a = math.max(self.measureAlpha * (1 - self.measureConcentrationRate * math.abs(timeUntilMeasureStart+measureLength*0.25) / timeDivision), 0)	-- maximum alpha at the 25% position of the measure
				
				love.graphics.setColor(r,g,b,a)
				if self.orientation == 0 then
					love.graphics.rectangle("fill", measureX,0, measureWidth,screenHeight)
				elseif self.orientation == 1 then
					love.graphics.rectangle("fill", 0,screenWidth-measureX-measureWidth, screenHeight,measureWidth)
				elseif self.orientation == 2 then
					love.graphics.rectangle("fill", screenWidth-measureX-measureWidth,0, measureWidth,screenHeight)
				elseif self.orientation == 3 then
					love.graphics.rectangle("fill", 0,measureX, screenHeight,measureWidth)
				end
				
				love.graphics.setColor(vivid.HSVtoRGB(self.measureTextColorHSVA))
				love.graphics.setFont(self.font)
				
				local textOffsets = {self.measureTextOffsets[1] * measureWidth, self.measureTextOffsets[2] * screenHeight}
				love.graphics.push()
				love.graphics.translate(textOffsets[1], textOffsets[2])
				
				if self.orientation == 0 then
					love.graphics.print(measureID, measureX,0)
				elseif self.orientation == 1 then
					love.graphics.print(measureID, 0,screenWidth-measureX-measureWidth)
				elseif self.orientation == 2 then
					love.graphics.print(measureID, screenWidth-measureX-measureWidth,0)
				elseif self.orientation == 3 then
					love.graphics.print(measureID, 0,measureX)
				end
				love.graphics.pop()
				
				-- Increment / decrement for the while loop
				if i == 0 then
					measureID = measureID + 1
				else
					measureID = measureID - 1
				end
			end
		end
		
		love.graphics.pop()
	end,
	
	loadFontIfNecessary = function (self, screenHeight)
		local newFontSize = self.measureTextScale * screenHeight
		if self.needToUpdateFont or self.fontSize ~= newFontSize then
			self.fontSize = newFontSize
		
			if self.usingDefaultFont then
				local fileData = love.filesystem.newFileData(self.defaultFontPath)
				self.font = love.graphics.newFont(fileData, self.fontSize)
			else
				local file = io.open(self.fontPath, "rb")
				local fileData = love.filesystem.newFileData(file:read("*a"), "")
				self.font = love.graphics.newFont(fileData, self.fontSize)
				file:close()
			end
			
			self.needToUpdateFont = false
		end
	end,
	
	setFontPath = function (self, fontPath)
		self.fontPath = fontPath
		self.usingDefaultFont = false
		self.needToUpdateFont = true
	end,
	
	useDefaultFont = function (self)
		self.usingDefaultFont = true
		self.needToUpdateFont = true
	end,
}