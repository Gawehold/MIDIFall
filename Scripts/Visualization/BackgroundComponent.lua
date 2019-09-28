class "BackgroundComponent" {
	extends "DisplayComponent",
	
	-- Override
	new = function (self, left,right,top,bottom)
		self:super(left,right,top,bottom)
		
		self.image = love.graphics.newImage("Assets/background.png")
		self.fits = {true, true}
		self.scales = {1, 1}
		self.offsets = {0, 0}
		self.isAligncenter = false
		self.colorHSVA = {1,0,1,1}
		
		-- self:setImage("D:/MIDIFall_Project/MIDIFall/Assets/transparent.png")
	end,
	
	-- Implement
	update = function (self, dt)
	end,
	
	-- Implement
	draw = function (self, screenWidth,screenHeight)
		if not self.enabled then
			return
		end
		
		-- Find out the display scales of the background image
		local scales = {self.scales[1], self.scales[2]}
		
		if self.fits[1] then
			scales[1] = screenWidth / self.image:getWidth()
		end
		
		if self.fits[2] then
			scales[2] = screenHeight / self.image:getHeight()
		end
		
		-- Find out the display offsets of the background image
		local offsets = {screenWidth*self.offsets[1], screenHeight*self.offsets[2]}
		
		if self.isAligncenter then
			offsets[1] = offsets[1] + (screenWidth - scales[1]*self.image:getWidth()) / 2
			offsets[2] = offsets[2] + (screenHeight - scales[2]*self.image:getHeight()) / 2
		end
		
		-- Draw the background image
		love.graphics.setColor(vivid.HSVtoRGB(self.colorHSVA))
		love.graphics.draw(self.image, screenWidth*self.x+offsets[1], screenHeight*self.y+offsets[2], 0, scales[1], scales[2])
	end,
	
	setImage = function (self, path)
		local file = io.open(path, "rb")
		local fileData
		
		if file then
			fileData = love.filesystem.newFileData(file:read("*a"), "backgroundImageFile")
			file:close()
			
			local imageData = love.image.newImageData(fileData)
			self.image = love.graphics.newImage(imageData)
		end
	end,
}