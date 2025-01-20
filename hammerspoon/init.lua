-- local log = hs.logger.new('init', 'debug')

-- Settings

hs.window.animationDuration = 0

-- Key Combos

local mash = {"cmd", "alt"}
local supermash = {"cmd", "alt", "ctrl"}

-- Mappings of keys to Applications names

local app_keys = {
  b = "Google Chrome";
  t = "iTerm2";
  e = "Sublime Text";
  s = "Slack";
  p = "Postman";
  f = "Finder";
}

-- Layouts

local mbpScreen = "Color LCD"

local leftDeskScreen = function()
  return hs.screen.allScreens()[2]
end

local rightDeskScreen = function()
  return hs.screen.allScreens()[3]
end

local mobileLayout = {
  {"Google Chrome", nil, mbpScreen, hs.layout.maximized, nil, nil},
  {"Firefox", nil, mbpScreen, hs.layout.maximized, nil, nil},
  {"FirefoxDeveloperEdition", nil, mbpScreen, hs.layout.maximized, nil, nil},
  {"Sublime Text", nil, mbpScreen, hs.layout.maximized, nil, nil},
  {"Joplin", nil, mbpScreen, hs.layout.maximized, nil, nil},
  {"Slack", nil, mbpScreen, hs.layout.maximized, nil, nil},
  {"iTerm", nil, mbpScreen, hs.layout.maximized, nil, nil},
}

local deskLayout = {
  {"Google Chrome", nil, mbpScreen, hs.layout.maximized, nil, nil},
  {"Firefox", nil, mbpScreen, hs.layout.maximized, nil, nil},
  {"FirefoxDeveloperEdition", nil, mbpScreen, hs.layout.maximized, nil, nil},
  {"Sublime Text", nil, leftDeskScreen,  hs.layout.left50, nil, nil},
  {"Joplin", nil, rightDeskScreen, hs.layout.right50, nil, nil},
  {"Slack", nil, rightDeskScreen, hs.layout.right50, nil, nil},
  {"iTerm", nil, rightDeskScreen, hs.layout.left50, nil, nil},
}

-- Watchers

hs.screen.watcher.new(function()
    local numScreens = #hs.screen.allScreens()

    if numScreens == 1 then
      hs.layout.apply(mobileLayout)
    elseif numScreens == 3 then
      hs.layout.apply(deskLayout)
    end
  end
):start()

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
