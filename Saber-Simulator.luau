-- HUD variables --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Twooto hub | Saber sim",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Welcome to twooto hub!",
   LoadingSubtitle = "by twooto",
   ShowText = "Rayfield", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   DisableRayfieldPrompts = true,
   DisableBuildWarnings = true, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

    ConfigurationSaving = {
    Enabled = true,
    FolderName = false, -- Create a custom folder for your hub/game
    FileName = "Twooto Hub Saber Sim"
    },
})

-- variables --
local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local rootPart = char:WaitForChild("HumanoidRootPart")

-- game variables --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:WaitForChild("Events")

-- script variables --
local autoswingrunning = false
local autosellrunning = false
local autogroundpickup = false
local autoflag = false
local autobuyalldna = false
local autobuyallswords = false
local autobuyclasses = false
local autogroundpickup_event = false
local killeventboss = false

local classes = {
    "Noob","Apprentice","Soldier","Paladin","Assassin","Warrior","Warlord","Berserker","Saber","Cyborg","Master","Titan","Phantom","Shadow","Ghoul","Tempest","Elementalist","Beast","Elementalist","Beast","Dark Ninja",
    "Warlock","Overlord","Demigod","ArchAngel","Wraith","Deity","Nemesis","Executioner","Terminator","Colossus","Zeus","Elf","Santa","Corruptor","Prestige","Caster","Cyclops","King","Hacker",
    "Angel","Minotaur","Cerberus","Yeti","Samurai","Baron","Detective","Red Baron","Witch","Gladiator","Purple Baron","Guard","Shadow Titan","Superhuman","Brain","Shadow Guard","Shadow Gladiator",
    "Red Elf","Gingerbread","Ninja Warrior","Snowman","Lord Of Death","Demonic","Alien","Ghost","Dracula","Golem","Dragon","Spirit","Pharaoh","Mummy","Ape","Robot","Goblin","Techno","Golden Warrior",
    "Golden Royalty","Demonic Imp","Anubis","Illuminati","Hydra","Skeleton","Supervillain","Dark Slayer","Dark Spider","Troll","Shark","Pirate","Kraken","Genie","Cobra","Sphinx","Dark Witch","Knight",
    "Chimera", "Kitsune","Odin","Cowboy","Undead","Satyr","Hermes","Hades","Faun","Giant","Ignivar","Aviator","Astronaut","Poseidon","Fallen Angel","Gargoyle","Necromancer","Sentinel","Reaper","Fireborn"
}

-- functions --
local function autoswing(status)
    autoswingrunning = status

    if autoswingrunning then
        print("Auto Swing is now enabled" .. (autoswingrunning and " (Running)" or " (Stopped)"))
        task.spawn(function()
            while autoswingrunning do
                Events.SwingSaber:FireServer()
                task.wait(0.1)
            end
        end)
    end
end

local function autosell(status)
    autosellrunning = status

    if autosellrunning then
        print("Auto Sell is now enabled" .. (autosellrunning and " (Running)" or " (Stopped)"))
        task.spawn(function()
            while autosellrunning do
                Events.SellStrength:FireServer()
                task.wait(0.1)
            end
        end)
    end
end

local function autoclaimflag(status)
    autoflag = status

    if autoflag then
        print("Auto Flag is now enabled" .. (autoflag and " (Running)" or " (Stopped)"))
        for _, flag in pairs(game:GetService("Workspace").Gameplay.Flags:GetChildren()) do
            if flag.Flag.BillboardGui.Frame.TextLabelTop.Text == plr.Name then
                continue
            end

            if not autoflag then break end

            repeat
                rootPart.CFrame = flag.Base.CFrame
                task.wait()
            until flag.Flag.BillboardGui.Frame.TextLabelTop.Text == plr.Name and string.find(flag.Flag.BillboardGui.Frame.Title.Text, "Rewarding in:")
        end

    end
end

local function auto_ground_pickup(status)
    autogroundpickup = status

    if autogroundpickup then
        print("Auto Ground Pickup is now enabled" .. (autogroundpickup and " (Running)" or " (Stopped)"))
        task.spawn(function()
            while autogroundpickup do
                for _, item in pairs(game:GetService("Workspace").Gameplay.CurrencyPickup.CurrencyHolder:GetChildren()) do
                    item.CFrame = rootPart.CFrame
                end
                task.wait(2)
            end
        end)
    end
end

local function auto_buy_all_dna(status)
    autobuyalldna = status

    if autobuyalldna then
        print("Auto Buy All DNA is now enabled" .. (autobuyalldna and " (Running)" or " (Stopped)"))
        task.spawn(function()
            while autobuyalldna do
                Events.UIAction:FireServer("BuyAllDNAs")
                task.wait()
            end
        end)
    end
end

local function auto_buy_all_swords(status)
    autobuyallswords = status

    if autobuyallswords then
        print("Auto Buy All Swords is now enabled" .. (autobuyallswords and " (Running)" or " (Stopped)"))
        task.spawn(function()
            while autobuyallswords do
                Events.UIAction:FireServer("BuyAllWeapons")
                task.wait()
            end
        end)
    end
end

local function auto_buy_classes(status)
    autobuyclasses = status

    if autobuyclasses then
        print("Auto Buy All Classes is now enabled" .. (autobuyclasses and " (Running)" or " (Stopped)"))
        task.spawn(function()
            while autobuyclasses do
                for _, class in pairs(classes) do
                    Events.UIAction:FireServer("BuyClass", class)
                    task.wait(0.1)
                    print("Buying class: " .. class)
                end
            end
        end)
    end
end

local function auto_ground_pickup_classic_event(status)
    autogroundpickup_event = status

    if autogroundpickup_event then
        print("Auto event Ground Pickup is now enabled" .. (autogroundpickup_event and " (Running)" or " (Stopped)"))
        task.spawn(function()
            while autogroundpickup_event do
                for _, item in pairs(game:GetService("Workspace").Gameplay.RegionsLoaded.ClassicEvent.CurrencyPickup.CurrencyHolder:GetChildren()) do
                    item.CFrame = rootPart.CFrame
                    task.wait(0.1)
                end
                task.wait(0.1)
            end
        end)
    end
end

local function kill_event_boss(status)
    killeventboss = status

    if killeventboss then
        print("Auto Event Boss Kill is now enabled" .. (killeventboss and " (Running)" or " (Stopped)"))
        task.spawn(function()
            while killeventboss do
                local boss = workspace.Gameplay.RegionsLoaded.ClassicEvent.Boss.BossHolder:FindFirstChild("Boss")
                local workplr = game:GetService("Workspace"):findFirstChild(plr.Name)
                for _, sword in pairs(workplr:GetChildren()) do
                    if sword:IsA("Tool") and boss then
                        sword.RemoteClick:FireServer({boss})
                    end
                end

                if boss and boss:FindFirstChild("Torso") then
                    local bossTorso = boss.Torso
                    rootPart.CFrame = bossTorso.CFrame
                end
                task.wait(0.1)
            end
        end)
    end
end

-- GUI --
-- Auto Farm Tab
local autofarmtab = Window:CreateTab("Auto Farm!", 4483345998) -- Title, Image

local farms_section = autofarmtab:CreateSection("Auto")

local Toggle1 = autofarmtab:CreateToggle({
    Name = "Auto Swing",
    CurrentValue = false,
    Flag = "Toggle_AutoSwing",  -- Unique flag
    Callback = function(Value)
        autoswing(Value)
    end
})

local Toggle2 = autofarmtab:CreateToggle({
    Name = "Auto Sell",
    CurrentValue = false,
    Flag = "Toggle_AutoSell",  -- Unique flag
    Callback = function(Value)
        autosell(Value)
    end
})

local Toggle3 = autofarmtab:CreateToggle({
    Name = "Auto Claim Flag",
    CurrentValue = false,
    Flag = "Toggle_AutoClaimFlag",  -- Unique flag
    Callback = function(Value)
        autoclaimflag(Value)
    end
})

local Toggle4 = autofarmtab:CreateToggle({
    Name = "Auto Ground Pickup",
    CurrentValue = false,
    Flag = "Toggle_AutoGroundPickup",  -- Unique flag
    Callback = function(Value)
        auto_ground_pickup(Value)
    end
})

-- Auto Buy Tab
local buytab = Window:CreateTab("Auto Buy!", 4483345998) -- Title, Image

local buy_section = buytab:CreateSection("Auto Buy")

local Toggle5 = buytab:CreateToggle({
    Name = "Auto Buy All DNA",
    CurrentValue = false,
    Flag = "Toggle_AutoBuyDNA",  -- Unique flag
    Callback = function(Value)
        auto_buy_all_dna(Value)
    end
})

local Toggle6 = buytab:CreateToggle({
    Name = "Auto Buy All Swords",
    CurrentValue = false,
    Flag = "Toggle_AutoBuySwords",  -- Unique flag
    Callback = function(Value)
        auto_buy_all_swords(Value)
    end
})

local Toggle7 = buytab:CreateToggle({
    Name = "Auto Buy All Classes",
    CurrentValue = false,
    Flag = "Toggle_AutoBuyClasses",  -- Unique flag
    Callback = function(Value)
        auto_buy_classes(Value)
    end
})

-- Event Tab
-- local eventtab = Window:CreateTab("Event!", 4483345998) -- Title, Image

-- local event_section = eventtab:CreateSection("Event Farms")

-- local Toggle8 = eventtab:CreateToggle({
--     Name = "Auto Event Ground Pickup",
--     CurrentValue = false,
--     Flag = "Toggle_AutoEventGroundPickup",  -- Unique flag
--     Callback = function(Value)
--         auto_ground_pickup_classic_event(Value)
--     end
-- })

-- local Toggle9 = eventtab:CreateToggle({
--     Name = "Auto Event Boss Kill",
--     CurrentValue = false,
--     Flag = "Toggle_AutoEventBossKill",  -- Unique flag
--     Callback = function(Value)
--         kill_event_boss(Value)
--     end
-- })


-- refresh player -- 
plr.CharacterAdded:Connect(function(character)
    char = character
    humanoid = char:WaitForChild("Humanoid")
    rootPart = char:WaitForChild("HumanoidRootPart")
end)
