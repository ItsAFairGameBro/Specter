local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",Textbox="Textbox",UserList="UserList"}
local TCS = game:GetService("TextChatService")
local RS = game:GetService"ReplicatedStorage"
local PS = game:GetService"Players"
local RunS = game:GetService("RunService")
local CG = game:GetService("CoreGui")
local CAS = game:GetService("ContextActionService")
local SG = game:GetService('StarterGui')
local UIS = game:GetService('UserInputService')

local C

local pi    = math.pi
local abs   = math.abs
local clamp = math.clamp
local exp   = math.exp
local rad   = math.rad
local sign  = math.sign
local sqrt  = math.sqrt
local tan   = math.tan

local FREECAM_SETTINGS
local TOGGLE_INPUT_PRIORITY = Enum.ContextActionPriority.Low.Value
local INPUT_PRIORITY = Enum.ContextActionPriority.High.Value

local NAV_GAIN = Vector3.new(1, 1, 1)*64
local PAN_GAIN = Vector2.new(0.75, 1)*8
local FOV_GAIN = 300

local PITCH_LIMIT = rad(90)

local VEL_STIFFNESS = 10
local PAN_STIFFNESS = 10
local FOV_STIFFNESS = 10

local Spring = {} do
	Spring.__index = Spring

	function Spring.new(freq, pos)
		local self = setmetatable({}, Spring)
		self.f = freq
		self.p = pos
		self.v = pos*0
		return self
	end

	function Spring:Update(dt, goal)
		local f = self.f*2*pi
		local p0 = self.p
		local v0 = self.v

		local offset = goal - p0
		local decay = exp(-f*dt)

		local p1 = goal + (v0*dt - offset*(f*dt + 1))*decay
		local v1 = (f*dt*(offset*f - v0) + v0)*decay

		self.p = p1
		self.v = v1

		return p1
	end

	function Spring:Reset(pos)
		self.p = pos
		self.v = pos*0
	end
end

local cameraPos = Vector3.new()
local cameraRot = Vector2.new()
local cameraFov = 0

local velSpring = Spring.new(VEL_STIFFNESS, Vector3.new())
local panSpring = Spring.new(PAN_STIFFNESS, Vector2.new())
local fovSpring = Spring.new(FOV_STIFFNESS, 0)

local Input = {} do
	local thumbstickCurve do
		local K_CURVATURE = 2.0
		local K_DEADZONE = 0.15

		local function fCurve(x)
			return (exp(K_CURVATURE*x) - 1)/(exp(K_CURVATURE) - 1)
		end

		local function fDeadzone(x)
			return fCurve((x - K_DEADZONE)/(1 - K_DEADZONE))
		end

		function thumbstickCurve(x)
			return sign(x)*clamp(fDeadzone(abs(x)), 0, 1)
		end
	end

	local gamepad = {
		ButtonX = 0,
		ButtonY = 0,
		DPadDown = 0,
		DPadUp = 0,
		ButtonL2 = 0,
		ButtonR2 = 0,
		Thumbstick1 = Vector2.new(),
		Thumbstick2 = Vector2.new(),
	}

	local keyboard = {
		W = 0,
		A = 0,
		S = 0,
		D = 0,
		E = 0,
		Q = 0,
		U = 0,
		H = 0,
		J = 0,
		K = 0,
		I = 0,
		Y = 0,
		Up = 0,
		Down = 0,
		LeftShift = 0,
		RightShift = 0,
	}

	local mouse = {
		Delta = Vector2.new(),
		MouseWheel = 0,
	}

	local NAV_GAMEPAD_SPEED  = Vector3.new(1, 1, 1)
	local NAV_KEYBOARD_SPEED = Vector3.new(1, 1, 1)
	local PAN_MOUSE_SPEED    = Vector2.new(1, 1)*(pi/64)
	local PAN_GAMEPAD_SPEED  = Vector2.new(1, 1)*(pi/8)
	local FOV_WHEEL_SPEED    = 1.0
	local FOV_GAMEPAD_SPEED  = 0.25
	local NAV_ADJ_SPEED      = 0.75
	local NAV_SHIFT_MUL      = 0.25

	local navSpeed = 1

	function Input.Vel(dt)
		navSpeed = clamp(navSpeed + dt*(keyboard.Up - keyboard.Down)*NAV_ADJ_SPEED*FREECAM_SETTINGS.SpeedMult, 0.01, 4)

		local kGamepad = Vector3.new(
			thumbstickCurve(gamepad.Thumbstick1.X),
			thumbstickCurve(gamepad.ButtonR2) - thumbstickCurve(gamepad.ButtonL2),
			thumbstickCurve(-gamepad.Thumbstick1.Y)
		)*NAV_GAMEPAD_SPEED*FREECAM_SETTINGS.SpeedMult

		local kKeyboard = Vector3.new(
			keyboard.D - keyboard.A + keyboard.K - keyboard.H,
			keyboard.E - keyboard.Q + keyboard.I - keyboard.Y,
			keyboard.S - keyboard.W + keyboard.J - keyboard.U
		)*NAV_KEYBOARD_SPEED*FREECAM_SETTINGS.SpeedMult

		local shift = UIS:IsKeyDown(Enum.KeyCode.LeftShift) or UIS:IsKeyDown(Enum.KeyCode.RightShift)

		return (kGamepad + kKeyboard)*(navSpeed*(shift and NAV_SHIFT_MUL or 1))
	end

	function Input.Pan(dt)
		local kGamepad = Vector2.new(
			thumbstickCurve(gamepad.Thumbstick2.Y),
			thumbstickCurve(-gamepad.Thumbstick2.X)
		)*PAN_GAMEPAD_SPEED*FREECAM_SETTINGS.TurnMult
		local kMouse = mouse.Delta*PAN_MOUSE_SPEED*FREECAM_SETTINGS.TurnMult
		mouse.Delta = Vector2.new()
		return kGamepad + kMouse
	end

	function Input.Fov(dt)
		local kGamepad = (gamepad.ButtonX - gamepad.ButtonY)*FOV_GAMEPAD_SPEED*FREECAM_SETTINGS.ZoomMult
		local kMouse = mouse.MouseWheel*FOV_WHEEL_SPEED*FREECAM_SETTINGS.ZoomMult
		mouse.MouseWheel = 0
		return kGamepad + kMouse
	end

	do
		local function Keypress(action, state, input)
			keyboard[input.KeyCode.Name] = state == Enum.UserInputState.Begin and 1 or 0
			return Enum.ContextActionResult.Sink
		end

		local function GpButton(action, state, input)
			gamepad[input.KeyCode.Name] = state == Enum.UserInputState.Begin and 1 or 0
			return Enum.ContextActionResult.Sink
		end

		local function MousePan(action, state, input)
			local delta = input.Delta
			mouse.Delta = Vector2.new(-delta.y, -delta.x)
			return Enum.ContextActionResult.Sink
		end

		local function Thumb(action, state, input)
			gamepad[input.KeyCode.Name] = input.Position
			return Enum.ContextActionResult.Sink
		end

		local function Trigger(action, state, input)
			gamepad[input.KeyCode.Name] = input.Position.z
			return Enum.ContextActionResult.Sink
		end

		local function MouseWheel(action, state, input)
			mouse[input.UserInputType.Name] = -input.Position.z
			return Enum.ContextActionResult.Sink
		end

		local function Zero(t)
			for k, v in pairs(t) do
				t[k] = v*0
			end
		end

		function Input.StartCapture()
			CAS:BindActionAtPriority("FreecamKeyboard", Keypress, false, INPUT_PRIORITY,
				Enum.KeyCode.W, Enum.KeyCode.U,
				Enum.KeyCode.A, Enum.KeyCode.H,
				Enum.KeyCode.S, Enum.KeyCode.J,
				Enum.KeyCode.D, Enum.KeyCode.K,
				Enum.KeyCode.E, Enum.KeyCode.I,
				Enum.KeyCode.Q, Enum.KeyCode.Y,
				Enum.KeyCode.Up, Enum.KeyCode.Down
			)
			CAS:BindActionAtPriority("FreecamMousePan",          MousePan,   false, INPUT_PRIORITY, Enum.UserInputType.MouseMovement)
			CAS:BindActionAtPriority("FreecamMouseWheel",        MouseWheel, false, INPUT_PRIORITY, Enum.UserInputType.MouseWheel)
			CAS:BindActionAtPriority("FreecamGamepadButton",     GpButton,   false, INPUT_PRIORITY, Enum.KeyCode.ButtonX, Enum.KeyCode.ButtonY)
			CAS:BindActionAtPriority("FreecamGamepadTrigger",    Trigger,    false, INPUT_PRIORITY, Enum.KeyCode.ButtonR2, Enum.KeyCode.ButtonL2)
			CAS:BindActionAtPriority("FreecamGamepadThumbstick", Thumb,      false, INPUT_PRIORITY, Enum.KeyCode.Thumbstick1, Enum.KeyCode.Thumbstick2)
		end

		function Input.StopCapture()
			navSpeed = 1
			Zero(gamepad)
			Zero(keyboard)
			Zero(mouse)
			CAS:UnbindAction("FreecamKeyboard")
			CAS:UnbindAction("FreecamMousePan")
			CAS:UnbindAction("FreecamMouseWheel")
			CAS:UnbindAction("FreecamGamepadButton")
			CAS:UnbindAction("FreecamGamepadTrigger")
			CAS:UnbindAction("FreecamGamepadThumbstick")
		end
	end
end

local function GetFocusDistance(cameraFrame)
	local znear = 0.1
	local viewport = C.Camera.ViewportSize
	local projy = 2*tan(cameraFov/2)
	local projx = viewport.x/viewport.y*projy
	local fx = cameraFrame.rightVector
	local fy = cameraFrame.upVector
	local fz = cameraFrame.lookVector

	local minVect = Vector3.new()
	local minDist = 512

	for x = 0, 1, 0.5 do
		for y = 0, 1, 0.5 do
			local cx = (x - 0.5)*projx
			local cy = (y - 0.5)*projy
			local offset = fx*cx - fy*cy + fz
			local origin = cameraFrame.p + offset*znear
			local _, hit = workspace:FindPartOnRay(Ray.new(origin, offset.unit*minDist))
			local dist = (hit - origin).magnitude
			if minDist > dist then
				minDist = dist
				minVect = offset.unit
			end
		end
	end

	return fz:Dot(minVect)*minDist
end


local function StepFreecam(dt)
	local vel = velSpring:Update(dt, Input.Vel(dt))
	local pan = panSpring:Update(dt, Input.Pan(dt))
	local fov = fovSpring:Update(dt, Input.Fov(dt))

	local zoomFactor = sqrt(tan(rad(70/2))/tan(rad(cameraFov/2)))

	cameraFov = clamp(cameraFov + fov*FOV_GAIN*(dt/zoomFactor), 1, 120)
	cameraRot = cameraRot + pan*PAN_GAIN*(dt/zoomFactor)
	cameraRot = Vector2.new(clamp(cameraRot.x, -PITCH_LIMIT, PITCH_LIMIT), cameraRot.y%(2*pi))

	local cameraCFrame = CFrame.new(cameraPos)*CFrame.fromOrientation(cameraRot.x, cameraRot.y, 0)*CFrame.new(vel*NAV_GAIN*dt)
	cameraPos = cameraCFrame.p

	C.Camera.CFrame = cameraCFrame
	C.Camera.Focus = cameraCFrame*CFrame.new(0, 0, -GetFocusDistance(cameraCFrame))
	C.Camera.FieldOfView = cameraFov
end

local PlayerState = {} do
	local mouseBehavior
	local mouseIconEnabled
	local cameraType
	local cameraFocus
	local cameraCFrame
	local cameraFieldOfView
	local coreGuis = {}
	local setCores = {}

	function PlayerState.Push()
		if FREECAM_SETTINGS.HideCoreUI then
			for name in pairs(coreGuis) do
				coreGuis[name] = SG:GetCoreGuiEnabled(Enum.CoreGuiType[name])
				SG:SetCoreGuiEnabled(Enum.CoreGuiType[name], false)
			end
			for name in pairs(setCores) do
				setCores[name] = SG:GetCore(name)
				SG:SetCore(name, false)
			end
		end
		if C.PlayerGui then
			for _, gui in pairs(C.PlayerGui:GetChildren()) do
				if gui:IsA("ScreenGui") and gui ~= C.GUI and (FREECAM_SETTINGS.HideCoreUI or gui.Name~="Chat") then
					C.SetPartProperty(gui,"Enabled","Freecam",false)
				end
			end
		end

		cameraFieldOfView = C.Camera.FieldOfView
		C.Camera.FieldOfView = 70

		cameraType = C.Camera.CameraType
		C.Camera.CameraType = Enum.CameraType.Custom

		cameraCFrame = C.Camera.CFrame
		cameraFocus = C.Camera.Focus

		mouseIconEnabled = UIS.MouseIconEnabled
		UIS.MouseIconEnabled = true

		mouseBehavior = UIS.MouseBehavior
		UIS.MouseBehavior = Enum.MouseBehavior.Default
	end

	function PlayerState.Pop()
		for name, isEnabled in pairs(coreGuis) do
			SG:SetCoreGuiEnabled(Enum.CoreGuiType[name], isEnabled)
		end
		for name, isEnabled in pairs(setCores) do
			SG:SetCore(name, isEnabled)
		end
		for _, gui in pairs(C.PlayerGui:GetChildren()) do
			if gui:IsA("ScreenGui") then
				C.ResetPartProperty(gui,"Enabled","Freecam")
			end
		end

		if cameraFieldOfView then
			C.Camera.FieldOfView = cameraFieldOfView
			cameraFieldOfView = nil	
		end
		if cameraType then
			C.Camera.CameraType = cameraType
			cameraType = nil
		end
		if cameraCFrame then
			C.Camera.CFrame = cameraCFrame
			cameraCFrame = nil
		end
		if cameraFocus then
			C.Camera.Focus = cameraFocus
			cameraFocus = nil
		end
		if mouseIconEnabled then
			UIS.MouseIconEnabled = mouseIconEnabled
			mouseIconEnabled = nil
		end
		if mouseBehavior then
			UIS.MouseBehavior = mouseBehavior
			mouseBehavior = nil	
		end
	end
end

return function(C_new,Settings)
	C = C_new
	return {
		Category = {
			Name = "World",
			Title = "World",
			Image = 15170258619,
			Layout = 4,
		},
		Tab = {
			{
				Title = "Fake Chat",
				Tooltip = "Display two messages in the chat",
				Layout = 1,Type = "NoToggle",
				Shortcut = "Nickname",
				Activate = function(self,newValue)
					local real = self.EnTbl.Real
                    local fake = self.EnTbl.Fake
                    if TCS.ChatVersion == Enum.ChatVersion.TextChatService then
                        fake = string.gsub(fake, "\n", "\r")
                        C.SendGeneralMessage(real..'\r'..fake)
                    elseif TCS.ChatVersion == Enum.ChatVersion.LegacyChatService then
                        C.SendGeneralMessage(real..string.sub((" "):rep(155),#real)..fake)
                    else
                        error("Unknown TCS ChatVersion For `Fake Chat`: "..tostring(TCS.ChatVersion))
                    end
				end,
                Events = {},
				Options = {
					{
						Type = Types.Textbox,
						Title = "Real",
						Tooltip = "What you say in the chat",
						Layout = 1,Default = ";admin all",Min=1,Max=100,
						Shortcut="Real",
					},
					{
						Type = Types.Textbox,
						Title = "Fake",
						Tooltip = "What is said a message below your chat",
						Layout = 2,Default = "{Team} You are now on the 'Admins' team.",Min=1,Max=100,
						Shortcut="Fake",
					}
				},
			},
            {
				Title = "Chat Spy",
				Tooltip = "Puts ALL whispers and team chat messages not visible to you into the chat!",
				Layout = 2,
				Shortcut = "ChatSpy",Default=true,
                AddToChat = function(self,theirPlr)
                    local DefaultChatSystemChatEvents = RS:WaitForChild("DefaultChatSystemChatEvents",10)
                    local Config = {public = false}
                    if not DefaultChatSystemChatEvents then
                        return
                    end
                    local getmsg = DefaultChatSystemChatEvents:WaitForChild("OnMessageDoneFiltering")
                    table.insert(self.Functs,theirPlr.Chatted:Connect(function(msg)
                        msg = msg:gsub("[\n\r]",''):gsub("\t",' '):gsub("[ ]+",' ') -- CLIP THE MESSAGE (important!)
						local setChannel,moveon,hidden = nil,false,true
						local conn = getmsg.OnClientEvent:Connect(function(packet,channel)
							if (packet.Message==msg:sub(#msg-#packet.Message+1) and (channel=="All") and packet.SpeakerUserId==theirPlr.UserId)
								or (channel=="Team" and Config.public==false and PS[packet.FromSpeaker].Team==C.plr.Team) then
								hidden = false
							end
                            setChannel,moveon = channel or packet.OriginalChannel, true
						end)
                        task.delay(C.plr:GetNetworkPing()*3,function()
                            moveon=true
                        end)
                        while not moveon do
                            RunS.RenderStepped:Wait()
                        end
						conn:Disconnect()
						if hidden then
							C.CreateSysMessage("["..theirPlr.Name.."]: "..msg,Color3.fromRGB(0,175),`{setChannel or "Chat"} Spy`)
                            if self.EnTbl.Echo then
                                C.SendGeneralMessage("["..theirPlr.Name.."]: "..msg)
                            end
						end
                    end))
                end,
				Activate = function(self,newValue)
                    if not newValue then return end
					for num, theirPlr in ipairs(PS:GetPlayers()) do
                        if theirPlr ~= C.plr then
                            self:AddToChat(theirPlr)
                        end
                    end
				end,
                Events = {
                    OthersPlayerAdded=function(self,theirPlr,firstRun)
                        if not self.RealEnabled or firstRun then return end
						self:AddToChat(theirPlr)
					end,
                },Functs={},
				Options = {
                    {
						Type = Types.Toggle,
						Title = "Echo",
						Tooltip = "What is said privately in the chat you repeat (using the chat function)",
						Layout = 2,Default = false,
						Shortcut="Echo",
					}
				},
			},
			FireElements={
				Title = "Fire",Type="NoToggle",
				Tooltip = "Fires TouchInterest, ProximityPrompt, ClickDetector",
				Layout = 3,NoStudio=true,
				Shortcut = "FireElements",Threads={},
				CheckForBlacklist = function(self,instance)
					if game.GameId == 2733031763 and instance.Parent.Name == "Floor" then
						return true
					end
					return false
				end,
				GetSearchInstance = function(self)
					if game.GameId == 2733031763 then
						return C.StringWait(workspace,"Bridge")
					end
					return workspace
				end,
				TouchTransmitter = function(self,instance)
					local Parent = instance.Parent
					if C.hrp then
						C.firetouchinterest(C.hrp,Parent)
					end
				end,
				ClickDetector = function(self,instance)
					C.fireclickdetector(instance,C.Randomizer:NextNumber(2,3),"MouseClick")
				end,
				ProximityPrompt = function(self,instance)
					C.fireproximityprompt(instance,1,true)
				end,
				Activate = function(self,newValue)
					local EnTbl = self.EnTbl
                    for num, instance in ipairs(self:GetSearchInstance():GetDescendants()) do
						for name, en in pairs(EnTbl) do
							if instance:IsA(name) and en and not self:CheckForBlacklist(instance) then
								self[name](self,instance)
							end
						end
						if num%100 == 0 then
							RunS.RenderStepped:Wait()
						end
					end
				end,
				Options = {
                    {
						Type = Types.Toggle,
						Title = "TouchInterest",
						Tooltip = "Fire TouchInterests with your character's rootpart",
						Layout = 1,Default = true,
						Shortcut="TouchTransmitter",
					},
					{
						Type = Types.Toggle,
						Title = "ProximityPrompt",
						Tooltip = "Fires all ProximityPrompts exactly once",
						Layout = 2,Default = false,
						Shortcut="ProximityPrompt",
					},
					{
						Type = Types.Toggle,
						Title = "ClickDetector",
						Tooltip = "Clicks on all ClickDetectors at the same time",
						Layout = 3,Default = false,
						Shortcut="ClickDetector",
					}
				},
			},
			{
				Title = "Chat",
				Tooltip = "Chat modifications are listed here",
				Layout = 3,
				Shortcut = "ChatEdit",
				FontTranslations = {
					["Fancy Unicode Font 1"] = {Input = `ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.,:;'"!?-_/+*=()%@#$&^~`,
						Output = {`卂`,`乃`,`匚`,`ᗪ`,`乇`,`千`,`Ꮆ`,`卄`,`丨`,`ﾌ`,`Ҝ`,`ㄥ`,`爪`,`几`,`ㄖ`,`卩`,`Ɋ`,`尺`,`丂`,`ㄒ`,`ㄩ`,`ᐯ`,`山`,`乂`,`ㄚ`,`乙`,`卂`,`乃`,`匚`,`ᗪ`,`乇`,`千`,`Ꮆ`,`卄`,`丨`,`ﾌ`,`Ҝ`,`ㄥ`,`爪`,`几`,`ㄖ`,`卩`,`Ɋ`,`尺`,`丂`,`ㄒ`,`ㄩ`,`ᐯ`,`山`,`乂`,`ㄚ`,`乙`,`0`,`1`,`2`,`3`,`4`,`5`,`6`,`7`,`8`,`9`,`.`,`,`,`:`,`;`,`'`,`"`,`!`,`?`,`-`,`_`,`/`,`+`,`*`,`=`,`(`,`)`,`%`,`@`,`#`,`$`,`&`,`^`,`~`}},
				},
				Activate = function(self,newValue)
					local find, sub, isa = string.find, string.sub, workspace.IsA
					local gsub, tskSpawn = string.gsub, task.spawn
					local TranslationTbl = self.FontTranslations[self.EnTbl.ChosenFont]
					local MultiLine = self.EnTbl.MultiLine
					assert(TranslationTbl or self.EnTbl.ChosenFont == "Off", `Chat Bypass Translation Doesn't Contain Proper Font: {self.EnTbl.ChosenFont}`)
					local gmatch = string.gmatch
					local Input, Output = TranslationTbl.Input, TranslationTbl.Output
					C.HookMethod("__namecall",self.Shortcut,newValue and function(newSc,method,self,message,channel)
                        if tostring(self) == "SayMessageRequest" or isa(self,"TextChannel") then
							if MultiLine then
								message = gsub(message,"\\n",MultiLine)
							end
							if TranslationTbl then
								local newMessage = ""
								for character in gmatch(message,".") do
									local foundIndex = find(Input,character,1,true)
									if foundIndex then
										newMessage ..= rawget(Output,foundIndex)
									else
										newMessage ..= character
									end
								end
								message = newMessage
							end
							return "Override", {self, message, channel}
						end
                    end,{"fireserver","sendasync"})
				end,
				Options = {
					{
						Type = Types.Dropdown,
						Selections = {"Off","Fancy Unicode Font 1"},
						Title = "Font Bypass",
						Tooltip = "Replaces your text with fancy custom font, which bypasses filter!",
						Layout = 1,Default = 2,
						Shortcut="ChosenFont",
						Activate = C.ReloadHack,
					},
					{
						Type = Types.Textbox,
						Title = "Multi Line",
						Tooltip = `Whenever a \n is present, it is automatically replaced with a newline followed by this text!`,
						Layout = 1,Default = "{System}: ",Min=1,Max=50,
						Shortcut="MultiLine",
						Activate = C.ReloadHack,
					},
				},
			},
			{
				Title = "Freecam",
				Tooltip = "Allows your camera to fly around",
				Layout = 4,
				Shortcut = "Freecam",Threads={},
				RunOnDestroy = function(self)
					self:Activate(false)
				end,
				Activate = function(self,newValue)
					FREECAM_SETTINGS = self.EnTbl
					if newValue then
						self:Activate(false) -- Disable it to re-enable!
						task.wait()
						local cameraCFrame = C.Camera.CFrame
						cameraRot = Vector2.new(cameraCFrame:toEulerAnglesYXZ())
						cameraPos = cameraCFrame.Position
						cameraFov = C.Camera.FieldOfView
					
						velSpring:Reset(Vector3.new())
						panSpring:Reset(Vector2.new())
						fovSpring:Reset(0)
						
	
						PlayerState.Push()
						RunS:BindToRenderStep("Freecam", Enum.RenderPriority.Camera.Value, StepFreecam)
						Input.StartCapture()
					else
						Input.StopCapture()
						RunS:UnbindFromRenderStep("Freecam")
						PlayerState.Pop()
					end
				end,
				Options = {
					{
						Type = Types.Slider,
						Title = "Speed Mult",
						Tooltip = "How fast you move",
						Layout = 1,Default = 1,
						Min = 0, Max=5, Digits=1,
						Shortcut="SpeedMult",
					},
                    {
						Type = Types.Slider,
						Title = "Turn Mult",
						Tooltip = "How fast you turn",
						Layout = 2,Default = 1,
						Min = 0, Max=5, Digits=1,
						Shortcut="TurnMult",
					},
					{
						Type = Types.Slider,
						Title = "Zoom Mult",
						Tooltip = "How fast you zoom in/out",
						Layout = 3,Default = 1,
						Min = 0, Max=5, Digits=1,
						Shortcut="ZoomMult",
					},
					{
						Type = Types.Toggle,
						Title = "Hide Core UI",
						Tooltip = "Whether or not Core UI is hidden or not",
						Layout = 4,Default = true,
						Shortcut="HideCoreUI",
						Activate = C.ReloadHack,
					},
				},
			},
		}
	}
end