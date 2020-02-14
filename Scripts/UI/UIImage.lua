class "UIImage" {
	extends "UIObject",
	
	new = function (self, x,y,width,height, image)
		-- self:super(x,y, width,height)
		UIObject.instanceMethods.new(self, x,y, width,height) -- self.super not working for two level inhertance
		
		self.image = image
	end,
	
	update = function (self, dt, transform)
		self.transform = transform
	end,
	
	draw = function (self)
		-- Draw the box
		local boxX, boxY = self.transform:transformPoint(self.x, self.y)
		local boxX2, boxY2 = self.transform:transformPoint(self.x+self.width, self.y+self.height)
		local boxWidth = boxX2 - boxX
		local boxHeight = boxY2 - boxY
		
		local scale = math.min(boxWidth / self.image:getWidth(), boxHeight / self.image:getHeight())
		
		love.graphics.setColor(1,1,1)
		love.graphics.draw(
			self.image,
			boxX + (boxWidth - scale * self.image:getWidth()) /2 ,
			boxY + (boxHeight - scale * self.image:getHeight()) / 2,
			0,
			scale
		)
	end,
}