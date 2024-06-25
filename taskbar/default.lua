local settings = require("taskbar.settings")
local colors = require("taskbar.colors")

-- Equivalent to the --default domain
sbar.default({
  updates = "when_shown",
  icon = {
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Bold"],
      size = 15.0,
    },
    color = colors.white,
    padding_left = settings.paddings,
    padding_right = settings.paddings,
    background = { image = { corner_radius = 9 } },
  },
  label = {
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Semibold"],
      size = 12.0,
    },
    color = colors.white,
    padding_left = settings.paddings,
    padding_right = settings.paddings,
  },
  background = {
    height = 28,
    corner_radius = 15,
    border_width = 0,
    border_color = colors.bg2,
    image = {
      corner_radius = 9,
      border_color = colors.grey,
      border_width = 0,
    },
  },
  popup = {
    background = {
      border_width = 0,
      corner_radius = 9,
      border_color = colors.popup.border,
      color = colors.with_alpha(colors.popup.bg, colors.transparency),
      shadow = { drawing = true },
    },
    blur_radius = 50,
  },
  padding_left = 8,
  padding_right = 8,
  scroll_texts = true,
})
