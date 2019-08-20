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
							self.currentPage = self.pages.videoExport
							self.currentPage:open()
						end
					),
					UIButton(0.0,0.5, 1.0,0.06, "Update", love.graphics.newImage("Assets/Reload icon.png"), 
						function (obj)
							self.currentPage = self.pages.update
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
					UIText(-0.05,0.00, 1.0,0.05, "Properties", 1, false,true),
					UIButton(0.0,0.06, 0.45,0.05,"Import", nil, 
						function (obj)
							ffi.string(clib.openFileDialog())
						end
					),
					UIButton(0.55,0.06,0.45,0.05,"Export", nil, 
						function (obj)
							ffi.string(clib.openFileDialog())
						end
					),
					
					UIText(-0.05,0.16, 1.0,0.05, "Resolution", 1, false,true),
					UISliderSuite(0.0,0.22, 1.0,0.07, "Width", Alias(self.proposedResolution, 1), 1,select(1, love.window.getDesktopDimensions()), 1),
					UISliderSuite(0.0,0.32, 1.0,0.07, "Height", Alias(self.proposedResolution, 2), 1,select(2, love.window.getDesktopDimensions()), 1),
					UIButton(0.0,0.42,0.45,0.05,"Update", nil, 
						function (obj)
							love.window.setFullscreen(false)
							
							local width, height, flags = love.window.getMode()
							flags.x = nil
							flags.y = nil
							love.window.setMode(self.proposedResolution[1], self.proposedResolution[2], flags)
						end
					),
					
					UICheckbox(0.0,0.53, 1.0,0.05, "Fullscreen", love.window.getFullscreen(), 
						function (obj)
							love.window.setFullscreen(true)
						end,
						function (obj)
							love.window.setFullscreen(false)
						end
					),
					
					UICheckbox(0.0,0.59, 1.0,0.05, "Vsync", select(3, love.window.getMode()).vsync~=0, 
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
					UIText(-0.05,0.00, 1.0,0.05, "MIDI File", 1, false,true),
					UIButton(0.55,0.00, 0.45,0.05,"Load", nil, 
						function (obj)
							local path = ffi.string(clib.openFileDialog())
							if path then
								player:loadSongFromPath(path)
							end
						end
					),
					
					UIText(-0.05,0.1, 1.0,0.05, "MIDI Device", 1, false,true),
					UIDropdown(0.0,0.16, 1.0,0.05,
						player:getMIDIPortListFrom1(),
						player:getMIDIPort()+1,
						function (obj, choiceID)
							player:setMIDIPort(choiceID-1)
						end
					),
					
					UIText(-0.05,0.26, 1.0,0.05, "Playback", 1, false,true),
					UISliderSuite(0.0,0.32, 1.0,0.07, "Speed", Alias(player, "playbackSpeed"), 0.01,10,0.01),
					
					UICheckbox(0.0,0.42, 1.0,0.05, "Mute", player.muted,
						function(obj)
							player:setMuted(true)
						end,
						function(obj)
							player:setMuted(false)
						end
					)
				}
			),
			
			tracks = UIPanel(self.x,self.y, self.width,self.height,
				{
					
				}
			),
			
			display = UIPanel(self.x,self.y, self.width,self.height,
				{
					UIText(-0.05,0.0, 1.0,0.05, "Orientation", 1, false,true),
					UIDropdown(0.0,0.06, 1.0,0.05,
						{
							"Horizontal",
							"Vertical",
							"Horizaontal (Mirrored)",
							"Vertical (Mirrored)"
						},
						mainComponent.orientation+1,
						function (obj, choiceID)
							mainComponent:setOrientation(choiceID-1)
						end
					),
					
					UIText(-0.05,0.15, 1.0,0.05, "Theme", 1, false,true),
					UICheckbox(0,0.2, 1.0,0.05, "Enabled", false),
					UIButton(0.55,0.2, 0.45,0.05,"Load", nil, 
						function (obj)
							local path = ffi.string(clib.openFileDialog())
							if path then
								player:loadSongFromPath(path)
							end
						end
					),
					
					UICheckbox(0,0.3, 1.0,0.05, "", Alias(mainComponent.backgroundComponent, "enabled")),
					UIButton(0.2,0.3, 0.8,0.05,"Background", nil, 
						function (obj)
							obj.parent:changePage(2)
						end
					),
					
					UICheckbox(0,0.4, 1.0,0.05, "", Alias(mainComponent.keyboardComponent, "enabled")),
					UIButton(0.2,0.4, 0.8,0.05,"Keyboard", nil, 
						function (obj)
							obj.parent:changePage(3)
						end
					),
					
					UICheckbox(0,0.5, 1.0,0.05, "", Alias(mainComponent.notesComponent, "enabled")),
					UIButton(0.2,0.5, 0.8,0.05,"Notes", nil, 
						function (obj)
							obj.parent:changePage(4)
						end
					),
					
					UICheckbox(0,0.6, 1.0,0.05, "", Alias(mainComponent.fallsComponent, "enabled")),
					UIButton(0.2,0.6, 0.8,0.05,"Falls", nil, 
						function (obj)
							obj.parent:changePage(5)
						end
					),
					
					UICheckbox(0,0.7, 1.0,0.05, "", Alias(mainComponent.hitAnimationComponent, "enabled")),
					UIButton(0.2,0.7, 0.8,0.05,"Hit Animation", nil, 
						function (obj)
							obj.parent:changePage(6)
						end
					),
					
					UICheckbox(0,0.8, 1.0,0.05, "", Alias(mainComponent.measuresComponent, "enabled")),
					UIButton(0.2,0.8, 0.8,0.05,"Measure", nil, 
						function (obj)
							obj.parent:changePage(7)
						end
					),
					
					UICheckbox(0,0.9, 1.0,0.05, "", Alias(mainComponent.statisticComponent, "enabled")),
					UIButton(0.2,0.9, 0.8,0.05,"Statistic", nil, 
						function (obj)
							obj.parent:changePage(8)
						end
					),
				},
				
				{
					UIText(0.0,0.0, 1.0,0.05, "Background", 1, true,true),
					
					UIText(0.0,0.1, 1.0,0.05, "Image", 0.8),
					UIButton(0.55,0.1, 0.45,0.05,"Load", nil, 
						function (obj)
							mainComponent.backgroundComponent:setImage(tostring(ffi.string(clib.openFileDialog())))
						end
					),
					
					UIText(0.0,0.2, 1.0,0.05, "Colour", 0.8),
					UIColorPickerToggle(0.55,0.2, 0.45,0.05,
						Alias(mainComponent.backgroundComponent.colorHSVA, 1),
						Alias(mainComponent.backgroundComponent.colorHSVA, 2),
						Alias(mainComponent.backgroundComponent.colorHSVA, 3),
						Alias(mainComponent.backgroundComponent.colorHSVA, 4)
					),
					
					UICheckbox(0.0,0.3, 1.0,0.04, "Align Center", Alias(mainComponent.backgroundComponent, "isAligncenter")),
					
					UICheckbox(0.0,0.35, 1.0,0.04, "Horizaontally Fit", Alias(mainComponent.backgroundComponent.fits, 1)),
					
					UICheckbox(0.0,0.4, 1.0,0.04, "Vertically Fit", Alias(mainComponent.backgroundComponent.fits, 2)),
					
					UISliderSuite(0.0,0.5, 1.0,0.07, "Horizontal Scale", Alias(mainComponent.backgroundComponent.scales, 1), 0,10, 0.0001),
					
					UISliderSuite(0.0,0.6, 1.0,0.07, "Vertical Scale", Alias(mainComponent.backgroundComponent.scales, 2), 0,10, 0.0001),
					
					UISliderSuite(0.0,0.7, 1.0,0.07, "Horizontal Offset", Alias(mainComponent.backgroundComponent.offsets, 1), -1,1, 0.0001),
					
					UISliderSuite(0.0,0.8, 1.0,0.07, "Vertical Offset", Alias(mainComponent.backgroundComponent.offsets, 2), -1,1, 0.0001),
				},
				
				{
					UIText(0.0,0.0, 1.0,0.05, "Keyboard", 1, true,true),
					
					UIText(0.0,0.11, 1.0,0.04, "Range"),
					UIText(0.6,0.1, 0.3,0.04, "To"),
					UIInputBox(0.3,0.1, 0.25,0.04, Alias(mainComponent, "lowestKey")),
					UIInputBox(0.75,0.1, 0.25,0.04, Alias(mainComponent, "highestKey")),
					UIRangeSlider(0.3,0.16,0.7,0.018, Alias(mainComponent, "lowestKey"),Alias(mainComponent, "highestKey"), 0,127,1),
					
					UISliderSuite(0.0,0.2, 1.0,0.07, "Position", Alias(mainComponent, "keyboardPosition"), -1,1, 0.0001),
					
					UISliderSuite(0.0,0.3, 1.0,0.07, "Length", Alias(mainComponent, "keyboardLength"), 0,1, 0.0001),
					
					UISliderSuite(0.0,0.4, 1.0,0.07, "Height", Alias(mainComponent, "keyboardHeight"), 0,1, 0.0001),
					
					UIText(0.0,0.55, 0.5,0.05, "Black Keys Colour", 0.7, false,true),
					UIColorPickerToggle(0.55,0.55, 0.45,0.05,
						Alias(mainComponent.keyboardComponent.blackKeyColorHSV, 1),
						Alias(mainComponent.keyboardComponent.blackKeyColorHSV, 2),
						Alias(mainComponent.keyboardComponent.blackKeyColorHSV, 3),
						Alias(mainComponent.keyboardComponent, "blackKeyAlpha")
					),
					
					UIText(0.0,0.62, 0.5,0.05, "White Keys Colour", 0.7, false,true),
					UIColorPickerToggle(0.55,0.62, 0.45,0.05,
						Alias(mainComponent.keyboardComponent.whiteKeyColorHSV, 1),
						Alias(mainComponent.keyboardComponent.whiteKeyColorHSV, 2),
						Alias(mainComponent.keyboardComponent.whiteKeyColorHSV, 3),
						Alias(mainComponent.keyboardComponent, "whiteKeyAlpha")
					),
					
					UICheckbox(0.0,0.74, 1.0,0.04, "Rainbow Highlight Colour", Alias(mainComponent.keyboardComponent, "useRainbowColor")),
					
					UIText(0.0,0.8, 0.5,0.05, "Highlight Colour", 0.7, false,true),
					UIColorPickerToggle(0.55,0.8, 0.45,0.05,
						Alias(mainComponent.keyboardComponent, "rainbowHueShift"),
						Alias(mainComponent.keyboardComponent.brightKeyColorHSV, 2),
						Alias(mainComponent.keyboardComponent.brightKeyColorHSV, 3),
						Alias(mainComponent.keyboardComponent, "brightKeyAlpha")
					),
				},
				
				{
					UIText(0.0,0.0, 1.0,0.05, "Notes", 1, true,true),
					
					UISliderSuite(0.0,0.1, 1.0,0.07, "Length Scale", Alias(mainComponent.notesComponent, "noteScale"), 0.01,10, 0.0001),
					
					UISliderSuite(0.0,0.2, 1.0,0.07, "Length Offset", Alias(mainComponent.notesComponent, "noteLengthOffset"), 0,1, 0.0001),
					
					UISliderSuite(0.0,0.3, 1.0,0.07, "Pitch Bend Range", Alias(mainComponent.notesComponent, "pitchBendSemitone"), 0,24, 1),
					
					UICheckbox(0.0,0.45, 1.0,0.04, "Rainbow Colour", Alias(mainComponent.notesComponent, "useRainbowColor")),
					
					UIText(0,0.5, 0.5,0.05, "Colour", 0.7, false,true),
					UIColorPickerToggle(0.55,0.5, 0.45,0.05,
						Alias(mainComponent.notesComponent, "rainbowColorHueShift"),
						Alias(mainComponent.notesComponent, "rainbowColorSaturation"),
						Alias(mainComponent.notesComponent, "rainbowColorValue"),
						Alias(mainComponent.notesComponent, "colorAlpha")
					),
					
					UICheckbox(0.0,0.6, 1.0,0.04, "Highlight while playing", Alias(mainComponent.notesComponent, "brightNote")),
					
					UIText(0.0,0.65, 0.5,0.05, "Highlight Colour", 0.7, false,true),
					UIColorPickerToggle(0.55,0.65, 0.45,0.05,
						Alias(mainComponent.notesComponent, "rainbowColorHueShift"),
						Alias(mainComponent.notesComponent, "brightNoteSaturation"),
						Alias(mainComponent.notesComponent, "brightNodeValue"),
						Alias(mainComponent.notesComponent, "colorAlpha")
					),
				},
				
				{
					UIText(0.0,0.0, 1.0,0.05, "Falls", 1, true,true),
					
					UISliderSuite(0.0,0.1, 1.0,0.07, "Length Scale", Alias(mainComponent.fallsComponent, "noteScale"), 0,10, 0.0001),
					
					UISliderSuite(0.0,0.2, 1.0,0.07, "Length Offset", Alias(mainComponent.fallsComponent, "noteLengthOffset"), 0,1, 0.0001),
					
					UISliderSuite(0.0,0.3, 1.0,0.07, "Fade-out Speed", Alias(mainComponent.fallsComponent, "fadingOutSpeed"), 0,10, 0.0001),
					
					UICheckbox(0.0,0.45, 1.0,0.04, "Rainbow Colour", Alias(mainComponent.fallsComponent, "useRainbowColor")),
					
					UIText(0,0.5, 0.5,0.05, "Colour", 0.7, false,true),
					UIColorPickerToggle(0.55,0.5, 0.45,0.05,
						Alias(mainComponent.fallsComponent, "rainbowColorHueShift"),
						Alias(mainComponent.fallsComponent, "rainbowColorSaturation"),
						Alias(mainComponent.fallsComponent, "rainbowColorValue"),
						Alias(mainComponent.fallsComponent, "colorAlpha")
					),
				},
				
				{
					UIText(0.0,0.0, 1.0,0.05, "Hit Animation", 1, true,true),
					
					UISliderSuite(0.0,0.1, 1.0,0.07, "Length Scale", Alias(mainComponent.hitAnimationComponent, "lengthScale"), 0,10, 0.0001),
					
					UISliderSuite(0.0,0.2, 1.0,0.07, "Size Scale", Alias(mainComponent.hitAnimationComponent, "sizeScale"), 0,10, 0.0001),
					
					UISliderSuite(0.0,0.3, 1.0,0.07, "Fade-out Speed", Alias(mainComponent.hitAnimationComponent, "fadingOutSpeed"), 0,10, 0.0001),
					
					UICheckbox(0.0,0.45, 1.0,0.04, "Rainbow Colour", Alias(mainComponent.hitAnimationComponent, "useRainbowColor")),
					
					UIText(0,0.5, 0.5,0.05, "Colour", 0.7, false,true),
					UIColorPickerToggle(0.55,0.5, 0.45,0.05,
						Alias(mainComponent.hitAnimationComponent, "rainbowColorHueShift"),
						Alias(mainComponent.hitAnimationComponent, "rainbowColorSaturation"),
						Alias(mainComponent.hitAnimationComponent, "rainbowColorValue"),
						Alias(mainComponent.hitAnimationComponent, "colorAlpha")
					),
				},
				
				{
					UIText(0.0,0.0, 1.0,0.05, "Measures", 1, true,true),
					
					UISliderSuite(0.0,0.1, 1.0,0.07, "Concentration", Alias(mainComponent.measuresComponent, "measureConcentrationRate"), 0,1, 0.0001),
					
					-- UISliderSuite(0.0,0.2, 1.0,0.07, "Size Scale", Alias(mainComponent.hitAnimationComponent, "sizeScale"), 0,10, 0.0001),
					
					-- UISliderSuite(0.0,0.3, 1.0,0.07, "Fade-out Speed", Alias(mainComponent.hitAnimationComponent, "fadingOutSpeed"), 0,10, 0.0001),
					
					-- UICheckbox(0.0,0.45, 1.0,0.04, "Rainbow Colour", Alias(mainComponent.hitAnimationComponent, "useRainbowColor")),
					
					UIText(0,0.2, 0.5,0.05, "Measure Colour", 0.7, false,true),
					UIColorPickerToggle(0.55,0.2, 0.45,0.05,
						Alias(mainComponent.measuresComponent.measureColorHSV, 1),
						Alias(mainComponent.measuresComponent.measureColorHSV, 2),
						Alias(mainComponent.measuresComponent.measureColorHSV, 3),
						Alias(mainComponent.measuresComponent, "measureAlpha")
					),
					
					UIText(0,0.35, 0.5,0.05, "Font", 0.7, false,true),
					UIButton(0.55,0.35, 0.45,0.05,"Import", nil, 
						function (obj)
							ffi.string(clib.openFileDialog())
						end
					),
					
					UISliderSuite(0.0,0.45, 1.0,0.07, "Text Size", Alias(mainComponent.measuresComponent, "measureTextScale"), 0.01,1, 0.0001),
				},
				
				{
					UIText(0.0,0.0, 1.0,0.05, "Statistic", 1, true,true),
					
					-- UISliderSuite(0.0,0.1, 1.0,0.07, "Concentration", Alias(mainComponent.measuresComponent, "measureConcentrationRate"), 0,1, 0.0001),
					
					-- UISliderSuite(0.0,0.2, 1.0,0.07, "Size Scale", Alias(mainComponent.hitAnimationComponent, "sizeScale"), 0,10, 0.0001),
					
					-- UISliderSuite(0.0,0.3, 1.0,0.07, "Fade-out Speed", Alias(mainComponent.hitAnimationComponent, "fadingOutSpeed"), 0,10, 0.0001),
					
					-- UICheckbox(0.0,0.45, 1.0,0.04, "Rainbow Colour", Alias(mainComponent.hitAnimationComponent, "useRainbowColor")),
					
					-- UIText(0,0.5, 0.5,0.05, "Colour", 0.7, false,true),
					-- UIColorPickerToggle(0.55,0.5, 0.45,0.05,
						-- Alias(mainComponent.hitAnimationComponent, "rainbowColorHueShift"),
						-- Alias(mainComponent.hitAnimationComponent, "rainbowColorSaturation"),
						-- Alias(mainComponent.hitAnimationComponent, "rainbowColorValue"),
						-- Alias(mainComponent.hitAnimationComponent, "colorAlpha")
					-- ),
				}
			),
			
			videoExport = UIPanel(self.x,self.y, self.width,self.height,
				{
					UIText(0.0,0.0, 1.0,0.05, "Not yet implemented", 1, true,true, nil, true)
				}
			),
			
			update = UIPanel(self.x,self.y, self.width,self.height,
				{
					UIText(0.0,0.0, 1.0,0.05, "Not yet implemented", 1, true,true, nil, true)
				}
			),
			
			about = UIPanel(self.x,self.y, self.width,self.height,
				{
					UIText(0.0,0.0, 1.0,0.05, "MIDIFall 3.0 (WIP)", 1, true,true),
					UIText(0.0,0.05, 1.0,0.05, "Gawehold", 1, true,true),
				}
			),
		}
		
		self.currentPage = self.pages.homepage
		self.currentPage = self.pages.display
		self.pages.display:changePage(7)
		
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