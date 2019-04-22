class "Queue" {
	private {
		queue = {},
	},
	
	public {
		__construct = function (self)
		end,
		
		enqueue = function (self, object)
			self.queue[#self.queue+1] = object
		end,
		
		dequeue = function (self)
			table.remove(self.queue, 1)
		end,
	},
}