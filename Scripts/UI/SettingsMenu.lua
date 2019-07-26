class "SettingsMenu" {
	new = function (self)
		self.position = 0
		self.x = 0.75
		self.y = 0
		self.width = 0.25
		self.height = 1.0
		
		self.openAndCloseSpeed = 1.0
		self.childrenTransform = love.math.newTransform()
		
		self.isOpening = false
		self.isOpened = false
		self.isClosing = false
		
		self.font = love.graphics.newFont("Assets/NotoSansCJKtc-Medium_1.otf", 36)
		
		self.pages = {
			homepage = UIPanel(self.x,self.y, self.width,self.height,
				{
					UIButton(0.1,0.1,0.8,0.05,"System", love.graphics.newImage("Assets/Free desktop PC icon.png"), 
						function (obj)
							self.currentPage = self.pages.system
							self.currentPage:open()
						end
					),
					UIButton(0.1,0.2,0.8,0.05,"Playback", love.graphics.newImage("Assets/video cassette recorder icon 2.png"), 
						function (obj)
							self.currentPage = self.pages.playback
							self.currentPage:open()
						end
					),
					UIButton(0.1,0.3,0.8,0.05,"Tracks", love.graphics.newImage("Assets/mixer (music) icon 1.png"), 
						function (obj)
							self.currentPage = self.pages.tracks
							self.currentPage:open()
						end
					),
					UIButton(0.1,0.4,0.8,0.05,"Display", love.graphics.newImage("Assets/projector.png"), 
						function (obj)
							self.currentPage = self.pages.display
							self.currentPage:open()
						end
					),
					UIButton(0.1,0.5,0.8,0.05,"Experimental", nil, 
						function (obj)
							self.currentPage = self.pages.experimental
							self.currentPage:open()
						end
					),
					UIButton(0.1,0.6,0.8,0.05,"About", love.graphics.newImage("Assets/Resume icon 6.png"), 
						function (obj)
							self.currentPage = self.pages.about
							self.currentPage:open()
						end
					),
				}
			),
			
			system = UIPanel(self.x,self.y, self.width,self.height,
				{
					UIColorPicker(0,0,1,0.5, 
						Alias(mainComponent.keyboardComponent.whiteKeyColourHSV, 1),
						Alias(mainComponent.keyboardComponent.whiteKeyColourHSV, 2),
						Alias(mainComponent.keyboardComponent.whiteKeyColourHSV, 3),
						Alias(mainComponent.keyboardComponent, "whiteKeyAlpha")
					),
					
					UIDropdown(0.1,0.7,0.8,0.05,
						{
							"Fast",
							"Medium",
							"Slow as hell",
						}, 1
					),
				}
			),
			
			playback = UIPanel(self.x,self.y, self.width,self.height,
				{
					
				}
			),
			
			tracks = UIPanel(self.x,self.y, self.width,self.height,
				{
					
				}
			),
			
			display = UIPanel(self.x,self.y, self.width,self.height,
				{
					UIButton(0.1,0.1,0.8,0.05,"Background", nil, 
						function (obj)
							obj.parent:changePage(2)
						end
					),
					UIButton(0.1,0.2,0.8,0.05,"Keyboard", nil, 
						function (obj)
							obj.parent:changePage(3)
						end
					),
					UIButton(0.1,0.3,0.8,0.05,"Notes", nil, 
						function (obj)
							obj.parent:changePage(4)
						end
					),
					UIButton(0.1,0.4,0.8,0.05,"Falls", nil, 
						function (obj)
							obj.parent:changePage(5)
						end
					),
					UIButton(0.1,0.5,0.8,0.05,"Hit Animation", nil, 
						function (obj)
							obj.parent:changePage(6)
						end
					),
					UIButton(0.1,0.6,0.8,0.05,"Measure", nil, 
						function (obj)
							obj.parent:changePage(7)
						end
					),
				},
				
				{
					UISliderSuite(0.1,0.1, 0.8,0.1, "Opacity", Alias(mainComponent.backgroundComponent, "opacity"), 0,1, 0.01),
				},
				
				{
					UIText(0.1,0.1,0.3,0.05, "Keyboard Position", 0.75),
					UIText(0.1,0.1,0.3,0.05, "Keyboard Position", 0.75),
					UIInputBox(0.4,0.115,0.3,0.05, Alias(mainComponent, "keyboardPosition")),
					UISlider(0.1,0.2,0.8,0.02, Alias(mainComponent, "keyboardPosition"),-1,1,0.01),
					UISlider(0.1,0.3,0.8,0.02, Alias(mainComponent, "keyboardLength"),0,1,0.01),
					UISlider(0.1,0.4,0.8,0.02, Alias(mainComponent.notesComponent, "rainbowColourHueShift"),0,1,0.01),
					UISlider(0.1,0.5,0.8,0.02, Alias(mainComponent, "keyGap"),0,1,0.01),					
				}
			),
			
			experimental = UIPanel(self.x,self.y, self.width,self.height,
				{
					UIInputBox(0.1,0.1,0.2,0.05, Alias(mainComponent, "lowestKey")),
					UIInputBox(0.5,0.1,0.2,0.05, Alias(mainComponent, "highestKey")),
					UIRangeSlider(0.1,0.5,0.8,0.02, Alias(mainComponent, "lowestKey"),Alias(mainComponent, "highestKey"), 0,127,1),
				}
			),
			
			about = UIPanel(self.x,self.y, self.width,self.height,
				{
					UIText(0.1,0.1,0.8,0.5, "A MIDI score (smf file) visualizer with rainbow falls!", 1)
				}
			),
		}
		
		self.currentPage = self.pages.homepage
		
		-- self:open()
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
		local previousFont = love.graphics.getFont()
		love.graphics.setFont(self.font)
		if self.isOpened or self.isOpening or self.isClosing then
			self.currentPage:draw()
		end
		love.graphics.setFont(previousFont)
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
				if self.currentPage:closeTopPanels() then
					self.currentPage = self.pages.homepage
				end
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
	
	wheelMoved = function (self, x, y)
		self.currentPage:wheelMoved(x, y)
	end,

	keyPressed = function(self, key)
		self.currentPage:keyPressed(key)
	end,
	
	keyReleased = function (self, key)
		self.currentPage:keyReleased(key)
	end,
	
	textInput = function (self, ch)
		self.currentPage:textInput(ch)
	end,
	
	fileDropped = function (self, file)
	end,
	
	getIsInside = function (self)
		return self.currentPage:getIsInside()
	end,
	
	getIsFocusing = function (self)
		return self.currentPage:getIsFocusing()
	end,
}