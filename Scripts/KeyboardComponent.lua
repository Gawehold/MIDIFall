class "KeyboardComponent" {
	extends "DisplayComponent",
	
	-- Override
	new = function (self, x,y, width,height)
		self:super(x,y, width,height)
		
		self.rainbow = true
		self.keyboardBrightAlpha = 0.8
		self.keyboardBlackAlpha = 0.8
		self.keyboardWhiteAlpha = 0.8
		
		-- TODO: adjust these values
		self.whiteHeadsUpperPartRatio = {
			[1] = 0.4,
			[3] = 0.6,
			[6] = 0.35,
			[8] = 0.5,
			[10] = 0.65
		}
	end,
	
	-- Implement
	update = function (self, dt)
	end,
	
	-- Implement
	draw = function (self, lowestKey, highestKey, keyGap, trackIsVisible)
		local screenWidth = love.graphics.getWidth()
		local screenHeight = love.graphics.getHeight()
		local resolutionRatio = screenWidth / screenHeight
		local keyboardX = screenWidth * self.x
		local keyboardWidth = screenWidth * self.width
		local spaceForEachKey = screenHeight / (highestKey-lowestKey+1)
		
		local keyHeightRatio = 1 - keyGap
		
		local isPlayingKeys = {}
		for i = 0, 127 do
			isPlayingKeys[i] = false
		end
		
		local firstNonFinishedNoteIdInTracks = player:getFirstNonFinishedNoteIdInTracks()
		local song = player:getSong()
		local tracks = song:getTracks()
		local time = player:getTimeManager():getTime()
		
		for trackID = 1, #tracks do
			if trackIsVisible[trackID] then
				local notes = tracks[trackID]:getNotes()
				for noteID = firstNonFinishedNoteIdInTracks[trackID], #notes do
					local note = notes[noteID]
					local noteTime = note:getTime()
					local noteLength = note:getLength()
					
					if noteTime > time then
						break
					else
						isPlayingKeys[note:getPitch()] = true
					end
				end
			end
		end
		
		for i = lowestKey, highestKey do
			local keyY = (highestKey-i) * spaceForEachKey
			local keyHeight = keyHeightRatio*spaceForEachKey
			local semitoneInOctave = i % 12
			
			if semitoneInOctave == 1 or semitoneInOctave == 3 or semitoneInOctave == 6 or semitoneInOctave == 8 or semitoneInOctave == 10 then
				-- Black Key
				if isPlayingKeys[i] == true then
					love.graphics.setColor(0,0,1,self.keyboardWhiteAlpha)
				else
					love.graphics.setColor(1,1,1,self.keyboardWhiteAlpha)
				end
				love.graphics.rectangle("fill", self.x,keyY, screenWidth*self.width*0.65,keyHeight)
				
				-- White Key Heads
				if isPlayingKeys[i+1] == true then
					love.graphics.setColor(0,0,1,self.keyboardWhiteAlpha)
				else
					love.graphics.setColor(1,1,1,self.keyboardWhiteAlpha)
				end
				love.graphics.rectangle(
					"fill",
					self.x+screenWidth*self.width*0.65+keyGap*spaceForEachKey,
					keyY-keyGap*spaceForEachKey,
					screenWidth*self.width*0.35-keyGap*spaceForEachKey,
					(keyHeight+2*keyGap*spaceForEachKey)*self.whiteHeadsUpperPartRatio[semitoneInOctave] - keyGap*spaceForEachKey/2
				)
				
				if isPlayingKeys[i-1] == true then
					love.graphics.setColor(0,0,1,self.keyboardWhiteAlpha)
				else
					love.graphics.setColor(1,1,1,self.keyboardWhiteAlpha)
				end
				love.graphics.rectangle(
					"fill",
					self.x+screenWidth*self.width*0.65+keyGap*spaceForEachKey,
					keyY-keyGap*spaceForEachKey+(keyHeight+2*keyGap*spaceForEachKey)*self.whiteHeadsUpperPartRatio[semitoneInOctave] - keyGap*spaceForEachKey/2+keyGap*spaceForEachKey,
					screenWidth*self.width*0.35-keyGap*spaceForEachKey,
					(keyHeight+2*keyGap*spaceForEachKey)*(1-self.whiteHeadsUpperPartRatio[semitoneInOctave]) - keyGap*spaceForEachKey/2
				)
			else
				
				-- White Key
				if isPlayingKeys[i] == true then
					love.graphics.setColor(0,0,1,self.keyboardWhiteAlpha)
				else
					love.graphics.setColor(1,1,1,self.keyboardWhiteAlpha)
				end
				love.graphics.rectangle("fill", self.x,keyY, screenWidth*self.width,keyHeight)
			end
		end
	end,
}