class "MeasuresComponent" {
	extends "DisplayComponent",
	
	-- Override
	new = function (self, x,y, width,height)
		self:super(x,y, width,height)
		
		self.measureColourHSV = {0,0,0}
		self.measureAlpha = 0.5
		self.measureConcentrationRate = 0.2
		
		self.fontSize = 0
		self.font = nil
		self.measureTextOffsets = {0.02, 0.025}
		self.measureTextScale = 0.05
		self:loadFontIfNecessary(love.graphics.getHeight())
	end,
	
	-- Implement
	update = function (self, dt)
	end,
	
	-- Implement
	draw = function (self, noteScale)
		love.graphics.push()
		
		local song = player:getSong()
		local timeDivision = song:getTimeDivision()
		local time = player:getTimeManager():getTime()
		
		local screenWidth = love.graphics.getWidth()
		local screenHeight = love.graphics.getHeight()
		
		if self.orientation == 1 or self.orientation == 3 then
			screenWidth, screenHeight = screenHeight, screenWidth
		end
		
		local pixelMoved = math.floor(noteScale*time)
		
		local offset = screenWidth * self.x
		
		local measures = song:getMeasures()
		
		local firstNonStartedMeasureID = player:getFirstNonStartedMeasureID()
		
		self:loadFontIfNecessary(screenHeight)
		
		for i = 0, 1 do
			-- There are two culling direction, so draw forward first, then backward
			-- i = 0: draw forward
			-- i = 1: draw backward
				
			local measureID = firstNonStartedMeasureID - i	-- just a trick to make a shortcut for making different starting points for draw forward and backward
			
			while measureID > 0 and measureID < #measures do
				local measure = measures[measureID]
				local nextMeasure = measures[measureID+1]
				
				local measureTime = measure:getTime()
				local nextMeasureTime = nextMeasure:getTime()
				
				local timeUntilMeasureStart = measureTime - time
				local timeUntilNextMeasureStart = nextMeasureTime - time
				
				local measureLength = nextMeasureTime - measureTime 
				
				local measureScale = noteScale * 128 / timeDivision	-- Multiplier for MIDI time domain to screen display domain convertion
				local measureX = offset + math.floor(measureScale * timeUntilMeasureStart)
				local measureWidth = offset + math.floor(measureScale * timeUntilNextMeasureStart) - measureX	-- pixel distance between current and next measures
				
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
				
				local r,g,b = vivid.HSVtoRGB(self.measureColourHSV)
				local a = math.max(math.min(1 - self.measureConcentrationRate * math.abs(timeUntilMeasureStart+measureLength*0.25) / timeDivision, self.measureAlpha), 0)	-- maximum alpha at the 25% position of the measure
				
				love.graphics.setColor(r,g,b,a)
				if self.orientation == 0 then
					love.graphics.rectangle("fill", measureX,0, measureWidth,screenHeight)
				elseif self.orientation == 1 then
					love.graphics.rectangle("fill", 0,screenHeight-measureX, screenHeight,measureWidth)
				elseif self.orientation == 2 then
					love.graphics.rectangle("fill", measureWidth-measureX,0, measureWidth,screenHeight)
				elseif self.orientation == 3 then
					love.graphics.rectangle("fill", 0,measureX, screenHeight,measureWidth)
				end
				
				love.graphics.setColor(1,1,1,0.8)
				love.graphics.setFont(self.font)
				
				local textOffsets = {self.measureTextOffsets[1] * screenHeight, self.measureTextOffsets[2] * screenHeight}
				love.graphics.push()
				love.graphics.translate(textOffsets[1], textOffsets[2])
				
				if self.orientation == 0 then
					love.graphics.print(measureID, measureX,0)
				elseif self.orientation == 1 then
					love.graphics.print(measureID, 0,screenHeight-measureX)
				elseif self.orientation == 2 then
					love.graphics.print(measureID, measureWidth-measureX,0)
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
		if self.fontSize ~= newFontSize then
			self.fontSize = newFontSize
			self.font = love.graphics.newFont("Assets/MODERNE SANS.ttf", self.fontSize)
		end
	end,
}