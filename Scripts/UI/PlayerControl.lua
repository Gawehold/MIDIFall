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
		if self:getIsInside() and button == 1 then
			self.isClicking = true
		end
		
		if button == 1 then
			local mouseClickedTime = love.timer.getTime()
			
			if mouseClickedTime - self.lastMouseClickedTime <= self.doubleClickInterval then
				player:pauseOrResume()
			end
		
			self.lastMouseClickedTime = mouseClickedTime
			
		elseif button == 3 then
			love.window.setFullscreen(not select(3, love.window.getMode()).fullscreen)
		end
	end,
	
	mouseReleased = function (self, mouseX, mouseY, istouch, presses)
		self.isClicking = false
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
			mainComponent:setOrientation((mainComponent.orientation+1)%4)
			
		elseif key == "escape" then
			-- love.event.quit()
			uiManager:getSettingsMenu():openOrClose()
			
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
	
	fileDropped = function (self, file)
		if displayComponentsRenderer:getIsExportingVideo() then
			return
		end
		
		local extension = nil
		local filename = file:getFilename()
		local len = string.len(filename)
		
		for i = 0, len-1 do
			local str = string.sub(filename, len-i, len)
			if string.sub(str, 1, 1) == "." then
				extension = string.lower(str)
				break
			end
		end
		
		-- if not extension then
			-- love.window.showMessageBox("Error", "", "error")
		-- end
		
		if extension == ".mid" then
			player:loadSongFromFile(file)
			uiManager:getComponents()[1]:initializeTracksPanel()
			
		elseif extension == ".jpg" or extension == ".png" or extension == ".bmp" or extension == ".jpeg" then
			local data
			if file:open("r") then
				data = file:read()
				file:close()
			end
		
			local dataFile = love.filesystem.newFileData(data, "backgroundImage")
			local imageData = love.image.newImageData(dataFile)

			mainComponent.backgroundComponent.image = love.graphics.newImage(imageData)
		
		elseif extension == ".mfp" then
			propertiesManager:load(file:getFilename())
		elseif extension == ".mftc" then
			mainComponent:getThemeManager():loadTheme(file:getFilename())
		end
	end,
	
	resize = function (self, w, h)
	end,
	
	getIsInside = function (self)
		return true
	end,
	
	getIsFocusing = function (self)
		return false
	end,
	
	getIsClicking = function (self)
		return self.isClicking
	end,
}