class "SettingsMenu" {
	new = function (self)
		self.position = 0
		self.width = 0.25
		
		self.openAndCloseSpeed = 1.0
		self.childrenTransform = love.math.newTransform()
		
		self.isOpening = false
		self.isOpened = false
		self.isClosing = false
		
		self.pages = {
			homepage = UIPanel(0.75,0.0, 0.25,1.0,
				{
					UICheckbox(0.1,0.0,nil,0.05,"Scale"),
					UIButton(0.1,0.1,0.8,0.05,"System", love.graphics.newImage("Assets/Free desktop PC icon.png"), 
						function (obj)
							self.currentPage = self.pages.system
						end
					),
					UIButton(0.1,0.2,0.8,0.05,"Playback", love.graphics.newImage("Assets/video cassette recorder icon 2.png"), 
						function (obj)
							self.currentPage = self.pages.playback
						end
					),
					UIButton(0.1,0.3,0.8,0.05,"Tracks", love.graphics.newImage("Assets/mixer (music) icon 1.png"), 
						function (obj)
							self.currentPage = self.pages.tracks
						end
					),
					UIButton(0.1,0.4,0.8,0.05,"Display", love.graphics.newImage("Assets/projector.png"), 
						function (obj)
							self.currentPage = self.pages.display
						end
					),
					UIButton(0.1,0.5,0.8,0.05,"About", love.graphics.newImage("Assets/Resume icon 6.png"), 
						function (obj)
							self.currentPage = self.pages.about
						end
					),
					UISlider(0.1,0.6,0.8,0.02, Alias(defaultTheme.notesComponent, "noteScale")),
				}
			),
			
			system = UIPanel(0.75,0.0, 0.25,1.0,
				{
				}
			),
		}
		
		self.currentPage = self.pages.homepage
		
		self:open()
	end,
	
	update = function (self, dt)
		if self.isOpening then
			self.position = self.position + self.openAndCloseSpeed*dt
			
			if self.position >= self.width then
				self.position = self.width
				self.isOpened = true
				self.isOpening = false
			end
		end
		
		if self.isClosing then
			self.position = self.position - self.openAndCloseSpeed*dt
			
			if self.position <= 0 then
				self.position = 0
				self.isClosing = false
			end
		end
		
		-- TODO: change newTransform to use self.childrenTransform
		self.currentPage:update(dt, love.math.newTransform(love.graphics.getWidth()*(self.width-self.position),0,0,love.graphics.getWidth(),love.graphics.getHeight()))
	end,
	
	draw = function (self)
		if self.isOpened or self.isOpening or self.isClosing then
			self.currentPage:draw()
		end
	end,
	
	open = function (self)
		self.isOpening = true
	end,
	
	close = function (self)
		self.isClosing = true
		self.isOpened = false
	end,
	
	mousePressed = function (self, mouseX, mouseY, button, istouch, presses)
		if self.isOpening or self.isClosing then
			return
		end
		
		if button == 2 then
			if self.currentPage == self.pages.homepage then
				if self.isOpened then
					self:close()
				else
					self:open()
				end
			else
				self.currentPage = self.pages.homepage
			end
		end
		
		self.currentPage:mousePressed(mouseX, mouseY, button, istouch, presses)
	end,
	
	mouseReleased = function (self, mouseX, mouseY, istouch, presses)
		self.currentPage:mouseReleased(mouseX, mouseY, istouch, presses)
	end,

	mouseMoved = function (self, x, y, dx, dy, istouch)
		self.currentPage:mouseMoved(x, y, dx, dy, istouch)
	end,

	keyPressed = function(self, key)
		self.currentPage:keyPressed(key)
	end,
}