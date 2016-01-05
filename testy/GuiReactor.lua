-- GuiApp.lua

package.path = package.path..";../?.lua"

local ffi = require("ffi")
local bit = require("bit")
local bor = bit.bor
local band = bit.band

local kernel = require("kernel")
local X11Interactor = require("X11Interactor")


-- some global variables
local width = 640;
local height = 480;


-- mouse information
mouseX = 0;
mouseY = 0;
local isMouseDragging = false;

-- keyboard information
keyCode = nil;
keyChar = nil;


--[[
	This function is called by the Interactor whenever there
	are interesting events, such as mouse and keyboard.  This
	is the primary tie between the platform, and the rest
	of the application.
--]]
local function onKeyPress(activity)
	keyCode = activity.keycode;
	keyChar = activity.keychar;

	if keyPressed then
		keyPressed();
	end

	if keyTyped then
		keyTyped(keyChar)
	end
end

local function onKeyRelease(activity)
	keyCode = activity.keycode;
	if keyReleased then
		keyReleased();
	end
end

local function onMouseMove(activity)
		mouseX = activity.x;
		mouseY = activity.y;

		if isMouseDragging then
			if mouseDragged then
				mouseDragged()
			end
		else
			if mouseMoved then
				mouseMoved()
			end
		end
end

local function onButtonPress(activity)
		isMouseDragging = true;
		mouseButton = activity.button;
		mouseX = activity.x;
		mouseY = activity.y;
		if mousePressed then
			mousePressed()
		end
end

local function onButtonRelease(activity)
			isMouseDragging = false;
		mouseButton = activity.button;
		mouseX = activity.x;
		mouseY = activity.y;

		if mouseReleased then
			mouseReleased()
		end
end

local function onLoop(activity)
	if loop then
		loop()
	end
end

local driver = X11Interactor()

function size(awidth, aheight)
	width = awidth;
	height = aheight;

	local graphPort = driver:graphPort(awidth, aheight)

	return graphPort;
end

local exports = {
	size = size;
}

on("keypress", onKeyPress)
on("keyrelease", onKeyRelease)
on("buttonpress", onButtonPress)
on("buttonrelease", onButtonRelease)
on("mousemove", onMouseMove)
on("loop", onLoop)

spawn(driver.run, driver)

return exports
