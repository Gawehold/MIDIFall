-- Heper functions
math.clamp = function (x,a,b)
	return math.max(math.min(x,b),a)
end

math.round = function (x, n)	-- n is the step
	n = n or 1
	
	if x % n >= n / 2 then
		return x - (x % n) + n
	else
		return x - (x % n)
	end
end

function getDirectory(self)
	local path = love.filesystem.getSource()
	if string.find(path, "%.") then
		path = love.filesystem.getSourceBaseDirectory()
	end
	
	return path
end

-- Load global libraries
bit = require "bit"
ffi = require "ffi"
vivid = require "Libraries/vivid/vivid"
midi = require "luamidi"

ffi.cdef[[
char *malloc(size_t size);
void free(void *ptr);
char* openFileDialog(const char* dialogType, const char* fileType);
]]

clib = ffi.load(getDirectory().."/clib.dll")

function openFileDialog(dialogType, fileType)
	local path = ffi.string( clib.openFileDialog(dialogType, fileType) )
	
	if path ~= "" then
		local file
		if dialogType == "open" then
			file = io.open(path, "rb")
		elseif dialogType == "save" then
			file = io.open(path, "wb")
		else
			error("Incorrect dialog type.")
		end
		
		if file then
			file:close()
			
			if dialogType == "save" then
				os.remove(path)
			end
			
			return path
		else
			love.window.showMessageBox("Error", "Cannot load the file.\nIt may be caused by filepath with unicode characters.", "error")
			return ""
		end
	else
		return path
	end
end

-- local cstr = clib.openFileDialog("open", "*.*\0*.*")
-- local i = 0
-- while cstr[i] ~= 0 do
	-- print(string.format("%x", cstr[i]))
	-- i = i + 1
-- end
-- love.event.quit()

-- Define global variables
-- NULL = {}

-- Load scripts
require "Scripts/Class"
-- require "Scripts/Queue"
-- require "Scripts/Stack"

require "Scripts/MIDIEvent"
require "Scripts/TempoChange"
require "Scripts/TimeSignature"
require "Scripts/Note"
require "Scripts/Measure"
require "Scripts/PitchBend"
require "Scripts/MIDITrack"
require "Scripts/MIDISong"
require "Scripts/MIDIParser"

require "Scripts/Player"
require "Scripts/TimeManager"

require "Scripts/Visualization/DisplayComponent"
require "Scripts/Visualization/BackgroundComponent"
require "Scripts/Visualization/NotesComponent"
require "Scripts/Visualization/KeyboardComponent"
require "Scripts/Visualization/FallsComponent"
require "Scripts/Visualization/HitAnimationComponent"
require "Scripts/Visualization/MeasuresComponent"
require "Scripts/Visualization/StatisticComponent"
require "Scripts/Visualization/Sprite"
require "Scripts/Visualization/MainComponent"
require "Scripts/Visualization/DisplayComponentsRenderer"
require "Scripts/Visualization/ThemeManager"

require "Scripts/UI/UIObject"
require "Scripts/UI/UIPanel"
require "Scripts/UI/UIText"
require "Scripts/UI/UIButton"
require "Scripts/UI/UICheckbox"
require "Scripts/UI/UISlider"
require "Scripts/UI/UIRangeSlider"
require "Scripts/UI/UIInputBox"
require "Scripts/UI/UIDropdown"
require "Scripts/UI/UISliderSuite"
require "Scripts/UI/UIPalette"
require "Scripts/UI/UIColorBlock"
require "Scripts/UI/UIColorPicker"
require "Scripts/UI/UIColorPickerToggle"
require "Scripts/UI/SettingsMenu"
require "Scripts/UI/PlayerControl"
require "Scripts/UI/UIManager"

require "Scripts/PropertiesManager"
require "Scripts/UpdateManager"

local song = MIDIParser:parse(love.filesystem.read("Assets/empty.mid"))
-- local song = MIDIParser:parse(love.filesystem.read("Assets/indeterminateuniverse-wip.mid"))
-- local song = MIDIParser:parse(love.filesystem.read("Assets/tate_ed.mid"))
-- local song = MIDIParser:parse(love.filesystem.read("Assets/Omega_Five_-_The_Glacial_Fortress_-_ShinkoNetCavy.mid"))
-- local song = MIDIParser:parse(love.filesystem.read("Assets/DELTARUNE_-_Chapter_1_-_Lantern_-_ShinkoNetCavy.mid"))
-- local song = MIDIParser:parse(love.filesystem.read("Assets/Megalomachia2 - Track 6 - SUPER-REFLEX - ShinkoNetCavy.mid"))
-- local song = MIDIParser:parse(love.filesystem.read("Assets/Toumei Elegy [2d erin & Kanade].mid"))
-- local song = MIDIParser:parse(love.filesystem.read("Assets/Ultimate_Tetris_Remix.mid"))
-- local song = MIDIParser:parse(love.filesystem.read("Assets/進化系Colors.mid"))

displayComponentsRenderer = DisplayComponentsRenderer()
player = Player(song)
mainComponent = MainComponent(0,0,0,0)
updateManager = UpdateManager()
uiManager = UIManager()
propertiesManager = PropertiesManager()

function love.load(args)
end

function love.update(dt)
	mainComponent:update(dt)
	uiManager:update(dt)
	displayComponentsRenderer:update(dt, 
		player
	)
	
	updateManager:update(dt)
end

function love.draw()
	displayComponentsRenderer:draw(
		mainComponent
	)
	
	uiManager:draw()
	
	updateManager:draw()
	-- love.graphics.print(player:getCurrentPitchBendValueInTracks()[2],0,200)
	-- love.graphics.setColor(1,1,1,1)
	-- love.graphics.setFont(defaultFont)
	-- love.graphics.print(love.timer.getFPS() ,0,0 ,0, 2)
	-- love.graphics.print(player:getTimeManager():getTime(), 0,20, 0, 2)
	-- love.graphics.print(player:getSong():getTempoChanges()[player:getTimeManager().currentTempoChangeID]:getTempo(), 0,40, 0, 2)
	
	-- for k,v in ipairs(player.song.tracks) do
		-- love.graphics.print(tostring(player.firstNonPlayedNoteIDInTracks[k]), 0, 50+20*k,0,2)
	-- end
	
	-- love.graphics.print(tostring(player.firstNonStartedMeasureID),0,100)
	-- love.graphics.print(tostring(getDirectory()),0,100)
	
	-- love.graphics.print(tostring(player.timeManager.currentTempoChangeID), 200 ,200)
end

function love.quit()
	if displayComponentsRenderer:getIsExportingVideo() then
		displayComponentsRenderer:terminateVideoExport()
		return true
	end
	
	player:releaseMIDIPort()
	-- TODO: free memory allocated by ffi.C.malloc()
	
	love.filesystem.write(
		"config.ini",
		string.format("width = %d\nheight = %d", love.window.getMode())
	)
	
	return false
end

function love.mousepressed(mouseX, mouseY, button, istouch, presses)
	if displayComponentsRenderer:getIsExportingVideo() then
		return
	end
	
	uiManager:mousePressed(mouseX, mouseY, button, istouch, presses)
end

function love.mousereleased(mouseX, mouseY, istouch, presses)
	if displayComponentsRenderer:getIsExportingVideo() then
		return
	end
	
	uiManager:mouseReleased(mouseX, mouseY, istouch, presses)
end

function love.mousemoved(x, y, dx, dy, istouch)
	if displayComponentsRenderer:getIsExportingVideo() then
		return
	end
	
	uiManager:mouseMoved(x, y, dx, dy, istouch)
end

function love.wheelmoved(x, y)
	if displayComponentsRenderer:getIsExportingVideo() then
		return
	end
	
	uiManager:wheelMoved(x, y)
end

function love.keypressed(key)
	if displayComponentsRenderer:getIsExportingVideo() then
		return
	end
	
	uiManager:keyPressed(key)
	
	if key == "r" then
		displayComponentsRenderer:startToRender()
	elseif key == "m" then
		player:mute()
	end
end

function love.keyreleased(key)
	if displayComponentsRenderer:getIsExportingVideo() then
		return
	end
	
	uiManager:keyReleased(key)
end

function love.textinput(ch)
	if displayComponentsRenderer:getIsExportingVideo() then
		return
	end
	
	uiManager:textInput(ch)
end

function love.filedropped(file)
	uiManager:fileDropped(file)
end

function love.resize(w, h)
	uiManager:resize(w, h)
	mainComponent:resize(w, h)
end

function love.threaderror(thread, errorstr)
	print("Thread error!\n"..errorstr)
	-- thread:getError() will return the same error string now.
end