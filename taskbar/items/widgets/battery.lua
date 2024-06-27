local icons = require("taskbar.icons")
local colors = require("taskbar.colors")
local settings = require("taskbar.settings")

local battery = sbar.add("item", "widgets.battery", {
  position = "right",
  icon = {
    padding_right = 4,
    font = {
      style = settings.font.style_map["Regular"],
      size = 19.0,
    }
  },
  label = {
      padding_left = 4,
      font = { family = settings.font.numbers }
  },
  update_freq = 180,
  popup = { align = "center", horizontal = true, }
})

local battery_bracket = sbar.add("bracket", "widgets.battery.bracket", { battery.name }, {
  background = {
    color = colors.with_alpha(colors.bg2, colors.transparency),
    border_color = colors.black,
  },
})

sbar.add("item", "widgets.battery.padding", {
  position = "right",
  width = settings.group_paddings
})

sbar.add("item", {
  position = "popup." .. battery.name,
  label = { string = "Time Remaining: ", font = { style = "bold" } }

})

local remaining_time = sbar.add("item", {
  position = "popup." .. battery.name,
  label = {
    string = "??:??h",
    align = "right",
    font = { style = "bold" }
  },
})


battery:subscribe({"routine", "power_source_change", "system_woke"}, function()
  sbar.exec("pmset -g batt", function(batt_info)
    local icon = "!"
    local label = "?"

    local found, _, charge = batt_info:find("(%d+)%%")
    if found then
      charge = tonumber(charge)
      label = charge .. "%"
    end

    local color = colors.green
    local charging, _, _ = batt_info:find("AC Power")

    if charging then
      icon = icons.battery.charging
    else
      if found and charge > 80 then
        icon = icons.battery._100
      elseif found and charge > 60 then
        icon = icons.battery._75
      elseif found and charge > 40 then
        icon = icons.battery._50
      elseif found and charge > 20 then
        icon = icons.battery._25
        color = colors.orange
      else
        icon = icons.battery._0
        color = colors.red
      end
    end

    battery:set({
      icon = {
        string = icon,
        color = color
      },
      label = { string = label },
    })

    battery_bracket:set({ background = { border_color = color } })
  end)
end)

battery:subscribe("mouse.entered", function(env)
  local drawing = battery:query().popup.drawing
  battery:set( { popup = { drawing = "toggle" } })

  if drawing == "off" then
    sbar.exec("pmset -g batt", function(batt_info)
      local found, _, remaining = batt_info:find(" (%d+:%d+) remaining")
      local label = found and remaining .. "h" or "No estimate"
      remaining_time:set( { label = label })
    end)
  end
end)

battery:subscribe("mouse.exited", function(_)
  battery:set({ popup = { drawing = false } })
end)

