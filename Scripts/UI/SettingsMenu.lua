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
		
		self.currentPage = nil
		
		self.proposedResolution = {1920, 1080}
		
		self.font = love.graphics.newFont("Assets/NotoSansCJKtc-Medium_1.otf", 36)
		
		self.pages = {
			homepage = UIPanel(self.x,self.y, self.width,self.height,
				{
					UIButton(0.0,0.0, 1.0,0.06, "System", love.graphics.newImage("Assets/Free desktop PC icon.png"), 
						function (obj)
							self:changePage(self.pages.system)
							self.currentPage:open()
						end
					),
					UIButton(0.0,0.1, 1.0,0.06, "Playback", love.graphics.newImage("Assets/video cassette recorder icon 2.png"), 
						function (obj)
							self:changePage(self.pages.playback)
							self.currentPage:open()
						end
					),
					UIButton(0.0,0.2, 1.0,0.06, "Tracks", love.graphics.newImage("Assets/mixer (music) icon 1.png"), 
						function (obj)
							self:changePage(self.pages.tracks)
							self.currentPage:open()
						end
					),
					UIButton(0.0,0.3, 1.0,0.06, "Display", love.graphics.newImage("Assets/projector.png"), 
						function (obj)
							self:changePage(self.pages.display)
							self.currentPage:open()
						end
					),
					UIButton(0.0,0.4, 1.0,0.06, "Video Export", love.graphics.newImage("Assets/Film projector 8.png"), 
						function (obj)
							self:changePage(self.pages.videoExport)
							self.currentPage:open()
						end
					),
					UIButton(0.0,0.5, 1.0,0.06, "Update", love.graphics.newImage("Assets/Reload icon.png"), 
						function (obj)
							self:changePage(self.pages.update)
							self.currentPage:open()
						end
					),
					UIButton(0.0,0.6, 1.0,0.06, "About", love.graphics.newImage("Assets/Resume icon 6.png"), 
						function (obj)
							self:changePage(self.pages.about)
							self.currentPage:open()
						end
					),
				}
			),
			
			system = UIPanel(self.x,self.y, self.width,self.height,
				{
					UIText(-0.05,0.00, 1.0,0.05, "Display Properties", 1, false,true),
					UIButton(0.0,0.06, 0.45,0.05,"Import", nil, 
						function (obj)
							local path = ffi.string(openFileDialog("open", "MIDIFall Properties Files (*.mfp)\0*.mfp\0All Files (*.*)\0*.*\0\0"))
							if path ~= "" then
								propertiesManager:load(path)
							end
							-- propertiesManager:load(getDirectory().."/properties.txt")
						end
					),
					UIButton(0.55,0.06,0.45,0.05,"Export", nil, 
						function (obj)
							local path = ffi.string(openFileDialog("save", "MIDIFall Properties Files (*.mfp)\0*.mfp\0All Files (*.*)\0*.*\0\0", string.format("%s.mfp", os.date("%Y%m%d-%H%M%S"))))
							if path ~= "" then
								propertiesManager:save(path)
							end
							-- propertiesManager:save(getDirectory().."/properties.txt")
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
							
							love.resize(self.proposedResolution[1], self.proposedResolution[2])
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
							local path = ffi.string(openFileDialog("open", "MIDI Files (*.mid)\0*.mid\0All Files (*.*)\0*.*\0\0"))
							if path ~= "" then
								player:loadSongFromPath(path)
								uiManager:getComponents()[1]:initializeTracksPanel()
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
			
			tracks = UIPanel(self.x,self.y, self.width,self.height, {}),
			
			display = UIPanel(self.x,self.y, self.width,self.height,
				{
					UIText(0.0,0.0, 1.0,0.05, "Orientation", 0.7, false,true),
					UIDropdown(0.45,0.0, 0.55,0.05,
						{
							"Horizontal",
							"Vertical",
							"Horizontal (Mirrored)",
							"Vertical (Mirrored)"
						},
						mainComponent.orientation+1,
						function (obj, choiceID)
							mainComponent:setOrientation(choiceID-1)
						end
					),
					
					UIText(0.0,0.1, 1.0,0.05, "Theme", 0.7, false,true),
					UIButton(0.35,0.1, 0.3,0.05,"Load", nil, 
						function (obj)
							local path = ffi.string(openFileDialog("open", "MIDIFall Theme Configuration File (*.mftc)\0*.mftc\0All Files (*.*)\0*.*\0\0"))
							
							if path ~= "" then
								mainComponent:getThemeManager():loadTheme(path)
								-- if not pcall(mainComponent:getThemeManager().loadTheme, self, path) then
									-- love.window.showMessageBox("Error", "It is not a valid theme configuration file.", "error")
								-- end
							end
						end
					),
					UIButton(0.7,0.1, 0.3,0.05,"Reset", nil, 
						function (obj)
							mainComponent:getThemeManager():reset()
						end
					),
					
					UIText(0.0,0.15, 1.0,0.05,
						Follower(
							function ()
								local environment = mainComponent.themeManager
								return string.format(
									"%s (v%.2f) by %s", environment.name, environment.version, environment.author
								)
							end
						),
						0.7, false,true
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
					UIButton(0.2,0.8, 0.8,0.05,"Measures", nil, 
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
							local path = ffi.string(openFileDialog("open",
									"Images (*.bmp;*.jpg;*.jpeg;*.png)\0*.bmp;*.jpg;*.jpeg;*.png\0All Files(*.*)\0*.*\0\0"
								)
							)
							
							if path ~= "" then
								mainComponent.backgroundComponent:setImage(path)
							end
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
					
					UICheckbox(0.0,0.35, 1.0,0.04, "Horizontally Fit", Alias(mainComponent.backgroundComponent.fits, 1)),
					
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
					
					UISliderSuite(0.0,0.5, 1.0,0.07, "Key Gap", Alias(mainComponent, "keyGap"), 0,1, 0.0001),
					
					UIText(0.0,0.65, 0.5,0.05, "Black Keys Colour", 0.7, false,true),
					UIColorPickerToggle(0.55,0.65, 0.45,0.05,
						Alias(mainComponent.keyboardComponent.blackKeyColorHSV, 1),
						Alias(mainComponent.keyboardComponent.blackKeyColorHSV, 2),
						Alias(mainComponent.keyboardComponent.blackKeyColorHSV, 3),
						Alias(mainComponent.keyboardComponent, "blackKeyAlpha")
					),
					
					UIText(0.0,0.72, 0.5,0.05, "White Keys Colour", 0.7, false,true),
					UIColorPickerToggle(0.55,0.72, 0.45,0.05,
						Alias(mainComponent.keyboardComponent.whiteKeyColorHSV, 1),
						Alias(mainComponent.keyboardComponent.whiteKeyColorHSV, 2),
						Alias(mainComponent.keyboardComponent.whiteKeyColorHSV, 3),
						Alias(mainComponent.keyboardComponent, "whiteKeyAlpha")
					),
					
					UICheckbox(0.0,0.84, 1.0,0.04, "Rainbow Highlight Colour", Alias(mainComponent.keyboardComponent, "useRainbowColor")),
					
					UIText(0.0,0.9, 0.5,0.05, "Highlight Colour", 0.7, false,true),
					UIColorPickerToggle(0.55,0.9, 0.45,0.05,
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
					
					UIText(0,0.2, 0.5,0.05, "Measure Colour", 0.7, false,true),
					UIColorPickerToggle(0.55,0.2, 0.45,0.05,
						Alias(mainComponent.measuresComponent.measureColorHSV, 1),
						Alias(mainComponent.measuresComponent.measureColorHSV, 2),
						Alias(mainComponent.measuresComponent.measureColorHSV, 3),
						Alias(mainComponent.measuresComponent, "measureAlpha")
					),
					
					UIText(0,0.32, 0.5,0.05, "Font", 0.7, false,true),
					UIButton(0.35,0.32, 0.3,0.05,"Import", nil, 
						function (obj)
							local path = ffi.string(openFileDialog("open",
									"Images (*.otf;*.ttf)\0*.otf;*.ttf\0All Files(*.*)\0*.*\0\0"
								)
							)
							
							if path ~= "" then
								mainComponent.measuresComponent:setFontPath(path)
							end
						end
					),
					UIButton(0.7,0.32, 0.3,0.05,"Reset", nil, 
						function (obj)
							mainComponent.measuresComponent:useDefaultFont()
						end
					),
					
					UISliderSuite(0.0,0.4, 1.0,0.07, "Text Offset X", Alias(mainComponent.measuresComponent.measureTextOffsets, 1), -1,1, 0.0001),
					
					UISliderSuite(0.0,0.48, 1.0,0.07, "Text Offset Y", Alias(mainComponent.measuresComponent.measureTextOffsets, 2), -1,1, 0.0001),
					
					UISliderSuite(0.0,0.6, 1.0,0.07, "Text Size", Alias(mainComponent.measuresComponent, "measureTextScale"), 0.01,1, 0.0001),
					
					UIText(0,0.7, 0.5,0.05, "Text Colour", 0.7, false,true),
					UIColorPickerToggle(0.55,0.7, 0.45,0.05,
						Alias(mainComponent.measuresComponent.measureTextColorHSVA, 1),
						Alias(mainComponent.measuresComponent.measureTextColorHSVA, 2),
						Alias(mainComponent.measuresComponent.measureTextColorHSVA, 3),
						Alias(mainComponent.measuresComponent.measureTextColorHSVA, 4)
					),
				},
				
				{
					UIText(0.0,0.0, 1.0,0.05, "Statistic", 1, true,true),
					
					UIText(0,0.1, 0.5,0.05, "Font", 0.7, false,true),
					UIButton(0.35,0.1, 0.3,0.05,"Import", nil, 
						function (obj)
							local path = ffi.string(openFileDialog("open",
									"Images (*.otf;*.ttf)\0*.otf;*.ttf\0All Files(*.*)\0*.*\0\0"
								)
							)
							
							if path ~= "" then
								mainComponent.statisticComponent:setFontPath(path)
							end
						end
					),
					UIButton(0.7,0.1, 0.3,0.05,"Reset", nil, 
						function (obj)
							mainComponent.statisticComponent:useDefaultFont()
						end
					),
					
					UISliderSuite(0.0,0.2, 1.0,0.07, "Text Offset X", Alias(mainComponent.statisticComponent.textOffsets, 1), -1,1, 0.0001),
					
					UISliderSuite(0.0,0.28, 1.0,0.07, "Text Offset Y", Alias(mainComponent.statisticComponent.textOffsets, 2), -1,1, 0.0001),
					
					UISliderSuite(0.0,0.4, 1.0,0.07, "Text Size Scale", Alias(mainComponent.statisticComponent, "textScale"), 0.01,1, 0.0001),
					
					UIText(0,0.5, 0.5,0.05, "Text Colour", 0.7, false,true),
					UIColorPickerToggle(0.55,0.5, 0.45,0.05,
						Alias(mainComponent.statisticComponent.colorHSVA, 1),
						Alias(mainComponent.statisticComponent.colorHSVA, 2),
						Alias(mainComponent.statisticComponent.colorHSVA, 3),
						Alias(mainComponent.statisticComponent.colorHSVA, 4)
					),
				}
			),
			
			videoExport = UIPanel(self.x,self.y, self.width,self.height,
				{
					UIText(0.0,0.0, 1.0,0.05, "Video Export", 1, true,true),
					
					UISliderSuite(0.0,0.1, 1.0,0.07, "Framerate", Alias(displayComponentsRenderer, "exportingFramerate"), 1,240, 1),
					
					UIText(0.0,0.2, 1.0,0.05, "Resolution", 0.7, false,true),
					UISliderSuite(0.0,0.25, 1.0,0.07, "Width", Alias(displayComponentsRenderer, "exportingWidth"), 2,10000, 2),
					UISliderSuite(0.0,0.35, 1.0,0.07, "Height", Alias(displayComponentsRenderer, "exportingHeight"), 2,10000, 2),
					
					UIButton(0.0,0.45, 1.0,0.05,"Resize to the screen size", nil, 
						function (obj)
							displayComponentsRenderer:setExportingResolution(love.window.getMode())
						end
					),
					
					UICheckbox(0.0,0.55, 1.0,0.04, "Preserve Transparency (Disable x264)", Alias(displayComponentsRenderer, "exportingTransparency")),
					
					UIText(0.0,0.65, 1.0,0.05, "x264 Settings", 0.7, false,true),
					UISliderSuite(0.0,0.7, 1.0,0.07, "CRF", Alias(displayComponentsRenderer, "exportingCRF"), 0,51, 1),
					
					UIText(0.0,0.8, 1.0,0.05, "Speed", 0.7, false,true),
					UIDropdown(0.55,0.8, 0.45,0.05,
						displayComponentsRenderer.exportingPresets,
						displayComponentsRenderer.exportingPresetID,
						function (obj, choiceID)
							displayComponentsRenderer:setExportingPresetID(choiceID)
						end
					),
					
					UIButton(0.0,0.95, 0.45,0.05,"Export", nil, 
						function (obj)
							if displayComponentsRenderer:checkIfEncoderExist() then
								while not self.currentPage:closeTopPanels() do end
								self:changePage(self.pages.homepage)
								self:close()
							end
							
							displayComponentsRenderer:startToRender()
						end
					),
				}
			),
			
			update = UIPanel(self.x,self.y, self.width,self.height,
				{
					UIText(0.0,0.0, 1.0,0.05, "Update", 1, true,true, nil, true),
					
					UIText(0.0,0.1, 1.0,0.05,
						"Current Version",
						0.7, false,true
					),
					
					UIText(0.6,0.1, 1.0,0.05,
						string.format("v%.1f", VERSION),
						0.7, false,true
					),
					
					UIText(0.0,0.15, 1.0,0.05,
						"Latest Version",
						0.7, false,true
					),
					
					UIText(0.6,0.15, 1.0,0.05,
						"",
						0.7, false,true
					),
					
					UIButton(0.6,0.15, 0.4,0.05,"Check", nil, 
						function (obj)
							updateManager:fetch(
								function (version)
									self.pages.update.children[5]:setText(string.format("v%.1f", version))
									table.remove(self.pages.update.children, 6)
								end
							)
						end
					),
					
					UIButton(0.0,0.25, 0.45,0.05,"Download", nil, 
						function (obj)
							love.system.openURL("http://gawehold.weebly.com/midifall.html")
						end
					),
				}
			),
			
			about = UIPanel(self.x,self.y, self.width,self.height,
				{
					UIText(0.0,0.0, 1.0,0.05, "About", 1, true,true, nil, true),
					
					UIImage(0.0,0.09, 1.0,0.1, love.graphics.newImage("Assets/logo.png")),
					UIText(0.0,0.20, 1.0,0.05, string.format("MIDIFall v%.1f", VERSION), 1, true,true),
					UIText(0.0,0.24, 1.0,0.05, "Copyright (c) 2017-2020 Gawehold", 1, true,true),
					UIButton(0.0,0.32, 0.45,0.05,"Website", nil, 
						function (obj)
							love.system.openURL("http://gawehold.weebly.com/midifall.html")
						end
					),
					UIButton(0.55,0.32, 0.45,0.05,"Github", nil, 
						function (obj)
							love.system.openURL("https://github.com/Gawehold/MIDIFall")
						end
					),
				}
			),
		}
		
		-- Linking the UI Objects
		self.pages.videoExport.children[9].slider.isFrozen = Alias(self.pages.videoExport.children[7], "isChecked")
		self.pages.videoExport.children[9].inputBox.isFrozen = Alias(self.pages.videoExport.children[7], "isChecked")
		self.pages.videoExport.children[11].isFrozen = Alias(self.pages.videoExport.children[7], "isChecked")
		
		self:initializeTracksPanel()
		
		self:changePage(self.pages.homepage)
		-- self:changePage(self.pages.display)
		-- self.pages.display:changePage(7)
		
		-- self:open()
	end,
	
	initializeTracksPanel = function (self)
		local tracksPageChildren = {
			UIText(0.0,0.0, 1.0,0.05, "Tracks", 1, true,true, nil, true),
			UIButton(0.0,0.1, 1.0,0.05,"Reset All Colours", nil, 
				function (obj)
					player:getSong():resetTracksColor()
				end
			),
		}
		
		for i, track in ipairs(player:getSong():getTracks()) do
			local y = (i-1)/20 + 0.2
			
			table.insert(tracksPageChildren, 
				UICheckbox(0.0,y, 1.0,0.04, "", Alias(track, "enabled"))
			)
			
			table.insert(tracksPageChildren, 
				UICheckbox(0.12,y, 1.0,0.04, "Track "..i, Alias(track, "isDiamond"),
					nil,nil,
					love.graphics.newImage("Assets/Diamond mark 1.png"),
					love.graphics.newImage("Assets/Diamond mark 2.png")
				)
			)
			
			table.insert(tracksPageChildren, 
				UIColorPickerToggle(0.9,y, 0.1,0.04, 
					Alias(track.customColorHSV, 1),
					Alias(track.customColorHSV, 2),
					Alias(track.customColorHSV, 3),
					nil,
					""
				)
			)
			
			table.insert(tracksPageChildren, 
				UIInputBox(0.65,y, 0.2,0.04, 
					Follower(
						function ()
							return track:getPriority()
						end,
						
						function (value)
							track:setPriority(value)
							player:getSong():sortTracks()
						end
					)
				)
			)
		end
		
		self.pages.tracks:setPages(tracksPageChildren)
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
		if self.isOpening or self.isClosing then
			return
		end
		
		self.isOpening = true
	end,
	
	close = function (self)
		if self.isOpening or self.isClosing then
			return
		end
		
		self.isClosing = true
		self.isOpened = false
	end,
	
	openOrClose = function (self)
		if self.currentPage == self.pages.homepage then
			if self.isOpened then
				self:close()
			else
				self:open()
			end
		else
			if self.currentPage:closeTopPanels() then
				self:changePage(self.pages.homepage)
			end
		end
	end,
	
	mousePressed = function (self, mouseX, mouseY, button, istouch, presses)
		if button == 2 then
			self:openOrClose()
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
	
	-- findAnyFocusingDescendant = function (self)
		-- return self.currentPage:findAnyFocusingDescendant()
	-- end,
	
	getIsClicking = function (self)
		return self.currentPage:getIsClicking()
	end,
	
	changePage = function (self, page)
		-- For preventing incorrect "isInside" information after change page without moving the mouse
		if self.currentPage then
			page.isInside = self.currentPage.isInside
		end
		
		self.currentPage = page
	end,
}