class "NotesComponent" {
	extends "DisplayComponent",
	
	-- Override
	new = function (self, x,y, width,height)
		self:super(x,y, width,height)
		
		self.noteScale = 1
		self.noteLengthOffset = 0
		self.noteLengthFlooring = true
		
		self.colourAlpha = 0.9
		
		self.useRainbowColour = true
		self.rainbowColourHueShift = 0.5
		self.rainbowColourSaturation = 0.5
		self.rainbowColourValue = 0.5
		
		self.brightNote = true
		self.brightNoteSaturation = 0.4
		self.brightNodeValue = 1
		
		self.pitchBendSemitone = 12
		
			
		-- self.noteShader = love.graphics.newShader([[
			-- extern bool isPitchBendValueIncreasing;
			
			-- vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
				-- vec4 texcolor = Texel(tex, texture_coords);
				
				-- if (isPitchBendValueIncreasing) {
					-- return vec4(1,1,1,1);
				-- } else {
					-- return vec4(1,0,1,1);
				-- }
				
				-- return texcolor * color;
			-- }
		-- ]], [[
		
		self.noteShader = love.graphics.newShader([[
			extern float noteX;
			extern float noteWidth;
			
			vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
				vec4 texcolor = Texel(tex, texture_coords);
				
				for (int i = 0; i < 200; i++) {
					if ((screen_coords.x+1080-i*30) < screen_coords.y && (screen_coords.x+1080-i*30)+10 >= screen_coords.y) {
						return vec4(0,0,0,0);
					}
				}
				
				color.a = color.a * (noteX+noteWidth-screen_coords.x)/50.0f;
				
				return  texcolor * color;
			}
		]], [[
			vec4 position(mat4 transform_projection, vec4 vertex_position) {
				mat4 custom_transform_matrix;
				
				custom_transform_matrix = mat4(
					vec4(1,0,0,0),
					vec4(0,1,0,0),
					vec4(0,0,1,0),
					vec4(0,0,0,1)
				);
				
				return custom_transform_matrix * transform_projection * vertex_position;
			}
		]])
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
		
		local firstNonFinishedNoteIDInTracks = player:getfirstNonFinishedNoteIDInTracks()
		local currentPitchBendValueInTracks = player:getCurrentPitchBendValueInTracks()
		
		--//////// Main Section ////////
		for trackID = 1, #tracks do
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
							
							if noteX <= 0 then
							-- if true then
							-- if false then
								local pbV = currentPitchBendValueInTracks[trackID]
								local ky = pbV / 8192
								
								love.graphics.push()
								-- love.graphics.setShader(self.noteShader)
								-- self.noteShader:send("noteX", noteX+noteCulledWidth)
								-- self.noteShader:send("noteWidth", noteWidth-noteCulledWidth)
								love.graphics.rectangle("fill", noteX+noteCulledWidth,noteY+self.pitchBendSemitone*spaceForEachKey*ky, noteWidth-noteCulledWidth,noteHeight)
								-- love.graphics.setShader()
								love.graphics.pop()
								
							else
								-- love.graphics.rectangle("fill", noteX+noteCulledWidth,noteY, noteWidth-noteCulledWidth,noteHeight, noteHeight/2,noteHeight/2)
								love.graphics.rectangle("fill", noteX+noteCulledWidth,noteY, noteWidth-noteCulledWidth,noteHeight)
							end
						end
					end
				end
			end
		end
	end,
}
