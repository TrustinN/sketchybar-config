return {
    black = 0xff45475a,
    white = 0xffbac2de,
    red = 0xfff38ba8,
    green = 0xffa6e3a1,
    blue = 0xff89b4fa,
    yellow = 0xfff9e2af,
    orange = 0xfff39660,
    magenta = 0xfff5c2e7,
    grey = 0xff585b70,
    transparent = 0x00000000,

    bar = {
        bg = 0x00000000,
        border = 0xff2c2e34,
    },
    popup = {
        bg = 0xff000000,
        border = 0xffb4befe
    },
    -- bg1 = 0xff1e1e2e,
    -- bg2 = 0xff1e1e2e,
    bg1 = 0xff000000,
    bg2 = 0xff000000,

    with_alpha = function(color, alpha)
        if alpha > 1.0 or alpha < 0.0 then return color end
        return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
    end,
    transparency = 0.5,
    active_border_color = 0xff666bff,
}
