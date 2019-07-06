class "UIManager" {
	new = function (self)
		self.components = {
			settingsMenu = SettingsMenu()
		}
	end,
	
	update = function (self, dt)
		for k,v in pairs(self.components) do
			v:update(dt)
		end
	end,
	
	draw = function (self)
		for k,v in pairs(self.components) do
			v:draw()
		end
	end,
	
	mousePressed = function (self, mouseX, mouseY, button, istouch, presses)
		for k,v in pairs(self.components) do
			v:mousePressed(mouseX, mouseY, button, istouch, presses)
		end
	end,

	mouseReleased = function (self, mouseX, mouseY, istouch, presses)
		for k,v in pairs(self.components) do
			v:mouseReleased(mouseX, mouseY, istouch, presses)
		end
	end,

	mouseMoved = function (self, x, y, dx, dy, istouch)
		for k,v in pairs(self.components) do
			v:mouseMoved(x, y, dx, dy, istouch)
		end
	end,

	keyPressed = function(self, key)
		for k,v in pairs(self.components) do
			v:keyPressed(key)
		end
	end,
}