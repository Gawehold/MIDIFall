class "Track" {
	private {
		notes = {},
		pitchBends = {},
	},
	
	public {
		getNotes = function (self)
			return self.notes
		end,
		
		getPitchBends = function (self)
			return self.pitchBends
		end,
		
		getNote = function (self, noteID)
			return self.notes[noteID]
		end,
		
		getPitchBend = function (self, pbID)
			return self.pitchBends[pbID]
		end,
		
		addNote = function (self, note)
			self.notes[#self.notes+1] = note
		end,
		
		addPitchBend = function (self, pb)
			self.pitchBends[#self.pitchBends+1] = pb
		end,
	},
}