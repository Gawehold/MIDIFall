class "UISliderSuite" {
	extends "UIObject",
	
	new = function (self, x,y,width,height, text, valueAlias, minValue,maxValue)
		self:super(x,y, width,height)
		
		self.text = text
		self.slider = Slider(x,y, width,height, valueAlias, minValue,maxValue)
		
	end,
	
	update = function (self, dt, transform)
		self.transform = transform
		
		self.slider:update()
	end,
	
	draw = function (self)
		self.slider 
	end,
	
	mousePressed = function (self, mouseX, mouseY, button, istouch, presses)
		if self.isInside and button == 1 then
			self.isClicking = true
			
			self.value = (self.maxValue - self.minValue) * (mouseX - self.transform:transformPoint(self.x,0)) / (self.transform:transformPoint(self.width,0) - self.transform:transformPoint(0,0))
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
			self.value = (self.maxValue - self.minValue) * (x - self.transform:transformPoint(self.x,0)) / (self.transform:transformPoint(self.width,0) - self.transform:transformPoint(0,0))
			self.value = math.clamp(self.value, self.minValue, self.maxValue)
		end
	end,
}