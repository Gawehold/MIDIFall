class "UIColorPickerToggle" {
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
	
	new = function (self, x,y,width,height, colorHueAlias,colorSaturationAlias,colorValueAlias,colorAlphaAlias)
		UIButton.instanceMethods.new(self, x,y,width,height, nil, nil, UIColorPickerToggle.toggleMenu)
		
		self.choices = choices
		self.choiceID = defaultChoiceID
		
		self.text = "C"
		
		self.addedMenuToParent = false	-- The parent object is created AFTER this object is created, so we cannot add the menu as a child right now
		
		self.menu = UIColorPicker(-0.85,0.25, 0.8,0.5, colorHueAlias,colorSaturationAlias,colorValueAlias,colorAlphaAlias)
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
}