class "UIInputBox" {
	extends "UIObject",
	
	new = function (self, x,y,width,height, valueAlias, isNumber, minValue, maxValue)
		self:super(x,y, width,height)
		
		self.value = valueAlias
		
		if isNumber ~= nil then
			self.isNumber = isNumber
		else
			self.isNumber = true
		end
		
		self.minValue = minValue
		self.maxValue = maxValue
		
		self.isFocusing = false
		self.cursorPosition = 0
		self.padding = 0.02
		
		self.text = UIText(x+self.padding,y, width-2*self.padding,height, tostring(self.value), 1, false,true)
	end,
	
	update = function (self, dt, transform)
		self.transform = transform
		self.text:update(dt, transform)
		
		if not self.isFocusing then
			self.text:setText(tostring(self.value))
		end
	end,
	
	draw = function (self)
		-- Draw the box
		local boxX, boxY = self.transform:transformPoint(self.x, self.y)
		local boxX2, boxY2 = self.transform:transformPoint(self.x+self.width, self.y+self.height)
		local boxWidth = boxX2 - boxX
		local boxHeight = boxY2 - boxY
		
		if self.isFrozen then
			love.graphics.setColor(0.5,0.5,0.5,0.8)
			love.graphics.rectangle("fill", boxX,boxY, boxWidth,boxHeight, boxHeight/8,boxHeight/8)
			
			self.text:setColor(0,0,0,0.8)
			self.text:draw()
		else	
			if self.isFocusing then
				love.graphics.setColor(1,1,1,0.8)
				-- love.graphics.rectangle("fill", boxX,boxY, boxWidth,boxHeight, boxHeight/8,boxHeight/8)
				
				love.graphics.setColor(0,0.5,1,1)
				love.graphics.setLineWidth((boxWidth+boxHeight) / 128)
				love.graphics.rectangle("line", boxX,boxY, boxWidth,boxHeight, boxHeight/8,boxHeight/8)
			else
				love.graphics.setColor(1,1,1,0.8)
				love.graphics.rectangle("fill", boxX,boxY, boxWidth,boxHeight, boxHeight/8,boxHeight/8)
			end
			
			-- Draw cursor
			if self.isFocusing then
				love.graphics.setColor(0,0.5,1,1)
				
				local font = self.text:getFont()
				
				local cursorX, cursorY = self.transform:transformPoint(self.x + self.padding, self.y)
				cursorX = cursorX + self.text:getScale() * ( font:getWidth(string.sub(self.text:getText(), 1, self.cursorPosition)) + font:getWidth(" ")/2 )
				
				love.graphics.line(cursorX,cursorY+4*love.graphics.getLineWidth(), cursorX,boxY2-4*love.graphics.getLineWidth())
			end
			
			if self.isFocusing then
				self.text:setColor(0,0.5,1,1)
			else
				self.text:setColor(0,0,0,0.8)
			end
			self.text:draw()
		end
	end,
	
	mousePressed = function (self, mouseX, mouseY, button, istouch, presses)
		if not self.transform then
			return
		end
		
		local textObj = self.text
		local text = self.text:getText()
		
		local startPositionOfText = self.transform:transformPoint(self.x+self.padding,self.y)
		
		if button == 1 then
			if self.isInside then
				self:focus()
				-- Find the cursor position
				if mouseX > startPositionOfText + textObj:getSubstringWidth(1) then
					-- If the mouse clicked on the spaces on the right of the text
					self.cursorPosition = string.len(text)
				else
					for i = 0, string.len(text) do
						local substringWidth = textObj:getSubstringWidth(1, i)
						local lastCharacterWidth = textObj:getSubstringWidth(-1)
						
						if mouseX - lastCharacterWidth / 2 <= startPositionOfText + substringWidth then
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
		if self.isFrozen then
			return
		end
		
		self.isFocusing = true
	end,
	
	enter = function (self)
		self.isFocusing = false
		
		if self.isNumber then
			self.value = tonumber(self.text:getText()) or self.value
			
			if self.minValue and self.maxValue then
				self.value = math.clamp(self.value, self.minValue, self.maxValue)
			end
		else
			self.value = self.text:getText()
		end
	end,
	
	mouseMoved = function (self, x, y, dx, dy, istouch )
		if self:findIsInside(x,y) then
			self:mouseEntered()
		else
			self:mouseExited()
		end
	end,
	
	keyPressed = function (self, key)	
		if self.isFrozen then
			return
		end
		
		if self.isFocusing then
			local text = self.text:getText()
			
			if key == "return" or key == "kpenter" then
				self:enter()
				
			elseif key == "backspace" then
				text = string.sub(text, 0, self.cursorPosition-1) .. string.sub(text, self.cursorPosition+1, string.len(text))
				self.cursorPosition = math.max(self.cursorPosition - 1, 0)
				
				self.text:setText(text)
				
			elseif key == "left" then
				self.cursorPosition = self.cursorPosition - 1
				self.cursorPosition = math.clamp(self.cursorPosition, 0, text:len())
				
			elseif key == "right" then
				self.cursorPosition = self.cursorPosition + 1
				self.cursorPosition = math.clamp(self.cursorPosition, 0, text:len())
				
			elseif key == "home" then
				self.cursorPosition = 0
				
			elseif key == "end" then
				self.cursorPosition = text:len()
			end
		end
	end,
	
	textInput = function (self, ch)
		if self.isFrozen then
			return
		end
		
		if self.isFocusing then
			local text = self.text:getText()
			
			text = string.sub(text, 0, self.cursorPosition) .. ch .. string.sub(text, self.cursorPosition+1, string.len(text))
			self.cursorPosition = self.cursorPosition + 1
			
			self.text:setText(text)
		end
	end,
	
	getIsFocusing = function (self)
		return self.isFocusing
	end,
	
	setIsFrozen = function (self, isFrozen)
		UIObject.instanceMethods.setIsFrozen(self, isFrozen)
		if self.isFrozen then
			self:enter()
		end
	end,
}