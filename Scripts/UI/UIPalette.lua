class "UIPalette" {
	extends "UIObject",
	
	static {
		shader = love.graphics.newShader([[
			vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
				return ( color + vec4( (1-texture_coords.x) * (1-vec3(color)),1) ) * vec4( (1-texture_coords.y) * vec3(1,1,1), 1 );
			}
		]])
	},
	
	new = function (self, x,y, width,height, colorHueAlias,colorSaturationAlias,colorValueAlias)
		UIObject.instanceMethods.new(self, x,y, width,height)
		
		self.colorHueAlias = colorHueAlias
		self.colorSaturation = colorSaturationAlias
		self.colorValue = colorValueAlias
		self.canvas = nil
		self.isClicking = false
	end,
	
	update = function (self, dt, transform)
		self.transform = transform
		
		if self.isClicking then
			self.colorSaturation = (
				( love.mouse.getX() - select(1, self.transform:transformPoint(self.x,0)) )
				/ ( select(1, self.transform:transformPoint(self.width,0)) - select(1, self.transform:transformPoint(0,0)) )
			)
			self.colorSaturation = math.clamp(self.colorSaturation, 0,1)
			
			self.colorValue = 1 - (
				( love.mouse.getY() - select(2, self.transform:transformPoint(0,self.y)))
				/ ( select(2, self.transform:transformPoint(0,self.height)) - select(2, self.transform:transformPoint(0,0)) )
			)
			self.colorValue = math.clamp(self.colorValue, 0,1)
		end
	end,
	
	draw = function (self)
		-- Draw the box
		local boxX, boxY = self.transform:transformPoint(self.x, self.y)
		local boxX2, boxY2 = self.transform:transformPoint(self.x+self.width, self.y+self.height)
		local boxWidth = boxX2 - boxX
		local boxHeight = boxY2 - boxY
		
		if not self.canvas then
			self.canvas = love.graphics.newCanvas(boxWidth, boxHeight)
		end
		
		local previousShader = love.graphics.getShader()
		
		love.graphics.setShader(UIPalette.shader)
		love.graphics.setColor(vivid.HSVtoRGB(self.colorHueAlias,1,1,1))
		love.graphics.draw(self.canvas, boxX,boxY)
		love.graphics.setShader(previousShader)
		
		-- Draw the cursor
		local cursorX = boxX + self.colorSaturation * boxWidth
		local cursorY = boxY + (1-self.colorValue) * boxHeight
		
		love.graphics.setLineWidth(boxHeight/100)
		love.graphics.setColor(0,0,0,1)
		love.graphics.circle("line", cursorX,cursorY,boxHeight/60)
		love.graphics.setColor(0,0,0,1)
		love.graphics.circle("line", cursorX,cursorY,boxHeight/40)
		love.graphics.setColor(1,1,1,1)
		love.graphics.circle("line", cursorX,cursorY,boxHeight/50)
	end,
	
	mouseMoved = function (self, x, y, dx, dy, istouch)
		UIObject.instanceMethods.mouseMoved(self, x, y, dx, dy, istouch)
	end,
	
	mousePressed = function (self, mouseX, mouseY, button, istouch, presses)
		if self:getIsInside() and button == 1 then
			self.isClicking = true
		end
	end,
	
	mouseReleased = function (self, mouseX, mouseY, istouch, presses)
		self.isClicking = false
	end,
}