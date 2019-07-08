class "UIManager" {
	new = function (self)
		self.components = {
			SettingsMenu(),
			PlayerControl(),
		}
	end,
	
	update = function (self, dt)
		for k,v in ipairs(self.components) do
			v:update(dt)
		end
	end,
	
	draw = function (self)
		for k,v in ipairs(self.components) do
			v:draw()
		end
	end,
	
	mousePressed = function (self, mouseX, mouseY, button, istouch, presses)
		for k,v in ipairs(self.components) do
			v:mousePressed(mouseX, mouseY, button, istouch, presses)
			
			if v:getIsInside() then
				break
			end
		end
	end,

	mouseReleased = function (self, mouseX, mouseY, istouch, presses)
		for k,v in ipairs(self.components) do
			v:mouseReleased(mouseX, mouseY, istouch, presses)
			
			if v:getIsInside() then
				break
			end
		end
	end,

	mouseMoved = function (self, x, y, dx, dy, istouch)
		for k,v in ipairs(self.components) do
			v:mouseMoved(x, y, dx, dy, istouch)
			
			if v:getIsInside() then
				break
			end
		end
	end,
	
	wheelMoved = function (self, x, y)
		for k,v in ipairs(self.components) do
			v:wheelMoved(x, y)
			
			if v:getIsInside() then
				break
			end
		end
	end,

	keyPressed = function(self, key)
		for k,v in ipairs(self.components) do
			v:keyPressed(key)
			
			if v:getIsFocusing() then
				break
			end
		end
	end,
	
	keyReleased = function (self, key)
		for k,v in ipairs(self.components) do
			v:keyReleased(key)
		end
	end,
	
	textInput = function (self, ch)
		for k,v in ipairs(self.components) do
			v:textInput(ch)
		end
	end,
}