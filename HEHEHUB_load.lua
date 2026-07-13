local Flux = {RainbowColorValue = 0, HueSelectionPosition = 0}
local PresetColor = Color3.fromRGB(66, 134, 255)
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CloseBind = Enum.KeyCode.RightControl

local list = {
    --Blox Fruit
    [994732206] = "loadstring(game:HttpGet('https://raw.githubusercontent.com/AsV911/HEHEHUB911TESTING2/main/HEHEHUB.lua'))()",

local function MakeDraggable(topbarobject, object)
	local Dragging = nil
	local DragInput = nil
	local DragStart = nil
	local StartPosition = nil
	local function Update(input)
		local Delta = input.Position - DragStart
		local pos =
			UDim2.new(
				StartPosition.X.Scale,
				StartPosition.X.Offset + Delta.X,
				StartPosition.Y.Scale,
				StartPosition.Y.Offset + Delta.Y
			)
		object.Position = pos
	end
	topbarobject.InputBegan:Connect(
		function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				Dragging = true
				DragStart = input.Position
				StartPosition = object.Position

				input.Changed:Connect(
					function()
						if input.UserInputState == Enum.UserInputState.End then
							Dragging = false
						end
					end
				)
			end
		end
	)
	topbarobject.InputChanged:Connect(
		function(input)
			if
				input.UserInputType == Enum.UserInputType.MouseMovement or
					input.UserInputType == Enum.UserInputType.Touch
			then
				DragInput = input
			end
		end
	)
	UserInputService.InputChanged:Connect(
		function(input)
			if input == DragInput and Dragging then
				Update(input)
			end
		end
	)
end
  
if list[game.GameId] ~= nil then
    if game.CoreGui:FindFirstChild("Hoho_Hub") then game.CoreGui:FindFirstChild("Hoho_Hub"):Destroy() end
    if game.CoreGui:FindFirstChild("Toggle HOHO") then game.CoreGui:FindFirstChild("Toggle HOHO"):Destroy() end
    wait()
    function pe_Button()
        local ui = Instance.new("ScreenGui")
        ui.Name = "Toggle HOHO"
        ui.Parent = game.CoreGui
        ui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        local OPENCLOSE = Instance.new("TextButton")
        OPENCLOSE.Name = "HoHo"
        OPENCLOSE.Parent = ui
        OPENCLOSE.BackgroundColor3 = Color3.fromRGB(0, 0, 102)
        OPENCLOSE.BorderSizePixel = 0
        OPENCLOSE.Position = UDim2.new(0.120833337, 0, 0.0952890813, 0)
        OPENCLOSE.Size = UDim2.new(0.0447916649, 0, 0.0845824406, 0)
        OPENCLOSE.Text = "HEHEHUB"
        OPENCLOSE.TextColor3 = Color3.fromRGB(255, 255, 255)
        OPENCLOSE.TextScaled = true
        OPENCLOSE.TextSize = 14.000
        OPENCLOSE.TextWrapped = true
        Instance.new("UICorner",OPENCLOSE)
        OPENCLOSE.MouseButton1Click:Connect(function()
            pcall(function()
                game.CoreGui:FindFirstChild("Hoho_Hub").Enabled = not game.CoreGui:FindFirstChild("Hoho_Hub").Enabled
            end)
        end)
        MakeDraggable(OPENCLOSE,OPENCLOSE)
    end
    loadstring(list[tonumber(game.GameId)])()
    repeat wait() until game.CoreGui:FindFirstChild("Hoho_Hub")
    pe_Button()
    game:GetService("UserInputService").InputBegan:Connect(function(input, chat)
        if not chat and input.KeyCode == Enum.KeyCode.RightControl then
            pcall(function()
                game.CoreGui:FindFirstChild("Hoho_Hub").Enabled = not game.CoreGui:FindFirstChild("Hoho_Hub").Enabled
            end)
        end
    end)
else
    game.Players.LocalPlayer:Kick("game not support")
end
