local settings = require("taskbar.settings")
local colors = require("taskbar.colors")

-- Padding item required because of bracket
sbar.add("item", { position = "right", width = settings.group_paddings })

local calAnchor = sbar.add("item", {
  width = 0,
  icon = {
    color = colors.white,
    padding_right = 4,
    padding_left = 8,
    font = {
      style = settings.font.style_map["Semibold"],
      size = 12.0,
    },
  },
  label = {
    color = colors.white,
    padding_right = 8,
    padding_left = 4,
    align = "right",
    font = { family = settings.font.numbers },
  },
  position = "right",
  update_freq = 30,
  padding_left = 1,
  padding_right = 1,
  background = {
    color = colors.with_alpha(colors.bg2, colors.transparency),
    border_color = colors.blue,
  },
  popup = {
    align = "left",
    height = 10,
    y_offset = 0,
  },
})

local cal = sbar.add("item", {
  icon = {
    color = colors.white,
    padding_right = 4,
    padding_left = 8,
    font = {
      style = settings.font.style_map["Semibold"],
      size = 12.0,
    },
  },
  label = {
    color = colors.white,
    padding_right = 8,
    padding_left = 4,
    align = "right",
    font = { family = settings.font.numbers },
  },
  position = "right",
  update_freq = 30,
  padding_left = 1,
  padding_right = 1,
  background = {
    color = colors.with_alpha(colors.bg2, colors.transparency),
    border_color = colors.blue,
  },
  popup = {
    align = "left",
    height = 10,
    y_offset = 10,
    horizontal = true,
    background = { color = colors.transparent },
  },
})

-- -- Double border for calendar using a single item bracket
-- sbar.add("bracket", { cal.name }, {
--   background = {
--     color = colors.transparent,
--     height = 30,
--     border_color = colors.grey,
--   }
-- })


local monthToggleLeft = sbar.add("item", {
    position = "popup." .. cal.name,
    padding_right = 0,
    label = { string = "", font = "Hack Nerd Font:Bold:11.0" },
})

local monthToggleSpaces = sbar.add("item", {
    position = "popup." .. cal.name,
    padding_right = 0,
    padding_left = 0,
    label = { string = "", font = "Hack Nerd Font:Bold:11.0" },
})

local monthToggleRight = sbar.add("item", {
    position = "popup." .. cal.name,
    padding_left = 0,
    padding_right = 10,
    label = { string = "", font = "Hack Nerd Font:Bold:11.0" },
})

-- # -------- Globals -------- # -- 
local calPopups = {}
local currMonth
local currYear
local function resetCalendar() currMonth = tonumber(os.date("%m")) currYear = tonumber(os.date("%Y")) end
resetCalendar()
local popupOpen = false

for i = 1, 12 do
    calPopups[i] = sbar.add("item", {
        position = "popup." .. calAnchor.name,
        label = {
            string = " ",
            padding_right = 4,
            padding_left = 4,
            align = "right",
            font = "Hack Nerd Font:Bold:11.0",
        },
        width = 158,
        background = {
            padding_left = 0,
            padding_right = 0,
        },
        drawing = true,
    })

end

local setData = function(itm, text, visible)
    itm:set({ label = text, drawing = visible })

end

local function loadCalendar(month, year)
    local count = 1
    local day = tostring(os.date("%d"))

    for lines in io.popen("cal " .. tostring(month) .. " " .. tostring(year)):lines() do
        lines = (" " .. lines):sub(1, -2)
        count = count + 1
        if count == 3 then
            count = 4
        end

        if string.find(lines, "%s" .. day .. "%s") then
            lines = string.gsub(lines, "%s" .. day .. "%s", "⌈" .. day .. "⌋")
        end

        lines = string.gsub(lines, "%s", " ")
        setData(calPopups[count], lines, true)
    end

    if count + 1 <= #calPopups then
        setData(calPopups[count + 1], " ", true)
    end

    for i = count + 2, #calPopups do
        setData(calPopups[i], "", false)
    end

end


-- Padding item required because of bracket
sbar.add("item", { position = "right", width = settings.group_paddings })

cal:subscribe("mouse.clicked", function(env)
    popupOpen = not popupOpen
    resetCalendar()
    loadCalendar(currMonth, currYear)
    calAnchor:set({ popup = { drawing = popupOpen } })
    monthToggleSpaces:set({ label = { string = string.rep("_", #calPopups[2]:query().label.value - 3) } })
    cal:set({ popup = { drawing = popupOpen } })
end)

cal:subscribe({ "forced", "routine", "system_woke" }, function(env)
  local date = os.date("%a %d %b %I:%M %p")
  cal:set({ icon = "􀧞", label = date })
  calAnchor:set({ icon = "􀧞", label = date })
  resetCalendar()
  loadCalendar(currMonth, currYear)
end)

monthToggleLeft:subscribe("mouse.clicked", function(env)
    if currMonth == 1 then
        currMonth = 12
        currYear = currYear - 1
    else
        currMonth = currMonth - 1
    end
    loadCalendar(currMonth, currYear)
end)

monthToggleRight:subscribe("mouse.clicked", function(env)
    if currMonth == 12 then
        currYear = currYear + 1
        currMonth = 1
    else
        currMonth = currMonth + 1
    end
    loadCalendar(currMonth, currYear)
end)
