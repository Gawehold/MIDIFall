class "NotesComponent" {
	extends "DisplayComponent",
	
	-- Override
	new = function (self, x,y, width,height)
		self:super(x,y, width,height)
		
		self.noteScale = 0.5
		self.noteLengthOffset = 0
		self.noteLengthFlooring = true
		self.brightNote = true
		self.noteAlpha = 0.9
		self.rainbow = true
		self.colourSaturation = 0.5
		self.colourValue = 0.5
		self.brightNoteSaturation = 0.4
		self.brightNodeValue = 1
		
		local song = player:getSong()
		local tracks = song:getTracks()
		
		self.isDiamondTracks = {}
		for trackID = 1, #tracks do
			self.isDiamondTracks[trackID] = false
		end
		
		self.firstNonFinishedNoteIdInTracks = {}
		for trackID = 1, #tracks do
			self.firstNonFinishedNoteIdInTracks[trackID] = 1
		end
	end,

	-- Implement
	update = function (self, dt)
		
	end,
	
	-- Implement
	draw = function (self, lowestKey, highestKey, keyHeight, trackIsVisible)
		local song = player:getSong()
		
		local tracks = song:getTracks()
		local time = player:getTimeManager():getTime()
		
		local screenWidth = love.graphics.getWidth()
		local screenHeight = love.graphics.getHeight()
		local resolutionRatio = screenWidth / screenHeight
		
		local noteLengthOffset = resolutionRatio * self.noteScale*128 * self.noteLengthOffset	-- 1.0 = a crotchet
		
		local noteScale = self.noteScale*128/song:getTimeDivision()
		local pixelMoved = math.floor(noteScale*(time-song:getInitialTime()))
		
		for trackID = 1, #tracks do
			if trackIsVisible[trackID] then
				local notes = tracks[trackID]:getNotes()
				
				for noteID = self.firstNonFinishedNoteIdInTracks[trackID], #notes do
					local note = notes[noteID]
					
					local noteTime = note:getTime()
					local noteLength = note:getLength() or 0
					
					if noteTime + noteLength >= time then
						local pitch = note:getPitch()
						local velocity = note:getVelocity()
						
						local noteX = noteScale * (noteTime-song:getInitialTime()) - pixelMoved
						
						-- If the current event is outside the screen, then so to the later events
						if self.x + noteX >= screenWidth then
							break
						end
						
						noteLength = noteScale*noteLength + math.min(noteX,0) - self.noteLengthOffset
						
						if velocity > 0 and math.max(noteX,0)+noteLength >= 0 then
							local h,s,v
							
							if self.rainbow then
								h, s, v = (pitch-lowestKey) / highestKey, self.colourSaturation, self.colourValue
							else
								local chColourPtr = tracks.colour[trackID]
								h, s, v = chColourPtr[1], chColourPtr[2], chColourPtr[3]
							end
							
							-- Brighter when hitting
							if self.brightNote and noteX <= 0 then
								s = self.brightNoteSaturation
								v = self.brightNodeValue
							end
							
							local r,g,b = vivid.HSVtoRGB(h,s,v)
							
							local px = math.max(math.floor(noteX), 0) + self.x
							local py = screenHeight * (1 - ((pitch-lowestKey+1) / (highestKey+1))) + self.y + ((screenHeight / (highestKey-lowestKey+1))*(1-keyHeight)/2)
							
							if self.isDiamondTracks[trackID] then
								local size = screenHeight / (highestKey-lowestKey+1)
								
								py = py + size / 2
								
								if py+size >= 0 and py-size < screenHeight then
									love.graphics.setColor(r, g, b, self.noteAlpha)
									love.graphics.polygon("fill",
										px,			py-size,
										px-size, 	py,
										px,			py+size,
										px+size, 	py
									)
								end
							else
								local pw = noteLength
								if self.noteLengthFlooring then
									pw = math.floor(pw, 0)
								else
									pw = math.ceil(pw, 0)
								end
								pw = math.min(math.max(pw, 0), screenWidth-noteX-self.x)
								
								local ph = (screenHeight / (highestKey-lowestKey+1))*keyHeight
								
								if py+ph >= 0 and py < screenHeight and pw > 0 and ph > 0 then
									love.graphics.setColor(r, g, b, self.noteAlpha)
									love.graphics.rectangle("fill", px,py, pw,ph)
								end
								
							end
						end
					else
						self.firstNonFinishedNoteIdInTracks[trackID] = math.max(noteID+1, self.firstNonFinishedNoteIdInTracks[trackID])
					end
				end
				
				love.graphics.setColor(1,1,1,1)
				love.graphics.print(self.firstNonFinishedNoteIdInTracks[trackID], 0, 200+20*trackID)
			end
		end
	end,
}
