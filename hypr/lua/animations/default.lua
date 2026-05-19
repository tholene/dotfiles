hl.config({ animations = { enabled = true } })

hl.curve("ios", { type = "bezier", points = { {0.20, 0.85}, {0.20, 1.0} } })

hl.animation({ leaf = "windows",    enabled = true, speed = 2, bezier = "ios"     })
hl.animation({ leaf = "windowsIn",  enabled = true, speed = 1, bezier = "ios"     })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2, bezier = "ios"     })
hl.animation({ leaf = "fade",       enabled = true, speed = 1, bezier = "default" })
hl.animation({ leaf = "border",     enabled = true, speed = 2, bezier = "ios"     })
