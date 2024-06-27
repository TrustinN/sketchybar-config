local colors = require("taskbar.colors")
local icons = require("taskbar.icons")
local settings = require("taskbar.settings")

local menu_watcher = sbar.add("item", {
  drawing = false,
  updates = false,
})
local space_menu_swap = sbar.add("item", {
  drawing = false,
  updates = true,
})
sbar.add("event", "swap_menus_and_spaces")

local max_items = 15
local menu_items = {}
for i = 1, max_items, 1 do
  local menu = sbar.add("item", "menu." .. i, {
    padding_left = 5,
    padding_right = 5,
    drawing = false,
    icon = { drawing = false },
    label = {
      font = {
        -- style = settings.font.style_map[i == 1 and "Heavy" or "Semibold"]
        style = "bold",
      },
      padding_left = 6,
      padding_right = 6,
    },
    background = {
      color = colors.with_alpha(colors.bg1, 0.0),
      border_color = colors.with_alpha(colors.bg1, 0.0),
    },
    click_script = "$CONFIG_DIR/taskbar/helpers/menus/bin/menus -s " .. i,
  })

  menu_items[i] = menu
end

sbar.add("bracket", { '/menu\\..*/' }, {
  background = {
    color = colors.with_alpha(colors.bg1, colors.transparency),
    border_color = colors.with_alpha(colors.white, colors.transparency),
  },
})

local menu_padding = sbar.add("item", "menu.padding", {
  drawing = false,
  width = 5
})

local function update_menus(env)
  sbar.exec("$CONFIG_DIR/taskbar/helpers/menus/bin/menus -l", function(menus)
    sbar.set('/menu\\..*/', { drawing = false })
    menu_padding:set({ drawing = true })
    id = 1
    for menu in string.gmatch(menus, '[^\r\n]+') do
      if id < max_items then
        menu_items[id]:set({ label = menu, drawing = true,
          background = {
            color = colors.with_alpha(colors.bg1, 0.0),
            border_color = colors.with_alpha(colors.bg1, 0.0),
          },

        })
      else break end
      id = id + 1
    end
  end)
end

menu_watcher:subscribe("front_app_switched", update_menus)

space_menu_swap:subscribe("swap_menus_and_spaces", function(env)
  local drawing = menu_items[1]:query().geometry.drawing == "on"
  if drawing then
    menu_watcher:set( { updates = false })
    sbar.set("/menu\\..*/", { drawing = false })
    sbar.set("/space\\..*/", { drawing = true })
    sbar.set("front_app", { drawing = true })
  else
    menu_watcher:set( { updates = true })
    sbar.set("/space\\..*/", { drawing = false })
    sbar.set("front_app", { drawing = false })
    update_menus()
  end
end)

return menu_watcher
