class "MIDITrack" {
	private {
		binPos = NULL,
		binSize = NULL,
		events = {},
	},
	
	public {
		__construct = function (self, binPos, binSize)
			self.binPos = binPos
			self.binSize = binSize
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
		
		getEvent = function (self, eventID)
			return self.events[eventID]
		end,
		
		addEvent = function (self, event)
			table.insert(self.events, event)
		end,
	},
}