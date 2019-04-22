class "Track" {
	private {
		notes = {},
	},
	
	public {
		getNotes = function (self)
			return self.notes
		end,
		
		getNote = function (self, noteID)
			return self.notes[noteID]
		end,
		
		addNote = function (self, note)
			self.notes[#self.notes+1] = note
		end,
	},
}