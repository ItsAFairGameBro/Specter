local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local RS = game:GetService("ReplicatedStorage")
local RunS = game:GetService("RunService")

local function LoadCore(C,Settings)
-- Gui to Lua
-- Version: 3.2

-- Instances:

local SpecterGUI = Instance.new("ScreenGui")
local MainHUD = Instance.new("Frame")
local DropdownFrame = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")
local DropdownButtonEx = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local CategoriesFrame = Instance.new("Frame")
local Buttons = Instance.new("Frame")
local CategoryEx = Instance.new("Frame")
local Image = Instance.new("ImageLabel")
local Text = Instance.new("TextLabel")
local Arrow = Instance.new("TextLabel")
local BottomFrame = Instance.new("Frame")
local SaveButton = Instance.new("ImageLabel")
local Wait = Instance.new("TextLabel")
local UICorner_2 = Instance.new("UICorner")
local UIListLayout_2 = Instance.new("UIListLayout")
local MiscDivider = Instance.new("Frame")
local MiscLabel = Instance.new("TextLabel")
local HeaderTab = Instance.new("Frame")
local HeaderTitleLabel = Instance.new("TextLabel")
local SettingsButton = Instance.new("ImageButton")
local Settings = Instance.new("Frame")
local SupportedFrame = Instance.new("Frame")
local Image_2 = Instance.new("ImageLabel")
local Description = Instance.new("TextLabel")
local Supported = Instance.new("TextLabel")
local BottomFrame_2 = Instance.new("Frame")
local RefreshButton = Instance.new("ImageLabel")
local UICorner_3 = Instance.new("UICorner")
local UIListLayout_3 = Instance.new("UIListLayout")
local HackDivider = Instance.new("Frame")
local HackLabel = Instance.new("TextLabel")
local GameDivider = Instance.new("Frame")
local GameLabel = Instance.new("TextLabel")
local ScrollTab = Instance.new("ScrollingFrame")
local UIListLayout_4 = Instance.new("UIListLayout")
local TabsFrame = Instance.new("Frame")
local TabEx = Instance.new("CanvasGroup")
local HeaderTab_2 = Instance.new("Frame")
local HeaderTitleLabel_2 = Instance.new("TextLabel")
local DropDownButton = Instance.new("ImageButton")
local Text_2 = Instance.new("TextLabel")
local Image_3 = Instance.new("ImageLabel")
local ScrollTab_2 = Instance.new("ScrollingFrame")
local UIListLayout_5 = Instance.new("UIListLayout")
local HackButtonEx = Instance.new("Frame")
local HackText = Instance.new("TextLabel")
local HackExpand = Instance.new("ImageButton")
local OptionsList = Instance.new("Frame")
local UIListLayout_6 = Instance.new("UIListLayout")
local ToggleEx = Instance.new("Frame")
local NameTL = Instance.new("TextLabel")
local ToggleSwitchSlider = Instance.new("ImageButton")
local UICorner_4 = Instance.new("UICorner")
local ToggleCircle = Instance.new("Frame")
local UICorner_5 = Instance.new("UICorner")
local UIGradient = Instance.new("UIGradient")
local UIGradient_2 = Instance.new("UIGradient")
local SliderEx = Instance.new("Frame")
local NameTL_2 = Instance.new("TextLabel")
local SlidingBar = Instance.new("ImageButton")
local UICorner_6 = Instance.new("UICorner")
local CurrentPosition = Instance.new("Frame")
local UICorner_7 = Instance.new("UICorner")
local UIGradient_3 = Instance.new("UIGradient")
local UIGradient_4 = Instance.new("UIGradient")
local Backing = Instance.new("Frame")
local Track = Instance.new("Frame")
local ForceTB = Instance.new("TextBox")
local TBUnderbar = Instance.new("Frame")
local LeftBound = Instance.new("TextLabel")
local RightBound = Instance.new("TextLabel")
local DropdownEx = Instance.new("Frame")
local NameTL_3 = Instance.new("TextLabel")
local DropdownButton = Instance.new("TextButton")
local UICorner_8 = Instance.new("UICorner")
local UserListEx = Instance.new("Frame")
local NameTL_4 = Instance.new("TextLabel")
local AddButton = Instance.new("TextButton")
local UICorner_9 = Instance.new("UICorner")
local MainList = Instance.new("Frame")
local UIListLayout_7 = Instance.new("UIListLayout")
local OneListEx = Instance.new("Frame")
local DeleteButton = Instance.new("TextButton")
local UICorner_10 = Instance.new("UICorner")
local UserTL = Instance.new("TextLabel")
local EnterTB = Instance.new("TextBox")
local UICorner_11 = Instance.new("UICorner")
local LimitTL = Instance.new("TextLabel")
local TextboxEx = Instance.new("Frame")
local NameTL_5 = Instance.new("TextLabel")
local SetTB = Instance.new("TextBox")
local UICorner_12 = Instance.new("UICorner")
local LimitTL_2 = Instance.new("TextLabel")
local EnterButton = Instance.new("ImageButton")
local UICorner_13 = Instance.new("UICorner")
local HighlightBackground = Instance.new("Frame")
local KeybindButton = Instance.new("ImageButton")
local BindedKey = Instance.new("TextLabel")
local KeybindLabel = Instance.new("TextLabel")
local KeybindBacking = Instance.new("Frame")
local UIGradient_5 = Instance.new("UIGradient")
local ToolTipHeaderFrame = Instance.new("Frame")
local ToolTipText = Instance.new("TextLabel")
local UICorner_14 = Instance.new("UICorner")
local Notifications = Instance.new("Frame")
local NotificationEx = Instance.new("Frame")
local Timer = Instance.new("Frame")
local UICorner_15 = Instance.new("UICorner")
local NotificationTitle = Instance.new("TextLabel")
local NotificationDesc = Instance.new("TextLabel")
local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
local HUDBackgroundFade = Instance.new("Frame")
local ChatAutoComplete = Instance.new("ScrollingFrame")
local UISizeConstraint = Instance.new("UISizeConstraint")
local AutoCompleteEx = Instance.new("Frame")
local AutoCompleteTitleLabel = Instance.new("TextLabel")
local UIListLayout_8 = Instance.new("UIListLayout")

--Properties:

SpecterGUI.Name = "SpecterGUI"

SpecterGUI.DisplayOrder = 696969
SpecterGUI.ResetOnSpawn = false

MainHUD.Name = "MainHUD"
MainHUD.Parent = SpecterGUI
C.UI.MainHUD = MainHUD
MainHUD.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainHUD.BackgroundTransparency = 1.000
MainHUD.BorderColor3 = Color3.fromRGB(0, 0, 0)
MainHUD.BorderSizePixel = 0
MainHUD.Size = UDim2.new(1, 0, 1, 0)

DropdownFrame.Name = "DropdownFrame"
DropdownFrame.Parent = MainHUD
C.UI.DropdownFrame = DropdownFrame
DropdownFrame.AutomaticSize = Enum.AutomaticSize.Y
DropdownFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
DropdownFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
DropdownFrame.BorderSizePixel = 0
DropdownFrame.Position = UDim2.new(0, 532, 0, 332)
DropdownFrame.Size = UDim2.new(0, 92, 0, 0)
DropdownFrame.Visible = false
DropdownFrame.ZIndex = 20

UIListLayout.Parent = DropdownFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

DropdownButtonEx.Name = "DropdownButtonEx"
DropdownButtonEx:AddTag("RemoveOnDestroy")
C.Examples.DropdownButtonEx = DropdownButtonEx
DropdownButtonEx.AnchorPoint = Vector2.new(1, 0.5)
DropdownButtonEx.BackgroundColor3 = Color3.fromRGB(39, 39, 39)
DropdownButtonEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
DropdownButtonEx.BorderSizePixel = 0
DropdownButtonEx.Position = UDim2.new(0.970000029, 0, 0.5, 0)
DropdownButtonEx.Size = UDim2.new(1, 0, 0, 30)
DropdownButtonEx.ZIndex = 21
DropdownButtonEx.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
DropdownButtonEx.Text = "God Mode"
DropdownButtonEx.TextColor3 = Color3.fromRGB(255, 255, 255)
DropdownButtonEx.TextScaled = true
DropdownButtonEx.TextSize = 14.000
DropdownButtonEx.TextStrokeTransparency = 0.000
DropdownButtonEx.TextWrapped = true

UICorner.Parent = DropdownButtonEx

CategoriesFrame.Name = "CategoriesFrame"
CategoriesFrame.Parent = MainHUD
C.UI.CategoriesFrame = CategoriesFrame
CategoriesFrame.Active = true
CategoriesFrame.AutomaticSize = Enum.AutomaticSize.Y
CategoriesFrame.BackgroundColor3 = Color3.fromRGB(39, 39, 39)
CategoriesFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
CategoriesFrame.BorderSizePixel = 0
CategoriesFrame.LayoutOrder = -15
CategoriesFrame.Position = UDim2.new(0, 30, 0, 100)
CategoriesFrame.Size = UDim2.new(0, 200, 0, 0)

Buttons.Name = "Buttons"
Buttons.Parent = CategoriesFrame
Buttons.AutomaticSize = Enum.AutomaticSize.Y
Buttons.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Buttons.BackgroundTransparency = 1.000
Buttons.BorderColor3 = Color3.fromRGB(0, 0, 0)
Buttons.BorderSizePixel = 0
Buttons.Position = UDim2.new(0, 0, 0, 40)
Buttons.Size = UDim2.new(1, 0, 0, 0)

CategoryEx.Name = "CategoryEx"
CategoryEx:AddTag("RemoveOnDestroy")
C.Examples.CategoryEx = CategoryEx
CategoryEx.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CategoryEx.BackgroundTransparency = 1.000
CategoryEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
CategoryEx.BorderSizePixel = 0
CategoryEx.LayoutOrder = 1
CategoryEx.Size = UDim2.new(1, 0, 0, 40)

Image.Name = "Image"
Image.Parent = CategoryEx
Image.Active = true
Image.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Image.BackgroundTransparency = 1.000
Image.BorderColor3 = Color3.fromRGB(0, 0, 0)
Image.BorderSizePixel = 0
Image.Size = UDim2.new(0.150000006, 0, 1, 0)
Image.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
Image.ScaleType = Enum.ScaleType.Fit

Text.Name = "Text"
Text.Parent = CategoryEx
Text.Active = true
Text.AnchorPoint = Vector2.new(0, 0.5)
Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Text.BackgroundTransparency = 1.000
Text.BorderColor3 = Color3.fromRGB(0, 0, 0)
Text.BorderSizePixel = 0
Text.Position = UDim2.new(0.150000006, 0, 0.5, 0)
Text.Size = UDim2.new(0.670000017, 0, 0.730000019, 0)
Text.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
Text.Text = " Render"
Text.TextColor3 = Color3.fromRGB(255, 255, 255)
Text.TextScaled = true
Text.TextSize = 14.000
Text.TextWrapped = true
Text.TextXAlignment = Enum.TextXAlignment.Left

Arrow.Name = "Arrow"
Arrow.Parent = CategoryEx
Arrow.Active = true
Arrow.AnchorPoint = Vector2.new(0, 0.5)
Arrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Arrow.BackgroundTransparency = 1.000
Arrow.BorderColor3 = Color3.fromRGB(0, 0, 0)
Arrow.BorderSizePixel = 0
Arrow.Position = UDim2.new(0.779999971, 0, 0.5, 0)
Arrow.Size = UDim2.new(0.199999779, 0, 0.730000138, 0)
Arrow.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
Arrow.Text = ">"
Arrow.TextColor3 = Color3.fromRGB(115, 115, 115)
Arrow.TextScaled = true
Arrow.TextSize = 14.000
Arrow.TextWrapped = true

BottomFrame.Name = "BottomFrame"
BottomFrame.Parent = Buttons
BottomFrame.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
BottomFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
BottomFrame.BorderSizePixel = 0
BottomFrame.LayoutOrder = 2000
BottomFrame.Size = UDim2.new(1, 0, 0, 40)

SaveButton.Name = "SaveButton"
SaveButton.Parent = BottomFrame
SaveButton.Active = true
SaveButton.AnchorPoint = Vector2.new(0, 0.5)
SaveButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SaveButton.BackgroundTransparency = 1.000
SaveButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
SaveButton.BorderSizePixel = 0
SaveButton.Position = UDim2.new(0, 0, 0.5, 0)
SaveButton.Size = UDim2.new(0.200000003, 0, 0.899999976, 0)
SaveButton.Image = "rbxassetid://14737163568"
SaveButton.ScaleType = Enum.ScaleType.Fit

Wait.Name = "Wait"
Wait.Parent = SaveButton
Wait.AnchorPoint = Vector2.new(0.5, 0.5)
Wait.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Wait.BackgroundTransparency = 1.000
Wait.BorderColor3 = Color3.fromRGB(0, 0, 0)
Wait.BorderSizePixel = 0
Wait.Position = UDim2.new(0.5, 0, 0.5, 0)
Wait.Size = UDim2.new(0.800000012, 0, 0.800000012, 0)
Wait.Visible = false
Wait.FontFace = Font.new("rbxasset://fonts/families/ComicNeueAngular.json",Enum.FontWeight.Regular,Enum.FontStyle.Normal)
Wait.Text = "•••"
Wait.TextColor3 = Color3.fromRGB(143, 143, 143)
Wait.TextScaled = true
Wait.TextSize = 40.000
Wait.TextStrokeTransparency = 0.000
Wait.TextWrapped = true

UICorner_2.CornerRadius = UDim.new(2, 0)
UICorner_2.Parent = Wait

UIListLayout_2.Parent = Buttons
UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder

MiscDivider.Name = "MiscDivider"
MiscDivider.Parent = Buttons
MiscDivider.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
MiscDivider.BorderColor3 = Color3.fromRGB(0, 0, 0)
MiscDivider.BorderSizePixel = 0
MiscDivider.LayoutOrder = 20
MiscDivider.Size = UDim2.new(1, 0, 0, 24)

MiscLabel.Name = "MiscLabel"
MiscLabel.Parent = MiscDivider
MiscLabel.AnchorPoint = Vector2.new(0, 0.5)
MiscLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MiscLabel.BackgroundTransparency = 1.000
MiscLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
MiscLabel.BorderSizePixel = 0
MiscLabel.Position = UDim2.new(0.100000001, 0, 0.5, 0)
MiscLabel.Size = UDim2.new(0.699999988, 0, 0.800000012, 0)
MiscLabel.FontFace = Font.new("rbxasset://fonts/families/Nunito.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
MiscLabel.Text = "MISC"
MiscLabel.TextColor3 = Color3.fromRGB(111, 111, 111)
MiscLabel.TextScaled = true
MiscLabel.TextSize = 14.000
MiscLabel.TextStrokeTransparency = 0.000
MiscLabel.TextWrapped = true
MiscLabel.TextXAlignment = Enum.TextXAlignment.Left

HeaderTab.Name = "HeaderTab"
HeaderTab.Parent = CategoriesFrame
HeaderTab.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
HeaderTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
HeaderTab.BorderSizePixel = 0
HeaderTab.LayoutOrder = -20
HeaderTab.Size = UDim2.new(1, 0, 0, 40)

HeaderTitleLabel.Name = "HeaderTitleLabel"
HeaderTitleLabel.Parent = HeaderTab
HeaderTitleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
HeaderTitleLabel.BackgroundTransparency = 1.000
HeaderTitleLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
HeaderTitleLabel.BorderSizePixel = 0
HeaderTitleLabel.Size = UDim2.new(0.600000024, 0, 1, 0)
HeaderTitleLabel.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
HeaderTitleLabel.Text = " SPECTER"
HeaderTitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderTitleLabel.TextScaled = true
HeaderTitleLabel.TextSize = 14.000
HeaderTitleLabel.TextStrokeTransparency = 0.000
HeaderTitleLabel.TextWrapped = true
HeaderTitleLabel.TextXAlignment = Enum.TextXAlignment.Left

SettingsButton.Name = "SettingsButton"
SettingsButton.Parent = HeaderTab
SettingsButton.AnchorPoint = Vector2.new(1, 0.5)
SettingsButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SettingsButton.BackgroundTransparency = 1.000
SettingsButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
SettingsButton.BorderSizePixel = 0
SettingsButton.Position = UDim2.new(0.980000019, 0, 0.5, 0)
SettingsButton.Size = UDim2.new(0.200000003, 0, 0.800000012, 0)
SettingsButton.ZIndex = 50
SettingsButton.Image = "rbxassetid://14134158045"
SettingsButton.ScaleType = Enum.ScaleType.Fit

Settings.Name = "Settings"
Settings.Parent = CategoriesFrame
Settings.AutomaticSize = Enum.AutomaticSize.Y
Settings.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Settings.BackgroundTransparency = 1.000
Settings.BorderColor3 = Color3.fromRGB(0, 0, 0)
Settings.BorderSizePixel = 0
Settings.Position = UDim2.new(0, 0, 0, 40)
Settings.Size = UDim2.new(1, 0, 0, 0)
Settings.Visible = false

SupportedFrame.Name = "SupportedFrame"
SupportedFrame.Parent = Settings
SupportedFrame.AutomaticSize = Enum.AutomaticSize.Y
SupportedFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SupportedFrame.BackgroundTransparency = 1.000
SupportedFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
SupportedFrame.BorderSizePixel = 0
SupportedFrame.LayoutOrder = 1
SupportedFrame.Size = UDim2.new(1, 0, 0, 0)

Image_2.Name = "Image"
Image_2.Parent = SupportedFrame
Image_2.Active = true
Image_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Image_2.BackgroundTransparency = 1.000
Image_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Image_2.BorderSizePixel = 0
Image_2.Size = UDim2.new(0.150000006, 0, 1, 0)
Image_2.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
Image_2.ScaleType = Enum.ScaleType.Fit

Description.Name = "Description"
Description.Parent = SupportedFrame
Description.Active = true
Description.AutomaticSize = Enum.AutomaticSize.Y
Description.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Description.BackgroundTransparency = 1.000
Description.BorderColor3 = Color3.fromRGB(0, 0, 0)
Description.BorderSizePixel = 0
Description.Position = UDim2.new(0.150000006, 0, 0, 20)
Description.Size = UDim2.new(0.790000021, 0, 0, 0)
Description.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
Description.Text = " Render"
Description.TextColor3 = Color3.fromRGB(255, 255, 255)
Description.TextSize = 14.000
Description.TextWrapped = true
Description.TextXAlignment = Enum.TextXAlignment.Left

Supported.Name = "Supported"
Supported.Parent = SupportedFrame
Supported.Active = true
Supported.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Supported.BackgroundTransparency = 1.000
Supported.BorderColor3 = Color3.fromRGB(0, 0, 0)
Supported.BorderSizePixel = 0
Supported.Position = UDim2.new(0.150000006, 0, 0, 0)
Supported.Size = UDim2.new(0.790000021, 0, 0, 20)
Supported.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
Supported.Text = "Supported Game"
Supported.TextColor3 = Color3.fromRGB(255, 255, 255)
Supported.TextScaled = true
Supported.TextSize = 14.000
Supported.TextWrapped = true
Supported.TextXAlignment = Enum.TextXAlignment.Left

BottomFrame_2.Name = "BottomFrame"
BottomFrame_2.Parent = Settings
BottomFrame_2.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
BottomFrame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
BottomFrame_2.BorderSizePixel = 0
BottomFrame_2.LayoutOrder = 50
BottomFrame_2.Size = UDim2.new(1, 0, 0, 40)

RefreshButton.Name = "RefreshButton"
RefreshButton.Parent = BottomFrame_2
RefreshButton.Active = true
RefreshButton.AnchorPoint = Vector2.new(1, 0.5)
RefreshButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
RefreshButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
RefreshButton.BorderSizePixel = 0
RefreshButton.Position = UDim2.new(1, -1, 0.5, 0)
RefreshButton.Size = UDim2.new(0, 36, 0, 36)
RefreshButton.Image = "rbxassetid://13492317101"
RefreshButton.ScaleType = Enum.ScaleType.Fit

UICorner_3.CornerRadius = UDim.new(0, 999)
UICorner_3.Parent = RefreshButton

UIListLayout_3.Parent = Settings
UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder

HackDivider.Name = "HackDivider"
HackDivider.Parent = Settings
HackDivider.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
HackDivider.BorderColor3 = Color3.fromRGB(0, 0, 0)
HackDivider.BorderSizePixel = 0
HackDivider.LayoutOrder = 20
HackDivider.Size = UDim2.new(1, 0, 0, 24)

HackLabel.Name = "HackLabel"
HackLabel.Parent = HackDivider
HackLabel.AnchorPoint = Vector2.new(0, 0.5)
HackLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
HackLabel.BackgroundTransparency = 1.000
HackLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
HackLabel.BorderSizePixel = 0
HackLabel.Position = UDim2.new(0.100000001, 0, 0.5, 0)
HackLabel.Size = UDim2.new(0.699999988, 0, 0.800000012, 0)
HackLabel.FontFace = Font.new("rbxasset://fonts/families/Nunito.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
HackLabel.Text = "HACK"
HackLabel.TextColor3 = Color3.fromRGB(111, 111, 111)
HackLabel.TextScaled = true
HackLabel.TextSize = 14.000
HackLabel.TextStrokeTransparency = 0.000
HackLabel.TextWrapped = true
HackLabel.TextXAlignment = Enum.TextXAlignment.Left

GameDivider.Name = "GameDivider"
GameDivider.Parent = Settings
GameDivider.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
GameDivider.BorderColor3 = Color3.fromRGB(0, 0, 0)
GameDivider.BorderSizePixel = 0
GameDivider.LayoutOrder = -20
GameDivider.Size = UDim2.new(1, 0, 0, 24)

GameLabel.Name = "GameLabel"
GameLabel.Parent = GameDivider
GameLabel.AnchorPoint = Vector2.new(0, 0.5)
GameLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GameLabel.BackgroundTransparency = 1.000
GameLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
GameLabel.BorderSizePixel = 0
GameLabel.Position = UDim2.new(0.100000001, 0, 0.5, 0)
GameLabel.Size = UDim2.new(0.699999988, 0, 0.800000012, 0)
GameLabel.FontFace = Font.new("rbxasset://fonts/families/Nunito.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
GameLabel.Text = "GAME"
GameLabel.TextColor3 = Color3.fromRGB(111, 111, 111)
GameLabel.TextScaled = true
GameLabel.TextSize = 14.000
GameLabel.TextStrokeTransparency = 0.000
GameLabel.TextWrapped = true
GameLabel.TextXAlignment = Enum.TextXAlignment.Left

ScrollTab.Name = "ScrollTab"
ScrollTab.Parent = Settings
ScrollTab.AutomaticSize = Enum.AutomaticSize.Y
ScrollTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ScrollTab.BackgroundTransparency = 1.000
ScrollTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
ScrollTab.BorderSizePixel = 0
ScrollTab.LayoutOrder = 40
ScrollTab.Position = UDim2.new(0, 0, 0, 45)
ScrollTab.Size = UDim2.new(1, 0, 0, 0)
ScrollTab.ZIndex = 0
ScrollTab.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollTab.BottomImage = "rbxassetid://3062505976"
ScrollTab.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollTab.MidImage = "rbxassetid://3062506202"
ScrollTab.TopImage = "rbxassetid://3062506445"
ScrollTab.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar

UIListLayout_4.Parent = ScrollTab
UIListLayout_4.SortOrder = Enum.SortOrder.LayoutOrder

TabsFrame.Name = "TabsFrame"
TabsFrame.Parent = MainHUD
C.UI.TabsFrame = TabsFrame
TabsFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TabsFrame.BackgroundTransparency = 1.000
TabsFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
TabsFrame.BorderSizePixel = 0
TabsFrame.LayoutOrder = -15
TabsFrame.Size = UDim2.new(1, 0, 1, 0)
TabsFrame.ZIndex = -15

TabEx.Name = "TabEx"
TabEx:AddTag("RemoveOnDestroy")
C.Examples.TabEx = TabEx
TabEx.BackgroundColor3 = Color3.fromRGB(39, 39, 39)
TabEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
TabEx.BorderSizePixel = 0
TabEx.LayoutOrder = -14
TabEx.Position = UDim2.new(0, 400, 0, 100)
TabEx.Size = UDim2.new(0, 230, 0, 400)
TabEx.ZIndex = -14

HeaderTab_2.Name = "HeaderTab"
HeaderTab_2.Parent = TabEx
HeaderTab_2.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
HeaderTab_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
HeaderTab_2.BorderSizePixel = 0
HeaderTab_2.LayoutOrder = -13
HeaderTab_2.Size = UDim2.new(1, 0, 0, 45)
HeaderTab_2.ZIndex = -13

HeaderTitleLabel_2.Name = "HeaderTitleLabel"
HeaderTitleLabel_2.Parent = HeaderTab_2
HeaderTitleLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
HeaderTitleLabel_2.BackgroundTransparency = 1.000
HeaderTitleLabel_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
HeaderTitleLabel_2.BorderSizePixel = 0
HeaderTitleLabel_2.LayoutOrder = -12
HeaderTitleLabel_2.Size = UDim2.new(0.600000024, 0, 1, 0)
HeaderTitleLabel_2.Visible = false
HeaderTitleLabel_2.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
HeaderTitleLabel_2.Text = " SPECTER"
HeaderTitleLabel_2.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderTitleLabel_2.TextScaled = true
HeaderTitleLabel_2.TextSize = 14.000
HeaderTitleLabel_2.TextStrokeTransparency = 0.000
HeaderTitleLabel_2.TextWrapped = true
HeaderTitleLabel_2.TextXAlignment = Enum.TextXAlignment.Left

DropDownButton.Name = "DropDownButton"
DropDownButton.Parent = HeaderTab_2
DropDownButton.AnchorPoint = Vector2.new(1, 0.5)
DropDownButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
DropDownButton.BackgroundTransparency = 1.000
DropDownButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
DropDownButton.BorderSizePixel = 0
DropDownButton.LayoutOrder = -12
DropDownButton.Position = UDim2.new(0.980000019, 0, 0.5, 0)
DropDownButton.Size = UDim2.new(0.200000003, 0, 0.5, 0)
DropDownButton.Image = "rbxassetid://14569017448"
DropDownButton.ScaleType = Enum.ScaleType.Fit

Text_2.Name = "Text"
Text_2.Parent = HeaderTab_2
Text_2.AnchorPoint = Vector2.new(0, 0.5)
Text_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Text_2.BackgroundTransparency = 1.000
Text_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Text_2.BorderSizePixel = 0
Text_2.LayoutOrder = -12
Text_2.Position = UDim2.new(0.150000036, 0, 0.5, 0)
Text_2.Size = UDim2.new(0.629999697, 0, 0.730000138, 0)
Text_2.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
Text_2.Text = " Render"
Text_2.TextColor3 = Color3.fromRGB(255, 255, 255)
Text_2.TextScaled = true
Text_2.TextSize = 14.000
Text_2.TextWrapped = true
Text_2.TextXAlignment = Enum.TextXAlignment.Left

Image_3.Name = "Image"
Image_3.Parent = HeaderTab_2
Image_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Image_3.BackgroundTransparency = 1.000
Image_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
Image_3.BorderSizePixel = 0
Image_3.LayoutOrder = -12
Image_3.Size = UDim2.new(0.150000006, 0, 1, 0)
Image_3.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
Image_3.ScaleType = Enum.ScaleType.Fit

ScrollTab_2.Name = "ScrollTab"
ScrollTab_2.Parent = TabEx
ScrollTab_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ScrollTab_2.BackgroundTransparency = 1.000
ScrollTab_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
ScrollTab_2.BorderSizePixel = 0
ScrollTab_2.LayoutOrder = -13
ScrollTab_2.Position = UDim2.new(0, 0, 0, 45)
ScrollTab_2.Size = UDim2.new(1, 0, 0, 300)
ScrollTab_2.ZIndex = 0
ScrollTab_2.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollTab_2.BottomImage = "rbxassetid://3062505976"
ScrollTab_2.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollTab_2.MidImage = "rbxassetid://3062506202"
ScrollTab_2.TopImage = "rbxassetid://3062506445"
ScrollTab_2.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar

UIListLayout_5.Parent = ScrollTab_2
UIListLayout_5.SortOrder = Enum.SortOrder.LayoutOrder

HackButtonEx.Name = "HackButtonEx"
HackButtonEx:AddTag("RemoveOnDestroy")
C.Examples.HackButtonEx = HackButtonEx
HackButtonEx.AutomaticSize = Enum.AutomaticSize.Y
HackButtonEx.BackgroundColor3 = Color3.fromRGB(39, 39, 39)
HackButtonEx.BackgroundTransparency = 1.000
HackButtonEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
HackButtonEx.BorderSizePixel = 0
HackButtonEx.LayoutOrder = -12
HackButtonEx.Size = UDim2.new(1, 0, 0, 0)

HackText.Name = "HackText"
HackText.Parent = HackButtonEx
HackText.Active = true
HackText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
HackText.BackgroundTransparency = 1.000
HackText.BorderColor3 = Color3.fromRGB(0, 0, 0)
HackText.BorderSizePixel = 0
HackText.Position = UDim2.new(0.0500000007, 0, 0, 0)
HackText.Size = UDim2.new(0.649999976, 0, 0, 40)
HackText.ZIndex = 2
HackText.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
HackText.Text = "AimAssist"
HackText.TextColor3 = Color3.fromRGB(255, 255, 255)
HackText.TextScaled = true
HackText.TextSize = 14.000
HackText.TextStrokeTransparency = 0.000
HackText.TextWrapped = true
HackText.TextXAlignment = Enum.TextXAlignment.Left

HackExpand.Name = "HackExpand"
HackExpand.Parent = HackButtonEx
HackExpand.Active = false
HackExpand.AnchorPoint = Vector2.new(1, 0.5)
HackExpand.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
HackExpand.BackgroundTransparency = 1.000
HackExpand.BorderColor3 = Color3.fromRGB(0, 0, 0)
HackExpand.BorderSizePixel = 0
HackExpand.Position = UDim2.new(1, 0, 0, 20)
HackExpand.Selectable = false
HackExpand.Size = UDim2.new(0, 31, 0, 40)
HackExpand.ZIndex = 3
HackExpand.Image = "rbxassetid://12809025337"
HackExpand.ScaleType = Enum.ScaleType.Fit

OptionsList.Name = "OptionsList"
OptionsList.Parent = HackButtonEx
OptionsList.AutomaticSize = Enum.AutomaticSize.Y
OptionsList.BackgroundColor3 = Color3.fromRGB(58, 58, 58)
OptionsList.BorderColor3 = Color3.fromRGB(0, 0, 0)
OptionsList.BorderSizePixel = 0
OptionsList.Position = UDim2.new(0, 0, 0, 40)
OptionsList.Size = UDim2.new(1, 0, 0, 0)
OptionsList.ZIndex = 2

UIListLayout_6.Parent = OptionsList
UIListLayout_6.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout_6.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout_6.Padding = UDim.new(0, 1)

ToggleEx.Name = "ToggleEx"
ToggleEx:AddTag("RemoveOnDestroy")
C.Examples.ToggleEx = ToggleEx
ToggleEx.BackgroundColor3 = Color3.fromRGB(0, 255, 102)
ToggleEx.BackgroundTransparency = 1.000
ToggleEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleEx.BorderSizePixel = 0
ToggleEx.Size = UDim2.new(1, 0, 0, 40)

NameTL.Name = "NameTL"
NameTL.Parent = ToggleEx
NameTL.Active = true
NameTL.AnchorPoint = Vector2.new(0, 0.5)
NameTL.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NameTL.BackgroundTransparency = 1.000
NameTL.BorderColor3 = Color3.fromRGB(0, 0, 0)
NameTL.BorderSizePixel = 0
NameTL.Position = UDim2.new(0.0500000007, 0, 0.5, 0)
NameTL.Size = UDim2.new(0.600000024, 0, 0, 30)
NameTL.ZIndex = 2
NameTL.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
NameTL.Text = "AimAssist"
NameTL.TextColor3 = Color3.fromRGB(255, 255, 255)
NameTL.TextScaled = true
NameTL.TextSize = 14.000
NameTL.TextStrokeTransparency = 0.000
NameTL.TextWrapped = true
NameTL.TextXAlignment = Enum.TextXAlignment.Left

ToggleSwitchSlider.Name = "ToggleSwitchSlider"
ToggleSwitchSlider.Parent = ToggleEx
ToggleSwitchSlider.Active = false
ToggleSwitchSlider.AnchorPoint = Vector2.new(1, 0.5)
ToggleSwitchSlider.BackgroundColor3 = Color3.fromRGB(113, 113, 113)
ToggleSwitchSlider.BorderColor3 = Color3.fromRGB(27, 42, 53)
ToggleSwitchSlider.Position = UDim2.new(0.949999988, 0, 0.5, 0)
ToggleSwitchSlider.Selectable = false
ToggleSwitchSlider.Size = UDim2.new(0.25, 0, 0.600000024, 0)
ToggleSwitchSlider.ZIndex = 2
ToggleSwitchSlider.AutoButtonColor = false

UICorner_4.CornerRadius = UDim.new(1, 0)
UICorner_4.Parent = ToggleSwitchSlider

ToggleCircle.Name = "ToggleCircle"
ToggleCircle.Parent = ToggleSwitchSlider
ToggleCircle.Active = true
ToggleCircle.AnchorPoint = Vector2.new(0, 0.5)
ToggleCircle.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
ToggleCircle.BorderColor3 = Color3.fromRGB(27, 42, 53)
ToggleCircle.Position = UDim2.new(0.603999972, 0, 0.5, 0)
ToggleCircle.Size = UDim2.new(0.345999986, 0, 0.649999976, 0)
ToggleCircle.ZIndex = 3

UICorner_5.CornerRadius = UDim.new(0, 100)
UICorner_5.Parent = ToggleCircle

UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(83, 83, 83))}
UIGradient.Rotation = 90
UIGradient.Parent = ToggleCircle

UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(83, 83, 83))}
UIGradient_2.Rotation = 90
UIGradient_2.Parent = ToggleSwitchSlider

SliderEx.Name = "SliderEx"
SliderEx:AddTag("RemoveOnDestroy")
C.Examples.SliderEx = SliderEx
SliderEx.BackgroundColor3 = Color3.fromRGB(0, 255, 102)
SliderEx.BackgroundTransparency = 1.000
SliderEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
SliderEx.BorderSizePixel = 0
SliderEx.Size = UDim2.new(1, 0, 0, 60)

NameTL_2.Name = "NameTL"
NameTL_2.Parent = SliderEx
NameTL_2.Active = true
NameTL_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NameTL_2.BackgroundTransparency = 1.000
NameTL_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
NameTL_2.BorderSizePixel = 0
NameTL_2.Position = UDim2.new(0.0500000007, 0, 0, 0)
NameTL_2.Size = UDim2.new(0.600000024, 0, 0, 30)
NameTL_2.ZIndex = 2
NameTL_2.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
NameTL_2.Text = "Range"
NameTL_2.TextColor3 = Color3.fromRGB(255, 255, 255)
NameTL_2.TextScaled = true
NameTL_2.TextSize = 14.000
NameTL_2.TextStrokeTransparency = 0.000
NameTL_2.TextWrapped = true
NameTL_2.TextXAlignment = Enum.TextXAlignment.Left

SlidingBar.Name = "SlidingBar"
SlidingBar.Parent = SliderEx
SlidingBar.AnchorPoint = Vector2.new(0.5, 1)
SlidingBar.BackgroundColor3 = Color3.fromRGB(44, 44, 44)
SlidingBar.BorderColor3 = Color3.fromRGB(27, 42, 53)
SlidingBar.Position = UDim2.new(0.5, 0, 0.879999995, 0)
SlidingBar.Selectable = false
SlidingBar.Size = UDim2.new(0.699999988, 0, 0, 15)
SlidingBar.ZIndex = 2
SlidingBar.AutoButtonColor = false

UICorner_6.CornerRadius = UDim.new(1, 0)
UICorner_6.Parent = SlidingBar

CurrentPosition.Name = "CurrentPosition"
CurrentPosition.Parent = SlidingBar
CurrentPosition.Active = true
CurrentPosition.AnchorPoint = Vector2.new(0.5, 0.5)
CurrentPosition.BackgroundColor3 = Color3.fromRGB(89, 89, 89)
CurrentPosition.BorderColor3 = Color3.fromRGB(27, 42, 53)
CurrentPosition.Position = UDim2.new(0.200000003, 0, 0.5, 0)
CurrentPosition.Size = UDim2.new(0.100000001, 0, 1, 0)
CurrentPosition.ZIndex = 3

UICorner_7.CornerRadius = UDim.new(0, 100)
UICorner_7.Parent = CurrentPosition

UIGradient_3.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(83, 83, 83))}
UIGradient_3.Rotation = 90
UIGradient_3.Parent = CurrentPosition

UIGradient_4.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(83, 83, 83))}
UIGradient_4.Rotation = 90
UIGradient_4.Parent = SlidingBar

Backing.Name = "Backing"
Backing.Parent = SlidingBar
Backing.AnchorPoint = Vector2.new(0.5, 0.5)
Backing.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Backing.BackgroundTransparency = 1.000
Backing.BorderColor3 = Color3.fromRGB(0, 0, 0)
Backing.BorderSizePixel = 0
Backing.Position = UDim2.new(0.5, 0, 0.5, 0)
Backing.Size = UDim2.new(1.29999995, 0, 1.70000005, 0)
Backing.ZIndex = 9

Track.Name = "Track"
Track.Parent = SlidingBar
Track.AnchorPoint = Vector2.new(0.5, 0.5)
Track.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Track.BackgroundTransparency = 1.000
Track.BorderColor3 = Color3.fromRGB(0, 0, 0)
Track.BorderSizePixel = 0
Track.Position = UDim2.new(0.5, 0, 0.5, 0)
Track.Size = UDim2.new(0.899999976, 0, 0.100000001, 0)
Track.ZIndex = 9

ForceTB.Name = "ForceTB"
ForceTB.Parent = SliderEx
ForceTB.AnchorPoint = Vector2.new(1, 0)
ForceTB.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ForceTB.BackgroundTransparency = 1.000
ForceTB.BorderColor3 = Color3.fromRGB(0, 0, 0)
ForceTB.BorderSizePixel = 0
ForceTB.Position = UDim2.new(1, 0, 0, 0)
ForceTB.Size = UDim2.new(0.300000012, 0, 0, 30)
ForceTB.ZIndex = 3
ForceTB.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ForceTB.Text = ""
ForceTB.TextColor3 = Color3.fromRGB(255, 255, 255)
ForceTB.TextScaled = true
ForceTB.TextSize = 14.000
ForceTB.TextStrokeTransparency = 0.000
ForceTB.TextWrapped = true

TBUnderbar.Name = "TBUnderbar"
TBUnderbar.Parent = ForceTB
TBUnderbar.AnchorPoint = Vector2.new(0.5, 1)
TBUnderbar.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
TBUnderbar.BorderColor3 = Color3.fromRGB(0, 0, 0)
TBUnderbar.BorderSizePixel = 0
TBUnderbar.Position = UDim2.new(0.5, 0, 0.959999979, 0)
TBUnderbar.Size = UDim2.new(0.400000006, 0, 0, 1)

LeftBound.Name = "LeftBound"
LeftBound.Parent = SliderEx
LeftBound.Active = true
LeftBound.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LeftBound.BackgroundTransparency = 1.000
LeftBound.BorderColor3 = Color3.fromRGB(0, 0, 0)
LeftBound.BorderSizePixel = 0
LeftBound.Position = UDim2.new(0.0500000007, 0, 0.629999995, 0)
LeftBound.Size = UDim2.new(0.100000001, 0, -0.25, 30)
LeftBound.ZIndex = 2
LeftBound.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
LeftBound.Text = "30"
LeftBound.TextColor3 = Color3.fromRGB(255, 255, 255)
LeftBound.TextScaled = true
LeftBound.TextSize = 14.000
LeftBound.TextStrokeTransparency = 0.000
LeftBound.TextWrapped = true

RightBound.Name = "RightBound"
RightBound.Parent = SliderEx
RightBound.Active = true
RightBound.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
RightBound.BackgroundTransparency = 1.000
RightBound.BorderColor3 = Color3.fromRGB(0, 0, 0)
RightBound.BorderSizePixel = 0
RightBound.Position = UDim2.new(0.850000024, 0, 0.629999995, 0)
RightBound.Size = UDim2.new(0.100000001, 0, -0.25, 30)
RightBound.ZIndex = 2
RightBound.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
RightBound.Text = "100"
RightBound.TextColor3 = Color3.fromRGB(255, 255, 255)
RightBound.TextScaled = true
RightBound.TextSize = 14.000
RightBound.TextStrokeTransparency = 0.000
RightBound.TextWrapped = true

DropdownEx.Name = "DropdownEx"
DropdownEx:AddTag("RemoveOnDestroy")
C.Examples.DropdownEx = DropdownEx
DropdownEx.BackgroundColor3 = Color3.fromRGB(0, 255, 102)
DropdownEx.BackgroundTransparency = 1.000
DropdownEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
DropdownEx.BorderSizePixel = 0
DropdownEx.Size = UDim2.new(1, 0, 0, 40)

NameTL_3.Name = "NameTL"
NameTL_3.Parent = DropdownEx
NameTL_3.Active = true
NameTL_3.AnchorPoint = Vector2.new(0, 0.5)
NameTL_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NameTL_3.BackgroundTransparency = 1.000
NameTL_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
NameTL_3.BorderSizePixel = 0
NameTL_3.Position = UDim2.new(0.0500000007, 0, 0.5, 0)
NameTL_3.Size = UDim2.new(0.5, 0, 0, 30)
NameTL_3.ZIndex = 2
NameTL_3.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
NameTL_3.Text = "AimAssist"
NameTL_3.TextColor3 = Color3.fromRGB(255, 255, 255)
NameTL_3.TextScaled = true
NameTL_3.TextSize = 14.000
NameTL_3.TextStrokeTransparency = 0.000
NameTL_3.TextWrapped = true
NameTL_3.TextXAlignment = Enum.TextXAlignment.Left

DropdownButton.Name = "DropdownButton"
DropdownButton.Parent = DropdownEx
DropdownButton.AnchorPoint = Vector2.new(1, 0.5)
DropdownButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
DropdownButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
DropdownButton.BorderSizePixel = 0
DropdownButton.Position = UDim2.new(0.970000029, 0, 0.5, 0)
DropdownButton.Size = UDim2.new(0.400000006, 0, 0, 30)
DropdownButton.ZIndex = 2
DropdownButton.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
DropdownButton.Text = "God Mode⬇"
DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DropdownButton.TextScaled = true
DropdownButton.TextSize = 14.000
DropdownButton.TextStrokeTransparency = 0.000
DropdownButton.TextWrapped = true

UICorner_8.Parent = DropdownButton

UserListEx.Name = "UserListEx"
UserListEx:AddTag("RemoveOnDestroy")
C.Examples.UserListEx = UserListEx
UserListEx.AutomaticSize = Enum.AutomaticSize.Y
UserListEx.BackgroundColor3 = Color3.fromRGB(0, 255, 102)
UserListEx.BackgroundTransparency = 1.000
UserListEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
UserListEx.BorderSizePixel = 0
UserListEx.Size = UDim2.new(1, 0, 0, 40)

NameTL_4.Name = "NameTL"
NameTL_4.Parent = UserListEx
NameTL_4.Active = true
NameTL_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NameTL_4.BackgroundTransparency = 1.000
NameTL_4.BorderColor3 = Color3.fromRGB(0, 0, 0)
NameTL_4.BorderSizePixel = 0
NameTL_4.Position = UDim2.new(0.0500000007, 0, 0, 5)
NameTL_4.Size = UDim2.new(0.699999988, 0, 0, 30)
NameTL_4.ZIndex = 2
NameTL_4.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
NameTL_4.Text = "AimAssist"
NameTL_4.TextColor3 = Color3.fromRGB(255, 255, 255)
NameTL_4.TextScaled = true
NameTL_4.TextSize = 14.000
NameTL_4.TextStrokeTransparency = 0.000
NameTL_4.TextWrapped = true
NameTL_4.TextXAlignment = Enum.TextXAlignment.Left

AddButton.Name = "AddButton"
AddButton.Parent = UserListEx
AddButton.AnchorPoint = Vector2.new(1, 0)
AddButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
AddButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
AddButton.BorderSizePixel = 0
AddButton.Position = UDim2.new(0.970000029, 0, 0, 40)
AddButton.Size = UDim2.new(0.150000006, 0, 0, 30)
AddButton.ZIndex = 2
AddButton.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
AddButton.Text = "+"
AddButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AddButton.TextScaled = true
AddButton.TextSize = 14.000
AddButton.TextStrokeTransparency = 0.000
AddButton.TextWrapped = true

UICorner_9.Parent = AddButton

MainList.Name = "MainList"
MainList.Parent = UserListEx
MainList.AutomaticSize = Enum.AutomaticSize.Y
MainList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainList.BackgroundTransparency = 1.000
MainList.BorderColor3 = Color3.fromRGB(0, 0, 0)
MainList.BorderSizePixel = 0
MainList.Position = UDim2.new(0, 0, 0, 80)
MainList.Size = UDim2.new(1, 0, 0, 0)

UIListLayout_7.Parent = MainList
UIListLayout_7.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout_7.SortOrder = Enum.SortOrder.LayoutOrder

OneListEx.Name = "OneListEx"
OneListEx:AddTag("RemoveOnDestroy")
C.Examples.OneListEx = OneListEx
OneListEx.BackgroundColor3 = Color3.fromRGB(79, 79, 79)
OneListEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
OneListEx.BorderSizePixel = 0
OneListEx.Size = UDim2.new(1, 0, 0, 20)

DeleteButton.Name = "DeleteButton"
DeleteButton.Parent = OneListEx
DeleteButton.AnchorPoint = Vector2.new(1, 0)
DeleteButton.BackgroundColor3 = Color3.fromRGB(198, 0, 0)
DeleteButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
DeleteButton.BorderSizePixel = 0
DeleteButton.Position = UDim2.new(0.970000029, 0, 0, 0)
DeleteButton.Size = UDim2.new(0.150000006, 0, 1, 0)
DeleteButton.ZIndex = 2
DeleteButton.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
DeleteButton.Text = "X"
DeleteButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DeleteButton.TextScaled = true
DeleteButton.TextSize = 14.000
DeleteButton.TextStrokeTransparency = 0.000
DeleteButton.TextWrapped = true

UICorner_10.Parent = DeleteButton

UserTL.Name = "UserTL"
UserTL.Parent = OneListEx
UserTL.Active = true
UserTL.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UserTL.BackgroundTransparency = 1.000
UserTL.BorderColor3 = Color3.fromRGB(0, 0, 0)
UserTL.BorderSizePixel = 0
UserTL.Position = UDim2.new(0.0500000007, 0, 0, 0)
UserTL.Size = UDim2.new(0.699999988, 0, 1, 0)
UserTL.ZIndex = 2
UserTL.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
UserTL.Text = "areallycoolguy"
UserTL.TextColor3 = Color3.fromRGB(255, 255, 255)
UserTL.TextScaled = true
UserTL.TextSize = 14.000
UserTL.TextStrokeTransparency = 0.000
UserTL.TextWrapped = true
UserTL.TextXAlignment = Enum.TextXAlignment.Left

EnterTB.Name = "EnterTB"
EnterTB.Parent = UserListEx
EnterTB.BackgroundColor3 = Color3.fromRGB(188, 188, 188)
EnterTB.BorderColor3 = Color3.fromRGB(0, 0, 0)
EnterTB.BorderSizePixel = 0
EnterTB.Position = UDim2.new(0.0500000007, 0, 0, 40)
EnterTB.Selectable = false
EnterTB.Size = UDim2.new(0.730000019, 0, 0, 30)
EnterTB.ZIndex = 2
EnterTB.ClearTextOnFocus = false
EnterTB.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
EnterTB.PlaceholderText = "Enter username/userid"
EnterTB.Text = ""
EnterTB.TextColor3 = Color3.fromRGB(255, 255, 255)
EnterTB.TextScaled = true
EnterTB.TextSize = 14.000
EnterTB.TextStrokeTransparency = 0.000
EnterTB.TextWrapped = true

UICorner_11.Parent = EnterTB

LimitTL.Name = "LimitTL"
LimitTL.Parent = UserListEx
LimitTL.Active = true
LimitTL.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LimitTL.BackgroundTransparency = 1.000
LimitTL.BorderColor3 = Color3.fromRGB(0, 0, 0)
LimitTL.BorderSizePixel = 0
LimitTL.Position = UDim2.new(0.789999783, 0, 0, 5)
LimitTL.Size = UDim2.new(0.177391246, 0, 0, 30)
LimitTL.ZIndex = 2
LimitTL.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Regular,Enum.FontStyle.Normal)
LimitTL.Text = "0/50"
LimitTL.TextColor3 = Color3.fromRGB(255, 255, 255)
LimitTL.TextScaled = true
LimitTL.TextSize = 14.000
LimitTL.TextStrokeTransparency = 0.000
LimitTL.TextWrapped = true
LimitTL.TextXAlignment = Enum.TextXAlignment.Left

TextboxEx.Name = "TextboxEx"
TextboxEx:AddTag("RemoveOnDestroy")
C.Examples.TextboxEx = TextboxEx
TextboxEx.AutomaticSize = Enum.AutomaticSize.Y
TextboxEx.BackgroundColor3 = Color3.fromRGB(0, 255, 102)
TextboxEx.BackgroundTransparency = 1.000
TextboxEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextboxEx.BorderSizePixel = 0
TextboxEx.Size = UDim2.new(1, 0, 0, 40)

NameTL_5.Name = "NameTL"
NameTL_5.Parent = TextboxEx
NameTL_5.Active = true
NameTL_5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NameTL_5.BackgroundTransparency = 1.000
NameTL_5.BorderColor3 = Color3.fromRGB(0, 0, 0)
NameTL_5.BorderSizePixel = 0
NameTL_5.Position = UDim2.new(0.0500000007, 0, 0, 5)
NameTL_5.Size = UDim2.new(0.699999988, 0, 0, 30)
NameTL_5.ZIndex = 2
NameTL_5.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
NameTL_5.Text = "AimAssist"
NameTL_5.TextColor3 = Color3.fromRGB(255, 255, 255)
NameTL_5.TextScaled = true
NameTL_5.TextSize = 14.000
NameTL_5.TextStrokeTransparency = 0.000
NameTL_5.TextWrapped = true
NameTL_5.TextXAlignment = Enum.TextXAlignment.Left

SetTB.Name = "SetTB"
SetTB.Parent = TextboxEx
SetTB.BackgroundColor3 = Color3.fromRGB(188, 188, 188)
SetTB.BorderColor3 = Color3.fromRGB(0, 0, 0)
SetTB.BorderSizePixel = 0
SetTB.Position = UDim2.new(0.0500000007, 0, 0, 40)
SetTB.Selectable = false
SetTB.Size = UDim2.new(0.730000019, 0, 0, 30)
SetTB.ZIndex = 2
SetTB.ClearTextOnFocus = false
SetTB.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
SetTB.PlaceholderText = "Enter something here.."
SetTB.Text = ""
SetTB.TextColor3 = Color3.fromRGB(255, 255, 255)
SetTB.TextScaled = true
SetTB.TextSize = 14.000
SetTB.TextStrokeTransparency = 0.100
SetTB.TextTransparency = 0.100
SetTB.TextWrapped = true

UICorner_12.Parent = SetTB

LimitTL_2.Name = "LimitTL"
LimitTL_2.Parent = TextboxEx
LimitTL_2.Active = true
LimitTL_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LimitTL_2.BackgroundTransparency = 1.000
LimitTL_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
LimitTL_2.BorderSizePixel = 0
LimitTL_2.Position = UDim2.new(0.789999783, 0, 0, 5)
LimitTL_2.Size = UDim2.new(0.177391246, 0, 0, 30)
LimitTL_2.ZIndex = 2
LimitTL_2.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Regular,Enum.FontStyle.Normal)
LimitTL_2.Text = "0/50"
LimitTL_2.TextColor3 = Color3.fromRGB(255, 255, 255)
LimitTL_2.TextScaled = true
LimitTL_2.TextSize = 14.000
LimitTL_2.TextStrokeTransparency = 0.000
LimitTL_2.TextWrapped = true
LimitTL_2.TextXAlignment = Enum.TextXAlignment.Left

EnterButton.Name = "EnterButton"
EnterButton.Parent = TextboxEx
EnterButton.AnchorPoint = Vector2.new(1, 0)
EnterButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
EnterButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
EnterButton.BorderSizePixel = 0
EnterButton.Position = UDim2.new(0.970000029, 0, 0, 40)
EnterButton.Size = UDim2.new(0.150000006, 0, 0, 30)
EnterButton.ZIndex = 2
EnterButton.Image = "rbxassetid://504367763"

UICorner_13.Parent = EnterButton

HighlightBackground.Name = "HighlightBackground"
HighlightBackground.Parent = HackButtonEx
HighlightBackground.BackgroundColor3 = Color3.fromRGB(0, 255, 60)
HighlightBackground.BackgroundTransparency = 1.000
HighlightBackground.BorderColor3 = Color3.fromRGB(0, 0, 0)
HighlightBackground.BorderSizePixel = 0
HighlightBackground.Size = UDim2.new(1, 0, 0, 40)

KeybindButton.Name = "KeybindButton"
KeybindButton.Parent = HackButtonEx
KeybindButton.Active = false
KeybindButton.AnchorPoint = Vector2.new(1, 0.5)
KeybindButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
KeybindButton.BackgroundTransparency = 1.000
KeybindButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
KeybindButton.BorderSizePixel = 0
KeybindButton.Position = UDim2.new(0.841303527, 0, 0, 20)
KeybindButton.Selectable = false
KeybindButton.Size = UDim2.new(0, 34, 0, 40)
KeybindButton.ZIndex = 3
KeybindButton.Image = "rbxassetid://6884453656"
KeybindButton.ScaleType = Enum.ScaleType.Fit

BindedKey.Name = "BindedKey"
BindedKey.Parent = KeybindButton
BindedKey.Active = true
BindedKey.AnchorPoint = Vector2.new(0.5, 0.5)
BindedKey.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
BindedKey.BackgroundTransparency = 1.000
BindedKey.BorderColor3 = Color3.fromRGB(0, 0, 0)
BindedKey.BorderSizePixel = 0
BindedKey.Position = UDim2.new(0.5, 0, 0.5, 0)
BindedKey.Size = UDim2.new(0.800000012, 0, 0.600000024, 0)
BindedKey.ZIndex = 4
BindedKey.FontFace = Font.new("rbxasset://fonts/families/Jura.json",Enum.FontWeight.Regular,Enum.FontStyle.Normal)
BindedKey.Text = ""
BindedKey.TextColor3 = Color3.fromRGB(255, 255, 255)
BindedKey.TextScaled = true
BindedKey.TextSize = 14.000
BindedKey.TextStrokeTransparency = 0.000
BindedKey.TextWrapped = true

KeybindLabel.Name = "KeybindLabel"
KeybindLabel.Parent = HackButtonEx
KeybindLabel.Active = true
KeybindLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
KeybindLabel.BackgroundTransparency = 1.000
KeybindLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
KeybindLabel.BorderSizePixel = 0
KeybindLabel.Position = UDim2.new(0.0500000007, 0, 0, 0)
KeybindLabel.Size = UDim2.new(0.649999976, 0, 0, 40)
KeybindLabel.Visible = false
KeybindLabel.ZIndex = 3
KeybindLabel.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
KeybindLabel.Text = "PRESS KEY TO BIND"
KeybindLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
KeybindLabel.TextScaled = true
KeybindLabel.TextSize = 14.000
KeybindLabel.TextStrokeTransparency = 0.000
KeybindLabel.TextWrapped = true
KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left

KeybindBacking.Name = "KeybindBacking"
KeybindBacking.Parent = KeybindLabel
KeybindBacking.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
KeybindBacking.BorderColor3 = Color3.fromRGB(0, 0, 0)
KeybindBacking.BorderSizePixel = 0
KeybindBacking.Position = UDim2.new(-0.0769230798, 0, 0, 0)
KeybindBacking.Size = UDim2.new(1.53846157, 0, 1, 0)
KeybindBacking.ZIndex = 2

UIGradient_5.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(117, 75, 255)), ColorSequenceKeypoint.new(0.52, Color3.fromRGB(169, 0, 23)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(197, 255, 39))}
UIGradient_5.Parent = KeybindBacking

ToolTipHeaderFrame.Name = "ToolTipHeaderFrame"
ToolTipHeaderFrame.Parent = MainHUD
C.UI.ToolTipHeaderFrame = ToolTipHeaderFrame
ToolTipHeaderFrame.AutomaticSize = Enum.AutomaticSize.Y
ToolTipHeaderFrame.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
ToolTipHeaderFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToolTipHeaderFrame.BorderSizePixel = 0
ToolTipHeaderFrame.Position = UDim2.new(0, 536, 0, 180)
ToolTipHeaderFrame.Size = UDim2.new(0, 200, 0, 0)
ToolTipHeaderFrame.Visible = false
ToolTipHeaderFrame.ZIndex = 15

ToolTipText.Name = "ToolTipText"
ToolTipText.Parent = ToolTipHeaderFrame
ToolTipText.AutomaticSize = Enum.AutomaticSize.Y
ToolTipText.AnchorPoint = Vector2.new(0.5, 0)
ToolTipText.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
ToolTipText.BackgroundTransparency = 1.000
ToolTipText.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToolTipText.BorderSizePixel = 0
ToolTipText.Position = UDim2.new(0.5, 0, 0, 0)
ToolTipText.Size = UDim2.new(0.800000012, 0, 0, 0)
ToolTipText.ZIndex = 16
ToolTipText.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ToolTipText.Text = "Aims At Enemies"
ToolTipText.TextColor3 = Color3.fromRGB(255, 255, 255)
ToolTipText.TextSize = 22.000
ToolTipText.TextStrokeTransparency = 0.000
ToolTipText.TextWrapped = true

UICorner_14.CornerRadius = UDim.new(0.400000006, 0)
UICorner_14.Parent = ToolTipHeaderFrame

Notifications.Name = "Notifications"
Notifications.Parent = SpecterGUI
C.UI.Notifications = Notifications
Notifications.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Notifications.BackgroundTransparency = 1.000
Notifications.BorderColor3 = Color3.fromRGB(0, 0, 0)
Notifications.BorderSizePixel = 0
Notifications.Size = UDim2.new(1, 0, 1, 0)

NotificationEx.Name = "NotificationEx"
NotificationEx:AddTag("RemoveOnDestroy")
C.Examples.NotificationEx = NotificationEx
NotificationEx.AnchorPoint = Vector2.new(1, 1)
NotificationEx.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
NotificationEx.BackgroundTransparency = 0.300
NotificationEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
NotificationEx.BorderSizePixel = 0
NotificationEx.Position = UDim2.new(1, 0, 1, 0)
NotificationEx.Size = UDim2.new(0.150000006, 0, 0.100000001, 0)
NotificationEx.Visible = false
NotificationEx.ZIndex = 2

Timer.Name = "Timer"
Timer.Parent = NotificationEx
Timer.AnchorPoint = Vector2.new(0, 1)
Timer.BackgroundColor3 = Color3.fromRGB(0, 115, 255)
Timer.BackgroundTransparency = 0.600
Timer.BorderColor3 = Color3.fromRGB(0, 0, 0)
Timer.BorderSizePixel = 0
Timer.Position = UDim2.new(0, 0, 1, -15)
Timer.Size = UDim2.new(1, 0, 0, 3)
Timer.ZIndex = 3

UICorner_15.CornerRadius = UDim.new(0, 20)
UICorner_15.Parent = NotificationEx

NotificationTitle.Name = "NotificationTitle"
NotificationTitle.Parent = NotificationEx
NotificationTitle.AnchorPoint = Vector2.new(0.5, 0)
NotificationTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NotificationTitle.BackgroundTransparency = 1.000
NotificationTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
NotificationTitle.BorderSizePixel = 0
NotificationTitle.Position = UDim2.new(0.5, 0, -0, 0)
NotificationTitle.Size = UDim2.new(0.800000012, 0, 0.200000003, 0)
NotificationTitle.ZIndex = 3
NotificationTitle.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
NotificationTitle.Text = "UI Loaded"
NotificationTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
NotificationTitle.TextScaled = true
NotificationTitle.TextSize = 22.000
NotificationTitle.TextStrokeTransparency = 0.000
NotificationTitle.TextWrapped = true

NotificationDesc.Name = "NotificationDesc"
NotificationDesc.Parent = NotificationEx
NotificationDesc.AnchorPoint = Vector2.new(0.5, 0)
NotificationDesc.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NotificationDesc.BackgroundTransparency = 1.000
NotificationDesc.BorderColor3 = Color3.fromRGB(0, 0, 0)
NotificationDesc.BorderSizePixel = 0
NotificationDesc.Position = UDim2.new(0.500000179, 0, 0.190796182, 0)
NotificationDesc.Size = UDim2.new(0.800000072, 0, 0.583613932, 0)
NotificationDesc.ZIndex = 3
NotificationDesc.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
NotificationDesc.Text = "UI Loaded"
NotificationDesc.TextColor3 = Color3.fromRGB(255, 255, 255)
NotificationDesc.TextScaled = true
NotificationDesc.TextSize = 22.000
NotificationDesc.TextStrokeTransparency = 0.000
NotificationDesc.TextWrapped = true

UITextSizeConstraint.Parent = NotificationDesc
UITextSizeConstraint.MaxTextSize = 44

HUDBackgroundFade.Name = "HUDBackgroundFade"
HUDBackgroundFade.Parent = SpecterGUI
C.UI.HUDBackgroundFade = HUDBackgroundFade
HUDBackgroundFade.AnchorPoint = Vector2.new(0.5, 0.5)
HUDBackgroundFade.BackgroundColor3 = Color3.fromRGB(6, 6, 6)
HUDBackgroundFade.BackgroundTransparency = 1.000
HUDBackgroundFade.BorderColor3 = Color3.fromRGB(0, 0, 0)
HUDBackgroundFade.BorderSizePixel = 0
HUDBackgroundFade.LayoutOrder = -30
HUDBackgroundFade.Position = UDim2.new(0.5, 0, 0.5, 0)
HUDBackgroundFade.Size = UDim2.new(4, 0, 4, 0)
HUDBackgroundFade.ZIndex = -30

ChatAutoComplete.Name = "ChatAutoComplete"
ChatAutoComplete.Parent = SpecterGUI
C.UI.ChatAutoComplete = ChatAutoComplete
ChatAutoComplete.Active = true
ChatAutoComplete.AutomaticSize = Enum.AutomaticSize.Y
ChatAutoComplete.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ChatAutoComplete.BackgroundTransparency = 1.000
ChatAutoComplete.BorderColor3 = Color3.fromRGB(0, 0, 0)
ChatAutoComplete.BorderSizePixel = 0
ChatAutoComplete.Size = UDim2.new(0.300000012, 0, 0, 0)
ChatAutoComplete.Visible = false
ChatAutoComplete.AutomaticCanvasSize = Enum.AutomaticSize.Y
ChatAutoComplete.CanvasSize = UDim2.new(0, 0, 0, 0)

UISizeConstraint.Parent = ChatAutoComplete
UISizeConstraint.MaxSize = Vector2.new(9999999, 300)

AutoCompleteEx.Name = "AutoCompleteEx"
AutoCompleteEx:AddTag("RemoveOnDestroy")
C.Examples.AutoCompleteEx = AutoCompleteEx
AutoCompleteEx.BackgroundColor3 = Color3.fromRGB(55, 255, 0)
AutoCompleteEx.BorderColor3 = Color3.fromRGB(0, 0, 0)
AutoCompleteEx.BorderSizePixel = 0
AutoCompleteEx.Size = UDim2.new(1, 0, 0, 25)

AutoCompleteTitleLabel.Name = "AutoCompleteTitleLabel"
AutoCompleteTitleLabel.Parent = AutoCompleteEx
AutoCompleteTitleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
AutoCompleteTitleLabel.BackgroundTransparency = 1.000
AutoCompleteTitleLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
AutoCompleteTitleLabel.BorderSizePixel = 0
AutoCompleteTitleLabel.Size = UDim2.new(1, 0, 1, 0)
AutoCompleteTitleLabel.FontFace = Font.new("rbxasset://fonts/families/IndieFlower.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
AutoCompleteTitleLabel.Text = "This sounds cool"
AutoCompleteTitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoCompleteTitleLabel.TextScaled = true
AutoCompleteTitleLabel.TextSize = 14.000
AutoCompleteTitleLabel.TextStrokeTransparency = 0.000
AutoCompleteTitleLabel.TextWrapped = true

UIListLayout_8.Parent = ChatAutoComplete
UIListLayout_8.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout_8.SortOrder = Enum.SortOrder.LayoutOrder
	return SpecterGUI,CategoriesFrame,TabsFrame,ToolTipHeaderFrame,ToolTipText
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
			x = math.clamp(x, minX, maxX)
			y = math.clamp(y, minY, maxY)

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

	
	--Load Settings Loader
	C.ExtraOptions = C.LoadModule("HackOptions")
	
	C.UI.CategoriesFrame = CategoriesFrame
	C.UI.TabsFrame = TabsFrame
	
	C.GUI = SpecterGUI
end