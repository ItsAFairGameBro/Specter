local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local RS = game:GetService("ReplicatedStorage")
local RunS = game:GetService("RunService")

local function LoadCore(C,Settings)
-- Gui to Lua
-- Version: 3.2

-- Instances:

local ToggleTagEx = {
	SpecterGUI = Instance.new("ScreenGui"),
	MainHUD = Instance.new("Frame"),
	DropdownFrame = Instance.new("Frame"),
	UIListLayout = Instance.new("UIListLayout"),
	DropdownButtonEx = Instance.new("TextButton"),
	UICorner = Instance.new("UICorner"),
	UIStroke = Instance.new("UIStroke"),
	CategoriesFrame = Instance.new("Frame"),
	Buttons = Instance.new("Frame"),
	CategoryEx = Instance.new("Frame"),
	Image = Instance.new("ImageLabel"),
	Text = Instance.new("TextLabel"),
	Arrow = Instance.new("TextLabel"),
	BottomFrame = Instance.new("Frame"),
	SaveButton = Instance.new("ImageLabel"),
	Wait = Instance.new("TextLabel"),
	UICorner_2 = Instance.new("UICorner"),
	UIListLayout_2 = Instance.new("UIListLayout"),
	MiscDivider = Instance.new("Frame"),
	MiscLabel = Instance.new("TextLabel"),
	HeaderTab = Instance.new("Frame"),
	HeaderTitleLabel = Instance.new("TextLabel"),
	SettingsButton = Instance.new("ImageButton"),
	Settings = Instance.new("Frame"),
	SupportedFrame = Instance.new("Frame"),
	Image_2 = Instance.new("ImageLabel"),
	Description = Instance.new("TextLabel"),
	Supported = Instance.new("TextLabel"),
	BottomFrame_2 = Instance.new("Frame"),
	RefreshButton = Instance.new("ImageLabel"),
	UICorner_3 = Instance.new("UICorner"),
	UIStroke_2 = Instance.new("UIStroke"),
	UIListLayout_3 = Instance.new("UIListLayout"),
	HackDivider = Instance.new("Frame"),
	HackLabel = Instance.new("TextLabel"),
	GameDivider = Instance.new("Frame"),
	GameLabel = Instance.new("TextLabel"),
	ScrollTab = Instance.new("ScrollingFrame"),
	UIListLayout_4 = Instance.new("UIListLayout"),
	TabsFrame = Instance.new("Frame"),
	TabEx = Instance.new("CanvasGroup"),
	HeaderTab_2 = Instance.new("Frame"),
	HeaderTitleLabel_2 = Instance.new("TextLabel"),
	DropDownButton = Instance.new("ImageButton"),
	Text_2 = Instance.new("TextLabel"),
	Image_3 = Instance.new("ImageLabel"),
	ScrollTab_2 = Instance.new("ScrollingFrame"),
	UIListLayout_5 = Instance.new("UIListLayout"),
	HackButtonEx = Instance.new("Frame"),
	HackText = Instance.new("TextLabel"),
	HackExpand = Instance.new("ImageButton"),
	OptionsList = Instance.new("Frame"),
	UIListLayout_6 = Instance.new("UIListLayout"),
	ToggleEx = Instance.new("Frame"),
	NameTL = Instance.new("TextLabel"),
	ToggleSwitchSlider = Instance.new("ImageButton"),
	UICorner_4 = Instance.new("UICorner"),
	ToggleCircle = Instance.new("Frame"),
	UICorner_5 = Instance.new("UICorner"),
	UIGradient = Instance.new("UIGradient"),
	UIGradient_2 = Instance.new("UIGradient"),
	UIStroke_3 = Instance.new("UIStroke"),
	SliderEx = Instance.new("Frame"),
	NameTL_2 = Instance.new("TextLabel"),
	SlidingBar = Instance.new("ImageButton"),
	UICorner_6 = Instance.new("UICorner"),
	CurrentPosition = Instance.new("Frame"),
	UICorner_7 = Instance.new("UICorner"),
	UIGradient_3 = Instance.new("UIGradient"),
	UIGradient_4 = Instance.new("UIGradient"),
	Backing = Instance.new("Frame"),
	Track = Instance.new("Frame"),
	ForceTB = Instance.new("TextBox"),
	TBUnderbar = Instance.new("Frame"),
	LeftBound = Instance.new("TextLabel"),
	RightBound = Instance.new("TextLabel"),
	UIStroke_4 = Instance.new("UIStroke"),
	DropdownEx = Instance.new("Frame"),
	NameTL_3 = Instance.new("TextLabel"),
	UIStroke_5 = Instance.new("UIStroke"),
	DropdownButton = Instance.new("TextButton"),
	UICorner_8 = Instance.new("UICorner"),
	UIStroke_6 = Instance.new("UIStroke"),
	UserListEx = Instance.new("Frame"),
	NameTL_4 = Instance.new("TextLabel"),
	UIStroke_7 = Instance.new("UIStroke"),
	AddButton = Instance.new("TextButton"),
	UICorner_9 = Instance.new("UICorner"),
	UIStroke_8 = Instance.new("UIStroke"),
	MainList = Instance.new("Frame"),
	UIListLayout_7 = Instance.new("UIListLayout"),
	OneListEx = Instance.new("Frame"),
	DeleteButton = Instance.new("TextButton"),
	UICorner_10 = Instance.new("UICorner"),
	UIStroke_9 = Instance.new("UIStroke"),
	UserTL = Instance.new("TextLabel"),
	EnterTB = Instance.new("TextBox"),
	UICorner_11 = Instance.new("UICorner"),
	UIStroke_10 = Instance.new("UIStroke"),
	LimitTL = Instance.new("TextLabel"),
	TextboxEx = Instance.new("Frame"),
	NameTL_5 = Instance.new("TextLabel"),
	UIStroke_11 = Instance.new("UIStroke"),
	SetTB = Instance.new("TextBox"),
	UICorner_12 = Instance.new("UICorner"),
	UIStroke_12 = Instance.new("UIStroke"),
	LimitTL_2 = Instance.new("TextLabel"),
	EnterButton = Instance.new("ImageButton"),
	UICorner_13 = Instance.new("UICorner"),
	UIStroke_13 = Instance.new("UIStroke"),
	HighlightBackground = Instance.new("Frame"),
	KeybindButton = Instance.new("ImageButton"),
	BindedKey = Instance.new("TextLabel"),
	KeybindLabel = Instance.new("TextLabel"),
	KeybindBacking = Instance.new("Frame"),
	UIGradient_5 = Instance.new("UIGradient"),
	ToolTipHeaderFrame = Instance.new("Frame"),
	ToolTipText = Instance.new("TextLabel"),
	UICorner_14 = Instance.new("UICorner"),
	Notifications = Instance.new("Frame"),
	NotificationEx = Instance.new("Frame"),
	Timer = Instance.new("Frame"),
	UICorner_15 = Instance.new("UICorner"),
	NotificationTitle = Instance.new("TextLabel"),
	NotificationDesc = Instance.new("TextLabel"),
	UITextSizeConstraint = Instance.new("UITextSizeConstraint"),
	HUDBackgroundFade = Instance.new("Frame"),
	ChatAutoComplete = Instance.new("ScrollingFrame"),
	AutoCompleteEx = Instance.new("Frame"),
	AutoCompleteTitleLabel = Instance.new("TextLabel"),
	UIListLayout_8 = Instance.new("UIListLayout"),
	Actions = Instance.new("CanvasGroup"),
	HeaderTab_3 = Instance.new("Frame"),
	HeaderTitleLabel_3 = Instance.new("TextLabel"),
	DropDownButton_2 = Instance.new("ImageButton"),
	Text_3 = Instance.new("TextLabel"),
	Image_4 = Instance.new("ImageLabel"),
	ScrollTab_3 = Instance.new("ScrollingFrame"),
	UIListLayout_9 = Instance.new("UIListLayout"),
	ActionsEx = Instance.new("Frame"),
	Title = Instance.new("TextLabel"),
	StopButton = Instance.new("TextButton"),
	UIStroke_14 = Instance.new("UIStroke"),
	Time = Instance.new("TextLabel"),
	UIStroke_15 = Instance.new("UIStroke"),
	UIStroke_16 = Instance.new("UIStroke"),
	UIGradient_6 = Instance.new("UIGradient"),
	ToggleTagEx = Instance.new("BillboardGui"),
	Toggle = Instance.new("TextButton"),
	UIStroke_17 = Instance.new("UIStroke"),
	KickedButton = Instance.new("TextButton"),
	SecondaryHUD = Instance.new("Frame"),
	Servers = Instance.new("Frame"),
	UICorner_16 = Instance.new("UICorner"),
	ServersTitleLabel = Instance.new("TextLabel"),
	TabsSelection = Instance.new("Frame"),
	FromGame = Instance.new("TextButton"),
	UICorner_17 = Instance.new("UICorner"),
	UIStroke_18 = Instance.new("UIStroke"),
	UIGridLayout = Instance.new("UIGridLayout"),
	Recent = Instance.new("TextButton"),
	UICorner_18 = Instance.new("UICorner"),
	UIStroke_19 = Instance.new("UIStroke"),
	Close = Instance.new("TextButton"),
	UICorner_19 = Instance.new("UICorner"),
	UIStroke_20 = Instance.new("UIStroke"),
	Friends = Instance.new("TextButton"),
	UICorner_20 = Instance.new("UICorner"),
	UIStroke_21 = Instance.new("UIStroke"),
	MainScroll = Instance.new("ScrollingFrame"),
	ServerEx = Instance.new("Frame"),
	ServerTitle = Instance.new("TextLabel"),
	TimeStamp = Instance.new("TextLabel"),
	SecondData = Instance.new("TextLabel"),
	UICorner_21 = Instance.new("UICorner"),
	UIStroke_22 = Instance.new("UIStroke"),
	UIGridLayout_2 = Instance.new("UIGridLayout"),
	BottomButtons = Instance.new("Frame"),
	Previous = Instance.new("TextButton"),
	UICorner_22 = Instance.new("UICorner"),
	UIStroke_23 = Instance.new("UIStroke"),
	UIGridLayout_3 = Instance.new("UIGridLayout"),
	Join = Instance.new("TextButton"),
	UICorner_23 = Instance.new("UICorner"),
	UIStroke_24 = Instance.new("UIStroke"),
	Next = Instance.new("TextButton"),
	UICorner_24 = Instance.new("UICorner"),
	UIStroke_25 = Instance.new("UIStroke"),
	ExtraLabel = Instance.new("TextLabel"),
	UICorner_25 = Instance.new("UICorner"),
	UIStroke_26 = Instance.new("UIStroke"),
	PromptFrame = Instance.new("Frame"),
	UICorner_26 = Instance.new("UICorner"),
	UIStroke_27 = Instance.new("UIStroke"),
	PromptTile = Instance.new("TextLabel"),
	PromptDesc = Instance.new("TextLabel"),
	PromptButtons = Instance.new("Frame"),
	UIGridLayout_4 = Instance.new("UIGridLayout"),
	Yes = Instance.new("TextButton"),
	UIStroke_28 = Instance.new("UIStroke"),
	UICorner_27 = Instance.new("UICorner"),
	No = Instance.new("TextButton"),
	UIStroke_29 = Instance.new("UIStroke"),
	UICorner_28 = Instance.new("UICorner"),
	Ok = Instance.new("TextButton"),
	UIStroke_30 = Instance.new("UIStroke"),
	UICorner_29 = Instance.new("UICorner"),
}

--Properties:

ToggleTagEx.SpecterGUI.Name = "SpecterGUI"
ToggleTagEx.SpecterGUI.DisplayOrder = -1
ToggleTagEx.SpecterGUI.ResetOnSpawn = false

ToggleTagEx.MainHUD.Name = "MainHUD"
ToggleTagEx.MainHUD.Parent = ToggleTagEx.SpecterGUI
ToggleTagEx.MainHUD.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.MainHUD.BackgroundTransparency = 1.000
ToggleTagEx.MainHUD.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.MainHUD.BorderSizePixel = 0
ToggleTagEx.MainHUD.Size = UDim2.new(1, 0, 1, 0)

ToggleTagEx.DropdownFrame.Name = "DropdownFrame"
ToggleTagEx.DropdownFrame.Parent = ToggleTagEx.MainHUD
ToggleTagEx.DropdownFrame.AutomaticSize = Enum.AutomaticSize.Y
ToggleTagEx.DropdownFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
ToggleTagEx.DropdownFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.DropdownFrame.BorderSizePixel = 0
ToggleTagEx.DropdownFrame.Position = UDim2.new(0, 532, 0, 332)
ToggleTagEx.DropdownFrame.Size = UDim2.new(0, 92, 0, 0)
ToggleTagEx.DropdownFrame.Visible = false
ToggleTagEx.DropdownFrame.ZIndex = 20

ToggleTagEx.UIListLayout.Parent = ToggleTagEx.DropdownFrame
ToggleTagEx.UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

ToggleTagEx.DropdownButtonEx.Name = "DropdownButtonEx"
ToggleTagEx.DropdownButtonEx.Parent = ToggleTagEx.DropdownFrame
ToggleTagEx.DropdownButtonEx.AnchorPoint = Vector2.new(1, 0.5)
ToggleTagEx.DropdownButtonEx.BackgroundColor3 = Color3.fromRGB(39, 39, 39)
ToggleTagEx.DropdownButtonEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.DropdownButtonEx.BorderSizePixel = 0
ToggleTagEx.DropdownButtonEx.Position = UDim2.new(0.970000029, 0, 0.5, 0)
ToggleTagEx.DropdownButtonEx.Size = UDim2.new(1, 0, 0, 30)
ToggleTagEx.DropdownButtonEx.ZIndex = 21
ToggleTagEx.DropdownButtonEx.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.DropdownButtonEx.Text = "God Mode"
ToggleTagEx.DropdownButtonEx.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.DropdownButtonEx.TextScaled = true
ToggleTagEx.DropdownButtonEx.TextSize = 14.000
ToggleTagEx.DropdownButtonEx.TextStrokeTransparency = 0.000
ToggleTagEx.DropdownButtonEx.TextWrapped = true

ToggleTagEx.UICorner.Parent = ToggleTagEx.DropdownButtonEx

ToggleTagEx.UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ToggleTagEx.UIStroke.Parent = ToggleTagEx.DropdownButtonEx

ToggleTagEx.CategoriesFrame.Name = "CategoriesFrame"
ToggleTagEx.CategoriesFrame.Parent = ToggleTagEx.MainHUD
ToggleTagEx.CategoriesFrame.Active = true
ToggleTagEx.CategoriesFrame.AutomaticSize = Enum.AutomaticSize.Y
ToggleTagEx.CategoriesFrame.BackgroundColor3 = Color3.fromRGB(39, 39, 39)
ToggleTagEx.CategoriesFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.CategoriesFrame.BorderSizePixel = 0
ToggleTagEx.CategoriesFrame.LayoutOrder = -15
ToggleTagEx.CategoriesFrame.Position = UDim2.new(0, 30, 0, 100)
ToggleTagEx.CategoriesFrame.Size = UDim2.new(0, 200, 0, 0)

ToggleTagEx.Buttons.Name = "Buttons"
ToggleTagEx.Buttons.Parent = ToggleTagEx.CategoriesFrame
ToggleTagEx.Buttons.AutomaticSize = Enum.AutomaticSize.Y
ToggleTagEx.Buttons.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.Buttons.BackgroundTransparency = 1.000
ToggleTagEx.Buttons.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.Buttons.BorderSizePixel = 0
ToggleTagEx.Buttons.Position = UDim2.new(0, 0, 0, 40)
ToggleTagEx.Buttons.Size = UDim2.new(1, 0, 0, 0)

ToggleTagEx.CategoryEx.Name = "CategoryEx"
ToggleTagEx.CategoryEx.Parent = ToggleTagEx.Buttons
ToggleTagEx.CategoryEx.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.CategoryEx.BackgroundTransparency = 1.000
ToggleTagEx.CategoryEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.CategoryEx.BorderSizePixel = 0
ToggleTagEx.CategoryEx.LayoutOrder = 1
ToggleTagEx.CategoryEx.Size = UDim2.new(1, 0, 0, 40)

ToggleTagEx.Image.Name = "Image"
ToggleTagEx.Image.Parent = ToggleTagEx.CategoryEx
ToggleTagEx.Image.Active = true
ToggleTagEx.Image.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.Image.BackgroundTransparency = 1.000
ToggleTagEx.Image.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.Image.BorderSizePixel = 0
ToggleTagEx.Image.Size = UDim2.new(0.150000006, 0, 1, 0)
ToggleTagEx.Image.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
ToggleTagEx.Image.ScaleType = Enum.ScaleType.Fit

ToggleTagEx.Text.Name = "Text"
ToggleTagEx.Text.Parent = ToggleTagEx.CategoryEx
ToggleTagEx.Text.Active = true
ToggleTagEx.Text.AnchorPoint = Vector2.new(0, 0.5)
ToggleTagEx.Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.Text.BackgroundTransparency = 1.000
ToggleTagEx.Text.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.Text.BorderSizePixel = 0
ToggleTagEx.Text.Position = UDim2.new(0.150000006, 0, 0.5, 0)
ToggleTagEx.Text.Size = UDim2.new(0.670000017, 0, 0.730000019, 0)
ToggleTagEx.Text.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.Text.Text = " Render"
ToggleTagEx.Text.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.Text.TextScaled = true
ToggleTagEx.Text.TextSize = 14.000
ToggleTagEx.Text.TextWrapped = true
ToggleTagEx.Text.TextXAlignment = Enum.TextXAlignment.Left

ToggleTagEx.Arrow.Name = "Arrow"
ToggleTagEx.Arrow.Parent = ToggleTagEx.CategoryEx
ToggleTagEx.Arrow.Active = true
ToggleTagEx.Arrow.AnchorPoint = Vector2.new(0, 0.5)
ToggleTagEx.Arrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.Arrow.BackgroundTransparency = 1.000
ToggleTagEx.Arrow.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.Arrow.BorderSizePixel = 0
ToggleTagEx.Arrow.Position = UDim2.new(0.779999971, 0, 0.5, 0)
ToggleTagEx.Arrow.Size = UDim2.new(0.199999779, 0, 0.730000138, 0)
ToggleTagEx.Arrow.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.Arrow.Text = ">"
ToggleTagEx.Arrow.TextColor3 = Color3.fromRGB(115, 115, 115)
ToggleTagEx.Arrow.TextScaled = true
ToggleTagEx.Arrow.TextSize = 14.000
ToggleTagEx.Arrow.TextWrapped = true

ToggleTagEx.BottomFrame.Name = "BottomFrame"
ToggleTagEx.BottomFrame.Parent = ToggleTagEx.Buttons
ToggleTagEx.BottomFrame.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
ToggleTagEx.BottomFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.BottomFrame.BorderSizePixel = 0
ToggleTagEx.BottomFrame.LayoutOrder = 12000
ToggleTagEx.BottomFrame.Size = UDim2.new(1, 0, 0, 40)

ToggleTagEx.SaveButton.Name = "SaveButton"
ToggleTagEx.SaveButton.Parent = ToggleTagEx.BottomFrame
ToggleTagEx.SaveButton.Active = true
ToggleTagEx.SaveButton.AnchorPoint = Vector2.new(0, 0.5)
ToggleTagEx.SaveButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.SaveButton.BackgroundTransparency = 1.000
ToggleTagEx.SaveButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.SaveButton.BorderSizePixel = 0
ToggleTagEx.SaveButton.Position = UDim2.new(0, 0, 0.5, 0)
ToggleTagEx.SaveButton.Size = UDim2.new(0.200000003, 0, 0.899999976, 0)
ToggleTagEx.SaveButton.Image = "rbxassetid://14737163568"
ToggleTagEx.SaveButton.ScaleType = Enum.ScaleType.Fit

ToggleTagEx.Wait.Name = "Wait"
ToggleTagEx.Wait.Parent = ToggleTagEx.SaveButton
ToggleTagEx.Wait.AnchorPoint = Vector2.new(0.5, 0.5)
ToggleTagEx.Wait.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.Wait.BackgroundTransparency = 1.000
ToggleTagEx.Wait.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.Wait.BorderSizePixel = 0
ToggleTagEx.Wait.Position = UDim2.new(0.5, 0, 0.5, 0)
ToggleTagEx.Wait.Size = UDim2.new(0.800000012, 0, 0.800000012, 0)
ToggleTagEx.Wait.Visible = false
ToggleTagEx.Wait.FontFace = Font.new("rbxasset://fonts/families/ComicNeueAngular.json",Enum.FontWeight.Regular,Enum.FontStyle.Normal)
ToggleTagEx.Wait.Text = "•••"
ToggleTagEx.Wait.TextColor3 = Color3.fromRGB(143, 143, 143)
ToggleTagEx.Wait.TextScaled = true
ToggleTagEx.Wait.TextSize = 40.000
ToggleTagEx.Wait.TextStrokeTransparency = 0.000
ToggleTagEx.Wait.TextWrapped = true

ToggleTagEx.UICorner_2.CornerRadius = UDim.new(2, 0)
ToggleTagEx.UICorner_2.Parent = ToggleTagEx.Wait

ToggleTagEx.UIListLayout_2.Parent = ToggleTagEx.Buttons
ToggleTagEx.UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder

ToggleTagEx.MiscDivider.Name = "MiscDivider"
ToggleTagEx.MiscDivider.Parent = ToggleTagEx.Buttons
ToggleTagEx.MiscDivider.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
ToggleTagEx.MiscDivider.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.MiscDivider.BorderSizePixel = 0
ToggleTagEx.MiscDivider.LayoutOrder = 2000
ToggleTagEx.MiscDivider.Size = UDim2.new(1, 0, 0, 24)

ToggleTagEx.MiscLabel.Name = "MiscLabel"
ToggleTagEx.MiscLabel.Parent = ToggleTagEx.MiscDivider
ToggleTagEx.MiscLabel.AnchorPoint = Vector2.new(0, 0.5)
ToggleTagEx.MiscLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.MiscLabel.BackgroundTransparency = 1.000
ToggleTagEx.MiscLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.MiscLabel.BorderSizePixel = 0
ToggleTagEx.MiscLabel.Position = UDim2.new(0.100000001, 0, 0.5, 0)
ToggleTagEx.MiscLabel.Size = UDim2.new(0.699999988, 0, 0.800000012, 0)
ToggleTagEx.MiscLabel.FontFace = Font.new("rbxasset://fonts/families/Nunito.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.MiscLabel.Text = "MISC"
ToggleTagEx.MiscLabel.TextColor3 = Color3.fromRGB(111, 111, 111)
ToggleTagEx.MiscLabel.TextScaled = true
ToggleTagEx.MiscLabel.TextSize = 14.000
ToggleTagEx.MiscLabel.TextStrokeTransparency = 0.000
ToggleTagEx.MiscLabel.TextWrapped = true
ToggleTagEx.MiscLabel.TextXAlignment = Enum.TextXAlignment.Left

ToggleTagEx.HeaderTab.Name = "HeaderTab"
ToggleTagEx.HeaderTab.Parent = ToggleTagEx.CategoriesFrame
ToggleTagEx.HeaderTab.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
ToggleTagEx.HeaderTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.HeaderTab.BorderSizePixel = 0
ToggleTagEx.HeaderTab.LayoutOrder = -20
ToggleTagEx.HeaderTab.Size = UDim2.new(1, 0, 0, 40)

ToggleTagEx.HeaderTitleLabel.Name = "HeaderTitleLabel"
ToggleTagEx.HeaderTitleLabel.Parent = ToggleTagEx.HeaderTab
ToggleTagEx.HeaderTitleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.HeaderTitleLabel.BackgroundTransparency = 1.000
ToggleTagEx.HeaderTitleLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.HeaderTitleLabel.BorderSizePixel = 0
ToggleTagEx.HeaderTitleLabel.Size = UDim2.new(0.600000024, 0, 1, 0)
ToggleTagEx.HeaderTitleLabel.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.HeaderTitleLabel.Text = " SPECTER"
ToggleTagEx.HeaderTitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.HeaderTitleLabel.TextScaled = true
ToggleTagEx.HeaderTitleLabel.TextSize = 14.000
ToggleTagEx.HeaderTitleLabel.TextStrokeTransparency = 0.000
ToggleTagEx.HeaderTitleLabel.TextWrapped = true
ToggleTagEx.HeaderTitleLabel.TextXAlignment = Enum.TextXAlignment.Left

ToggleTagEx.SettingsButton.Name = "SettingsButton"
ToggleTagEx.SettingsButton.Parent = ToggleTagEx.HeaderTab
ToggleTagEx.SettingsButton.AnchorPoint = Vector2.new(1, 0.5)
ToggleTagEx.SettingsButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.SettingsButton.BackgroundTransparency = 1.000
ToggleTagEx.SettingsButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.SettingsButton.BorderSizePixel = 0
ToggleTagEx.SettingsButton.Position = UDim2.new(0.980000019, 0, 0.5, 0)
ToggleTagEx.SettingsButton.Size = UDim2.new(0.200000003, 0, 0.800000012, 0)
ToggleTagEx.SettingsButton.ZIndex = 50
ToggleTagEx.SettingsButton.Image = "rbxassetid://14134158045"
ToggleTagEx.SettingsButton.ScaleType = Enum.ScaleType.Fit

ToggleTagEx.Settings.Name = "Settings"
ToggleTagEx.Settings.Parent = ToggleTagEx.CategoriesFrame
ToggleTagEx.Settings.AutomaticSize = Enum.AutomaticSize.Y
ToggleTagEx.Settings.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.Settings.BackgroundTransparency = 1.000
ToggleTagEx.Settings.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.Settings.BorderSizePixel = 0
ToggleTagEx.Settings.Position = UDim2.new(0, 0, 0, 40)
ToggleTagEx.Settings.Size = UDim2.new(1, 0, 0, 0)
ToggleTagEx.Settings.Visible = false

ToggleTagEx.SupportedFrame.Name = "SupportedFrame"
ToggleTagEx.SupportedFrame.Parent = ToggleTagEx.Settings
ToggleTagEx.SupportedFrame.AutomaticSize = Enum.AutomaticSize.Y
ToggleTagEx.SupportedFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.SupportedFrame.BackgroundTransparency = 1.000
ToggleTagEx.SupportedFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.SupportedFrame.BorderSizePixel = 0
ToggleTagEx.SupportedFrame.LayoutOrder = 1
ToggleTagEx.SupportedFrame.Size = UDim2.new(1, 0, 0, 0)

ToggleTagEx.Image_2.Name = "Image"
ToggleTagEx.Image_2.Parent = ToggleTagEx.SupportedFrame
ToggleTagEx.Image_2.Active = true
ToggleTagEx.Image_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.Image_2.BackgroundTransparency = 1.000
ToggleTagEx.Image_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.Image_2.BorderSizePixel = 0
ToggleTagEx.Image_2.Size = UDim2.new(0.150000006, 0, 1, 0)
ToggleTagEx.Image_2.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
ToggleTagEx.Image_2.ScaleType = Enum.ScaleType.Fit

ToggleTagEx.Description.Name = "Description"
ToggleTagEx.Description.Parent = ToggleTagEx.SupportedFrame
ToggleTagEx.Description.Active = true
ToggleTagEx.Description.AutomaticSize = Enum.AutomaticSize.Y
ToggleTagEx.Description.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.Description.BackgroundTransparency = 1.000
ToggleTagEx.Description.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.Description.BorderSizePixel = 0
ToggleTagEx.Description.Position = UDim2.new(0.150000006, 0, 0, 20)
ToggleTagEx.Description.Size = UDim2.new(0.790000021, 0, 0, 0)
ToggleTagEx.Description.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.Description.Text = " Render"
ToggleTagEx.Description.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.Description.TextSize = 14.000
ToggleTagEx.Description.TextWrapped = true
ToggleTagEx.Description.TextXAlignment = Enum.TextXAlignment.Left

ToggleTagEx.Supported.Name = "Supported"
ToggleTagEx.Supported.Parent = ToggleTagEx.SupportedFrame
ToggleTagEx.Supported.Active = true
ToggleTagEx.Supported.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.Supported.BackgroundTransparency = 1.000
ToggleTagEx.Supported.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.Supported.BorderSizePixel = 0
ToggleTagEx.Supported.Position = UDim2.new(0.150000006, 0, 0, 0)
ToggleTagEx.Supported.Size = UDim2.new(0.790000021, 0, 0, 20)
ToggleTagEx.Supported.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.Supported.Text = "Supported Game"
ToggleTagEx.Supported.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.Supported.TextScaled = true
ToggleTagEx.Supported.TextSize = 14.000
ToggleTagEx.Supported.TextWrapped = true
ToggleTagEx.Supported.TextXAlignment = Enum.TextXAlignment.Left

ToggleTagEx.BottomFrame_2.Name = "BottomFrame"
ToggleTagEx.BottomFrame_2.Parent = ToggleTagEx.Settings
ToggleTagEx.BottomFrame_2.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
ToggleTagEx.BottomFrame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.BottomFrame_2.BorderSizePixel = 0
ToggleTagEx.BottomFrame_2.LayoutOrder = 50
ToggleTagEx.BottomFrame_2.Size = UDim2.new(1, 0, 0, 40)

ToggleTagEx.RefreshButton.Name = "RefreshButton"
ToggleTagEx.RefreshButton.Parent = ToggleTagEx.BottomFrame_2
ToggleTagEx.RefreshButton.Active = true
ToggleTagEx.RefreshButton.AnchorPoint = Vector2.new(1, 0.5)
ToggleTagEx.RefreshButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
ToggleTagEx.RefreshButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.RefreshButton.BorderSizePixel = 0
ToggleTagEx.RefreshButton.Position = UDim2.new(1, -1, 0.5, 0)
ToggleTagEx.RefreshButton.Size = UDim2.new(0, 36, 0, 36)
ToggleTagEx.RefreshButton.Image = "rbxassetid://13492317101"
ToggleTagEx.RefreshButton.ScaleType = Enum.ScaleType.Fit

ToggleTagEx.UICorner_3.CornerRadius = UDim.new(0, 999)
ToggleTagEx.UICorner_3.Parent = ToggleTagEx.RefreshButton

ToggleTagEx.UIStroke_2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ToggleTagEx.UIStroke_2.Parent = ToggleTagEx.RefreshButton

ToggleTagEx.UIListLayout_3.Parent = ToggleTagEx.Settings
ToggleTagEx.UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder

ToggleTagEx.HackDivider.Name = "HackDivider"
ToggleTagEx.HackDivider.Parent = ToggleTagEx.Settings
ToggleTagEx.HackDivider.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
ToggleTagEx.HackDivider.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.HackDivider.BorderSizePixel = 0
ToggleTagEx.HackDivider.LayoutOrder = 20
ToggleTagEx.HackDivider.Size = UDim2.new(1, 0, 0, 24)

ToggleTagEx.HackLabel.Name = "HackLabel"
ToggleTagEx.HackLabel.Parent = ToggleTagEx.HackDivider
ToggleTagEx.HackLabel.AnchorPoint = Vector2.new(0, 0.5)
ToggleTagEx.HackLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.HackLabel.BackgroundTransparency = 1.000
ToggleTagEx.HackLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.HackLabel.BorderSizePixel = 0
ToggleTagEx.HackLabel.Position = UDim2.new(0.100000001, 0, 0.5, 0)
ToggleTagEx.HackLabel.Size = UDim2.new(0.699999988, 0, 0.800000012, 0)
ToggleTagEx.HackLabel.FontFace = Font.new("rbxasset://fonts/families/Nunito.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.HackLabel.Text = "HACK"
ToggleTagEx.HackLabel.TextColor3 = Color3.fromRGB(111, 111, 111)
ToggleTagEx.HackLabel.TextScaled = true
ToggleTagEx.HackLabel.TextSize = 14.000
ToggleTagEx.HackLabel.TextStrokeTransparency = 0.000
ToggleTagEx.HackLabel.TextWrapped = true
ToggleTagEx.HackLabel.TextXAlignment = Enum.TextXAlignment.Left

ToggleTagEx.GameDivider.Name = "GameDivider"
ToggleTagEx.GameDivider.Parent = ToggleTagEx.Settings
ToggleTagEx.GameDivider.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
ToggleTagEx.GameDivider.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.GameDivider.BorderSizePixel = 0
ToggleTagEx.GameDivider.LayoutOrder = -20
ToggleTagEx.GameDivider.Size = UDim2.new(1, 0, 0, 24)

ToggleTagEx.GameLabel.Name = "GameLabel"
ToggleTagEx.GameLabel.Parent = ToggleTagEx.GameDivider
ToggleTagEx.GameLabel.AnchorPoint = Vector2.new(0, 0.5)
ToggleTagEx.GameLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.GameLabel.BackgroundTransparency = 1.000
ToggleTagEx.GameLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.GameLabel.BorderSizePixel = 0
ToggleTagEx.GameLabel.Position = UDim2.new(0.100000001, 0, 0.5, 0)
ToggleTagEx.GameLabel.Size = UDim2.new(0.699999988, 0, 0.800000012, 0)
ToggleTagEx.GameLabel.FontFace = Font.new("rbxasset://fonts/families/Nunito.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.GameLabel.Text = "GAME"
ToggleTagEx.GameLabel.TextColor3 = Color3.fromRGB(111, 111, 111)
ToggleTagEx.GameLabel.TextScaled = true
ToggleTagEx.GameLabel.TextSize = 14.000
ToggleTagEx.GameLabel.TextStrokeTransparency = 0.000
ToggleTagEx.GameLabel.TextWrapped = true
ToggleTagEx.GameLabel.TextXAlignment = Enum.TextXAlignment.Left

ToggleTagEx.ScrollTab.Name = "ScrollTab"
ToggleTagEx.ScrollTab.Parent = ToggleTagEx.Settings
ToggleTagEx.ScrollTab.AutomaticSize = Enum.AutomaticSize.Y
ToggleTagEx.ScrollTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.ScrollTab.BackgroundTransparency = 1.000
ToggleTagEx.ScrollTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.ScrollTab.BorderSizePixel = 0
ToggleTagEx.ScrollTab.LayoutOrder = 40
ToggleTagEx.ScrollTab.Position = UDim2.new(0, 0, 0, 45)
ToggleTagEx.ScrollTab.Size = UDim2.new(1, 0, 0, 0)
ToggleTagEx.ScrollTab.ZIndex = 0
ToggleTagEx.ScrollTab.AutomaticCanvasSize = Enum.AutomaticSize.Y
ToggleTagEx.ScrollTab.BottomImage = "rbxassetid://3062505976"
ToggleTagEx.ScrollTab.CanvasSize = UDim2.new(0, 0, 0, 0)
ToggleTagEx.ScrollTab.MidImage = "rbxassetid://3062506202"
ToggleTagEx.ScrollTab.TopImage = "rbxassetid://3062506445"
ToggleTagEx.ScrollTab.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar

ToggleTagEx.UIListLayout_4.Parent = ToggleTagEx.ScrollTab
ToggleTagEx.UIListLayout_4.SortOrder = Enum.SortOrder.LayoutOrder

ToggleTagEx.TabsFrame.Name = "TabsFrame"
ToggleTagEx.TabsFrame.Parent = ToggleTagEx.MainHUD
ToggleTagEx.TabsFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.TabsFrame.BackgroundTransparency = 1.000
ToggleTagEx.TabsFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.TabsFrame.BorderSizePixel = 0
ToggleTagEx.TabsFrame.LayoutOrder = -15
ToggleTagEx.TabsFrame.Size = UDim2.new(1, 0, 1, 0)
ToggleTagEx.TabsFrame.ZIndex = -15

ToggleTagEx.TabEx.Name = "TabEx"
ToggleTagEx.TabEx.Parent = ToggleTagEx.TabsFrame
ToggleTagEx.TabEx.BackgroundColor3 = Color3.fromRGB(39, 39, 39)
ToggleTagEx.TabEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.TabEx.BorderSizePixel = 0
ToggleTagEx.TabEx.LayoutOrder = -14
ToggleTagEx.TabEx.Position = UDim2.new(0, 400, 0, 100)
ToggleTagEx.TabEx.Size = UDim2.new(0, 230, 0, 400)
ToggleTagEx.TabEx.ZIndex = -14

ToggleTagEx.HeaderTab_2.Name = "HeaderTab"
ToggleTagEx.HeaderTab_2.Parent = ToggleTagEx.TabEx
ToggleTagEx.HeaderTab_2.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
ToggleTagEx.HeaderTab_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.HeaderTab_2.BorderSizePixel = 0
ToggleTagEx.HeaderTab_2.LayoutOrder = -13
ToggleTagEx.HeaderTab_2.Size = UDim2.new(1, 0, 0, 45)
ToggleTagEx.HeaderTab_2.ZIndex = -13

ToggleTagEx.HeaderTitleLabel_2.Name = "HeaderTitleLabel"
ToggleTagEx.HeaderTitleLabel_2.Parent = ToggleTagEx.HeaderTab_2
ToggleTagEx.HeaderTitleLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.HeaderTitleLabel_2.BackgroundTransparency = 1.000
ToggleTagEx.HeaderTitleLabel_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.HeaderTitleLabel_2.BorderSizePixel = 0
ToggleTagEx.HeaderTitleLabel_2.LayoutOrder = -12
ToggleTagEx.HeaderTitleLabel_2.Size = UDim2.new(0.600000024, 0, 1, 0)
ToggleTagEx.HeaderTitleLabel_2.Visible = false
ToggleTagEx.HeaderTitleLabel_2.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.HeaderTitleLabel_2.Text = " SPECTER"
ToggleTagEx.HeaderTitleLabel_2.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.HeaderTitleLabel_2.TextScaled = true
ToggleTagEx.HeaderTitleLabel_2.TextSize = 14.000
ToggleTagEx.HeaderTitleLabel_2.TextStrokeTransparency = 0.000
ToggleTagEx.HeaderTitleLabel_2.TextWrapped = true
ToggleTagEx.HeaderTitleLabel_2.TextXAlignment = Enum.TextXAlignment.Left

ToggleTagEx.DropDownButton.Name = "DropDownButton"
ToggleTagEx.DropDownButton.Parent = ToggleTagEx.HeaderTab_2
ToggleTagEx.DropDownButton.AnchorPoint = Vector2.new(1, 0.5)
ToggleTagEx.DropDownButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.DropDownButton.BackgroundTransparency = 1.000
ToggleTagEx.DropDownButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.DropDownButton.BorderSizePixel = 0
ToggleTagEx.DropDownButton.LayoutOrder = -12
ToggleTagEx.DropDownButton.Position = UDim2.new(0.980000019, 0, 0.5, 0)
ToggleTagEx.DropDownButton.Size = UDim2.new(0.200000003, 0, 0.5, 0)
ToggleTagEx.DropDownButton.Image = "rbxassetid://14569017448"
ToggleTagEx.DropDownButton.ScaleType = Enum.ScaleType.Fit

ToggleTagEx.Text_2.Name = "Text"
ToggleTagEx.Text_2.Parent = ToggleTagEx.HeaderTab_2
ToggleTagEx.Text_2.AnchorPoint = Vector2.new(0, 0.5)
ToggleTagEx.Text_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.Text_2.BackgroundTransparency = 1.000
ToggleTagEx.Text_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.Text_2.BorderSizePixel = 0
ToggleTagEx.Text_2.LayoutOrder = -12
ToggleTagEx.Text_2.Position = UDim2.new(0.150000036, 0, 0.5, 0)
ToggleTagEx.Text_2.Size = UDim2.new(0.629999697, 0, 0.730000138, 0)
ToggleTagEx.Text_2.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.Text_2.Text = " Render"
ToggleTagEx.Text_2.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.Text_2.TextScaled = true
ToggleTagEx.Text_2.TextSize = 14.000
ToggleTagEx.Text_2.TextWrapped = true
ToggleTagEx.Text_2.TextXAlignment = Enum.TextXAlignment.Left

ToggleTagEx.Image_3.Name = "Image"
ToggleTagEx.Image_3.Parent = ToggleTagEx.HeaderTab_2
ToggleTagEx.Image_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.Image_3.BackgroundTransparency = 1.000
ToggleTagEx.Image_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.Image_3.BorderSizePixel = 0
ToggleTagEx.Image_3.LayoutOrder = -12
ToggleTagEx.Image_3.Size = UDim2.new(0.150000006, 0, 1, 0)
ToggleTagEx.Image_3.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
ToggleTagEx.Image_3.ScaleType = Enum.ScaleType.Fit

ToggleTagEx.ScrollTab_2.Name = "ScrollTab"
ToggleTagEx.ScrollTab_2.Parent = ToggleTagEx.TabEx
ToggleTagEx.ScrollTab_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.ScrollTab_2.BackgroundTransparency = 1.000
ToggleTagEx.ScrollTab_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.ScrollTab_2.BorderSizePixel = 0
ToggleTagEx.ScrollTab_2.LayoutOrder = -13
ToggleTagEx.ScrollTab_2.Position = UDim2.new(0, 0, 0, 45)
ToggleTagEx.ScrollTab_2.Size = UDim2.new(1, 0, 0, 300)
ToggleTagEx.ScrollTab_2.ZIndex = 0
ToggleTagEx.ScrollTab_2.AutomaticCanvasSize = Enum.AutomaticSize.Y
ToggleTagEx.ScrollTab_2.BottomImage = "rbxassetid://3062505976"
ToggleTagEx.ScrollTab_2.CanvasSize = UDim2.new(0, 0, 0, 0)
ToggleTagEx.ScrollTab_2.MidImage = "rbxassetid://3062506202"
ToggleTagEx.ScrollTab_2.TopImage = "rbxassetid://3062506445"
ToggleTagEx.ScrollTab_2.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar

ToggleTagEx.UIListLayout_5.Parent = ToggleTagEx.ScrollTab_2
ToggleTagEx.UIListLayout_5.SortOrder = Enum.SortOrder.LayoutOrder

ToggleTagEx.HackButtonEx.Name = "HackButtonEx"
ToggleTagEx.HackButtonEx.Parent = ToggleTagEx.ScrollTab_2
ToggleTagEx.HackButtonEx.AutomaticSize = Enum.AutomaticSize.Y
ToggleTagEx.HackButtonEx.BackgroundColor3 = Color3.fromRGB(39, 39, 39)
ToggleTagEx.HackButtonEx.BackgroundTransparency = 1.000
ToggleTagEx.HackButtonEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.HackButtonEx.BorderSizePixel = 0
ToggleTagEx.HackButtonEx.LayoutOrder = -12
ToggleTagEx.HackButtonEx.Size = UDim2.new(1, 0, 0, 0)

ToggleTagEx.HackText.Name = "HackText"
ToggleTagEx.HackText.Parent = ToggleTagEx.HackButtonEx
ToggleTagEx.HackText.Active = true
ToggleTagEx.HackText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.HackText.BackgroundTransparency = 1.000
ToggleTagEx.HackText.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.HackText.BorderSizePixel = 0
ToggleTagEx.HackText.Position = UDim2.new(0.0500000007, 0, 0, 0)
ToggleTagEx.HackText.Size = UDim2.new(0.649999976, 0, 0, 40)
ToggleTagEx.HackText.ZIndex = 2
ToggleTagEx.HackText.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.HackText.Text = "AimAssist"
ToggleTagEx.HackText.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.HackText.TextScaled = true
ToggleTagEx.HackText.TextSize = 14.000
ToggleTagEx.HackText.TextStrokeTransparency = 0.000
ToggleTagEx.HackText.TextWrapped = true
ToggleTagEx.HackText.TextXAlignment = Enum.TextXAlignment.Left

ToggleTagEx.HackExpand.Name = "HackExpand"
ToggleTagEx.HackExpand.Parent = ToggleTagEx.HackButtonEx
ToggleTagEx.HackExpand.Active = false
ToggleTagEx.HackExpand.AnchorPoint = Vector2.new(1, 0.5)
ToggleTagEx.HackExpand.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.HackExpand.BackgroundTransparency = 1.000
ToggleTagEx.HackExpand.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.HackExpand.BorderSizePixel = 0
ToggleTagEx.HackExpand.Position = UDim2.new(1, 0, 0, 20)
ToggleTagEx.HackExpand.Selectable = false
ToggleTagEx.HackExpand.Size = UDim2.new(0, 31, 0, 40)
ToggleTagEx.HackExpand.ZIndex = 3
ToggleTagEx.HackExpand.Image = "rbxassetid://12809025337"
ToggleTagEx.HackExpand.ScaleType = Enum.ScaleType.Fit

ToggleTagEx.OptionsList.Name = "OptionsList"
ToggleTagEx.OptionsList.Parent = ToggleTagEx.HackButtonEx
ToggleTagEx.OptionsList.AutomaticSize = Enum.AutomaticSize.Y
ToggleTagEx.OptionsList.BackgroundColor3 = Color3.fromRGB(58, 58, 58)
ToggleTagEx.OptionsList.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.OptionsList.BorderSizePixel = 0
ToggleTagEx.OptionsList.Position = UDim2.new(0, 0, 0, 40)
ToggleTagEx.OptionsList.Size = UDim2.new(1, 0, 0, 0)
ToggleTagEx.OptionsList.ZIndex = 2

ToggleTagEx.UIListLayout_6.Parent = ToggleTagEx.OptionsList
ToggleTagEx.UIListLayout_6.HorizontalAlignment = Enum.HorizontalAlignment.Center
ToggleTagEx.UIListLayout_6.SortOrder = Enum.SortOrder.LayoutOrder
ToggleTagEx.UIListLayout_6.Padding = UDim.new(0, 1)

ToggleTagEx.ToggleEx.Name = "ToggleEx"
ToggleTagEx.ToggleEx.Parent = ToggleTagEx.OptionsList
ToggleTagEx.ToggleEx.BackgroundColor3 = Color3.fromRGB(0, 255, 102)
ToggleTagEx.ToggleEx.BackgroundTransparency = 1.000
ToggleTagEx.ToggleEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.ToggleEx.BorderSizePixel = 0
ToggleTagEx.ToggleEx.Size = UDim2.new(1, 0, 0, 40)

ToggleTagEx.NameTL.Name = "NameTL"
ToggleTagEx.NameTL.Parent = ToggleTagEx.ToggleEx
ToggleTagEx.NameTL.Active = true
ToggleTagEx.NameTL.AnchorPoint = Vector2.new(0, 0.5)
ToggleTagEx.NameTL.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.NameTL.BackgroundTransparency = 1.000
ToggleTagEx.NameTL.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.NameTL.BorderSizePixel = 0
ToggleTagEx.NameTL.Position = UDim2.new(0.0500000007, 0, 0.5, 0)
ToggleTagEx.NameTL.Size = UDim2.new(0.600000024, 0, 0, 30)
ToggleTagEx.NameTL.ZIndex = 2
ToggleTagEx.NameTL.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.NameTL.Text = "AimAssist"
ToggleTagEx.NameTL.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.NameTL.TextScaled = true
ToggleTagEx.NameTL.TextSize = 14.000
ToggleTagEx.NameTL.TextStrokeTransparency = 0.000
ToggleTagEx.NameTL.TextWrapped = true
ToggleTagEx.NameTL.TextXAlignment = Enum.TextXAlignment.Left

ToggleTagEx.ToggleSwitchSlider.Name = "ToggleSwitchSlider"
ToggleTagEx.ToggleSwitchSlider.Parent = ToggleTagEx.ToggleEx
ToggleTagEx.ToggleSwitchSlider.Active = false
ToggleTagEx.ToggleSwitchSlider.AnchorPoint = Vector2.new(1, 0.5)
ToggleTagEx.ToggleSwitchSlider.BackgroundColor3 = Color3.fromRGB(113, 113, 113)
ToggleTagEx.ToggleSwitchSlider.BorderColor3 = Color3.fromRGB(27, 42, 53)
ToggleTagEx.ToggleSwitchSlider.Position = UDim2.new(0.949999988, 0, 0.5, 0)
ToggleTagEx.ToggleSwitchSlider.Selectable = false
ToggleTagEx.ToggleSwitchSlider.Size = UDim2.new(0.25, 0, 0.600000024, 0)
ToggleTagEx.ToggleSwitchSlider.ZIndex = 2
ToggleTagEx.ToggleSwitchSlider.AutoButtonColor = false

ToggleTagEx.UICorner_4.CornerRadius = UDim.new(1, 0)
ToggleTagEx.UICorner_4.Parent = ToggleTagEx.ToggleSwitchSlider

ToggleTagEx.ToggleCircle.Name = "ToggleCircle"
ToggleTagEx.ToggleCircle.Parent = ToggleTagEx.ToggleSwitchSlider
ToggleTagEx.ToggleCircle.Active = true
ToggleTagEx.ToggleCircle.AnchorPoint = Vector2.new(0, 0.5)
ToggleTagEx.ToggleCircle.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
ToggleTagEx.ToggleCircle.BorderColor3 = Color3.fromRGB(27, 42, 53)
ToggleTagEx.ToggleCircle.Position = UDim2.new(0.603999972, 0, 0.5, 0)
ToggleTagEx.ToggleCircle.Size = UDim2.new(0.345999986, 0, 0.649999976, 0)
ToggleTagEx.ToggleCircle.ZIndex = 3

ToggleTagEx.UICorner_5.CornerRadius = UDim.new(0, 100)
ToggleTagEx.UICorner_5.Parent = ToggleTagEx.ToggleCircle

ToggleTagEx.UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(83, 83, 83))}
ToggleTagEx.UIGradient.Rotation = 90
ToggleTagEx.UIGradient.Parent = ToggleTagEx.ToggleCircle

ToggleTagEx.UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(83, 83, 83))}
ToggleTagEx.UIGradient_2.Rotation = 90
ToggleTagEx.UIGradient_2.Parent = ToggleTagEx.ToggleSwitchSlider

ToggleTagEx.UIStroke_3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ToggleTagEx.UIStroke_3.Parent = ToggleTagEx.ToggleEx

ToggleTagEx.SliderEx.Name = "SliderEx"
ToggleTagEx.SliderEx.Parent = ToggleTagEx.OptionsList
ToggleTagEx.SliderEx.BackgroundColor3 = Color3.fromRGB(0, 255, 102)
ToggleTagEx.SliderEx.BackgroundTransparency = 1.000
ToggleTagEx.SliderEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.SliderEx.BorderSizePixel = 0
ToggleTagEx.SliderEx.Size = UDim2.new(1, 0, 0, 60)

ToggleTagEx.NameTL_2.Name = "NameTL"
ToggleTagEx.NameTL_2.Parent = ToggleTagEx.SliderEx
ToggleTagEx.NameTL_2.Active = true
ToggleTagEx.NameTL_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.NameTL_2.BackgroundTransparency = 1.000
ToggleTagEx.NameTL_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.NameTL_2.BorderSizePixel = 0
ToggleTagEx.NameTL_2.Position = UDim2.new(0.0500000007, 0, 0, 0)
ToggleTagEx.NameTL_2.Size = UDim2.new(0.600000024, 0, 0, 30)
ToggleTagEx.NameTL_2.ZIndex = 2
ToggleTagEx.NameTL_2.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.NameTL_2.Text = "Range"
ToggleTagEx.NameTL_2.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.NameTL_2.TextScaled = true
ToggleTagEx.NameTL_2.TextSize = 14.000
ToggleTagEx.NameTL_2.TextStrokeTransparency = 0.000
ToggleTagEx.NameTL_2.TextWrapped = true
ToggleTagEx.NameTL_2.TextXAlignment = Enum.TextXAlignment.Left

ToggleTagEx.SlidingBar.Name = "SlidingBar"
ToggleTagEx.SlidingBar.Parent = ToggleTagEx.SliderEx
ToggleTagEx.SlidingBar.AnchorPoint = Vector2.new(0.5, 1)
ToggleTagEx.SlidingBar.BackgroundColor3 = Color3.fromRGB(44, 44, 44)
ToggleTagEx.SlidingBar.BorderColor3 = Color3.fromRGB(27, 42, 53)
ToggleTagEx.SlidingBar.Position = UDim2.new(0.5, 0, 0.879999995, 0)
ToggleTagEx.SlidingBar.Selectable = false
ToggleTagEx.SlidingBar.Size = UDim2.new(0.699999988, 0, 0, 15)
ToggleTagEx.SlidingBar.ZIndex = 2
ToggleTagEx.SlidingBar.AutoButtonColor = false

ToggleTagEx.UICorner_6.CornerRadius = UDim.new(1, 0)
ToggleTagEx.UICorner_6.Parent = ToggleTagEx.SlidingBar

ToggleTagEx.CurrentPosition.Name = "CurrentPosition"
ToggleTagEx.CurrentPosition.Parent = ToggleTagEx.SlidingBar
ToggleTagEx.CurrentPosition.Active = true
ToggleTagEx.CurrentPosition.AnchorPoint = Vector2.new(0.5, 0.5)
ToggleTagEx.CurrentPosition.BackgroundColor3 = Color3.fromRGB(89, 89, 89)
ToggleTagEx.CurrentPosition.BorderColor3 = Color3.fromRGB(27, 42, 53)
ToggleTagEx.CurrentPosition.Position = UDim2.new(0.200000003, 0, 0.5, 0)
ToggleTagEx.CurrentPosition.Size = UDim2.new(0.100000001, 0, 1, 0)
ToggleTagEx.CurrentPosition.ZIndex = 3

ToggleTagEx.UICorner_7.CornerRadius = UDim.new(0, 100)
ToggleTagEx.UICorner_7.Parent = ToggleTagEx.CurrentPosition

ToggleTagEx.UIGradient_3.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(83, 83, 83))}
ToggleTagEx.UIGradient_3.Rotation = 90
ToggleTagEx.UIGradient_3.Parent = ToggleTagEx.CurrentPosition

ToggleTagEx.UIGradient_4.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(83, 83, 83))}
ToggleTagEx.UIGradient_4.Rotation = 90
ToggleTagEx.UIGradient_4.Parent = ToggleTagEx.SlidingBar

ToggleTagEx.Backing.Name = "Backing"
ToggleTagEx.Backing.Parent = ToggleTagEx.SlidingBar
ToggleTagEx.Backing.AnchorPoint = Vector2.new(0.5, 0.5)
ToggleTagEx.Backing.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.Backing.BackgroundTransparency = 1.000
ToggleTagEx.Backing.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.Backing.BorderSizePixel = 0
ToggleTagEx.Backing.Position = UDim2.new(0.5, 0, 0.5, 0)
ToggleTagEx.Backing.Size = UDim2.new(1.29999995, 0, 1.70000005, 0)
ToggleTagEx.Backing.ZIndex = 9

ToggleTagEx.Track.Name = "Track"
ToggleTagEx.Track.Parent = ToggleTagEx.SlidingBar
ToggleTagEx.Track.AnchorPoint = Vector2.new(0.5, 0.5)
ToggleTagEx.Track.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.Track.BackgroundTransparency = 1.000
ToggleTagEx.Track.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.Track.BorderSizePixel = 0
ToggleTagEx.Track.Position = UDim2.new(0.5, 0, 0.5, 0)
ToggleTagEx.Track.Size = UDim2.new(0.899999976, 0, 0.100000001, 0)
ToggleTagEx.Track.ZIndex = 9

ToggleTagEx.ForceTB.Name = "ForceTB"
ToggleTagEx.ForceTB.Parent = ToggleTagEx.SliderEx
ToggleTagEx.ForceTB.AnchorPoint = Vector2.new(1, 0)
ToggleTagEx.ForceTB.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.ForceTB.BackgroundTransparency = 1.000
ToggleTagEx.ForceTB.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.ForceTB.BorderSizePixel = 0
ToggleTagEx.ForceTB.Position = UDim2.new(1, 0, 0, 0)
ToggleTagEx.ForceTB.Size = UDim2.new(0.300000012, 0, 0, 30)
ToggleTagEx.ForceTB.ZIndex = 3
ToggleTagEx.ForceTB.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.ForceTB.Text = ""
ToggleTagEx.ForceTB.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.ForceTB.TextScaled = true
ToggleTagEx.ForceTB.TextSize = 14.000
ToggleTagEx.ForceTB.TextStrokeTransparency = 0.000
ToggleTagEx.ForceTB.TextWrapped = true

ToggleTagEx.TBUnderbar.Name = "TBUnderbar"
ToggleTagEx.TBUnderbar.Parent = ToggleTagEx.ForceTB
ToggleTagEx.TBUnderbar.AnchorPoint = Vector2.new(0.5, 1)
ToggleTagEx.TBUnderbar.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
ToggleTagEx.TBUnderbar.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.TBUnderbar.BorderSizePixel = 0
ToggleTagEx.TBUnderbar.Position = UDim2.new(0.5, 0, 0.959999979, 0)
ToggleTagEx.TBUnderbar.Size = UDim2.new(0.400000006, 0, 0, 1)

ToggleTagEx.LeftBound.Name = "LeftBound"
ToggleTagEx.LeftBound.Parent = ToggleTagEx.SliderEx
ToggleTagEx.LeftBound.Active = true
ToggleTagEx.LeftBound.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.LeftBound.BackgroundTransparency = 1.000
ToggleTagEx.LeftBound.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.LeftBound.BorderSizePixel = 0
ToggleTagEx.LeftBound.Position = UDim2.new(0.0500000007, 0, 0.629999995, 0)
ToggleTagEx.LeftBound.Size = UDim2.new(0.100000001, 0, -0.25, 30)
ToggleTagEx.LeftBound.ZIndex = 2
ToggleTagEx.LeftBound.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.LeftBound.Text = "30"
ToggleTagEx.LeftBound.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.LeftBound.TextScaled = true
ToggleTagEx.LeftBound.TextSize = 14.000
ToggleTagEx.LeftBound.TextStrokeTransparency = 0.000
ToggleTagEx.LeftBound.TextWrapped = true

ToggleTagEx.RightBound.Name = "RightBound"
ToggleTagEx.RightBound.Parent = ToggleTagEx.SliderEx
ToggleTagEx.RightBound.Active = true
ToggleTagEx.RightBound.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.RightBound.BackgroundTransparency = 1.000
ToggleTagEx.RightBound.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.RightBound.BorderSizePixel = 0
ToggleTagEx.RightBound.Position = UDim2.new(0.850000024, 0, 0.629999995, 0)
ToggleTagEx.RightBound.Size = UDim2.new(0.100000001, 0, -0.25, 30)
ToggleTagEx.RightBound.ZIndex = 2
ToggleTagEx.RightBound.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.RightBound.Text = "100"
ToggleTagEx.RightBound.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.RightBound.TextScaled = true
ToggleTagEx.RightBound.TextSize = 14.000
ToggleTagEx.RightBound.TextStrokeTransparency = 0.000
ToggleTagEx.RightBound.TextWrapped = true

ToggleTagEx.UIStroke_4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ToggleTagEx.UIStroke_4.Parent = ToggleTagEx.SliderEx

ToggleTagEx.DropdownEx.Name = "DropdownEx"
ToggleTagEx.DropdownEx.Parent = ToggleTagEx.OptionsList
ToggleTagEx.DropdownEx.BackgroundColor3 = Color3.fromRGB(0, 255, 102)
ToggleTagEx.DropdownEx.BackgroundTransparency = 1.000
ToggleTagEx.DropdownEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.DropdownEx.BorderSizePixel = 0
ToggleTagEx.DropdownEx.Size = UDim2.new(1, 0, 0, 40)

ToggleTagEx.NameTL_3.Name = "NameTL"
ToggleTagEx.NameTL_3.Parent = ToggleTagEx.DropdownEx
ToggleTagEx.NameTL_3.Active = true
ToggleTagEx.NameTL_3.AnchorPoint = Vector2.new(0, 0.5)
ToggleTagEx.NameTL_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.NameTL_3.BackgroundTransparency = 1.000
ToggleTagEx.NameTL_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.NameTL_3.BorderSizePixel = 0
ToggleTagEx.NameTL_3.Position = UDim2.new(0.0500000007, 0, 0.5, 0)
ToggleTagEx.NameTL_3.Size = UDim2.new(0.5, 0, 0, 30)
ToggleTagEx.NameTL_3.ZIndex = 2
ToggleTagEx.NameTL_3.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.NameTL_3.Text = "AimAssist"
ToggleTagEx.NameTL_3.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.NameTL_3.TextScaled = true
ToggleTagEx.NameTL_3.TextSize = 14.000
ToggleTagEx.NameTL_3.TextStrokeTransparency = 0.000
ToggleTagEx.NameTL_3.TextWrapped = true
ToggleTagEx.NameTL_3.TextXAlignment = Enum.TextXAlignment.Left

ToggleTagEx.UIStroke_5.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ToggleTagEx.UIStroke_5.Parent = ToggleTagEx.DropdownEx

ToggleTagEx.DropdownButton.Name = "DropdownButton"
ToggleTagEx.DropdownButton.Parent = ToggleTagEx.DropdownEx
ToggleTagEx.DropdownButton.AnchorPoint = Vector2.new(1, 0.5)
ToggleTagEx.DropdownButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ToggleTagEx.DropdownButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.DropdownButton.BorderSizePixel = 0
ToggleTagEx.DropdownButton.Position = UDim2.new(0.970000029, 0, 0.5, 0)
ToggleTagEx.DropdownButton.Size = UDim2.new(0.400000006, 0, 0, 30)
ToggleTagEx.DropdownButton.ZIndex = 2
ToggleTagEx.DropdownButton.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.DropdownButton.Text = "God Mode⬇"
ToggleTagEx.DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.DropdownButton.TextScaled = true
ToggleTagEx.DropdownButton.TextSize = 14.000
ToggleTagEx.DropdownButton.TextStrokeTransparency = 0.000
ToggleTagEx.DropdownButton.TextWrapped = true

ToggleTagEx.UICorner_8.Parent = ToggleTagEx.DropdownButton

ToggleTagEx.UIStroke_6.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ToggleTagEx.UIStroke_6.Parent = ToggleTagEx.DropdownButton

ToggleTagEx.UserListEx.Name = "UserListEx"
ToggleTagEx.UserListEx.Parent = ToggleTagEx.OptionsList
ToggleTagEx.UserListEx.AutomaticSize = Enum.AutomaticSize.Y
ToggleTagEx.UserListEx.BackgroundColor3 = Color3.fromRGB(0, 255, 102)
ToggleTagEx.UserListEx.BackgroundTransparency = 1.000
ToggleTagEx.UserListEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.UserListEx.BorderSizePixel = 0
ToggleTagEx.UserListEx.Size = UDim2.new(1, 0, 0, 40)

ToggleTagEx.NameTL_4.Name = "NameTL"
ToggleTagEx.NameTL_4.Parent = ToggleTagEx.UserListEx
ToggleTagEx.NameTL_4.Active = true
ToggleTagEx.NameTL_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.NameTL_4.BackgroundTransparency = 1.000
ToggleTagEx.NameTL_4.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.NameTL_4.BorderSizePixel = 0
ToggleTagEx.NameTL_4.Position = UDim2.new(0.0500000007, 0, 0, 5)
ToggleTagEx.NameTL_4.Size = UDim2.new(0.699999988, 0, 0, 30)
ToggleTagEx.NameTL_4.ZIndex = 2
ToggleTagEx.NameTL_4.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.NameTL_4.Text = "AimAssist"
ToggleTagEx.NameTL_4.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.NameTL_4.TextScaled = true
ToggleTagEx.NameTL_4.TextSize = 14.000
ToggleTagEx.NameTL_4.TextStrokeTransparency = 0.000
ToggleTagEx.NameTL_4.TextWrapped = true
ToggleTagEx.NameTL_4.TextXAlignment = Enum.TextXAlignment.Left

ToggleTagEx.UIStroke_7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ToggleTagEx.UIStroke_7.Parent = ToggleTagEx.UserListEx

ToggleTagEx.AddButton.Name = "AddButton"
ToggleTagEx.AddButton.Parent = ToggleTagEx.UserListEx
ToggleTagEx.AddButton.AnchorPoint = Vector2.new(1, 0)
ToggleTagEx.AddButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ToggleTagEx.AddButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.AddButton.BorderSizePixel = 0
ToggleTagEx.AddButton.Position = UDim2.new(0.970000029, 0, 0, 40)
ToggleTagEx.AddButton.Size = UDim2.new(0.150000006, 0, 0, 30)
ToggleTagEx.AddButton.ZIndex = 2
ToggleTagEx.AddButton.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.AddButton.Text = "+"
ToggleTagEx.AddButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.AddButton.TextScaled = true
ToggleTagEx.AddButton.TextSize = 14.000
ToggleTagEx.AddButton.TextStrokeTransparency = 0.000
ToggleTagEx.AddButton.TextWrapped = true

ToggleTagEx.UICorner_9.Parent = ToggleTagEx.AddButton

ToggleTagEx.UIStroke_8.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ToggleTagEx.UIStroke_8.Parent = ToggleTagEx.AddButton

ToggleTagEx.MainList.Name = "MainList"
ToggleTagEx.MainList.Parent = ToggleTagEx.UserListEx
ToggleTagEx.MainList.AutomaticSize = Enum.AutomaticSize.Y
ToggleTagEx.MainList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.MainList.BackgroundTransparency = 1.000
ToggleTagEx.MainList.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.MainList.BorderSizePixel = 0
ToggleTagEx.MainList.Position = UDim2.new(0, 0, 0, 80)
ToggleTagEx.MainList.Size = UDim2.new(1, 0, 0, 0)

ToggleTagEx.UIListLayout_7.Parent = ToggleTagEx.MainList
ToggleTagEx.UIListLayout_7.HorizontalAlignment = Enum.HorizontalAlignment.Center
ToggleTagEx.UIListLayout_7.SortOrder = Enum.SortOrder.LayoutOrder

ToggleTagEx.OneListEx.Name = "OneListEx"
ToggleTagEx.OneListEx.Parent = ToggleTagEx.MainList
ToggleTagEx.OneListEx.BackgroundColor3 = Color3.fromRGB(79, 79, 79)
ToggleTagEx.OneListEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.OneListEx.BorderSizePixel = 0
ToggleTagEx.OneListEx.Size = UDim2.new(1, 0, 0, 20)

ToggleTagEx.DeleteButton.Name = "DeleteButton"
ToggleTagEx.DeleteButton.Parent = ToggleTagEx.OneListEx
ToggleTagEx.DeleteButton.AnchorPoint = Vector2.new(1, 0)
ToggleTagEx.DeleteButton.BackgroundColor3 = Color3.fromRGB(198, 0, 0)
ToggleTagEx.DeleteButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.DeleteButton.BorderSizePixel = 0
ToggleTagEx.DeleteButton.Position = UDim2.new(0.970000029, 0, 0, 0)
ToggleTagEx.DeleteButton.Size = UDim2.new(0.150000006, 0, 1, 0)
ToggleTagEx.DeleteButton.ZIndex = 2
ToggleTagEx.DeleteButton.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.DeleteButton.Text = "X"
ToggleTagEx.DeleteButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.DeleteButton.TextScaled = true
ToggleTagEx.DeleteButton.TextSize = 14.000
ToggleTagEx.DeleteButton.TextStrokeTransparency = 0.000
ToggleTagEx.DeleteButton.TextWrapped = true

ToggleTagEx.UICorner_10.Parent = ToggleTagEx.DeleteButton

ToggleTagEx.UIStroke_9.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ToggleTagEx.UIStroke_9.Parent = ToggleTagEx.DeleteButton

ToggleTagEx.UserTL.Name = "UserTL"
ToggleTagEx.UserTL.Parent = ToggleTagEx.OneListEx
ToggleTagEx.UserTL.Active = true
ToggleTagEx.UserTL.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.UserTL.BackgroundTransparency = 1.000
ToggleTagEx.UserTL.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.UserTL.BorderSizePixel = 0
ToggleTagEx.UserTL.Position = UDim2.new(0.0500000007, 0, 0, 0)
ToggleTagEx.UserTL.Size = UDim2.new(0.699999988, 0, 1, 0)
ToggleTagEx.UserTL.ZIndex = 2
ToggleTagEx.UserTL.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.UserTL.Text = "areallycoolguy"
ToggleTagEx.UserTL.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.UserTL.TextScaled = true
ToggleTagEx.UserTL.TextSize = 14.000
ToggleTagEx.UserTL.TextStrokeTransparency = 0.000
ToggleTagEx.UserTL.TextWrapped = true
ToggleTagEx.UserTL.TextXAlignment = Enum.TextXAlignment.Left

ToggleTagEx.EnterTB.Name = "EnterTB"
ToggleTagEx.EnterTB.Parent = ToggleTagEx.UserListEx
ToggleTagEx.EnterTB.BackgroundColor3 = Color3.fromRGB(188, 188, 188)
ToggleTagEx.EnterTB.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.EnterTB.BorderSizePixel = 0
ToggleTagEx.EnterTB.Position = UDim2.new(0.0500000007, 0, 0, 40)
ToggleTagEx.EnterTB.Selectable = false
ToggleTagEx.EnterTB.Size = UDim2.new(0.730000019, 0, 0, 30)
ToggleTagEx.EnterTB.ZIndex = 2
ToggleTagEx.EnterTB.ClearTextOnFocus = false
ToggleTagEx.EnterTB.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.EnterTB.PlaceholderText = "Enter username/userid"
ToggleTagEx.EnterTB.Text = ""
ToggleTagEx.EnterTB.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.EnterTB.TextScaled = true
ToggleTagEx.EnterTB.TextSize = 14.000
ToggleTagEx.EnterTB.TextStrokeTransparency = 0.000
ToggleTagEx.EnterTB.TextWrapped = true

ToggleTagEx.UICorner_11.Parent = ToggleTagEx.EnterTB

ToggleTagEx.UIStroke_10.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ToggleTagEx.UIStroke_10.Parent = ToggleTagEx.EnterTB

ToggleTagEx.LimitTL.Name = "LimitTL"
ToggleTagEx.LimitTL.Parent = ToggleTagEx.UserListEx
ToggleTagEx.LimitTL.Active = true
ToggleTagEx.LimitTL.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.LimitTL.BackgroundTransparency = 1.000
ToggleTagEx.LimitTL.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.LimitTL.BorderSizePixel = 0
ToggleTagEx.LimitTL.Position = UDim2.new(0.789999783, 0, 0, 5)
ToggleTagEx.LimitTL.Size = UDim2.new(0.177391246, 0, 0, 30)
ToggleTagEx.LimitTL.ZIndex = 2
ToggleTagEx.LimitTL.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Regular,Enum.FontStyle.Normal)
ToggleTagEx.LimitTL.Text = "0/50"
ToggleTagEx.LimitTL.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.LimitTL.TextScaled = true
ToggleTagEx.LimitTL.TextSize = 14.000
ToggleTagEx.LimitTL.TextStrokeTransparency = 0.000
ToggleTagEx.LimitTL.TextWrapped = true
ToggleTagEx.LimitTL.TextXAlignment = Enum.TextXAlignment.Left

ToggleTagEx.TextboxEx.Name = "TextboxEx"
ToggleTagEx.TextboxEx.Parent = ToggleTagEx.OptionsList
ToggleTagEx.TextboxEx.AutomaticSize = Enum.AutomaticSize.Y
ToggleTagEx.TextboxEx.BackgroundColor3 = Color3.fromRGB(0, 255, 102)
ToggleTagEx.TextboxEx.BackgroundTransparency = 1.000
ToggleTagEx.TextboxEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.TextboxEx.BorderSizePixel = 0
ToggleTagEx.TextboxEx.Size = UDim2.new(1, 0, 0, 40)

ToggleTagEx.NameTL_5.Name = "NameTL"
ToggleTagEx.NameTL_5.Parent = ToggleTagEx.TextboxEx
ToggleTagEx.NameTL_5.Active = true
ToggleTagEx.NameTL_5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.NameTL_5.BackgroundTransparency = 1.000
ToggleTagEx.NameTL_5.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.NameTL_5.BorderSizePixel = 0
ToggleTagEx.NameTL_5.Position = UDim2.new(0.0500000007, 0, 0, 5)
ToggleTagEx.NameTL_5.Size = UDim2.new(0.699999988, 0, 0, 30)
ToggleTagEx.NameTL_5.ZIndex = 2
ToggleTagEx.NameTL_5.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.NameTL_5.Text = "AimAssist"
ToggleTagEx.NameTL_5.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.NameTL_5.TextScaled = true
ToggleTagEx.NameTL_5.TextSize = 14.000
ToggleTagEx.NameTL_5.TextStrokeTransparency = 0.000
ToggleTagEx.NameTL_5.TextWrapped = true
ToggleTagEx.NameTL_5.TextXAlignment = Enum.TextXAlignment.Left

ToggleTagEx.UIStroke_11.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ToggleTagEx.UIStroke_11.Parent = ToggleTagEx.TextboxEx

ToggleTagEx.SetTB.Name = "SetTB"
ToggleTagEx.SetTB.Parent = ToggleTagEx.TextboxEx
ToggleTagEx.SetTB.BackgroundColor3 = Color3.fromRGB(188, 188, 188)
ToggleTagEx.SetTB.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.SetTB.BorderSizePixel = 0
ToggleTagEx.SetTB.Position = UDim2.new(0.0500000007, 0, 0, 40)
ToggleTagEx.SetTB.Selectable = false
ToggleTagEx.SetTB.Size = UDim2.new(0.730000019, 0, 0, 30)
ToggleTagEx.SetTB.ZIndex = 2
ToggleTagEx.SetTB.ClearTextOnFocus = false
ToggleTagEx.SetTB.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.SetTB.PlaceholderText = "Enter something here.."
ToggleTagEx.SetTB.Text = ""
ToggleTagEx.SetTB.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.SetTB.TextScaled = true
ToggleTagEx.SetTB.TextSize = 14.000
ToggleTagEx.SetTB.TextStrokeTransparency = 0.100
ToggleTagEx.SetTB.TextTransparency = 0.100
ToggleTagEx.SetTB.TextWrapped = true

ToggleTagEx.UICorner_12.Parent = ToggleTagEx.SetTB

ToggleTagEx.UIStroke_12.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ToggleTagEx.UIStroke_12.Parent = ToggleTagEx.SetTB

ToggleTagEx.LimitTL_2.Name = "LimitTL"
ToggleTagEx.LimitTL_2.Parent = ToggleTagEx.TextboxEx
ToggleTagEx.LimitTL_2.Active = true
ToggleTagEx.LimitTL_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.LimitTL_2.BackgroundTransparency = 1.000
ToggleTagEx.LimitTL_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.LimitTL_2.BorderSizePixel = 0
ToggleTagEx.LimitTL_2.Position = UDim2.new(0.789999783, 0, 0, 5)
ToggleTagEx.LimitTL_2.Size = UDim2.new(0.177391246, 0, 0, 30)
ToggleTagEx.LimitTL_2.ZIndex = 2
ToggleTagEx.LimitTL_2.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Regular,Enum.FontStyle.Normal)
ToggleTagEx.LimitTL_2.Text = "0/50"
ToggleTagEx.LimitTL_2.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.LimitTL_2.TextScaled = true
ToggleTagEx.LimitTL_2.TextSize = 14.000
ToggleTagEx.LimitTL_2.TextStrokeTransparency = 0.000
ToggleTagEx.LimitTL_2.TextWrapped = true
ToggleTagEx.LimitTL_2.TextXAlignment = Enum.TextXAlignment.Left

ToggleTagEx.EnterButton.Name = "EnterButton"
ToggleTagEx.EnterButton.Parent = ToggleTagEx.TextboxEx
ToggleTagEx.EnterButton.AnchorPoint = Vector2.new(1, 0)
ToggleTagEx.EnterButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ToggleTagEx.EnterButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.EnterButton.BorderSizePixel = 0
ToggleTagEx.EnterButton.Position = UDim2.new(0.970000029, 0, 0, 40)
ToggleTagEx.EnterButton.Size = UDim2.new(0.150000006, 0, 0, 30)
ToggleTagEx.EnterButton.ZIndex = 2
ToggleTagEx.EnterButton.Image = "rbxassetid://504367763"

ToggleTagEx.UICorner_13.Parent = ToggleTagEx.EnterButton

ToggleTagEx.UIStroke_13.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ToggleTagEx.UIStroke_13.Parent = ToggleTagEx.EnterButton

ToggleTagEx.HighlightBackground.Name = "HighlightBackground"
ToggleTagEx.HighlightBackground.Parent = ToggleTagEx.HackButtonEx
ToggleTagEx.HighlightBackground.BackgroundColor3 = Color3.fromRGB(0, 255, 60)
ToggleTagEx.HighlightBackground.BackgroundTransparency = 1.000
ToggleTagEx.HighlightBackground.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.HighlightBackground.BorderSizePixel = 0
ToggleTagEx.HighlightBackground.Size = UDim2.new(1, 0, 0, 40)

ToggleTagEx.KeybindButton.Name = "KeybindButton"
ToggleTagEx.KeybindButton.Parent = ToggleTagEx.HackButtonEx
ToggleTagEx.KeybindButton.Active = false
ToggleTagEx.KeybindButton.AnchorPoint = Vector2.new(1, 0.5)
ToggleTagEx.KeybindButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.KeybindButton.BackgroundTransparency = 1.000
ToggleTagEx.KeybindButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.KeybindButton.BorderSizePixel = 0
ToggleTagEx.KeybindButton.Position = UDim2.new(0.841303527, 0, 0, 20)
ToggleTagEx.KeybindButton.Selectable = false
ToggleTagEx.KeybindButton.Size = UDim2.new(0, 34, 0, 40)
ToggleTagEx.KeybindButton.ZIndex = 3
ToggleTagEx.KeybindButton.Image = "rbxassetid://6884453656"
ToggleTagEx.KeybindButton.ScaleType = Enum.ScaleType.Fit

ToggleTagEx.BindedKey.Name = "BindedKey"
ToggleTagEx.BindedKey.Parent = ToggleTagEx.KeybindButton
ToggleTagEx.BindedKey.Active = true
ToggleTagEx.BindedKey.AnchorPoint = Vector2.new(0.5, 0.5)
ToggleTagEx.BindedKey.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.BindedKey.BackgroundTransparency = 1.000
ToggleTagEx.BindedKey.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.BindedKey.BorderSizePixel = 0
ToggleTagEx.BindedKey.Position = UDim2.new(0.5, 0, 0.5, 0)
ToggleTagEx.BindedKey.Size = UDim2.new(0.800000012, 0, 0.600000024, 0)
ToggleTagEx.BindedKey.ZIndex = 4
ToggleTagEx.BindedKey.FontFace = Font.new("rbxasset://fonts/families/Jura.json",Enum.FontWeight.Regular,Enum.FontStyle.Normal)
ToggleTagEx.BindedKey.Text = ""
ToggleTagEx.BindedKey.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.BindedKey.TextScaled = true
ToggleTagEx.BindedKey.TextSize = 14.000
ToggleTagEx.BindedKey.TextStrokeTransparency = 0.000
ToggleTagEx.BindedKey.TextWrapped = true

ToggleTagEx.KeybindLabel.Name = "KeybindLabel"
ToggleTagEx.KeybindLabel.Parent = ToggleTagEx.HackButtonEx
ToggleTagEx.KeybindLabel.Active = true
ToggleTagEx.KeybindLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.KeybindLabel.BackgroundTransparency = 1.000
ToggleTagEx.KeybindLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.KeybindLabel.BorderSizePixel = 0
ToggleTagEx.KeybindLabel.Position = UDim2.new(0.0500000007, 0, 0, 0)
ToggleTagEx.KeybindLabel.Size = UDim2.new(0.649999976, 0, 0, 40)
ToggleTagEx.KeybindLabel.Visible = false
ToggleTagEx.KeybindLabel.ZIndex = 3
ToggleTagEx.KeybindLabel.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.KeybindLabel.Text = "PRESS KEY TO BIND"
ToggleTagEx.KeybindLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.KeybindLabel.TextScaled = true
ToggleTagEx.KeybindLabel.TextSize = 14.000
ToggleTagEx.KeybindLabel.TextStrokeTransparency = 0.000
ToggleTagEx.KeybindLabel.TextWrapped = true
ToggleTagEx.KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left

ToggleTagEx.KeybindBacking.Name = "KeybindBacking"
ToggleTagEx.KeybindBacking.Parent = ToggleTagEx.KeybindLabel
ToggleTagEx.KeybindBacking.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.KeybindBacking.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.KeybindBacking.BorderSizePixel = 0
ToggleTagEx.KeybindBacking.Position = UDim2.new(-0.0769230798, 0, 0, 0)
ToggleTagEx.KeybindBacking.Size = UDim2.new(1.53846157, 0, 1, 0)
ToggleTagEx.KeybindBacking.ZIndex = 2

ToggleTagEx.UIGradient_5.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(117, 75, 255)), ColorSequenceKeypoint.new(0.52, Color3.fromRGB(169, 0, 23)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(197, 255, 39))}
ToggleTagEx.UIGradient_5.Parent = ToggleTagEx.KeybindBacking

ToggleTagEx.ToolTipHeaderFrame.Name = "ToolTipHeaderFrame"
ToggleTagEx.ToolTipHeaderFrame.Parent = ToggleTagEx.MainHUD
ToggleTagEx.ToolTipHeaderFrame.AutomaticSize = Enum.AutomaticSize.Y
ToggleTagEx.ToolTipHeaderFrame.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
ToggleTagEx.ToolTipHeaderFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.ToolTipHeaderFrame.BorderSizePixel = 0
ToggleTagEx.ToolTipHeaderFrame.Position = UDim2.new(0, 536, 0, 180)
ToggleTagEx.ToolTipHeaderFrame.Size = UDim2.new(0, 200, 0, 0)
ToggleTagEx.ToolTipHeaderFrame.Visible = false
ToggleTagEx.ToolTipHeaderFrame.ZIndex = 15

ToggleTagEx.ToolTipText.Name = "ToolTipText"
ToggleTagEx.ToolTipText.Parent = ToggleTagEx.ToolTipHeaderFrame
ToggleTagEx.ToolTipText.AutomaticSize = Enum.AutomaticSize.Y
ToggleTagEx.ToolTipText.AnchorPoint = Vector2.new(0.5, 0)
ToggleTagEx.ToolTipText.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
ToggleTagEx.ToolTipText.BackgroundTransparency = 1.000
ToggleTagEx.ToolTipText.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.ToolTipText.BorderSizePixel = 0
ToggleTagEx.ToolTipText.Position = UDim2.new(0.5, 0, 0, 0)
ToggleTagEx.ToolTipText.Size = UDim2.new(0.800000012, 0, 0, 0)
ToggleTagEx.ToolTipText.ZIndex = 16
ToggleTagEx.ToolTipText.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.ToolTipText.Text = "Aims At Enemies"
ToggleTagEx.ToolTipText.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.ToolTipText.TextSize = 22.000
ToggleTagEx.ToolTipText.TextStrokeTransparency = 0.000
ToggleTagEx.ToolTipText.TextWrapped = true

ToggleTagEx.UICorner_14.CornerRadius = UDim.new(0.400000006, 0)
ToggleTagEx.UICorner_14.Parent = ToggleTagEx.ToolTipHeaderFrame

ToggleTagEx.Notifications.Name = "Notifications"
ToggleTagEx.Notifications.Parent = ToggleTagEx.SpecterGUI
ToggleTagEx.Notifications.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.Notifications.BackgroundTransparency = 1.000
ToggleTagEx.Notifications.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.Notifications.BorderSizePixel = 0
ToggleTagEx.Notifications.Size = UDim2.new(1, 0, 1, 0)

ToggleTagEx.NotificationEx.Name = "NotificationEx"
ToggleTagEx.NotificationEx.Parent = ToggleTagEx.Notifications
ToggleTagEx.NotificationEx.AnchorPoint = Vector2.new(1, 1)
ToggleTagEx.NotificationEx.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleTagEx.NotificationEx.BackgroundTransparency = 0.300
ToggleTagEx.NotificationEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.NotificationEx.BorderSizePixel = 0
ToggleTagEx.NotificationEx.Position = UDim2.new(1, 0, 1, 0)
ToggleTagEx.NotificationEx.Size = UDim2.new(0.150000006, 0, 0.100000001, 0)
ToggleTagEx.NotificationEx.Visible = false
ToggleTagEx.NotificationEx.ZIndex = 2

ToggleTagEx.Timer.Name = "Timer"
ToggleTagEx.Timer.Parent = ToggleTagEx.NotificationEx
ToggleTagEx.Timer.AnchorPoint = Vector2.new(0, 1)
ToggleTagEx.Timer.BackgroundColor3 = Color3.fromRGB(0, 115, 255)
ToggleTagEx.Timer.BackgroundTransparency = 0.600
ToggleTagEx.Timer.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.Timer.BorderSizePixel = 0
ToggleTagEx.Timer.Position = UDim2.new(0, 0, 1, -15)
ToggleTagEx.Timer.Size = UDim2.new(1, 0, 0, 3)
ToggleTagEx.Timer.ZIndex = 3

ToggleTagEx.UICorner_15.CornerRadius = UDim.new(0, 20)
ToggleTagEx.UICorner_15.Parent = ToggleTagEx.NotificationEx

ToggleTagEx.NotificationTitle.Name = "NotificationTitle"
ToggleTagEx.NotificationTitle.Parent = ToggleTagEx.NotificationEx
ToggleTagEx.NotificationTitle.AnchorPoint = Vector2.new(0.5, 0)
ToggleTagEx.NotificationTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.NotificationTitle.BackgroundTransparency = 1.000
ToggleTagEx.NotificationTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.NotificationTitle.BorderSizePixel = 0
ToggleTagEx.NotificationTitle.Position = UDim2.new(0.5, 0, -0, 0)
ToggleTagEx.NotificationTitle.Size = UDim2.new(0.800000012, 0, 0.200000003, 0)
ToggleTagEx.NotificationTitle.ZIndex = 3
ToggleTagEx.NotificationTitle.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.NotificationTitle.Text = "UI Loaded"
ToggleTagEx.NotificationTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.NotificationTitle.TextScaled = true
ToggleTagEx.NotificationTitle.TextSize = 22.000
ToggleTagEx.NotificationTitle.TextStrokeTransparency = 0.000
ToggleTagEx.NotificationTitle.TextWrapped = true

ToggleTagEx.NotificationDesc.Name = "NotificationDesc"
ToggleTagEx.NotificationDesc.Parent = ToggleTagEx.NotificationEx
ToggleTagEx.NotificationDesc.AnchorPoint = Vector2.new(0.5, 0)
ToggleTagEx.NotificationDesc.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.NotificationDesc.BackgroundTransparency = 1.000
ToggleTagEx.NotificationDesc.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.NotificationDesc.BorderSizePixel = 0
ToggleTagEx.NotificationDesc.Position = UDim2.new(0.500000179, 0, 0.190796182, 0)
ToggleTagEx.NotificationDesc.Size = UDim2.new(0.800000072, 0, 0.583613932, 0)
ToggleTagEx.NotificationDesc.ZIndex = 3
ToggleTagEx.NotificationDesc.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.NotificationDesc.Text = "UI Loaded"
ToggleTagEx.NotificationDesc.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.NotificationDesc.TextScaled = true
ToggleTagEx.NotificationDesc.TextSize = 22.000
ToggleTagEx.NotificationDesc.TextStrokeTransparency = 0.000
ToggleTagEx.NotificationDesc.TextWrapped = true

ToggleTagEx.UITextSizeConstraint.Parent = ToggleTagEx.NotificationDesc
ToggleTagEx.UITextSizeConstraint.MaxTextSize = 44

ToggleTagEx.HUDBackgroundFade.Name = "HUDBackgroundFade"
ToggleTagEx.HUDBackgroundFade.Parent = ToggleTagEx.SpecterGUI
ToggleTagEx.HUDBackgroundFade.AnchorPoint = Vector2.new(0.5, 0.5)
ToggleTagEx.HUDBackgroundFade.BackgroundColor3 = Color3.fromRGB(6, 6, 6)
ToggleTagEx.HUDBackgroundFade.BackgroundTransparency = 1.000
ToggleTagEx.HUDBackgroundFade.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.HUDBackgroundFade.BorderSizePixel = 0
ToggleTagEx.HUDBackgroundFade.LayoutOrder = -30
ToggleTagEx.HUDBackgroundFade.Position = UDim2.new(0.5, 0, 0.5, 0)
ToggleTagEx.HUDBackgroundFade.Size = UDim2.new(4, 0, 4, 0)
ToggleTagEx.HUDBackgroundFade.ZIndex = -1200000

ToggleTagEx.ChatAutoComplete.Name = "ChatAutoComplete"
ToggleTagEx.ChatAutoComplete.Parent = ToggleTagEx.SpecterGUI
ToggleTagEx.ChatAutoComplete.Active = true
ToggleTagEx.ChatAutoComplete.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.ChatAutoComplete.BackgroundTransparency = 1.000
ToggleTagEx.ChatAutoComplete.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.ChatAutoComplete.BorderSizePixel = 0
ToggleTagEx.ChatAutoComplete.Size = UDim2.new(0.300000012, 0, 0, 0)
ToggleTagEx.ChatAutoComplete.Visible = false
ToggleTagEx.ChatAutoComplete.AutomaticCanvasSize = Enum.AutomaticSize.Y
ToggleTagEx.ChatAutoComplete.CanvasSize = UDim2.new(0, 0, 0, 0)

ToggleTagEx.AutoCompleteEx.Name = "AutoCompleteEx"
ToggleTagEx.AutoCompleteEx.Parent = ToggleTagEx.ChatAutoComplete
ToggleTagEx.AutoCompleteEx.BackgroundColor3 = Color3.fromRGB(55, 255, 0)
ToggleTagEx.AutoCompleteEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.AutoCompleteEx.BorderSizePixel = 0
ToggleTagEx.AutoCompleteEx.Size = UDim2.new(1, 0, 0, 25)

ToggleTagEx.AutoCompleteTitleLabel.Name = "AutoCompleteTitleLabel"
ToggleTagEx.AutoCompleteTitleLabel.Parent = ToggleTagEx.AutoCompleteEx
ToggleTagEx.AutoCompleteTitleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.AutoCompleteTitleLabel.BackgroundTransparency = 1.000
ToggleTagEx.AutoCompleteTitleLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.AutoCompleteTitleLabel.BorderSizePixel = 0
ToggleTagEx.AutoCompleteTitleLabel.Size = UDim2.new(1, 0, 1, 0)
ToggleTagEx.AutoCompleteTitleLabel.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.AutoCompleteTitleLabel.Text = "This sounds cool"
ToggleTagEx.AutoCompleteTitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.AutoCompleteTitleLabel.TextScaled = true
ToggleTagEx.AutoCompleteTitleLabel.TextSize = 14.000
ToggleTagEx.AutoCompleteTitleLabel.TextStrokeTransparency = 0.000
ToggleTagEx.AutoCompleteTitleLabel.TextWrapped = true

ToggleTagEx.UIListLayout_8.Parent = ToggleTagEx.ChatAutoComplete
ToggleTagEx.UIListLayout_8.HorizontalAlignment = Enum.HorizontalAlignment.Center
ToggleTagEx.UIListLayout_8.SortOrder = Enum.SortOrder.LayoutOrder

ToggleTagEx.Actions.Name = "Actions"
ToggleTagEx.Actions.Parent = ToggleTagEx.SpecterGUI
ToggleTagEx.Actions.BackgroundColor3 = Color3.fromRGB(39, 39, 39)
ToggleTagEx.Actions.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.Actions.BorderSizePixel = 0
ToggleTagEx.Actions.LayoutOrder = -14
ToggleTagEx.Actions.Position = UDim2.new(1, 0, 1, 0)
ToggleTagEx.Actions.Size = UDim2.new(0, 230, 0, 200)
ToggleTagEx.Actions.ZIndex = -50

ToggleTagEx.HeaderTab_3.Name = "HeaderTab"
ToggleTagEx.HeaderTab_3.Parent = ToggleTagEx.Actions
ToggleTagEx.HeaderTab_3.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
ToggleTagEx.HeaderTab_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.HeaderTab_3.BorderSizePixel = 0
ToggleTagEx.HeaderTab_3.LayoutOrder = -13
ToggleTagEx.HeaderTab_3.Size = UDim2.new(1, 0, 0, 30)
ToggleTagEx.HeaderTab_3.ZIndex = -49

ToggleTagEx.HeaderTitleLabel_3.Name = "HeaderTitleLabel"
ToggleTagEx.HeaderTitleLabel_3.Parent = ToggleTagEx.HeaderTab_3
ToggleTagEx.HeaderTitleLabel_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.HeaderTitleLabel_3.BackgroundTransparency = 1.000
ToggleTagEx.HeaderTitleLabel_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.HeaderTitleLabel_3.BorderSizePixel = 0
ToggleTagEx.HeaderTitleLabel_3.LayoutOrder = -12
ToggleTagEx.HeaderTitleLabel_3.Size = UDim2.new(0.600000024, 0, 1, 0)
ToggleTagEx.HeaderTitleLabel_3.Visible = false
ToggleTagEx.HeaderTitleLabel_3.ZIndex = -47
ToggleTagEx.HeaderTitleLabel_3.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.HeaderTitleLabel_3.Text = " SPECTER"
ToggleTagEx.HeaderTitleLabel_3.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.HeaderTitleLabel_3.TextScaled = true
ToggleTagEx.HeaderTitleLabel_3.TextSize = 14.000
ToggleTagEx.HeaderTitleLabel_3.TextStrokeTransparency = 0.000
ToggleTagEx.HeaderTitleLabel_3.TextWrapped = true
ToggleTagEx.HeaderTitleLabel_3.TextXAlignment = Enum.TextXAlignment.Left

ToggleTagEx.DropDownButton_2.Name = "DropDownButton"
ToggleTagEx.DropDownButton_2.Parent = ToggleTagEx.HeaderTab_3
ToggleTagEx.DropDownButton_2.AnchorPoint = Vector2.new(1, 0.5)
ToggleTagEx.DropDownButton_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.DropDownButton_2.BackgroundTransparency = 1.000
ToggleTagEx.DropDownButton_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.DropDownButton_2.BorderSizePixel = 0
ToggleTagEx.DropDownButton_2.LayoutOrder = -12
ToggleTagEx.DropDownButton_2.Position = UDim2.new(0.980000019, 0, 0.5, 0)
ToggleTagEx.DropDownButton_2.Size = UDim2.new(0.200000003, 0, 0.5, 0)
ToggleTagEx.DropDownButton_2.ZIndex = -47
ToggleTagEx.DropDownButton_2.Image = "rbxassetid://14569017448"
ToggleTagEx.DropDownButton_2.ScaleType = Enum.ScaleType.Fit

ToggleTagEx.Text_3.Name = "Text"
ToggleTagEx.Text_3.Parent = ToggleTagEx.HeaderTab_3
ToggleTagEx.Text_3.AnchorPoint = Vector2.new(0, 0.5)
ToggleTagEx.Text_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.Text_3.BackgroundTransparency = 1.000
ToggleTagEx.Text_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.Text_3.BorderSizePixel = 0
ToggleTagEx.Text_3.LayoutOrder = -12
ToggleTagEx.Text_3.Position = UDim2.new(0.150000036, 0, 0.5, 0)
ToggleTagEx.Text_3.Size = UDim2.new(0.629999995, 0, 1, 0)
ToggleTagEx.Text_3.ZIndex = -47
ToggleTagEx.Text_3.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.Text_3.Text = " Actions"
ToggleTagEx.Text_3.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.Text_3.TextScaled = true
ToggleTagEx.Text_3.TextSize = 14.000
ToggleTagEx.Text_3.TextWrapped = true
ToggleTagEx.Text_3.TextXAlignment = Enum.TextXAlignment.Left

ToggleTagEx.Image_4.Name = "Image"
ToggleTagEx.Image_4.Parent = ToggleTagEx.HeaderTab_3
ToggleTagEx.Image_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.Image_4.BackgroundTransparency = 1.000
ToggleTagEx.Image_4.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.Image_4.BorderSizePixel = 0
ToggleTagEx.Image_4.LayoutOrder = -12
ToggleTagEx.Image_4.Size = UDim2.new(0.150000006, 0, 1, 0)
ToggleTagEx.Image_4.ZIndex = -47
ToggleTagEx.Image_4.Image = "rbxassetid://8068133"
ToggleTagEx.Image_4.ScaleType = Enum.ScaleType.Fit

ToggleTagEx.ScrollTab_3.Name = "ScrollTab"
ToggleTagEx.ScrollTab_3.Parent = ToggleTagEx.Actions
ToggleTagEx.ScrollTab_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.ScrollTab_3.BackgroundTransparency = 1.000
ToggleTagEx.ScrollTab_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.ScrollTab_3.BorderSizePixel = 0
ToggleTagEx.ScrollTab_3.LayoutOrder = -13
ToggleTagEx.ScrollTab_3.Position = UDim2.new(0, 0, 0, 30)
ToggleTagEx.ScrollTab_3.Size = UDim2.new(1, 0, 0, 300)
ToggleTagEx.ScrollTab_3.ZIndex = -49
ToggleTagEx.ScrollTab_3.AutomaticCanvasSize = Enum.AutomaticSize.Y
ToggleTagEx.ScrollTab_3.BottomImage = "rbxassetid://3062505976"
ToggleTagEx.ScrollTab_3.CanvasSize = UDim2.new(0, 0, 0, 0)
ToggleTagEx.ScrollTab_3.MidImage = "rbxassetid://3062506202"
ToggleTagEx.ScrollTab_3.TopImage = "rbxassetid://3062506445"
ToggleTagEx.ScrollTab_3.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar

ToggleTagEx.UIListLayout_9.Parent = ToggleTagEx.ScrollTab_3
ToggleTagEx.UIListLayout_9.SortOrder = Enum.SortOrder.LayoutOrder

ToggleTagEx.ActionsEx.Name = "ActionsEx"
ToggleTagEx.ActionsEx.Parent = ToggleTagEx.ScrollTab_3
ToggleTagEx.ActionsEx.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.ActionsEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.ActionsEx.BorderSizePixel = 0
ToggleTagEx.ActionsEx.Size = UDim2.new(1, 0, 0, 40)
ToggleTagEx.ActionsEx.ZIndex = -47

ToggleTagEx.Title.Name = "Title"
ToggleTagEx.Title.Parent = ToggleTagEx.ActionsEx
ToggleTagEx.Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.Title.BackgroundTransparency = 1.000
ToggleTagEx.Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.Title.BorderSizePixel = 0
ToggleTagEx.Title.Size = UDim2.new(0.699999988, 0, 0.5, 0)
ToggleTagEx.Title.ZIndex = -45
ToggleTagEx.Title.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.Title.Text = "HACKING COMPUTER 5"
ToggleTagEx.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.Title.TextScaled = true
ToggleTagEx.Title.TextSize = 14.000
ToggleTagEx.Title.TextStrokeTransparency = 0.000
ToggleTagEx.Title.TextWrapped = true
ToggleTagEx.Title.TextXAlignment = Enum.TextXAlignment.Left

ToggleTagEx.StopButton.Name = "StopButton"
ToggleTagEx.StopButton.Parent = ToggleTagEx.ActionsEx
ToggleTagEx.StopButton.AnchorPoint = Vector2.new(1, 1)
ToggleTagEx.StopButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ToggleTagEx.StopButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.StopButton.BorderSizePixel = 0
ToggleTagEx.StopButton.Position = UDim2.new(1, 0, 1, 0)
ToggleTagEx.StopButton.Size = UDim2.new(0.286956519, 0, 0.5, 0)
ToggleTagEx.StopButton.ZIndex = -45
ToggleTagEx.StopButton.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.StopButton.Text = "CANCEL"
ToggleTagEx.StopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.StopButton.TextScaled = true
ToggleTagEx.StopButton.TextSize = 14.000
ToggleTagEx.StopButton.TextStrokeTransparency = 0.000
ToggleTagEx.StopButton.TextWrapped = true

ToggleTagEx.UIStroke_14.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ToggleTagEx.UIStroke_14.Parent = ToggleTagEx.StopButton

ToggleTagEx.Time.Name = "Time"
ToggleTagEx.Time.Parent = ToggleTagEx.ActionsEx
ToggleTagEx.Time.AnchorPoint = Vector2.new(0, 1)
ToggleTagEx.Time.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.Time.BackgroundTransparency = 1.000
ToggleTagEx.Time.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.Time.BorderSizePixel = 0
ToggleTagEx.Time.Position = UDim2.new(-0, 0, 1, 0)
ToggleTagEx.Time.Size = UDim2.new(0.713, -1, 0.5, 0)
ToggleTagEx.Time.ZIndex = -45
ToggleTagEx.Time.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.Time.Text = "34 m, 24 s"
ToggleTagEx.Time.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.Time.TextScaled = true
ToggleTagEx.Time.TextSize = 14.000
ToggleTagEx.Time.TextStrokeTransparency = 0.000
ToggleTagEx.Time.TextWrapped = true
ToggleTagEx.Time.TextXAlignment = Enum.TextXAlignment.Left

ToggleTagEx.UIStroke_15.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ToggleTagEx.UIStroke_15.Parent = ToggleTagEx.Time

ToggleTagEx.UIStroke_16.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ToggleTagEx.UIStroke_16.Parent = ToggleTagEx.ActionsEx

ToggleTagEx.UIGradient_6.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(140, 140, 140)), ColorSequenceKeypoint.new(0.96, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(39, 39, 39))}
ToggleTagEx.UIGradient_6.Parent = ToggleTagEx.ActionsEx

ToggleTagEx.ToggleTagEx.Name = "ToggleTagEx"
ToggleTagEx.ToggleTagEx.Parent = ToggleTagEx.SpecterGUI
ToggleTagEx.ToggleTagEx.Enabled = false
ToggleTagEx.ToggleTagEx.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ToggleTagEx.ToggleTagEx.Active = true
ToggleTagEx.ToggleTagEx.AlwaysOnTop = true
ToggleTagEx.ToggleTagEx.ExtentsOffsetWorldSpace = Vector3.new(0, 4, 0)
ToggleTagEx.ToggleTagEx.LightInfluence = 1.000
ToggleTagEx.ToggleTagEx.Size = UDim2.new(1, 30, 0.75, 10)

ToggleTagEx.Toggle.Name = "Toggle"
ToggleTagEx.Toggle.Parent = ToggleTagEx.ToggleTagEx
ToggleTagEx.Toggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ToggleTagEx.Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.Toggle.BorderSizePixel = 0
ToggleTagEx.Toggle.Size = UDim2.new(1, 0, 1, 0)
ToggleTagEx.Toggle.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.Toggle.TextScaled = true
ToggleTagEx.Toggle.TextSize = 14.000
ToggleTagEx.Toggle.TextStrokeTransparency = 0.000
ToggleTagEx.Toggle.TextWrapped = true

ToggleTagEx.UIStroke_17.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ToggleTagEx.UIStroke_17.Parent = ToggleTagEx.Toggle

ToggleTagEx.KickedButton.Name = "KickedButton"
ToggleTagEx.KickedButton.Parent = ToggleTagEx.SpecterGUI
ToggleTagEx.KickedButton.AnchorPoint = Vector2.new(0.5, 1)
ToggleTagEx.KickedButton.BackgroundColor3 = Color3.fromRGB(255, 106, 32)
ToggleTagEx.KickedButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.KickedButton.BorderSizePixel = 0
ToggleTagEx.KickedButton.Position = UDim2.new(0.5, 0, 0.980000019, 0)
ToggleTagEx.KickedButton.Size = UDim2.new(0.5, 0, 0, 0)
ToggleTagEx.KickedButton.Visible = false
ToggleTagEx.KickedButton.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.KickedButton.Text = "You are kicked. This means that you cannot interact with the game nor other players.Click to hide this prompt"
ToggleTagEx.KickedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.KickedButton.TextSize = 33.000
ToggleTagEx.KickedButton.TextStrokeTransparency = 0.000
ToggleTagEx.KickedButton.TextWrapped = true

ToggleTagEx.SecondaryHUD.Name = "SecondaryHUD"
ToggleTagEx.SecondaryHUD.Parent = ToggleTagEx.SpecterGUI
ToggleTagEx.SecondaryHUD.AnchorPoint = Vector2.new(0.5, 0.5)
ToggleTagEx.SecondaryHUD.BackgroundColor3 = Color3.fromRGB(56, 56, 56)
ToggleTagEx.SecondaryHUD.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.SecondaryHUD.BorderSizePixel = 0
ToggleTagEx.SecondaryHUD.Position = UDim2.new(0.5, 0, 0.5, 0)
ToggleTagEx.SecondaryHUD.Size = UDim2.new(0.5, 0, 0.5, 0)
ToggleTagEx.SecondaryHUD.Visible = false
ToggleTagEx.SecondaryHUD.ZIndex = 100

ToggleTagEx.Servers.Name = "Servers"
ToggleTagEx.Servers.Parent = ToggleTagEx.SecondaryHUD
ToggleTagEx.Servers.BackgroundColor3 = Color3.fromRGB(56, 56, 56)
ToggleTagEx.Servers.BackgroundTransparency = 1.000
ToggleTagEx.Servers.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.Servers.BorderSizePixel = 0
ToggleTagEx.Servers.Size = UDim2.new(1, 0, 1, 0)
ToggleTagEx.Servers.ZIndex = 101

ToggleTagEx.UICorner_16.CornerRadius = UDim.new(0, 32)
ToggleTagEx.UICorner_16.Parent = ToggleTagEx.Servers

ToggleTagEx.ServersTitleLabel.Name = "ServersTitleLabel"
ToggleTagEx.ServersTitleLabel.Parent = ToggleTagEx.Servers
ToggleTagEx.ServersTitleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.ServersTitleLabel.BackgroundTransparency = 1.000
ToggleTagEx.ServersTitleLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.ServersTitleLabel.BorderSizePixel = 0
ToggleTagEx.ServersTitleLabel.Position = UDim2.new(0.300000012, 0, 0, 0)
ToggleTagEx.ServersTitleLabel.Size = UDim2.new(0.699999988, 0, 0.100000001, 0)
ToggleTagEx.ServersTitleLabel.ZIndex = 102
ToggleTagEx.ServersTitleLabel.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.ServersTitleLabel.Text = "SERVERS"
ToggleTagEx.ServersTitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.ServersTitleLabel.TextScaled = true
ToggleTagEx.ServersTitleLabel.TextSize = 14.000
ToggleTagEx.ServersTitleLabel.TextStrokeTransparency = 0.000
ToggleTagEx.ServersTitleLabel.TextWrapped = true

ToggleTagEx.TabsSelection.Name = "TabsSelection"
ToggleTagEx.TabsSelection.Parent = ToggleTagEx.Servers
ToggleTagEx.TabsSelection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.TabsSelection.BackgroundTransparency = 1.000
ToggleTagEx.TabsSelection.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.TabsSelection.BorderSizePixel = 0
ToggleTagEx.TabsSelection.Size = UDim2.new(0.300000012, 0, 1, 0)
ToggleTagEx.TabsSelection.ZIndex = 102

ToggleTagEx.FromGame.Name = "FromGame"
ToggleTagEx.FromGame.Parent = ToggleTagEx.TabsSelection
ToggleTagEx.FromGame.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
ToggleTagEx.FromGame.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.FromGame.BorderSizePixel = 0
ToggleTagEx.FromGame.LayoutOrder = -1
ToggleTagEx.FromGame.Size = UDim2.new(0, 200, 0, 50)
ToggleTagEx.FromGame.ZIndex = 103
ToggleTagEx.FromGame.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.FromGame.Text = "All"
ToggleTagEx.FromGame.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.FromGame.TextScaled = true
ToggleTagEx.FromGame.TextSize = 14.000
ToggleTagEx.FromGame.TextStrokeTransparency = 0.000
ToggleTagEx.FromGame.TextWrapped = true

ToggleTagEx.UICorner_17.CornerRadius = UDim.new(0, 32)
ToggleTagEx.UICorner_17.Parent = ToggleTagEx.FromGame

ToggleTagEx.UIStroke_18.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ToggleTagEx.UIStroke_18.Parent = ToggleTagEx.FromGame

ToggleTagEx.UIGridLayout.Parent = ToggleTagEx.TabsSelection
ToggleTagEx.UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
ToggleTagEx.UIGridLayout.CellPadding = UDim2.new(0, 0, 0.13333334, 0)
ToggleTagEx.UIGridLayout.CellSize = UDim2.new(1, 0, 0.150000006, 0)

ToggleTagEx.Recent.Name = "Recent"
ToggleTagEx.Recent.Parent = ToggleTagEx.TabsSelection
ToggleTagEx.Recent.BackgroundColor3 = Color3.fromRGB(0, 110, 255)
ToggleTagEx.Recent.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.Recent.BorderSizePixel = 0
ToggleTagEx.Recent.Size = UDim2.new(0, 200, 0, 50)
ToggleTagEx.Recent.ZIndex = 103
ToggleTagEx.Recent.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.Recent.Text = "Recent"
ToggleTagEx.Recent.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.Recent.TextScaled = true
ToggleTagEx.Recent.TextSize = 14.000
ToggleTagEx.Recent.TextStrokeTransparency = 0.000
ToggleTagEx.Recent.TextWrapped = true

ToggleTagEx.UICorner_18.CornerRadius = UDim.new(0, 32)
ToggleTagEx.UICorner_18.Parent = ToggleTagEx.Recent

ToggleTagEx.UIStroke_19.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ToggleTagEx.UIStroke_19.Parent = ToggleTagEx.Recent

ToggleTagEx.Close.Name = "Close"
ToggleTagEx.Close.Parent = ToggleTagEx.TabsSelection
ToggleTagEx.Close.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ToggleTagEx.Close.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.Close.BorderSizePixel = 0
ToggleTagEx.Close.LayoutOrder = 2
ToggleTagEx.Close.Size = UDim2.new(0, 200, 0, 50)
ToggleTagEx.Close.ZIndex = 103
ToggleTagEx.Close.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.Close.Text = "Exit"
ToggleTagEx.Close.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.Close.TextScaled = true
ToggleTagEx.Close.TextSize = 14.000
ToggleTagEx.Close.TextStrokeTransparency = 0.000
ToggleTagEx.Close.TextWrapped = true

ToggleTagEx.UICorner_19.CornerRadius = UDim.new(0, 32)
ToggleTagEx.UICorner_19.Parent = ToggleTagEx.Close

ToggleTagEx.UIStroke_20.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ToggleTagEx.UIStroke_20.Parent = ToggleTagEx.Close

ToggleTagEx.Friends.Name = "Friends"
ToggleTagEx.Friends.Parent = ToggleTagEx.TabsSelection
ToggleTagEx.Friends.BackgroundColor3 = Color3.fromRGB(34, 255, 0)
ToggleTagEx.Friends.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.Friends.BorderSizePixel = 0
ToggleTagEx.Friends.LayoutOrder = 1
ToggleTagEx.Friends.Size = UDim2.new(0, 200, 0, 50)
ToggleTagEx.Friends.ZIndex = 103
ToggleTagEx.Friends.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.Friends.Text = "Friends"
ToggleTagEx.Friends.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.Friends.TextScaled = true
ToggleTagEx.Friends.TextSize = 14.000
ToggleTagEx.Friends.TextStrokeTransparency = 0.000
ToggleTagEx.Friends.TextWrapped = true

ToggleTagEx.UICorner_20.CornerRadius = UDim.new(0, 32)
ToggleTagEx.UICorner_20.Parent = ToggleTagEx.Friends

ToggleTagEx.UIStroke_21.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ToggleTagEx.UIStroke_21.Parent = ToggleTagEx.Friends

ToggleTagEx.MainScroll.Name = "MainScroll"
ToggleTagEx.MainScroll.Parent = ToggleTagEx.Servers
ToggleTagEx.MainScroll.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.MainScroll.BackgroundTransparency = 1.000
ToggleTagEx.MainScroll.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.MainScroll.BorderSizePixel = 0
ToggleTagEx.MainScroll.LayoutOrder = -13
ToggleTagEx.MainScroll.Position = UDim2.new(0.299999952, 0, 0.100000001, 0)
ToggleTagEx.MainScroll.Size = UDim2.new(0.699999988, 0, 0.760000229, 0)
ToggleTagEx.MainScroll.ZIndex = 102
ToggleTagEx.MainScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
ToggleTagEx.MainScroll.BottomImage = "rbxassetid://3062505976"
ToggleTagEx.MainScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ToggleTagEx.MainScroll.MidImage = "rbxassetid://3062506202"
ToggleTagEx.MainScroll.TopImage = "rbxassetid://3062506445"

ToggleTagEx.ServerEx.Name = "ServerEx"
ToggleTagEx.ServerEx.Parent = ToggleTagEx.MainScroll
ToggleTagEx.ServerEx.Active = true
ToggleTagEx.ServerEx.BackgroundColor3 = Color3.fromRGB(255, 81, 0)
ToggleTagEx.ServerEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.ServerEx.BorderSizePixel = 0
ToggleTagEx.ServerEx.Size = UDim2.new(1, 0, 0, 60)
ToggleTagEx.ServerEx.ZIndex = 103

ToggleTagEx.ServerTitle.Name = "ServerTitle"
ToggleTagEx.ServerTitle.Parent = ToggleTagEx.ServerEx
ToggleTagEx.ServerTitle.AnchorPoint = Vector2.new(0.5, 0)
ToggleTagEx.ServerTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.ServerTitle.BackgroundTransparency = 1.000
ToggleTagEx.ServerTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.ServerTitle.BorderSizePixel = 0
ToggleTagEx.ServerTitle.Position = UDim2.new(0.5, 0, 0, 0)
ToggleTagEx.ServerTitle.Size = UDim2.new(0.800000012, 0, 0.300000012, 0)
ToggleTagEx.ServerTitle.ZIndex = 103
ToggleTagEx.ServerTitle.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.ServerTitle.Text = "SERVER"
ToggleTagEx.ServerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.ServerTitle.TextScaled = true
ToggleTagEx.ServerTitle.TextSize = 14.000
ToggleTagEx.ServerTitle.TextStrokeTransparency = 0.000
ToggleTagEx.ServerTitle.TextWrapped = true

ToggleTagEx.TimeStamp.Name = "TimeStamp"
ToggleTagEx.TimeStamp.Parent = ToggleTagEx.ServerEx
ToggleTagEx.TimeStamp.AnchorPoint = Vector2.new(0.5, 0)
ToggleTagEx.TimeStamp.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.TimeStamp.BackgroundTransparency = 1.000
ToggleTagEx.TimeStamp.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.TimeStamp.BorderSizePixel = 0
ToggleTagEx.TimeStamp.Position = UDim2.new(0.5, 0, 0.699999988, 0)
ToggleTagEx.TimeStamp.Size = UDim2.new(0.800000012, 0, 0.300000012, 0)
ToggleTagEx.TimeStamp.ZIndex = 103
ToggleTagEx.TimeStamp.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.TimeStamp.Text = "7:56 PM"
ToggleTagEx.TimeStamp.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.TimeStamp.TextScaled = true
ToggleTagEx.TimeStamp.TextSize = 14.000
ToggleTagEx.TimeStamp.TextStrokeTransparency = 0.000
ToggleTagEx.TimeStamp.TextWrapped = true

ToggleTagEx.SecondData.Name = "SecondData"
ToggleTagEx.SecondData.Parent = ToggleTagEx.ServerEx
ToggleTagEx.SecondData.AnchorPoint = Vector2.new(0.5, 0)
ToggleTagEx.SecondData.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.SecondData.BackgroundTransparency = 1.000
ToggleTagEx.SecondData.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.SecondData.BorderSizePixel = 0
ToggleTagEx.SecondData.Position = UDim2.new(0.5, 0, 0.349999994, 0)
ToggleTagEx.SecondData.Size = UDim2.new(0.800000012, 0, 0.300000012, 0)
ToggleTagEx.SecondData.ZIndex = 103
ToggleTagEx.SecondData.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.SecondData.Text = "5/10 PLAYERS"
ToggleTagEx.SecondData.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.SecondData.TextScaled = true
ToggleTagEx.SecondData.TextSize = 14.000
ToggleTagEx.SecondData.TextStrokeTransparency = 0.000
ToggleTagEx.SecondData.TextWrapped = true

ToggleTagEx.UICorner_21.CornerRadius = UDim.new(0, 32)
ToggleTagEx.UICorner_21.Parent = ToggleTagEx.ServerEx

ToggleTagEx.UIStroke_22.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ToggleTagEx.UIStroke_22.Parent = ToggleTagEx.ServerEx

ToggleTagEx.UIGridLayout_2.Parent = ToggleTagEx.MainScroll
ToggleTagEx.UIGridLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
ToggleTagEx.UIGridLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
ToggleTagEx.UIGridLayout_2.CellPadding = UDim2.new(0, 0, 0, 0)
ToggleTagEx.UIGridLayout_2.CellSize = UDim2.new(0.300000012, 0, 0, 150)

ToggleTagEx.BottomButtons.Name = "BottomButtons"
ToggleTagEx.BottomButtons.Parent = ToggleTagEx.Servers
ToggleTagEx.BottomButtons.AnchorPoint = Vector2.new(0, 1)
ToggleTagEx.BottomButtons.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.BottomButtons.BackgroundTransparency = 1.000
ToggleTagEx.BottomButtons.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.BottomButtons.BorderSizePixel = 0
ToggleTagEx.BottomButtons.Position = UDim2.new(0.300000012, 0, 0.980000019, 0)
ToggleTagEx.BottomButtons.Size = UDim2.new(0.699999988, 0, 0.109999999, 0)
ToggleTagEx.BottomButtons.ZIndex = 102

ToggleTagEx.Previous.Name = "Previous"
ToggleTagEx.Previous.Parent = ToggleTagEx.BottomButtons
ToggleTagEx.Previous.BackgroundColor3 = Color3.fromRGB(255, 238, 0)
ToggleTagEx.Previous.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.Previous.BorderSizePixel = 0
ToggleTagEx.Previous.LayoutOrder = -1
ToggleTagEx.Previous.Size = UDim2.new(0, 200, 0, 50)
ToggleTagEx.Previous.ZIndex = 103
ToggleTagEx.Previous.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.Previous.Text = "Previous"
ToggleTagEx.Previous.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.Previous.TextScaled = true
ToggleTagEx.Previous.TextSize = 14.000
ToggleTagEx.Previous.TextStrokeTransparency = 0.000
ToggleTagEx.Previous.TextWrapped = true

ToggleTagEx.UICorner_22.CornerRadius = UDim.new(0, 32)
ToggleTagEx.UICorner_22.Parent = ToggleTagEx.Previous

ToggleTagEx.UIStroke_23.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ToggleTagEx.UIStroke_23.Parent = ToggleTagEx.Previous

ToggleTagEx.UIGridLayout_3.Parent = ToggleTagEx.BottomButtons
ToggleTagEx.UIGridLayout_3.HorizontalAlignment = Enum.HorizontalAlignment.Center
ToggleTagEx.UIGridLayout_3.SortOrder = Enum.SortOrder.LayoutOrder
ToggleTagEx.UIGridLayout_3.CellPadding = UDim2.new(0, 0, 0, 0)
ToggleTagEx.UIGridLayout_3.CellSize = UDim2.new(0.333299994, 0, 1, 0)

ToggleTagEx.Join.Name = "Join"
ToggleTagEx.Join.Parent = ToggleTagEx.BottomButtons
ToggleTagEx.Join.BackgroundColor3 = Color3.fromRGB(140, 0, 255)
ToggleTagEx.Join.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.Join.BorderSizePixel = 0
ToggleTagEx.Join.Size = UDim2.new(0, 200, 0, 50)
ToggleTagEx.Join.Visible = false
ToggleTagEx.Join.ZIndex = 103
ToggleTagEx.Join.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.Join.Text = "Join"
ToggleTagEx.Join.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.Join.TextScaled = true
ToggleTagEx.Join.TextSize = 14.000
ToggleTagEx.Join.TextStrokeTransparency = 0.000
ToggleTagEx.Join.TextWrapped = true

ToggleTagEx.UICorner_23.CornerRadius = UDim.new(0, 32)
ToggleTagEx.UICorner_23.Parent = ToggleTagEx.Join

ToggleTagEx.UIStroke_24.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ToggleTagEx.UIStroke_24.Parent = ToggleTagEx.Join

ToggleTagEx.Next.Name = "Next"
ToggleTagEx.Next.Parent = ToggleTagEx.BottomButtons
ToggleTagEx.Next.BackgroundColor3 = Color3.fromRGB(60, 255, 0)
ToggleTagEx.Next.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.Next.BorderSizePixel = 0
ToggleTagEx.Next.LayoutOrder = 1
ToggleTagEx.Next.Size = UDim2.new(0, 200, 0, 50)
ToggleTagEx.Next.ZIndex = 103
ToggleTagEx.Next.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.Next.Text = "Next"
ToggleTagEx.Next.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.Next.TextScaled = true
ToggleTagEx.Next.TextSize = 14.000
ToggleTagEx.Next.TextStrokeTransparency = 0.000
ToggleTagEx.Next.TextWrapped = true

ToggleTagEx.UICorner_24.CornerRadius = UDim.new(0, 32)
ToggleTagEx.UICorner_24.Parent = ToggleTagEx.Next

ToggleTagEx.UIStroke_25.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ToggleTagEx.UIStroke_25.Parent = ToggleTagEx.Next

ToggleTagEx.ExtraLabel.Name = "ExtraLabel"
ToggleTagEx.ExtraLabel.Parent = ToggleTagEx.Servers
ToggleTagEx.ExtraLabel.AnchorPoint = Vector2.new(0.5, 0)
ToggleTagEx.ExtraLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.ExtraLabel.BackgroundTransparency = 1.000
ToggleTagEx.ExtraLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.ExtraLabel.BorderSizePixel = 0
ToggleTagEx.ExtraLabel.Position = UDim2.new(0.5, 0, 1, 0)
ToggleTagEx.ExtraLabel.Size = UDim2.new(1, 0, 0, 30)
ToggleTagEx.ExtraLabel.ZIndex = 102
ToggleTagEx.ExtraLabel.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.ExtraLabel.Text = "Only public servers in this universe are visible; player count or server status may not be up to date"
ToggleTagEx.ExtraLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.ExtraLabel.TextScaled = true
ToggleTagEx.ExtraLabel.TextSize = 14.000
ToggleTagEx.ExtraLabel.TextStrokeTransparency = 0.000
ToggleTagEx.ExtraLabel.TextWrapped = true

ToggleTagEx.UICorner_25.CornerRadius = UDim.new(0, 32)
ToggleTagEx.UICorner_25.Parent = ToggleTagEx.SecondaryHUD

ToggleTagEx.UIStroke_26.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ToggleTagEx.UIStroke_26.Parent = ToggleTagEx.SecondaryHUD

ToggleTagEx.PromptFrame.Name = "PromptFrame"
ToggleTagEx.PromptFrame.Parent = ToggleTagEx.SpecterGUI
ToggleTagEx.PromptFrame.AnchorPoint = Vector2.new(0.5, 0.5)
ToggleTagEx.PromptFrame.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
ToggleTagEx.PromptFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.PromptFrame.BorderSizePixel = 0
ToggleTagEx.PromptFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
ToggleTagEx.PromptFrame.Size = UDim2.new(0.400000006, 0, 0.400000006, 0)
ToggleTagEx.PromptFrame.Visible = false
ToggleTagEx.PromptFrame.ZIndex = 1000

ToggleTagEx.UICorner_26.CornerRadius = UDim.new(0, 32)
ToggleTagEx.UICorner_26.Parent = ToggleTagEx.PromptFrame

ToggleTagEx.UIStroke_27.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ToggleTagEx.UIStroke_27.Parent = ToggleTagEx.PromptFrame

ToggleTagEx.PromptTile.Name = "PromptTile"
ToggleTagEx.PromptTile.Parent = ToggleTagEx.PromptFrame
ToggleTagEx.PromptTile.AnchorPoint = Vector2.new(0.5, 0)
ToggleTagEx.PromptTile.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.PromptTile.BackgroundTransparency = 1.000
ToggleTagEx.PromptTile.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.PromptTile.BorderSizePixel = 0
ToggleTagEx.PromptTile.Position = UDim2.new(0.5, 0, 0, 0)
ToggleTagEx.PromptTile.Size = UDim2.new(0.699999988, 0, 0.125, 0)
ToggleTagEx.PromptTile.ZIndex = 1002
ToggleTagEx.PromptTile.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.PromptTile.Text = "SERVERS"
ToggleTagEx.PromptTile.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.PromptTile.TextScaled = true
ToggleTagEx.PromptTile.TextSize = 14.000
ToggleTagEx.PromptTile.TextStrokeTransparency = 0.000
ToggleTagEx.PromptTile.TextWrapped = true

ToggleTagEx.PromptDesc.Name = "PromptDesc"
ToggleTagEx.PromptDesc.Parent = ToggleTagEx.PromptFrame
ToggleTagEx.PromptDesc.AnchorPoint = Vector2.new(0.5, 0)
ToggleTagEx.PromptDesc.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.PromptDesc.BackgroundTransparency = 1.000
ToggleTagEx.PromptDesc.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.PromptDesc.BorderSizePixel = 0
ToggleTagEx.PromptDesc.Position = UDim2.new(0.5, 0, 0.12226776, 0)
ToggleTagEx.PromptDesc.Size = UDim2.new(0.699999988, 0, 0.699999988, 0)
ToggleTagEx.PromptDesc.ZIndex = 1002
ToggleTagEx.PromptDesc.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.PromptDesc.Text = "Insert a notifaction text here later. You can put a lot or a little, and it will scale."
ToggleTagEx.PromptDesc.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.PromptDesc.TextScaled = true
ToggleTagEx.PromptDesc.TextSize = 14.000
ToggleTagEx.PromptDesc.TextStrokeTransparency = 0.000
ToggleTagEx.PromptDesc.TextWrapped = true

ToggleTagEx.PromptButtons.Name = "PromptButtons"
ToggleTagEx.PromptButtons.Parent = ToggleTagEx.PromptFrame
ToggleTagEx.PromptButtons.AnchorPoint = Vector2.new(0.5, 0)
ToggleTagEx.PromptButtons.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.PromptButtons.BackgroundTransparency = 1.000
ToggleTagEx.PromptButtons.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.PromptButtons.BorderSizePixel = 0
ToggleTagEx.PromptButtons.Position = UDim2.new(0.5, 0, 0.819672108, 0)
ToggleTagEx.PromptButtons.Size = UDim2.new(0.800000012, 0, 0.150000006, 0)
ToggleTagEx.PromptButtons.ZIndex = 1003

ToggleTagEx.UIGridLayout_4.Parent = ToggleTagEx.PromptButtons
ToggleTagEx.UIGridLayout_4.HorizontalAlignment = Enum.HorizontalAlignment.Center
ToggleTagEx.UIGridLayout_4.SortOrder = Enum.SortOrder.LayoutOrder
ToggleTagEx.UIGridLayout_4.CellPadding = UDim2.new(0, 0, 0, 0)
ToggleTagEx.UIGridLayout_4.CellSize = UDim2.new(0.5, 0, 1, 0)

ToggleTagEx.Yes.Name = "Yes"
ToggleTagEx.Yes.Parent = ToggleTagEx.PromptButtons
ToggleTagEx.Yes.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
ToggleTagEx.Yes.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.Yes.BorderSizePixel = 0
ToggleTagEx.Yes.Size = UDim2.new(0, 200, 0, 50)
ToggleTagEx.Yes.ZIndex = 1004
ToggleTagEx.Yes.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.Yes.Text = "Yes"
ToggleTagEx.Yes.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.Yes.TextScaled = true
ToggleTagEx.Yes.TextSize = 14.000
ToggleTagEx.Yes.TextStrokeTransparency = 0.000
ToggleTagEx.Yes.TextWrapped = true

ToggleTagEx.UIStroke_28.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ToggleTagEx.UIStroke_28.Parent = ToggleTagEx.Yes

ToggleTagEx.UICorner_27.CornerRadius = UDim.new(0, 32)
ToggleTagEx.UICorner_27.Parent = ToggleTagEx.Yes

ToggleTagEx.No.Name = "No"
ToggleTagEx.No.Parent = ToggleTagEx.PromptButtons
ToggleTagEx.No.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ToggleTagEx.No.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.No.BorderSizePixel = 0
ToggleTagEx.No.LayoutOrder = 1
ToggleTagEx.No.Size = UDim2.new(0, 200, 0, 50)
ToggleTagEx.No.ZIndex = 1004
ToggleTagEx.No.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.No.Text = "No"
ToggleTagEx.No.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.No.TextScaled = true
ToggleTagEx.No.TextSize = 14.000
ToggleTagEx.No.TextStrokeTransparency = 0.000
ToggleTagEx.No.TextWrapped = true

ToggleTagEx.UIStroke_29.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ToggleTagEx.UIStroke_29.Parent = ToggleTagEx.No

ToggleTagEx.UICorner_28.CornerRadius = UDim.new(0, 32)
ToggleTagEx.UICorner_28.Parent = ToggleTagEx.No

ToggleTagEx.Ok.Name = "Ok"
ToggleTagEx.Ok.Parent = ToggleTagEx.PromptButtons
ToggleTagEx.Ok.BackgroundColor3 = Color3.fromRGB(0, 132, 255)
ToggleTagEx.Ok.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleTagEx.Ok.BorderSizePixel = 0
ToggleTagEx.Ok.LayoutOrder = 2
ToggleTagEx.Ok.Size = UDim2.new(0, 200, 0, 50)
ToggleTagEx.Ok.Visible = false
ToggleTagEx.Ok.ZIndex = 1004
ToggleTagEx.Ok.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToggleTagEx.Ok.Text = "Ok"
ToggleTagEx.Ok.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTagEx.Ok.TextScaled = true
ToggleTagEx.Ok.TextSize = 14.000
ToggleTagEx.Ok.TextStrokeTransparency = 0.000
ToggleTagEx.Ok.TextWrapped = true

ToggleTagEx.UIStroke_30.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ToggleTagEx.UIStroke_30.Parent = ToggleTagEx.Ok

ToggleTagEx.UICorner_29.CornerRadius = UDim.new(0, 32)
ToggleTagEx.UICorner_29.Parent = ToggleTagEx.Ok
	return ToggleTagEx.SpecterGUI,ToggleTagEx.CategoriesFrame,ToggleTagEx.TabsFrame,ToggleTagEx.ToolTipHeaderFrame,ToggleTagEx.ToolTipText
end

local function CreateOtherElements(C, Settings)
	local newPart = Instance.new("Part")
	newPart.Size=Vector3.new(1.15,1.15,1.15)
	newPart.BrickColor=BrickColor.Red()
	newPart.Anchored=true
	newPart.CanCollide=false
	newPart.Transparency=.35
	newPart:AddTag("RemoveOnDestroy")
	C.Examples.TestPartEx = newPart
end

return function(C, Settings)
	-- Gui to Lua
	
	-- Initiziations
	C.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
	C.Examples = {}
	C.UI = {}
	
	-- Functions
	local BlockStartDragging = false
	function C.SetImage(imageButton,image)
		imageButton.Image = image
	end
	local function ClampNoCrash(x, min, max)
		return math.clamp(x, math.min(min,max), math.max(min, max))
	end
	local function CreateDraggable(frame: Frame)
		local dragging
		local dragInput
		local dragStart
		local dragStartTime
		local startPos
		local wantLoc

		local function update(delta: UDim2, start: boolean)
			if start then
				startPos = frame.Position
			end
			local x = startPos.X.Scale * C.GUI.AbsoluteSize.X + startPos.X.Offset + delta.X
			local y = startPos.Y.Scale * C.GUI.AbsoluteSize.Y + startPos.Y.Offset + delta.Y

			if delta.Magnitude > 0 or not wantLoc then
				wantLoc = UDim2.fromOffset(x, y)
			else
				x, y = wantLoc.X.Offset, wantLoc.Y.Offset
			end

			-- Get the screen bounds
			local screenWidth = math.max(workspace.CurrentCamera.ViewportSize.X, C.GUI.AbsoluteSize.X)
			local screenHeight = math.max(workspace.CurrentCamera.ViewportSize.Y, C.GUI.AbsoluteSize.Y)

			-- Get the frame size
			local frameWidth = frame.AbsoluteSize.X
			local frameHeight = frame.AbsoluteSize.Y

			-- Get the frame anchor point
			local anchorX = frame.AnchorPoint.X
			local anchorY = frame.AnchorPoint.Y

			-- Calculate the clamping bounds based on the anchor point
			local minX = anchorX * frameWidth
			local maxX = screenWidth - (1 - anchorX) * frameWidth
			local minY = anchorY * frameHeight
			local maxY = screenHeight - (1 - anchorY) * frameHeight

			-- Clamp the x and y positions
			x = ClampNoCrash(x, minX, maxX)
			y = ClampNoCrash(y, minY, maxY)

			TS:Create(frame,TweenInfo.new(start and 0 or .07),{Position = UDim2.fromOffset(x, y)}):Play()
		end

		C.AddGlobalConnection(frame.HeaderTab.InputBegan:Connect(function(input)
			if (input.UserInputType == Enum.UserInputType.MouseButton1 
				or input.UserInputType == Enum.UserInputType.Touch)
				and not BlockStartDragging then
				BlockStartDragging = true
				dragging = true
				dragStartTime = os.clock()
				dragStart = input.Position
				startPos = frame.Position
				
				local connection

				connection = input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
						BlockStartDragging = false
						C.RemoveGlobalConnection(connection)
					end
				end)
				C.AddGlobalConnection(connection)
			end
		end))

		C.AddGlobalConnection(frame.HeaderTab.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				if C.UI.DisableDrag then
					return
				end
				dragInput = input
			end
		end))

		C.AddGlobalConnection(UIS.InputChanged:Connect(function(input)
			if input == dragInput and dragging and os.clock() - dragStartTime > .1 then
				update(input.Position - dragStart)
			end
		end))
		
		return update
	end
	function C.MakeDraggableTab(TabEx,HasScroll)
		if C.Cleared then
			return
		end
		local PercentageVisible
		local ScrollTab,HeaderTab
		if HasScroll then
			ScrollTab = TabEx:WaitForChild("ScrollTab",5)
			if not ScrollTab then return end -- Likely cleared!
			HeaderTab = TabEx:WaitForChild("HeaderTab")
			PercentageVisible = Instance.new("NumberValue",ScrollTab)
			PercentageVisible.Name = "PercentageVisible"
			PercentageVisible.Value = 1
		end
		--Draggable
		local UpdateBounds = CreateDraggable(TabEx)
		-- Tab Resizing
		local function UpdateTabSize()
			if ScrollTab then
				local ySize =  math.min(ScrollTab.UIListLayout.AbsoluteContentSize.Y,300)
				if HasScroll then
					ySize *= PercentageVisible.Value
				end
				ySize += HeaderTab.AbsoluteSize.Y
				TabEx.Size = UDim2.fromOffset(TabEx.AbsoluteSize.X,ySize)
			end
			UpdateBounds(Vector2.zero, true)
		end
		if HasScroll then
			PercentageVisible.Changed:Connect(UpdateTabSize)
			ScrollTab.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateTabSize)
			local vis = true
			C.ButtonClick(HeaderTab:WaitForChild("DropDownButton"),function()
				vis = not vis
				TS:Create(HeaderTab.DropDownButton,TweenInfo.new(.3),{Rotation=vis and 0 or 180}):Play()
				TS:Create(PercentageVisible,TweenInfo.new(.3),{Value=vis and 1 or 0}):Play()
			end)
		end
		C.AddGlobalConnection(C.GUI:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateTabSize))
		UpdateTabSize()
	end
	-- BEGIN LOAD CORE
	
	-- Instances:
	local SpecterGUI,CategoriesFrame,TabsFrame,ToolTipHeaderFrame,ToolTipText = LoadCore(C)
	if C.isStudio then
		SpecterGUI.Name = "SpecterGUI" .. C.SaveIndex
	else
		SpecterGUI.Name = C.GenerateGUID()
	end
	SpecterGUI.SafeAreaCompatibility = Enum.SafeAreaCompatibility.None
	SpecterGUI.ScreenInsets = Enum.ScreenInsets.None
	SpecterGUI.ClipToDeviceSafeArea = false
	
	CreateOtherElements(C, Settings)
	
	-- Load tooltip

	
	local toolTipFunct
	local toolTipDeb = 0
	
	function C.TooltipActivate(text)
		toolTipDeb+=1
		local wasRegistered = C.TooltipDeactivate(true)
		ToolTipText.Text = text
		ToolTipHeaderFrame.Visible = true
		if not wasRegistered then
			toolTipFunct = C.AddGlobalConnection(RunS.RenderStepped:Connect(function()
				C.TooltipPosition(UIS:GetMouseLocation())
			end))
			C.TooltipPosition(UIS:GetMouseLocation())--Stop a render from being stepped!
		end
		return toolTipDeb
	end

	function C.TooltipDeactivate(doNotRemove)
		if toolTipFunct and not doNotRemove then
			ToolTipHeaderFrame.Visible = false
			C.RemoveGlobalConnection(toolTipFunct)
			toolTipFunct = nil
		end
		return toolTipFunct~=nil
	end

	function C.TooltipPosition(position)
		local x = position.X -- 47
		local y = position.Y - 40
		local screenWidth = SpecterGUI.AbsoluteSize.X
		local screenHeight = SpecterGUI.AbsoluteSize.Y
		local tooltipWidth = ToolTipHeaderFrame.AbsoluteSize.X
		local tooltipHeight = ToolTipHeaderFrame.AbsoluteSize.Y

		x = math.clamp(x, 0, screenWidth - tooltipWidth)
		y = math.clamp(y, 0, screenHeight - tooltipHeight)

		ToolTipHeaderFrame.Position = UDim2.fromOffset(x, y)
	end
	
	function C.TooltipSetUp(button,label)
		local saveDeb
		
		C.AddGlobalConnection(button.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				saveDeb = C.TooltipActivate(label)
			end
		end))

		-- Detect when input ends (e.g., mouse button up or movement stops)
		C.AddGlobalConnection(button.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement and saveDeb == toolTipDeb and label == ToolTipText.Text then
				C.TooltipDeactivate()
			end
		end))
	end
	
	--Load Notifications
	
	local NotiList = {}
	function C.AddNotification(title,desc)
		local NotiClone = C.Examples.NotificationEx:Clone()
		NotiClone:WaitForChild("NotificationTitle").Text = title
		NotiClone:WaitForChild("NotificationDesc").Text = desc
		NotiClone.Position = UDim2.fromScale(1+NotiClone.Size.X.Scale/2,1)
		NotiClone.Visible = true
		NotiClone.Parent = C.UI.Notifications
		local xTween = Instance.new("NumberValue",NotiClone)
		xTween.Name = "XValue"
		xTween.Value = 1
		local order = Instance.new("IntValue",NotiClone)
		order.Name = "Order"
		order.Value = -1
		local yTween = Instance.new("NumberValue",NotiClone)
		yTween.Value = 1
		yTween.Name = 'YValue'
		table.insert(NotiList,NotiClone)
		for num, currentClone in ipairs(NotiList) do
			currentClone.Order.Value += 1
			TS:Create(currentClone.YValue,TweenInfo.new(.2),{Value=(1-(currentClone.Order.Value*currentClone.Size.Y.Scale))}):Play()
		end
		local XTweenObj = TS:Create(xTween,TweenInfo.new(.3),{Value=0})
		XTweenObj:Play()
		local AlreadyDisabled = false
		local function DisableFunct(tweenStatus)
			if AlreadyDisabled or tweenStatus == Enum.TweenStatus.Canceled then
				return
			end
			AlreadyDisabled = true
			C.TblRemove(NotiList,NotiClone)
			local XTweenObj2 = TS:Create(xTween,TweenInfo.new(.3),{Value=1})
			XTweenObj2:Play()
			XTweenObj2.Completed:Wait()
			NotiClone:Destroy()
		end
		task.delay(12,DisableFunct)
		local function UpdateNotiPos()
			NotiClone.Position = UDim2.fromScale(1+(xTween.Value * NotiClone.Size.X.Scale),yTween.Value)
			if yTween.Value <= NotiClone.Size.Y.Scale * 3 then
				DisableFunct()
			end
		end
		local TimerTween = TS:Create(NotiClone:WaitForChild("Timer"),TweenInfo.new(12,Enum.EasingStyle.Linear),{Size=UDim2.new(0,0,0,NotiClone.Timer.Size.Y.Offset)})
		TimerTween.Completed:Connect(DisableFunct)
		TimerTween:Play()
		--C.AddGlobalConnection(RunS.RenderStepped:Connect(UpdateNotiPos))
		C.AddGlobalConnection(xTween.Changed:Connect(UpdateNotiPos))
		C.AddGlobalConnection(yTween.Changed:Connect(UpdateNotiPos))
		UpdateNotiPos()
	end
	--[[task.spawn(function()
		while true do
			C.AddNotification("test",'testestestestes')
			task.wait(.3)
		end
	end)--]]
	
	function C.ButtonClick(button:GuiBase,funct,msb)
		msb = msb or 1
		local FirstClick,FirstClickCoords
		--This does not need to be connected because it is removed when it is deleted.
		local function isValidPress(inputObject: InputObject)
			return (inputObject.UserInputType == Enum.UserInputType["MouseButton"..msb] or 
				(inputObject.UserInputType == Enum.UserInputType.Touch and msb==1))
		end
		button.InputBegan:Connect(function(inputObject: InputObject)
			if isValidPress(inputObject) then
				FirstClick = os.clock()
				FirstClickCoords = inputObject.Position
			end
		end)
		button.InputEnded:Connect(function(inputObject: InputObject)
			if isValidPress(inputObject) then
				local diffTime = FirstClick and os.clock() - FirstClick
				if diffTime and diffTime > 0.03 and diffTime < 1.5 and (FirstClickCoords-inputObject.Position).Magnitude < 15 then
					funct()
				end
			end
		end)
	end

	-- Set up actions

	local ActionsFrame = C.UI.Actions
	local ActionsList = ActionsFrame:WaitForChild("ScrollTab")

	C.getgenv().ActionsList = C.getgenv().ActionsList or {}
	
	function C.AddAction(info)
		local ActionClone = ActionsList:FindFirstChild(info.Name)
		if ActionsList:FindFirstChild(info.Name) then
			return ActionClone
		end
		info.Tags = info.Tags or {}
		ActionClone = C.Examples.ActionsEx:Clone()
		ActionClone.Name = info.Name
		ActionClone.Title.Text = (info.Title or info.Name):gsub("/"," "):gsub("_"," "):gsub("%l%u",function(old) return old:sub(1,1) .. " " .. old:sub(2) end)
		ActionClone.Visible = true
		local StopEvent = Instance.new("BindableEvent",ActionClone)
		StopEvent.Name = "StopEvent"
		StopEvent.Event:Connect(function(onRequest)
			StopEvent:Destroy()
			if info.Stop then
				info.Stop(onRequest)
			end
			info.Enabled = false
			ActionsFrame.Visible = #ActionsList:GetChildren()-1 > 2 -- If there's something else apart from UIListLayout and the deleted instance!
			ActionClone:Destroy()
		end)
		ActionClone.StopButton.MouseButton1Click:Connect(function()
			StopEvent:Fire(true)
		end)
		C.getgenv().ActionsList[info.Name] = info
		ActionClone.Parent = ActionsList
		if info.Time then
			if typeof(info.Time) == "number" then
				task.spawn(function()
					for s = info.Time, 1, -1 do
						if not ActionClone.Parent then
							return
						end
						ActionClone.Time.Text = s
						task.wait(1)
					end
					if StopEvent.Parent then
						StopEvent:Fire()
					end
				end)
			else
				task.spawn(info.Time,ActionClone,info)
			end
		else
			--Probably utilized elsewhere!
		end
		info.Enabled = true
		ActionsFrame.Visible = true
		return ActionClone
	end

	function C.SetActionPercentage(actionClone: ActionClone, percentage: float)
		local Time = actionClone:WaitForChild("Time",5)
		if Time then
			local Display = ("%.2f%%"):format(percentage * 100)
			local LastPing, LastPercentage = actionClone:GetAttribute("LastPing"), actionClone:GetAttribute("LastPercentage")
			if not LastPercentage or LastPercentage ~= percentage then
				if LastPing and LastPercentage then
					local WholeTime = (os.clock() - LastPing) / (percentage - LastPercentage)
					local TimeLeft = (1 - percentage) * WholeTime
					Display ..= (" (%.0f seconds)"):format(TimeLeft)
				end
				actionClone:SetAttribute("LastPing", os.clock())
				actionClone:SetAttribute("LastPercentage",percentage)
				Time.Text = Display
			end
		end
	end
	
	function C.GetAction(name)
		local actionInstance = ActionsList:FindFirstChild(name)
		if actionInstance then
			return actionInstance
		end
	end
	
	function C.RemoveAction(name)
		local actionInstance = ActionsList:FindFirstChild(name)
		if actionInstance then
			local event = actionInstance:FindFirstChild("StopEvent")
			if event then
				event:Fire()
			end
		end
		if C.getgenv().ActionsList[name] then
			C.getgenv().ActionsList[name] = nil
		end
	end
	
	function C.GetActionsWithTag(tagName:string)
		local Items = {}
		for name, data in pairs(C.getgenv().ActionsList) do
			if table.find(data.Tags,tagName) then
				C.RemoveAction(name)
				Items[name] = data
			end
		end
		return Items
	end
	
	function C.PurgeActionsWithTag(tagName:string)
		for name, data in pairs(C.GetActionsWithTag(tagName)) do
			C.RemoveAction(name)
		end
	end

	ActionsFrame.Visible = false

	for name, actionData in pairs(C.getgenv().ActionsList) do
		C.AddAction(actionData)
	end

	--Add Prompt control
	local PromptFrame=C.UI.Prompt
	local count=0
	local queue,canRunEvent={},Instance.new("BindableEvent",script)
	local buttonTriggerEvent=Instance.new("BindableEvent",script)
	buttonTriggerEvent:AddTag("RemoveOnDestroy")
	canRunEvent:AddTag("RemoveOnDestroy")

	for _, button in ipairs(PromptFrame.PromptButtons:GetChildren()) do
		C.ButtonClick(button,function()
			buttonTriggerEvent:Fire(button.Name)
		end)
	end

	function C.Prompt(Title: string,Desc: string,Buttons: table): string
		count+=1
		local saveNum=count
		table.insert(queue,saveNum)
		while table.find(queue,saveNum)~=1 do
			canRunEvent.Event:Wait()
		end
		PromptFrame.PromptTitle.Text=Title
		PromptFrame.PromptTitle.TextColor3=C.ComputeNameColor(Title)
		PromptFrame.PromptDesc.Text=Desc
		--PromptFrame.PictureLabel.Visible = Image~=nil
		--PromptFrame.PictureLabel.Image = Image~=nil and Image or 0
		--PromptFrame.DescLabel.Size = Image~=nil and UDim2.fromScale(.575, .541) or UDim2.fromScale(.9,.541)
		local buttonCount=0
		for num, button in ipairs(PromptFrame.PromptButtons:GetChildren()) do
			if not button:IsA("UIBase") then
				continue
			end
			if button.Name == "Ok" then
				button.Visible = Buttons == "Ok" or not Buttons
			elseif button.Name == "Yes" or button.Name == "No" then
				button.Visible = Buttons == "Y/N"
			else
				error(`[Prompt]: Unknown Button: {button.Name}`)
			end
			if button.Visible then
				buttonCount+=1
			end
		end
		--PromptFrame.Buttons.UIGridLayout.CellSize=UDim2.new(1/buttonCount,-3,1,0)
		PromptFrame.Position=UDim2.new(0.5, 0,-PromptFrame.Size.Y.Scale/2, -36)
		PromptFrame:TweenPosition(UDim2.new(0.5, 0,.5, 18),"Out","Quad",3/8,true)
		PromptFrame.Visible=true
		local result=buttonTriggerEvent.Event:Wait()
		buttonTriggerEvent:Destroy()
		PromptFrame:TweenPosition(UDim2.new(0.5,0,1+PromptFrame.Size.Y.Scale/2,36),"Out","Quad",3/8,true)
		task.delay(3/8,function()
			C.TblRemove(queue,saveNum)
			if #queue<=0 then
				PromptFrame.Visible=false
			end
			canRunEvent:Fire()
		end)
		return result
	end

	task.delay(3,function()
		while true do
			print(C.Prompt("HELLO","wjgeowirjgioewjigjewiotejwijgmqeogfqeoikqek","Ok"))
			task.wait()
		end
	end)

	--Kick button

	C.ButtonClick(C.UI.KickedButton,function()
		C.UI.KickedButton:Destroy()
		C.UI.KickedButton = nil
	end)

	--Load Servers
	local SecondaryHUD = C.UI.SecondaryHUD
	local ServersFrame = SecondaryHUD:WaitForChild("Servers")

	local MainScroll = ServersFrame:WaitForChild("MainScroll")
	local TabsSelection = ServersFrame:WaitForChild("TabsSelection")
	local BottomButtons = ServersFrame:WaitForChild("BottomButtons")
	local ServersTL = ServersFrame:WaitForChild("ServersTitleLabel")

	local function ActivateServers(tabName: string)
		C.ClearChildren(MainScroll)
		if tabName == "Recent" then
			local index = 0
			for num, data in ipairs(C.getgenv().PreviousServers) do
				if data.GameId == game.GameId then
					index+=1
					local serverClone = C.Examples.ServerEx:Clone()
					serverClone.Name = index
					serverClone.ServerTitle.Text = `Server {index}`
					serverClone.SecondData.Text = `{data.Players}/{data.MaxPlayers} Players`
					serverClone.TimeStamp.Text = `{C.FormatTimeFromUnix(data.Time)}`
					serverClone.LayoutOrder = index
					serverClone.BackgroundColor3 = C.ComputeNameColor(data.JobId)
					serverClone.Parent = MainScroll
				end
			end
		end
		local hasArrows = tabName == "All"
		MainScroll.Size = UDim2.fromScale(.7,hasArrows and 0.76 or 0.9)
		BottomButtons.Visible = hasArrows
		ServersTL.Text = `{tabName} SERVERS`
	end

	local Visible = true
	function C.ToggleServersVisiblity()
		Visible = not Visible
		SecondaryHUD.Visible = Visible
	end
	C.ToggleServersVisiblity()

	for num, button in ipairs(TabsSelection:GetChildren()) do
		if button:IsA("TextButton") then
			if button.Name ~= "Close" then
				C.ButtonClick(button, function()
					ActivateServers(button.Name)
				end)
			else
				C.ButtonClick(button, C.ToggleServersVisiblity)
			end
		end
	end
	
	
	--Load Settings Loader
	C.ExtraOptions = C.LoadModule("HackOptions")
	
	C.UI.CategoriesFrame = CategoriesFrame
	C.UI.TabsFrame = TabsFrame
	
	C.GUI = SpecterGUI

	ActionsFrame.Position = UDim2.fromOffset(0, C.GUI.AbsoluteSize.Y * 3)
	C.MakeDraggableTab(ActionsFrame, true)
end