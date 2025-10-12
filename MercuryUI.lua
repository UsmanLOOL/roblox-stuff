--// Modern UI Library v2 //--
local Library = {}
Library.__index = Library

-- Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Player = Players.LocalPlayer

-- Utilities
local function roundify(obj, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius or 8)
	c.Parent = obj
end

local function canSave()
	return type(writefile) == "function" and type(readfile) == "function" and type(isfile) == "function"
end

-- Create Window
function Library:CreateWindow(title)
	local Window = {}
	Window.Tabs = {}
	Window.Config = {}
	local ConfigFile = "MercuryLoader.json"

	-- Load config
	if canSave() and isfile(ConfigFile) then
		local ok, data = pcall(function()
			return HttpService:JSONDecode(readfile(ConfigFile))
		end)
		if ok and type(data) == "table" then
			Window.Config = data
		end
	end

	-- GUI
	local PlayerGui = Player:WaitForChild("PlayerGui")
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "MercuryLoader"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = PlayerGui

	local Main = Instance.new("Frame")
	Main.Size = UDim2.new(0, 500, 0, 300)
	Main.Position = UDim2.new(0.5, -250, 0.5, -150)
	Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	Main.BorderSizePixel = 0
	Main.Parent = ScreenGui
	roundify(Main, 12)

	-- Title Bar
	local TitleBar = Instance.new("Frame")
	TitleBar.Size = UDim2.new(1, 0, 0, 35)
	TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	TitleBar.BorderSizePixel = 0
	TitleBar.Parent = Main
	roundify(TitleBar, 12)

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Text = title or "Script Hub"
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.TextColor3 = Color3.new(1, 1, 1)
	TitleLabel.TextSize = 18
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Position = UDim2.new(0, 10, 0, 0)
	TitleLabel.Size = UDim2.new(1, -10, 1, 0)
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.Parent = TitleBar

	-- Draggable window
local dragging = false
local dragStart
local startPos

local function update(input)
	if not dragging then return end
	local delta = input.Position - dragStart
	Main.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

Main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

Main.InputChanged:Connect(update)
UIS.InputChanged:Connect(update)


	-- Tabs Frame
	local TabsFrame = Instance.new("ScrollingFrame")
	TabsFrame.Size = UDim2.new(0, 130, 1, -35)
	TabsFrame.Position = UDim2.new(0, 0, 0, 35)
	TabsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	TabsFrame.BorderSizePixel = 0
	TabsFrame.ScrollBarThickness = 6
	TabsFrame.CanvasSize = UDim2.new(0,0,0,0)
	TabsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	TabsFrame.Parent = Main
	roundify(TabsFrame, 10)

	local TabLayout = Instance.new("UIListLayout")
	TabLayout.Padding = UDim.new(0, 6)
	TabLayout.FillDirection = Enum.FillDirection.Vertical
	TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	TabLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	TabLayout.Parent = TabsFrame

	-- Content Frame
	local ContentFrame = Instance.new("ScrollingFrame")
	ContentFrame.Size = UDim2.new(1, -130, 1, -35)
	ContentFrame.Position = UDim2.new(0, 130, 0, 35)
	ContentFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	ContentFrame.BorderSizePixel = 0
	ContentFrame.ScrollBarThickness = 6
	ContentFrame.CanvasSize = UDim2.new(0,0,0,0)
	ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	ContentFrame.Parent = Main
	roundify(ContentFrame, 10)

	-- Save Config
	function Window:SaveConfig()
		if canSave() then
			pcall(function()
				writefile(ConfigFile, HttpService:JSONEncode(Window.Config))
			end)
		end
	end

	-- Create Tab
	function Window:CreateTab(name)
		local Tab = {}
		Tab.Name = name

		local TabButton = Instance.new("TextButton")
		TabButton.Size = UDim2.new(0.9,0,0,30)
		TabButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
		TabButton.Text = name
		TabButton.TextColor3 = Color3.new(1,1,1)
		TabButton.Font = Enum.Font.GothamBold
		TabButton.TextSize = 15
		TabButton.Parent = TabsFrame
		roundify(TabButton,8)

		local TabFrame = Instance.new("ScrollingFrame")
		TabFrame.Size = UDim2.new(1,0,1,0)
		TabFrame.BackgroundTransparency = 1
		TabFrame.Visible = false
		TabFrame.ScrollBarThickness = 6
		TabFrame.CanvasSize = UDim2.new(0,0,0,0)
		TabFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
		TabFrame.Parent = ContentFrame

		local Layout = Instance.new("UIListLayout")
		Layout.Padding = UDim.new(0,8)
		Layout.FillDirection = Enum.FillDirection.Vertical
		Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		Layout.VerticalAlignment = Enum.VerticalAlignment.Top
		Layout.Parent = TabFrame

		local Padding = Instance.new("UIPadding")
		Padding.PaddingTop = UDim.new(0,10)
		Padding.Parent = TabFrame

		local function selectTab()
			for _, frame in pairs(ContentFrame:GetChildren()) do
				if frame:IsA("ScrollingFrame") then frame.Visible = false end
			end
			for _, btn in pairs(TabsFrame:GetChildren()) do
				if btn:IsA("TextButton") then btn.BackgroundColor3 = Color3.fromRGB(50,50,50) end
			end
			TabFrame.Visible = true
			TabButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
		end

		TabButton.MouseButton1Click:Connect(selectTab)
		if #Window.Tabs == 0 then selectTab() end

		-- Toggle
		function Tab:Toggle(name, default, callback)
			local state = default or false
			local Btn = Instance.new("TextButton")
			Btn.Size = UDim2.new(0,250,0,35)
			Btn.BackgroundColor3 = state and Color3.fromRGB(0,200,100) or Color3.fromRGB(60,60,60)
			Btn.Text = name.." : "..(state and "ON" or "OFF")
			Btn.Font = Enum.Font.GothamBold
			Btn.TextSize = 15
			Btn.TextColor3 = Color3.new(1,1,1)
			Btn.Parent = TabFrame
			roundify(Btn,8)

			Btn.MouseButton1Click:Connect(function()
				state = not state
				Btn.BackgroundColor3 = state and Color3.fromRGB(0,200,100) or Color3.fromRGB(60,60,60)
				Btn.Text = name.." : "..(state and "ON" or "OFF")
				if callback then callback(state) end
				Window.Config[name] = state
				Window:SaveConfig()
			end)
		end

		-- Button
		function Tab:Button(name, callback, iconId)
			local Btn = Instance.new("TextButton")
			Btn.Size = UDim2.new(0,250,0,35)
			Btn.BackgroundColor3 = Color3.fromRGB(0,170,255)
			Btn.Text = name
			Btn.Font = Enum.Font.GothamBold
			Btn.TextSize = 15
			Btn.TextColor3 = Color3.new(1,1,1)
			Btn.Parent = TabFrame
			roundify(Btn,8)

			if iconId then
				local Icon = Instance.new("ImageLabel")
				Icon.Image = "rbxassetid://"..iconId
				Icon.Size = UDim2.new(0,18,0,18)
				Icon.Position = UDim2.new(0,10,0.5,-9)
				Icon.BackgroundTransparency = 1
				Icon.Parent = Btn
				Btn.Text = "    "..name
			end

			Btn.MouseButton1Click:Connect(function()
				if callback then callback() end
			end)
		end

		-- Slider
		function Tab:Slider(name, min, max, default, callback)
			local Frame = Instance.new("Frame")
			Frame.Size = UDim2.new(0,250,0,40)
			Frame.BackgroundColor3 = Color3.fromRGB(45,45,45)
			Frame.Parent = TabFrame
			roundify(Frame,8)

			local Label = Instance.new("TextLabel")
			Label.Text = name.." : "..tostring(default)
			Label.Font = Enum.Font.GothamBold
			Label.TextColor3 = Color3.new(1,1,1)
			Label.TextSize = 15
			Label.BackgroundTransparency = 1
			Label.Size = UDim2.new(1,0,0.5,0)
			Label.Parent = Frame

			local Bar = Instance.new("Frame")
			Bar.Size = UDim2.new(1,-20,0,5)
			Bar.Position = UDim2.new(0,10,1,-15)
			Bar.BackgroundColor3 = Color3.fromRGB(60,60,60)
			Bar.BorderSizePixel = 0
			Bar.Parent = Frame

			local Fill = Instance.new("Frame")
			Fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
			Fill.BackgroundColor3 = Color3.fromRGB(0,170,255)
			Fill.BorderSizePixel = 0
			Fill.Parent = Bar

			local Circle = Instance.new("Frame")
			Circle.Size = UDim2.new(0,12,0,12)
			Circle.Position = UDim2.new((default-min)/(max-min),-6,0.5,-6)
			Circle.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Circle.BorderSizePixel = 0
			roundify(Circle,6)
			Circle.Parent = Bar

			local dragging = false
			Circle.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
				end
			end)
			UIS.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
				end
			end)
			UIS.InputChanged:Connect(function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					local rel = math.clamp((input.Position.X-Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X,0,1)
					local value = math.floor(min + (max-min)*rel)
					Fill.Size = UDim2.new(rel,0,1,0)
					Circle.Position = UDim2.new(rel,-6,0.5,-6)
					Label.Text = name.." : "..tostring(value)
					if callback then callback(value) end
					Window.Config[name] = value
					Window:SaveConfig()
				end
			end)
		end

		-- TextBox
		function Tab:TextBox(name, placeholder, callback)
			local Frame = Instance.new("Frame")
			Frame.Size = UDim2.new(0,250,0,40)
			Frame.BackgroundColor3 = Color3.fromRGB(45,45,45)
			Frame.Parent = TabFrame
			roundify(Frame,8)

			local Label = Instance.new("TextLabel")
			Label.Text = name
			Label.Font = Enum.Font.GothamBold
			Label.TextColor3 = Color3.new(1,1,1)
			Label.TextSize = 15
			Label.BackgroundTransparency = 1
			Label.Position = UDim2.new(0,10,0,0)
			Label.Size = UDim2.new(0.5,0,1,0)
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = Frame

			local Box = Instance.new("TextBox")
			Box.PlaceholderText = placeholder or "Enter text..."
			Box.Text = ""
			Box.Font = Enum.Font.Gotham
			Box.TextColor3 = Color3.new(1,1,1)
			Box.TextSize = 15
			Box.BackgroundTransparency = 1
			Box.Position = UDim2.new(0.5,10,0,0)
			Box.Size = UDim2.new(0.5,-20,1,0)
			Box.TextXAlignment = Enum.TextXAlignment.Left
			Box.ClearTextOnFocus = false
			Box.Parent = Frame

			Box.Focused:Connect(function()
				Frame.BackgroundColor3 = Color3.fromRGB(70,70,70)
			end)

			Box.FocusLost:Connect(function(enterPressed)
				Frame.BackgroundColor3 = Color3.fromRGB(45,45,45)
				if enterPressed and callback then callback(Box.Text) end
				Window.Config[name] = Box.Text
				Window:SaveConfig()
			end)
		end

		-- Dropdown
		function Tab:Dropdown(name, options, settings, callback)
			local MultiSelect = settings and settings.MultiSelect
			local Frame = Instance.new("Frame")
			Frame.Size = UDim2.new(0,250,0,40)
			Frame.BackgroundColor3 = Color3.fromRGB(45,45,45)
			Frame.Parent = TabFrame
			roundify(Frame,8)

			local Label = Instance.new("TextLabel")
			Label.Text = name
			Label.Font = Enum.Font.GothamBold
			Label.TextColor3 = Color3.new(1,1,1)
			Label.TextSize = 15
			Label.BackgroundTransparency = 1
			Label.Position = UDim2.new(0,10,0,0)
			Label.Size = UDim2.new(1, -20, 0.5, 0)
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = Frame

			local Button = Instance.new("TextButton")
			Button.Size = UDim2.new(1,-20,0.5,0)
			Button.Position = UDim2.new(0,10,0.5,0)
			Button.BackgroundColor3 = Color3.fromRGB(60,60,60)
			Button.Text = "Select..."
			Button.TextColor3 = Color3.new(1,1,1)
			Button.Font = Enum.Font.GothamBold
			Button.TextSize = 15
			Button.Parent = Frame
			roundify(Button,6)

			local ListFrame = Instance.new("ScrollingFrame")
			ListFrame.Size = UDim2.new(1,0,0,0)
			ListFrame.Position = UDim2.new(0,0,1,0)
			ListFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
			ListFrame.BorderSizePixel = 0
			ListFrame.Visible = false
			ListFrame.ScrollBarThickness = 6
			ListFrame.Parent = Frame

			local Layout = Instance.new("UIListLayout")
			Layout.Padding = UDim.new(0,4)
			Layout.FillDirection = Enum.FillDirection.Vertical
			Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			Layout.VerticalAlignment = Enum.VerticalAlignment.Top
			Layout.Parent = ListFrame

			local Selected = MultiSelect and {} or nil

			Button.MouseButton1Click:Connect(function()
				ListFrame.Visible = not ListFrame.Visible
				if ListFrame.Visible then
					local total = #options
					local h = math.min(6*35, total*35)
					ListFrame.Size = UDim2.new(1,0,0,h)
				end
			end)

			for _, opt in ipairs(options) do
				local OptBtn = Instance.new("TextButton")
				OptBtn.Size = UDim2.new(1,-10,0,30)
				OptBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
				OptBtn.TextColor3 = Color3.new(1,1,1)
				OptBtn.Text = opt
				OptBtn.Font = Enum.Font.GothamBold
				OptBtn.TextSize = 14
				OptBtn.Parent = ListFrame
				roundify(OptBtn,6)

				OptBtn.MouseButton1Click:Connect(function()
					if MultiSelect then
						if table.find(Selected,opt) then
							table.remove(Selected, table.find(Selected,opt))
						else
							table.insert(Selected,opt)
						end
						Button.Text = #Selected > 0 and table.concat(Selected,", ") or "Select..."
						if callback then callback(Selected) end
					else
						Selected = opt
						Button.Text = opt
						ListFrame.Visible = false
						if callback then callback(opt) end
						Window.Config[name] = opt
						Window:SaveConfig()
					end
				end)
			end
		end

		table.insert(Window.Tabs, Tab)
		return Tab
	end

	return Window
end

return Library
