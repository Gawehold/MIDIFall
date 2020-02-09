local playlistIndex = 0
local playlistPath = "D:/MIDIFall_Project/MIDIFall/Test Assets"
local playlistLength = 3

class "TimeManager" {
	new = function (self, player)
		self.player = player
		self.time = player:getInitialTime()
		self.currentTempoChangeID = 1
	end,

	update = function (self, dt)
		local endTime = self.player:getEndTime()
		
		if self.time < endTime then
			local song = self.player:getSong()
			local tempoChanges = song:getTempoChanges()
			local timeDivision = song:getTimeDivision()
			
			local newTime = self.time + (self.player:getPlaybackSpeed() * dt * tempoChanges[self.currentTempoChangeID]:getTempo() * timeDivision / 60)	-- 60 means 60 seconds
			
			-- The time between the original time and new time may be passed some tempo change events
			for i = self.currentTempoChangeID+1, #tempoChanges do
				local nextTempoChangeTime = tempoChanges[i]:getTime()
				
				if newTime < tempoChanges[i]:getTime() then
					break
				else
					local previousTempoTimeRegion = nextTempoChangeTime - self.time
					local newTempoTimeRegion = newTime - nextTempoChangeTime
					local newPerPrevTempoRatio = tempoChanges[i]:getTempo() / tempoChanges[i-1]:getTempo()
					newTime = self.time + previousTempoTimeRegion + newPerPrevTempoRatio * newTempoTimeRegion
					
					self.currentTempoChangeID = i
					self.time = newTime
				end
			end
			
			self.time = newTime
		else
			self.time = endTime
			
			if playlistIndex < playlistLength then
				player:loadSongFromPath( string.format(playlistPath.."/%d.mid", playlistIndex) )
				player:resume()
				playlistIndex = playlistIndex + 1
			end
		end
	end,

	getTime = function (self)
		return self.time
	end,
	
	-- TODO: remove this method later, it is for debug only
	setTime = function (self, time)
		local song = self.player:getSong()
		local tempoChanges = song:getTempoChanges()
		
		if time >= self.time then
			for i = self.currentTempoChangeID+1, #tempoChanges do
				local nextTempoChangeTime = tempoChanges[i]:getTime()
				
				if time >= nextTempoChangeTime then
					self.currentTempoChangeID = i
				else
					break
				end
			end
		else
			local currentTempoChangeID = self.currentTempoChangeID
			self.currentTempoChangeID = 1
			
			for i = currentTempoChangeID, 1, -1 do
				local previousTempoChangeTime = tempoChanges[i]:getTime()
				
				if time >= previousTempoChangeTime then
					self.currentTempoChangeID = i
					break
				end
			end
		end
		
		self.time = time
	end,
	
	getTempo = function (self)
		return self.player:getSong():getTempoChanges()[self.currentTempoChangeID]:getTempo()
	end,
}