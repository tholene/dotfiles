local state_file = os.getenv("HOME") .. "/.config/hypr/.display-mode"
local f = io.open(state_file, "r")
local mode = f and f:read("*l") or "sdr"
if f then f:close() end

local hdr = (mode == "hdr")

if hdr then
    hl.monitor({
        output        = "DP-4",
        mode          = "highres@highrr",
        position      = "0x0",
        scale         = 1,
        bitdepth      = 10,
        cm            = "hdr",
        sdrbrightness = 1.05,
        sdrsaturation = 1.1,
    })
else
    hl.monitor({
        output   = "DP-4",
        mode     = "highres@highrr",
        position = "0x0",
        scale    = 1,
        bitdepth = 10,
    })
end

hl.monitor({
    output   = "DP-5",
    mode     = "highres@highrr",
    position = "3840x0",
    scale    = 1,
    bitdepth = 10,
})

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})
