class "DefaultTheme" {
	extends "DisplayComponent",
	
	-- Override
	new = function (self, x,y, width,height)
		self:super(x,y, width,height)
		
		self.lowestKey = 20
		self.highestKey = 100
		self.keyGap = 0.2
		
		local song = player:getSong()
		local tracks = song:getTracks()
		
		self.notesComponent = NotesComponent(0.28,0,0,0)
		self.keyboardComponent = KeyboardComponent(0.2,0,0.08,1)
		self.fallsComponent = FallsComponent(0,0,0.2,1)
	end,
	
	-- Implement
	update = function (self, dt)
		self.notesComponent:update(dt)
		self.keyboardComponent:update(dt)
		self.fallsComponent:update(dt)
	end,
		
	-- Implement
	draw = function (self)
		-- love.graphics.push()
		-- love.graphics.translate(love.graphics.getHeight(), 0)
		-- love.graphics.rotate(math.pi/2)
		-- love.graphics.translate(love.graphics.getHeight(), 0)
		-- love.graphics.scale(-1,1)
		self.notesComponent:draw(self.lowestKey,self.highestKey,self.keyGap)
		self.keyboardComponent:draw(self.lowestKey,self.highestKey,self.keyGap)
		self.fallsComponent:draw(self.lowestKey,self.highestKey,self.keyGap)
		-- love.graphics.pop()
	end,
}
	
