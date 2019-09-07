class "UISliderSuite" {
	extends "UIObject",
	
	new = function (self, x,y,width,height, text, valueAlias, minValue,maxValue, valueStep)
		self:super(x,y, width,height)
		
		self.text = UIText(x,y, width/2,height/2, text, 1, false,true, nil, false)
		self.inputBox = UIInputBox(x+width/2,y, width/2,height/2, valueAlias)
		self.slider = UISlider(x,y+3*height/4, width,height/4, valueAlias, minValue,maxValue, valueStep)
		
	end,
	
	update = function (self, dt, transform)
		self.transform = transform
		
		self.text:update(dt, transform)
		self.inputBox:update(dt, transform)
		self.slider:update(dt, transform)
	end,
	
	draw = function (self)
		self.text:draw()
		self.inputBox:draw()
		self.slider:draw()
	end,
	
	setIsFrozen = function (self, isFrozen)
		self.text:setIsForzen(isFrozen)
		self.inputBox:setIsForzen(isFrozen)
		self.slider:setIsForzen(isFrozen)
	end,
	
	mousePressed = function (self, mouseX, mouseY, button, istouch, presses)
		self.text:mousePressed(mouseX, mouseY, button, istouch, presses)
		self.inputBox:mousePressed(mouseX, mouseY, button, istouch, presses)
		self.slider:mousePressed(mouseX, mouseY, button, istouch, presses)
	end,
	
	mouseReleased = function (self, mouseX, mouseY, istouch, presses)
		self.text:mouseReleased(mouseX, mouseY, istouch, presses)
		self.inputBox:mouseReleased(mouseX, mouseY, istouch, presses)
		self.slider:mouseReleased(mouseX, mouseY, istouch, presses)
	end,

	mouseMoved = function (self, x, y, dx, dy, istouch)
		self.text:mouseMoved(x, y, dx, dy, istouch)
		self.inputBox:mouseMoved(x, y, dx, dy, istouch)
		self.slider:mouseMoved(x, y, dx, dy, istouch)
	end,
	
	wheelMoved = function (self, x, y)
		self.text:wheelMoved(x, y)
		self.inputBox:wheelMoved(x, y)
		self.slider:wheelMoved(x, y)
	end,

	keyPressed = function(self, key)
		self.text:keyPressed(key)
		self.inputBox:keyPressed(key)
		self.slider:keyPressed(key)
	end,
	
	keyReleased = function (self, key)
		self.text:keyReleased(key)
		self.inputBox:keyReleased(key)
		self.slider:keyReleased(key)
	end,
	
	textInput = function (self, ch)
		self.text:textInput(ch)
		self.inputBox:textInput(ch)
		self.slider:textInput(ch)
	end,
	
	fileDropped = function (self, file)
		self.text:fileDropped(file)
		self.inputBox:fileDropped(file)
		self.slider:fileDropped(file)
	end,
}