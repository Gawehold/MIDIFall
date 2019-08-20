-- Orientation
-- 0: Horizontal (default)
-- 1: Vertical
-- 2: Horizontal (reversed)
-- 3: Vertical (reversed)

class "DisplayComponent" {
	new = function (self, x,y, width,height)
		self.x = x
		self.y = y
		self.width = width
		self.height = height
		self.isVerticalView = false
		self.orientation = 0
		self.enabled = true
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
	
	setIsVerticalView = function (self, isVerticalView)
		self.isVerticalView = isVerticalView
	end,
	
	setOrientation = function (self, orientation)
		self.orientation = orientation
	end,
}