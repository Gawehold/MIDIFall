class "MIDISong" {
	private {
		formatType = NULL,
		timeDivision = NULL,
		tracks = {},
		
	},
	
	public {
		__construct = function (self, formatType, timeDivision)
			self.formatType = formatType
			self.timeDivision = timeDivision
		end,
		
		getFormatType = function (self)
			return self.formatType
		end,
		
		getTimeDivision = function (self)
			return self.timeDivision
		end,
		
		getTracks = function (self)
			return self.tracks
		end,
		
		getTrack = function (self, trackID)
			return self.tracks[trackID]
		end,
		
		addTrack = function (self, track)
			self.tracks[#self.tracks+1] = track
		end,

	},
}