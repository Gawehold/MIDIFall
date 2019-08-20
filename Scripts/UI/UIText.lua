class "UIText" {
	extends "UIObject",
	
	new = function (self, x,y,width,height, text, maxScale, horizontallyCentered, verticallyCentered, colorRGBA, isParagraph)
		self:super(x,y, width,height)
		self:setText(text or "")
		self.maxScale = maxScale or 1
		self.scale = self.maxScale
		self.verticallyCentered = verticallyCentered or false
		self.horizontallyCentered = horizontallyCentered or false
		self.colorRGBA = colorRGBA or {1,1,1,0.8}
		self.isParagraph = isParagraph or false
		
		self.font = love.graphics.getFont()
	end,
	
	update = function (self, dt, transform)
		self.transform = transform
	end,
	
	draw = function (self)
		self.font = love.graphics.getFont()
		
		local font = love.graphics.getFont()
		local fontHeight = font:getHeight()
		local spaceWidth = font:getWidth(" ")
		
		local boxX, boxY = self.transform:transformPoint(self.x, self.y)
		local boxX2, boxY2 = self.transform:transformPoint(self.x+self.width, self.y+self.height)
		local boxWidth = boxX2 - boxX
		local boxHeight = boxY2 - boxY
		
		-- love.graphics.setColor(1,1,1,0.8)
		-- love.graphics.rectangle("line", boxX,boxY, boxWidth,boxHeight)
		
		-- Find out the lines
		local wordX = boxX
		local wordY = boxY
		
		self.scale = self.maxScale
		
		local lines = {}
		local currentLine = 1
		
		for i,word in ipairs(self.words) do
			-- print(font:getWidth("ABCD"))
			if wordX + self.scale*font:getWidth(word) > boxX2 then
				if self.scale*font:getWidth(word) > boxWidth then
					-- If the space is too small for the word, then make the text smaller
					self.scale = boxWidth / (self.scale*font:getWidth(word))
				else
					-- Newline
					if self.isParagraph then
						wordX = boxX
						wordY = wordY + self.scale*fontHeight
						
						currentLine = currentLine + 1
					end
				end
			end
			
			lines[currentLine] = (lines[currentLine] or "") .. " " .. word
			-- love.graphics.print(word, wordX,wordY, 0, self.scale)
			
			wordX = wordX + self.scale*font:getWidth(word) + self.scale*spaceWidth
		end
		
		-- Draw lines
		if #lines * fontHeight > boxHeight then
			self.scale = math.min(self.scale, boxHeight / (#lines * fontHeight))
		end
		
		if not self.isParagraph and lines[1] then
			self.scale = math.min(self.scale, boxWidth / font:getWidth(lines[1]))
		end
		
		local linesHeight = #lines * self.scale * fontHeight
		
		love.graphics.push()
			love.graphics.setColor(self.colorRGBA)
			
			if self.verticallyCentered then
				love.graphics.translate(0, (boxHeight - linesHeight) / 2)
			end
				
			for i,line in ipairs(lines) do
				local lineX = boxX
				local lineY = boxY + (i-1) * self.scale * fontHeight
				
				if self.horizontallyCentered then
					lineX = lineX + ((boxWidth - self.scale * font:getWidth(line)) / 2)
				end
				
				love.graphics.print(line, lineX-font:getWidth(" ")/2, lineY, 0, self.scale)	-- the font:getWidth(" ")/2 is for translating the text a little bit to left so it aligns to the boxX. There is a spaceby default
			end
		love.graphics.pop()
	end,
	
	setText = function (self, text)
		self.text = text
		self.words = {}
		for word in self.text:gmatch("[^%s]+") do
			table.insert(self.words, word)
		end
	end,
	
	getText = function (self)
		return self.text
	end,
	
	setColor = function (self, ...)
		if type(select(1, ...)) == "table" then
			self.colorRGBA = ...
		else
			for i = 1, 4 do
				self.colorRGBA[i] = select(i, ...)
			end
		end
	end,
	
	getScale = function (self)
		return self.scale
	end,
	
	getSubstringWidth = function (self, i,j)	-- assume the substring is in a single line
		return self.scale * self.font:getWidth(string.sub(self.text, i,j))
	end,
	
	getColor = function (self)
		return self.colorRGBA
	end,
	
	getFont = function (self)
		return self.font
	end,
	
	setIsParagraph = function (self, isParagraph)
		self.isParagraph = isParagraph
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