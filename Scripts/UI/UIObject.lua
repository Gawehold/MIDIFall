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
	
	update = function (self, dt, transform)
		self.transform = transform
	end,
	
	draw = function (self)
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

	mouseMoved = function (self, x, y, dx, dy, istouch )
		if self:findIsInside(x,y) then
			self:mouseEntered()
		else
			self:mouseExited()
		end
	end,
	
	wheelMoved = function (self, x, y)
	end,

	keyPressed = function (self, key)
	end,
	
	keyReleased = function (self, key)
	end,
	
	textInput = function (self, ch)
	end,
	
	fileDropped = function (self, file)
	end,
	
	resize = function (self, w, h)
	end,
	
	mouseEntered = function (self)
		self.isInside = true
	end,
	
	mouseExited = function (self)
		self.isInside = false
	end,
}