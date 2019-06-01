class "DefaultTheme" {
	extends "DisplayComponent",
	
	-- Override
	new = function (self, x,y, width,height)
		self:super(x,y, width,height)
		
		self.keyHeight = 0.5
		
		local song = player:getSong()
		local tracks = song:getTracks()
		
		self.tracksVisibility = {}
		for trackID = 1, #tracks do
			self.tracksVisibility[trackID] = true
		end
		
		self.notesComponent = NotesComponent(500,0,0,0)
	end,
	
	-- Implement
	update = function (self, dt)
		
	end,
	
	-- Implement
	draw = function (self)
		self.notesComponent:draw(20,80,self.keyHeight,self.tracksVisibility)
	end,
}