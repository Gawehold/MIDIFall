class "UIColorPicker" {
	extends "UIPanel",
	
	new = function (self, x,y, width,height, colorHueAlias,colorSaturationAlias,colorValueAlias,colorAlphaAlias)
		self.colorHue = colorHueAlias or 0
		self.colorSaturation = colorSaturationAlias or 0
		self.colorValue  = colorValueAlias or 0
		self.colorAlpha = colorAlphaAlias or 0
		self.hexCode = self:hsvToHex(self.colorHue, self.colorSaturation, self.colorValue)
		
		local palette = UIPalette(0,0,0.5,0.25, colorHueAlias,colorSaturationAlias,colorValueAlias)
		local colorBlock = UIColorBlock(0.5,0,0.5,0.25, colorHueAlias,colorSaturationAlias,colorValueAlias,1)
		
		local colorHueSlider = UISliderSuite(0.0,0.3, 1.0,0.1, "Hue", colorHueAlias, 0,1, 0.0001)
		
		local colorSaturationSlider = UISliderSuite(0.0,0.45, 1.0,0.1, "Saturation", colorSaturationAlias, 0,1, 0.0001)
		
		local colorValueSlider = UISliderSuite(0.0,0.6, 1.0,0.1, "Value", colorValueAlias, 0,1, 0.0001)
		
		local colorAlphaSlider = UISliderSuite(0.0,0.75, 1.0,0.1, "Alpha", colorAlphaAlias, 0,1, 0.0001)
		
		local hexCodeText = UIText(0,0.95, 0.5,0.05, "Hex Code", 0.7, false,true)
		local hexCodeInputBox = UIInputBox(0.5,0.95, 0.5,0.05, Follower(
			function ()
				return self:hsvToHex(self.colorHue, self.colorSaturation, self.colorValue)
			end,
			
			function (value)
				self.hexCode = value
				self.colorHue, self.colorSaturation, self.colorValue = self:hexToHSV(self.hexCode)
			end
		), false)
		
		UIPanel.instanceMethods.new(self, x,y, width,height, {
			colorBlock,
			palette,
			colorHueSlider,
			colorSaturationSlider,
			colorValueSlider,
			colorAlphaSlider,
			hexCodeText,
			hexCodeInputBox,
		})
	end,
	
	hexToHSV = function (self, hexCode)
		if string.sub(hexCode, 1,1) == "#" then
			-- Remove the hash symbol
			hexCode = string.sub(hexCode, 2)
		end
		
		local r = tonumber( string.sub(hexCode, 1,2), 16 ) / 255
		local g = tonumber( string.sub(hexCode, 3,4), 16 ) / 255
		local b = tonumber( string.sub(hexCode, 5,6), 16 ) / 255
		
		return vivid.RGBtoHSV(r,g,b)
	end,
	
	hsvToHex = function (self, h,s,v)
		local r,g,b = vivid.HSVtoRGB(h,s,v)
		
		r = math.round( r * 255 )
		g = math.round( g * 255 )
		b = math.round( b * 255 )
		
		local hexCode = string.format("#%.2X%.2X%.2X", r,g,b)
		
		return hexCode
	end,
	
	draw = function (self)
		if not self.isOpened then
			return
		end
		
		love.graphics.push()
		
			if self.transform then
				love.graphics.applyTransform(self.transform)
			end
			
			love.graphics.setColor(0,0,0,0.8)
			love.graphics.rectangle("fill", self.x,self.y, self.width,self.height, 0.07, 0.03)
		
		love.graphics.pop()
		
		for k,v in ipairs(self.children) do
			v:draw()
		end
	end,
}