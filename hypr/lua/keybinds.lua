local mod  = "SUPER"
local term = "kitty"
local home = os.getenv("HOME")

-- Core
hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd(term))
hl.bind(mod .. " + SPACE",  hl.dsp.exec_cmd("walker"))
hl.bind(mod .. " + Q",      hl.dsp.window.close())
hl.bind(mod .. " + SHIFT + F", hl.dsp.window.fullscreen())
hl.bind(mod .. " + F",      hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + B",      hl.dsp.exec_cmd("pkill waybar; waybar"))
hl.bind(mod .. " + E",      hl.dsp.exec_cmd("nautilus"))
hl.bind(mod .. " + C",      hl.dsp.exec_cmd("zen-browser"))

-- Focus (vim-style)
hl.bind(mod .. " + H", hl.dsp.focus({ direction = "left"  }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "down"  }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up"    }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" }))

-- Move windows (vim-style)
hl.bind(mod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left"  }))
hl.bind(mod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down"  }))
hl.bind(mod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up"    }))
hl.bind(mod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))

-- Workspaces: switch and move window
for i = 1, 9 do
    hl.bind(mod .. " + " .. i,             hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. i,     hl.dsp.window.move({ workspace = i }))
end

-- Monitor focus
hl.bind(mod .. " + comma",  hl.dsp.focus({ monitor = "-1" }))
hl.bind(mod .. " + period", hl.dsp.focus({ monitor = "+1" }))

-- Screenshot: region to clipboard
hl.bind("PRINT", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))

-- Lock screen
hl.bind(mod .. " + Escape", hl.dsp.exec_cmd("hyprlock"))

-- Scripts
hl.bind(mod .. " + SHIFT + F10", hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/toggle-hdr.sh"))
hl.bind(mod .. " + F9",          hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/toggle-monitor-dp4.sh"))

-- Volume
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })

-- Media
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl --player playerctld play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl --player playerctld play-pause"), { locked = true })
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl --player playerctld next"),        { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl --player playerctld previous"),    { locked = true })

-- Wallpaper
hl.bind(mod .. " + W", hl.dsp.exec_cmd("skwd wall toggle"))

-- Keyboard layout
hl.bind("ALT + " .. mod .. " + TAB", hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/switch-kb-layout.sh"))

-- Mouse: move/resize
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
