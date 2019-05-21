Player = Object:extend()

function Player:new(song)
	self.song = song
	self.timeManager = TimeManager(self)
	
	self.playbackSpeed = 1.0
	
	self.lastPlayedEventIDs = {}
	for i = 1, #self.song:getTracks() do
		self.lastPlayedEventIDs[i] = 0
	end
end

function Player:update(dt)
	local time = self.timeManager:getTime()
	-- TODO: Set the intial index of the searching (i.e. j = ?) as the next one of the last played event
	for i = 1, #self.song:getTracks() do
		local track = self.song:getTrack(i)
		
		for j = self.lastPlayedEventIDs[i]+1, #track:getRawEvents() do
			local event = track:getRawEvent(j)
			
			if time >= event:getTime() then
				if event:getType() < 0xF0 then
					midi.sendMessage(0, event:getType(), event:getMsg1(), event:getMsg2() or 0)
					
					self.lastPlayedEventIDs[i] = j
				end
			else
				break
			end
		end
	end
	
	self.timeManager:update(dt)
end

function Player:getSong()
	return self.song
end

function Player:getMIDISong()
	return self.midiSong
end

function Player:getTimeManager()
	return self.timeManager
end

function Player:getPlaybackSpeed()
	return self.playbackSpeed
end