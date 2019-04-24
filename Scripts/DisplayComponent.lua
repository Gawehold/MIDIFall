class "DisplayComponent" {
	private {
		x = NULL,
		y = NULL,
		width = NULL,
		height = NULL,
	},
	
	public {
		__construct = function (self)
		end,
		
		abstract {
			update = function (self, dt)
			end,
			
			draw = function (self)
			end,
		},
		
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
	},
}