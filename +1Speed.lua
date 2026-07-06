local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

if not game:IsLoaded() then game.Loaded:Wait() end

local executorName = "Unknown"
pcall(function()
	if identifyexecutor then
		executorName = identifyexecutor()
	elseif getexecutorname then
		executorName = getexecutorname()
	end
end)

local Username = game:GetService("Players").LocalPlayer.Name

local Window = Library:CreateWindow({
	Title = "Flux Hub | " .. Username,
	Footer = "discord.gg/D6Mfqx5eS | " .. executorName,
	Icon = 87424236837554,
	NotifySide = "Right",
	ShowCustomCursor = true,
})

local Tabs = {
	Farm = Window:AddTab("Auto Farm", "sprout"),
	Movement = Window:AddTab("Movement", "zap"),
	Player = Window:AddTab("Player", "user"),
	Misc = Window:AddTab("Misc", "shield"),
	["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local CollectionService = game:GetService("CollectionService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Cfg = {
	Fly = false,
	FlySpeed = 50,
	Noclip = false,
	WalkSpeed = 16,
	JumpPower = 50,
	InfiniteJump = false,
	AutoWalk = false,
	GodMode = false,
	AntiKickEnabled = false,
	AntiBanEnabled = false,
	AntiACEnabled = false,
	AntiTPEnabled = false,
	MobileFlyUp = false,
	MobileFlyDown = false,
	MobileFlySpeed = 1,
}

	{X = -7.09,   Y = 8.57,   Z = 507.36,  Win = "+3 Wins"},
	{X = -5.72,   Y = 76.95,  Z = 773.96,  Win = "+10 Wins"},
	{X = -2.27,   Y = 77.00,  Z = 1107.21, Win = "+20 Wins"},
	{X = -8.36,   Y = 76.90,  Z = 1410.91, Win = "+50 Wins"},
	{X = -538.21,  Y = 54.28,  Z = 1460.07, Win = "+100 Wins"},
	{X = -1009.22, Y = 54.25,  Z = 1457.43, Win = "+150 Wins"},
	{X = -1126.21, Y = 293.79, Z = 1457.51, Win = "+250 Wins"},
	{X = -2969.32, Y = 294.96, Z = 1458.07, Win = "+500 Wins"},
	{X = -3939.31, Y = 294.99, Z = 1459.73, Win = "+1K Wins"},
	{X = -4368.22, Y = 472.35, Z = 1525.73, Win = "+2.5K Wins"},
	{X = -5342.24, Y = 471.62, Z = 1469.75, Win = "+10K Wins"},
	{X = -6809.07, Y = 520.91, Z = 1484.37, Win = "+25K Wins"},
	{X = -8354.77, Y = 483.89, Z = 1485.12, Win = "+50K Wins"},
	{X = -14005.07, Y = 762.85, Z = 3089.53, Win = "+150K Wins"},
}

local FlyToggle, GodModeToggle, AntiKickToggle, AntiBanToggle, AntiACToggle, AntiTPToggle
local FlyBV, FlyBG, FlyConn
local GodModeConn, GodModeHealthConn, GodModePosConn, AntiTPConn
local DeathPosition = nil
local MobileFlySpeed = 1
local MobileNowe = false
local MobileTpWalking = false

local function GetCharacter()
	return LocalPlayer.Character
end

local function GetHumanoid()
	local char = GetCharacter()
	return char and char:FindFirstChildOfClass("Humanoid")
end

local function GetRootPart()
	local char = GetCharacter()
	return char and char:FindFirstChild("HumanoidRootPart")
end

local function GetTorso()
	local char = GetCharacter()
	if not char then return nil end
	local hum = GetHumanoid()
	if not hum then return nil end
	if hum.RigType == Enum.HumanoidRigType.R6 then
		return char:FindFirstChild("Torso")
	else
		return char:FindFirstChild("UpperTorso")
	end
end

	end
	return 1
end

end

local oldNewIndex
oldNewIndex = hookmetamethod(game, "__newindex", function(self, key, value)
	if not checkcaller() and key == "Health" and self:IsA("Humanoid") then
		local character = LocalPlayer.Character
		if character and self:IsDescendantOf(character) then
			if type(value) == "number" and value <= 0 then
				return
			end
		end
	end
	return oldNewIndex(self, key, value)
end)

local npcZoneTags = {
	"NPC9_Zone",
	"NPC10_AttackZone",
	"NPC12_LabyrinthZone",
	"NPC15_Zone",
	"NPC15_SpeedZone",
	"MacaronMonster_AttackZone",
}

local function destroyZone(inst)
	if inst and inst.Parent then
		inst:Destroy()
	end
end

for _, tag in ipairs(npcZoneTags) do
	for _, inst in ipairs(CollectionService:GetTagged(tag)) do
		destroyZone(inst)
	end
	CollectionService:GetInstanceAddedSignal(tag):Connect(function(inst)
		task.defer(destroyZone, inst)
	end)
end

local npcNames = {
	["NPC9"] = true,
	["NPC10"] = true,
	["NPC12"] = true,
	["NPC15"] = true,
	["NPC_MacaronMonster"] = true,
}

local function handleWorkspaceDescendant(desc)
	if npcNames[desc.Name] then
		task.defer(function()
			if desc.Parent then
				desc:Destroy()
			end
		end)
	end
end

for _, desc in ipairs(workspace:GetDescendants()) do
	handleWorkspaceDescendant(desc)
end
workspace.DescendantAdded:Connect(handleWorkspaceDescendant)

local trapTags = {
	"CrushTrap",
	"LavaTrap",
	"MovingWallModel",
	"TsunamiModel",
}

local function disableTrapPart(part)
	if part:IsA("BasePart") then
		local name = part.Name
		if string.find(name, "MovingWall")
			or name == "WallL"
			or name == "WallR"
			or name == "LavaPart"
			or name == "Tsunami"
		then
			part.CanCollide = false
			part.CanTouch = false
			part.Transparency = 0.6
		end
	end
end

for _, tag in ipairs(trapTags) do
	for _, trap in ipairs(CollectionService:GetTagged(tag)) do
		for _, desc in ipairs(trap:GetDescendants()) do
			disableTrapPart(desc)
		end
		trap.DescendantAdded:Connect(disableTrapPart)
	end
	CollectionService:GetInstanceAddedSignal(tag):Connect(function(trap)
		for _, desc in ipairs(trap:GetDescendants()) do
			disableTrapPart(desc)
		end
		trap.DescendantAdded:Connect(disableTrapPart)
	end)
end

local function StartFlyPC()
	local char = GetCharacter()
	local root = GetRootPart()
	local hum = GetHumanoid()
	if not root or not hum then return end
	if FlyBV then FlyBV:Destroy() end
	if FlyBG then FlyBG:Destroy() end
	if FlyConn then FlyConn:Disconnect() end
	hum.PlatformStand = true
	FlyBG = Instance.new("BodyGyro")
	FlyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
	FlyBG.P = 5e4
	FlyBG.CFrame = root.CFrame
	FlyBG.Parent = root
	FlyBV = Instance.new("BodyVelocity")
	FlyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	FlyBV.Velocity = Vector3.zero
	FlyBV.Parent = root
	FlyConn = RunService.RenderStepped:Connect(function()
		if not Cfg.Fly then return end
		local cam = Camera.CFrame
		local spd = Cfg.FlySpeed
		local vel = Vector3.zero
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel = vel + cam.LookVector * spd end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel = vel - cam.LookVector * spd end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel = vel - cam.RightVector * spd end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel = vel + cam.RightVector * spd end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vel = vel + Vector3.yAxis * spd end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then vel = vel - Vector3.yAxis * spd end
		if UserInputService.TouchEnabled then
			if Cfg.MobileFlyUp then vel = vel + Vector3.yAxis * spd end
			if Cfg.MobileFlyDown then vel = vel - Vector3.yAxis * spd end
		end
		FlyBV.Velocity = vel
		FlyBG.CFrame = cam
	end)
end

local function StopFlyPC()
	if FlyConn then FlyConn:Disconnect() FlyConn = nil end
	if FlyBV then FlyBV:Destroy() FlyBV = nil end
	if FlyBG then FlyBG:Destroy() FlyBG = nil end
	local hum = GetHumanoid()
	if hum then
		hum.PlatformStand = false
		hum:ChangeState(Enum.HumanoidStateType.Running)
	end
end

local function StartMobileFlyMethod()
	MobileNowe = true
	local char = GetCharacter()
	local hum = GetHumanoid()
	if not char or not hum then return end
	for i = 1, MobileFlySpeed do
		task.spawn(function()
			local hb = RunService.Heartbeat
			MobileTpWalking = true
			local chr = GetCharacter()
			local h = chr and chr:FindFirstChildWhichIsA("Humanoid")
			while MobileTpWalking and chr and h and h.Parent do
				if h.MoveDirection.Magnitude > 0 then
					chr:TranslateBy(h.MoveDirection)
				end
				hb:Wait()
			end
		end)
	end
	local animate = char:FindFirstChild("Animate")
	if animate then animate.Disabled = true end
	local Hum = char:FindFirstChildOfClass("Humanoid") or char:FindFirstChildOfClass("AnimationController")
	if Hum then
		for _, v in next, Hum:GetPlayingAnimationTracks() do
			v:AdjustSpeed(0)
		end
	end
	hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
	hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
	hum:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
	hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
	hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
	hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
	hum:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
	hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
	hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
	hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
	hum:SetStateEnabled(Enum.HumanoidStateType.Running, false)
	hum:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, false)
	hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
	hum:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, false)
	hum:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
	hum:ChangeState(Enum.HumanoidStateType.Swimming)
	local torso = GetTorso()
	if not torso then return end
	local ctrl = {f = 0, b = 0, l = 0, r = 0}
	local lastctrl = {f = 0, b = 0, l = 0, r = 0}
	local maxspeed = 50
	local speed = 0
	local bg = Instance.new("BodyGyro", torso)
	bg.P = 9e4
	bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
	bg.cframe = torso.CFrame
	local bv = Instance.new("BodyVelocity", torso)
	bv.velocity = Vector3.new(0, 0.1, 0)
	bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
	hum.PlatformStand = true
	local flyLoop
	flyLoop = RunService.RenderStepped:Connect(function()
		if not MobileNowe or not torso.Parent then
			flyLoop:Disconnect()
			bg:Destroy()
			bv:Destroy()
			return
		end
		if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
			speed = speed + 0.5 + (speed / maxspeed)
			if speed > maxspeed then speed = maxspeed end
		elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
			speed = speed - 1
			if speed < 0 then speed = 0 end
		end
		if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
			bv.velocity = ((Camera.CFrame.lookVector * (ctrl.f + ctrl.b)) + ((Camera.CFrame * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * 0.2, 0).p) - Camera.CFrame.p)) * speed
			lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
		elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
			bv.velocity = ((Camera.CFrame.lookVector * (lastctrl.f + lastctrl.b)) + ((Camera.CFrame * CFrame.new(lastctrl.l + lastctrl.r, (lastctrl.f + lastctrl.b) * 0.2, 0).p) - Camera.CFrame.p)) * speed
		else
			bv.velocity = Vector3.new(0, 0.1, 0)
		end
		bg.cframe = Camera.CFrame * CFrame.Angles(-math.rad((ctrl.f + ctrl.b) * 50 * speed / maxspeed), 0, 0)
	end)
end

local function StopMobileFlyMethod()
	MobileNowe = false
	MobileTpWalking = false
	local hum = GetHumanoid()
	if hum then
		hum.PlatformStand = false
		hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
		hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
		hum:SetStateEnabled(Enum.HumanoidStateType.Flying, true)
		hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
		hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
		hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
		hum:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
		hum:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
		hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, true)
		hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
		hum:SetStateEnabled(Enum.HumanoidStateType.Running, true)
		hum:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, true)
		hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
		hum:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, true)
		hum:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
		hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
	end
	local char = GetCharacter()
	if char then
		local animate = char:FindFirstChild("Animate")
		if animate then animate.Disabled = false end
	end
end

local function EnableGodMode()
	local hum = GetHumanoid()
	if not hum then return end
	local char = GetCharacter()
	if not char then return end
	if GodModeConn then GodModeConn:Disconnect() end
	if GodModeHealthConn then GodModeHealthConn:Disconnect() end
	if GodModePosConn then GodModePosConn:Disconnect() end
	local maxHealth = hum.MaxHealth
	if maxHealth <= 0 then maxHealth = 100 end
	local root = GetRootPart()
	if root then
		DeathPosition = root.Position
	end
	GodModePosConn = RunService.Heartbeat:Connect(function()
		if not Cfg.GodMode then return end
		local r = GetRootPart()
		if r then
			DeathPosition = r.Position
		end
	end)
	GodModeConn = RunService.Heartbeat:Connect(function()
		if not Cfg.GodMode then return end
		local h = GetHumanoid()
		local c = GetCharacter()
		if not h or not c then return end
		if h.Health < maxHealth then
			h.Health = maxHealth
		end
		if h.MaxHealth ~= maxHealth then
			h.MaxHealth = maxHealth
		end
		if h:GetState() == Enum.HumanoidStateType.Dead then
			h:ChangeState(Enum.HumanoidStateType.Running)
		end
		for _, part in pairs(c:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end)
	GodModeHealthConn = hum.HealthChanged:Connect(function(newHealth)
		if not Cfg.GodMode then return end
		if newHealth < maxHealth then
			hum.Health = maxHealth
		end
	end)
	local mt = getrawmetatable(game)
	local oldNamecall = mt.__namecall
	setreadonly(mt, false)
	mt.__namecall = newcclosure(function(self, ...)
		local method = getnamecallmethod()
		if method == "FireServer" or method == "InvokeServer" then
			local args = {...}
			if #args > 0 then
				local argStr = tostring(args[1]):lower()
				if argStr:find("damage") or argStr:find("hurt") or argStr:find("kill") or argStr:find("die") or argStr:find("death") or argStr:find("respawn") or argStr:find("spawn") or argStr:find("teleport") or argStr:find("tp") then
					return
				end
			end
		end
		return oldNamecall(self, ...)
	end)
	setreadonly(mt, true)
	local oldIndex = mt.__index
	setreadonly(mt, false)
	mt.__index = newcclosure(function(self, key)
		if self == hum and (key == "Health" or key == "health") then
			return maxHealth
		end
		if self == hum and (key == "MaxHealth" or key == "maxhealth") then
			return maxHealth
		end
		return oldIndex(self, key)
	end)
	setreadonly(mt, true)
	for _, conn in pairs(getconnections(hum.Died)) do
		conn:Disable()
	end
	Library:Notify({Title = "God Mode", Description = "Enabled for " .. Username .. "!", Time = 3})
end

local function DisableGodMode()
	if GodModeConn then GodModeConn:Disconnect() GodModeConn = nil end
	if GodModeHealthConn then GodModeHealthConn:Disconnect() GodModeHealthConn = nil end
	if GodModePosConn then GodModePosConn:Disconnect() GodModePosConn = nil end
	local hum = GetHumanoid()
	if hum then
		hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
	end
	local char = GetCharacter()
	if char then
		for _, part in pairs(char:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = true
			end
		end
	end
	DeathPosition = nil
end

local function EnableAntiKick()
	if Cfg.AntiKickEnabled then return end
	Cfg.AntiKickEnabled = true
	local oldhmmi
	oldhmmi = hookmetamethod(game, "__index", function(self, method)
		if self == LocalPlayer and method:lower() == "kick" then
			return error("Expected ':' not '.' calling member function Kick", 2)
		end
		return oldhmmi(self, method)
	end)
	local oldhmmnc
	oldhmmnc = hookmetamethod(game, "__namecall", function(self, ...)
		if self == LocalPlayer and getnamecallmethod():lower() == "kick" then
			return
		end
		return oldhmmnc(self, ...)
	end)
	local mt = getrawmetatable(game)
	local oldnc = mt.__namecall
	setreadonly(mt, false)
	mt.__namecall = newcclosure(function(self, ...)
		local method = getnamecallmethod()
		if method == "FireServer" or method == "InvokeServer" then
			local args = {...}
			if #args > 0 then
				local argStr = tostring(args[1]):lower()
				if argStr:find("kick") or argStr:find("remove") or argStr:find("disconnect") or argStr:find("ban") or argStr:find("punish") then
					return
				end
			end
		end
		return oldnc(self, ...)
	end)
	setreadonly(mt, true)
	local oldhmmi2 = mt.__index
	setreadonly(mt, false)
	mt.__index = newcclosure(function(self, key)
		if self == LocalPlayer and (key:lower() == "kick" or key:lower() == "ban") then
			return function() end
		end
		return oldhmmi2(self, key)
	end)
	setreadonly(mt, true)
	Library:Notify({Title = "Anti Kick", Description = "Enabled for " .. Username .. "!", Time = 3})
end

local function EnableAntiBan()
	if Cfg.AntiBanEnabled then return end
	Cfg.AntiBanEnabled = true
	for _, v in pairs(getconnections(LocalPlayer.CharacterAdded)) do
		if v.Function then
			local info = debug.getinfo(v.Function)
			if info and info.source then
				local src = info.source:lower()
				if src:find("ban") or src:find("kick") or src:find("punish") or src:find("remove") or src:find("disconnect") then
					v:Disable()
				end
			end
		end
	end
	local mt = getrawmetatable(game)
	local oldnc = mt.__namecall
	setreadonly(mt, false)
	mt.__namecall = newcclosure(function(self, ...)
		local method = getnamecallmethod()
		if method == "FireServer" or method == "InvokeServer" then
			local args = {...}
			if #args > 0 then
				local argStr = tostring(args[1]):lower()
				if argStr:find("ban") or argStr:find("kick") or argStr:find("punish") or argStr:find("remove") or argStr:find("disconnect") or argStr:find("report") then
					return
				end
			end
		end
		return oldnc(self, ...)
	end)
	setreadonly(mt, true)
	Library:Notify({Title = "Anti Ban", Description = "Enabled for " .. Username .. "!", Time = 3})
end

local function EnableAntiAC()
	if Cfg.AntiACEnabled then return end
	Cfg.AntiACEnabled = true
	local mt = getrawmetatable(game)
	local oldnc = mt.__namecall
	setreadonly(mt, false)
	mt.__namecall = newcclosure(function(self, ...)
		local method = getnamecallmethod()
		if method == "FireServer" then
			local args = {...}
			if #args > 0 then
				local argStr = tostring(args[1]):lower()
				if argStr:find("anticheat") or argStr:find("anti_cheat") or argStr:find("anti-cheat") or argStr:find("cheatdetection") or argStr:find("hackdetection") or argStr:find("exploitdetection") or argStr:find("speedcheck") or argStr:find("flycheck") or argStr:find("noclipcheck") or argStr:find("tpdetection") or argStr:find("teleportcheck") or argStr:find("accheck") then
					return
				end
			end
		end
		return oldnc(self, ...)
	end)
	setreadonly(mt, true)
	Library:Notify({Title = "Anti AC", Description = "Enabled for " .. Username .. "!", Time = 3})
end

local function EnableAntiTP()
	if Cfg.AntiTPEnabled then return end
	Cfg.AntiTPEnabled = true
	local mt = getrawmetatable(game)
	local oldnc = mt.__namecall
	setreadonly(mt, false)
	mt.__namecall = newcclosure(function(self, ...)
		local method = getnamecallmethod()
		if method == "FireServer" or method == "InvokeServer" then
			local args = {...}
			if #args > 0 then
				local argStr = tostring(args[1]):lower()
				if argStr:find("teleport") or argStr:find("tp") or argStr:find("moveto") or argStr:find("setprimarypartcframe") or argStr:find("respawn") or argStr:find("spawn") or argStr:find("reset") then
					return
				end
				if typeof(args[1]) == "CFrame" or typeof(args[1]) == "Vector3" then
					return
				end
			end
		end
		return oldnc(self, ...)
	end)
	setreadonly(mt, true)
	AntiTPConn = RunService.Heartbeat:Connect(function()
		if not Cfg.AntiTPEnabled then return end
		local root = GetRootPart()
		if root and DeathPosition then
			if (root.Position - DeathPosition).Magnitude > 10 then
				root.CFrame = CFrame.new(DeathPosition)
			end
		end
	end)
	Library:Notify({Title = "Anti TP", Description = "Enabled for " .. Username .. "!", Time = 3})
end

local function DisableAntiTP()
	if AntiTPConn then AntiTPConn:Disconnect() AntiTPConn = nil end
	Cfg.AntiTPEnabled = false
end

local FarmLeft = Tabs.Farm:AddLeftGroupbox("Auto Farm", "sprout")
local MoveLeft = Tabs.Movement:AddLeftGroupbox("Fly", "zap")
local MoveRight = Tabs.Movement:AddRightGroupbox("Noclip", "shield")

FlyToggle = MoveLeft:AddToggle("Fly", {
	Text = "Fly",
	Default = false,
})

Toggles.Fly:OnChanged(function()
	Cfg.Fly = Toggles.Fly.Value
	if Cfg.Fly then
		if UserInputService.TouchEnabled then
			StartMobileFlyMethod()
		else
			StartFlyPC()
		end
	else
		if UserInputService.TouchEnabled then
			StopMobileFlyMethod()
		else
			StopFlyPC()
		end
	end
end)

MoveLeft:AddSlider("FlySpeed", {
	Text = "Fly Speed",
	Default = 50,
	Min = 10,
	Max = 2000,
	Rounding = 0,
	Compact = false,
})

Options.FlySpeed:OnChanged(function()
	Cfg.FlySpeed = Options.FlySpeed.Value
end)

if UserInputService.TouchEnabled then
	MoveLeft:AddToggle("MobileFlyUp", {
		Text = "Mobile: Fly Up",
		Default = false,
	})
	Toggles.MobileFlyUp:OnChanged(function()
		Cfg.MobileFlyUp = Toggles.MobileFlyUp.Value
	end)

	MoveLeft:AddToggle("MobileFlyDown", {
		Text = "Mobile: Fly Down",
		Default = false,
	})
	Toggles.MobileFlyDown:OnChanged(function()
		Cfg.MobileFlyDown = Toggles.MobileFlyDown.Value
	end)

	MoveLeft:AddSlider("MobileFlySpeed", {
		Text = "Mobile Fly Speed",
		Default = 1,
		Min = 1,
		Max = 50,
		Rounding = 0,
		Compact = false,
	})
	Options.MobileFlySpeed:OnChanged(function()
		MobileFlySpeed = Options.MobileFlySpeed.Value
		if MobileNowe then
			MobileTpWalking = false
			for i = 1, MobileFlySpeed do
				task.spawn(function()
					local hb = RunService.Heartbeat
					MobileTpWalking = true
					local chr = GetCharacter()
					local h = chr and chr:FindFirstChildWhichIsA("Humanoid")
					while MobileTpWalking and chr and h and h.Parent do
						if h.MoveDirection.Magnitude > 0 then
							chr:TranslateBy(h.MoveDirection)
						end
						hb:Wait()
					end
				end)
			end
		end
	end)
end

MoveRight:AddToggle("Noclip", {
	Text = "Noclip",
	Default = false,
})

Toggles.Noclip:OnChanged(function()
	Cfg.Noclip = Toggles.Noclip.Value
end)

local PlayerLeft = Tabs.Player:AddLeftGroupbox("Character", "user")
local PlayerRight = Tabs.Player:AddRightGroupbox("God Mode", "shield")

PlayerLeft:AddSlider("WalkSpeed", {
	Text = "Walk Speed",
	Default = 16,
	Min = 16,
	Max = 1000,
	Rounding = 0,
	Compact = false,
})

Options.WalkSpeed:OnChanged(function()
	Cfg.WalkSpeed = Options.WalkSpeed.Value
	local hum = GetHumanoid()
	if hum then hum.WalkSpeed = Cfg.WalkSpeed end
end)

PlayerLeft:AddSlider("JumpPower", {
	Text = "Jump Power",
	Default = 50,
	Min = 50,
	Max = 1000,
	Rounding = 0,
	Compact = false,
})

Options.JumpPower:OnChanged(function()
	Cfg.JumpPower = Options.JumpPower.Value
	local hum = GetHumanoid()
	if hum then
		hum.UseJumpPower = true
		hum.JumpPower = Cfg.JumpPower
	end
end)

PlayerLeft:AddToggle("InfiniteJump", {
	Text = "Infinite Jump",
	Default = false,
})

Toggles.InfiniteJump:OnChanged(function()
	Cfg.InfiniteJump = Toggles.InfiniteJump.Value
end)

UserInputService.JumpRequest:Connect(function()
	if Cfg.InfiniteJump then
		local hum = GetHumanoid()
		if hum then hum:ChangeState("Jumping") end
	end
end)

GodModeToggle = PlayerRight:AddToggle("GodMode", {
	Text = "God Mode",
	Default = false,
})

Toggles.GodMode:OnChanged(function()
	Cfg.GodMode = Toggles.GodMode.Value
	if Cfg.GodMode then
		EnableGodMode()
	else
		DisableGodMode()
	end
end)

local MiscLeft = Tabs.Misc:AddLeftGroupbox("Anti Kick", "shield")
local MiscCenter = Tabs.Misc:AddRightGroupbox("Anti Ban", "shield")
local MiscRight = Tabs.Misc:AddRightGroupbox("Anti AC", "shield")
local MiscBottom = Tabs.Misc:AddLeftGroupbox("Anti TP", "shield")
local MiscOther = Tabs.Misc:AddRightGroupbox("Other", "settings")

AntiKickToggle = MiscLeft:AddToggle("AntiKick", {
	Text = "Anti Kick",
	Default = true,
})

Toggles.AntiKick:OnChanged(function()
	if Toggles.AntiKick.Value then
		EnableAntiKick()
	end
end)

AntiBanToggle = MiscCenter:AddToggle("AntiBan", {
	Text = "Anti Ban",
	Default = true,
})

Toggles.AntiBan:OnChanged(function()
	if Toggles.AntiBan.Value then
		EnableAntiBan()
	end
end)

AntiACToggle = MiscRight:AddToggle("AntiAC", {
	Text = "Bypass Anti Cheat",
	Default = true,
})

Toggles.AntiAC:OnChanged(function()
	if Toggles.AntiAC.Value then
		EnableAntiAC()
	end
end)

AntiTPToggle = MiscBottom:AddToggle("AntiTP", {
	Text = "Anti Teleport",
	Default = true,
})

Toggles.AntiTP:OnChanged(function()
	if Toggles.AntiTP.Value then
		EnableAntiTP()
	else
		DisableAntiTP()
	end
end)

MiscOther:AddButton({
	Text = "Enable Anti-AFK",
	Func = function()
		LocalPlayer.Idled:Connect(function()
			VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame)
			task.wait(1)
			VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
		end)
		Library:Notify({Title = "Anti-AFK", Description = "Active", Time = 3})
	end,
})

RunService.Stepped:Connect(function()
	local char = GetCharacter()
	if not char then return end
	local hum = GetHumanoid()
	if Cfg.Noclip then
		for _, part in pairs(char:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
	if hum and Cfg.WalkSpeed ~= 16 then
		hum.WalkSpeed = Cfg.WalkSpeed
	end
	if hum and Cfg.JumpPower ~= 50 then
		hum.JumpPower = Cfg.JumpPower
	end
end)

LocalPlayer.CharacterAdded:Connect(function(newChar)
	task.wait(0.1)
	if Cfg.GodMode and DeathPosition then
		local root = newChar:WaitForChild("HumanoidRootPart", 3)
		if root then
			root.CFrame = CFrame.new(DeathPosition)
		end
	end
	task.wait(0.5)
	if Cfg.Fly then
		if UserInputService.TouchEnabled then
			StartMobileFlyMethod()
		else
			StartFlyPC()
		end
	end
	if Cfg.GodMode then
		local h = newChar:FindFirstChildOfClass("Humanoid")
		if h then
			for _, conn in pairs(getconnections(h.Died)) do
				conn:Disable()
			end
		end
	end
end)

LocalPlayer.CharacterRemoving:Connect(function()
	if Cfg.GodMode then
		local root = GetRootPart()
		if root then
			DeathPosition = root.Position
		end
	end
end)

local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu", "wrench")

MenuGroup:AddToggle("KeybindMenuOpen", {
	Default = Library.KeybindFrame.Visible,
	Text = "Open Keybind Menu",
	Callback = function(value) Library.KeybindFrame.Visible = value end,
})

MenuGroup:AddButton({
	Text = "Copy Discord",
	Func = function()
		Library:Notify({Title = "Discord", Description = "https://discord.gg/D6Mfqx5eS", Time = 5})
	end,
})

MenuGroup:AddButton({
	Text = "Unload",
	Func = function()
		Cfg.AutoWalk = false
		Cfg.InfiniteJump = false
		Cfg.GodMode = false
		Cfg.Fly = false

		StopFlyPC()
		StopMobileFlyMethod()
		DisableGodMode()
		DisableAntiTP()
		Library:Unload()
	end,
})

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder("FluxHub")
SaveManager:SetFolder("FluxHub/Universal")
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()

EnableAntiKick()
EnableAntiBan()
EnableAntiAC()
EnableAntiTP()

Library:Notify({Title = "Flux Hub Loaded", Description = "Auto Win + All protections for " .. Username .. "!", Time = 5})
