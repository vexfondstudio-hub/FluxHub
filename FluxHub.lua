local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

-- ==================== GAME DATABASE ====================
-- Supported games with their script URLs
local GameDB = {
	[142823291] = {
		Name = "Murder Mystery 2",
		Script = "https://raw.githubusercontent.com/vexfondstudio-hub/FluxHub/refs/heads/main/MM2.lua",
		Icon = "sword",
	},
	-- Add more games here:
	-- [gameId] = { Name = "Game Name", Script = "url", Icon = "icon" },
}

local CurrentGame = game.PlaceId
local GameInfo = GameDB[CurrentGame]

-- ==================== LOADING SCREEN ====================
local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "FluxHub_Loading"
LoadingGui.Parent = game.CoreGui
LoadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local LoadingFrame = Instance.new("Frame")
LoadingFrame.Name = "LoadingFrame"
LoadingFrame.Size = UDim2.new(0, 400, 0, 250)
LoadingFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
LoadingFrame.BorderSizePixel = 0
LoadingFrame.Parent = LoadingGui

local Corner = Instance.new("UICorner", LoadingFrame)
Corner.CornerRadius = UDim.new(0, 16)

local Stroke = Instance.new("UIStroke", LoadingFrame)
Stroke.Color = Color3.fromRGB(60, 60, 80)
Stroke.Thickness = 2

-- Logo
local Logo = Instance.new("ImageLabel")
Logo.Name = "Logo"
Logo.Size = UDim2.new(0, 80, 0, 80)
Logo.Position = UDim2.new(0.5, -40, 0, 20)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://87424236837554"
Logo.Parent = LoadingFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 110)
Title.BackgroundTransparency = 1
Title.Text = "Flux hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 28
Title.Font = Enum.Font.GothamBold
Title.Parent = LoadingFrame

-- Status text
local Status = Instance.new("TextLabel")
Status.Name = "Status"
Status.Size = UDim2.new(1, -40, 0, 25)
Status.Position = UDim2.new(0, 20, 0, 155)
Status.BackgroundTransparency = 1
Status.Text = "Detecting game..."
Status.TextColor3 = Color3.fromRGB(180, 180, 180)
Status.TextSize = 14
Status.Font = Enum.Font.Gotham
Status.TextWrapped = true
Status.Parent = LoadingFrame

-- Progress bar background
local ProgressBg = Instance.new("Frame")
ProgressBg.Name = "ProgressBg"
ProgressBg.Size = UDim2.new(0, 360, 0, 6)
ProgressBg.Position = UDim2.new(0.5, -180, 0, 200)
ProgressBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
ProgressBg.BorderSizePixel = 0
ProgressBg.Parent = LoadingFrame

local ProgressBgCorner = Instance.new("UICorner", ProgressBg)
ProgressBgCorner.CornerRadius = UDim.new(1, 0)

-- Progress bar fill
local ProgressFill = Instance.new("Frame")
ProgressFill.Name = "ProgressFill"
ProgressFill.Size = UDim2.new(0, 0, 1, 0)
ProgressFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ProgressFill.BorderSizePixel = 0
ProgressFill.Parent = ProgressBg

local ProgressFillCorner = Instance.new("UICorner", ProgressFill)
ProgressFillCorner.CornerRadius = UDim.new(1, 0)

-- Subtitle
local Subtitle = Instance.new("TextLabel")
Subtitle.Name = "Subtitle"
Subtitle.Size = UDim2.new(1, 0, 0, 20)
Subtitle.Position = UDim2.new(0, 0, 0, 215)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "discord.gg/D6Mfqx5eS"
Subtitle.TextColor3 = Color3.fromRGB(100, 100, 120)
Subtitle.TextSize = 12
Subtitle.Font = Enum.Font.Gotham
Subtitle.Parent = LoadingFrame

-- Animation function
local function SetProgress(percent, text)
	Status.Text = text
	local tween = game:GetService("TweenService"):Create(
		ProgressFill,
		TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{Size = UDim2.new(percent, 0, 1, 0)}
	)
	tween:Play()
end

-- ==================== GAME DETECTION & LOADING ====================

local function LoadGameScript()
	SetProgress(0.1, "Checking game...")
	task.wait(0.5)

	if not GameInfo then
		-- Game not supported
		SetProgress(0.3, "Game not supported yet")
		task.wait(0.5)

		Status.TextColor3 = Color3.fromRGB(255, 80, 80)
		Status.Text = "No script available for this game"

		-- Show game info
		local GameName = game:GetService("MarketplaceService"):GetProductInfo(CurrentGame).Name
		Subtitle.Text = GameName .. " (ID: " .. CurrentGame .. ")"
		Subtitle.TextColor3 = Color3.fromRGB(255, 150, 80)

		-- Add request button
		local RequestBtn = Instance.new("TextButton")
		RequestBtn.Size = UDim2.new(0, 200, 0, 36)
		RequestBtn.Position = UDim2.new(0.5, -100, 0, 240)
		RequestBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
		RequestBtn.Text = "Request Script in Discord"
		RequestBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		RequestBtn.TextSize = 13
		RequestBtn.Font = Enum.Font.GothamSemibold
		RequestBtn.Parent = LoadingFrame
		Instance.new("UICorner", RequestBtn).CornerRadius = UDim.new(0, 8)

		RequestBtn.MouseButton1Click:Connect(function()
			pcall(function()
				setclipboard("https://discord.gg/D6Mfqx5eS")
			end)
			Status.Text = "Discord invite copied!"
			Status.TextColor3 = Color3.fromRGB(0, 255, 150)
		end)

		-- Fade out after 5 seconds
		task.delay(5, function()
			local fade = game:GetService("TweenService"):Create(
				LoadingFrame,
				TweenInfo.new(0.8, Enum.EasingStyle.Quad),
				{BackgroundTransparency = 1}
			)
			fade:Play()
			for _, child in pairs(LoadingFrame:GetDescendants()) do
				if child:IsA("GuiObject") then
					game:GetService("TweenService"):Create(
						child,
						TweenInfo.new(0.8),
						{BackgroundTransparency = 1, ImageTransparency = 1, TextTransparency = 1}
					):Play()
				end
			end
			task.wait(1)
			LoadingGui:Destroy()
		end)

		return
	end

	-- Game supported — load it
	SetProgress(0.3, GameInfo.Name .. " detected!")
	task.wait(0.3)

	SetProgress(0.5, "Loading script...")
	task.wait(0.3)

	SetProgress(0.7, "Executing...")

	local success, err = pcall(function()
		loadstring(game:HttpGet(GameInfo.Script))()
	end)

	if success then
		SetProgress(1, "Loaded successfully!")
		Status.TextColor3 = Color3.fromRGB(0, 255, 150)
		task.wait(0.8)

		-- Fade out
		local fade = game:GetService("TweenService"):Create(
			LoadingFrame,
			TweenInfo.new(0.6, Enum.EasingStyle.Quad),
			{BackgroundTransparency = 1}
		)
		fade:Play()
		for _, child in pairs(LoadingFrame:GetDescendants()) do
			if child:IsA("GuiObject") then
				game:GetService("TweenService"):Create(
					child,
					TweenInfo.new(0.6),
					{BackgroundTransparency = 1, ImageTransparency = 1, TextTransparency = 1}
				):Play()
			end
		end
		task.wait(0.8)
		LoadingGui:Destroy()
	else
		SetProgress(0.5, "Failed to load script!")
		Status.TextColor3 = Color3.fromRGB(255, 80, 80)
		Subtitle.Text = tostring(err):sub(1, 50)
		Subtitle.TextColor3 = Color3.fromRGB(255, 100, 100)

		task.delay(4, function()
			LoadingGui:Destroy()
		end)
	end
end

-- Start loading
task.spawn(LoadGameScript)
