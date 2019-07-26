class "UIText" {
	extends "UIObject",
	
	new = function (self, x,y,width,height, text, scale)
		self:super(x,y, width,height)
		self.text = text or ""
		self.scale = scale or 1
		self.words = {}
		for word in self.text:gmatch("[^%s]+") do
			table.insert(self.words, word)
		end
	end,
	
	update = function (self, dt, transform)
		self.transform = transform
	end,
	
	draw = function (self)
		local font = love.graphics.getFont()
		local fontHeight = self.scale*font:getHeight()
		local spaceWidth = self.scale*font:getWidth(" ")
		
		local boxX, boxY = self.transform:transformPoint(self.x, self.y)
		local boxX2, boxY2 = self.transform:transformPoint(self.x+self.width, self.y+self.height)
		local boxWidth = boxX2 - boxX
		local boxHeight = boxY2 - boxY
		
		love.graphics.setColor(1,1,1,0.8)
		-- love.graphics.rectangle("line", boxX,boxY, boxWidth,boxHeight)
		
		local wordX = boxX
		local wordY = boxY
		
		local scale = self.scale
		
		for i,word in ipairs(self.words) do
			if wordX + scale*font:getWidth(word) + spaceWidth > boxX2 then
				if boxX + scale*font:getWidth(word) + spaceWidth > boxX2 then
					-- If the space is too small for the word, then make the text smaller
					scale = (boxX2 - wordX - spaceWidth) / font:getWidth(word)
				else
					-- Newline
					wordX = boxX
					wordY = wordY + fontHeight
				end
			end
			
			love.graphics.print(word, wordX,wordY, 0, scale)
			wordX = wordX + scale*font:getWidth(word) + spaceWidth
		end
	end,
	
	mousePressed = function (self, mouseX, mouseY, button, istouch, presses)
		if self.isInside and self.clicked and button == 1 then
			self:clicked()
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