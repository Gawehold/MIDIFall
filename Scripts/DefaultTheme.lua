class "DefaultTheme" {
	extends "DisplayComponent",
	
	-- Override
	new = function (self, x,y, width,height)
		self:super(x,y, width,height)
		
		self.lowestKey = 30
		self.highestKey = 92
		self.keyGap = 0.3
		
		local song = player:getSong()
		local tracks = song:getTracks()
		
		self.backgroundComponent = BackgroundComponent(0,0,0,0)
		self.notesComponent = NotesComponent(0.28,0,0,0)
		self.keyboardComponent = KeyboardComponent(0.2,0,0.08,1)
		self.fallsComponent = FallsComponent(0,0,0.2,1)
		
		self.hitAnimationComponent = HitAnimationComponent(0,0,1,1)
		self.measuresComponent = MeasuresComponent(0.28,0,1,1)
	end,
	
	-- Implement
	update = function (self, dt)
		self.backgroundComponent:update(dt)
		self.notesComponent:update(dt)
		self.keyboardComponent:update(dt)
		self.fallsComponent:update(dt)
		self.hitAnimationComponent:update(dt)
		self.measuresComponent:update(dt)
	end,
		
	-- Implement
	draw = function (self)
		-- love.graphics.push()
		-- love.graphics.translate(love.graphics.getHeight(), 0)
		-- love.graphics.rotate(math.pi/2)
		-- love.graphics.translate(love.graphics.getHeight(), 0)
		-- love.graphics.scale(-1,1)
		self.backgroundComponent:draw()
		self.measuresComponent:draw(self.notesComponent:getNotesScale())
		self.notesComponent:draw(self.lowestKey,self.highestKey,self.keyGap)
		self.keyboardComponent:draw(self.lowestKey,self.highestKey,self.keyGap)
		self.fallsComponent:draw(self.lowestKey,self.highestKey,self.keyGap)
		self.hitAnimationComponent:draw()
		
		-- love.graphics.pop()
	end,
}
