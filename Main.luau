-- services --
local VirtualUser = game:GetService("VirtualUser")
-- player variables --
local plr = game.Players.LocalPlayer

-- games ---
if game.PlaceId == 2202352383 then -- spts classic
    loadstring(game:HttpGet(""))()
elseif game.PlaceId == 3823781113 then -- Saber Simulator
    loadstring(game:HttpGet(""))()
elseif game.PlaceId == 76220848070434 then -- inf parts
    loadstring(game:HttpGet(""))()
elseif game.PlaceId == 140699359360137 then -- SPTS: Reimagined
    loadstring(game:HttpGet(""))()
elseif game.PlaceId == 79268393072444 then -- sell lemons
    loadstring(game:HttpGet(""))()
else
    local player = game.Players.LocalPlayer
    local gui = Instance.new("ScreenGui", player.PlayerGui)
    local frame = Instance.new("Frame", gui)

    frame.Size = UDim2.new(0, 200, 0, 50)
    frame.Position = UDim2.new(0.5, -100, 0.1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

    local text = Instance.new("TextLabel", frame)
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.Text = "Game not suported!"

    task.wait(60)

    gui:Destroy()
end

-- anti afk --
plr.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)
