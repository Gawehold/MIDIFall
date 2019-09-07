class "UIPanel" {
	extends "UIObject",
	
	new = function (self, x,y, width,height, ...)
		-- self:super(x,y, width,height)
		UIObject.instanceMethods.new(self, x,y, width,height) -- self.super not working for two level inhertance
		
		self.isOpened = true
		
		self.shift = 0
		self.shiftStep = 0.05
		
		self.paddings = {0.1,0.05,0.1,0.05}
		
		self.pages = nil
		self.homepageID = nil
		self.homepage = nil
		self.children = nil
		self:setPages(...)
		
		self.cornerRadiuses = {0,0}
		
		self.childrenTransform = love.math.newTransform()
		
		-- self.blurringShader = love.graphics.newShader([[
			-- float dx = 1 / 1920;
			-- float dy = 1 / 1080;
			
			-- float kernal[25] = float[](
				-- 0.003765, 0.015019, 0.023792, 0.015019, 0.003765,
				-- 0.015019, 0.059912, 0.094907, 0.059912, 0.015019,
				-- 0.023792, 0.094907, 0.150342, 0.094907, 0.023792,
				-- 0.015019, 0.059912, 0.094907, 0.059912, 0.015019,
				-- 0.003765, 0.015019, 0.023792, 0.015019, 0.003765
			-- );
			
			-- vec4 effect(vec4 color, Image texture, vec2 textureCoords, vec2 screenCoords) {
				-- vec4 averagedcolor;
				
				-- for (int i = -2; i <= 2; i++) {
					-- for (int j = -2; j <= 2; j++) {
						-- averagedcolor += kernal[5*i + j] * Texel(texture, textureCoords + vec2(dx*j, dy*i));
					-- }
				-- }
				
				-- return averagedcolor * color;
			-- }
		-- ]])
	end,
	
	setPages = function (self, ...)
		self.pages = {}
		for i = 1, select("#", ...) do
			local page = select(i, ...)
			self.pages[i] = page
			
			for k,v in ipairs(page) do
				v:setParent(self)
			end
		end
		
		self.homepageID = 1
		self.homepage = self.pages[self.homepageID]
		
		self.children = self.pages[self.homepageID] or {}
	end,
	
	update = function (self, dt, transform)
		if not self.isOpened then
			return
		end
		
		self.transform = transform
		
		self.childrenTransform = self.transform:clone()
		self.childrenTransform:translate(0, self.shiftStep*self.shift)
		
		self.childrenTransform:scale(
			(1-(self.paddings[1]+self.paddings[3])) * self.width,
			(1-(self.paddings[2]+self.paddings[4])) * self.height
		)
		
		self.childrenTransform:translate(
			(self.x + (self.paddings[1]*self.width)) / ((1-(self.paddings[1]+self.paddings[3])) * self.width),
			(self.y + (self.paddings[2]*self.height)) / ((1-(self.paddings[2]+self.paddings[4])) * self.height)
		)
		
		for k,v in ipairs(self.children) do
			v:update(dt, self.childrenTransform)
		end
	end,
	
	draw = function (self)
		if not self.isOpened then
			return
		end
		
		love.graphics.push()
		
			if self.transform then
				love.graphics.applyTransform(self.transform)
			end
			
			love.graphics.setColor(0,0,0,0.8)
			love.graphics.rectangle("fill", self.x,self.y, self.width,self.height,self.cornerRadiuses[1],self.cornerRadiuses[2])
		
		love.graphics.pop()
		
		-- local prevScissorX, prevScissorY, prevScissorWidth, prevScissorHeight = love.graphics.getScissor()
		-- local scissorX, scissorY = self.childrenTransform:transformPoint(0, 0)
		-- local scissorX2, scissorY2 = self.childrenTransform:transformPoint(1, 1)
		-- local scissorWidth, scissorHeight = scissorX2 - scissorX, scissorY2 - scissorY
		
		-- love.graphics.setScissor(scissorX,scissorY, scissorWidth,scissorHeight)
		
		for k,v in ipairs(self.children) do
			v:draw()
		end
		-- love.graphics.setScissor(prevScissorX, prevScissorY, prevScissorWidth, prevScissorHeight)
	end,
	
	mousePressed = function (self, mouseX, mouseY, button, istouch, presses)
		if not self.isOpened then
			return
		end
		
		if self:getIsInside() and button == 1 then
			self.isClicking = true
		end
		
		for k,v in ipairs(self.children) do
			v:mousePressed(mouseX, mouseY, button, istouch, presses)
		end
	end,
	
	mouseReleased = function (self, mouseX, mouseY, istouch, presses)
		if not self.isOpened then
			return
		end
		
		self.isClicking = false
		
		for k,v in ipairs(self.children) do
			v:mouseReleased(mouseX, mouseY, istouch, presses)
		end
	end,
	
	wheelMoved = function (self, x, y)
		if not self.isOpened then
			return
		end
		
		if self.isInside then
			for k,v in ipairs(self.children) do
				if y > 0 and v.y + self.shiftStep*self.shift < self.y then
					self.shift = self.shift + y
					break
				elseif y < 0 and v.y + v.height + self.shiftStep*self.shift > self.height then
					self.shift = self.shift + y
					break
				end
			end
			
			for k,v in ipairs(self.children) do
				v:wheelMoved(x, y)
			end
		end
	end,
	
	mouseMoved = function (self, x, y, dx, dy, istouch )
		if not self.isOpened then
			return
		end
		
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
		if not self.isOpened then
			return
		end
		
		for k,v in ipairs(self.children) do
			v:keyPressed(key)
		end
	end,
	
	keyReleased = function (self, key)
		if not self.isOpened then
			return
		end
		
		for k,v in ipairs(self.children) do
			v:keyReleased(key)
		end
	end,
	
	textInput = function (self, ch)
		if not self.isOpened then
			return
		end
		
		for k,v in ipairs(self.children) do
			v:textInput(ch)
		end
	end,
	
	fileDropped = function (self, file)
		for k,v in ipairs(self.children) do
			v:fileDropped(file)
		end
	end,
	
	resize = function (self, w, h)
		for k,v in ipairs(self.children) do
			v:resize(w, h)
		end
	end,
	
	getIsInside = function (self)
		local isInside = self.isInside
		
		for k,v in ipairs(self.children) do
			isInside = isInside or v:getIsInside()
		end
		
		return isInside
	end,
	
	getIsFocusing = function (self)
		for k,v in ipairs(self.children) do
			if v.getIsFocusing and v:getIsFocusing() then
				return true
			end
		end
		
		return false
	end,
	
	getIsClicking = function (self)
		local isClicking = self.isClicking
		
		for k,v in ipairs(self.children) do
			isClicking = isClicking or v:getIsClicking()
		end
		
		return isClicking
	end,
	
	addChild = function (self, child)
		table.insert(self.children, child)
		child:setParent(self)
	end,
	
	open = function (self)
		self.isOpened = true
	end,
	
	close = function (self)
		-- Return
		-- True:	If self is closed
		-- False:	If self is not closed
		
		if self.children == self.homepage then
			self.isOpened = false
			return true
		else
			self:changePage(self.homepageID)
			return false
		end
	end,
	
	closeTopPanels = function (self)
		-- Return
		-- True:	The top panel is self
		-- False:	The top panel is not self
		
		local openedChildPanel = nil
		
		for k,v in ipairs(self.children) do
			if v.closeTopPanels and v:getIsOpened() then	-- v.closeTopPanels is to check if it is a Panel/descendant object of Panel
				openedChildPanel = v
				v:closeTopPanels()
			end
		end
		
		if openedChildPanel then
			return false
		else
			return self:close()
		end
	end,
	
	closeChildrenPanels = function (self)
		for k,v in ipairs(self.children) do
			if v.closeTopPanels and v:getIsOpened() then	-- v.closeTopPanels is to check if it is a Panel/descendant object of Panel
				openedChildPanel = v
				v:closeTopPanels()
			end
		end
	end,
	
	toggle = function (self)
		if not self.isOpened then
			-- Close sibling panels
			self.parent:closeChildrenPanels()
		end
		self.isOpened = not self.isOpened
	end,
	
	getIsOpened = function (self)
		return self.isOpened
	end,
	
	changePage = function (self, pageID)
		self.children = self.pages[pageID]
	end,
}