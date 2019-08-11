class "UIRangeSlider" {
	extends "UIObject",
	
	new = function (self, x,y,width,height, lowerValueAlias, upperValueAlias, minValue,maxValue, valueStep)
		self:super(x,y, width,height)
		
		self.lowerValue = lowerValueAlias
		self.upperValue = upperValueAlias
		self.minValue = minValue
		self.maxValue = maxValue
		self.isClicking = false
		self.valueStep = valueStep
		self.isVertical = isVertical or false	-- TODO
	end,
	
	update = function (self, dt, transform)
		self.transform = transform
	end,
	
	draw = function (self)
		love.graphics.push()
		
			if self.transform then
				love.graphics.applyTransform(self.transform)
			end
			
			if self.isInside then
				love.graphics.setColor(0,0.5,1,0.8)
			else
				love.graphics.setColor(1,1,1,0.8)
			end
			
			love.graphics.rectangle("fill", self.x,self.y+self.height/4, self.width,self.height/2)
			
		love.graphics.pop()
		
		-- Draw the indicator
		if self.transform then
				
			local absoluteIndicatorHeight = select(2,self.transform:transformPoint(0,self.height)) - select(2,self.transform:transformPoint(0,0))
			local absoluteIndicatorWidth = absoluteIndicatorHeight
			local absoluteIndicatorX, absoluteIndicatorY = self.transform:transformPoint(self.x, self.y)
			absoluteIndicatorX = absoluteIndicatorX - absoluteIndicatorWidth/2
			
			local absolutelowerIndicatorX = absoluteIndicatorX + (self.transform:transformPoint(self.width,0) - self.transform:transformPoint(0,0)) * ((self.lowerValue - self.minValue) / (self.maxValue - self.minValue))
			
			local absoluteUpperIndicatorX = absoluteIndicatorX + (self.transform:transformPoint(self.width,0) - self.transform:transformPoint(0,0)) * ((self.upperValue - self.minValue) / (self.maxValue - self.minValue))
			
			love.graphics.rectangle("fill", absolutelowerIndicatorX,absoluteIndicatorY, absoluteIndicatorHeight,absoluteIndicatorHeight)
			love.graphics.rectangle("fill", absoluteUpperIndicatorX,absoluteIndicatorY, absoluteIndicatorHeight,absoluteIndicatorHeight)
		end
	end,
	
	mousePressed = function (self, mouseX, mouseY, button, istouch, presses)
		if self.isInside and button == 1 then
			local relativeMouseX, relativeMouseY = self.transform:inverseTransformPoint(mouseX, mouseY)
			local distanceToLowerValue = math.abs(relativeMouseX - ((self.lowerValue - self.minValue) / (self.maxValue - self.minValue)))
			local distanceToUpperValue = math.abs(relativeMouseX - ((self.upperValue - self.minValue) / (self.maxValue - self.minValue)))
			
			-- print(distanceToLowerValue, distanceToUpperValue)
			
			if distanceToLowerValue < distanceToUpperValue then
				self.isClicking = "lowerValue"
				
				self.lowerValue = (self.maxValue - self.minValue) * (mouseX - self.transform:transformPoint(self.x,0)) / (self.transform:transformPoint(self.width,0) - self.transform:transformPoint(0,0)) + self.minValue
				self.lowerValue = math.round(self.lowerValue, self.valueStep)
				self.lowerValue = math.clamp(self.lowerValue, self.minValue, self.upperValue-self.valueStep)
			else
				self.isClicking = "upperValue"
				
				self.upperValue = (self.maxValue - self.minValue) * (mouseX - self.transform:transformPoint(self.x,0)) / (self.transform:transformPoint(self.width,0) - self.transform:transformPoint(0,0)) + self.minValue
				self.upperValue = math.round(self.upperValue, self.valueStep)
				self.upperValue = math.clamp(self.upperValue, self.lowerValue+self.valueStep, self.maxValue)
			end
		end
	end,
	
	mouseReleased = function (self, mouseX, mouseY, istouch, presses)
		self.isClicking = false
	end,
	
	mouseMoved = function (self, mouseX, mouseY, dx, dy, istouch)
		if self:findIsInside(mouseX,mouseY) then
			self:mouseEntered()
		else
			self:mouseExited()
		end
		
		if self.isClicking == "lowerValue" then
			self.lowerValue = (self.maxValue - self.minValue) * (mouseX - self.transform:transformPoint(self.x,0)) / (self.transform:transformPoint(self.width,0) - self.transform:transformPoint(0,0)) + self.minValue
			self.lowerValue = math.round(self.lowerValue, self.valueStep)
			self.lowerValue = math.clamp(self.lowerValue, self.minValue, self.upperValue-self.valueStep)
			
		elseif self.isClicking == "upperValue" then
			self.upperValue = (self.maxValue - self.minValue) * (mouseX - self.transform:transformPoint(self.x,0)) / (self.transform:transformPoint(self.width,0) - self.transform:transformPoint(0,0)) + self.minValue
			self.upperValue = math.round(self.upperValue, self.valueStep)
			self.upperValue = math.clamp(self.upperValue, self.lowerValue+self.valueStep, self.maxValue)
		end
	end,
}