class "DisplayComponentsRenderer" {
	new = function (self)
		self.isRenderingVideo = false
		self.isEncodingVideo = false
		self.canvas = nil
		self.pipe = nil
		
		self.exportingFramerate = 60
		self.exportingThread = love.thread.newThread([[
			require "love.image"
			require "love.event"
			
			local pipe = io.popen(
				string.format("D:/MIDIFall_Project/MIDIFall/ffmpeg.exe -f image2pipe -r %d -s %dx%d -c:v rawvideo -pix_fmt rgba -frame_size %d -i - -vf colormatrix=bt601:bt709 -pix_fmt yuv420p -c:v libx264 -crf %d -preset:v %s -y %s", ...), "wb"
			)
			
			while not love.thread.getChannel("renderingStopped"):peek() or love.thread.getChannel("imageData"):getCount() > 0 do
				
				local imageData = love.thread.getChannel("imageData"):pop()
				
				if imageData then
					pipe:write(imageData:getString())
				end
			end
			
			love.thread.getChannel("renderingStopped"):pop()
			
			pipe:read('*a')	-- wait for the pipe
			pipe:close()
		]])
	end,
	
	update = function (self, dt, ...)
		
		if self.isRenderingVideo then
			dt = 1 / self.exportingFramerate
		end
		
		for i = 1, select("#", ...) do
			select(i, ...):update(dt)
		end
		
		if self.isRenderingVideo and player:getTimeManager():getTime() > player:getEndTime() then
			self:finishRendering()
		end
		
		if self.isEncodingVideo and not self.exportingThread:isRunning() then
			self:finishEncoding()
		end
	end,
	
	draw = function (self, ...)
		if self.isRenderingVideo then
			love.graphics.setCanvas(self.canvas)
			love.graphics.clear()
		end
		
		for i = 1, select("#", ...) do
			select(i, ...):draw(self:getWidth(), self:getHeight())
		end
		
		love.graphics.setColor(1,1,1)
		
		if self.isRenderingVideo then
			love.graphics.setCanvas()
			
			local imageData = self.canvas:newImageData(0,1, 0,0, self.canvas:getWidth(),self.canvas:getHeight())
			-- if love.thread.getChannel("imageData"):getCount() >= 3 then
				-- while love.thread.getChannel("imageData"):getCount() > 0 do end
				love.thread.getChannel("imageData"):push(imageData)
				imageData:release()
			-- end
			
			local percentage = string.format("%3.2f", math.min(100*(player:getTimeManager():getTime()-player:getInitialTime())/(player:getEndTime()-player:getInitialTime()), 100))
			local renderingProgressMessage = "Rendering: " .. percentage .. "%"
			
			love.graphics.print(
				renderingProgressMessage,
				(love.graphics.getWidth()  - love.graphics.getFont():getWidth(renderingProgressMessage)) / 2,
				(love.graphics.getHeight() - love.graphics.getFont():getHeight()) / 2
			)
			
		elseif self.isEncodingVideo then
			local encodingProgressMessage = "Waiting for encoding..."
			
			love.graphics.print(
				encodingProgressMessage,
				(love.graphics.getWidth()  - love.graphics.getFont():getWidth(encodingProgressMessage)) / 2,
				(love.graphics.getHeight() - love.graphics.getFont():getHeight()) / 2
			)
		end
	end,
	
	startToRender = function (self, width, height, framerate)
		self.isRenderingVideo = true
		self.isEncodingVideo = true
		self.canvas = love.graphics.newCanvas(width, height)
		self.exportingThread:start(framerate, width, height, 4*width*height, 0,"medium", "D:/MIDIFall_Project/MIDIFall/test.mp4")
		self.exportingFramerate = framerate
		
		player:moveToBeginning()
		player:resume()
	end,
	
	finishRendering = function (self)
		player:pause()
		player:moveToBeginning()
		self.isRenderingVideo = false
		love.thread.getChannel("renderingStopped"):push(true)
	end,
	
	finishEncoding = function (self)
		self.isEncodingVideo = false
	end,
	
	getWidth = function (self)
		if self.isRenderingVideo then
			return self.canvas:getWidth()
		else
			return love.graphics.getWidth()
		end
	end,
	
	getHeight = function (self)
		if self.isRenderingVideo then
			return self.canvas:getHeight()
		else
			return love.graphics.getHeight()
		end
	end,
	
	getIsExportingVideo = function (self)
		return self.isRenderingVideo or self.isEncodingVideo
	end,
	
	terminateVideoExport = function (self)
		self:finishRendering()
		self:finishEncoding()
		
		-- PRINT TERMINATED
	end,
}