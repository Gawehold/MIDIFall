-- TODO: repeat mode

class "Sprite" {
	new = function (self, image, rect, edgeScales, scales, offsets)
		self.image = image
		self.rect = rect or {0,0,image:getDimensions()}
		self.edgeScales = edgeScales or {1,1}
		self.scales = scales or {1,1}
		self.offsets = offsets or {0,0}
		
		------------------------------------------------------------------------------
		self.topQuad = love.graphics.newQuad(
			self.rect[1], 0, 
			self.rect[3], self.rect[2],
			self.image:getDimensions()
		)
		
		self.topLeftQuad = love.graphics.newQuad(
			0, 0, 
			self.rect[1], self.rect[2],
			self.image:getDimensions()
		)
		
		self.topRightQuad = love.graphics.newQuad(
			self.rect[1]+self.rect[3], 0, 
			self.image:getWidth() - self.rect[1] - self.rect[3], self.rect[2],
			self.image:getDimensions()
		)
		------------------------------------------------------------------------------
		self.centerQuad = love.graphics.newQuad(
			self.rect[1], self.rect[2],
			self.rect[3], self.rect[4],
			self.image:getDimensions()
		)
		
		self.leftQuad = love.graphics.newQuad(
			0, self.rect[2],
			self.rect[1], self.rect[4],
			self.image:getDimensions()
		)
		
		self.rightQuad = love.graphics.newQuad(
			self.rect[1]+self.rect[3], self.rect[2], 
			self.image:getWidth() - self.rect[1] - self.rect[3], self.rect[4],
			self.image:getDimensions()
		)
		------------------------------------------------------------------------------
		self.bottomQuad = love.graphics.newQuad(
			self.rect[1], self.rect[2]+self.rect[4],
			self.rect[3], self.image:getHeight() - self.rect[2] - self.rect[4],
			self.image:getDimensions()
		)
		
		self.bottomLeftQuad = love.graphics.newQuad(
			0, self.rect[2]+self.rect[4],
			self.rect[1], self.image:getHeight() - self.rect[2] - self.rect[4],
			self.image:getDimensions()
		)
		
		self.bottomRightQuad = love.graphics.newQuad(
			self.rect[1]+self.rect[3], self.rect[2]+self.rect[4],
			self.image:getWidth() - self.rect[1] - self.rect[3], self.image:getHeight() - self.rect[2] - self.rect[4],
			self.image:getDimensions()
		)
		------------------------------------------------------------------------------
	end,
	
	draw = function (self, x,y, width,height)
		love.graphics.push()
		
		local edgeWidthScale = self.edgeScales[1]
		local edgeHeightScale = self.edgeScales[2]
		
		local rectWidthScale = width / self.rect[3]
		local rectHeightScale = height / self.rect[4]
		
		love.graphics.scale(self.scales[1], self.scales[2])
		x = x / self.scales[1] + (1/self.scales[1]-1)*width/2
		y = y / self.scales[2] + (1/self.scales[2]-1)*height/2
		
		-- Offsets
		x = x + self.scales[1]*rectWidthScale*self.offsets[1]*self.rect[3]
		y = y + self.scales[2]*rectHeightScale*self.offsets[2]*self.rect[4]
		------------------------------------------------------------------------------
		love.graphics.draw(
			self.image,
			self.topQuad,
			x, y - edgeHeightScale*self.rect[2],
			0,
			rectWidthScale, edgeHeightScale
		)
		
		love.graphics.draw(
			self.image,
			self.topLeftQuad,
			x - edgeWidthScale*self.rect[1], y - edgeHeightScale*self.rect[2],
			0,
			edgeWidthScale, edgeHeightScale
		)
		
		love.graphics.draw(
			self.image,
			self.topRightQuad,
			x + rectWidthScale*self.rect[3], y - edgeHeightScale*self.rect[2],
			0,
			edgeWidthScale, edgeHeightScale
		)
		------------------------------------------------------------------------------
		love.graphics.draw(
			self.image,
			self.centerQuad,
			x, y,
			0,
			rectWidthScale, rectHeightScale
		)
		
		love.graphics.draw(
			self.image,
			self.leftQuad,
			x - edgeWidthScale*self.rect[1], y,
			0,
			edgeWidthScale, rectHeightScale
		)
		
		love.graphics.draw(
			self.image,
			self.rightQuad,
			x + rectWidthScale*self.rect[3], y,
			0,
			edgeWidthScale, rectHeightScale
		)
		------------------------------------------------------------------------------
		love.graphics.draw(
			self.image,
			self.bottomQuad,
			x, y + rectHeightScale*self.rect[4],
			0,
			rectWidthScale, edgeHeightScale
		)
		
		love.graphics.draw(
			self.image,
			self.bottomLeftQuad,
			x - edgeWidthScale*self.rect[1], y + rectHeightScale*self.rect[4],
			0,
			edgeWidthScale, edgeHeightScale
		)
		
		love.graphics.draw(
			self.image,
			self.bottomRightQuad,
			x + rectWidthScale*self.rect[3], y + rectHeightScale*self.rect[4],
			0,
			edgeWidthScale, edgeHeightScale
		)
		------------------------------------------------------------------------------
		
		love.graphics.pop()
	end,
}