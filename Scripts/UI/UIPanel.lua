class "UIPanel" {
	extends "UIObject",
	
	new = function (self, x,y, width,height, children)
		self:super(x,y, width,height)
		
		self.children = children or {}
		for k,v in ipairs(self.children) do
			v:setParent(self)
		end
		
		self.childrenTransform = love.math.newTransform()
	end,
	
	update = function (self, dt, transform)
		self.transform = transform
		
		self.childrenTransform = self.transform:clone()
		self.childrenTransform:scale(self.width,self.height)
		self.childrenTransform:translate(self.x/self.width,self.y/self.height)
		
		for k,v in ipairs(self.children) do
			v:update(dt, self.childrenTransform)
		end
	end,
	
	draw = function (self)
		love.graphics.push()
		if self.transform then
			love.graphics.applyTransform(self.transform)
		end
		
		if self.isInside then
			love.graphics.setColor(0.5,0,0,0.8)
		else
			love.graphics.setColor(0,0,0,0.8)
		end
		love.graphics.rectangle("fill", self.x,self.y, self.width,self.height)
		
		love.graphics.pop()
		
		for k,v in ipairs(self.children) do
			v:draw()
		end
	end,
	
	mousePressed = function (self, mouseX, mouseY, button, istouch, presses)
		for k,v in ipairs(self.children) do
			v:mousePressed(mouseX, mouseY, button, istouch, presses)
		end
	end,
	
	mouseReleased = function (self, mouseX, mouseY, istouch, presses)
		for k,v in ipairs(self.children) do
			v:mouseReleased(mouseX, mouseY, istouch, presses)
		end
	end,
	
	wheelMoved = function (self, x, y)
		for k,v in ipairs(self.children) do
			v:wheelMoved(x, y)
		end
	end,
	
	mouseMoved = function (self, x, y, dx, dy, istouch )
		if self:findIsInside(x,y) then
			self:mouseEntered()
		else
			self:mouseExited()
		end
		
		for k,v in ipairs(self.children) do
			v:mouseMoved(x, y, dx, dy, istouch)
		end
	end,
	
	keyPressed = function (self, key)
		for k,v in ipairs(self.children) do
			v:keyPressed(key)
		end
	end,
	
	keyReleased = function (self, key)
		for k,v in ipairs(self.children) do
			v:keyReleased(key)
		end
	end,
	
	textInput = function (self, ch)
		for k,v in ipairs(self.children) do
			v:textInput(ch)
		end
	end,
	
	getIsInside = function (self)
		return self.isInside
	end,
	
	getIsFocusing = function (self)
		for k,v in ipairs(self.children) do
			if v.getIsFocusing and v:getIsFocusing() then
				return true
			end
		end
		
		return false
	end,
}