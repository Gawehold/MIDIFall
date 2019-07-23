class "FallsComponent" {
	extends "DisplayComponent",
	
	-- Override
	new = function (self, x,y, width,height)
		self:super(x,y, width,height)
		
		self.noteScale = 1.0
		self.noteLengthOffset = 0
		self.noteLengthFlooring = true
		
		self.colourAlpha = 0.8
		
		self.useRainbowColour = true
		self.rainbowColourHueShift = 0.45
		self.rainbowColourSaturation = 0.8
		self.rainbowColourValue = 0.8
		
		self.fadingOutSpeed = 0.6
	end,

	-- Implement
	update = function (self, dt)
		
	end,
	
	-- Implement
	draw = function (self, screenWidth,screenHeight, lowestKey, highestKey, keyGap)
		love.graphics.push()
		
		--//////// Common Infomation ////////
		local song = player:getSong()
		
		local tracks = song:getTracks()
		local time = player:getTimeManager():getTime()
		
		local timeDivision = song:getTimeDivision()
		local tempo = player:getTimeManager():getTempo()
		
		if self.orientation == 1 or self.orientation == 3 then
			if self.orientation == 1 then
				love.graphics.translate(0,self.height*screenHeight)
				love.graphics.scale(1,-1)
			end
			love.graphics.translate(screenWidth, 0)
			love.graphics.rotate(math.pi/2)
			
			screenWidth, screenHeight = screenHeight, screenWidth
			
		elseif self.orientation == 2 then
			love.graphics.translate(screenWidth, 0)
			love.graphics.scale(-1,1)
		end
		
		local resolutionRatio = screenWidth / (self.height*screenHeight)
		
		local spaceForEachKey = (self.height*screenHeight) / (highestKey-lowestKey+1)
		local keyHeightRatio = 1 - keyGap
		local noteLengthOffset = resolutionRatio * self.noteScale*128 * self.noteLengthOffset	-- 1.0 = a crotchet
		local absoluteKeyGap = keyGap*spaceForEachKey
		
		local noteScale = self.noteScale*128/song:getTimeDivision()
		local pixelMoved = math.floor(noteScale*(time-song:getInitialTime()))
		
		local leftBoundary = math.floor(self.x * screenWidth)
		local rightBoundary = leftBoundary + math.floor(self.width * screenWidth)
		
		local firstNonPlayedNoteIDInTracks = player:getFirstNonPlayedNoteIDInTracks()
		
		--//////// Main Section ////////
		love.graphics.translate(0, absoluteKeyGap/2)
		
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
						local noteX = math.floor(screenWidth*(self.x+self.width) + noteScale * (noteTime-time))
						local noteY = (highestKey-notePitch) * spaceForEachKey
						
						-- Here math.max seems to be unnecessary since it would be culled out before.
						-- However, the precision problem may cause a very small negative number.
						-- Hence, to prevent a note being shown outside the boundary, using a math.max is better.
						local noteWidth = math.ceil(math.max(noteScale*noteLength - self.noteLengthOffset, 0))
						local noteHeight = math.max(((self.height*screenHeight) / (highestKey-lowestKey+1))*keyHeightRatio, 0)
						noteWidth = math.max(math.min(rightBoundary - noteX, noteWidth), 0)	-- Cull out the note width outside the right boundary
						
						-- If the current note is outside the left boundary, then so to the later notes
						if noteX + noteWidth < leftBoundary then
							break
						end
						
						local h,s,v,a
						if self.useRainbowColour then
							h,s,v = ((notePitch-lowestKey) / highestKey + self.rainbowColourHueShift) % 1, self.rainbowColourSaturation, self.rainbowColourValue
						else
							h,s,v = unpack(track:getCustomColourHSV())
						end
						
						a = self.colourAlpha * math.clamp(1 - self.fadingOutSpeed * tempo * ((time - (noteTime+noteLength)) / timeDivision) / 100, 0, 1)
						
						love.graphics.setColor(vivid.HSVtoRGB(h,s,v,a))
						love.graphics.rectangle("fill", noteX,noteY, noteWidth,noteHeight)
						
						
					end
				end
			end
		end
		
		love.graphics.pop()
	end,
}
