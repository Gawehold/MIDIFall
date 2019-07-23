class "UISlider" {
	extends "UIObject",
	
	new = function (self, x,y,width,height, valueAlias, minValue,maxValue, valueStep, isVertical)
		self:super(x,y, width,height)
		self.value = valueAlias
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
			absoluteIndicatorX = absoluteIndicatorX + (self.transform:transformPoint(self.width,0) - self.transform:transformPoint(0,0)) * ((self.value - self.minValue) / (self.maxValue - self.minValue))
			absoluteIndicatorX = absoluteIndicatorX - absoluteIndicatorWidth/2
			
			love.graphics.rectangle("fill", absoluteIndicatorX,absoluteIndicatorY, absoluteIndicatorHeight,absoluteIndicatorHeight)
		end
	end,
	
	mousePressed = function (self, mouseX, mouseY, button, istouch, presses)
		if self.isInside and button == 1 then
			self.isClicking = true
			
			self.value = (self.maxValue - self.minValue) * (mouseX - self.transform:transformPoint(self.x,0)) / (self.transform:transformPoint(self.width,0) - self.transform:transformPoint(0,0)) + self.minValue
			self.value = math.round(self.value, self.valueStep)
			self.value = math.clamp(self.value, self.minValue, self.maxValue)
		end
	end,
	
	mouseReleased = function (self, mouseX, mouseY, istouch, presses)
		self.isClicking = false
	end,
	
	mouseMoved = function (self, x, y, dx, dy, istouch)
		if self:findIsInside(x,y) then
			self:mouseEntered()
		else
			self:mouseExited()
		end
		
		if self.isClicking then
			self.value = (self.maxValue - self.minValue) * (x - self.transform:transformPoint(self.x,0)) / (self.transform:transformPoint(self.width,0) - self.transform:transformPoint(0,0)) + self.minValue
			self.value = math.round(self.value, self.valueStep)
			self.value = math.clamp(self.value, self.minValue, self.maxValue)
		end
	end,
}