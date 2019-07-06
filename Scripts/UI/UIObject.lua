class "UIObject" {
	new = function (self, x,y,width,height)
		self.x = x
		self.y = y
		self.width = width
		self.height = height
		self.transform = nil
		self.parent = nil
		self.isHovering = false
		self.isInside = false
	end,
	
	setParent = function (self, parent)
		self.parent = parent
	end,
	
	getIsHovering = function (self)
		return self.isHovering
	end,
	
	getIsInside = function (self)
		return self.isInside
	end,
	
	findIsInside = function (self, x,y)
		if self.transform then
			x,y = self.transform:inverseTransformPoint(x,y)
			
			if x >= self.x and y >= self.y and x <= self.x+self.width and y <= self.y+self.height then
				return true
			else
				return false
			end
		else
			return false
		end
	end,
	
	mousePressed = function (self, mouseX, mouseY, button, istouch, presses)
	end,
	
	mouseReleased = function (self, mouseX, mouseY, istouch, presses)
	end,

	mouseMoved = function (self, x, y, dx, dy, istouch)
	end,

	keyPressed = function (self, key)
	end,
	
	mouseEnter = function (self)
		self.isInside = true
	end,
	
	mouseExit = function (self)
		self.isInside = false
	end,
}