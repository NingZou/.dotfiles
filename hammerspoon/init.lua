-- ************************************************************
-- Windows Management
-- ************************************************************

hs.window.animationDuration = 0

local centerCoordinate =      {x = 0.1, y = 0,    w = 0.8,  h = 1}
local maximizedCoordinate =   {x = 0,   y = 0,    w = 1,    h = 1}
local topHalfCoordinate =     {x = 0,   y = 0,    w = 1,    h = 0.5}
local bottomHalfCoordinate =  {x = 0,   y = 0.5,  w = 1,    h = 0.5}

local function adjustFrame(coordinate)
  hs.window.focusedWindow():moveToUnit(coordinate)
end

local function toNextScreen()
  local win = hs.window.focusedWindow()
  local nextScreen = win:screen():next()
  win:moveToScreen(nextScreen)
end

local function toPreviousScreen()
  local win = hs.window.focusedWindow()
  local nextScreen = win:screen():previous()
  win:moveToScreen(nextScreen)
end

hs.hotkey.bind({"alt"}, "u", function() adjustFrame(centerCoordinate) end)
hs.hotkey.bind({"alt"}, "o", function() adjustFrame(maximizedCoordinate) end)

hs.hotkey.bind({"alt"}, "i", function() adjustFrame(topHalfCoordinate) end)
hs.hotkey.bind({"alt"}, "k", function() adjustFrame(bottomHalfCoordinate) end)

hs.hotkey.bind({"alt"}, "l", toNextScreen)
hs.hotkey.bind({"alt"}, "j", toPreviousScreen)

-- ************************************************************
-- Application Shortcuts (use name in applications folder)
-- ************************************************************

shortcuts = {
  -- c       =   "Google Chrome Canary",
  c       =   "Google Chrome",
  -- a       =   "IntelliJ IDEA",
  s       =   "PyCharm Community",
  v       =   "Postman",
  e       =   "iTerm",
  -- r       =   "Royal TSX",
  r       =   "Postico",
  ["`"]   =   "Finder",
  -- ["1"]   =   "Atom",
  ["1"]   =   "Visual Studio Code",
  ["2"]   =   "Typora",
  ["3"]   =   "Notion",
  ['4']   =   "Slack",
  ['5']   =   "Royal TSX",
  ['6']   =   "Microsoft Outlook"
}

for shortcut, app in pairs(shortcuts) do
  hs.hotkey.bind({"alt"}, shortcut, function() hs.application.launchOrFocus(app) end)
end

-- ************************************************************
-- Scripts
-- ************************************************************
local function setAwsCredentials()
  hs.execute("echo \"$(pbpaste)\" > ~/.aws/credentials")

  hs.notify.new({title="Hammerspoon", informativeText="AWS credentials is updated"}):send()
end

hs.hotkey.bind({"alt"}, "8", setAwsCredentials)

-- ************************************************************
-- URL handlers
-- ************************************************************
-- ➜  Chrome  defaults read com.google.Chrome ExternalProtocolDialogShowAlwaysOpenCheckbox
-- 2020-02-05 09:19:29.451 defaults[87394:6359726]
-- The domain/default pair of (com.google.Chrome, ExternalProtocolDialogShowAlwaysOpenCheckbox) does not exist
-- ➜  Chrome defaults write com.google.Chrome ExternalProtocolDialogShowAlwaysOpenCheckbox -bool true

-- ➜  Chrome defaults read com.google.Chrome ExternalProtocolDialogShowAlwaysOpenCheckbox
-- 1
-- Restart Chrome
hs.urlevent.bind("update_aws", setAwsCredentials)

-- ************************************************************
-- auto layout
-- ************************************************************
-- get name by
--   for index,value in pairs(hs.screen.allScreens()) do print(value:name() .. " - " .. value:id()) end

-- office
local macScreenHint    = "Color LCD"
local middleScreenHint = 722488782
local eastScreenHint   = 722478799
-- home
local upperScreenHint = "DELL U2412M"
local lowerScreenHint = "HP 2011"

-- get application name by
--   for key,value in pairs(hs.application.runningApplications()) do print(key,value) end

local defaultLayout = {
  {"Code",              macScreenHint,   centerCoordinate},
  {"iTerm2",            macScreenHint,   centerCoordinate},
  {"Notion",            macScreenHint,   centerCoordinate},
  {"Postman",           macScreenHint,   centerCoordinate},
  {"Slack",             macScreenHint,   centerCoordinate},
  {"Trello",            macScreenHint,   centerCoordinate},
  {"Typora",            macScreenHint,   centerCoordinate},

  {"Google Chrome",     macScreenHint,   maximizedCoordinate},
  {"IntelliJ IDEA",     macScreenHint,   maximizedCoordinate},
  {"Microsoft Outlook", macScreenHint,   maximizedCoordinate},
  {"RubyMine",          macScreenHint,   maximizedCoordinate}
}

local officeLayout = {
  {"Code",              macScreenHint,    centerCoordinate},
  {"iTerm2",            macScreenHint,    centerCoordinate},
  {"Trello",            macScreenHint,    centerCoordinate},
  {"Typora",            macScreenHint,    centerCoordinate},

  {"Google Chrome",     middleScreenHint, maximizedCoordinate},
  {"IntelliJ IDEA",     middleScreenHint, maximizedCoordinate},
  {"RubyMine",          middleScreenHint, maximizedCoordinate},

  {"Microsoft Outlook", eastScreenHint,   topHalfCoordinate},
  {"Notion",            eastScreenHint,   maximizedCoordinate},
  {"Postman",           eastScreenHint,   maximizedCoordinate},
  {"Slack",             eastScreenHint,   bottomHalfCoordinate}
}

local homeLayout = {
  {"Google Chrome",     upperScreenHint,  maximizedCoordinate},
  {"IntelliJ IDEA",     upperScreenHint,  maximizedCoordinate},
  {"RubyMine",          upperScreenHint,  maximizedCoordinate},

  {"Code",              lowerScreenHint,  maximizedCoordinate},
  {"iTerm2",            lowerScreenHint,  maximizedCoordinate},
  {"Microsoft Outlook", lowerScreenHint,  maximizedCoordinate},
  {"Notion",            lowerScreenHint,  maximizedCoordinate},
  {"Postman",           lowerScreenHint,  maximizedCoordinate},
  {"Slack",             lowerScreenHint,  maximizedCoordinate},
  {"Trello",            lowerScreenHint,  maximizedCoordinate},
  {"Typora",            lowerScreenHint,  maximizedCoordinate}
}

local function applyLayout(layout)
  transformedLayout = {}

  for key,value in pairs(layout) do
    table.insert(transformedLayout, {value[1], nil, hs.screen.find(value[2]), value[3], nil, nil})
  end

  hs.layout.apply(transformedLayout)
end

local function reformatLayout()
  currentNumberOfScreens = #hs.screen.allScreens()

  if currentNumberOfScreens == 3 then
    applyLayout(officeLayout)
  elseif currentNumberOfScreens == 2 then
    applyLayout(homeLayout)
  else
    applyLayout(defaultLayout)
  end
end

hs.hotkey.bind({"alt"}, "0", reformatLayout)

-- ************************************************************
-- screen watcher to set layouts automatically
-- ************************************************************
local lastNumberOfScreens = #hs.screen.allScreens()

function screenChangedCallback()
    currentNumberOfScreens = #hs.screen.allScreens()

    if currentNumberOfScreens ~= lastNumberOfScreens then
      reformatLayout()

      lastNumberOfScreens = currentNumberOfScreens
    end
end

-- http://www.hammerspoon.org/go/#variablelife
-- use a global variable to keep watchers out of being GCed
screenWatcher = hs.screen.watcher.new(screenChangedCallback):start()

-- ************************************************************
-- wifi watcher to mute audio when it is not a home environment
-- ************************************************************
local homeSSIDs = {"404fi", "404fi_5G"}
local lastSSID = hs.wifi.currentNetwork()

function inTable(tbl, item)
    for key, value in pairs(tbl) do
        if value == item then
          return true
        end
    end

    return false
end

function ssidChangedCallback()
    newSSID = hs.wifi.currentNetwork()
    device = hs.audiodevice.defaultOutputDevice()

    if newSSID ~= lastSSID then
      -- os.execute("sleep " .. tonumber(2))
      -- hs.notify.new({title="Hammerspoon", informativeText="Debug:no the same SSID"}):send()

      if inTable(homeSSIDs, newSSID) then
        if device:muted() then
          device:setMuted(false)
        end
        -- hs.audiodevice.defaultOutputDevice():setMuted(false)

        if device:volume() == 0 then
          device:setVolume(25)
        end
      else
        -- hs.notify.new({title="Hammerspoon", informativeText="Mute audio since this is not a home wifi"}):send()

        if device:muted() then
          device:setMuted(false)
        end
        device:setVolume(0)
        -- hs.audiodevice.defaultOutputDevice():setMuted(false)
        -- hs.audiodevice.defaultOutputDevice():setVolume(0)
      end

      lastSSID = newSSID
    end
end

wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback):start()


-- function keyStrokes(str)
--   return function()
--       hs.eventtap.keyStrokes(str)
--   end
-- end
-- hs.hotkey.bind({"ctrl", "alt", "cmd"}, "L", keyStrokes("console.log("))

-- function chrome_active_tab_with_name(name)
--   return function()
--       hs.osascript.javascript([[
--           // below is javascript code
--           var chrome = Application('Google Chrome');
--           chrome.activate();
--           var wins = chrome.windows;

--           // loop tabs to find a web page with a title of <name>
--           function main() {
--               for (var i = 0; i < wins.length; i++) {
--                   var win = wins.at(i);
--                   var tabs = win.tabs;
--                   for (var j = 0; j < tabs.length; j++) {
--                   var tab = tabs.at(j);
--                   tab.title(); j;
--                   if (tab.title().indexOf(']] .. name .. [[') > -1) {
--                           win.activeTabIndex = j + 1;
--                           return;
--                       }
--                   }
--               }
--           }
--           main();
--           // end of javascript
--       ]])
--   end
-- end

-- --- Use
-- hs.hotkey.bind({"alt"}, "H", chrome_active_tab_with_name("HipChat"))
