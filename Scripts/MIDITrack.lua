class "MIDITrack" {
	private {
		binPos = NULL,
		binSize = NULL,
		events = {},
		lastPlayedEventID = NULL,
	},
	
	public {
		__construct = function (self, binPos, binSize)
			self.binPos = binPos
			self.binSize = binSize
			self.lastPlayedEventID = 0
		end,
		
		getBinPos = function (self)
			return self.binPos
		end,
		
		getBinSize = function (self)
			return self.binSize
		end,
		
		getEvents = function (self)
			return self.events
		end,
		
		getLastPlayedEventID = function (self)
			return self.lastPlayedEventID
		end,
		
		getEvent = function (self, eventID)
			return self.events[eventID]
		end,
		
		setLastPlayedEventID = function (self, eventID)
			self.lastPlayedEventID = eventID
		end,
		
		addEvent = function (self, event)
			table.insert(self.events, event)
		end,
	},
}