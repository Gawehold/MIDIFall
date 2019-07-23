class "UIColorPicker" {
	extends "UIPanel",
	
	new = function (self, x,y, width,height, colorHueAlias,colorSaturationAlias,colorValueAlias,colorAlphaAlias)
		self.colorHue = colorHueAlias
		self.colorSaturation = colorSaturationAlias
		self.colorValue  = colorValueAlias
		self.colorAlpha = colorAlphaAlias
		
		local palette = UIPalette(0,0,0.5,0.4, colorHueAlias,colorSaturationAlias,colorValueAlias)
		local colorBlock = UIColorBlock(0.5,0,0.5,0.4, colorHueAlias,colorSaturationAlias,colorValueAlias,1)
		local colorHueSlider = UISlider(0.1, 0.6, 0.8,0.05, colorHueAlias, 0,1, 0.01)
		local colorSaturationSlider = UISlider(0.1, 0.7, 0.8,0.05, colorSaturationAlias, 0,1, 0.01)
		local colorValueSlider = UISlider(0.1, 0.8, 0.8,0.05, colorValueAlias, 0,1, 0.01)
		local colorAlphaSlider = UISlider(0.1, 0.9, 0.8,0.05, colorAlphaAlias, 0,1, 0.01)
		
		UIPanel.instanceMethods.new(self, x,y, width,height, {
			palette,
			colorBlock,
			colorHueSlider,
			colorSaturationSlider,
			colorValueSlider,
			colorAlphaSlider,
		})
	end,
}