require("lua.animations.smooth")

hl.config({
    general = {
        gaps_in  = 8,
        gaps_out = 12,
        border_size = 1,
        layout = "dwindle",
        resize_on_border = true,

        col = {
            active_border   = "rgba(ffb59dee)",
            inactive_border = "rgba(261e1b99)",
        },
    },

    decoration = {
        rounding = 4,

        active_opacity   = 1,
        inactive_opacity = 0.75,

        shadow = {
            enabled      = true,
            range        = 20,
            render_power = 4,
            color        = "rgba(00000055)",
        },

        blur = {
            enabled           = true,
            size              = 8,
            passes            = 3,
            new_optimizations = true,
        },
    },

    dwindle = {
        preserve_split = true,
    },
})
