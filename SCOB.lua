--[[
    STEAL A BRAINROT - ULTIMATE MOBILE SCRIPT
    Creador del Juego: Sammy
    Optimización: Mobile (Menú pequeño y movible)
]]

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("🧠 Brainrot Stealer Pro", "BloodTheme")

-- ================= PESTAÑA: ROBO Y TP =================
local Main = Window:NewTab("Robo")
local Section = Main:NewSection("Funciones de Valor")

-- 1. AGARRE INSTANTÁNEO (Súper rápido)
Section:NewToggle("Auto-Grab Instantáneo", "Roba objetos en cuanto aparezcan", function(state)
    _G.AutoGrab = state
    task.spawn(function()
        while _G.AutoGrab do
            for _, item in pairs(workspace:GetChildren()) do
                -- Buscamos el ClickDetector dentro de los modelos de Brainrot
                if item:FindFirstChild("ClickDetector") or item:FindFirstChildOfClass("ClickDetector") then
                    local cd = item:FindFirstChildOfClass("ClickDetector")
                    fireclickdetector(cd)
                end
            end
            task.wait(0.05) -- Velocidad máxima de escaneo
        end
    end)
end)

-- 2. TELETRANSPORTE SEGURO A BASE (Sin soltar)
Section:NewButton("TP a Base + SafeHold", "Teletransporta y asegura el objeto", function()
    local lp = game.Players.LocalPlayer
    local char = lp.Character
    local root = char:FindFirstChild("HumanoidRootPart")
    
    -- Detectar tu base dinámicamente en Steal a Brainrot
    local myBase = workspace.Bases:FindFirstChild(lp.Name)
    
    if root and myBase then
        -- TRUCO DE FÍSICAS: Esperamos un frame para que el motor reconozca el agarre
        task.wait(0.05)
        -- Nos movemos justo encima del punto de entrega (Deposit/Pad)
        root.CFrame = myBase.Pad.CFrame + Vector3.new(0, 3, 0)
        
        Library:Notify("Botín Asegurado", "Te has teletransportado a tu base", 2)
    else
        Library:Notify("Error", "No se detectó tu base", 3)
    end
end)

-- ================= PESTAÑA: SERVIDORES =================
local Server = Window:NewTab("Servers")
local S_Section = Server:NewSection("Buscar Mejores Partidas")

S_Section:NewButton("Buscar Brainrot de Valor", "Salta a un servidor con más objetos", function()
    local TeleportService = game:GetService("TeleportService")
    local HttpService = game:GetService("HttpService")
    local PlaceId = game.PlaceId
    
    -- Lógica de Server Hop para encontrar servidores frescos
    local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100")).data
    for _, s in pairs(servers) do
        if s.playing < s.maxPlayers and s.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(PlaceId, s.id)
            break
        end
    end
end)

-- ================= PESTAÑA: AJUSTES MÓVIL =================
local Settings = Window:NewTab("Menú")
local SetSection = Settings:NewSection("Configuración UI")

-- Botón para hacer el menú pequeño (Minimizar)
SetSection:NewKeybind("Ocultar/Mostrar GUI", "Úsalo para que no te estorbe al robar", Enum.KeyCode.E, function()
    Library:ToggleUI()
end)

SetSection:NewSlider("Velocidad de Caminado", "Corre más que los demás", 100, 16, function(s)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)

-- Info adicional para el usuario
SetSection:NewButton("Limpiar Pantalla", "Borra alertas visuales", function()
    for _, v in pairs(game.CoreGui:GetChildren()) do
        if v.Name == "KavoNotification" then v:Destroy() end
    end
end)
