class "NotesComponent" {
	extends "DisplayComponent",
	
	-- Override
	new = function (self, x,y, width,height)
		self:super(x,y, width,height)
		
		self.noteScale = 1.0
		self.noteLengthOffset = 0		-- TODO: offset not yet done!
		self.noteLengthFlooring = true
		
		self.colourAlpha = 0.8
		
		self.useRainbowColour = true
		self.rainbowColourHueShift = 0.45
		self.rainbowColourSaturation = 0.8
		self.rainbowColourValue = 0.8
		
		self.brightNote = true
		self.brightNoteSaturation = 0.6
		self.brightNodeValue = 0.9
		
		self.pitchBendSemitone = 12
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
		
		local firstNonFinishedNoteIDInTracks = player:getFirstNonFinishedNoteIDInTracks()
		local currentPitchBendValueInTracks = player:getCurrentPitchBendValueInTracks()
		
		--//////// Main Section ////////
		love.graphics.translate(0, absoluteKeyGap/2)
		
		for trackID = 1, #tracks do
		-- for trackID = 3,3 do
			local track = tracks[trackID]
			
			if track:getEnabled() then
				local notes = track:getNotes()
				local pitchBends = track:getPitchBends()
				local isPitchBendValueInTracksIncreasing = player:getIsPitchBendValueInTracksIncreasing()
				
				for noteID = firstNonFinishedNoteIDInTracks[trackID], #notes do
					local note = notes[noteID]
					local noteTime = note:getTime()
					local noteLength = note:getLength() or 0
					local notePitch = note:getPitch()
					
					if notePitch >= lowestKey and notePitch <= highestKey then
						local noteX = math.floor(screenWidth*self.x + noteScale * (noteTime-song:getInitialTime()) - pixelMoved)
						local noteY = (highestKey-notePitch) * spaceForEachKey
						local noteCulledWidth = math.max(leftBoundary - noteX, 0)
						
						-- If the current note is outside the right boundary, then so to the later notes
						if noteX >= screenWidth then
							break
						end
						
						--//////// Colouring ////////
						local h,s,v
						if self.useRainbowColour then
							h,s,v = ((notePitch-lowestKey) / highestKey + self.rainbowColourHueShift) % 1, self.rainbowColourSaturation, self.rainbowColourValue
						else
							h,s,v = unpack(track:getCustomColourHSV())
						end
						
						-- Brighten up the key while playing
						if self.brightNote and noteTime <= time then
							s = self.brightNoteSaturation
							v = self.brightNodeValue
						end
						
						love.graphics.setColor(vivid.HSVtoRGB(h,s,v,self.colourAlpha))
						
						
						--//////// Drawing ////////
						if track:getIsDiamond() then
							local size = math.max(12/7*((self.height*screenHeight) / (highestKey-lowestKey+1))*keyHeightRatio, 0)
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
							local noteHeight = math.max(((self.height*screenHeight) / (highestKey-lowestKey+1))*keyHeightRatio, 0)
							
							if noteTime <= time then
							-- if true then
							-- if false then
								local pbV = currentPitchBendValueInTracks[trackID]
								local pbShift = -self.pitchBendSemitone*spaceForEachKey * pbV/8192
								
								love.graphics.rectangle("fill", noteX+noteCulledWidth,noteY+pbShift, math.max(noteWidth-noteCulledWidth, 0),noteHeight)
								
							else
								-- love.graphics.rectangle("fill", noteX+noteCulledWidth,noteY, noteWidth-noteCulledWidth,noteHeight, noteHeight/2,noteHeight/2)
								love.graphics.rectangle("fill", noteX+noteCulledWidth,noteY, math.max(noteWidth-noteCulledWidth, 0),noteHeight)
								
								-- love.graphics.setColor(0,0,0)
								-- love.graphics.setLineWidth(4)
								-- love.graphics.rectangle("line", noteX+noteCulledWidth,noteY, noteWidth-noteCulledWidth,noteHeight)
							end
							-- love.graphics.setColor(1,1,1)
							-- love.graphics.print(noteID, noteX+noteCulledWidth,noteY)
							-- love.graphics.print(noteTime, 0,50,0,2)
							-- love.graphics.print(currentPitchBendValueInTracks[trackID], 0,70,0,2)
						end
					end
				end
			end
		end
		
		love.graphics.pop()
	end,
	
	getNotesScale = function (self)
		return self.noteScale
	end,
}
