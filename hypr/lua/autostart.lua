hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

    hl.exec_cmd("waybar")
    hl.exec_cmd("hypridle")

    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("nm-applet --indicator")

    hl.exec_cmd("systemctl --user start skwd-daemon")
    hl.exec_cmd("systemctl --user start elephant")
    hl.exec_cmd("walker --gapplication-service")
    hl.exec_cmd("qalc -e 'exrates'")

    hl.exec_cmd("udiskie")
    hl.exec_cmd("xembedsniproxy")
    hl.exec_cmd("swaync")
    hl.exec_cmd("sleep 3 && easyeffects --hide-window")

    hl.exec_cmd("[workspace 2 silent] webstorm")
    hl.exec_cmd("[workspace 4 silent] steam")
    hl.exec_cmd("[workspace 4 silent] gtk-launch battlenet")
    hl.exec_cmd("[workspace 5 silent] discord")
    hl.exec_cmd("[workspace 5 silent] zen-browser")
    hl.exec_cmd("[workspace 6 silent] spotify")
    hl.exec_cmd("[workspace 7 silent] betterbird")
end)
