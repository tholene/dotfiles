for i = 1, 4 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "DP-4", persistent = true })
end
for i = 5, 7 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "DP-5", persistent = true })
end
