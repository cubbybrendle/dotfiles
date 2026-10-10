-- local log = hs.logger.new('init', 'debug')

App = {}

-- Settings

hs.window.animationDuration = 0

-- Key Combos

local mash = {"cmd", "alt"}
local supermash = {"cmd", "alt", "ctrl"}

-- Mappings of keys to Applications names

local app_keys = {
  b = "Firefox";
  t = "Ghostty";
  e = "Code";
  s = "Slack";
  f = "Finder";
}

-- Layouts

local mbpScreen = hs.screen.mainScreen():name()

local ok, config = pcall(require, "config")
local screenIds = {}
if ok and type(config) == "table" and type(config.screens) == "table" then
  screenIds = config.screens
else
  hs.printf("ERROR: could not load config.lua, falling back to screen order: %s", tostring(config))
end

local deskScreen = function(id, index)
  return (id and hs.screen.find(id)) or hs.screen.allScreens()[index]
end

local leftDeskScreen = function()
  return deskScreen(screenIds.left, 2)
end

local rightDeskScreen = function()
  return deskScreen(screenIds.right, 3)
end

local mobileLayout = {
  {"Firefox", nil, mbpScreen, hs.layout.maximized, nil, nil},
  {"Code", nil, mbpScreen, hs.layout.maximized, nil, nil},
  {"Joplin", nil, mbpScreen, hs.layout.maximized, nil, nil},
  {"Slack", nil, mbpScreen, hs.layout.maximized, nil, nil},
  {"Ghostty", nil, mbpScreen, hs.layout.maximized, nil, nil},
}

local deskLayout = {
  {"Firefox", nil, mbpScreen, hs.layout.maximized, nil, nil},
  {"Code", nil, leftDeskScreen,  hs.layout.maximized, nil, nil},
  {"Joplin", nil, rightDeskScreen, hs.layout.right50, nil, nil},
  {"Slack", nil, rightDeskScreen, hs.layout.right50, nil, nil},
  {"Ghostty", nil, rightDeskScreen, hs.layout.left50, nil, nil},
}

-- Watchers

App.screenwatcher = hs.screen.watcher.new(function()
    local numScreens = #hs.screen.allScreens()

    if numScreens == 1 then
      hs.layout.apply(mobileLayout)
    elseif numScreens == 3 then
      hs.layout.apply(deskLayout)
    end
  end
)
App.screenwatcher:start()

-- Bindings

hs.hotkey.bind(mash, "left", function()
    local win = hs.window.focusedWindow()
    local ws = westScreen(win)
    if isLeft(win) and ws then
      rightSide(win, ws)
    else
      leftSide(win)
    end
  end
)

hs.hotkey.bind(mash, "right", function()
    local win = hs.window.focusedWindow()
    local es = eastScreen(win)
    if isRight(win) and es then
      leftSide(win, es)
    else
      rightSide(win)
    end
  end
)

hs.hotkey.bind(supermash, "left", function()
    local win = hs.window.focusedWindow()
    local ws = westScreen(win)
    if ws then
      fullscreen(win, ws)
    end
  end
)

hs.hotkey.bind(supermash, "right", function()
    local win = hs.window.focusedWindow()
    local es = eastScreen(win)
    if es then
      fullscreen(win, es)
    end
  end
)

hs.hotkey.bind(mash, "f", function()
    local win = hs.window.focusedWindow()
    fullscreen(win)
  end
)

for k, v in pairs(app_keys) do
  hs.hotkey.bind(supermash, k, function()
      r = hs.application.launchOrFocus(v) or hs.application.find(v):activate()
    end
  )
end

-- Functions

-- push win to left half of frame
function leftSide(win, screen)
  if not screen then
    screen = win:screen()
  end
  local frame = screen:frame()
  frame.w = frame.w/2
  win:setFrame(frame)
  win:setFrame(frame)
end

-- push win to right half of frame
function rightSide(win, screen)
  if not screen then
    screen = win:screen()
  end
  local frame = screen:frame()
  frame.x = frame.x + frame.w/2
  frame.w = frame.w/2
  win:setFrame(frame)
  win:setFrame(frame)
end

-- make win fullscreen in frame
function fullscreen(win, screen)
  if not screen then
    screen = win:screen()
  end
  local frame = screen:frame()
  win:setFrame(frame)
  win:setFrame(frame)
end

-- bool, true if win is sized to left half
function isLeft(win)
  local f = win:frame()
  local sf = win:screen():frame()
  if f.x == sf.x and f.y == sf.y and f.w < (sf.w/2 + 50) then
    return true
  end
end

-- bool, true if win is sized to right half
function isRight(win)
  local f = win:frame()
  local sf = win:screen():frame()
  if f.x == sf.x + sf.w/2 and f.y == sf.y then
    return true
  end
end

-- bool, true if win is fullscreen
function isFull(win)
  local f = win:frame()
  local sf = win:screen():frame()
  if f.x == sf.x and f.y == sf.y and f.w >= (sf.w - 50) and f.h >= (sf.h - 50) then
    return true
  end
end

function westScreen(win)
  return win:screen():toWest()
end

function eastScreen(win)
  return win:screen():toEast()
end

------------------------------------------------------------
-- Handy dictation using Globe/Fn as push-to-talk
--
-- Fn down:
--   Start Handy
--
-- Fn up:
--   Stop Handy, unless another key was pressed while Fn was held
--
-- Fn + another key:
--   Cancel Handy and let the other key behave normally
------------------------------------------------------------

-- local handyToggleShortcut = {
--   modifiers = { "alt" },
--   key = "space",
-- }

-- local handyCancelShortcut = {
--   modifiers = {},
--   key = "escape",
-- }

-- local fnHeld = false
-- local fnUsedAsModifier = false
-- local handyStartedByFn = false

-- local function sendShortcut(shortcut)
--   hs.eventtap.keyStroke(
--     shortcut.modifiers,
--     shortcut.key,
--     0
--   )
-- end

-- ------------------------------------------------------------
-- -- Watch Fn/Globe state
-- ------------------------------------------------------------

-- App.fnWatcher = hs.eventtap.new(
--   { hs.eventtap.event.types.flagsChanged },
--   function(event)
--     local flags = event:getFlags()
--     local fnNowHeld = flags.fn == true

--     -- Fn was just pressed
--     if fnNowHeld and not fnHeld then
--       fnHeld = true
--       fnUsedAsModifier = false
--       handyStartedByFn = false

--       sendShortcut(handyToggleShortcut)
--       handyStartedByFn = true

--     -- Fn was just released
--     elseif not fnNowHeld and fnHeld then
--       fnHeld = false

--       if handyStartedByFn and not fnUsedAsModifier then
--         sendShortcut(handyToggleShortcut)
--         handyStartedByFn = false
--       end

--       fnUsedAsModifier = false
--     end

--     -- Never consume the Fn event.
--     return false
--   end
-- )

-- ------------------------------------------------------------
-- -- Detect another key while Fn is held
-- ------------------------------------------------------------

-- App.keyWatcher = hs.eventtap.new(
--   {
--     hs.eventtap.event.types.keyDown,
--     hs.eventtap.event.types.systemDefined,
--   },
--   function(event)
--     local eventType = event:getType()

--     if not fnHeld or fnUsedAsModifier then
--       return false
--     end

--     if eventType == hs.eventtap.event.types.keyDown then
--       local keyCode = event:getKeyCode()
--       local flags = event:getFlags()

--       -- Ignore Handy's synthetic Option-Space shortcut.
--       -- macOS keycode 49 = Space.
--       if keyCode == 53 then
--         return false
--       end

--       if keyCode == 179 then
--         return false
--       end

--       if keyCode == 49 and flags.alt then
--         return false
--       end
--     end

--     fnUsedAsModifier = true

--     if handyStartedByFn then
--         sendShortcut(handyCancelShortcut)
--         handyStartedByFn = false
--     end

--     -- Return false so the key still reaches macOS.
--     return false
--   end
-- )

-- App.fnWatcher:start()
-- App.keyWatcher:start()
