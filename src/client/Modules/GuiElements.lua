local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local RS = game:GetService("ReplicatedStorage")
local RunS = game:GetService("RunService")
local HS = game:GetService("HttpService")

local function LoadCore(C,Settings)
-- Gui to Lua
-- Version: 3.2

-- Instances:

local GuiTbl = {
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
	Game = Instance.new("TextButton"),
	UICorner_17 = Instance.new("UICorner"),
	UIStroke_18 = Instance.new("UIStroke"),
	UIGridLayout = Instance.new("UIGridLayout"),
	Recent = Instance.new("TextButton"),
	UICorner_18 = Instance.new("UICorner"),
	UIStroke_19 = Instance.new("UIStroke"),
	Close = Instance.new("TextButton"),
	UICorner_19 = Instance.new("UICorner"),
	UIStroke_20 = Instance.new("UIStroke"),
	Friend = Instance.new("TextButton"),
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
	PromptTitle = Instance.new("TextLabel"),
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

GuiTbl.SpecterGUI.Name = "SpecterGUI"

GuiTbl.SpecterGUI.DisplayOrder = -1
GuiTbl.SpecterGUI.ResetOnSpawn = false

GuiTbl.MainHUD.Name = "MainHUD"
GuiTbl.MainHUD.Parent = GuiTbl.SpecterGUI
C.UI.MainHUD = GuiTbl.MainHUD
GuiTbl.MainHUD.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.MainHUD.BackgroundTransparency = 1.000
GuiTbl.MainHUD.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.MainHUD.BorderSizePixel = 0
GuiTbl.MainHUD.Size = UDim2.new(1, 0, 1, 0)

GuiTbl.DropdownFrame.Name = "DropdownFrame"
GuiTbl.DropdownFrame.Parent = GuiTbl.MainHUD
C.UI.DropdownFrame = GuiTbl.DropdownFrame
GuiTbl.DropdownFrame.AutomaticSize = Enum.AutomaticSize.Y
GuiTbl.DropdownFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
GuiTbl.DropdownFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.DropdownFrame.BorderSizePixel = 0
GuiTbl.DropdownFrame.Position = UDim2.new(0, 532, 0, 332)
GuiTbl.DropdownFrame.Size = UDim2.new(0, 92, 0, 0)
GuiTbl.DropdownFrame.Visible = false
GuiTbl.DropdownFrame.ZIndex = 20

GuiTbl.UIListLayout.Parent = GuiTbl.DropdownFrame
GuiTbl.UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

GuiTbl.DropdownButtonEx.Name = "DropdownButtonEx"
GuiTbl.DropdownButtonEx:AddTag("RemoveOnDestroy")
C.Examples.DropdownButtonEx = GuiTbl.DropdownButtonEx
GuiTbl.DropdownButtonEx.AnchorPoint = Vector2.new(1, 0.5)
GuiTbl.DropdownButtonEx.BackgroundColor3 = Color3.fromRGB(39, 39, 39)
GuiTbl.DropdownButtonEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.DropdownButtonEx.BorderSizePixel = 0
GuiTbl.DropdownButtonEx.Position = UDim2.new(0.970000029, 0, 0.5, 0)
GuiTbl.DropdownButtonEx.Size = UDim2.new(1, 0, 0, 30)
GuiTbl.DropdownButtonEx.ZIndex = 21
GuiTbl.DropdownButtonEx.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.DropdownButtonEx.Text = "God Mode"
GuiTbl.DropdownButtonEx.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.DropdownButtonEx.TextScaled = true
GuiTbl.DropdownButtonEx.TextSize = 14.000
GuiTbl.DropdownButtonEx.TextStrokeTransparency = 0.000
GuiTbl.DropdownButtonEx.TextWrapped = true

GuiTbl.UICorner.Parent = GuiTbl.DropdownButtonEx

GuiTbl.UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke.Parent = GuiTbl.DropdownButtonEx

GuiTbl.CategoriesFrame.Name = "CategoriesFrame"
GuiTbl.CategoriesFrame.Parent = GuiTbl.MainHUD
C.UI.CategoriesFrame = GuiTbl.CategoriesFrame
GuiTbl.CategoriesFrame.Active = true
GuiTbl.CategoriesFrame.AutomaticSize = Enum.AutomaticSize.Y
GuiTbl.CategoriesFrame.BackgroundColor3 = Color3.fromRGB(39, 39, 39)
GuiTbl.CategoriesFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.CategoriesFrame.BorderSizePixel = 0
GuiTbl.CategoriesFrame.LayoutOrder = -15
GuiTbl.CategoriesFrame.Position = UDim2.new(0, 30, 0, 100)
GuiTbl.CategoriesFrame.Size = UDim2.new(0, 200, 0, 0)

GuiTbl.Buttons.Name = "Buttons"
GuiTbl.Buttons.Parent = GuiTbl.CategoriesFrame
GuiTbl.Buttons.AutomaticSize = Enum.AutomaticSize.Y
GuiTbl.Buttons.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Buttons.BackgroundTransparency = 1.000
GuiTbl.Buttons.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Buttons.BorderSizePixel = 0
GuiTbl.Buttons.Position = UDim2.new(0, 0, 0, 40)
GuiTbl.Buttons.Size = UDim2.new(1, 0, 0, 0)

GuiTbl.CategoryEx.Name = "CategoryEx"
GuiTbl.CategoryEx:AddTag("RemoveOnDestroy")
C.Examples.CategoryEx = GuiTbl.CategoryEx
GuiTbl.CategoryEx.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.CategoryEx.BackgroundTransparency = 1.000
GuiTbl.CategoryEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.CategoryEx.BorderSizePixel = 0
GuiTbl.CategoryEx.LayoutOrder = 1
GuiTbl.CategoryEx.Size = UDim2.new(1, 0, 0, 40)

GuiTbl.Image.Name = "Image"
GuiTbl.Image.Parent = GuiTbl.CategoryEx
GuiTbl.Image.Active = true
GuiTbl.Image.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Image.BackgroundTransparency = 1.000
GuiTbl.Image.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Image.BorderSizePixel = 0
GuiTbl.Image.Size = UDim2.new(0.150000006, 0, 1, 0)
C.SetImage(GuiTbl.Image,"rbxasset://textures/ui/GuiImagePlaceholder.png")
GuiTbl.Image.ScaleType = Enum.ScaleType.Fit

GuiTbl.Text.Name = "Text"
GuiTbl.Text.Parent = GuiTbl.CategoryEx
GuiTbl.Text.Active = true
GuiTbl.Text.AnchorPoint = Vector2.new(0, 0.5)
GuiTbl.Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Text.BackgroundTransparency = 1.000
GuiTbl.Text.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Text.BorderSizePixel = 0
GuiTbl.Text.Position = UDim2.new(0.150000006, 0, 0.5, 0)
GuiTbl.Text.Size = UDim2.new(0.670000017, 0, 0.730000019, 0)
GuiTbl.Text.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.Text.Text = " Render"
GuiTbl.Text.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Text.TextScaled = true
GuiTbl.Text.TextSize = 14.000
GuiTbl.Text.TextWrapped = true
GuiTbl.Text.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.Arrow.Name = "Arrow"
GuiTbl.Arrow.Parent = GuiTbl.CategoryEx
GuiTbl.Arrow.Active = true
GuiTbl.Arrow.AnchorPoint = Vector2.new(0, 0.5)
GuiTbl.Arrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Arrow.BackgroundTransparency = 1.000
GuiTbl.Arrow.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Arrow.BorderSizePixel = 0
GuiTbl.Arrow.Position = UDim2.new(0.779999971, 0, 0.5, 0)
GuiTbl.Arrow.Size = UDim2.new(0.199999779, 0, 0.730000138, 0)
GuiTbl.Arrow.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.Arrow.Text = ">"
GuiTbl.Arrow.TextColor3 = Color3.fromRGB(115, 115, 115)
GuiTbl.Arrow.TextScaled = true
GuiTbl.Arrow.TextSize = 14.000
GuiTbl.Arrow.TextWrapped = true

GuiTbl.BottomFrame.Name = "BottomFrame"
GuiTbl.BottomFrame.Parent = GuiTbl.Buttons
GuiTbl.BottomFrame.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
GuiTbl.BottomFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.BottomFrame.BorderSizePixel = 0
GuiTbl.BottomFrame.LayoutOrder = 12000
GuiTbl.BottomFrame.Size = UDim2.new(1, 0, 0, 40)

GuiTbl.SaveButton.Name = "SaveButton"
GuiTbl.SaveButton.Parent = GuiTbl.BottomFrame
GuiTbl.SaveButton.Active = true
GuiTbl.SaveButton.AnchorPoint = Vector2.new(0, 0.5)
GuiTbl.SaveButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.SaveButton.BackgroundTransparency = 1.000
GuiTbl.SaveButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.SaveButton.BorderSizePixel = 0
GuiTbl.SaveButton.Position = UDim2.new(0, 0, 0.5, 0)
GuiTbl.SaveButton.Size = UDim2.new(0.200000003, 0, 0.899999976, 0)
C.SetImage(GuiTbl.SaveButton,"rbxassetid://14737163568")
GuiTbl.SaveButton.ScaleType = Enum.ScaleType.Fit

GuiTbl.Wait.Name = "Wait"
GuiTbl.Wait.Parent = GuiTbl.SaveButton
GuiTbl.Wait.AnchorPoint = Vector2.new(0.5, 0.5)
GuiTbl.Wait.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Wait.BackgroundTransparency = 1.000
GuiTbl.Wait.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Wait.BorderSizePixel = 0
GuiTbl.Wait.Position = UDim2.new(0.5, 0, 0.5, 0)
GuiTbl.Wait.Size = UDim2.new(0.800000012, 0, 0.800000012, 0)
GuiTbl.Wait.Visible = false
GuiTbl.Wait.FontFace = Font.new("rbxasset://fonts/families/ComicNeueAngular.json",Enum.FontWeight.Regular,Enum.FontStyle.Normal)
GuiTbl.Wait.Text = "•••"
GuiTbl.Wait.TextColor3 = Color3.fromRGB(143, 143, 143)
GuiTbl.Wait.TextScaled = true
GuiTbl.Wait.TextSize = 40.000
GuiTbl.Wait.TextStrokeTransparency = 0.000
GuiTbl.Wait.TextWrapped = true

GuiTbl.UICorner_2.CornerRadius = UDim.new(2, 0)
GuiTbl.UICorner_2.Parent = GuiTbl.Wait

GuiTbl.UIListLayout_2.Parent = GuiTbl.Buttons
GuiTbl.UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder

GuiTbl.MiscDivider.Name = "MiscDivider"
GuiTbl.MiscDivider.Parent = GuiTbl.Buttons
GuiTbl.MiscDivider.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
GuiTbl.MiscDivider.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.MiscDivider.BorderSizePixel = 0
GuiTbl.MiscDivider.LayoutOrder = 2000
GuiTbl.MiscDivider.Size = UDim2.new(1, 0, 0, 24)

GuiTbl.MiscLabel.Name = "MiscLabel"
GuiTbl.MiscLabel.Parent = GuiTbl.MiscDivider
GuiTbl.MiscLabel.AnchorPoint = Vector2.new(0, 0.5)
GuiTbl.MiscLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.MiscLabel.BackgroundTransparency = 1.000
GuiTbl.MiscLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.MiscLabel.BorderSizePixel = 0
GuiTbl.MiscLabel.Position = UDim2.new(0.100000001, 0, 0.5, 0)
GuiTbl.MiscLabel.Size = UDim2.new(0.699999988, 0, 0.800000012, 0)
GuiTbl.MiscLabel.FontFace = Font.new("rbxasset://fonts/families/Nunito.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.MiscLabel.Text = "MISC"
GuiTbl.MiscLabel.TextColor3 = Color3.fromRGB(111, 111, 111)
GuiTbl.MiscLabel.TextScaled = true
GuiTbl.MiscLabel.TextSize = 14.000
GuiTbl.MiscLabel.TextStrokeTransparency = 0.000
GuiTbl.MiscLabel.TextWrapped = true
GuiTbl.MiscLabel.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.HeaderTab.Name = "HeaderTab"
GuiTbl.HeaderTab.Parent = GuiTbl.CategoriesFrame
GuiTbl.HeaderTab.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
GuiTbl.HeaderTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.HeaderTab.BorderSizePixel = 0
GuiTbl.HeaderTab.LayoutOrder = -20
GuiTbl.HeaderTab.Size = UDim2.new(1, 0, 0, 40)

GuiTbl.HeaderTitleLabel.Name = "HeaderTitleLabel"
GuiTbl.HeaderTitleLabel.Parent = GuiTbl.HeaderTab
GuiTbl.HeaderTitleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.HeaderTitleLabel.BackgroundTransparency = 1.000
GuiTbl.HeaderTitleLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.HeaderTitleLabel.BorderSizePixel = 0
GuiTbl.HeaderTitleLabel.Size = UDim2.new(0.600000024, 0, 1, 0)
GuiTbl.HeaderTitleLabel.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.HeaderTitleLabel.Text = " SPECTER"
GuiTbl.HeaderTitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.HeaderTitleLabel.TextScaled = true
GuiTbl.HeaderTitleLabel.TextSize = 14.000
GuiTbl.HeaderTitleLabel.TextStrokeTransparency = 0.000
GuiTbl.HeaderTitleLabel.TextWrapped = true
GuiTbl.HeaderTitleLabel.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.SettingsButton.Name = "SettingsButton"
GuiTbl.SettingsButton.Parent = GuiTbl.HeaderTab
GuiTbl.SettingsButton.AnchorPoint = Vector2.new(1, 0.5)
GuiTbl.SettingsButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.SettingsButton.BackgroundTransparency = 1.000
GuiTbl.SettingsButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.SettingsButton.BorderSizePixel = 0
GuiTbl.SettingsButton.Position = UDim2.new(0.980000019, 0, 0.5, 0)
GuiTbl.SettingsButton.Size = UDim2.new(0.200000003, 0, 0.800000012, 0)
GuiTbl.SettingsButton.ZIndex = 50
C.SetImage(GuiTbl.SettingsButton,"rbxassetid://14134158045")
GuiTbl.SettingsButton.ScaleType = Enum.ScaleType.Fit

GuiTbl.Settings.Name = "Settings"
GuiTbl.Settings.Parent = GuiTbl.CategoriesFrame
GuiTbl.Settings.AutomaticSize = Enum.AutomaticSize.Y
GuiTbl.Settings.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Settings.BackgroundTransparency = 1.000
GuiTbl.Settings.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Settings.BorderSizePixel = 0
GuiTbl.Settings.Position = UDim2.new(0, 0, 0, 40)
GuiTbl.Settings.Size = UDim2.new(1, 0, 0, 0)
GuiTbl.Settings.Visible = false

GuiTbl.SupportedFrame.Name = "SupportedFrame"
GuiTbl.SupportedFrame.Parent = GuiTbl.Settings
GuiTbl.SupportedFrame.AutomaticSize = Enum.AutomaticSize.Y
GuiTbl.SupportedFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.SupportedFrame.BackgroundTransparency = 1.000
GuiTbl.SupportedFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.SupportedFrame.BorderSizePixel = 0
GuiTbl.SupportedFrame.LayoutOrder = 1
GuiTbl.SupportedFrame.Size = UDim2.new(1, 0, 0, 0)

GuiTbl.Image_2.Name = "Image"
GuiTbl.Image_2.Parent = GuiTbl.SupportedFrame
GuiTbl.Image_2.Active = true
GuiTbl.Image_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Image_2.BackgroundTransparency = 1.000
GuiTbl.Image_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Image_2.BorderSizePixel = 0
GuiTbl.Image_2.Size = UDim2.new(0.150000006, 0, 1, 0)
C.SetImage(GuiTbl.Image_2,"rbxasset://textures/ui/GuiImagePlaceholder.png")
GuiTbl.Image_2.ScaleType = Enum.ScaleType.Fit

GuiTbl.Description.Name = "Description"
GuiTbl.Description.Parent = GuiTbl.SupportedFrame
GuiTbl.Description.Active = true
GuiTbl.Description.AutomaticSize = Enum.AutomaticSize.Y
GuiTbl.Description.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Description.BackgroundTransparency = 1.000
GuiTbl.Description.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Description.BorderSizePixel = 0
GuiTbl.Description.Position = UDim2.new(0.150000006, 0, 0, 20)
GuiTbl.Description.Size = UDim2.new(0.790000021, 0, 0, 0)
GuiTbl.Description.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.Description.Text = " Render"
GuiTbl.Description.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Description.TextSize = 14.000
GuiTbl.Description.TextWrapped = true
GuiTbl.Description.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.Supported.Name = "Supported"
GuiTbl.Supported.Parent = GuiTbl.SupportedFrame
GuiTbl.Supported.Active = true
GuiTbl.Supported.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Supported.BackgroundTransparency = 1.000
GuiTbl.Supported.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Supported.BorderSizePixel = 0
GuiTbl.Supported.Position = UDim2.new(0.150000006, 0, 0, 0)
GuiTbl.Supported.Size = UDim2.new(0.790000021, 0, 0, 20)
GuiTbl.Supported.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.Supported.Text = "Supported Game"
GuiTbl.Supported.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Supported.TextScaled = true
GuiTbl.Supported.TextSize = 14.000
GuiTbl.Supported.TextWrapped = true
GuiTbl.Supported.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.BottomFrame_2.Name = "BottomFrame"
GuiTbl.BottomFrame_2.Parent = GuiTbl.Settings
GuiTbl.BottomFrame_2.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
GuiTbl.BottomFrame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.BottomFrame_2.BorderSizePixel = 0
GuiTbl.BottomFrame_2.LayoutOrder = 50
GuiTbl.BottomFrame_2.Size = UDim2.new(1, 0, 0, 40)

GuiTbl.RefreshButton.Name = "RefreshButton"
GuiTbl.RefreshButton.Parent = GuiTbl.BottomFrame_2
GuiTbl.RefreshButton.Active = true
GuiTbl.RefreshButton.AnchorPoint = Vector2.new(1, 0.5)
GuiTbl.RefreshButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
GuiTbl.RefreshButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.RefreshButton.BorderSizePixel = 0
GuiTbl.RefreshButton.Position = UDim2.new(1, -1, 0.5, 0)
GuiTbl.RefreshButton.Size = UDim2.new(0, 36, 0, 36)
C.SetImage(GuiTbl.RefreshButton,"rbxassetid://13492317101")
GuiTbl.RefreshButton.ScaleType = Enum.ScaleType.Fit

GuiTbl.UICorner_3.CornerRadius = UDim.new(0, 999)
GuiTbl.UICorner_3.Parent = GuiTbl.RefreshButton

GuiTbl.UIStroke_2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_2.Parent = GuiTbl.RefreshButton

GuiTbl.UIListLayout_3.Parent = GuiTbl.Settings
GuiTbl.UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder

GuiTbl.HackDivider.Name = "HackDivider"
GuiTbl.HackDivider.Parent = GuiTbl.Settings
GuiTbl.HackDivider.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
GuiTbl.HackDivider.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.HackDivider.BorderSizePixel = 0
GuiTbl.HackDivider.LayoutOrder = 20
GuiTbl.HackDivider.Size = UDim2.new(1, 0, 0, 24)

GuiTbl.HackLabel.Name = "HackLabel"
GuiTbl.HackLabel.Parent = GuiTbl.HackDivider
GuiTbl.HackLabel.AnchorPoint = Vector2.new(0, 0.5)
GuiTbl.HackLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.HackLabel.BackgroundTransparency = 1.000
GuiTbl.HackLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.HackLabel.BorderSizePixel = 0
GuiTbl.HackLabel.Position = UDim2.new(0.100000001, 0, 0.5, 0)
GuiTbl.HackLabel.Size = UDim2.new(0.699999988, 0, 0.800000012, 0)
GuiTbl.HackLabel.FontFace = Font.new("rbxasset://fonts/families/Nunito.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.HackLabel.Text = "HACK"
GuiTbl.HackLabel.TextColor3 = Color3.fromRGB(111, 111, 111)
GuiTbl.HackLabel.TextScaled = true
GuiTbl.HackLabel.TextSize = 14.000
GuiTbl.HackLabel.TextStrokeTransparency = 0.000
GuiTbl.HackLabel.TextWrapped = true
GuiTbl.HackLabel.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.GameDivider.Name = "GameDivider"
GuiTbl.GameDivider.Parent = GuiTbl.Settings
GuiTbl.GameDivider.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
GuiTbl.GameDivider.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.GameDivider.BorderSizePixel = 0
GuiTbl.GameDivider.LayoutOrder = -20
GuiTbl.GameDivider.Size = UDim2.new(1, 0, 0, 24)

GuiTbl.GameLabel.Name = "GameLabel"
GuiTbl.GameLabel.Parent = GuiTbl.GameDivider
GuiTbl.GameLabel.AnchorPoint = Vector2.new(0, 0.5)
GuiTbl.GameLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.GameLabel.BackgroundTransparency = 1.000
GuiTbl.GameLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.GameLabel.BorderSizePixel = 0
GuiTbl.GameLabel.Position = UDim2.new(0.100000001, 0, 0.5, 0)
GuiTbl.GameLabel.Size = UDim2.new(0.699999988, 0, 0.800000012, 0)
GuiTbl.GameLabel.FontFace = Font.new("rbxasset://fonts/families/Nunito.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.GameLabel.Text = "GAME"
GuiTbl.GameLabel.TextColor3 = Color3.fromRGB(111, 111, 111)
GuiTbl.GameLabel.TextScaled = true
GuiTbl.GameLabel.TextSize = 14.000
GuiTbl.GameLabel.TextStrokeTransparency = 0.000
GuiTbl.GameLabel.TextWrapped = true
GuiTbl.GameLabel.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.ScrollTab.Name = "ScrollTab"
GuiTbl.ScrollTab.Parent = GuiTbl.Settings
GuiTbl.ScrollTab.AutomaticSize = Enum.AutomaticSize.Y
GuiTbl.ScrollTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.ScrollTab.BackgroundTransparency = 1.000
GuiTbl.ScrollTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.ScrollTab.BorderSizePixel = 0
GuiTbl.ScrollTab.LayoutOrder = 40
GuiTbl.ScrollTab.Position = UDim2.new(0, 0, 0, 45)
GuiTbl.ScrollTab.Size = UDim2.new(1, 0, 0, 0)
GuiTbl.ScrollTab.ZIndex = 0
GuiTbl.ScrollTab.AutomaticCanvasSize = Enum.AutomaticSize.Y
GuiTbl.ScrollTab.BottomImage = "rbxassetid://3062505976"
GuiTbl.ScrollTab.CanvasSize = UDim2.new(0, 0, 0, 0)
GuiTbl.ScrollTab.MidImage = "rbxassetid://3062506202"
GuiTbl.ScrollTab.TopImage = "rbxassetid://3062506445"
GuiTbl.ScrollTab.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar

GuiTbl.UIListLayout_4.Parent = GuiTbl.ScrollTab
GuiTbl.UIListLayout_4.SortOrder = Enum.SortOrder.LayoutOrder

GuiTbl.TabsFrame.Name = "TabsFrame"
GuiTbl.TabsFrame.Parent = GuiTbl.MainHUD
C.UI.TabsFrame = GuiTbl.TabsFrame
GuiTbl.TabsFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.TabsFrame.BackgroundTransparency = 1.000
GuiTbl.TabsFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.TabsFrame.BorderSizePixel = 0
GuiTbl.TabsFrame.LayoutOrder = -15
GuiTbl.TabsFrame.Size = UDim2.new(1, 0, 1, 0)
GuiTbl.TabsFrame.ZIndex = -15

GuiTbl.TabEx.Name = "TabEx"
GuiTbl.TabEx:AddTag("RemoveOnDestroy")
C.Examples.TabEx = GuiTbl.TabEx
GuiTbl.TabEx.BackgroundColor3 = Color3.fromRGB(39, 39, 39)
GuiTbl.TabEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.TabEx.BorderSizePixel = 0
GuiTbl.TabEx.LayoutOrder = -14
GuiTbl.TabEx.Position = UDim2.new(0, 400, 0, 100)
GuiTbl.TabEx.Size = UDim2.new(0, 230, 0, 400)
GuiTbl.TabEx.ZIndex = -14

GuiTbl.HeaderTab_2.Name = "HeaderTab"
GuiTbl.HeaderTab_2.Parent = GuiTbl.TabEx
GuiTbl.HeaderTab_2.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
GuiTbl.HeaderTab_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.HeaderTab_2.BorderSizePixel = 0
GuiTbl.HeaderTab_2.LayoutOrder = -13
GuiTbl.HeaderTab_2.Size = UDim2.new(1, 0, 0, 45)
GuiTbl.HeaderTab_2.ZIndex = -13

GuiTbl.HeaderTitleLabel_2.Name = "HeaderTitleLabel"
GuiTbl.HeaderTitleLabel_2.Parent = GuiTbl.HeaderTab_2
GuiTbl.HeaderTitleLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.HeaderTitleLabel_2.BackgroundTransparency = 1.000
GuiTbl.HeaderTitleLabel_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.HeaderTitleLabel_2.BorderSizePixel = 0
GuiTbl.HeaderTitleLabel_2.LayoutOrder = -12
GuiTbl.HeaderTitleLabel_2.Size = UDim2.new(0.600000024, 0, 1, 0)
GuiTbl.HeaderTitleLabel_2.Visible = false
GuiTbl.HeaderTitleLabel_2.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.HeaderTitleLabel_2.Text = " SPECTER"
GuiTbl.HeaderTitleLabel_2.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.HeaderTitleLabel_2.TextScaled = true
GuiTbl.HeaderTitleLabel_2.TextSize = 14.000
GuiTbl.HeaderTitleLabel_2.TextStrokeTransparency = 0.000
GuiTbl.HeaderTitleLabel_2.TextWrapped = true
GuiTbl.HeaderTitleLabel_2.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.DropDownButton.Name = "DropDownButton"
GuiTbl.DropDownButton.Parent = GuiTbl.HeaderTab_2
GuiTbl.DropDownButton.AnchorPoint = Vector2.new(1, 0.5)
GuiTbl.DropDownButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.DropDownButton.BackgroundTransparency = 1.000
GuiTbl.DropDownButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.DropDownButton.BorderSizePixel = 0
GuiTbl.DropDownButton.LayoutOrder = -12
GuiTbl.DropDownButton.Position = UDim2.new(0.980000019, 0, 0.5, 0)
GuiTbl.DropDownButton.Size = UDim2.new(0.200000003, 0, 0.5, 0)
C.SetImage(GuiTbl.DropDownButton,"rbxassetid://14569017448")
GuiTbl.DropDownButton.ScaleType = Enum.ScaleType.Fit

GuiTbl.Text_2.Name = "Text"
GuiTbl.Text_2.Parent = GuiTbl.HeaderTab_2
GuiTbl.Text_2.AnchorPoint = Vector2.new(0, 0.5)
GuiTbl.Text_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Text_2.BackgroundTransparency = 1.000
GuiTbl.Text_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Text_2.BorderSizePixel = 0
GuiTbl.Text_2.LayoutOrder = -12
GuiTbl.Text_2.Position = UDim2.new(0.150000036, 0, 0.5, 0)
GuiTbl.Text_2.Size = UDim2.new(0.629999697, 0, 0.730000138, 0)
GuiTbl.Text_2.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.Text_2.Text = " Render"
GuiTbl.Text_2.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Text_2.TextScaled = true
GuiTbl.Text_2.TextSize = 14.000
GuiTbl.Text_2.TextWrapped = true
GuiTbl.Text_2.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.Image_3.Name = "Image"
GuiTbl.Image_3.Parent = GuiTbl.HeaderTab_2
GuiTbl.Image_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Image_3.BackgroundTransparency = 1.000
GuiTbl.Image_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Image_3.BorderSizePixel = 0
GuiTbl.Image_3.LayoutOrder = -12
GuiTbl.Image_3.Size = UDim2.new(0.150000006, 0, 1, 0)
C.SetImage(GuiTbl.Image_3,"rbxasset://textures/ui/GuiImagePlaceholder.png")
GuiTbl.Image_3.ScaleType = Enum.ScaleType.Fit

GuiTbl.ScrollTab_2.Name = "ScrollTab"
GuiTbl.ScrollTab_2.Parent = GuiTbl.TabEx
GuiTbl.ScrollTab_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.ScrollTab_2.BackgroundTransparency = 1.000
GuiTbl.ScrollTab_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.ScrollTab_2.BorderSizePixel = 0
GuiTbl.ScrollTab_2.LayoutOrder = -13
GuiTbl.ScrollTab_2.Position = UDim2.new(0, 0, 0, 45)
GuiTbl.ScrollTab_2.Size = UDim2.new(1, 0, 0, 300)
GuiTbl.ScrollTab_2.ZIndex = 0
GuiTbl.ScrollTab_2.AutomaticCanvasSize = Enum.AutomaticSize.Y
GuiTbl.ScrollTab_2.BottomImage = "rbxassetid://3062505976"
GuiTbl.ScrollTab_2.CanvasSize = UDim2.new(0, 0, 0, 0)
GuiTbl.ScrollTab_2.MidImage = "rbxassetid://3062506202"
GuiTbl.ScrollTab_2.TopImage = "rbxassetid://3062506445"
GuiTbl.ScrollTab_2.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar

GuiTbl.UIListLayout_5.Parent = GuiTbl.ScrollTab_2
GuiTbl.UIListLayout_5.SortOrder = Enum.SortOrder.LayoutOrder

GuiTbl.HackButtonEx.Name = "HackButtonEx"
GuiTbl.HackButtonEx:AddTag("RemoveOnDestroy")
C.Examples.HackButtonEx = GuiTbl.HackButtonEx
GuiTbl.HackButtonEx.AutomaticSize = Enum.AutomaticSize.Y
GuiTbl.HackButtonEx.BackgroundColor3 = Color3.fromRGB(39, 39, 39)
GuiTbl.HackButtonEx.BackgroundTransparency = 1.000
GuiTbl.HackButtonEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.HackButtonEx.BorderSizePixel = 0
GuiTbl.HackButtonEx.LayoutOrder = -12
GuiTbl.HackButtonEx.Size = UDim2.new(1, 0, 0, 0)

GuiTbl.HackText.Name = "HackText"
GuiTbl.HackText.Parent = GuiTbl.HackButtonEx
GuiTbl.HackText.Active = true
GuiTbl.HackText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.HackText.BackgroundTransparency = 1.000
GuiTbl.HackText.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.HackText.BorderSizePixel = 0
GuiTbl.HackText.Position = UDim2.new(0.0500000007, 0, 0, 0)
GuiTbl.HackText.Size = UDim2.new(0.649999976, 0, 0, 40)
GuiTbl.HackText.ZIndex = 2
GuiTbl.HackText.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.HackText.Text = "AimAssist"
GuiTbl.HackText.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.HackText.TextScaled = true
GuiTbl.HackText.TextSize = 14.000
GuiTbl.HackText.TextStrokeTransparency = 0.000
GuiTbl.HackText.TextWrapped = true
GuiTbl.HackText.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.HackExpand.Name = "HackExpand"
GuiTbl.HackExpand.Parent = GuiTbl.HackButtonEx
GuiTbl.HackExpand.Active = false
GuiTbl.HackExpand.AnchorPoint = Vector2.new(1, 0.5)
GuiTbl.HackExpand.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.HackExpand.BackgroundTransparency = 1.000
GuiTbl.HackExpand.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.HackExpand.BorderSizePixel = 0
GuiTbl.HackExpand.Position = UDim2.new(1, 0, 0, 20)
GuiTbl.HackExpand.Selectable = false
GuiTbl.HackExpand.Size = UDim2.new(0, 31, 0, 40)
GuiTbl.HackExpand.ZIndex = 3
C.SetImage(GuiTbl.HackExpand,"rbxassetid://12809025337")
GuiTbl.HackExpand.ScaleType = Enum.ScaleType.Fit

GuiTbl.OptionsList.Name = "OptionsList"
GuiTbl.OptionsList.Parent = GuiTbl.HackButtonEx
GuiTbl.OptionsList.AutomaticSize = Enum.AutomaticSize.Y
GuiTbl.OptionsList.BackgroundColor3 = Color3.fromRGB(58, 58, 58)
GuiTbl.OptionsList.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.OptionsList.BorderSizePixel = 0
GuiTbl.OptionsList.Position = UDim2.new(0, 0, 0, 40)
GuiTbl.OptionsList.Size = UDim2.new(1, 0, 0, 0)
GuiTbl.OptionsList.ZIndex = 2

GuiTbl.UIListLayout_6.Parent = GuiTbl.OptionsList
GuiTbl.UIListLayout_6.HorizontalAlignment = Enum.HorizontalAlignment.Center
GuiTbl.UIListLayout_6.SortOrder = Enum.SortOrder.LayoutOrder
GuiTbl.UIListLayout_6.Padding = UDim.new(0, 1)

GuiTbl.ToggleEx.Name = "ToggleEx"
GuiTbl.ToggleEx:AddTag("RemoveOnDestroy")
C.Examples.ToggleEx = GuiTbl.ToggleEx
GuiTbl.ToggleEx.BackgroundColor3 = Color3.fromRGB(0, 255, 102)
GuiTbl.ToggleEx.BackgroundTransparency = 1.000
GuiTbl.ToggleEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.ToggleEx.BorderSizePixel = 0
GuiTbl.ToggleEx.Size = UDim2.new(1, 0, 0, 40)

GuiTbl.NameTL.Name = "NameTL"
GuiTbl.NameTL.Parent = GuiTbl.ToggleEx
GuiTbl.NameTL.Active = true
GuiTbl.NameTL.AnchorPoint = Vector2.new(0, 0.5)
GuiTbl.NameTL.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.NameTL.BackgroundTransparency = 1.000
GuiTbl.NameTL.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.NameTL.BorderSizePixel = 0
GuiTbl.NameTL.Position = UDim2.new(0.0500000007, 0, 0.5, 0)
GuiTbl.NameTL.Size = UDim2.new(0.600000024, 0, 0, 30)
GuiTbl.NameTL.ZIndex = 2
GuiTbl.NameTL.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.NameTL.Text = "AimAssist"
GuiTbl.NameTL.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.NameTL.TextScaled = true
GuiTbl.NameTL.TextSize = 14.000
GuiTbl.NameTL.TextStrokeTransparency = 0.000
GuiTbl.NameTL.TextWrapped = true
GuiTbl.NameTL.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.ToggleSwitchSlider.Name = "ToggleSwitchSlider"
GuiTbl.ToggleSwitchSlider.Parent = GuiTbl.ToggleEx
GuiTbl.ToggleSwitchSlider.Active = false
GuiTbl.ToggleSwitchSlider.AnchorPoint = Vector2.new(1, 0.5)
GuiTbl.ToggleSwitchSlider.BackgroundColor3 = Color3.fromRGB(113, 113, 113)
GuiTbl.ToggleSwitchSlider.BorderColor3 = Color3.fromRGB(27, 42, 53)
GuiTbl.ToggleSwitchSlider.Position = UDim2.new(0.949999988, 0, 0.5, 0)
GuiTbl.ToggleSwitchSlider.Selectable = false
GuiTbl.ToggleSwitchSlider.Size = UDim2.new(0.25, 0, 0.600000024, 0)
GuiTbl.ToggleSwitchSlider.ZIndex = 2
GuiTbl.ToggleSwitchSlider.AutoButtonColor = false

GuiTbl.UICorner_4.CornerRadius = UDim.new(1, 0)
GuiTbl.UICorner_4.Parent = GuiTbl.ToggleSwitchSlider

GuiTbl.ToggleCircle.Name = "ToggleCircle"
GuiTbl.ToggleCircle.Parent = GuiTbl.ToggleSwitchSlider
GuiTbl.ToggleCircle.Active = true
GuiTbl.ToggleCircle.AnchorPoint = Vector2.new(0, 0.5)
GuiTbl.ToggleCircle.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
GuiTbl.ToggleCircle.BorderColor3 = Color3.fromRGB(27, 42, 53)
GuiTbl.ToggleCircle.Position = UDim2.new(0.603999972, 0, 0.5, 0)
GuiTbl.ToggleCircle.Size = UDim2.new(0.345999986, 0, 0.649999976, 0)
GuiTbl.ToggleCircle.ZIndex = 3

GuiTbl.UICorner_5.CornerRadius = UDim.new(0, 100)
GuiTbl.UICorner_5.Parent = GuiTbl.ToggleCircle

GuiTbl.UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(83, 83, 83))}
GuiTbl.UIGradient.Rotation = 90
GuiTbl.UIGradient.Parent = GuiTbl.ToggleCircle

GuiTbl.UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(83, 83, 83))}
GuiTbl.UIGradient_2.Rotation = 90
GuiTbl.UIGradient_2.Parent = GuiTbl.ToggleSwitchSlider

GuiTbl.UIStroke_3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_3.Parent = GuiTbl.ToggleEx

GuiTbl.SliderEx.Name = "SliderEx"
GuiTbl.SliderEx:AddTag("RemoveOnDestroy")
C.Examples.SliderEx = GuiTbl.SliderEx
GuiTbl.SliderEx.BackgroundColor3 = Color3.fromRGB(0, 255, 102)
GuiTbl.SliderEx.BackgroundTransparency = 1.000
GuiTbl.SliderEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.SliderEx.BorderSizePixel = 0
GuiTbl.SliderEx.Size = UDim2.new(1, 0, 0, 60)

GuiTbl.NameTL_2.Name = "NameTL"
GuiTbl.NameTL_2.Parent = GuiTbl.SliderEx
GuiTbl.NameTL_2.Active = true
GuiTbl.NameTL_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.NameTL_2.BackgroundTransparency = 1.000
GuiTbl.NameTL_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.NameTL_2.BorderSizePixel = 0
GuiTbl.NameTL_2.Position = UDim2.new(0.0500000007, 0, 0, 0)
GuiTbl.NameTL_2.Size = UDim2.new(0.600000024, 0, 0, 30)
GuiTbl.NameTL_2.ZIndex = 2
GuiTbl.NameTL_2.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.NameTL_2.Text = "Range"
GuiTbl.NameTL_2.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.NameTL_2.TextScaled = true
GuiTbl.NameTL_2.TextSize = 14.000
GuiTbl.NameTL_2.TextStrokeTransparency = 0.000
GuiTbl.NameTL_2.TextWrapped = true
GuiTbl.NameTL_2.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.SlidingBar.Name = "SlidingBar"
GuiTbl.SlidingBar.Parent = GuiTbl.SliderEx
GuiTbl.SlidingBar.AnchorPoint = Vector2.new(0.5, 1)
GuiTbl.SlidingBar.BackgroundColor3 = Color3.fromRGB(44, 44, 44)
GuiTbl.SlidingBar.BorderColor3 = Color3.fromRGB(27, 42, 53)
GuiTbl.SlidingBar.Position = UDim2.new(0.5, 0, 0.879999995, 0)
GuiTbl.SlidingBar.Selectable = false
GuiTbl.SlidingBar.Size = UDim2.new(0.699999988, 0, 0, 15)
GuiTbl.SlidingBar.ZIndex = 2
GuiTbl.SlidingBar.AutoButtonColor = false

GuiTbl.UICorner_6.CornerRadius = UDim.new(1, 0)
GuiTbl.UICorner_6.Parent = GuiTbl.SlidingBar

GuiTbl.CurrentPosition.Name = "CurrentPosition"
GuiTbl.CurrentPosition.Parent = GuiTbl.SlidingBar
GuiTbl.CurrentPosition.Active = true
GuiTbl.CurrentPosition.AnchorPoint = Vector2.new(0.5, 0.5)
GuiTbl.CurrentPosition.BackgroundColor3 = Color3.fromRGB(89, 89, 89)
GuiTbl.CurrentPosition.BorderColor3 = Color3.fromRGB(27, 42, 53)
GuiTbl.CurrentPosition.Position = UDim2.new(0.200000003, 0, 0.5, 0)
GuiTbl.CurrentPosition.Size = UDim2.new(0.100000001, 0, 1, 0)
GuiTbl.CurrentPosition.ZIndex = 3

GuiTbl.UICorner_7.CornerRadius = UDim.new(0, 100)
GuiTbl.UICorner_7.Parent = GuiTbl.CurrentPosition

GuiTbl.UIGradient_3.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(83, 83, 83))}
GuiTbl.UIGradient_3.Rotation = 90
GuiTbl.UIGradient_3.Parent = GuiTbl.CurrentPosition

GuiTbl.UIGradient_4.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(83, 83, 83))}
GuiTbl.UIGradient_4.Rotation = 90
GuiTbl.UIGradient_4.Parent = GuiTbl.SlidingBar

GuiTbl.Backing.Name = "Backing"
GuiTbl.Backing.Parent = GuiTbl.SlidingBar
GuiTbl.Backing.AnchorPoint = Vector2.new(0.5, 0.5)
GuiTbl.Backing.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Backing.BackgroundTransparency = 1.000
GuiTbl.Backing.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Backing.BorderSizePixel = 0
GuiTbl.Backing.Position = UDim2.new(0.5, 0, 0.5, 0)
GuiTbl.Backing.Size = UDim2.new(1.29999995, 0, 1.70000005, 0)
GuiTbl.Backing.ZIndex = 9

GuiTbl.Track.Name = "Track"
GuiTbl.Track.Parent = GuiTbl.SlidingBar
GuiTbl.Track.AnchorPoint = Vector2.new(0.5, 0.5)
GuiTbl.Track.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Track.BackgroundTransparency = 1.000
GuiTbl.Track.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Track.BorderSizePixel = 0
GuiTbl.Track.Position = UDim2.new(0.5, 0, 0.5, 0)
GuiTbl.Track.Size = UDim2.new(0.899999976, 0, 0.100000001, 0)
GuiTbl.Track.ZIndex = 9

GuiTbl.ForceTB.Name = "ForceTB"
GuiTbl.ForceTB.Parent = GuiTbl.SliderEx
GuiTbl.ForceTB.AnchorPoint = Vector2.new(1, 0)
GuiTbl.ForceTB.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.ForceTB.BackgroundTransparency = 1.000
GuiTbl.ForceTB.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.ForceTB.BorderSizePixel = 0
GuiTbl.ForceTB.Position = UDim2.new(1, 0, 0, 0)
GuiTbl.ForceTB.Size = UDim2.new(0.300000012, 0, 0, 30)
GuiTbl.ForceTB.ZIndex = 3
GuiTbl.ForceTB.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.ForceTB.Text = ""
GuiTbl.ForceTB.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.ForceTB.TextScaled = true
GuiTbl.ForceTB.TextSize = 14.000
GuiTbl.ForceTB.TextStrokeTransparency = 0.000
GuiTbl.ForceTB.TextWrapped = true

GuiTbl.TBUnderbar.Name = "TBUnderbar"
GuiTbl.TBUnderbar.Parent = GuiTbl.ForceTB
GuiTbl.TBUnderbar.AnchorPoint = Vector2.new(0.5, 1)
GuiTbl.TBUnderbar.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
GuiTbl.TBUnderbar.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.TBUnderbar.BorderSizePixel = 0
GuiTbl.TBUnderbar.Position = UDim2.new(0.5, 0, 0.959999979, 0)
GuiTbl.TBUnderbar.Size = UDim2.new(0.400000006, 0, 0, 1)

GuiTbl.LeftBound.Name = "LeftBound"
GuiTbl.LeftBound.Parent = GuiTbl.SliderEx
GuiTbl.LeftBound.Active = true
GuiTbl.LeftBound.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.LeftBound.BackgroundTransparency = 1.000
GuiTbl.LeftBound.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.LeftBound.BorderSizePixel = 0
GuiTbl.LeftBound.Position = UDim2.new(0.0500000007, 0, 0.629999995, 0)
GuiTbl.LeftBound.Size = UDim2.new(0.100000001, 0, -0.25, 30)
GuiTbl.LeftBound.ZIndex = 2
GuiTbl.LeftBound.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.LeftBound.Text = "30"
GuiTbl.LeftBound.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.LeftBound.TextScaled = true
GuiTbl.LeftBound.TextSize = 14.000
GuiTbl.LeftBound.TextStrokeTransparency = 0.000
GuiTbl.LeftBound.TextWrapped = true

GuiTbl.RightBound.Name = "RightBound"
GuiTbl.RightBound.Parent = GuiTbl.SliderEx
GuiTbl.RightBound.Active = true
GuiTbl.RightBound.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.RightBound.BackgroundTransparency = 1.000
GuiTbl.RightBound.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.RightBound.BorderSizePixel = 0
GuiTbl.RightBound.Position = UDim2.new(0.850000024, 0, 0.629999995, 0)
GuiTbl.RightBound.Size = UDim2.new(0.100000001, 0, -0.25, 30)
GuiTbl.RightBound.ZIndex = 2
GuiTbl.RightBound.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.RightBound.Text = "100"
GuiTbl.RightBound.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.RightBound.TextScaled = true
GuiTbl.RightBound.TextSize = 14.000
GuiTbl.RightBound.TextStrokeTransparency = 0.000
GuiTbl.RightBound.TextWrapped = true

GuiTbl.UIStroke_4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_4.Parent = GuiTbl.SliderEx

GuiTbl.DropdownEx.Name = "DropdownEx"
GuiTbl.DropdownEx:AddTag("RemoveOnDestroy")
C.Examples.DropdownEx = GuiTbl.DropdownEx
GuiTbl.DropdownEx.BackgroundColor3 = Color3.fromRGB(0, 255, 102)
GuiTbl.DropdownEx.BackgroundTransparency = 1.000
GuiTbl.DropdownEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.DropdownEx.BorderSizePixel = 0
GuiTbl.DropdownEx.Size = UDim2.new(1, 0, 0, 40)

GuiTbl.NameTL_3.Name = "NameTL"
GuiTbl.NameTL_3.Parent = GuiTbl.DropdownEx
GuiTbl.NameTL_3.Active = true
GuiTbl.NameTL_3.AnchorPoint = Vector2.new(0, 0.5)
GuiTbl.NameTL_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.NameTL_3.BackgroundTransparency = 1.000
GuiTbl.NameTL_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.NameTL_3.BorderSizePixel = 0
GuiTbl.NameTL_3.Position = UDim2.new(0.0500000007, 0, 0.5, 0)
GuiTbl.NameTL_3.Size = UDim2.new(0.5, 0, 0, 30)
GuiTbl.NameTL_3.ZIndex = 2
GuiTbl.NameTL_3.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.NameTL_3.Text = "AimAssist"
GuiTbl.NameTL_3.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.NameTL_3.TextScaled = true
GuiTbl.NameTL_3.TextSize = 14.000
GuiTbl.NameTL_3.TextStrokeTransparency = 0.000
GuiTbl.NameTL_3.TextWrapped = true
GuiTbl.NameTL_3.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.UIStroke_5.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_5.Parent = GuiTbl.DropdownEx

GuiTbl.DropdownButton.Name = "DropdownButton"
GuiTbl.DropdownButton.Parent = GuiTbl.DropdownEx
GuiTbl.DropdownButton.AnchorPoint = Vector2.new(1, 0.5)
GuiTbl.DropdownButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
GuiTbl.DropdownButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.DropdownButton.BorderSizePixel = 0
GuiTbl.DropdownButton.Position = UDim2.new(0.970000029, 0, 0.5, 0)
GuiTbl.DropdownButton.Size = UDim2.new(0.400000006, 0, 0, 30)
GuiTbl.DropdownButton.ZIndex = 2
GuiTbl.DropdownButton.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.DropdownButton.Text = "God Mode⬇"
GuiTbl.DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.DropdownButton.TextScaled = true
GuiTbl.DropdownButton.TextSize = 14.000
GuiTbl.DropdownButton.TextStrokeTransparency = 0.000
GuiTbl.DropdownButton.TextWrapped = true

GuiTbl.UICorner_8.Parent = GuiTbl.DropdownButton

GuiTbl.UIStroke_6.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_6.Parent = GuiTbl.DropdownButton

GuiTbl.UserListEx.Name = "UserListEx"
GuiTbl.UserListEx:AddTag("RemoveOnDestroy")
C.Examples.UserListEx = GuiTbl.UserListEx
GuiTbl.UserListEx.AutomaticSize = Enum.AutomaticSize.Y
GuiTbl.UserListEx.BackgroundColor3 = Color3.fromRGB(0, 255, 102)
GuiTbl.UserListEx.BackgroundTransparency = 1.000
GuiTbl.UserListEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.UserListEx.BorderSizePixel = 0
GuiTbl.UserListEx.Size = UDim2.new(1, 0, 0, 40)

GuiTbl.NameTL_4.Name = "NameTL"
GuiTbl.NameTL_4.Parent = GuiTbl.UserListEx
GuiTbl.NameTL_4.Active = true
GuiTbl.NameTL_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.NameTL_4.BackgroundTransparency = 1.000
GuiTbl.NameTL_4.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.NameTL_4.BorderSizePixel = 0
GuiTbl.NameTL_4.Position = UDim2.new(0.0500000007, 0, 0, 5)
GuiTbl.NameTL_4.Size = UDim2.new(0.699999988, 0, 0, 30)
GuiTbl.NameTL_4.ZIndex = 2
GuiTbl.NameTL_4.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.NameTL_4.Text = "AimAssist"
GuiTbl.NameTL_4.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.NameTL_4.TextScaled = true
GuiTbl.NameTL_4.TextSize = 14.000
GuiTbl.NameTL_4.TextStrokeTransparency = 0.000
GuiTbl.NameTL_4.TextWrapped = true
GuiTbl.NameTL_4.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.UIStroke_7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_7.Parent = GuiTbl.UserListEx

GuiTbl.AddButton.Name = "AddButton"
GuiTbl.AddButton.Parent = GuiTbl.UserListEx
GuiTbl.AddButton.AnchorPoint = Vector2.new(1, 0)
GuiTbl.AddButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
GuiTbl.AddButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.AddButton.BorderSizePixel = 0
GuiTbl.AddButton.Position = UDim2.new(0.970000029, 0, 0, 40)
GuiTbl.AddButton.Size = UDim2.new(0.150000006, 0, 0, 30)
GuiTbl.AddButton.ZIndex = 2
GuiTbl.AddButton.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.AddButton.Text = "+"
GuiTbl.AddButton.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.AddButton.TextScaled = true
GuiTbl.AddButton.TextSize = 14.000
GuiTbl.AddButton.TextStrokeTransparency = 0.000
GuiTbl.AddButton.TextWrapped = true

GuiTbl.UICorner_9.Parent = GuiTbl.AddButton

GuiTbl.UIStroke_8.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_8.Parent = GuiTbl.AddButton

GuiTbl.MainList.Name = "MainList"
GuiTbl.MainList.Parent = GuiTbl.UserListEx
GuiTbl.MainList.AutomaticSize = Enum.AutomaticSize.Y
GuiTbl.MainList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.MainList.BackgroundTransparency = 1.000
GuiTbl.MainList.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.MainList.BorderSizePixel = 0
GuiTbl.MainList.Position = UDim2.new(0, 0, 0, 80)
GuiTbl.MainList.Size = UDim2.new(1, 0, 0, 0)

GuiTbl.UIListLayout_7.Parent = GuiTbl.MainList
GuiTbl.UIListLayout_7.HorizontalAlignment = Enum.HorizontalAlignment.Center
GuiTbl.UIListLayout_7.SortOrder = Enum.SortOrder.LayoutOrder

GuiTbl.OneListEx.Name = "OneListEx"
GuiTbl.OneListEx:AddTag("RemoveOnDestroy")
C.Examples.OneListEx = GuiTbl.OneListEx
GuiTbl.OneListEx.BackgroundColor3 = Color3.fromRGB(79, 79, 79)
GuiTbl.OneListEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.OneListEx.BorderSizePixel = 0
GuiTbl.OneListEx.Size = UDim2.new(1, 0, 0, 20)

GuiTbl.DeleteButton.Name = "DeleteButton"
GuiTbl.DeleteButton.Parent = GuiTbl.OneListEx
GuiTbl.DeleteButton.AnchorPoint = Vector2.new(1, 0)
GuiTbl.DeleteButton.BackgroundColor3 = Color3.fromRGB(198, 0, 0)
GuiTbl.DeleteButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.DeleteButton.BorderSizePixel = 0
GuiTbl.DeleteButton.Position = UDim2.new(0.970000029, 0, 0, 0)
GuiTbl.DeleteButton.Size = UDim2.new(0.150000006, 0, 1, 0)
GuiTbl.DeleteButton.ZIndex = 2
GuiTbl.DeleteButton.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.DeleteButton.Text = "X"
GuiTbl.DeleteButton.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.DeleteButton.TextScaled = true
GuiTbl.DeleteButton.TextSize = 14.000
GuiTbl.DeleteButton.TextStrokeTransparency = 0.000
GuiTbl.DeleteButton.TextWrapped = true

GuiTbl.UICorner_10.Parent = GuiTbl.DeleteButton

GuiTbl.UIStroke_9.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_9.Parent = GuiTbl.DeleteButton

GuiTbl.UserTL.Name = "UserTL"
GuiTbl.UserTL.Parent = GuiTbl.OneListEx
GuiTbl.UserTL.Active = true
GuiTbl.UserTL.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.UserTL.BackgroundTransparency = 1.000
GuiTbl.UserTL.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.UserTL.BorderSizePixel = 0
GuiTbl.UserTL.Position = UDim2.new(0.0500000007, 0, 0, 0)
GuiTbl.UserTL.Size = UDim2.new(0.699999988, 0, 1, 0)
GuiTbl.UserTL.ZIndex = 2
GuiTbl.UserTL.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.UserTL.Text = "areallycoolguy"
GuiTbl.UserTL.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.UserTL.TextScaled = true
GuiTbl.UserTL.TextSize = 14.000
GuiTbl.UserTL.TextStrokeTransparency = 0.000
GuiTbl.UserTL.TextWrapped = true
GuiTbl.UserTL.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.EnterTB.Name = "EnterTB"
GuiTbl.EnterTB.Parent = GuiTbl.UserListEx
GuiTbl.EnterTB.BackgroundColor3 = Color3.fromRGB(188, 188, 188)
GuiTbl.EnterTB.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.EnterTB.BorderSizePixel = 0
GuiTbl.EnterTB.Position = UDim2.new(0.0500000007, 0, 0, 40)
GuiTbl.EnterTB.Selectable = false
GuiTbl.EnterTB.Size = UDim2.new(0.730000019, 0, 0, 30)
GuiTbl.EnterTB.ZIndex = 2
GuiTbl.EnterTB.ClearTextOnFocus = false
GuiTbl.EnterTB.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.EnterTB.PlaceholderText = "Enter username/userid"
GuiTbl.EnterTB.Text = ""
GuiTbl.EnterTB.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.EnterTB.TextScaled = true
GuiTbl.EnterTB.TextSize = 14.000
GuiTbl.EnterTB.TextStrokeTransparency = 0.000
GuiTbl.EnterTB.TextWrapped = true

GuiTbl.UICorner_11.Parent = GuiTbl.EnterTB

GuiTbl.UIStroke_10.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_10.Parent = GuiTbl.EnterTB

GuiTbl.LimitTL.Name = "LimitTL"
GuiTbl.LimitTL.Parent = GuiTbl.UserListEx
GuiTbl.LimitTL.Active = true
GuiTbl.LimitTL.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.LimitTL.BackgroundTransparency = 1.000
GuiTbl.LimitTL.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.LimitTL.BorderSizePixel = 0
GuiTbl.LimitTL.Position = UDim2.new(0.789999783, 0, 0, 5)
GuiTbl.LimitTL.Size = UDim2.new(0.177391246, 0, 0, 30)
GuiTbl.LimitTL.ZIndex = 2
GuiTbl.LimitTL.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Regular,Enum.FontStyle.Normal)
GuiTbl.LimitTL.Text = "0/50"
GuiTbl.LimitTL.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.LimitTL.TextScaled = true
GuiTbl.LimitTL.TextSize = 14.000
GuiTbl.LimitTL.TextStrokeTransparency = 0.000
GuiTbl.LimitTL.TextWrapped = true
GuiTbl.LimitTL.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.TextboxEx.Name = "TextboxEx"
GuiTbl.TextboxEx:AddTag("RemoveOnDestroy")
C.Examples.TextboxEx = GuiTbl.TextboxEx
GuiTbl.TextboxEx.AutomaticSize = Enum.AutomaticSize.Y
GuiTbl.TextboxEx.BackgroundColor3 = Color3.fromRGB(0, 255, 102)
GuiTbl.TextboxEx.BackgroundTransparency = 1.000
GuiTbl.TextboxEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.TextboxEx.BorderSizePixel = 0
GuiTbl.TextboxEx.Size = UDim2.new(1, 0, 0, 40)

GuiTbl.NameTL_5.Name = "NameTL"
GuiTbl.NameTL_5.Parent = GuiTbl.TextboxEx
GuiTbl.NameTL_5.Active = true
GuiTbl.NameTL_5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.NameTL_5.BackgroundTransparency = 1.000
GuiTbl.NameTL_5.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.NameTL_5.BorderSizePixel = 0
GuiTbl.NameTL_5.Position = UDim2.new(0.0500000007, 0, 0, 5)
GuiTbl.NameTL_5.Size = UDim2.new(0.699999988, 0, 0, 30)
GuiTbl.NameTL_5.ZIndex = 2
GuiTbl.NameTL_5.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.NameTL_5.Text = "AimAssist"
GuiTbl.NameTL_5.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.NameTL_5.TextScaled = true
GuiTbl.NameTL_5.TextSize = 14.000
GuiTbl.NameTL_5.TextStrokeTransparency = 0.000
GuiTbl.NameTL_5.TextWrapped = true
GuiTbl.NameTL_5.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.UIStroke_11.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_11.Parent = GuiTbl.TextboxEx

GuiTbl.SetTB.Name = "SetTB"
GuiTbl.SetTB.Parent = GuiTbl.TextboxEx
GuiTbl.SetTB.BackgroundColor3 = Color3.fromRGB(188, 188, 188)
GuiTbl.SetTB.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.SetTB.BorderSizePixel = 0
GuiTbl.SetTB.Position = UDim2.new(0.0500000007, 0, 0, 40)
GuiTbl.SetTB.Selectable = false
GuiTbl.SetTB.Size = UDim2.new(0.730000019, 0, 0, 30)
GuiTbl.SetTB.ZIndex = 2
GuiTbl.SetTB.ClearTextOnFocus = false
GuiTbl.SetTB.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.SetTB.PlaceholderText = "Enter something here.."
GuiTbl.SetTB.Text = ""
GuiTbl.SetTB.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.SetTB.TextScaled = true
GuiTbl.SetTB.TextSize = 14.000
GuiTbl.SetTB.TextStrokeTransparency = 0.100
GuiTbl.SetTB.TextTransparency = 0.100
GuiTbl.SetTB.TextWrapped = true

GuiTbl.UICorner_12.Parent = GuiTbl.SetTB

GuiTbl.UIStroke_12.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_12.Parent = GuiTbl.SetTB

GuiTbl.LimitTL_2.Name = "LimitTL"
GuiTbl.LimitTL_2.Parent = GuiTbl.TextboxEx
GuiTbl.LimitTL_2.Active = true
GuiTbl.LimitTL_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.LimitTL_2.BackgroundTransparency = 1.000
GuiTbl.LimitTL_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.LimitTL_2.BorderSizePixel = 0
GuiTbl.LimitTL_2.Position = UDim2.new(0.789999783, 0, 0, 5)
GuiTbl.LimitTL_2.Size = UDim2.new(0.177391246, 0, 0, 30)
GuiTbl.LimitTL_2.ZIndex = 2
GuiTbl.LimitTL_2.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Regular,Enum.FontStyle.Normal)
GuiTbl.LimitTL_2.Text = "0/50"
GuiTbl.LimitTL_2.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.LimitTL_2.TextScaled = true
GuiTbl.LimitTL_2.TextSize = 14.000
GuiTbl.LimitTL_2.TextStrokeTransparency = 0.000
GuiTbl.LimitTL_2.TextWrapped = true
GuiTbl.LimitTL_2.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.EnterButton.Name = "EnterButton"
GuiTbl.EnterButton.Parent = GuiTbl.TextboxEx
GuiTbl.EnterButton.AnchorPoint = Vector2.new(1, 0)
GuiTbl.EnterButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
GuiTbl.EnterButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.EnterButton.BorderSizePixel = 0
GuiTbl.EnterButton.Position = UDim2.new(0.970000029, 0, 0, 40)
GuiTbl.EnterButton.Size = UDim2.new(0.150000006, 0, 0, 30)
GuiTbl.EnterButton.ZIndex = 2
C.SetImage(GuiTbl.EnterButton,"rbxassetid://504367763")

GuiTbl.UICorner_13.Parent = GuiTbl.EnterButton

GuiTbl.UIStroke_13.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_13.Parent = GuiTbl.EnterButton

GuiTbl.HighlightBackground.Name = "HighlightBackground"
GuiTbl.HighlightBackground.Parent = GuiTbl.HackButtonEx
GuiTbl.HighlightBackground.BackgroundColor3 = Color3.fromRGB(0, 255, 60)
GuiTbl.HighlightBackground.BackgroundTransparency = 1.000
GuiTbl.HighlightBackground.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.HighlightBackground.BorderSizePixel = 0
GuiTbl.HighlightBackground.Size = UDim2.new(1, 0, 0, 40)

GuiTbl.KeybindButton.Name = "KeybindButton"
GuiTbl.KeybindButton.Parent = GuiTbl.HackButtonEx
GuiTbl.KeybindButton.Active = false
GuiTbl.KeybindButton.AnchorPoint = Vector2.new(1, 0.5)
GuiTbl.KeybindButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.KeybindButton.BackgroundTransparency = 1.000
GuiTbl.KeybindButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.KeybindButton.BorderSizePixel = 0
GuiTbl.KeybindButton.Position = UDim2.new(0.841303527, 0, 0, 20)
GuiTbl.KeybindButton.Selectable = false
GuiTbl.KeybindButton.Size = UDim2.new(0, 34, 0, 40)
GuiTbl.KeybindButton.ZIndex = 3
C.SetImage(GuiTbl.KeybindButton,"rbxassetid://6884453656")
GuiTbl.KeybindButton.ScaleType = Enum.ScaleType.Fit

GuiTbl.BindedKey.Name = "BindedKey"
GuiTbl.BindedKey.Parent = GuiTbl.KeybindButton
GuiTbl.BindedKey.Active = true
GuiTbl.BindedKey.AnchorPoint = Vector2.new(0.5, 0.5)
GuiTbl.BindedKey.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.BindedKey.BackgroundTransparency = 1.000
GuiTbl.BindedKey.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.BindedKey.BorderSizePixel = 0
GuiTbl.BindedKey.Position = UDim2.new(0.5, 0, 0.5, 0)
GuiTbl.BindedKey.Size = UDim2.new(0.800000012, 0, 0.600000024, 0)
GuiTbl.BindedKey.ZIndex = 4
GuiTbl.BindedKey.FontFace = Font.new("rbxasset://fonts/families/Jura.json",Enum.FontWeight.Regular,Enum.FontStyle.Normal)
GuiTbl.BindedKey.Text = ""
GuiTbl.BindedKey.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.BindedKey.TextScaled = true
GuiTbl.BindedKey.TextSize = 14.000
GuiTbl.BindedKey.TextStrokeTransparency = 0.000
GuiTbl.BindedKey.TextWrapped = true

GuiTbl.KeybindLabel.Name = "KeybindLabel"
GuiTbl.KeybindLabel.Parent = GuiTbl.HackButtonEx
GuiTbl.KeybindLabel.Active = true
GuiTbl.KeybindLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.KeybindLabel.BackgroundTransparency = 1.000
GuiTbl.KeybindLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.KeybindLabel.BorderSizePixel = 0
GuiTbl.KeybindLabel.Position = UDim2.new(0.0500000007, 0, 0, 0)
GuiTbl.KeybindLabel.Size = UDim2.new(0.649999976, 0, 0, 40)
GuiTbl.KeybindLabel.Visible = false
GuiTbl.KeybindLabel.ZIndex = 3
GuiTbl.KeybindLabel.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.KeybindLabel.Text = "PRESS KEY TO BIND"
GuiTbl.KeybindLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.KeybindLabel.TextScaled = true
GuiTbl.KeybindLabel.TextSize = 14.000
GuiTbl.KeybindLabel.TextStrokeTransparency = 0.000
GuiTbl.KeybindLabel.TextWrapped = true
GuiTbl.KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.KeybindBacking.Name = "KeybindBacking"
GuiTbl.KeybindBacking.Parent = GuiTbl.KeybindLabel
GuiTbl.KeybindBacking.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.KeybindBacking.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.KeybindBacking.BorderSizePixel = 0
GuiTbl.KeybindBacking.Position = UDim2.new(-0.0769230798, 0, 0, 0)
GuiTbl.KeybindBacking.Size = UDim2.new(1.53846157, 0, 1, 0)
GuiTbl.KeybindBacking.ZIndex = 2

GuiTbl.UIGradient_5.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(117, 75, 255)), ColorSequenceKeypoint.new(0.52, Color3.fromRGB(169, 0, 23)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(197, 255, 39))}
GuiTbl.UIGradient_5.Parent = GuiTbl.KeybindBacking

GuiTbl.ToolTipHeaderFrame.Name = "ToolTipHeaderFrame"
GuiTbl.ToolTipHeaderFrame.Parent = GuiTbl.MainHUD
C.UI.ToolTipHeaderFrame = GuiTbl.ToolTipHeaderFrame
GuiTbl.ToolTipHeaderFrame.AutomaticSize = Enum.AutomaticSize.Y
GuiTbl.ToolTipHeaderFrame.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
GuiTbl.ToolTipHeaderFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.ToolTipHeaderFrame.BorderSizePixel = 0
GuiTbl.ToolTipHeaderFrame.Position = UDim2.new(0, 536, 0, 180)
GuiTbl.ToolTipHeaderFrame.Size = UDim2.new(0, 200, 0, 0)
GuiTbl.ToolTipHeaderFrame.Visible = false
GuiTbl.ToolTipHeaderFrame.ZIndex = 15

GuiTbl.ToolTipText.Name = "ToolTipText"
GuiTbl.ToolTipText.Parent = GuiTbl.ToolTipHeaderFrame
GuiTbl.ToolTipText.AutomaticSize = Enum.AutomaticSize.Y
GuiTbl.ToolTipText.AnchorPoint = Vector2.new(0.5, 0)
GuiTbl.ToolTipText.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
GuiTbl.ToolTipText.BackgroundTransparency = 1.000
GuiTbl.ToolTipText.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.ToolTipText.BorderSizePixel = 0
GuiTbl.ToolTipText.Position = UDim2.new(0.5, 0, 0, 0)
GuiTbl.ToolTipText.Size = UDim2.new(0.800000012, 0, 0, 0)
GuiTbl.ToolTipText.ZIndex = 16
GuiTbl.ToolTipText.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.ToolTipText.Text = "Aims At Enemies"
GuiTbl.ToolTipText.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.ToolTipText.TextSize = 22.000
GuiTbl.ToolTipText.TextStrokeTransparency = 0.000
GuiTbl.ToolTipText.TextWrapped = true

GuiTbl.UICorner_14.CornerRadius = UDim.new(0.400000006, 0)
GuiTbl.UICorner_14.Parent = GuiTbl.ToolTipHeaderFrame

GuiTbl.Notifications.Name = "Notifications"
GuiTbl.Notifications.Parent = GuiTbl.SpecterGUI
C.UI.Notifications = GuiTbl.Notifications
GuiTbl.Notifications.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Notifications.BackgroundTransparency = 1.000
GuiTbl.Notifications.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Notifications.BorderSizePixel = 0
GuiTbl.Notifications.Size = UDim2.new(1, 0, 1, 0)

GuiTbl.NotificationEx.Name = "NotificationEx"
GuiTbl.NotificationEx:AddTag("RemoveOnDestroy")
C.Examples.NotificationEx = GuiTbl.NotificationEx
GuiTbl.NotificationEx.AnchorPoint = Vector2.new(1, 1)
GuiTbl.NotificationEx.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
GuiTbl.NotificationEx.BackgroundTransparency = 0.300
GuiTbl.NotificationEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.NotificationEx.BorderSizePixel = 0
GuiTbl.NotificationEx.Position = UDim2.new(1, 0, 1, 0)
GuiTbl.NotificationEx.Size = UDim2.new(0.150000006, 0, 0.100000001, 0)
GuiTbl.NotificationEx.Visible = false
GuiTbl.NotificationEx.ZIndex = 2

GuiTbl.Timer.Name = "Timer"
GuiTbl.Timer.Parent = GuiTbl.NotificationEx
GuiTbl.Timer.AnchorPoint = Vector2.new(0, 1)
GuiTbl.Timer.BackgroundColor3 = Color3.fromRGB(0, 115, 255)
GuiTbl.Timer.BackgroundTransparency = 0.600
GuiTbl.Timer.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Timer.BorderSizePixel = 0
GuiTbl.Timer.Position = UDim2.new(0, 0, 1, -15)
GuiTbl.Timer.Size = UDim2.new(1, 0, 0, 3)
GuiTbl.Timer.ZIndex = 3

GuiTbl.UICorner_15.CornerRadius = UDim.new(0, 20)
GuiTbl.UICorner_15.Parent = GuiTbl.NotificationEx

GuiTbl.NotificationTitle.Name = "NotificationTitle"
GuiTbl.NotificationTitle.Parent = GuiTbl.NotificationEx
GuiTbl.NotificationTitle.AnchorPoint = Vector2.new(0.5, 0)
GuiTbl.NotificationTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.NotificationTitle.BackgroundTransparency = 1.000
GuiTbl.NotificationTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.NotificationTitle.BorderSizePixel = 0
GuiTbl.NotificationTitle.Position = UDim2.new(0.5, 0, -0, 0)
GuiTbl.NotificationTitle.Size = UDim2.new(0.800000012, 0, 0.200000003, 0)
GuiTbl.NotificationTitle.ZIndex = 3
GuiTbl.NotificationTitle.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.NotificationTitle.Text = "UI Loaded"
GuiTbl.NotificationTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.NotificationTitle.TextScaled = true
GuiTbl.NotificationTitle.TextSize = 22.000
GuiTbl.NotificationTitle.TextStrokeTransparency = 0.000
GuiTbl.NotificationTitle.TextWrapped = true

GuiTbl.NotificationDesc.Name = "NotificationDesc"
GuiTbl.NotificationDesc.Parent = GuiTbl.NotificationEx
GuiTbl.NotificationDesc.AnchorPoint = Vector2.new(0.5, 0)
GuiTbl.NotificationDesc.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.NotificationDesc.BackgroundTransparency = 1.000
GuiTbl.NotificationDesc.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.NotificationDesc.BorderSizePixel = 0
GuiTbl.NotificationDesc.Position = UDim2.new(0.500000179, 0, 0.190796182, 0)
GuiTbl.NotificationDesc.Size = UDim2.new(0.800000072, 0, 0.583613932, 0)
GuiTbl.NotificationDesc.ZIndex = 3
GuiTbl.NotificationDesc.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.NotificationDesc.Text = "UI Loaded"
GuiTbl.NotificationDesc.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.NotificationDesc.TextScaled = true
GuiTbl.NotificationDesc.TextSize = 22.000
GuiTbl.NotificationDesc.TextStrokeTransparency = 0.000
GuiTbl.NotificationDesc.TextWrapped = true

GuiTbl.UITextSizeConstraint.Parent = GuiTbl.NotificationDesc
GuiTbl.UITextSizeConstraint.MaxTextSize = 44

GuiTbl.HUDBackgroundFade.Name = "HUDBackgroundFade"
GuiTbl.HUDBackgroundFade.Parent = GuiTbl.SpecterGUI
C.UI.HUDBackgroundFade = GuiTbl.HUDBackgroundFade
GuiTbl.HUDBackgroundFade.AnchorPoint = Vector2.new(0.5, 0.5)
GuiTbl.HUDBackgroundFade.BackgroundColor3 = Color3.fromRGB(6, 6, 6)
GuiTbl.HUDBackgroundFade.BackgroundTransparency = 1.000
GuiTbl.HUDBackgroundFade.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.HUDBackgroundFade.BorderSizePixel = 0
GuiTbl.HUDBackgroundFade.LayoutOrder = -30
GuiTbl.HUDBackgroundFade.Position = UDim2.new(0.5, 0, 0.5, 0)
GuiTbl.HUDBackgroundFade.Size = UDim2.new(4, 0, 4, 0)
GuiTbl.HUDBackgroundFade.ZIndex = -1200000

GuiTbl.ChatAutoComplete.Name = "ChatAutoComplete"
GuiTbl.ChatAutoComplete.Parent = GuiTbl.SpecterGUI
C.UI.ChatAutoComplete = GuiTbl.ChatAutoComplete
GuiTbl.ChatAutoComplete.Active = true
GuiTbl.ChatAutoComplete.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.ChatAutoComplete.BackgroundTransparency = 1.000
GuiTbl.ChatAutoComplete.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.ChatAutoComplete.BorderSizePixel = 0
GuiTbl.ChatAutoComplete.Size = UDim2.new(0.300000012, 0, 0, 0)
GuiTbl.ChatAutoComplete.Visible = false
GuiTbl.ChatAutoComplete.AutomaticCanvasSize = Enum.AutomaticSize.Y
GuiTbl.ChatAutoComplete.CanvasSize = UDim2.new(0, 0, 0, 0)

GuiTbl.AutoCompleteEx.Name = "AutoCompleteEx"
GuiTbl.AutoCompleteEx:AddTag("RemoveOnDestroy")
C.Examples.AutoCompleteEx = GuiTbl.AutoCompleteEx
GuiTbl.AutoCompleteEx.BackgroundColor3 = Color3.fromRGB(55, 255, 0)
GuiTbl.AutoCompleteEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.AutoCompleteEx.BorderSizePixel = 0
GuiTbl.AutoCompleteEx.Size = UDim2.new(1, 0, 0, 25)

GuiTbl.AutoCompleteTitleLabel.Name = "AutoCompleteTitleLabel"
GuiTbl.AutoCompleteTitleLabel.Parent = GuiTbl.AutoCompleteEx
GuiTbl.AutoCompleteTitleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.AutoCompleteTitleLabel.BackgroundTransparency = 1.000
GuiTbl.AutoCompleteTitleLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.AutoCompleteTitleLabel.BorderSizePixel = 0
GuiTbl.AutoCompleteTitleLabel.Size = UDim2.new(1, 0, 1, 0)
GuiTbl.AutoCompleteTitleLabel.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.AutoCompleteTitleLabel.Text = "This sounds cool"
GuiTbl.AutoCompleteTitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.AutoCompleteTitleLabel.TextScaled = true
GuiTbl.AutoCompleteTitleLabel.TextSize = 14.000
GuiTbl.AutoCompleteTitleLabel.TextStrokeTransparency = 0.000
GuiTbl.AutoCompleteTitleLabel.TextWrapped = true

GuiTbl.UIListLayout_8.Parent = GuiTbl.ChatAutoComplete
GuiTbl.UIListLayout_8.HorizontalAlignment = Enum.HorizontalAlignment.Center
GuiTbl.UIListLayout_8.SortOrder = Enum.SortOrder.LayoutOrder

GuiTbl.Actions.Name = "Actions"
GuiTbl.Actions.Parent = GuiTbl.SpecterGUI
C.UI.Actions = GuiTbl.Actions
GuiTbl.Actions.BackgroundColor3 = Color3.fromRGB(39, 39, 39)
GuiTbl.Actions.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Actions.BorderSizePixel = 0
GuiTbl.Actions.LayoutOrder = -14
GuiTbl.Actions.Position = UDim2.new(1, 0, 1, 0)
GuiTbl.Actions.Size = UDim2.new(0, 230, 0, 200)
GuiTbl.Actions.ZIndex = -50

GuiTbl.HeaderTab_3.Name = "HeaderTab"
GuiTbl.HeaderTab_3.Parent = GuiTbl.Actions
GuiTbl.HeaderTab_3.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
GuiTbl.HeaderTab_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.HeaderTab_3.BorderSizePixel = 0
GuiTbl.HeaderTab_3.LayoutOrder = -13
GuiTbl.HeaderTab_3.Size = UDim2.new(1, 0, 0, 30)
GuiTbl.HeaderTab_3.ZIndex = -49

GuiTbl.HeaderTitleLabel_3.Name = "HeaderTitleLabel"
GuiTbl.HeaderTitleLabel_3.Parent = GuiTbl.HeaderTab_3
GuiTbl.HeaderTitleLabel_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.HeaderTitleLabel_3.BackgroundTransparency = 1.000
GuiTbl.HeaderTitleLabel_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.HeaderTitleLabel_3.BorderSizePixel = 0
GuiTbl.HeaderTitleLabel_3.LayoutOrder = -12
GuiTbl.HeaderTitleLabel_3.Size = UDim2.new(0.600000024, 0, 1, 0)
GuiTbl.HeaderTitleLabel_3.Visible = false
GuiTbl.HeaderTitleLabel_3.ZIndex = -47
GuiTbl.HeaderTitleLabel_3.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.HeaderTitleLabel_3.Text = " SPECTER"
GuiTbl.HeaderTitleLabel_3.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.HeaderTitleLabel_3.TextScaled = true
GuiTbl.HeaderTitleLabel_3.TextSize = 14.000
GuiTbl.HeaderTitleLabel_3.TextStrokeTransparency = 0.000
GuiTbl.HeaderTitleLabel_3.TextWrapped = true
GuiTbl.HeaderTitleLabel_3.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.DropDownButton_2.Name = "DropDownButton"
GuiTbl.DropDownButton_2.Parent = GuiTbl.HeaderTab_3
GuiTbl.DropDownButton_2.AnchorPoint = Vector2.new(1, 0.5)
GuiTbl.DropDownButton_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.DropDownButton_2.BackgroundTransparency = 1.000
GuiTbl.DropDownButton_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.DropDownButton_2.BorderSizePixel = 0
GuiTbl.DropDownButton_2.LayoutOrder = -12
GuiTbl.DropDownButton_2.Position = UDim2.new(0.980000019, 0, 0.5, 0)
GuiTbl.DropDownButton_2.Size = UDim2.new(0.200000003, 0, 0.5, 0)
GuiTbl.DropDownButton_2.ZIndex = -47
C.SetImage(GuiTbl.DropDownButton_2,"rbxassetid://14569017448")
GuiTbl.DropDownButton_2.ScaleType = Enum.ScaleType.Fit

GuiTbl.Text_3.Name = "Text"
GuiTbl.Text_3.Parent = GuiTbl.HeaderTab_3
GuiTbl.Text_3.AnchorPoint = Vector2.new(0, 0.5)
GuiTbl.Text_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Text_3.BackgroundTransparency = 1.000
GuiTbl.Text_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Text_3.BorderSizePixel = 0
GuiTbl.Text_3.LayoutOrder = -12
GuiTbl.Text_3.Position = UDim2.new(0.150000036, 0, 0.5, 0)
GuiTbl.Text_3.Size = UDim2.new(0.629999995, 0, 1, 0)
GuiTbl.Text_3.ZIndex = -47
GuiTbl.Text_3.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.Text_3.Text = " Actions"
GuiTbl.Text_3.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Text_3.TextScaled = true
GuiTbl.Text_3.TextSize = 14.000
GuiTbl.Text_3.TextWrapped = true
GuiTbl.Text_3.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.Image_4.Name = "Image"
GuiTbl.Image_4.Parent = GuiTbl.HeaderTab_3
GuiTbl.Image_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Image_4.BackgroundTransparency = 1.000
GuiTbl.Image_4.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Image_4.BorderSizePixel = 0
GuiTbl.Image_4.LayoutOrder = -12
GuiTbl.Image_4.Size = UDim2.new(0.150000006, 0, 1, 0)
GuiTbl.Image_4.ZIndex = -47
C.SetImage(GuiTbl.Image_4,"rbxassetid://8068133")
GuiTbl.Image_4.ScaleType = Enum.ScaleType.Fit

GuiTbl.ScrollTab_3.Name = "ScrollTab"
GuiTbl.ScrollTab_3.Parent = GuiTbl.Actions
GuiTbl.ScrollTab_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.ScrollTab_3.BackgroundTransparency = 1.000
GuiTbl.ScrollTab_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.ScrollTab_3.BorderSizePixel = 0
GuiTbl.ScrollTab_3.LayoutOrder = -13
GuiTbl.ScrollTab_3.Position = UDim2.new(0, 0, 0, 30)
GuiTbl.ScrollTab_3.Size = UDim2.new(1, 0, 0, 300)
GuiTbl.ScrollTab_3.ZIndex = -49
GuiTbl.ScrollTab_3.AutomaticCanvasSize = Enum.AutomaticSize.Y
GuiTbl.ScrollTab_3.BottomImage = "rbxassetid://3062505976"
GuiTbl.ScrollTab_3.CanvasSize = UDim2.new(0, 0, 0, 0)
GuiTbl.ScrollTab_3.MidImage = "rbxassetid://3062506202"
GuiTbl.ScrollTab_3.TopImage = "rbxassetid://3062506445"
GuiTbl.ScrollTab_3.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar

GuiTbl.UIListLayout_9.Parent = GuiTbl.ScrollTab_3
GuiTbl.UIListLayout_9.SortOrder = Enum.SortOrder.LayoutOrder

GuiTbl.ActionsEx.Name = "ActionsEx"
GuiTbl.ActionsEx:AddTag("RemoveOnDestroy")
C.Examples.ActionsEx = GuiTbl.ActionsEx
GuiTbl.ActionsEx.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.ActionsEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.ActionsEx.BorderSizePixel = 0
GuiTbl.ActionsEx.Size = UDim2.new(1, 0, 0, 40)
GuiTbl.ActionsEx.ZIndex = -47

GuiTbl.Title.Name = "Title"
GuiTbl.Title.Parent = GuiTbl.ActionsEx
GuiTbl.Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Title.BackgroundTransparency = 1.000
GuiTbl.Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Title.BorderSizePixel = 0
GuiTbl.Title.Size = UDim2.new(0.699999988, 0, 0.5, 0)
GuiTbl.Title.ZIndex = -45
GuiTbl.Title.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.Title.Text = "HACKING COMPUTER 5"
GuiTbl.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Title.TextScaled = true
GuiTbl.Title.TextSize = 14.000
GuiTbl.Title.TextStrokeTransparency = 0.000
GuiTbl.Title.TextWrapped = true
GuiTbl.Title.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.StopButton.Name = "StopButton"
GuiTbl.StopButton.Parent = GuiTbl.ActionsEx
GuiTbl.StopButton.AnchorPoint = Vector2.new(1, 1)
GuiTbl.StopButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
GuiTbl.StopButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.StopButton.BorderSizePixel = 0
GuiTbl.StopButton.Position = UDim2.new(1, 0, 1, 0)
GuiTbl.StopButton.Size = UDim2.new(0.286956519, 0, 0.5, 0)
GuiTbl.StopButton.ZIndex = -45
GuiTbl.StopButton.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.StopButton.Text = "CANCEL"
GuiTbl.StopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.StopButton.TextScaled = true
GuiTbl.StopButton.TextSize = 14.000
GuiTbl.StopButton.TextStrokeTransparency = 0.000
GuiTbl.StopButton.TextWrapped = true

GuiTbl.UIStroke_14.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_14.Parent = GuiTbl.StopButton

GuiTbl.Time.Name = "Time"
GuiTbl.Time.Parent = GuiTbl.ActionsEx
GuiTbl.Time.AnchorPoint = Vector2.new(0, 1)
GuiTbl.Time.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Time.BackgroundTransparency = 1.000
GuiTbl.Time.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Time.BorderSizePixel = 0
GuiTbl.Time.Position = UDim2.new(-0, 0, 1, 0)
GuiTbl.Time.Size = UDim2.new(0.713, -1, 0.5, 0)
GuiTbl.Time.ZIndex = -45
GuiTbl.Time.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.Time.Text = "34 m, 24 s"
GuiTbl.Time.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Time.TextScaled = true
GuiTbl.Time.TextSize = 14.000
GuiTbl.Time.TextStrokeTransparency = 0.000
GuiTbl.Time.TextWrapped = true
GuiTbl.Time.TextXAlignment = Enum.TextXAlignment.Left

GuiTbl.UIStroke_15.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_15.Parent = GuiTbl.Time

GuiTbl.UIStroke_16.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_16.Parent = GuiTbl.ActionsEx

GuiTbl.UIGradient_6.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(140, 140, 140)), ColorSequenceKeypoint.new(0.96, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(39, 39, 39))}
GuiTbl.UIGradient_6.Parent = GuiTbl.ActionsEx

GuiTbl.ToggleTagEx.Name = "ToggleTagEx"
GuiTbl.ToggleTagEx:AddTag("RemoveOnDestroy")
C.Examples.ToggleTagEx = GuiTbl.ToggleTagEx
GuiTbl.ToggleTagEx.Enabled = false
GuiTbl.ToggleTagEx.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GuiTbl.ToggleTagEx.Active = true
GuiTbl.ToggleTagEx.AlwaysOnTop = true
GuiTbl.ToggleTagEx.ExtentsOffsetWorldSpace = Vector3.new(0, 4, 0)
GuiTbl.ToggleTagEx.LightInfluence = 1.000
GuiTbl.ToggleTagEx.Size = UDim2.new(1, 30, 0.75, 10)

GuiTbl.Toggle.Name = "Toggle"
GuiTbl.Toggle.Parent = GuiTbl.ToggleTagEx
GuiTbl.Toggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
GuiTbl.Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Toggle.BorderSizePixel = 0
GuiTbl.Toggle.Size = UDim2.new(1, 0, 1, 0)
GuiTbl.Toggle.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Toggle.TextScaled = true
GuiTbl.Toggle.TextSize = 14.000
GuiTbl.Toggle.TextStrokeTransparency = 0.000
GuiTbl.Toggle.TextWrapped = true

GuiTbl.UIStroke_17.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_17.Parent = GuiTbl.Toggle

GuiTbl.KickedButton.Name = "KickedButton"
GuiTbl.KickedButton.Parent = GuiTbl.SpecterGUI
C.UI.KickedButton = GuiTbl.KickedButton
GuiTbl.KickedButton.AnchorPoint = Vector2.new(0.5, 1)
GuiTbl.KickedButton.BackgroundColor3 = Color3.fromRGB(255, 106, 32)
GuiTbl.KickedButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.KickedButton.BorderSizePixel = 0
GuiTbl.KickedButton.Position = UDim2.new(0.5, 0, 0.980000019, 0)
GuiTbl.KickedButton.Size = UDim2.new(0.5, 0, 0, 0)
GuiTbl.KickedButton.Visible = false
GuiTbl.KickedButton.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.KickedButton.Text = "You are kicked. This means that you cannot interact with the game nor other players.Click to hide this prompt"
GuiTbl.KickedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.KickedButton.TextSize = 33.000
GuiTbl.KickedButton.TextStrokeTransparency = 0.000
GuiTbl.KickedButton.TextWrapped = true

GuiTbl.SecondaryHUD.Name = "SecondaryHUD"
GuiTbl.SecondaryHUD.Parent = GuiTbl.SpecterGUI
C.UI.SecondaryHUD = GuiTbl.SecondaryHUD
GuiTbl.SecondaryHUD.AnchorPoint = Vector2.new(0.5, 0.5)
GuiTbl.SecondaryHUD.BackgroundColor3 = Color3.fromRGB(56, 56, 56)
GuiTbl.SecondaryHUD.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.SecondaryHUD.BorderSizePixel = 0
GuiTbl.SecondaryHUD.Position = UDim2.new(0.5, 0, 0.5, 0)
GuiTbl.SecondaryHUD.Size = UDim2.new(0.5, 0, 0.5, 0)
GuiTbl.SecondaryHUD.Visible = false
GuiTbl.SecondaryHUD.ZIndex = 100

GuiTbl.Servers.Name = "Servers"
GuiTbl.Servers.Parent = GuiTbl.SecondaryHUD
GuiTbl.Servers.BackgroundColor3 = Color3.fromRGB(56, 56, 56)
GuiTbl.Servers.BackgroundTransparency = 1.000
GuiTbl.Servers.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Servers.BorderSizePixel = 0
GuiTbl.Servers.Size = UDim2.new(1, 0, 1, 0)
GuiTbl.Servers.ZIndex = 101

GuiTbl.UICorner_16.CornerRadius = UDim.new(0, 32)
GuiTbl.UICorner_16.Parent = GuiTbl.Servers

GuiTbl.ServersTitleLabel.Name = "ServersTitleLabel"
GuiTbl.ServersTitleLabel.Parent = GuiTbl.Servers
GuiTbl.ServersTitleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.ServersTitleLabel.BackgroundTransparency = 1.000
GuiTbl.ServersTitleLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.ServersTitleLabel.BorderSizePixel = 0
GuiTbl.ServersTitleLabel.Position = UDim2.new(0.300000012, 0, 0, 0)
GuiTbl.ServersTitleLabel.Size = UDim2.new(0.699999988, 0, 0.100000001, 0)
GuiTbl.ServersTitleLabel.ZIndex = 102
GuiTbl.ServersTitleLabel.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.ServersTitleLabel.Text = "SERVERS"
GuiTbl.ServersTitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.ServersTitleLabel.TextScaled = true
GuiTbl.ServersTitleLabel.TextSize = 14.000
GuiTbl.ServersTitleLabel.TextStrokeTransparency = 0.000
GuiTbl.ServersTitleLabel.TextWrapped = true

GuiTbl.TabsSelection.Name = "TabsSelection"
GuiTbl.TabsSelection.Parent = GuiTbl.Servers
GuiTbl.TabsSelection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.TabsSelection.BackgroundTransparency = 1.000
GuiTbl.TabsSelection.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.TabsSelection.BorderSizePixel = 0
GuiTbl.TabsSelection.Size = UDim2.new(0.300000012, 0, 1, 0)
GuiTbl.TabsSelection.ZIndex = 102

GuiTbl.Game.Name = "Game"
GuiTbl.Game.Parent = GuiTbl.TabsSelection
GuiTbl.Game.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
GuiTbl.Game.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Game.BorderSizePixel = 0
GuiTbl.Game.LayoutOrder = -1
GuiTbl.Game.Size = UDim2.new(0, 200, 0, 50)
GuiTbl.Game.ZIndex = 103
GuiTbl.Game.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.Game.Text = "This Game"
GuiTbl.Game.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Game.TextScaled = true
GuiTbl.Game.TextSize = 14.000
GuiTbl.Game.TextStrokeTransparency = 0.000
GuiTbl.Game.TextWrapped = true

GuiTbl.UICorner_17.CornerRadius = UDim.new(0, 32)
GuiTbl.UICorner_17.Parent = GuiTbl.Game

GuiTbl.UIStroke_18.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_18.Parent = GuiTbl.Game

GuiTbl.UIGridLayout.Parent = GuiTbl.TabsSelection
GuiTbl.UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
GuiTbl.UIGridLayout.CellPadding = UDim2.new(0, 0, 0.13333334, 0)
GuiTbl.UIGridLayout.CellSize = UDim2.new(1, 0, 0.150000006, 0)

GuiTbl.Recent.Name = "Recent"
GuiTbl.Recent.Parent = GuiTbl.TabsSelection
GuiTbl.Recent.BackgroundColor3 = Color3.fromRGB(0, 110, 255)
GuiTbl.Recent.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Recent.BorderSizePixel = 0
GuiTbl.Recent.Size = UDim2.new(0, 200, 0, 50)
GuiTbl.Recent.ZIndex = 103
GuiTbl.Recent.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.Recent.Text = "Recent"
GuiTbl.Recent.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Recent.TextScaled = true
GuiTbl.Recent.TextSize = 14.000
GuiTbl.Recent.TextStrokeTransparency = 0.000
GuiTbl.Recent.TextWrapped = true

GuiTbl.UICorner_18.CornerRadius = UDim.new(0, 32)
GuiTbl.UICorner_18.Parent = GuiTbl.Recent

GuiTbl.UIStroke_19.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_19.Parent = GuiTbl.Recent

GuiTbl.Close.Name = "Close"
GuiTbl.Close.Parent = GuiTbl.TabsSelection
GuiTbl.Close.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
GuiTbl.Close.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Close.BorderSizePixel = 0
GuiTbl.Close.LayoutOrder = 2
GuiTbl.Close.Size = UDim2.new(0, 200, 0, 50)
GuiTbl.Close.ZIndex = 103
GuiTbl.Close.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.Close.Text = "Exit"
GuiTbl.Close.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Close.TextScaled = true
GuiTbl.Close.TextSize = 14.000
GuiTbl.Close.TextStrokeTransparency = 0.000
GuiTbl.Close.TextWrapped = true

GuiTbl.UICorner_19.CornerRadius = UDim.new(0, 32)
GuiTbl.UICorner_19.Parent = GuiTbl.Close

GuiTbl.UIStroke_20.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_20.Parent = GuiTbl.Close

GuiTbl.Friend.Name = "Friend"
GuiTbl.Friend.Parent = GuiTbl.TabsSelection
GuiTbl.Friend.BackgroundColor3 = Color3.fromRGB(34, 255, 0)
GuiTbl.Friend.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Friend.BorderSizePixel = 0
GuiTbl.Friend.LayoutOrder = 1
GuiTbl.Friend.Size = UDim2.new(0, 200, 0, 50)
GuiTbl.Friend.ZIndex = 103
GuiTbl.Friend.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.Friend.Text = "Friends"
GuiTbl.Friend.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Friend.TextScaled = true
GuiTbl.Friend.TextSize = 14.000
GuiTbl.Friend.TextStrokeTransparency = 0.000
GuiTbl.Friend.TextWrapped = true

GuiTbl.UICorner_20.CornerRadius = UDim.new(0, 32)
GuiTbl.UICorner_20.Parent = GuiTbl.Friend

GuiTbl.UIStroke_21.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_21.Parent = GuiTbl.Friend

GuiTbl.MainScroll.Name = "MainScroll"
GuiTbl.MainScroll.Parent = GuiTbl.Servers
GuiTbl.MainScroll.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.MainScroll.BackgroundTransparency = 1.000
GuiTbl.MainScroll.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.MainScroll.BorderSizePixel = 0
GuiTbl.MainScroll.LayoutOrder = -13
GuiTbl.MainScroll.Position = UDim2.new(0.299999952, 0, 0.100000001, 0)
GuiTbl.MainScroll.Size = UDim2.new(0.699999988, 0, 0.760000229, 0)
GuiTbl.MainScroll.ZIndex = 102
GuiTbl.MainScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
GuiTbl.MainScroll.BottomImage = "rbxassetid://3062505976"
GuiTbl.MainScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
GuiTbl.MainScroll.MidImage = "rbxassetid://3062506202"
GuiTbl.MainScroll.TopImage = "rbxassetid://3062506445"

GuiTbl.ServerEx.Name = "ServerEx"
GuiTbl.ServerEx:AddTag("RemoveOnDestroy")
C.Examples.ServerEx = GuiTbl.ServerEx
GuiTbl.ServerEx.Active = true
GuiTbl.ServerEx.BackgroundColor3 = Color3.fromRGB(255, 81, 0)
GuiTbl.ServerEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.ServerEx.BorderSizePixel = 0
GuiTbl.ServerEx.Size = UDim2.new(1, 0, 0, 60)
GuiTbl.ServerEx.ZIndex = 103

GuiTbl.ServerTitle.Name = "ServerTitle"
GuiTbl.ServerTitle.Parent = GuiTbl.ServerEx
GuiTbl.ServerTitle.AnchorPoint = Vector2.new(0.5, 0)
GuiTbl.ServerTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.ServerTitle.BackgroundTransparency = 1.000
GuiTbl.ServerTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.ServerTitle.BorderSizePixel = 0
GuiTbl.ServerTitle.Position = UDim2.new(0.5, 0, 0, 0)
GuiTbl.ServerTitle.Size = UDim2.new(0.800000012, 0, 0.300000012, 0)
GuiTbl.ServerTitle.ZIndex = 103
GuiTbl.ServerTitle.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.ServerTitle.Text = "SERVER"
GuiTbl.ServerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.ServerTitle.TextScaled = true
GuiTbl.ServerTitle.TextSize = 14.000
GuiTbl.ServerTitle.TextStrokeTransparency = 0.000
GuiTbl.ServerTitle.TextWrapped = true

GuiTbl.TimeStamp.Name = "TimeStamp"
GuiTbl.TimeStamp.Parent = GuiTbl.ServerEx
GuiTbl.TimeStamp.AnchorPoint = Vector2.new(0.5, 0)
GuiTbl.TimeStamp.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.TimeStamp.BackgroundTransparency = 1.000
GuiTbl.TimeStamp.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.TimeStamp.BorderSizePixel = 0
GuiTbl.TimeStamp.Position = UDim2.new(0.5, 0, 0.699999988, 0)
GuiTbl.TimeStamp.Size = UDim2.new(0.800000012, 0, 0.300000012, 0)
GuiTbl.TimeStamp.ZIndex = 103
GuiTbl.TimeStamp.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.TimeStamp.Text = "7:56 PM"
GuiTbl.TimeStamp.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.TimeStamp.TextScaled = true
GuiTbl.TimeStamp.TextSize = 14.000
GuiTbl.TimeStamp.TextStrokeTransparency = 0.000
GuiTbl.TimeStamp.TextWrapped = true

GuiTbl.SecondData.Name = "SecondData"
GuiTbl.SecondData.Parent = GuiTbl.ServerEx
GuiTbl.SecondData.AnchorPoint = Vector2.new(0.5, 0)
GuiTbl.SecondData.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.SecondData.BackgroundTransparency = 1.000
GuiTbl.SecondData.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.SecondData.BorderSizePixel = 0
GuiTbl.SecondData.Position = UDim2.new(0.5, 0, 0.349999994, 0)
GuiTbl.SecondData.Size = UDim2.new(0.800000012, 0, 0.300000012, 0)
GuiTbl.SecondData.ZIndex = 103
GuiTbl.SecondData.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.SecondData.Text = "5/10 PLAYERS"
GuiTbl.SecondData.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.SecondData.TextScaled = true
GuiTbl.SecondData.TextSize = 14.000
GuiTbl.SecondData.TextStrokeTransparency = 0.000
GuiTbl.SecondData.TextWrapped = true

GuiTbl.UICorner_21.CornerRadius = UDim.new(0, 32)
GuiTbl.UICorner_21.Parent = GuiTbl.ServerEx

GuiTbl.UIStroke_22.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_22.Parent = GuiTbl.ServerEx

GuiTbl.UIGridLayout_2.Parent = GuiTbl.MainScroll
GuiTbl.UIGridLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
GuiTbl.UIGridLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
GuiTbl.UIGridLayout_2.CellPadding = UDim2.new(0, 0, 0, 0)
GuiTbl.UIGridLayout_2.CellSize = UDim2.new(0.300000012, 0, 0, 150)

GuiTbl.BottomButtons.Name = "BottomButtons"
GuiTbl.BottomButtons.Parent = GuiTbl.Servers
GuiTbl.BottomButtons.AnchorPoint = Vector2.new(0, 1)
GuiTbl.BottomButtons.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.BottomButtons.BackgroundTransparency = 1.000
GuiTbl.BottomButtons.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.BottomButtons.BorderSizePixel = 0
GuiTbl.BottomButtons.Position = UDim2.new(0.300000012, 0, 0.980000019, 0)
GuiTbl.BottomButtons.Size = UDim2.new(0.699999988, 0, 0.109999999, 0)
GuiTbl.BottomButtons.ZIndex = 102

GuiTbl.Previous.Name = "Previous"
GuiTbl.Previous.Parent = GuiTbl.BottomButtons
GuiTbl.Previous.BackgroundColor3 = Color3.fromRGB(255, 238, 0)
GuiTbl.Previous.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Previous.BorderSizePixel = 0
GuiTbl.Previous.LayoutOrder = -1
GuiTbl.Previous.Size = UDim2.new(0, 200, 0, 50)
GuiTbl.Previous.ZIndex = 103
GuiTbl.Previous.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.Previous.Text = "Previous"
GuiTbl.Previous.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Previous.TextScaled = true
GuiTbl.Previous.TextSize = 14.000
GuiTbl.Previous.TextStrokeTransparency = 0.000
GuiTbl.Previous.TextWrapped = true

GuiTbl.UICorner_22.CornerRadius = UDim.new(0, 32)
GuiTbl.UICorner_22.Parent = GuiTbl.Previous

GuiTbl.UIStroke_23.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_23.Parent = GuiTbl.Previous

GuiTbl.UIGridLayout_3.Parent = GuiTbl.BottomButtons
GuiTbl.UIGridLayout_3.HorizontalAlignment = Enum.HorizontalAlignment.Center
GuiTbl.UIGridLayout_3.SortOrder = Enum.SortOrder.LayoutOrder
GuiTbl.UIGridLayout_3.CellPadding = UDim2.new(0, 0, 0, 0)
GuiTbl.UIGridLayout_3.CellSize = UDim2.new(0.333299994, 0, 1, 0)

GuiTbl.Join.Name = "Join"
GuiTbl.Join.Parent = GuiTbl.BottomButtons
GuiTbl.Join.BackgroundColor3 = Color3.fromRGB(140, 0, 255)
GuiTbl.Join.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Join.BorderSizePixel = 0
GuiTbl.Join.Size = UDim2.new(0, 200, 0, 50)
GuiTbl.Join.Visible = false
GuiTbl.Join.ZIndex = 103
GuiTbl.Join.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.Join.Text = "Join"
GuiTbl.Join.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Join.TextScaled = true
GuiTbl.Join.TextSize = 14.000
GuiTbl.Join.TextStrokeTransparency = 0.000
GuiTbl.Join.TextWrapped = true

GuiTbl.UICorner_23.CornerRadius = UDim.new(0, 32)
GuiTbl.UICorner_23.Parent = GuiTbl.Join

GuiTbl.UIStroke_24.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_24.Parent = GuiTbl.Join

GuiTbl.Next.Name = "Next"
GuiTbl.Next.Parent = GuiTbl.BottomButtons
GuiTbl.Next.BackgroundColor3 = Color3.fromRGB(60, 255, 0)
GuiTbl.Next.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Next.BorderSizePixel = 0
GuiTbl.Next.LayoutOrder = 1
GuiTbl.Next.Size = UDim2.new(0, 200, 0, 50)
GuiTbl.Next.ZIndex = 103
GuiTbl.Next.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.Next.Text = "Next"
GuiTbl.Next.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Next.TextScaled = true
GuiTbl.Next.TextSize = 14.000
GuiTbl.Next.TextStrokeTransparency = 0.000
GuiTbl.Next.TextWrapped = true

GuiTbl.UICorner_24.CornerRadius = UDim.new(0, 32)
GuiTbl.UICorner_24.Parent = GuiTbl.Next

GuiTbl.UIStroke_25.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_25.Parent = GuiTbl.Next

GuiTbl.ExtraLabel.Name = "ExtraLabel"
GuiTbl.ExtraLabel.Parent = GuiTbl.Servers
GuiTbl.ExtraLabel.AnchorPoint = Vector2.new(0.5, 0)
GuiTbl.ExtraLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.ExtraLabel.BackgroundTransparency = 1.000
GuiTbl.ExtraLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.ExtraLabel.BorderSizePixel = 0
GuiTbl.ExtraLabel.Position = UDim2.new(0.5, 0, 1, 0)
GuiTbl.ExtraLabel.Size = UDim2.new(1, 0, 0, 30)
GuiTbl.ExtraLabel.ZIndex = 102
GuiTbl.ExtraLabel.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.ExtraLabel.Text = "Player count or server joinability may not be up to date; Recent lists up to 24 hrs"
GuiTbl.ExtraLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.ExtraLabel.TextScaled = true
GuiTbl.ExtraLabel.TextSize = 14.000
GuiTbl.ExtraLabel.TextStrokeTransparency = 0.000
GuiTbl.ExtraLabel.TextWrapped = true

GuiTbl.UICorner_25.CornerRadius = UDim.new(0, 32)
GuiTbl.UICorner_25.Parent = GuiTbl.SecondaryHUD

GuiTbl.UIStroke_26.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_26.Parent = GuiTbl.SecondaryHUD

GuiTbl.PromptFrame.Name = "PromptFrame"
GuiTbl.PromptFrame.Parent = GuiTbl.SpecterGUI
C.UI.PromptFrame = GuiTbl.PromptFrame
GuiTbl.PromptFrame.AnchorPoint = Vector2.new(0.5, 0.5)
GuiTbl.PromptFrame.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
GuiTbl.PromptFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.PromptFrame.BorderSizePixel = 0
GuiTbl.PromptFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
GuiTbl.PromptFrame.Size = UDim2.new(0.400000006, 0, 0.400000006, 0)
GuiTbl.PromptFrame.Visible = false
GuiTbl.PromptFrame.ZIndex = 1000

GuiTbl.UICorner_26.CornerRadius = UDim.new(0, 32)
GuiTbl.UICorner_26.Parent = GuiTbl.PromptFrame

GuiTbl.UIStroke_27.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_27.Parent = GuiTbl.PromptFrame

GuiTbl.PromptTitle.Name = "PromptTitle"
GuiTbl.PromptTitle.Parent = GuiTbl.PromptFrame
GuiTbl.PromptTitle.AnchorPoint = Vector2.new(0.5, 0)
GuiTbl.PromptTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.PromptTitle.BackgroundTransparency = 1.000
GuiTbl.PromptTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.PromptTitle.BorderSizePixel = 0
GuiTbl.PromptTitle.Position = UDim2.new(0.5, 0, 0, 0)
GuiTbl.PromptTitle.Size = UDim2.new(0.699999988, 0, 0.125, 0)
GuiTbl.PromptTitle.ZIndex = 1002
GuiTbl.PromptTitle.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.PromptTitle.Text = "SERVERS"
GuiTbl.PromptTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.PromptTitle.TextScaled = true
GuiTbl.PromptTitle.TextSize = 14.000
GuiTbl.PromptTitle.TextStrokeTransparency = 0.000
GuiTbl.PromptTitle.TextWrapped = true

GuiTbl.PromptDesc.Name = "PromptDesc"
GuiTbl.PromptDesc.Parent = GuiTbl.PromptFrame
GuiTbl.PromptDesc.AnchorPoint = Vector2.new(0.5, 0)
GuiTbl.PromptDesc.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.PromptDesc.BackgroundTransparency = 1.000
GuiTbl.PromptDesc.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.PromptDesc.BorderSizePixel = 0
GuiTbl.PromptDesc.Position = UDim2.new(0.5, 0, 0.12226776, 0)
GuiTbl.PromptDesc.Size = UDim2.new(0.699999988, 0, 0.699999988, 0)
GuiTbl.PromptDesc.ZIndex = 1002
GuiTbl.PromptDesc.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.PromptDesc.Text = "Insert a notifaction text here later. You can put a lot or a little, and it will scale."
GuiTbl.PromptDesc.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.PromptDesc.TextScaled = true
GuiTbl.PromptDesc.TextSize = 14.000
GuiTbl.PromptDesc.TextStrokeTransparency = 0.000
GuiTbl.PromptDesc.TextWrapped = true

GuiTbl.PromptButtons.Name = "PromptButtons"
GuiTbl.PromptButtons.Parent = GuiTbl.PromptFrame
GuiTbl.PromptButtons.AnchorPoint = Vector2.new(0.5, 0)
GuiTbl.PromptButtons.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.PromptButtons.BackgroundTransparency = 1.000
GuiTbl.PromptButtons.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.PromptButtons.BorderSizePixel = 0
GuiTbl.PromptButtons.Position = UDim2.new(0.5, 0, 0.819672108, 0)
GuiTbl.PromptButtons.Size = UDim2.new(0.800000012, 0, 0.150000006, 0)
GuiTbl.PromptButtons.ZIndex = 1003

GuiTbl.UIGridLayout_4.Parent = GuiTbl.PromptButtons
GuiTbl.UIGridLayout_4.HorizontalAlignment = Enum.HorizontalAlignment.Center
GuiTbl.UIGridLayout_4.SortOrder = Enum.SortOrder.LayoutOrder
GuiTbl.UIGridLayout_4.CellPadding = UDim2.new(0, 0, 0, 0)
GuiTbl.UIGridLayout_4.CellSize = UDim2.new(0.5, 0, 1, 0)

GuiTbl.Yes.Name = "Yes"
GuiTbl.Yes.Parent = GuiTbl.PromptButtons
GuiTbl.Yes.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
GuiTbl.Yes.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Yes.BorderSizePixel = 0
GuiTbl.Yes.Size = UDim2.new(0, 200, 0, 50)
GuiTbl.Yes.ZIndex = 1004
GuiTbl.Yes.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.Yes.Text = "Yes"
GuiTbl.Yes.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Yes.TextScaled = true
GuiTbl.Yes.TextSize = 14.000
GuiTbl.Yes.TextStrokeTransparency = 0.000
GuiTbl.Yes.TextWrapped = true

GuiTbl.UIStroke_28.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_28.Parent = GuiTbl.Yes

GuiTbl.UICorner_27.CornerRadius = UDim.new(0, 32)
GuiTbl.UICorner_27.Parent = GuiTbl.Yes

GuiTbl.No.Name = "No"
GuiTbl.No.Parent = GuiTbl.PromptButtons
GuiTbl.No.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
GuiTbl.No.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.No.BorderSizePixel = 0
GuiTbl.No.LayoutOrder = 1
GuiTbl.No.Size = UDim2.new(0, 200, 0, 50)
GuiTbl.No.ZIndex = 1004
GuiTbl.No.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.No.Text = "No"
GuiTbl.No.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.No.TextScaled = true
GuiTbl.No.TextSize = 14.000
GuiTbl.No.TextStrokeTransparency = 0.000
GuiTbl.No.TextWrapped = true

GuiTbl.UIStroke_29.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_29.Parent = GuiTbl.No

GuiTbl.UICorner_28.CornerRadius = UDim.new(0, 32)
GuiTbl.UICorner_28.Parent = GuiTbl.No

GuiTbl.Ok.Name = "Ok"
GuiTbl.Ok.Parent = GuiTbl.PromptButtons
GuiTbl.Ok.BackgroundColor3 = Color3.fromRGB(0, 132, 255)
GuiTbl.Ok.BorderColor3 = Color3.fromRGB(0, 0, 0)
GuiTbl.Ok.BorderSizePixel = 0
GuiTbl.Ok.LayoutOrder = 2
GuiTbl.Ok.Size = UDim2.new(0, 200, 0, 50)
GuiTbl.Ok.Visible = false
GuiTbl.Ok.ZIndex = 1004
GuiTbl.Ok.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GuiTbl.Ok.Text = "Ok"
GuiTbl.Ok.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiTbl.Ok.TextScaled = true
GuiTbl.Ok.TextSize = 14.000
GuiTbl.Ok.TextStrokeTransparency = 0.000
GuiTbl.Ok.TextWrapped = true

GuiTbl.UIStroke_30.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GuiTbl.UIStroke_30.Parent = GuiTbl.Ok

GuiTbl.UICorner_29.CornerRadius = UDim.new(0, 32)
GuiTbl.UICorner_29.Parent = GuiTbl.Ok
	return GuiTbl.SpecterGUI,GuiTbl.CategoriesFrame,GuiTbl.TabsFrame,GuiTbl.ToolTipHeaderFrame,GuiTbl.ToolTipText
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
		SpecterGUI.Name = "SpecterGUI"
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
	local PromptFrame=C.UI.PromptFrame
	local count=0
	local queue,canRunEvent={},Instance.new("BindableEvent",script)
	local buttonTriggerEvent=Instance.new("BindableEvent",script)
	buttonTriggerEvent:AddTag("RemoveOnDestroy")
	canRunEvent:AddTag("RemoveOnDestroy")

	for _, button in ipairs(PromptFrame.PromptButtons:GetChildren()) do
		if button:IsA("UIBase") then
			continue
		end
		local Return = (button.Name == "Yes" and true) or button.Name
		if Return == "No" then
			Return = false
		end
		C.ButtonClick(button,function()
			buttonTriggerEvent:Fire(Return)
		end)
	end
	
	--[YIELDS] Result C.Prompt("Title","Description","Ok" | "Y/N")
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
			if button:IsA("UIBase") then
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

	--Kick button

	C.ButtonClick(C.UI.KickedButton,function()
		--C.UI.KickedButton:Destroy()
		--C.UI.KickedButton = nil
		C.UI.KickedButton.Visible = false
	end)

	--Load Servers
	local SecondaryHUD = C.UI.SecondaryHUD
	local ServersFrame = SecondaryHUD:WaitForChild("Servers")

	local MainScroll = ServersFrame:WaitForChild("MainScroll")
	local TabsSelection = ServersFrame:WaitForChild("TabsSelection")
	local BottomButtons = ServersFrame:WaitForChild("BottomButtons")
	local ServersTL = ServersFrame:WaitForChild("ServersTitleLabel")
	local PrevButton, NextButton = BottomButtons:WaitForChild("Previous"), BottomButtons:WaitForChild("Next")

	local CurrentlySel
	local PageNum,Previous,Next = 0, "", ""
	local JoinServerDeb = false

	local GetServers = {
		Recent = function()
			return true, C.getgenv().PreviousServers
		end,
		Game = function(Cursor)
			local success, result = C.API(C.request,nil,1,{Url=`https://games.roblox.com/v1/games/{game.PlaceId}/servers/Public?sortOrder=Desc&excludeFullGames=true&limit=100&cursor={Cursor}`})
			if not success then
				return success, result
			end
			local success2, result2 = C.API(HS,"JSONDecode",1,result)
			if not success2 then
				return success2, result2
			end
			Previous,Next = result2.previousPageCursor, result2.nextPageCursor
			return true, result2.data
		end
	}

	local function ActivateServers(tabName: string, increment: boolean | nil)
		CurrentlySel = tabName
		C.ClearChildren(MainScroll)
		local index = 0
		local Cursor = ""
		if increment ~= nil then
			if Cursor then
				Cursor = Next
				PageNum+=1
			else
				Cursor = Prev
				PageNum-=1
			end
		else
			Previous,Next = nil,nil
			PageNum = 1
		end
		local success, result = GetServers[tabName](Cursor)
		if not success then
			return
		end
		for num, data in ipairs(result) do
			if data.GameId == game.GameId and (data.JobId ~= game.JobId or data.PlaceId ~= data.PlaceId) then
				index+=1
				local serverClone = C.Examples.ServerEx:Clone()
				local listedData = {
					`Server {index}`,
					(data.Players and `{data.Players}/{data.MaxPlayers} Players`) or (data.playing and `{data.playing}/{data.maxPlayers} Players`),
					(data.Time and `{C.FormatTimeFromUnix(data.Time)}`) or (data.Ping and `{data.Ping} ping`),
					data.JobId or data.id,
				}
				serverClone.Name = index
				serverClone.ServerTitle.Text = listedData[1]
				serverClone.SecondData.Text = listedData[2]
				serverClone.TimeStamp.Text = listedData[3]
				serverClone.LayoutOrder = index
				serverClone.BackgroundColor3 = C.ComputeNameColor(data.JobId)
				C.ButtonClick(serverClone, function()
					if JoinServerDeb then return end
					if C.Prompt(`Join {listedData[1]}?`, `JobId: {listedData[4]}\n{listedData[2]}\n{listedData[3]}`, "Y/N") then
						C.ServerTeleport(data.PlaceId or game.PlaceId,listedData[4])
					end
				end)
				serverClone.Parent = MainScroll
			end
		end
		local hasArrows = tabName == "Game" or false
		local titleAfter = tabName == "Game" and `pg {PageNum}` or index 

		NextButton.BackgroundColor3 = Next and Color3.fromRGB(60, 255, 0) or Color3.fromRGB(170,170,170)
		PrevButton.BackgroundColor3 = Prev and Color3.fromRGB(255, 238, 0) or Color3.fromRGB(170,170,170)

		MainScroll.Size = UDim2.fromScale(.7,hasArrows and 0.76 or 0.9)
		BottomButtons.Visible = hasArrows
		ServersTL.Text = `{tabName:upper()} SERVERS ({titleAfter})`
	end
	C.ButtonClick(NextButton, function()
		if not Next then
			return
		end
		ActivateServers(CurrentlySel,true)
	end)
	C.ButtonClick(PrevButton, function()
		if not Previous then
			return
		end
		ActivateServers(CurrentlySel,false)
	end)

	local Visible = true
	function C.ToggleServersVisiblity()
		Visible = not Visible
		if Visible and not CurrentlySel then
			ActivateServers("Recent")
		end
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