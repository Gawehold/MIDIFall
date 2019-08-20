class "UIDropdown" {
	extends "UIButton",
	
	static {
		toggleMenu = function (self)
			if self.parent and not self.addedMenuToParent then
				self.parent:addChild(self.menu)
				self.addedMenuToParent = true
			end
			
			self.menu:toggle()
		end,
		
		openIcon = love.graphics.newImage("Assets/Arrow left icon 4.png"),
		closeIcon = love.graphics.newImage("Assets/Arrow right icon 4.png"),
	},
	
	new = function (self, x,y,width,height, choices, defaultChoiceID, choiceSelectedFunc)
		UIButton.instanceMethods.new(self, x,y,width,height, choices[defaultChoiceID], nil, UIDropdown.toggleMenu)
		
		self.choices = choices
		self.choiceID = defaultChoiceID
		
		self.choiceSelectedFunc = choiceSelectedFunc
		
		self.addedMenuToParent = false	-- The parent object is created AFTER this object is created, so we cannot add the menu as a child right now
		
		local meunButtons = {}
		for i,text in ipairs(choices) do
			meunButtons[i] = UIButton(0,(i-1)*(1/#choices-0.1)+0.14,1.0,1/#choices-0.1,text,nil, function() self:choiceSelected(i) end)
		end
		
		self.menu = UIPanel(-0.9,(1-(0.05*#choices+0.1))/2, 0.8,0.05*#choices+0.1, meunButtons)
		self.menu:close()
	end,
	
	-- update = function (self, dt, transform)
	-- end,
	
	draw = function (self)
		UIButton.instanceMethods.draw(self)
		
		local boxX, boxY = self.transform:transformPoint(self.x, self.y)
		local boxX2, boxY2 = self.transform:transformPoint(self.x+self.width, self.y+self.height)
		local boxWidth = boxX2 - boxX
		local boxHeight = boxY2 - boxY
		
		local icon
		if self.menu:getIsOpened() then
			icon = UIDropdown.closeIcon
		else
			icon = UIDropdown.openIcon
		end
		
		if self.isInside then
			love.graphics.setColor(0,0.5,1,1)
		else
			love.graphics.setColor(1,1,1,0.8)
		end
		
		local iconScale = (boxHeight / icon:getHeight()) * 0.5
		local iconX, iconY = self.transform:transformPoint(self.x,self.y)
		iconX = iconX + (boxHeight - iconScale*icon:getWidth()) / 2
		iconY = iconY + (boxHeight - iconScale*icon:getHeight()) / 2
		
		love.graphics.draw(icon, iconX,iconY, 0, iconScale)
	end,
	
	-- mousePressed = function (self, mouseX, mouseY, button, istouch, presses)
		-- if self.isInside and self.clicked and button == 1 then
			-- self:clicked()
		-- end
	-- end,
	
	-- mouseMoved = function (self, x, y, dx, dy, istouch )
		-- if self:findIsInside(x,y) then
			-- self:mouseEntered()
		-- else
			-- self:mouseExited()
		-- end
	-- end,
	
	choiceSelected = function (self, choiceID)
		self.choiceID = choiceID
		self.text:setText(self.choices[self.choiceID])
		
		if self.choiceSelectedFunc then
			self:choiceSelectedFunc(choiceID)
		end
	end,
}