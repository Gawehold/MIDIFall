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

-- Load global libraries
bit = require "bit"
ffi = require "ffi"
vivid = require "Libraries/vivid/vivid"
midi = require "luamidi"
tick = require "Libraries/tick/tick"

ffi.cdef[[
char *malloc(size_t size);
void free(void *ptr);
char* openFileDialog();
]]

clib = ffi.load(love.filesystem.getSource().."/Scripts/openFileDialog.dll")

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

-- local song = MIDIParser:parse(love.filesystem.read("Assets/debug.mid"))
-- local song = MIDIParser:parse(love.filesystem.read("Assets/indeterminateuniverse-wip.mid"))
-- local song = MIDIParser:parse(love.filesystem.read("Assets/tate_ed.mid"))
-- local song = MIDIParser:parse(love.filesystem.read("Assets/Omega_Five_-_The_Glacial_Fortress_-_ShinkoNetCavy.mid"))
-- local song = MIDIParser:parse(love.filesystem.read("Assets/DELTARUNE_-_Chapter_1_-_Lantern_-_ShinkoNetCavy.mid"))
local song = MIDIParser:parse(love.filesystem.read("Assets/Megalomachia2 - Track 6 - SUPER-REFLEX - ShinkoNetCavy.mid"))
-- local song = MIDIParser:parse(love.filesystem.read("Assets/Toumei Elegy [2d erin & Kanade].mid"))
-- local song = MIDIParser:parse(love.filesystem.read("Assets/Ultimate_Tetris_Remix.mid"))
-- local song = MIDIParser:parse(love.filesystem.read("Assets/進化系Colors.mid"))

player = Player(song)
mainComponent = MainComponent(0,0,0,0)

local defaultFont = love.graphics.newFont()

local uiManager = UIManager()

displayComponentsRenderer = DisplayComponentsRenderer()

function love.load()
end

function love.update(dt)
	mainComponent:update(dt)
	uiManager:update(dt)
	displayComponentsRenderer:update(dt, 
		player
	)
end

function love.draw()
	displayComponentsRenderer:draw(
		mainComponent
	)
	
	uiManager:draw()
	
	-- love.graphics.setColor(1,1,1,1)
	-- love.graphics.setFont(defaultFont)
	-- love.graphics.print(love.timer.getFPS() ,0,0 ,0, 2)
	-- love.graphics.print(player:getTimeManager():getTime(), 0,20, 0, 2)
	-- love.graphics.print(player:getSong():getTempoChanges()[player:getTimeManager().currentTempoChangeID]:getTempo(), 0,40, 0, 2)
	
	-- for k,v in ipairs(player.song.tracks) do
		-- love.graphics.print(tostring(player.firstNonPlayedNoteIDInTracks[k]), 0, 50+20*k,0,2)
	-- end
	
	-- love.graphics.print(tostring(player.firstNonStartedMeasureID),0,100)
end

function love.quit()
	player:releaseMIDIPort()
	-- TODO: free memory allocated by ffi.C.malloc()
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
		displayComponentsRenderer:startToRender(1920, 1080, 60)
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
end

function love.threaderror(thread, errorstr)
	print("Thread error!\n"..errorstr)
	-- thread:getError() will return the same error string now.
end

function love.quit()
	if displayComponentsRenderer:getIsExportingVideo() then
		displayComponentsRenderer:terminateVideoExport()
		return true
	end
	
	return false
end