class "PlayerControl" {
	new = function (self)
		self.lastMouseClickedTime = -math.huge
		self.doubleClickInterval = 0.3
	end,
	
	update = function (self, dt)
	end,
	
	draw = function (self)
	end,
	
	mousePressed = function (self, mouseX, mouseY, button, istouch, presses)
		local mouseClickedTime = love.timer.getTime()
		
		if mouseClickedTime - self.lastMouseClickedTime <= self.doubleClickInterval then
			player:pauseOrResume()
		end
	
		self.lastMouseClickedTime = mouseClickedTime
	end,
	
	mouseReleased = function (self, mouseX, mouseY, istouch, presses)
	end,

	mouseMoved = function (self, x, y, dx, dy, istouch)
		if love.mouse.isDown(1) then
			if math.abs(dx) > 0 then
				player:pause()
			end
			
			local speed = 1
			if love.keyboard.isDown("lctrl") then speed = 1/4 end
			if love.keyboard.isDown("lshift") then speed = 4 end
			
			local timeDivision = player:getSong():getTimeDivision()
			player:moveToTime(player:getTimeManager():getTime()-timeDivision*speed*dx/100)
		end
	end,
	
	wheelMoved = function (self, x, y)
		player:pause()
		
		local speed = 4
		if love.keyboard.isDown("lctrl") then speed = speed * 1/4 end
		if love.keyboard.isDown("lshift") then speed = speed * 4 end
		
		local timeDivision = player:getSong():getTimeDivision()
		player:moveToTime(player:getTimeManager():getTime()-timeDivision*speed*y)
	end,

	keyPressed = function(self, key)
		if key == "o" then
			defaultTheme:setOrientation((defaultTheme.orientation+1)%4)
			
		elseif key == "escape" then
			love.event.quit()
			
		elseif key == "f12" then
			love.window.setFullscreen(not select(3, love.window.getMode()).fullscreen)
			
		elseif key == "space" then
			player:pauseOrResume()
		
		elseif key == "home" then
			player:moveToBeginning()
			
		elseif key == "end" then
			player:moveToEnd()
			
		elseif key == "printscreen" then
			-- local image = project.graphics.canvas:newImageData(0,0, screenWidth,screenHeight):encode("png"):getString()
			-- local folderName = "Screenshot"
			
			-- if not love.filesystem.exists(folderName) then
				-- os.execute("mkdir " .. folderName)
			-- end
			
			-- local fp = io.open(folderName.."\\"..filename, "wb")
			-- fp:write(image)
			-- fp:close()
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