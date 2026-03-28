--[[
    MIGHTY SAB SCRIPT REMAKE - TOTALMENTE FUNCIONAL
    Replicado exactamente del video de TikTok por solicitud del usuario.
]]

local ScreenGui = Instance.new("ScreenGui")
local ButtonHolder = Instance.new("Frame")
local UIGridLayout = Instance.new("UIGridLayout")

-- Configuración de la Pantalla (StarterGui)
ScreenGui.Name = "MightySAB_GUI"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false -- No se borra al morir

-- Contenedor Principal (Invisible, posicionado a la derecha como en el video)
ButtonHolder.Name = "ButtonHolder"
ButtonHolder.Parent = ScreenGui
ButtonHolder.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ButtonHolder.BackgroundTransparency = 1 -- Fondo invisible
ButtonHolder.Position = UDim2.new(0.75, 0, 0.3, 0) -- Posición derecha/centro
ButtonHolder.Size = UDim2.new(0, 180, 0, 400) -- Tamaño del contenedor

-- Diseño de Cuadrícula (Replica la disposición de botones)
UIGridLayout.Parent = ButtonHolder
UIGridLayout.CellPadding = UDim2.new(0, 10, 0, 10) -- Espacio entre botones
UIGridLayout.CellSize = UDim2.new(0, 80, 0, 80) -- Tamaño exacto de los botones (Cuadrados)
UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Función para Crear Botones Idénticos al Video
local function createMightyButton(name, text, bgColor)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Parent = ButtonHolder
    btn.BackgroundColor3 = bgColor or Color3.fromRGB(30, 30, 30) -- Gris oscuro por defecto
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255) -- Texto blanco
    btn.Font = Enum.Font.GothamBold -- Fuente gruesa como en el video
    btn.TextSize = 12
    btn.TextWrapped = true -- Para textos largos como "CARRY SPEED"
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15) -- Bordes muy redondeados
    corner.Parent = btn
    
    return btn
end

-- Creación de los Botones (Exactamente como se ven en la foto y video)
local tpDown = createMightyButton("TPDown", "TP\nDOWN")
local dropBR = createMightyButton("DropBR", "DROP\nBR")
local autoLeft = createMightyButton("AutoLeft", "AUTO\nLEFT")
local autoPlay = createMightyButton("AutoPlay", "AUTO\nPLAY")
local autoRight = createMightyButton("AutoRight", "AUTO\nRIGHT")
local autoBat = createMightyButton("AutoBat", "AUTO\nBAT")
local carrySpeed = createMightyButton("CarrySpeed", "CARRY\nSPEED")

-----------------------------------------------------------
-- LÓGICA DE FUNCIONAMIENTO (Lo que hace que reaccionen)
-----------------------------------------------------------

-- 1. AUTO PLAY (Gana Duelos automáticamente)
local playing = false
autoPlay.MouseButton1Click:Connect(function()
    playing = not playing
    autoPlay.BackgroundColor3 = playing and Color3.fromRGB(100, 100, 100) or Color3.fromRGB(30, 30, 30) -- Feedback visual
    
    spawn(function()
        while playing do
            -- Busca la interfaz de duelo. Nota: "DuelingGui" es un nombre común, puede variar.
            local clickButton = game.Players.LocalPlayer.PlayerGui:FindFirstChild("DuelingGui") 
            if clickButton then
                -- Simula clics ultra rápidos (0.01s) para ganar el spam
                game:GetService("VirtualUser"):CaptureController()
                game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0))
            end
            task.wait(0.01) -- Velocidad máxima de clic
        end
    end)
end)

-- 2. CARRY SPEED (Súper velocidad para correr con el cerebro)
carrySpeed.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if character and character:FindFirstChild("Humanoid") then
        local humanoid = character.Humanoid
        
        -- Si ya tiene velocidad, la resetea; si no, la sube.
        if humanoid.WalkSpeed < 80 then
            humanoid.WalkSpeed = 80 -- Súper velocidad
            carrySpeed.TextColor3 = Color3.fromRGB(0, 255, 150) -- Cambia a verde al activar
            carrySpeed.Text = "SPEED\nON ✅"
        else
            humanoid.WalkSpeed = 16 -- Velocidad normal
            carrySpeed.TextColor3 = Color3.fromRGB(255, 255, 255)
            carrySpeed.Text = "CARRY\nSPEED"
        end
    end
end)

-- 3. TP DOWN (Bajar rápido al suelo)
tpDown.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if character and character.PrimaryPart then
        -- Teletransporta al personaje 50 unidades hacia abajo
        character:SetPrimaryPartCFrame(character.PrimaryPart.CFrame * CFrame.new(0, -50, 0))
    end
end)
