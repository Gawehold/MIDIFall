class "BackgroundComponent" {
	extends "DisplayComponent",
	
	-- Override
	new = function (self, left,right,top,bottom)
		self:super(left,right,top,bottom)
		
		self.image = nil
		self.fits = {true, true}
		self.scales = {0.2, 0.2}
		self.offsets = {0, 0}
		self.isAlignCentre = false
		
		-- self:setImage("D:/MIDIFall_Project/MIDIFall/Assets/1186946-free-wallpaper-for-vertical-monitor-1440x3440.jpg")
		self:setImage("D:/MIDIFall_Project/MIDIFall/Assets/no_character.png")
	end,
	
	-- Implement
	update = function (self, dt)
	end,
	
	-- Implement
	draw = function (self, screenWidth,screenHeight)
		
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
		
		if self.isAlignCentre then
			offsets[1] = (screenWidth - scales[1]*self.image:getWidth()) / 2
			offsets[2] = (screenHeight - scales[2]*self.image:getHeight()) / 2
		end
		
		-- Draw the background image
		love.graphics.setColor(1,1,1)
		love.graphics.draw(self.image, screenWidth*self.x+offsets[1], screenHeight*self.y+offsets[2], 0, scales[1], scales[2])
	end,
	
	setImage = function (self, path)
		local file = io.open(path, "rb")
		local fileData
		
		if file then
			fileData = love.filesystem.newFileData(file:read("*a"), "backgroundImageFile")
			file:close()
		end
		
		local imageData = love.image.newImageData(fileData)
		self.image = love.graphics.newImage(imageData)
	end,
}