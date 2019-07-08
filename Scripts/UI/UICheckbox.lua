class "UICheckbox" {
	extends "UIObject",
	
	static {
		uncheckedIcon = love.graphics.newImage("Assets/Television 2.png"),
		checkedIcon = love.graphics.newImage("Assets/Free check mark icon 2.png"),
	},
	
	new = function (self, x,y,width,height, text,icon)
		self:super(x,y, width,height)
		self.text = text
		self.isChecked = false
	end,
	
	update = function (self, dt, transform)
		self.transform = transform
	end,
	
	draw = function (self)
		-- Draw the box
		love.graphics.push()
			
			if self.isInside then
				love.graphics.setColor(0,1,1,0.8)
			else
				love.graphics.setColor(1,1,1,0.8)
			end
			
			if self.transform then
				
				local transformedSize = select(2,self.transform:transformPoint(0,self.height)) - select(2,self.transform:transformPoint(0,0))
				self.width = self.transform:inverseTransformPoint(transformedSize, 0) - self.transform:inverseTransformPoint(0,0)
				
				local iconX, iconY = self.transform:transformPoint(self.x,self.y)
				if self.isChecked then
					local iconScale = transformedSize / self.class.checkedIcon:getHeight()
					love.graphics.draw(self.class.checkedIcon, iconX,iconY, 0, iconScale)
				else
					local iconScale = transformedSize / self.class.uncheckedIcon:getHeight()
					love.graphics.draw(self.class.uncheckedIcon, iconX,iconY, 0, iconScale)
				end
			end
			
		love.graphics.pop()
		
		
		local textX, textY = self.transform:transformPoint(self.x+self.width,self.y)
		love.graphics.setColor(1,1,1,0.8)
		love.graphics.print(self.text, textX,textY, 0, 0.5)
	end,
	
	mousePressed = function (self, mouseX, mouseY, button, istouch, presses)
		if self.isInside and button == 1 then
			self.isChecked = not self.isChecked
		end
	end,
	
	mouseMoved = function (self, x, y, dx, dy, istouch )
		if self:findIsInside(x,y) then
			self:mouseEntered()
		else
			self:mouseExited()
		end
	end,
}