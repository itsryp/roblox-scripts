local players = game:GetService("Players")
local runService = game:GetService("RunService")
local cam = workspace.CurrentCamera

local oldlines = {}
local friendships = {}

function trackplayers(p1, p2)
    while true do
        task.wait(0)
        if not p1 or not p2 then continue end
        local p1Char = p1.Character or p1.CharacterAdded:Wait()
        local p2Char = p2.Character or p2.CharacterAdded:Wait()
        local p1Pos, vis1 = cam:WorldToViewportPoint(p1Char:GetPivot().Position)
        local p2Pos, vis2 = cam:WorldToViewportPoint(p2Char:GetPivot().Position)
        if vis1 == false and vis2 == false then continue end
        local vpSize = cam.ViewportSize
        -- p1Pos = Vector3.new(-p1Pos.X, math.sign(p1Pos.Y), -p1Pos.Z)
        if p1Pos.Z < 0 then
            p1Pos = Vector3.new(-p1Pos.X, math.sign(p1Pos.Y), -p1Pos.Z)
            -- repeat
            --     p1Pos, vis1 = cam:WorldToViewportPoint(p1Char:GetPivot().Position:Lerp(p2Char:GetPivot().Position, 0.25))
            --     task.wait(0)
            -- until p1Pos.Z >= 0
            -- print("fixed")
        end
        if p2Pos.Z < 0 then
            p2Pos = Vector3.new(-p2Pos.X, math.sign(p2Pos.Y), -p2Pos.Z)
            -- repeat
            --     p2Pos, vis2 = cam:WorldToViewportPoint(p2Char:GetPivot().Position:Lerp(p1Char:GetPivot().Position, 0.25))
            --     task.wait(0)
            -- until p2Pos.Z >= 0
            -- print("fixed")
        end
        p1Pos = Vector2.new(p1Pos.X, p1Pos.Y)
        p2Pos = Vector2.new(p2Pos.X, p2Pos.Y)
        local line = Drawing.new("Line")
        local dot1 = Drawing.new("Circle")
        local dot2 = Drawing.new("Circle")
        --line1
        line.Visible = true
        line.From = p1Pos
        line.To = p2Pos
        line.Color = Color3.fromRGB(69, 162, 255)
        line.Thickness = 2
        line.Transparency = 0.5
        --dot1
        dot1.Visible = vis1
        dot1.Position = p1Pos
        dot1.Color = Color3.fromRGB(69, 162, 255)
        dot1.Thickness = 2
        dot1.Radius = 6
        dot1.Filled = true
        dot1.NumSides = 25
        dot1.Transparency = 0.5
        --dot2
        dot2.Visible = vis2
        dot2.Position = p2Pos
        dot2.Color = Color3.fromRGB(69, 162, 255)
        dot2.Thickness = 2
        dot2.Radius = 6
        dot2.Filled = true
        dot2.NumSides = 25
        dot2.Transparency = 0.5
        task.delay(0, function()
            line:Remove()
            dot1:Remove()
            dot2:Remove()
        end)
    end
end

function getfriends()
    for _,p1:Player in players:GetPlayers() do
        task.spawn(function()
            for _,p2:Player in players:GetPlayers() do
                if not p1 then break end
                if not p2 then continue end
                if p2.Name == p1.Name then continue end
                if p2:IsFriendsWith(p1.UserId) then
                    for _,v in friendships do
                        if table.find(v, p1.Name) and table.find(v, p2.Name) then
                            -- warn("players already tracked")
                            return
                        end
                    end
                    table.insert(friendships, {p1.Name, p2.Name})
                    -- print("tracking new players")
                    task.spawn(function()
                        trackplayers(p1, p2)
                    end)
                end
            end
        end)
    end
end

getfriends()

players.PlayerAdded:Connect(getfriends)