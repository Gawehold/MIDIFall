class "FallsComponent" {
	extends "DisplayComponent",
	
	-- Override
	new = function (self, x,y, width,height)
		self:super(x,y, width,height)
		
		self.noteScale = 2
		self.noteLengthOffset = 0
		self.noteLengthFlooring = true
		
		self.colourAlpha = 0.8
		
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
		--//////// Common Infomation ////////
		local song = player:getSong()
		
		local tracks = song:getTracks()
		local time = player:getTimeManager():getTime()
		
		local screenWidth = love.graphics.getWidth()
		local screenHeight = love.graphics.getHeight()
		local resolutionRatio = screenWidth / screenHeight
		
		local spaceForEachKey = screenHeight / (highestKey-lowestKey+1)
		local keyHeightRatio = 1 - keyGap
		local noteLengthOffset = resolutionRatio * self.noteScale*128 * self.noteLengthOffset	-- 1.0 = a crotchet
		
		local noteScale = self.noteScale*128/song:getTimeDivision()
		local pixelMoved = math.floor(noteScale*(time-song:getInitialTime()))
		
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
						local noteX = math.floor(screenWidth*(self.x+self.width) + noteScale * (noteTime-time))
						local noteY = (highestKey-notePitch) * spaceForEachKey
						
						-- Here math.max seems to be unnecessary since it would be culled out before.
						-- However, the precision problem may cause a very small negative number.
						-- Hence, to prevent a note being shown outside the boundary, using a math.max is better.
						local noteWidth = math.ceil(math.max(noteScale*noteLength - self.noteLengthOffset, 0))
						local noteHeight = math.max((screenHeight / (highestKey-lowestKey+1))*keyHeightRatio, 0)
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
						
						a = math.clamp(1 - (time - (noteTime+noteLength))/200, 0, 1)
						
						love.graphics.setColor(vivid.HSVtoRGB(h,s,v,a))
						love.graphics.rectangle("fill", noteX,noteY, noteWidth,noteHeight)
						
						
					end
				end
			end
		end
	end,
}
