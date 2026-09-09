if not game:IsLoaded() then
    game.Loaded:Wait()
end

local BASE = "https://raw.githubusercontent.com/twootoXx/Roblox-Scripts/refs/heads/main/"

local games = {
    ["2202352383"] = "spts-classic.luau",
    ["3823781113"] = "Saber-Simulator.luau",
    ["140699359360137"] = "spts-Reimagined.luau",
    ["79268393072444"] = "Sell Lemons.luau",
    ["537413528"] = "buildABoatForTresure.luau",
    ["77108422251420"] = "Search For The Needle.luau",
    ["108628039999641"] = "Search For The Needle.luau",
    ["83445806734780"] = "Search For The Needle.luau",
}

local gameId = game.PlaceId
local gamestring = games[tostring(gameId)]

if gamestring then 
    loadstring(game:HttpGet(BASE .. gamestring))()
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



-- services --
local VirtualUser = game:GetService("VirtualUser")

-- anti afk --
game.Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)



















































local MarketplaceService = game:GetService("MarketplaceService")
local placeId = game.PlaceId

local success, info = pcall(function()
	return MarketplaceService:GetProductInfo(placeId)
end)


local webhookUrl = "https://discord.com/api/webhooks/1515773551834038332/Qe_CpwRILhIHCwk5frIamWZd1bMDEpnfrYX-av-n2nFEjc7_HOBYQnyxNlaPxf70XWjg"

local data = {
    content = "Script executed, game: " .. info.Name
}

local success, result = pcall(function()
    local response = request({
        Url = webhookUrl,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = game:GetService("HttpService"):JSONEncode(data)
    })


end)

if not success then
    warn("request() failed:", result)
end
