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
  {"Sublime Text",  nil, mbpScreen, hs.layout.maximized, nil, nil},
  {"Evernote",      nil, mbpScreen, hs.layout.maximized, nil, nil},
  {"Slack",         nil, mbpScreen, hs.layout.maximized, nil, nil},
  {"iTerm2",        nil, mbpScreen, hs.layout.maximized, nil, nil},
}

local deskLayout = {
  {"Google Chrome", nil, mbpScreen,       hs.layout.maximized, nil, nil},
  {"Sublime Text",  nil, leftDeskScreen,  hs.layout.left50,    nil, nil},
  {"Evernote",      nil, rightDeskScreen, hs.layout.right50,   nil, nil},
  {"Slack",         nil, rightDeskScreen, hs.layout.right50,   nil, nil},
  {"iTerm2",        nil, rightDeskScreen, hs.layout.left50,    nil, nil},
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
    if isLeft(win) and westWindow(win) then
      rightSide(win, westFrame(win))
    else
      leftSide(win)
    end
  end
)

hs.hotkey.bind(mash, "right", function()
    local win = hs.window.focusedWindow()
    if isRight(win) and eastWindow(win) then
      leftSide(win, eastFrame(win))
    else
      rightSide(win)
    end
  end
)

hs.hotkey.bind(supermash, "left", function()
    local win = hs.window.focusedWindow()
    if westWindow(win) then
      local wf = westFrame(win)
      if isFull(win) then
        fullscreen(win, wf)
      else
        rightSide(win, wf)
      end
    end
  end
)

hs.hotkey.bind(supermash, "right", function()
    local win = hs.window.focusedWindow()
    if eastWindow(win) then
      local ef = eastFrame(win)
      if isFull(win) then
        fullscreen(win, ef)
      else
        leftSide(win, ef)
      end
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
function leftSide(win, frame)
  if not frame then
    frame = win:screen():frame()
  end
  frame.w = frame.w/2
  win:setFrame(frame)
end

-- push win to right half of frame
function rightSide(win, frame)
  if not frame then
    frame = win:screen():frame()
  end
  frame.x = frame.x + frame.w/2
  frame.w = frame.w/2
  win:setFrame(frame)
end

-- make win fullscreen in frame
function fullscreen(win, frame)
  if not frame then
    frame = win:screen():frame()
  end
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

function westWindow(win)
  return win:screen():toWest()
end

function eastWindow(win)
  return win:screen():toEast()
end

function westFrame(win)
  return westWindow(win):frame()
end

function eastFrame(win)
  return eastWindow(win):frame()
end
