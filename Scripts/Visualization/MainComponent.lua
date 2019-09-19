class "MainComponent" {
	extends "DisplayComponent",
	
	-- Override
	new = function (self, x,y, width,height)
		self:super(x,y, width,height)
		
		self.lowestKey = 29
		self.highestKey = 95
		self.keyGap = 0.18
		
		self.keyboardPosition = 0.2
		self.keyboardLength = 0.06
		self.keyboardHeight = 1.0
		
		self.shader = love.graphics.newShader([[
			float PI = 3.141592654;
			float rotation = -PI/2;
			
			vec4 effect( vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords ) {
				float r = sqrt(pow(texture_coords.x-0.5,2) + pow(texture_coords.y-0.5,2));
				float theta = mod(PI+atan((texture_coords.y-0.5), (texture_coords.x-0.5)) + rotation, 2*PI);
				float x = -(2*r) + 1;
				float y = -(theta/(2*PI)) + 1;
				
				vec4 texcolor = Texel(tex, vec2(x,y));
				return texcolor * color;
			}
		]])
		self.canvas = love.graphics.newCanvas(love.graphics.getDimensions())
		
		local keyboardPositionAlias = Alias(self, "keyboardPosition")
		local keyboardLengthAlias = Alias(self, "keyboardLength")
		local keyboardHeightAlias = Alias(self, "keyboardHeight")
		
		local notesPositionFollower = Follower(function () return self.keyboardPosition + self.keyboardLength end)
		local keyboardYFollower = Follower(function () return (1-self.keyboardHeight)/2 end)
		
		self.backgroundComponent = BackgroundComponent(
			0,0,
			1,1
		)
		self.notesComponent = NotesComponent(
			notesPositionFollower,keyboardYFollower,
			1,keyboardHeightAlias
		)
		self.keyboardComponent = KeyboardComponent(
			keyboardPositionAlias,keyboardYFollower,
			keyboardLengthAlias,keyboardHeightAlias
		)
		self.fallsComponent = FallsComponent(
			0,keyboardYFollower,
			keyboardPositionAlias,keyboardHeightAlias
		)
		self.hitAnimationComponent = HitAnimationComponent(
			0,keyboardYFollower,
			keyboardPositionAlias,keyboardHeightAlias
		)
		self.measuresComponent = MeasuresComponent(
			notesPositionFollower,0,
			0,1,
			keyboardHeightAlias
		)
		self.statisticComponent = StatisticComponent()
		
		self:setOrientation(0)
		
		self.themeManager = ThemeManager()
	end,
	
	-- Implement
	update = function (self, dt)
		self.backgroundComponent:update(dt)
		self.notesComponent:update(dt)
		self.keyboardComponent:update(dt)
		self.fallsComponent:update(dt)
		self.hitAnimationComponent:update(dt)
		self.measuresComponent:update(dt)
		self.statisticComponent:update(dt)
	end,
		
	-- Implement
	draw = function (self, screenWidth,screenHeight)
		
		-- love.graphics.translate(love.graphics.getHeight(), 0)
		-- love.graphics.rotate(math.pi/2)
		-- love.graphics.translate(love.graphics.getHeight(), 0)
		-- love.graphics.scale(-1,1)
		
		local previousCanvas = love.graphics.getCanvas()
		love.graphics.setCanvas(self.canvas)
		love.graphics.clear()
		
		self.measuresComponent:draw(screenWidth,screenHeight, self.notesComponent:getNotesScale())
		self.notesComponent:draw(screenWidth,screenHeight, self.lowestKey,self.highestKey,self.keyGap)
		self.keyboardComponent:draw(screenWidth,screenHeight, self.lowestKey,self.highestKey,self.keyGap)
		self.fallsComponent:draw(screenWidth,screenHeight, self.lowestKey,self.highestKey,self.keyGap)
		self.hitAnimationComponent:draw(screenWidth,screenHeight, self.lowestKey,self.highestKey,self.keyGap)
		self.statisticComponent:draw(screenWidth,screenHeight)
		love.graphics.setCanvas(previousCanvas)
		
		self.backgroundComponent:draw(screenWidth,screenHeight)
		-- love.graphics.setShader(self.shader)
		love.graphics.setBlendMode("alpha", "premultiplied")
		love.graphics.setColor(1,1,1)
		
		-- love.graphics.draw(self.canvas,2114,100,math.rad(120))
		love.graphics.draw(self.canvas)
		love.graphics.setBlendMode("alpha")
		-- love.graphics.setShader()
	end,
	
	-- Override
	setOrientation = function (self, orientation)
		self.orientation = orientation
		
		self.backgroundComponent:setOrientation(orientation)
		self.notesComponent:setOrientation(orientation)
		self.keyboardComponent:setOrientation(orientation)
		self.fallsComponent:setOrientation(orientation)
		self.hitAnimationComponent:setOrientation(orientation)
		self.measuresComponent:setOrientation(orientation)
		self.statisticComponent:setOrientation(orientation)
	end,
	
	getThemeManager = function (self)
		return self.themeManager
	end,
	
	resize = function (self, w, h)
		self.canvas = love.graphics.newCanvas(w, h)
		-- self.backgroundComponent:resize(w, h)
		-- self.notesComponent:resize(w, h)
		-- self.keyboardComponent:resize(w, h)
		-- self.fallsComponent:resize(w, h)
		-- self.hitAnimationComponent:resize(w, h)
		-- self.measuresComponent:resize(w, h)
		-- self.statisticComponent:resize(w, h)
	end,
}
