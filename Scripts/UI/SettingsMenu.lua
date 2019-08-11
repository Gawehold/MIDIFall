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
		
		self.proposedResolution = {1920, 1080}
		
		self.font = love.graphics.newFont("Assets/NotoSansCJKtc-Medium_1.otf", 36)
		
		self.pages = {
			homepage = UIPanel(self.x,self.y, self.width,self.height,
				{
					UIButton(0.0,0.0, 1.0,0.06, "System", love.graphics.newImage("Assets/Free desktop PC icon.png"), 
						function (obj)
							self.currentPage = self.pages.system
							self.currentPage:open()
						end
					),
					UIButton(0.0,0.1, 1.0,0.06, "Playback", love.graphics.newImage("Assets/video cassette recorder icon 2.png"), 
						function (obj)
							self.currentPage = self.pages.playback
							self.currentPage:open()
						end
					),
					UIButton(0.0,0.2, 1.0,0.06, "Tracks", love.graphics.newImage("Assets/mixer (music) icon 1.png"), 
						function (obj)
							self.currentPage = self.pages.tracks
							self.currentPage:open()
						end
					),
					UIButton(0.0,0.3, 1.0,0.06, "Display", love.graphics.newImage("Assets/projector.png"), 
						function (obj)
							self.currentPage = self.pages.display
							self.currentPage:open()
						end
					),
					UIButton(0.0,0.4, 1.0,0.06, "Video Export", love.graphics.newImage("Assets/Film projector 8.png"), 
						function (obj)
							self.currentPage = self.pages.experimental
							self.currentPage:open()
						end
					),
					UIButton(0.0,0.5, 1.0,0.06, "Update", love.graphics.newImage("Assets/Reload icon.png"), 
						function (obj)
							self.currentPage = self.pages.about
							self.currentPage:open()
						end
					),
					UIButton(0.0,0.6, 1.0,0.06, "About", love.graphics.newImage("Assets/Resume icon 6.png"), 
						function (obj)
							self.currentPage = self.pages.about
							self.currentPage:open()
						end
					),
				}
			),
			
			system = UIPanel(self.x,self.y, self.width,self.height,
				{
					UIText(-0.05,0.04, 1.0,0.05, "Properties", 1, false,true),
					UIButton(0.0,0.1,0.45,0.05,"Import", nil, 
						function (obj)
							ffi.string(clib.openFileDialog())
						end
					),
					UIButton(0.55,0.1,0.45,0.05,"Export", nil, 
						function (obj)
							ffi.string(clib.openFileDialog())
						end
					),
					
					UIText(-0.05,0.24, 1.0,0.05, "Resolution", 1, false,true),
					UISliderSuite(0.0,0.3, 1.0,0.07, "Width", Alias(self.proposedResolution, 1), 1,select(1, love.window.getDesktopDimensions()), 1),
					UISliderSuite(0.0,0.4, 1.0,0.07, "Height", Alias(self.proposedResolution, 2), 1,select(2, love.window.getDesktopDimensions()), 1),
					UIButton(0.0,0.5,0.45,0.05,"Update", nil, 
						function (obj)
							love.window.setFullscreen(false)
							
							local width, height, flags = love.window.getMode()
							flags.x = nil
							flags.y = nil
							love.window.setMode(self.proposedResolution[1], self.proposedResolution[2], flags)
						end
					),
					
					UICheckbox(0.0,0.65, 1.0,0.05, "Fullscreen", love.window.getFullscreen(), 
						function (obj)
							love.window.setFullscreen(true)
						end,
						function (obj)
							love.window.setFullscreen(false)
						end
					),
					
					UICheckbox(0.0,0.72, 1.0,0.05, "Vsync", select(3, love.window.getMode()).vsync, 
						function (obj)
							local width, height, flags = love.window.getMode()
							flags.vsync = true
							love.window.setMode(width, height, flags)
						end,
						function (obj)
							local width, height, flags = love.window.getMode()
							flags.vsync = false
							love.window.setMode(width, height, flags)
						end
					)
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
					UIText(-0.005,0.0, 1.0,0.05, "Background", 1, true,true),
					UIText(-0.005,0.1, 1.0,0.05, "Image"),
					UIButton(0.0,0.15, 0.45,0.05,"Load", nil, 
						function (obj)
							mainComponent.backgroundComponent:setImage(tostring(ffi.string(clib.openFileDialog())))
						end
					),
					
					UIColorPickerToggle(0.0,0.25, 1.0,0.05,
						Alias(mainComponent.backgroundComponent.colorHSVA, 1),
						Alias(mainComponent.backgroundComponent.colorHSVA, 2),
						Alias(mainComponent.backgroundComponent.colorHSVA, 3),
						Alias(mainComponent.backgroundComponent.colorHSVA, 4)
					),
					
					UICheckbox(0.0,0.3, 1.0,0.05, "Align Center", Alias(mainComponent.backgroundComponent, "isAligncenter")),
					
					UICheckbox(0.0,0.35, 1.0,0.05, "Horizaontally Fit", Alias(mainComponent.backgroundComponent.fits, 1)),
					
					UICheckbox(0.0,0.4, 1.0,0.05, "Vertically Fit", Alias(mainComponent.backgroundComponent.fits, 2)),
					
					UISliderSuite(0.0,0.5, 1.0,0.1, "Horizontal Scale", Alias(mainComponent.backgroundComponent.scales, 1), 0,10, 0.01),
					
					UISliderSuite(0.0,0.6, 1.0,0.1, "Vertical Scale", Alias(mainComponent.backgroundComponent.scales, 2), 0,10, 0.01),
					
					UISliderSuite(0.0,0.7, 1.0,0.1, "Horizontal Offset", Alias(mainComponent.backgroundComponent.offsets, 1), -1,1, 0.01),
					
					UISliderSuite(0.0,0.8, 1.0,0.1, "Vertical Offset", Alias(mainComponent.backgroundComponent.offsets, 2), -1,1, 0.01),
				},
				
				{
					UIText(0.1,0.1,0.3,0.05, "Keyboard Position", 0.75),
					UIText(0.1,0.1,0.3,0.05, "Keyboard Position", 0.75),
					UIInputBox(0.4,0.115,0.3,0.05, Alias(mainComponent, "keyboardPosition")),
					UISlider(0.1,0.2,0.8,0.02, Alias(mainComponent, "keyboardPosition"),-1,1,0.01),
					UISlider(0.1,0.3,0.8,0.02, Alias(mainComponent, "keyboardLength"),0,1,0.01),
					UISlider(0.1,0.4,0.8,0.02, Alias(mainComponent.notesComponent, "rainbowcolorHueShift"),0,1,0.01),
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
					UIText(0.1,0.1,0.8,0.5, "A MIDI score (smf file) visualizer with rainbow falls!", 1, true,true, nil, true)
				}
			),
		}
		
		-- self.currentPage = self.pages.display
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
		self.currentPage:fileDropped(file)
	end,
	
	resize = function (self, w, h)
		self.proposedResolution[1] = w
		self.proposedResolution[2] = h
		
		self.currentPage:resize(w, h)
	end,
	
	getIsInside = function (self)
		return self.currentPage:getIsInside()
	end,
	
	getIsFocusing = function (self)
		return self.currentPage:getIsFocusing()
	end,
}