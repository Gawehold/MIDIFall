class "NotesComponent" {
	extends "DisplayComponent",
	
	-- Override
	new = function (self, x,y, width,height)
		self:super(x,y, width,height)
		
		self.noteScale = 1
		self.noteLengthOffset = 0
		self.noteLengthFlooring = true
		
		self.colourAlpha = 0.9
		self.colourSaturation = 0.5
		self.colourValue = 0.5
		
		self.brightNote = true
		self.brightNoteSaturation = 0.4
		self.brightNodeValue = 1
		
		self.useRainbowColour = true
		self.rainbowColourHueShift = 0.5
	end,

	-- Implement
	update = function (self, dt)
		
	end,
	
	-- Implement
	draw = function (self, lowestKey, highestKey, keyGap)
		-- Caching -------------------
		local song = player:getSong()
		
		local tracks = song:getTracks()
		local time = player:getTimeManager():getTime()
		
		local screenWidth = love.graphics.getWidth()
		local screenHeight = love.graphics.getHeight()
		local resolutionRatio = screenWidth / screenHeight
		
		local heightForEachKey = screenHeight / (highestKey-lowestKey+1)
		local keyHeightRatio = 1 - keyGap
		
		local noteLengthOffset = resolutionRatio * self.noteScale*128 * self.noteLengthOffset	-- 1.0 = a crotchet
		
		local noteScale = self.noteScale*128/song:getTimeDivision()
		local pixelMoved = math.floor(noteScale*(time-song:getInitialTime()))
		
		local leftBoundary = math.floor(self.x * screenWidth)
		
		local firstNonFinishedNoteIDInTracks = player:getfirstNonFinishedNoteIDInTracks()
		local currentPitchBendValueInTracks = player:getCurrentPitchBendValueInTracks()
		
		-- Drawing -------------------
		for trackID = 1, #tracks do
			local track = tracks[trackID]
			
			if track:getEnabled() then
				local notes = track:getNotes()
				local pitchBends = track:getPitchBends()
				
				for noteID = firstNonFinishedNoteIDInTracks[trackID], #notes do
					local note = notes[noteID]
					local noteTime = note:getTime()
					local noteLength = note:getLength() or 0
					local notePitch = note:getPitch()
					
					if notePitch >= lowestKey and notePitch <= highestKey then
						local noteX = math.floor(screenWidth*self.x + noteScale * (noteTime-song:getInitialTime()) - pixelMoved)
						local noteY = (highestKey-notePitch) * heightForEachKey
						local noteCulledWidth = math.max(leftBoundary - noteX, 0)
						
						-- If the current note is outside the right boundary, then so to the later notes
						if noteX >= screenWidth then
							break
						end
						
						
						local h,s,v
						if self.useRainbowColour then
							h,s,v = ((notePitch-lowestKey) / highestKey + self.rainbowColourHueShift) % 1, self.colourSaturation, self.colourValue
						else
							local chColourPtr = tracks.colour[trackID]
							h,s,v = chColourPtr[1], chColourPtr[2], chColourPtr[3]
						end
						
						-- Brighten up the key while playing
						if self.brightNote and noteTime <= time then
							s = self.brightNoteSaturation
							v = self.brightNodeValue
						end
						
						love.graphics.setColor(vivid.HSVtoRGB(h,s,v,self.colourAlpha))
						
						if track:getIsDiamond() then
							local size = math.max(12/7*(screenHeight / (highestKey-lowestKey+1))*keyHeightRatio, 0)
							local halfSize = size / 2
							
							love.graphics.polygon("fill",
								noteX+noteCulledWidth, noteY,
								math.max(noteX+noteCulledWidth-halfSize, leftBoundary), noteY+halfSize,
								noteX+noteCulledWidth, noteY+size,
								noteX+noteCulledWidth+halfSize, noteY+halfSize
							)
						else
							-- Here math.max seems to be unnecessary since it would be culled out before.
							-- However, the precision problem may cause a very small negative number.
							-- Hence, to prevent a note being shown outside the boundary, using a math.max is better.
							local noteWidth = math.ceil(math.max(noteScale*noteLength - self.noteLengthOffset, 0))
							local noteHeight = math.max((screenHeight / (highestKey-lowestKey+1))*keyHeightRatio, 0)
							
							-- if noteX <= 0 then
							if false then
								local pbV = currentPitchBendValueInTracks[trackID]
								local ky = pbV / 8192
								love.graphics.push()
								love.graphics.shear(0, -ky)
								love.graphics.rectangle("fill", noteX,noteY-(noteX)*ky, noteWidth,noteHeight)
								love.graphics.pop()
							else
								love.graphics.rectangle("fill", noteX+noteCulledWidth,noteY, noteWidth-noteCulledWidth,noteHeight)
							end
						end
					end
				end
			end
		end
	end,
}
