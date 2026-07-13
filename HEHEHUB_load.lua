-- Local launcher for HEHEHUB.
-- Keep this file small and readable. The main implementation lives in HEHEHUB.lua.

local Players = game:GetService("Players")

local player = Players.LocalPlayer
if not player then
	error("HEHEHUB loader requires a LocalPlayer.")
end

warn("HEHEHUB_load.lua is now a local-only launcher. Run HEHEHUB.lua as the main script.")

local guiParent = player:FindFirstChildOfClass("PlayerGui") or player:WaitForChild("PlayerGui")
local messageGui = Instance.new("ScreenGui")
messageGui.Name = "HEHEHUB_LoaderNotice"
messageGui.ResetOnSpawn = false
messageGui.Parent = guiParent

local label = Instance.new("TextLabel")
label.AnchorPoint = Vector2.new(0.5, 0)
label.BackgroundColor3 = Color3.fromRGB(18, 26, 42)
label.BorderSizePixel = 0
label.Position = UDim2.new(0.5, 0, 0, 20)
label.Size = UDim2.new(0, 420, 0, 44)
label.Font = Enum.Font.Gotham
label.Text = "Run HEHEHUB.lua directly. Remote loadstring chaining has been removed."
label.TextColor3 = Color3.fromRGB(235, 245, 255)
label.TextSize = 14
label.Parent = messageGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = label

task.delay(5, function()
	if messageGui.Parent then
		messageGui:Destroy()
	end
end)
