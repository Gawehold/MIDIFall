class "UICheckbox" {
	extends "UIObject",
	
	static {
		uncheckedIcon = love.graphics.newImage("Assets/unchecked.png"),
		checkedIcon = love.graphics.newImage("Assets/Free check mark icon 2.png"),
	},
	
	new = function (self, x,y,width,height, text, valueAlias, checkBehaviour,uncheckBehaviour, checkedIcon, uncheckedIcon)
		self:super(x,y, width,height)
		self.text = UIText(x+0.12,y,width-0.12,height,text,0.8,false,true)
		self.checkBehaviour = checkBehaviour
		self.uncheckBehaviour = uncheckBehaviour
		self.isChecked = valueAlias or false
		
		self.checkedIcon = checkedIcon or UICheckbox.checkedIcon
		self.uncheckedIcon = uncheckedIcon or UICheckbox.uncheckedIcon
	end,
	
	update = function (self, dt, transform)
		self.transform = transform
		self.text:update(dt, transform)
	end,
	
	draw = function (self)
		-- Draw the box
		love.graphics.push()
			
			if self.isInside then
				love.graphics.setColor(0,0.5,1,0.8)
			else
				love.graphics.setColor(1,1,1,0.8)
			end
			
			if self.transform then
				
				local transformedSize = select(2,self.transform:transformPoint(0,self.height)) - select(2,self.transform:transformPoint(0,0))
				self.width = self.transform:inverseTransformPoint(transformedSize, 0) - self.transform:inverseTransformPoint(0,0)
				
				local iconX, iconY = self.transform:transformPoint(self.x,self.y)
				if self.isChecked then
					local iconScale = transformedSize / self.checkedIcon:getHeight()
					love.graphics.draw(self.checkedIcon, iconX,iconY, 0, iconScale)
				else
					local iconScale = transformedSize / self.uncheckedIcon:getHeight()
					love.graphics.draw(self.uncheckedIcon, iconX,iconY, 0, iconScale)
				end
			end
			
		love.graphics.pop()
		
		
		-- local textX, textY = self.transform:transformPoint(self.x+self.width,self.y)
		-- love.graphics.setColor(1,1,1,0.8)
		-- love.graphics.print(self.text, textX,textY, 0, 0.5)
		self.text:draw()
	end,
	
	toggle = function (self)
		self.isChecked = not self.isChecked
		
		if self.isChecked then
			if self.checkBehaviour then
				self:checkBehaviour()
			end
		else
			if self.uncheckBehaviour then
				self:uncheckBehaviour()
			end
		end
	end,
	
	mousePressed = function (self, mouseX, mouseY, button, istouch, presses)
		if self.isInside and button == 1 then
			self:toggle()
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