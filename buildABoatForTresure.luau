while not game.Loaded do
    task.wait()
end

if _G.Loaded then  
    error("Script already ran")
end

_G.Loaded = true
_G.Unload = false

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
local liniarTween = loadstring(game:HttpGet("https://raw.githubusercontent.com/twootoXx/TweenService/refs/heads/main/main.luau"))()


local Window = Library:CreateWindow({
    Title = "Luminis",
    Footer = "v1.0.0",
    ToggleKeybind = Enum.KeyCode.RightControl,
    Center = true,
    AutoShow = true
})

local infoTab = Window:AddTab("Info", "info")
local mainTab = Window:AddTab("Main", "house")
local settingsTab = Window:AddTab("settings", "settings")

local scriptInfoBox = infoTab:AddLeftGroupbox("Script Info")
local discordBox = infoTab:AddRightGroupbox("Discord")
local farmBox = mainTab:AddLeftGroupbox("Farms")
local scriptBox = settingsTab:AddLeftGroupbox("Script")

discordBox:AddLabel("Support the script by joining the discord!")
discordBox:AddButton({
    Text = "Discord Invite",
    Func = function()
        setclipboard("https://discord.com/invite/WYwXgHtdZW")
    end,
    DoubleClick = false
})

scriptInfoBox:AddLabel({
    Text = "This script was made by twooto and inteded to be free.",
    DoesWrap = true
})

scriptInfoBox:AddLabel({
    Text = "This script is open source so if you're curious go and take a look.",
    DoesWrap = true
})

scriptInfoBox:AddLabel({
    Text = "Ive you got any sugestions, go and join discord and make a thread !",
    DoesWrap = true
})

farmBox:AddSlider("TweenSpeed", {
    Text = "Tween speed",
    Default = 250,
    Min = 100,
    Max = 400,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        liniarTween.SetSpeed(Value)
    end
})

farmBox:AddToggle("Auto Farm", {
    Text = "Farm Gold",
    Default = false,
    Tooltip = "fly through all the stages and collect gold",
    Callback = function(Value)
        _G.AutoGold = Value

        task.spawn(function()
            local startPoint = Vector3.new(-52.12229537963867, 83.6512222290039, 800.6994018554688)
            local endStages = Vector3.new(-61.53855895996094, 63.24703598022461, 8714.4453125)
            local chest = Vector3.new(-55.706512451171875, -340.7396240234375, 9492.3564453125)

            while _G.AutoGold and not _G.Unload do 
                task.wait()
                liniarTween.TweenPlayer(startPoint)
                liniarTween.TweenPlayer(endStages)
                liniarTween.TweenPlayer(chest)
                task.wait(16)
            end
        end)
    end
})

scriptBox:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })
Library.ToggleKeybind = Library.Options.MenuKeybind 


scriptBox:AddButton({
    Text = "Unload script",
    Func = function()
        _G.Loaded = false
        _G.Unload = true

        liniarTween.ChangeRunningState(false)
        
        Library:Unload()
    end,
    DoubleClick = true
})

SaveManager:SetLibrary(Library)
SaveManager:SetFolder("Luminis/babft")
SaveManager:BuildConfigSection(settingsTab)
SaveManager:LoadAutoloadConfig()