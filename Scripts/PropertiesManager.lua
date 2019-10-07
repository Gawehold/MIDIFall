class "PropertiesManager" {
	new = function (self)
		self.header = "-- MIDIFall Properties File"
		self.extension = ".mfp"
		self.properties = {
			"mainComponent", "lowestKey",			false,
			"mainComponent", "highestKey",			false,
			"mainComponent", "keyGap",				false,
			"mainComponent", "keyboardPosition",	false,
			"mainComponent", "keyboardLength",		false,
			"mainComponent", "keyboardHeight",		false,
			"mainComponent", "orientation",			true,
			
			"mainComponent.backgroundComponent", "enabled",			false,
			"mainComponent.backgroundComponent", "fits",			false,
			"mainComponent.backgroundComponent", "scales",			false,
			"mainComponent.backgroundComponent", "offsets",			false,
			"mainComponent.backgroundComponent", "isAligncenter",	false,
			"mainComponent.backgroundComponent", "colorHSVA",		false,
			
			"mainComponent.keyboardComponent", "enabled",				false,
			"mainComponent.keyboardComponent", "useRainbowColor",		false,
			"mainComponent.keyboardComponent", "rainbowHueShift",		false,
			"mainComponent.keyboardComponent", "blackKeyColorHSV",		false,
			"mainComponent.keyboardComponent", "blackKeyAlpha",			false,
			"mainComponent.keyboardComponent", "whiteKeyColorHSV",		false,
			"mainComponent.keyboardComponent", "whiteKeyAlpha",			false,
			"mainComponent.keyboardComponent", "brightKeyColorHSV",		false,
			"mainComponent.keyboardComponent", "brightKeyAlpha",		false,
			
			"mainComponent.notesComponent", "enabled",					false,
			"mainComponent.notesComponent", "noteScale",				false,
			"mainComponent.notesComponent", "noteLengthOffset",			false,
			"mainComponent.notesComponent", "colorAlpha",				false,
			"mainComponent.notesComponent", "useRainbowColor",			false,
			"mainComponent.notesComponent", "rainbowColorHueShift",		false,
			"mainComponent.notesComponent", "rainbowColorSaturation",	false,
			"mainComponent.notesComponent", "rainbowColorValue",		false,
			"mainComponent.notesComponent", "brightNote",				false,
			"mainComponent.notesComponent", "brightNoteSaturation",		false,
			"mainComponent.notesComponent", "brightNodeValue",			false,
			"mainComponent.notesComponent", "pitchBendSemitone",		false,
			
			"mainComponent.fallsComponent", "enabled",					false,
			"mainComponent.fallsComponent", "noteScale",				false,
			"mainComponent.fallsComponent", "noteLengthOffset",			false,
			"mainComponent.fallsComponent", "colorAlpha",				false,
			"mainComponent.fallsComponent", "useRainbowColor",			false,
			"mainComponent.fallsComponent", "rainbowColorHueShift",		false,
			"mainComponent.fallsComponent", "rainbowColorSaturation",	false,
			"mainComponent.fallsComponent", "rainbowColorValue",		false,
			"mainComponent.fallsComponent", "fadingOutSpeed",			false,
			
			"mainComponent.hitAnimationComponent", "enabled",					false,
			"mainComponent.hitAnimationComponent", "useRainbowColor",			false,
			"mainComponent.hitAnimationComponent", "rainbowColorHueShift",		false,
			"mainComponent.hitAnimationComponent", "rainbowColorSaturation",	false,
			"mainComponent.hitAnimationComponent", "rainbowColorValue",			false,
			"mainComponent.hitAnimationComponent", "colorAlpha",				false,
			"mainComponent.hitAnimationComponent", "fadingOutSpeed",			false,
			"mainComponent.hitAnimationComponent", "lengthScale",				false,
			"mainComponent.hitAnimationComponent", "sizeScale",					false,
			
			"mainComponent.measuresComponent", "enabled",					false,
			"mainComponent.measuresComponent", "measureColorHSV",			false,
			"mainComponent.measuresComponent", "measureAlpha",				false,
			"mainComponent.measuresComponent", "measureConcentrationRate",	false,
			"mainComponent.measuresComponent", "fontSize",					false,
			"mainComponent.measuresComponent", "measureTextOffsets",		false,
			"mainComponent.measuresComponent", "measureTextScale",			false,
			"mainComponent.measuresComponent", "measureTextColorHSVA",		false,
			"mainComponent.measuresComponent", "measureTextColorHSVA",		false,
			
			"mainComponent.statisticComponent", "enabled",		false,
			"mainComponent.statisticComponent", "colorHSVA",	false,
			"mainComponent.statisticComponent", "textScale",	false,
			"mainComponent.statisticComponent", "textOffsets",	false,
			"mainComponent.statisticComponent", "fontSize",		false,
		}
	end,
	
	save = function (self, path)
		local file = io.open(path, "w")
		
		file:write(self.header .. "\n\n")
		
		for i = 1, #self.properties, 3 do
			local tableName = self.properties[i]
			local key = self.properties[i+1]
			local useSetter = self.properties[i+2]
			file:write(self:encodeVariable(tableName, key, useSetter))
		end
		
		for i, track in ipairs(player:getSong():getTracks()) do
			local tableName = "player:getSong():getTracks()".."["..i.."]"
			file:write(self:encodeVariable(tableName, "priority", false))
			file:write(self:encodeVariable(tableName, "enabled", false))
			file:write(self:encodeVariable(tableName, "customColorHSV", false))
			file:write(self:encodeVariable(tableName, "isDiamond", false))
		end
		
		file:close()
	end,
	
	load = function (self, path)
		local file = io.open(path, "r")
		
		if file:read("*line") == self.header then		
			loadstring( file:read("*a") )()
			player:getSong():sortTracks()
		else
			love.window.showMessageBox( "Error", "Invalid properties savefile.", "error" )
		end
		
		file:close()
	end,
	
	addConditionChecking = function (self, str, tableName)
		return "if " .. tableName .. " then " .. str .. " end"
	end,
	
	encodeVariable = function (self, tableName, key, useSetter)
		local value = loadstring("return " .. tableName)()[key]
		local encodedCode
		
		if type(value) == "table" then
			local str = ""
			for k,v in pairs(value) do
				str = str .. self:encodeVariable(tableName.."."..key, k, false)
			end
			
			encodedCode = str
			
		else
			if useSetter then
				if type(key) == "string" then
					local capitalizedKey = string.gsub(" " .. key, "%W%l", string.upper):sub(2)
					
					encodedCode = tableName .. ":set" .. capitalizedKey .. "(" .. tostring(value) .. ")"
				else
					error("Key type" .. " \"" .. type(key) .. "\" does not support setter.")
				end
			else
				if type(key) == "string" then
					encodedCode = tableName .. "." .. key .. " = " .. tostring(value)
				else
					encodedCode = tableName .. "[" .. key .. "] = " .. tostring(value)
				end
			end
		end
		
		return self:addConditionChecking(encodedCode, tableName) .. "\n"
	end,
}