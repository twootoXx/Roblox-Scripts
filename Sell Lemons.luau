local tycoon = nil
local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local root = char:FindFirstChild("HumanoidRootPart")
local rebirthMenu = plr.PlayerGui.Rebirth.InvestorsMenu.Body

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Tycoon = require(ReplicatedStorage.Modules.Tycoon.Tycoon)
local TycoonBalances = require(ReplicatedStorage.Modules.Tycoon.Component.TycoonBalances)
local ClientTycoonRebirth = require(ReplicatedStorage.Modules.Tycoon.Component.Client.ClientTycoonRebirth)
local ClientTycoonEvolution = require(ReplicatedStorage.Modules.Tycoon.Component.Client.ClientTycoonEvolution)
local Huge = require(ReplicatedStorage.Modules.Huge)

_G.RebirthCondision = 2

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "twooto hub",
    Icon = "door-open", -- lucide icon. optional
    Author = "by twooto", -- optional
})

Window:SetToggleKey(Enum.KeyCode.G)

WindUI:Notify({
    Title = "twooto hub loaded",
    Content = "Script executed successfully! Welcome to twooto hub.",
    Duration = 4,
})
 
for _, item in game.Workspace:GetDescendants() do
    if item.Name == "Owner" and item:IsA("ObjectValue") then
        if tostring(item.Value) == game.Players.LocalPlayer.Name then
            tycoon = item.Parent
        end
    end
end


local infoTab = Window:Tab({
    Title = "Info",
    Icon = "info",
    Locked = false,
})

infoTab:Select()

infoTab:Paragraph({
    Title = "Creator Name",
    Desc = "twooto",
})


infoTab:Button({
    Title = "Copy Discord Link",
    Desc = "Click to copy our Discord server link to clipboard",
    Callback = function()
        local discordLink = "https://discord.gg/WYwXgHtdZW"
        setclipboard(discordLink)
        WindUI:Notify({
            Title = "Discord Link Copied!",
            Content = "The Discord link has been copied to your clipboard: " .. discordLink,
            Duration = 4,
        })
    end
})


infoTab:Paragraph({
    Title = "Discord Server",
    Desc = "https://discord.gg/WYwXgHtdZW",
})




local autoFarmTab = Window:Tab({
    Title = "Auto Farm",
    Icon = "bird", -- optional
    Locked = false,
})

autoFarmTab:Toggle({
    Title = "Auto upgrade Stations",
    Desc = "Auto upgrade stations like lemon stand",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state) 
        _G.AutoUpgradeStands = state

        local numberTries = {
            1000, 500, 250, 100, 50, 25, 10, 1
        }

        task.spawn(function()
            while _G.AutoUpgradeStands do 
                for _, item in tycoon:GetDescendants() do
                    if item:IsA("RemoteFunction") and item.Name == "Upgrade" then 
                        for _, number in numberTries do 
                            local succes = pcall(function() item:InvokeServer(number) end)
                            if succes then 
                                break
                            end
                        end
                    end
                end
                task.wait()
            end
        end)
    end
})

autoFarmTab:Toggle({
    Title = "Auto upgrade buttons",
    Desc = "Auto upgrade buttons",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state) 
        _G.UpgradeButtons = state

        task.spawn(function()
            while _G.UpgradeButtons do 
                task.wait()
                for _, item in tycoon:GetDescendants() do 
                    if item:IsA("Model") then 
                        local shown = item:GetAttribute("Shown")
                        local bought = item:GetAttribute("Purchased")

                        if shown and not bought then 
                            local remote = item.Purchase
                            pcall(function() remote:InvokeServer() end)
                        end
                    end
                end
            end
        end)
    end
})

autoFarmTab:Toggle({
    Title = "Auto click stations",
    Desc = "Auto click stations",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state) 
        _G.AutoClickStations = state

        task.spawn(function()
            while _G.AutoClickStations do 
                task.wait()
                for _, item in tycoon:GetDescendants() do
                    if item:IsA("RemoteFunction") and item.Name == "Upgrade" then
                        if item.Parent.Name == "Lemon Stand" then 
                            tycoon:WaitForChild("Remotes"):WaitForChild("WakeIncomeStream"):InvokeServer("LemonStand")
                        end
                        tycoon:WaitForChild("Remotes"):WaitForChild("WakeIncomeStream"):InvokeServer(item.Parent.Name)
                    end
                end
            end
        end)
    end
})

autoFarmTab:Toggle({
    Title = "Auto Accept phone offers",
    Desc = "Auto Accept phone offers",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state) 
        _G.AutoPhone = state

        task.spawn(function()
            while _G.AutoPhone do 
                task.wait(1)
                if plr.PlayerGui.Phone.Phone.Visible then 
                    tycoon:WaitForChild("Remotes"):WaitForChild("PhoneOffer"):FireServer("Accept")
                end
            end
        end)
    end
})

local autoRebirthTab = Window:Tab({
    Title = "Auto Rebirth",
    Icon = "bird", -- optional
    Locked = false,
})

autoRebirthTab:Toggle({
    Title = "Auto Rebirth",
    Desc = "Auto Rebirth",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state) 
        _G.AutoRebirth = state

        task.spawn(function()
            while _G.AutoRebirth do 
                task.wait(1)

                local tycoonlocal = Tycoon.getLocal()

                local balances = tycoonlocal:GetComponent(TycoonBalances)
                local rebirth = tycoonlocal:GetComponent(ClientTycoonRebirth)
                
                local currentRebirth = balances:GetInvestors()
                local potentialRebirth = rebirth:GetPotentialInvestors()

                local current = Huge.toNumber(currentRebirth)
                local potential = Huge.toNumber(potentialRebirth)

                -- print("Current investors:", current)
                -- print("Potential investors:", potential)
                -- print(current * _G.RebirthCondision)

                if current * _G.RebirthCondision < potential then 
                    tycoon:WaitForChild("Remotes"):WaitForChild("Rebirth"):InvokeServer()
                end
            end
        end)
    end
})

autoRebirthTab:Input({
    Title = "RebirthAmount",
    Desc = "RebirthAmount",
    Value = "2",
    Type = "Input",
    Placeholder = "2",
    Callback = function(input) 

        pcall(function() input = tonumber(input) end)

        if type(input) == "number" and _G.RebirthCondision > 0 then 
            _G.RebirthCondision = input
        else
            WindUI:Notify({
                Title = "Invalid value",
                Content = "the entered value is invalid, please enter a number",
                Duration = 3,
            })
        end
    end
})

autoRebirthTab:Toggle({
    Title = "Auto void evolve",
    Desc = "Auto void evolve",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state) 
        _G.AutoEvolve = state

        task.spawn(function()
            while _G.AutoEvolve do 
                task.wait(10)

                local tycoon = Tycoon.getLocal()
                local evolution = tycoon:GetComponent(ClientTycoonEvolution)
                
                local progress = evolution:GetEvolutionProgress()

                local ready = progress >= 1

                if ready then 
                    tycoon:WaitForChild("Remotes"):WaitForChild("Evolve"):InvokeServer()
                    print("Evolved")
                end
            end
        end)
    end
})


local autoDrops = Window:Tab({
    Title = "Auto Drops",
    Icon = "bird", -- optional
    Locked = false,
})

autoDrops:Toggle({
    Title = "Auto Cash Drops",
    Desc = "Auto Cash Drops",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state) 
        _G.AutoCashDrops = state

        task.spawn(function()
            while _G.AutoCashDrops do 
                task.wait(1)
                local drops = workspace.CashDrops:GetChildren()
                if #drops > 0 then 
                    for _, item in drops do 
                        item.CFrame = root.CFrame 
                    end
                end
            end
        end)
    end
})

autoDrops:Toggle({
    Title = "Auto lemon tree",
    Desc = "Auto lemon tree",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state) 
        _G.AutoLemonTree = state

        task.spawn(function()
            while _G.AutoLemonTree do 
                for _, item in game.Workspace:GetDescendants() do 
                    if item.Name == "LemonTree" then
                        for _, fruit in item:GetChildren() do 
                            if fruit.Name == "Fruit" and fruit:FindFirstChild('ClickPart') and _G.AutoLemonTree then 
                                root.CFrame = fruit.CFrame
                                task.wait(0.1)
                                fireclickdetector(fruit.ClickPart.ClickDetector, 0, "MouseClick")
                            end
                        end
                    end
                end
                task.wait(1)
            end
        end)
    end
})


plr.CharacterAdded:Connect(function(newChar)
    char = newChar
    root = newChar:FindFirstChild("HumanoidRootPart")
end)
