class "UIButton" {
	extends "UIObject",
	
	new = function (self, x,y,width,height, text,icon, clicked)
		self:super(x,y, width,height)
		self.text = text
		self.icon = icon
		self.iconSpace = 0.05
		self.padding = 0.1
		self.centred = false
		
		self.clicked = clicked
	end,
	
	update = function (self, dt, transform)
		self.transform = transform
	end,
	
	draw = function (self)
		-- Draw the box
		love.graphics.push()
		
			if self.transform then
				love.graphics.applyTransform(self.transform)
			end
			
			if self.isInside then
				love.graphics.setColor(1,1,1,0.8)
			else
				love.graphics.setColor(0,0,0,0.8)
			end
			love.graphics.rectangle("fill", self.x,self.y, self.width,self.height, 0.04,1.0)
		
		love.graphics.pop()
		
		
		-- Draw icon and text
		if self.isInside then
			love.graphics.setColor(0,0,0,0.8)
		else
			love.graphics.setColor(1,1,1,0.8)
		end
		
		if self.icon then
			local iconScale = love.graphics.getFont():getHeight() / self.icon:getHeight()
			local iconX, iconY = self.transform:transformPoint(self.x+self.padding,self.y)
			love.graphics.draw(self.icon, iconX,iconY, 0, iconScale)
			
			local textX,textY = self.transform:transformPoint(self.x+self.width*(self.iconSpace)+self.padding,self.y)
			love.graphics.print(self.text, textX+iconScale*self.icon:getWidth(), textY)
		else
			love.graphics.print(self.text, self.transform:transformPoint(self.x,self.y))
		end
	end,
	
	mousePressed = function (self, mouseX, mouseY, button, istouch, presses)
		if self.isInside and self.clicked and button == 1 then
			self:clicked()
		end
	end,
	
	mouseMoved = function (self, x, y, dx, dy, istouch )
		if self:findIsInside(x,y) then
			self:mouseEnter()
		else
			self:mouseExit()
		end
	end,
}