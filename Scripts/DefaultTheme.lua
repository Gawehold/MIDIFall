class "DefaultTheme" {
	extends "DisplayComponent",
	
	-- Override
	new = function (self, x,y, width,height)
		self:super(x,y, width,height)
		
		self.lowestKey = 30
		self.highestKey = 90
		self.keyGap = 0.3
		
		local song = player:getSong()
		local tracks = song:getTracks()
		
		self.tracksVisibility = {}
		for trackID = 1, #tracks do
			self.tracksVisibility[trackID] = true
		end
		
		self.notesComponent = NotesComponent(0.08,0,0,0)
		self.keyboardComponent = KeyboardComponent(0,0,0.08,1)
	end,
	
	-- Implement
	update = function (self, dt)
		self.notesComponent:update(dt)
		self.keyboardComponent:update(dt)
	end,
	
	-- Implement
	draw = function (self)
		self.notesComponent:draw(self.lowestKey,self.highestKey,self.keyGap,self.tracksVisibility)
		self.keyboardComponent:draw(self.lowestKey,self.highestKey,self.keyGap,self.tracksVisibility)
	end,
}