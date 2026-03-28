-- FORCE DRAW GUI - MIGHTY SAB REMAKE
local p = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "MightyFix2026"
gui.Parent = p:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local f = Instance.new("Frame")
f.Name = "Main"
f.Parent = gui
f.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
f.BackgroundTransparency = 0.2
f.Position = UDim2.new(0.65, 0, 0.15, 0) -- Movido para que se vea en celular
f.Size = UDim2.new(0, 180, 0, 360) -- Tamaño extra para que quepan los 7
f.Active = true
f.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 20)
corner.Parent = f

local grid = Instance.new("UIGridLayout")
grid.Parent = f
grid.CellSize = UDim2.new(0, 80, 0, 80)
grid.CellPadding = UDim2.new(0, 10, 0, 10)
grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
grid.VerticalAlignment = Enum.VerticalAlignment.Center

-- Función para crear botones que SÍ reaccionan
local function create(n, t)
    local b = Instance.new("TextButton")
    b.Name = n
    b.Parent = f
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.Text = t
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 10
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 15)
    c.Parent = b
    
    -- EFECTO AL TOCAR (Para saber que reacciona)
    b.MouseButton1Down:Connect(function()
        b.BackgroundColor3 = Color3.fromRGB(0, 255, 100) -- Se pone verde al tocarlo
    end)
    b.MouseButton1Up:Connect(function()
        if n ~= "AP" then b.BackgroundColor3 = Color3.fromRGB(30, 30, 30) end
    end)
    
    return b
end

-- LOS 7 BOTONES EXACTOS
local b1 = create("TP", "TP\nDOWN")
local b2 = create("DR", "DROP\nBR")
local b3 = create("AL", "AUTO\nLEFT")
local b4 = create("AP", "AUTO\nPLAY")
local b5 = create("AR", "AUTO\nRIGHT")
local b6 = create("AB", "AUTO\nBAT")
local b7 = create("CS", "CARRY\nSPEED")

-----------------------------------------------------------
-- MOTOR DE DUELO (AUTO PLAY)
-----------------------------------------------------------
local active = false
b4.MouseButton1Click:Connect(function()
    active = not active
    b4.Text = active and "AUTO\nON ✅" or "AUTO\nPLAY"
    b4.BackgroundColor3 = active and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(30, 30, 30)
    
    task.spawn(function()
        while active do
            -- Clics ultra rápidos para ganar en Sammy
            game:GetService("VirtualUser"):CaptureController()
            game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0))
            task.wait(0.01)
        end
    end)
end)

-- MOTOR DE VELOCIDAD
b7.MouseButton1Click:Connect(function()
    local h = p.Character and p.Character:FindFirstChild("Humanoid")
    if h then
        h.WalkSpeed = (h.WalkSpeed == 16) and 100 or 16
    end
end)
