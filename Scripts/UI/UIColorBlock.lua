class "UIColorBlock" {
	extends "UIObject",
	
	new = function (self, x,y,width,height, colorHueAlias,colorSaturationAlias,colorValueAlias,colorAlphaAlias)
		-- self:super(x,y, width,height)
		UIObject.instanceMethods.new(self, x,y, width,height) -- self.super not working for two level inhertance
		
		self.colorHue = colorHueAlias
		self.colorSaturation = colorSaturationAlias
		self.colorValue  = colorValueAlias
		self.colorAlpha = colorAlphaAlias
	end,
	
	draw = function (self)
		local boxX, boxY = self.transform:transformPoint(self.x, self.y)
		local boxX2, boxY2 = self.transform:transformPoint(self.x+self.width, self.y+self.height)
		local boxWidth = boxX2 - boxX
		local boxHeight = boxY2 - boxY
		
		love.graphics.setColor(vivid.HSVtoRGB(self.colorHue, self.colorSaturation, self.colorValue, self.colorAlpha))
		love.graphics.rectangle("fill", boxX,boxY, boxWidth,boxHeight)
	end,
}