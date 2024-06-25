local settings = require("taskbar.settings")
local colors = require("taskbar.colors")

-- Padding item required because of bracket
sbar.add("item", { position = "right", width = settings.group_paddings })

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
})

-- -- Double border for calendar using a single item bracket
-- sbar.add("bracket", { cal.name }, {
--   background = {
--     color = colors.transparent,
--     height = 30,
--     border_color = colors.grey,
--   }
-- })

-- Padding item required because of bracket
sbar.add("item", { position = "right", width = settings.group_paddings })

cal:subscribe({ "forced", "routine", "system_woke" }, function(env)
  cal:set({ icon = "􀧞", label = os.date("%a %d %b %I:%M %p") })
end)
