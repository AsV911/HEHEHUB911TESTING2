local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local SUPPORTED_GAMES = {
	[994732206] = {
		name = "Blox Fruits",
		status = "Configured",
	},
}

local HUB_NAME = "HEHEHUB"
local GUI_NAME = "HEHEHUB_Main"
local TOGGLE_GUI_NAME = "HEHEHUB_Toggle"
local TOGGLE_KEY = Enum.KeyCode.RightControl
local HARDCODED_KEY = "HEHEHUB-DEV-2026"

local theme = {
	accent = Color3.fromRGB(0, 220, 255),
	bg = Color3.fromRGB(8, 12, 20),
	panel = Color3.fromRGB(14, 20, 32),
	panelAlt = Color3.fromRGB(18, 26, 42),
	border = Color3.fromRGB(42, 62, 92),
	text = Color3.fromRGB(235, 245, 255),
	textSoft = Color3.fromRGB(150, 185, 220),
	button = Color3.fromRGB(24, 36, 58),
	buttonHover = Color3.fromRGB(34, 50, 80),
	success = Color3.fromRGB(40, 180, 120),
	warn = Color3.fromRGB(240, 180, 70),
}

local function destroyIfPresent(name)
	local existing = playerGui:FindFirstChild(name)
	if existing then
		existing:Destroy()
	end
end

destroyIfPresent(GUI_NAME)
destroyIfPresent(TOGGLE_GUI_NAME)

local function makeCorner(parent, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius or 8)
	corner.Parent = parent
	return corner
end

local function makeStroke(parent, color)
	local stroke = Instance.new("UIStroke")
	stroke.Color = color or theme.border
	stroke.Thickness = 1
	stroke.Parent = parent
	return stroke
end

local function makePadding(parent, left, right, top, bottom)
	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, left or 0)
	padding.PaddingRight = UDim.new(0, right or 0)
	padding.PaddingTop = UDim.new(0, top or 0)
	padding.PaddingBottom = UDim.new(0, bottom or 0)
	padding.Parent = parent
	return padding
end

local function makeDraggable(handle, target)
	target = target or handle

	local dragging = false
	local dragStart
	local startPosition
	local dragInput

	handle.InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		dragging = true
		dragStart = input.Position
		startPosition = target.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end)

	handle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if not dragging or input ~= dragInput then
			return
		end

		local delta = input.Position - dragStart
		target.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)
	end)
end

local function createNotificationHost(parent)
	local host = Instance.new("Frame")
	host.Name = "Notifications"
	host.AnchorPoint = Vector2.new(1, 0)
	host.BackgroundTransparency = 1
	host.Position = UDim2.new(1, -16, 0, 16)
	host.Size = UDim2.new(0, 280, 1, -32)
	host.Parent = parent

	local list = Instance.new("UIListLayout")
	list.Padding = UDim.new(0, 8)
	list.HorizontalAlignment = Enum.HorizontalAlignment.Right
	list.SortOrder = Enum.SortOrder.LayoutOrder
	list.Parent = host

	return host
end

local root = Instance.new("ScreenGui")
root.Name = GUI_NAME
root.ResetOnSpawn = false
root.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
root.Parent = playerGui
root.Enabled = false

local notifications = createNotificationHost(root)

local function notify(text, duration)
	local card = Instance.new("Frame")
	card.BackgroundColor3 = theme.panel
	card.BackgroundTransparency = 0.05
	card.Size = UDim2.new(1, 0, 0, 44)
	card.Parent = notifications
	makeCorner(card, 10)
	makeStroke(card)
	makePadding(card, 12, 12, 8, 8)

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Gotham
	label.Text = text
	label.TextColor3 = theme.text
	label.TextSize = 14
	label.TextWrapped = true
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Size = UDim2.new(1, 0, 1, 0)
	label.Parent = card

	card.Position = UDim2.new(0, 24, 0, 0)
	card.BackgroundTransparency = 1
	label.TextTransparency = 1

	TweenService:Create(card, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 0.05,
	}):Play()
	TweenService:Create(label, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
		TextTransparency = 0,
	}):Play()

	task.delay(duration or 3, function()
		if not card.Parent then
			return
		end

		TweenService:Create(card, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
			Position = UDim2.new(0, 24, 0, 0),
			BackgroundTransparency = 1,
		}):Play()
		TweenService:Create(label, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
			TextTransparency = 1,
		}):Play()

		task.delay(0.22, function()
			if card.Parent then
				card:Destroy()
			end
		end)
	end)
end

local currentGame = SUPPORTED_GAMES[game.GameId]
local currentStatus = currentGame and currentGame.status or "Unsupported"
local statusColor = currentGame and theme.success or theme.warn
local unlocked = false

local window = Instance.new("Frame")
window.Name = "Window"
window.AnchorPoint = Vector2.new(0.5, 0.5)
window.BackgroundColor3 = theme.bg
window.Position = UDim2.new(0.5, 0, 0.5, 0)
window.Size = UDim2.new(0, 520, 0, 320)
window.Parent = root
makeCorner(window, 12)
makeStroke(window)

local topBar = Instance.new("Frame")
topBar.BackgroundColor3 = theme.accent
topBar.BorderSizePixel = 0
topBar.Size = UDim2.new(1, 0, 0, 36)
topBar.Parent = window
makeCorner(topBar, 12)

local topBarMask = Instance.new("Frame")
topBarMask.BackgroundColor3 = theme.accent
topBarMask.BorderSizePixel = 0
topBarMask.Position = UDim2.new(0, 0, 1, -12)
topBarMask.Size = UDim2.new(1, 0, 0, 12)
topBarMask.Parent = topBar

makeDraggable(topBar, window)

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = HUB_NAME
title.TextColor3 = Color3.fromRGB(4, 12, 20)
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Position = UDim2.new(0, 14, 0, 0)
title.Size = UDim2.new(1, -120, 1, 0)
title.Parent = topBar

local minimize = Instance.new("TextButton")
minimize.AnchorPoint = Vector2.new(1, 0.5)
minimize.BackgroundColor3 = theme.button
minimize.Position = UDim2.new(1, -14, 0.5, 0)
minimize.Size = UDim2.new(0, 28, 0, 28)
minimize.Text = "-"
minimize.Font = Enum.Font.GothamBold
minimize.TextColor3 = theme.text
minimize.TextSize = 18
minimize.Parent = topBar
makeCorner(minimize, 8)

local body = Instance.new("Frame")
body.BackgroundTransparency = 1
body.Position = UDim2.new(0, 16, 0, 52)
body.Size = UDim2.new(1, -32, 1, -68)
body.Parent = window

local left = Instance.new("Frame")
left.BackgroundColor3 = theme.panel
left.Size = UDim2.new(0, 156, 1, 0)
left.Parent = body
makeCorner(left, 10)
makeStroke(left)
makePadding(left, 12, 12, 12, 12)

local leftList = Instance.new("UIListLayout")
leftList.Padding = UDim.new(0, 10)
leftList.SortOrder = Enum.SortOrder.LayoutOrder
leftList.Parent = left

local right = Instance.new("Frame")
right.BackgroundColor3 = theme.panelAlt
right.Position = UDim2.new(0, 172, 0, 0)
right.Size = UDim2.new(1, -172, 1, 0)
right.Parent = body
makeCorner(right, 10)
makeStroke(right)
makePadding(right, 14, 14, 14, 14)

local rightList = Instance.new("UIListLayout")
rightList.Padding = UDim.new(0, 10)
rightList.SortOrder = Enum.SortOrder.LayoutOrder
rightList.Parent = right

local function addText(parent, text, size, color, bold)
	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.AutomaticSize = Enum.AutomaticSize.Y
	label.Size = UDim2.new(1, 0, 0, 0)
	label.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
	label.Text = text
	label.TextColor3 = color or theme.text
	label.TextSize = size or 14
	label.TextWrapped = true
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = parent
	return label
end

local function addButton(parent, text, callback)
	local button = Instance.new("TextButton")
	button.BackgroundColor3 = theme.button
	button.Size = UDim2.new(1, 0, 0, 36)
	button.Font = Enum.Font.GothamMedium
	button.Text = text
	button.TextColor3 = theme.text
	button.TextSize = 14
	button.Parent = parent
	makeCorner(button, 8)
	makeStroke(button)

	button.MouseEnter:Connect(function()
		button.BackgroundColor3 = theme.buttonHover
	end)

	button.MouseLeave:Connect(function()
		button.BackgroundColor3 = theme.button
	end)

	button.MouseButton1Click:Connect(callback)
	return button
end

addText(left, "Game", 15, theme.text, true)
addText(left, currentGame and currentGame.name or tostring(game.Name), 14, theme.textSoft, false)
addText(left, "Status", 15, theme.text, true)
addText(left, currentStatus, 14, statusColor, true)

local statusBox = Instance.new("Frame")
statusBox.BackgroundColor3 = theme.bg
statusBox.Size = UDim2.new(1, 0, 0, 72)
statusBox.Parent = right
makeCorner(statusBox, 10)
makeStroke(statusBox)
makePadding(statusBox, 12, 12, 10, 10)

addText(statusBox, "Local build", 16, theme.text, true)
addText(
	statusBox,
	"This version no longer downloads or executes remote code. Everything here is readable and local.",
	13,
	theme.textSoft,
	false
)

local actions = Instance.new("Frame")
actions.BackgroundTransparency = 1
actions.Size = UDim2.new(1, 0, 0, 128)
actions.Parent = right

local actionsList = Instance.new("UIListLayout")
actionsList.Padding = UDim.new(0, 10)
actionsList.SortOrder = Enum.SortOrder.LayoutOrder
actionsList.Parent = actions

addButton(actions, "Show Status", function()
	notify(("Game: %s | Status: %s"):format(currentGame and currentGame.name or game.Name, currentStatus), 3)
end)

addButton(actions, "Copy Game Id", function()
	if setclipboard then
		setclipboard(tostring(game.GameId))
		notify("Copied game id to clipboard.", 3)
	else
		notify(("Clipboard not available. Game id: %s"):format(game.GameId), 4)
	end
end)

addButton(actions, "Close Hub", function()
	root:Destroy()
end)

local notes = Instance.new("Frame")
notes.BackgroundColor3 = theme.bg
notes.Size = UDim2.new(1, 0, 1, -230)
notes.Parent = right
makeCorner(notes, 10)
makeStroke(notes)
makePadding(notes, 12, 12, 10, 10)

addText(notes, "Notes", 16, theme.text, true)
addText(
	notes,
	"Use this file as the main entry point. Add per-game features in plain Lua instead of obfuscated payloads or chained remote loaders.",
	13,
	theme.textSoft,
	false
)

local minimized = false
local expandedSize = window.Size

minimize.MouseButton1Click:Connect(function()
	minimized = not minimized
	minimize.Text = minimized and "+" or "-"
	TweenService:Create(window, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
		Size = minimized and UDim2.new(0, expandedSize.X.Offset, 0, 36) or expandedSize,
	}):Play()
	body.Visible = not minimized
end)

local toggleGui = Instance.new("ScreenGui")
toggleGui.Name = TOGGLE_GUI_NAME
toggleGui.ResetOnSpawn = false
toggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
toggleGui.Parent = playerGui

local toggleButton = Instance.new("TextButton")
toggleButton.BackgroundColor3 = theme.button
toggleButton.Position = UDim2.new(0, 16, 0, 120)
toggleButton.Size = UDim2.new(0, 100, 0, 34)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Text = HUB_NAME
toggleButton.TextColor3 = theme.text
toggleButton.TextSize = 14
toggleButton.Parent = toggleGui
makeCorner(toggleButton, 10)
makeStroke(toggleButton)
makeDraggable(toggleButton)

toggleButton.MouseButton1Click:Connect(function()
	if unlocked then
		root.Enabled = not root.Enabled
	end
end)

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then
		return
	end

	if input.KeyCode == TOGGLE_KEY then
		if unlocked then
			root.Enabled = not root.Enabled
		end
	end
end)

local keyGui = Instance.new("ScreenGui")
keyGui.Name = "HEHEHUB_KeySystem"
keyGui.ResetOnSpawn = false
keyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
keyGui.Parent = playerGui

local keyWindow = Instance.new("Frame")
keyWindow.AnchorPoint = Vector2.new(0.5, 0.5)
keyWindow.BackgroundColor3 = theme.bg
keyWindow.Position = UDim2.new(0.5, 0, 0.5, 0)
keyWindow.Size = UDim2.new(0, 360, 0, 220)
keyWindow.Parent = keyGui
makeCorner(keyWindow, 12)
makeStroke(keyWindow)

local keyBar = Instance.new("Frame")
keyBar.BackgroundColor3 = theme.accent
keyBar.BorderSizePixel = 0
keyBar.Size = UDim2.new(1, 0, 0, 36)
keyBar.Parent = keyWindow
makeCorner(keyBar, 12)

local keyBarMask = Instance.new("Frame")
keyBarMask.BackgroundColor3 = theme.accent
keyBarMask.BorderSizePixel = 0
keyBarMask.Position = UDim2.new(0, 0, 1, -12)
keyBarMask.Size = UDim2.new(1, 0, 0, 12)
keyBarMask.Parent = keyBar

makeDraggable(keyBar, keyWindow)

local keyTitle = Instance.new("TextLabel")
keyTitle.BackgroundTransparency = 1
keyTitle.Font = Enum.Font.GothamBold
keyTitle.Text = HUB_NAME .. " Key"
keyTitle.TextColor3 = Color3.fromRGB(4, 12, 20)
keyTitle.TextSize = 18
keyTitle.TextXAlignment = Enum.TextXAlignment.Left
keyTitle.Position = UDim2.new(0, 14, 0, 0)
keyTitle.Size = UDim2.new(1, -28, 1, 0)
keyTitle.Parent = keyBar

local keyBody = Instance.new("Frame")
keyBody.BackgroundTransparency = 1
keyBody.Position = UDim2.new(0, 16, 0, 52)
keyBody.Size = UDim2.new(1, -32, 1, -68)
keyBody.Parent = keyWindow

local keyLayout = Instance.new("UIListLayout")
keyLayout.Padding = UDim.new(0, 10)
keyLayout.SortOrder = Enum.SortOrder.LayoutOrder
keyLayout.Parent = keyBody

addText(keyBody, "Enter the hardcoded key to unlock the hub.", 14, theme.text, false)

local keyBox = Instance.new("TextBox")
keyBox.BackgroundColor3 = theme.panel
keyBox.ClearTextOnFocus = false
keyBox.PlaceholderText = "Enter key"
keyBox.PlaceholderColor3 = theme.textSoft
keyBox.Size = UDim2.new(1, 0, 0, 38)
keyBox.Font = Enum.Font.Gotham
keyBox.Text = ""
keyBox.TextColor3 = theme.text
keyBox.TextSize = 14
keyBox.Parent = keyBody
makeCorner(keyBox, 8)
makeStroke(keyBox)
makePadding(keyBox, 12, 12, 0, 0)

local feedback = addText(keyBody, "Test key: " .. HARDCODED_KEY, 13, theme.textSoft, false)

addButton(keyBody, "Unlock", function()
	if keyBox.Text == HARDCODED_KEY then
		unlocked = true
		root.Enabled = true
		keyGui:Destroy()
		notify("Key accepted. Hub unlocked.", 3)
	else
		feedback.Text = "Wrong key. Try again."
		feedback.TextColor3 = theme.warn
	end
end)

notify("Loaded local HEHEHUB safely. Enter the key to unlock.", 3)
