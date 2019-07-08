class "PlayerControl" {
	new = function (self)
	end,
	
	update = function (self, dt)
	end,
	
	draw = function (self)
	end,
	
	mousePressed = function (self, mouseX, mouseY, button, istouch, presses)
	end,
	
	mouseReleased = function (self, mouseX, mouseY, istouch, presses)
	end,

	mouseMoved = function (self, x, y, dx, dy, istouch)
		if love.mouse.isDown(1) then
			if math.abs(dx) > 0 then
				player:pause()
			end
		
			if dx > 0 then
				-- player:initiailzeStates()
			end
			
			local speed = 1
			if love.keyboard.isDown("lctrl") then speed = 1/4 end
			
			player:getTimeManager():setTime(player:getTimeManager():getTime()-dx)
		end
	end,
	
	wheelMoved = function (self, x, y)
	end,

	keyPressed = function(self, key)
		if key == "o" then
			defaultTheme:setOrientation((defaultTheme.orientation+1)%4)
		elseif key == "escape" then
			love.event.quit()
		end
	end,
	
	keyReleased = function (self, key)
	end,
	
	textInput = function (self, ch)
	end,
	
	getIsInside = function (self)
		return true
	end,
	
	getIsFocusing = function (self)
		return false
	end,
}