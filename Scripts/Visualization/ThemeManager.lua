class "ThemeManager" {
	new = function (self)
		self.name = ""
		self.author = ""
		self.version = -1
		self:reset()
		
		self.enabled = true
	end,
	
	loadTheme = function (self, path)
		path = string.gsub(path, "\\", "/")
		local configFile = io.open(path, "r")
		local directory = string.match(path, "^(.+)/")
		-- local directory = string.match(path, "/(.+)/")
		-- directory = string.match(directory , "/([^/]+)$")
		
		local environment
		for line in configFile:lines() do
			if line == "@MIDIFall Theme Configuration File" then
				environment = self
			
			elseif line == "@Regular Note" then
				environment = mainComponent.notesComponent.regularNoteSprite
				mainComponent.notesComponent.useDefaultTheme = false
				
			elseif line == "@Diamond Note" then
				environment = mainComponent.notesComponent.diamondNoteSprite
				mainComponent.notesComponent.useDefaultTheme = false
				
			elseif string.sub(line, 1, 4) == "@Key" then
				environment = mainComponent.keyboardComponent.sprites[tonumber(string.sub(line, 6))]
				mainComponent.keyboardComponent.useDefaultTheme = false
				
			elseif line == "@Particle" then
				environment = mainComponent.hitAnimationComponent.sprite
				mainComponent.hitAnimationComponent.useDefaultTheme = false
				
			elseif line == "@Fallen Note" then
				environment = mainComponent.fallsComponent.sprite
				mainComponent.fallsComponent.useDefaultTheme = false
			
			elseif line == "@End" then
				if environment ~= self then
					environment:new(environment.image, environment.rect, environment.edgeScales, environment.scales,
					environment.offsets, environment.sizeOffsets)
				end
			
			elseif string.sub(line, 1,1) == "@" then
				break
				
			elseif line == "" then
			
			else
				if string.match(line, "^[%s]*imagePath[%s]*=.*") then
					local imagePathEnvironment = {}
					local func = loadstring(line)
					setfenv(func, imagePathEnvironment)
					func()
					
					local imageFile = io.open(directory.."/"..imagePathEnvironment.imagePath, "rb")
					local fileData = love.filesystem.newFileData(imageFile:read("*a"), imagePathEnvironment.imagePath)
					local imageData = love.image.newImageData(fileData)
					
					environment.image = love.graphics.newImage(imageData)
					imageFile:close()
				else			
					local func = loadstring(line)
					setfenv(func, environment)
					func()
				end
			end
		end
		
		configFile:close()
	end,
	
	reset = function (self)
		self.name = "Default Theme"
		self.author = "Gawehold"
		self.version = 1.0
		
		if mainComponent then
			mainComponent.notesComponent.useDefaultTheme = true
			mainComponent.keyboardComponent.useDefaultTheme = true
			mainComponent.hitAnimationComponent.useDefaultTheme = true
			mainComponent.fallsComponent.useDefaultTheme = true
		end
	end,
}