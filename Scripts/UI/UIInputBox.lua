class "UIInputBox" {
	extends "UIObject",
	
	new = function (self, x,y,width,height, valueAlias)
		self:super(x,y, width,height)
		
		self.value = valueAlias
		self.text = tostring(self.value)
		self.isFocusing = false
		self.cursorPosition = 0
	end,
	
	update = function (self, dt, transform)
		self.transform = transform
		
		if not self.isFocusing then
			self.text = tostring(self.value)
		end
	end,
	
	draw = function (self)
		-- Draw the box
		local boxX, boxY = self.transform:transformPoint(self.x, self.y)
		local boxX2, boxY2 = self.transform:transformPoint(self.x+self.width, self.y+self.height)
		local boxWidth = boxX2 - boxX
		local boxHeight = boxY2 - boxY
		
		if self.isFocusing then
			love.graphics.setColor(1,1,1,0.8)
			love.graphics.rectangle("fill", boxX,boxY, boxWidth,boxHeight, boxHeight/8,boxHeight/8)
			
			love.graphics.setColor(0,0.5,1,1)
			love.graphics.setLineWidth((boxWidth+boxHeight) / 128)
			love.graphics.rectangle("line", boxX,boxY, boxWidth,boxHeight, boxHeight/8,boxHeight/8)
		else
			love.graphics.setColor(1,1,1,0.8)
			love.graphics.rectangle("fill", boxX,boxY, boxWidth,boxHeight, boxHeight/8,boxHeight/8)
		end
		
		if self.isFocusing then
			love.graphics.setColor(0,0.5,1,1)
		else
			love.graphics.setColor(0,0,0,0.8)
		end
		
		local textX, textY = self.transform:transformPoint(self.x,self.y)
		love.graphics.print(self.text, textX, textY)
		
		-- Draw cursor
		if self.isFocusing then
			love.graphics.setColor(0,0.5,1,1)
			local cursorX, cursorY = self.transform:transformPoint(self.x,self.y)
			cursorX = cursorX + love.graphics.getFont():getWidth(string.sub(self.text, 1, self.cursorPosition))
			love.graphics.line(cursorX,cursorY+4*love.graphics.getLineWidth(), cursorX,boxY2-4*love.graphics.getLineWidth())
		end
	end,
	
	mousePressed = function (self, mouseX, mouseY, button, istouch, presses)
		if button == 1 then
			if self.isInside then
				self:focus()
				
				-- Find the cursor position
				if mouseX > self.transform:transformPoint(self.x,self.y) + love.graphics.getFont():getWidth(self.text) then
					-- If the mouse clicked on the spaces on the right of the text
					self.cursorPosition = string.len(self.text)
				else
					for i = 0, string.len(self.text) do
						local substring = string.sub(self.text, 1, i)
						local substringWidth = love.graphics.getFont():getWidth(substring)
						local lastCharacter = string.sub(self.text, -1)
						local lastCharacterWidth = love.graphics.getFont():getWidth(lastCharacter)
						
						if mouseX - lastCharacterWidth/2 <= self.transform:transformPoint(self.x,self.y) + substringWidth then
							self.cursorPosition = i
							break
						end
					end
				end
			elseif self.isFocusing then
				self:enter()
			end
		end
	end,
	
	focus = function (self)
		self.isFocusing = true
	end,
	
	enter = function (self)
		self.isFocusing = false
		
		self.value = tonumber(self.text) or self.value
	end,
	
	mouseMoved = function (self, x, y, dx, dy, istouch )
		if self:findIsInside(x,y) then
			self:mouseEntered()
		else
			self:mouseExited()
		end
	end,
	
	keyPressed = function (self, key)
		if self.isFocusing then
			if key == "return" or key == "kpenter" then
				self:enter()
				
			elseif key == "backspace" then
				self.text = string.sub(self.text, 0, self.cursorPosition-1) .. string.sub(self.text, self.cursorPosition+1, string.len(self.text))
				self.cursorPosition = self.cursorPosition - 1
				
			elseif key == "left" then
				self.cursorPosition = self.cursorPosition - 1
				self.cursorPosition = math.clamp(self.cursorPosition, 0, self.text:len())
				
			elseif key == "right" then
				self.cursorPosition = self.cursorPosition + 1
				self.cursorPosition = math.clamp(self.cursorPosition, 0, self.text:len())
				
			elseif key == "home" then
				self.cursorPosition = 0
				
			elseif key == "end" then
				self.cursorPosition = self.text:len()
			end
		end
	end,
	
	textInput = function (self, ch)
		if self.isFocusing then
			self.text = string.sub(self.text, 0, self.cursorPosition) .. ch .. string.sub(self.text, self.cursorPosition+1, string.len(self.text))
			self.cursorPosition = self.cursorPosition + 1
		end
	end,
	
	getIsFocusing = function (self)
		return self.isFocusing
	end,
}