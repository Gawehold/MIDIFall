class "UISlider" {
	extends "UIObject",
	
	new = function (self, x,y,width,height, valueAlias)
		self:super(x,y, width,height)
		self.value = valueAlias
		self.isClicking = false
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
				love.graphics.setColor(0,1,1,0.8)
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
			absoluteIndicatorX = absoluteIndicatorX + (self.transform:transformPoint(self.width,0) - self.transform:transformPoint(0,0)) * self.value
			absoluteIndicatorX = absoluteIndicatorX - absoluteIndicatorWidth/2
			
			love.graphics.rectangle("fill", absoluteIndicatorX,absoluteIndicatorY, absoluteIndicatorHeight,absoluteIndicatorHeight)
		end
	end,
	
	mousePressed = function (self, mouseX, mouseY, button, istouch, presses)
		if self.isInside and button == 1 then
			self.isClicking = true
			
			self.value = (mouseX - self.transform:transformPoint(self.x,0)) / (self.transform:transformPoint(self.width,0) - self.transform:transformPoint(0,0))
			self.value = math.clamp(self.value, 0, 1)
			
			print(self.value, defaultTheme.notesComponent.noteScale)
		end
	end,
	
	mouseReleased = function (self, mouseX, mouseY, istouch, presses)
		self.isClicking = false
	end,
	
	mouseMoved = function (self, x, y, dx, dy, istouch)
		if self:findIsInside(x,y) then
			self:mouseEnter()
		else
			self:mouseExit()
		end
		
		if self.isClicking then
			self.value = (x - self.transform:transformPoint(self.x,0)) / (self.transform:transformPoint(self.width,0) - self.transform:transformPoint(0,0))
			self.value = math.clamp(self.value, 0, 1)
		end
	end,
}