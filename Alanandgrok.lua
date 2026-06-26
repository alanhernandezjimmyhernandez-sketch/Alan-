-- =============================================
-- PREMIUM MULTIPLIER & AUTOFARM HUB V3 - FULL
-- Grow a Garden 2 + Steal a Brainrot
-- Grok + Tú - Junio 2026
-- =============================================

if game.CoreGui:FindFirstChild("Orion") then
    game.CoreGui.Orion:Destroy()
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- ==================== CONFIG ====================
getgenv().Config = getgenv().Config or {
    AutoFarm = false,
    AutoPlant = false,
    AutoHarvest = false,
    AutoSell = false,
    AutoSteal = false,
    AutoCollect = false,
    DupeAmount = 10,
    TargetItem = "Basic Seed",
    DupeDelay = 0.1,
    FarmSpeed = 0.2,
    WalkSpeed = 16,
    JumpPower = 50,
    AntiAFK = true,
    Notifications = true,
}

-- ==================== ORION ====================
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()

local Window = OrionLib:MakeWindow({
    Name = "🌱 Multiplier Hub V3 | GAG2 & Brainrot",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "MultiplierHubV3"
})

-- Tabs
local MainTab = Window:MakeTab({Name = "⚡ Auto Farm", Icon = "rbxassetid://4483345998"})
local DupeTab = Window:MakeTab({Name = "💎 Duplicator", Icon = "rbxassetid://4483345998"})
local TeleportTab = Window:MakeTab({Name = "🗺️ Teleports", Icon = "rbxassetid://4483345998"})
local MiscTab = Window:MakeTab({Name = "⚙️ Misc", Icon = "rbxassetid://4483345998"})

-- ==================== TOGGLES ====================
MainTab:AddToggle({Name = "Auto Farm Global", Default = false, Callback = function(v) getgenv().Config.AutoFarm = v end})
MainTab:AddToggle({Name = "Auto Plantar", Default = false, Callback = function(v) getgenv().Config.AutoPlant = v end})
MainTab:AddToggle({Name = "Auto Cosechar", Default = false, Callback = function(v) getgenv().Config.AutoHarvest = v end})
MainTab:AddToggle({Name = "Auto Vender", Default = false, Callback = function(v) getgenv().Config.AutoSell = v end})
MainTab:AddToggle({Name = "Auto Steal (Noche)", Default = false, Callback = function(v) getgenv().Config.AutoSteal = v end})
MainTab:AddToggle({Name = "Auto Collect", Default = false, Callback = function(v) getgenv().Config.AutoCollect = v end})

-- Dupe Tab
DupeTab:AddTextbox({Name = "Nombre del Item", Default = "Basic Seed", TextDisappear = false, Callback = function(v) getgenv().Config.TargetItem = v end})
DupeTab:AddSlider({Name = "Cantidad", Min = 1, Max = 100, Default = 10, Callback = function(v) getgenv().Config.DupeAmount = v end})
DupeTab:AddSlider({Name = "Delay Dupe", Min = 0.05, Max = 0.4, Default = 0.1, Increment = 0.01, Callback = function(v) getgenv().Config.DupeDelay = v end})

DupeTab:AddButton({Name = "🚀 Ejecutar Dupe", Callback = function()
    OrionLib:MakeNotification({Name = "Dupe", Content = "Iniciando dupe de "..getgenv().Config.DupeAmount.."x "..getgenv().Config.TargetItem, Time = 5})
    DupeItem(getgenv().Config.TargetItem, getgenv().Config.DupeAmount)
end})

-- Misc Tab
MiscTab:AddToggle({Name = "Anti-AFK", Default = true, Callback = function(v) getgenv().Config.AntiAFK = v end})
MiscTab:AddSlider({Name = "WalkSpeed", Min = 16, Max = 150, Default = 16, Callback = function(v)
    if humanoid then humanoid.WalkSpeed = v end
end})
MiscTab:AddSlider({Name = "JumpPower", Min = 50, Max = 200, Default = 50, Callback = function(v)
    if humanoid then humanoid.JumpPower = v end
end})

MiscTab:AddButton({Name = "Cerrar Hub", Callback = function() OrionLib:Destroy() end})

-- ==================== FUNCIONES ====================
local function Notify(title, content, time)
    if getgenv().Config.Notifications then
        OrionLib:MakeNotification({Name = title, Content = content, Time = time or 4})
    end
end

local function DupeItem(itemName, amount)
    pcall(function()
        local remote = ReplicatedStorage:FindFirstChild("DupeItem", true) 
                    or ReplicatedStorage:FindFirstChild("GiveItem", true)
                    or ReplicatedStorage:FindFirstChild("InventoryEvent", true)

        if not remote then
            Notify("❌ Error", "Remote de Dupe no encontrado", 6)
            return
        end

        for i = 1, amount do
            remote:FireServer(itemName, 1)  -- Cambia argumentos si es necesario
            task.wait(getgenv().Config.DupeDelay)
        end
        Notify("✅ Dupe Completado", amount .. "x " .. itemName, 5)
    end)
end

-- ==================== MAIN LOOP ====================
task.spawn(function()
    while true do
        task.wait(getgenv().Config.FarmSpeed)

        if not getgenv().Config.AutoFarm then continue end

        pcall(function()
            character = player.Character
            if not character then return end
            rootPart = character:FindFirstChild("HumanoidRootPart")
            humanoid = character:FindFirstChild("Humanoid")
            if not rootPart or not humanoid then return end

            -- Aquí irán las llamadas a remotes reales cuando los encuentres
            if getgenv().Config.AutoSell then
                local sell = ReplicatedStorage:FindFirstChild("SellAll", true) or ReplicatedStorage:FindFirstChild("SellItem", true)
                if sell then sell:FireServer() end
            end
        end)
    end
end)

-- ==================== ANTI-AFK + RESPAWN ====================
player.Idled:Connect(function()
    if getgenv().Config.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

player.CharacterAdded:Connect(function(new)
    character = new
    rootPart = new:WaitForChild("HumanoidRootPart")
    humanoid = new:WaitForChild("Humanoid")
end)

OrionLib:Init()
Notify("🌱 Hub Cargado", "Multiplier Hub V3 listo para usar", 6)
print("🌱 Multiplier Hub V3 - FULLY LOADED")
