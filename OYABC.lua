-- ==========================================================
-- 🟦 BYPASS DE MOTOR AVANZADO (ANTI-CHEAT SHIELD) 🟦
-- ==========================================================
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

-- Engaña al juego: Si el servidor pregunta tu velocidad o salto, el script miente
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldIndex = mt.__index

mt.__index = newcclosure(function(t, k)
    if not checkcaller() then
        if t == hum and k == "WalkSpeed" then return 16 end
        if t == hum and k == "JumpPower" then return 50 end
        if t == hum and k == "JumpHeight" then return 7.2 end
    end
    return oldIndex(t, k)
end)
setreadonly(mt, true)

-- Ocultar la GUI de capturas de pantalla y escaneos
local function Protect(gui)
    if gethui then gui.Parent = gethui() else gui.Parent = game:GetService("CoreGui") end
end

-- ==========================================================
-- 🟦 INTERFAZ ESTILO VIDEO (OPTIMIZADA) 🟦
-- ==========================================================
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")

ScreenGui.Name = "OYBC_Stealth"
Protect(ScreenGui)

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.4
MainFrame.Position = UDim2.new(0.7, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 170, 0, 0)
MainFrame.AutomaticSize = Enum.AutomaticSize.Y
MainFrame.Active = true
MainFrame.Draggable = true

local PanelCorner = Instance.new("UICorner")
PanelCorner.CornerRadius = UDim.new(0, 15)
PanelCorner.Parent = MainFrame

UIListLayout.Parent = MainFrame
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Padding = UDim.new(0, 10)

local function CreateButton(text, callback)
    local Button = Instance.new("TextButton")
    local Status = Instance.new("Frame")
    Button.Parent = MainFrame
    Button.Size = UDim2.new(0, 150, 0, 45)
    Button.BackgroundColor3 = Color3.fromRGB(40, 0, 80)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Text = text
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 12
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Button

    Status.Parent = Button
    Status.Size = UDim2.new(0, 8, 0, 8)
    Status.Position = UDim2.new(0.9, 0, 0.1, 0)
    Status.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    Instance.new("UICorner", Status).CornerRadius = UDim.new(1, 0)

    local active = false
    Button.MouseButton1Click:Connect(function()
        active = not active
        Status.BackgroundColor3 = active and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        callback(active)
    end)
end

-- ==========================================================
-- 🟦 FUNCIONES CON BYPASS ACTIVO 🟦
-- ==========================================================

-- 1. AUTO-GRAB CON SMOOTH TP (Teletransporte Suave)
CreateButton("Ghost Grab & Base", function(enabled)
    _G.Loop = enabled
    spawn(function()
        local spawnPos = char.HumanoidRootPart.CFrame
        while _G.Loop do
            local target = workspace:FindFirstChild("Brainrot") or workspace:FindFirstChild("Item")
            if target and target:FindFirstChild("Handle") then
                -- Movimiento con 'jitter' aleatorio para parecer lag humano
                char.HumanoidRootPart.CFrame = target.Handle.CFrame * CFrame.new(0, math.random(2,3), 0)
                task.wait(0.15) -- Delay necesario para que el servidor registre el toque
                firetouchinterest(char.HumanoidRootPart, target.Handle, 0)
                firetouchinterest(char.HumanoidRootPart, target.Handle, 1)
                task.wait(0.1)
                char.HumanoidRootPart.CFrame = spawnPos
            end
            task.wait(math.random(5, 8) / 10) -- Espera aleatoria entre 0.5 y 0.8 seg
        end
    end)
end)

-- 2. MOVIMIENTO LEGIT (NO-DETECTION)
CreateButton("Legit Speed/Jump", function(enabled)
    if enabled then
        hum.WalkSpeed = 26 -- Velocidad límite para no activar alertas
        hum.JumpPower = 80 -- Salto mejorado pero creíble
    else
        hum.WalkSpeed = 16
        hum.JumpPower = 50
    end
end)

-- 3. AUTO FLOAT (BYPASS GRAVITY)
CreateButton("Auto Float", function(enabled)
    _G.Float = enabled
    game:GetService("RunService").Heartbeat:Connect(function()
        if _G.Float then
            -- En lugar de saltar siempre, aplicamos una fuerza hacia arriba
            char.HumanoidRootPart.Velocity = Vector3.new(char.HumanoidRootPart.Velocity.X, 1.5, char.HumanoidRootPart.Velocity.Z)
        end
    end)
end)

-- 4. HUMAN KILL AURA
CreateButton("Human Aura", function(enabled)
    _G.Aura = enabled
    while _G.Aura do
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (char.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if dist < 14 then
                    -- Simula clics con tiempos variados (no siempre igual)
                    game:GetService("VirtualUser"):ClickButton1(Vector2.new(math.random(800,900), math.random(400,500)))
                end
            end
        end
        task.wait(math.random(10, 15) / 100)
    end
end)

-- 5. ESP / WALLHACK
CreateButton("Ghost Vision", function(enabled)
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Transparency = enabled and 0.6 or 0
        end
    end
end)

print("OYBC ULTRA STEALTH LOADED")
