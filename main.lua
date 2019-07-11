-- Heper functions
math.clamp = function (x,a,b)
	return math.max(math.min(x,b),a)
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
]]

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

require "Scripts/DisplayComponent"
require "Scripts/BackgroundComponent"
require "Scripts/NotesComponent"
require "Scripts/KeyboardComponent"
require "Scripts/FallsComponent"
require "Scripts/HitAnimationComponent"
require "Scripts/MeasuresComponent"
require "Scripts/DefaultTheme"

require "Scripts/UI/UIObject"
require "Scripts/UI/UIPanel"
require "Scripts/UI/UIButton"
require "Scripts/UI/UICheckbox"
require "Scripts/UI/UISlider"
require "Scripts/UI/UIInputBox"
-- require "Scripts/UI/UIDropdown"
require "Scripts/UI/SettingsMenu"
require "Scripts/UI/PlayerControl"
require "Scripts/UI/UIManager"

-- local song = MIDIParser:parse(love.filesystem.read("Assets/debug.mid"))
-- local song = MIDIParser:parse(love.filesystem.read("Assets/indeterminateuniverse-wip.mid"))
-- local song = MIDIParser:parse(love.filesystem.read("Assets/tate_ed.mid"))
local song = MIDIParser:parse(love.filesystem.read("Assets/Omega_Five_-_The_Glacial_Fortress_-_ShinkoNetCavy.mid"))
-- local song = MIDIParser:parse(love.filesystem.read("Assets/DELTARUNE_-_Chapter_1_-_Lantern_-_ShinkoNetCavy.mid"))
-- local song = MIDIParser:parse(love.filesystem.read("Assets/Megalomachia2 - Track 6 - SUPER-REFLEX - ShinkoNetCavy.mid"))
-- local song = MIDIParser:parse(love.filesystem.read("Assets/Toumei Elegy [2d erin & Kanade].mid"))
-- local song = MIDIParser:parse(love.filesystem.read("Assets/U2.mid"))

player = Player(song)
defaultTheme = DefaultTheme(0,0,0,0)

local defaultFont = love.graphics.newFont()

local uiManager = UIManager()

function love.load()
	-- table.foreach(midi.enumerateinports(), print)
	-- print( 'Receiving on device: ', luamidi.getInPortName(0))
	-- local port = midi.openout(0)
	-- port:sendMessage(0x90, 52, 127)
	-- port:noteOn(60,127, 0)
	-- port:noteOff(60,5, 0)
	
	midi.sendMessage(0,0,0,0)	-- for activate the midi device, it takes a little bit time, if we don't do this, the playback of first MIDI event will be flicked
end

function love.update(dt)
	defaultTheme:update(dt)
	-- settingsMenu:update(dt)
	uiManager:update(dt)
	player:update(dt)
end

function love.draw()
	defaultTheme:draw()
	-- settingsMenu:draw()
	uiManager:draw()
	
	love.graphics.setColor(1,1,1,1)
	love.graphics.setFont(defaultFont)
	love.graphics.print(love.timer.getFPS() ,0,0 ,0, 2)
	love.graphics.print(player:getTimeManager():getTime(), 0,20, 0, 2)
	love.graphics.print(player:getSong():getTempoChanges()[player:getTimeManager().currentTempoChangeID]:getTempo(), 0,40, 0, 2)
	
	for k,v in ipairs(player.song.tracks) do
		love.graphics.print(tostring(player.firstNonPlayedNoteIDInTracks[k]), 0, 50+20*k,0,2)
	end
end

function love.quit()
	midi.gc()
	-- TODO: free memory allocated by ffi.C.malloc()
end

function love.mousepressed(mouseX, mouseY, button, istouch, presses)
	uiManager:mousePressed(mouseX, mouseY, button, istouch, presses)
	-- settingsMenu:mousePressed(mouseX, mouseY, button, istouch, presses)
end

function love.mousereleased(mouseX, mouseY, istouch, presses)
	uiManager:mouseReleased(mouseX, mouseY, istouch, presses)
end

function love.mousemoved(x, y, dx, dy, istouch)
	uiManager:mouseMoved(x, y, dx, dy, istouch)
end

function love.wheelmoved(x, y)
	uiManager:wheelMoved(x, y)
end

function love.keypressed(key)
	uiManager:keyPressed(key)
end

function love.keyreleased(key)
	uiManager:keyReleased(key)
end

function love.textinput(ch)
	uiManager:textInput(ch)
end

function love.filedropped(file)
	
	-- if extension == ".mid" then
		-- if file:open("r") then
			-- mute()
			-- showLoadingScreen()
			-- project.smf = readSmf(file:read(file:getSize()))
			-- song = MIDIParser:parse(love.filesystem.read("Assets/tate_ed.mid"))
		-- end
	-- end
end