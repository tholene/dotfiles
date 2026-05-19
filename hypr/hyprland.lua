require("lua.autostart")
require("lua.workspaces")
dofile(os.getenv("HOME") .. "/.config/hypr/lua/monitors.lua")
require("lua.windows")
require("lua.keybinds")
require("lua.style")

hl.config({
    input = {
        numlock_by_default = true,
        kb_layout = "us,sv",
    },
    misc = {
        mouse_move_enables_dpms = true,
        key_press_enables_dpms  = true,
    },
})
