class "HitAnimationComponent" {
	extends "DisplayComponent",
	
	-- Override
	new = function (self, x,y, width,height)
		self:super(x,y, width,height)
		
		self.useRainbowColour = true
		self.rainbowColourHueShift = 0.5
		self.rainbowColourSaturation = 0.8
		self.rainbowColourValue = 0.8
	end,
	
	-- Implement
	update = function (self, dt)
	end,
	
	-- Implement
	draw = function (self, lowestKey, highestKey, keyGap)
		love.graphics.push()
		
		--//////// Common Infomation ////////
		local song = player:getSong()
		
		local tracks = song:getTracks()
		local time = player:getTimeManager():getTime()
		
		local screenWidth = love.graphics.getWidth()
		local screenHeight = love.graphics.getHeight()
		if self.orientation == 1 or self.orientation == 3 then
			if self.orientation == 1 then
				love.graphics.translate(0,screenHeight)
				love.graphics.scale(1,-1)
			end
			love.graphics.translate(screenWidth, 0)
			love.graphics.rotate(math.pi/2)
			
			screenWidth, screenHeight = screenHeight, screenWidth
			
		elseif self.orientation == 2 then
			love.graphics.translate(screenWidth, 0)
			love.graphics.scale(-1,1)
		end
		
		local spaceForEachKey = screenHeight / (highestKey-lowestKey+1)
		local keyHeightRatio = 1 - keyGap
		
		local leftBoundary = math.floor(self.x * screenWidth)
		local rightBoundary = leftBoundary + math.floor(self.width * screenWidth)
		
		local firstNonPlayedNoteIDInTracks = player:getFirstNonPlayedNoteIDInTracks()
		
		--//////// Main Section ////////
		for trackID = 1, #tracks do
			local track = tracks[trackID]
			
			if track:getEnabled() then
				local notes = track:getNotes()
				
				for noteID = firstNonPlayedNoteIDInTracks[trackID]-1, 1, -1 do
					
					local note = notes[noteID]
					local noteTime = note:getTime()
					local noteLength = note:getLength() or 0
					local notePitch = note:getPitch()
					
					if notePitch >= lowestKey and notePitch <= highestKey then
						local noteY = (highestKey-notePitch) * spaceForEachKey
						local noteHeight = math.max((screenHeight / (highestKey-lowestKey+1))*keyHeightRatio, 0)
						
						local h,s,v,a
						if self.useRainbowColour then
							h,s,v = ((notePitch-lowestKey) / highestKey + self.rainbowColourHueShift) % 1, self.rainbowColourSaturation, self.rainbowColourValue
						else
							h,s,v = unpack(track:getCustomColourHSV())
						end
						
						local t = math.max(time - noteTime, 0)
						local size = t/5+spaceForEachKey
						a = 1 - math.clamp((time - noteTime) / 100, 0, 1)
						
						if a <= 0 then
							break
						end
						
						love.graphics.setColor(vivid.HSVtoRGB(h,s,v,a))
						
						love.graphics.push()
							love.graphics.translate(leftBoundary,noteY)
							love.graphics.rectangle("fill", -size/2 -t*4 + 20, -size/2 + spaceForEachKey/2, size, size)
							
							size = t/3+spaceForEachKey
							love.graphics.rectangle("fill", -size/2 -t*3 + 20, -size/2 + spaceForEachKey/2-(t^2)/200, size, size)
							-- love.graphics.pop()
							
							size = t/2+spaceForEachKey
							love.graphics.rectangle("fill", -size/2 -t*2 + 20, -size/2 + spaceForEachKey/2+(t^2)/200, size, size)
						love.graphics.pop()
					end
				end
			end
		end
		
		love.graphics.pop()
	end,
}