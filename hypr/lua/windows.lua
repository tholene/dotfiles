hl.window_rule({
    name  = "volume-control",
    match = { class = "hyprmixer" },
    float = true,
    size  = "768 500",
    move  = "(cursor_x-(window_x/2)) (cursor_y+30)",
})

hl.window_rule({
    name      = "hide-faugus",
    match     = { class = "faugus-launcer" },
    workspace = "special:faugus silent",
})

hl.window_rule({
    name      = "discord",
    match     = { class = "discord" },
    workspace = "5 silent",
})

hl.window_rule({
    name   = "file-dialog",
    match  = { title = "^((Save|Open) File(s|)|Select a folder this site can view)$" },
    float  = true,
    center = true,
    size   = "1080 720",
})

hl.window_rule({
    name          = "betterbird-popup",
    match         = { class = "eu.betterbird.Betterbird", initial_title = "^$" },
    float         = true,
    center        = true,
    size          = "1080 720",
})

hl.window_rule({
    name   = "easy-effects",
    match  = { class = "com.github.wwmm.easyeffects" },
    float  = true,
    center = true,
    size   = "1080 720",
})

hl.window_rule({
    name      = "steam",
    match     = { class = "^steam$", initial_title = "^Steam$" },
    workspace = "4 silent",
})

hl.window_rule({
    name      = "battlenet",
    match     = { class = "^steam_app_.*$", initial_title = "^Battle\\.net$" },
    workspace = "4 silent",
})

hl.window_rule({
    name      = "wow",
    match     = { class = "^steam_app_.*$", initial_title = "^World of Warcraft$" },
    workspace = "3 silent",
})

hl.window_rule({
    name    = "wow-opacity",
    match   = { class = "^steam_app_.*$", title = "^World of Warcraft$" },
    opacity = "1.0 override 1.0 override 1.0 override",
    opaque  = true,
})

hl.window_rule({
    name    = "chrome-opacity",
    match   = { class = "^google-chrome$" },
    opacity = "1.0 override 1.0 override",
})

hl.window_rule({
    name    = "zen-opacity",
    match   = { class = "^zen$" },
    opacity = "1.0 override 1.0 override",
})

hl.layer_rule({
    name      = "skwd-paper-noanim",
    match     = { namespace = "^skwd-paper" },
    no_anim   = true,
    animation = "noanim",
})
