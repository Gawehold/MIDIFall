class "NotesComponent" extends "DisplayComponent" {
	private {
		notes = {},
	},
	
	public {
		-- Implement
		update = function (self, dt)
		end,
		
		-- Implement
		draw = function (self)
			for i = 1, #self.notes do
				local note = self.notes[i]
				love.graphics.rectangle("fill", note:getTime()/20, note:getPitch()*20-800, note:getLength()/20, 10)
			end
		end,
		
		getNotes = function (self)
			return self.notes
		end,
		
		setNotes = function (self, notes)
			self.notes = notes
		end,
	},
}