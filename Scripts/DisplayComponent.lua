class "DisplayComponent" {
	new = function (self, x,y, width,height)
		self.x = x
		self.y = y
		self.width = width
		self.height = height
	end,
	
	update = abstract,
	
	draw = abstract,
	
	getX = function (self)
		return self.x
	end,
	
	getY = function (self)
		return self.y
	end,
	
	getWidth = function (self)
		return self.width
	end,
	
	getHeight = function (self)
		return self.height
	end,
}
