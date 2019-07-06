class "UICheckbox" {
	extends "UIObject",
	
	static {
		uncheckedIcon = love.graphics.newImage("Assets/Television 2.png"),
		checkedIcon = love.graphics.newImage("Assets/Free check mark icon 2.png"),
	},
	
	new = function (self, x,y,width,height, text,icon, clicked)
		self:super(x,y, width,height)
		self.text = text
		self.checked = false
		self.clicked = clicked
	end,
	
	update = function (self, dt, transform)
		self.transform = transform
	end,
	
	draw = function (self)
		-- Draw the box
		
			-- local iconScale = love.graphics.getFont():getHeight() / self.class.uncheckedIcon:getHeight()
			-- local iconX, iconY = self.transform:transformPoint(self.x+self.padding,self.y)
			-- for k,v in pairs(self.class.static) do
				-- print(k)
			-- end
			-- love.graphics.draw(self.class.uncheckedIcon)
		
		love.graphics.push()
			
			local boxWidth
			if self.transform then
				love.graphics.applyTransform(self.transform)
				local transformedSize = select(2,self.transform:transformPoint(0,self.height)) - select(2,self.transform:transformPoint(0,0))
				
				self.width = self.transform:inverseTransformPoint(transformedSize, 0) - self.transform:inverseTransformPoint(0,0)
			end
			
			if self.isInside then
				love.graphics.setColor(1,1,1,0.8)
			else
				love.graphics.setColor(0,0,0,0.8)
			end
		
		love.graphics.pop()
		
		
		love.graphics.setColor(1,1,1,0.8)
		love.graphics.print(self.text, self.transform:transformPoint(self.x+self.width,self.y))
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