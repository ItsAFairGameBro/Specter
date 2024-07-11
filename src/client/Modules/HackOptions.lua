local TS = game:GetService("TweenService")
local CS = game:GetService("CollectionService")
local PS = game:GetService("Players")
local RunS = game:GetService("RunService")
return function(C,Settings)
	C.UI.Options = {}
	C.UI.DisableDrag = false
	
	local ToggleTbl,SliderTbl, DropdownTbl, UserListTbl, TextboxTbl = {}, {}, {}, {}, {}
	C.UI.Options.Toggle = ToggleTbl
	C.UI.Options.Slider = SliderTbl
	C.UI.Options.Dropdown = DropdownTbl
	C.UI.Options.UserList = UserListTbl
	C.UI.Options.Textbox = TextboxTbl
		
	local function DoCombined(tbl,name,parent,options)
		assert(options.Title,"Title is missing")
		local newFrame = C.Examples[name .. "Ex"]:Clone()
		local self = setmetatable(options, { __index = tbl })
		self.Frame = newFrame
		--self.Options = options
		--self.Parent = options.Parent
		
		self.CategoryName = self.Parent.Parent.Category.Name
		self.ParentShortcut = self.Parent.Shortcut
		assert(self.Shortcut,`{tbl.Title} doesn't have a Shortcut`)
		assert(self.Shortcut~="Keybind",`{self.Shortcut} is a restricted internal option name!`)
		assert(self.CategoryName,`{tbl.Title} doesn't have a category`)
		assert(self.ParentShortcut,`{tbl.Title} doesn't have a PARENT category for {parent.Name}`)
		self.EnHackTbl = C.enHacks[self.CategoryName][self.ParentShortcut]
		assert(self.EnHackTbl,`{self.ParentShortcut} doesn't have a table or smt`)
		local Default 
		if self.EnHackTbl[self.Shortcut] ~= nil then
			Default = self.EnHackTbl[self.Shortcut]
		else
			Default = self.Default
		end
		newFrame.LayoutOrder = options.Layout
		newFrame:WaitForChild("NameTL").Text = options.Title
		if options.Tooltip then
			C.TooltipSetUp(newFrame:WaitForChild("NameTL"),options.Tooltip)
		end
		newFrame.Parent = parent:WaitForChild("OptionsList")
		return self, newFrame, Default
	end
	
	local function SetValueCombined(self,firstRun)
		self.EnHackTbl[self.Shortcut] = self.Value
		if not firstRun then
			if self.EnHackTbl.En and self.Activate then
				self.Activate(self.Parent,self,self.Value)
			end
		end
	end

	function ToggleTbl.new(parent,options)
		local self, newFrame, default = DoCombined(ToggleTbl,"Toggle",parent,options)
		self.Slider = newFrame:WaitForChild("ToggleSwitchSlider")
		self.Circle = self.Slider:WaitForChild("ToggleCircle")
		C.ButtonClick(self.Slider,function()
			self:Toggle()
		end)
		self:SetValue(default,true,true)
	end
	function ToggleTbl:Toggle(instant)
		self:SetValue(not self.Value, instant)
	end
	function ToggleTbl:SetValue(new,instant,firstRun)
		local tweenInfo = TweenInfo.new(instant and 0 or 0.2)
		if new then
			TS:Create(self.Circle, tweenInfo, {Position = UDim2.fromScale(0.604,.5)}):Play()
			TS:Create(self.Slider, tweenInfo, {BackgroundColor3 = Color3.fromRGB(0, 115, 255)}):Play()	
		else
			TS:Create(self.Circle, tweenInfo, {Position = UDim2.fromScale(0.05,.5)}):Play()
			TS:Create(self.Slider, tweenInfo, {BackgroundColor3 = Color3.fromRGB(113, 113, 113)}):Play()	
		end
		self.Value = new
		SetValueCombined(self,firstRun)
	end
	
	function SliderTbl.new(parent, options)
		assert(options.Min,"Min is missing")
		assert(options.Max,"Max is missing")
		assert(options.Default,"Default is missing")
		
		local self, newFrame, default = DoCombined(SliderTbl, "Slider", parent, options)

		self.Min = options.Min
		self.Max = options.Max
		self.Digits = options.Digits or 0
		self.Step = 1 * 10^-options.Digits
		if self.Step==0 then
			self.Step = 1
		end

		self.Slider = newFrame:WaitForChild("SlidingBar")
		self.CurrentPosition = self.Slider:WaitForChild("CurrentPosition")
		self.Backing = self.Slider:WaitForChild("Backing")
		self.ForceTB = newFrame:WaitForChild("ForceTB")
		self.Track = self.Slider:WaitForChild("Track")
		
		newFrame:WaitForChild("RightBound").Text = self.Max
		newFrame:WaitForChild("LeftBound").Text = self.Min

		self.ForceTB.FocusLost:Connect(function(enterPressed)
			RunS.RenderStepped:Wait()
			local value = tonumber(self.ForceTB.Text)
			if value then
				self:CheckSetValue(value, false)
			end
		end)

		self.Backing.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				self.Dragging = true
				C.UI.DisableDrag = true
				self:SetValueFromSlider(input)
			end
		end)

		self.Backing.InputChanged:Connect(function(input)
			if self.Dragging then
				self:SetValueFromSlider(input)
			end
		end)

		self.Backing.InputEnded:Connect(function(input)
			if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
				self.Dragging = false
				C.UI.DisableDrag = false
			end
		end)

		self:SetValue(default,true,true)

		return self
	end
	
	function SliderTbl:SetValueFromSlider(input)
		local percentage = (input.Position.X - self.Track.AbsolutePosition.X) / self.Track.AbsoluteSize.X
		local value = percentage * (self.Max - self.Min) + self.Min
		self:SetValue(self:FormatValue(value))
	end
	
	function SliderTbl:FormatValue(value)
		local setValue = math.round(value/self.Step)*self.Step
		setValue = math.clamp(setValue,self.Min,self.Max)
		return setValue
	end
	
	function SliderTbl:CheckSetValue(new,instant)
		new = tonumber(new)
		if new then
			self:SetValue(self:FormatValue(new),instant)
		else
			self:SetValue(self.Value,instant)
		end
	end
	
	function SliderTbl:SetValue(new,instant,firstRun)
		local tweenInfo = TweenInfo.new(instant and 0 or .1)
		local percentageComplete = (new-self.Min)/(self.Max-self.Min)
		local placementX = percentageComplete * (1-(.5 * self.CurrentPosition.AbsoluteSize.X/self.Track.AbsoluteSize.X))
		if placementX ~= placementX then
			placementX = percentageComplete
		end
		--(percentageComplete * widthToUse) + (.5 * (1 - widthToUse))
		TS:Create(self.CurrentPosition,tweenInfo,{Position = UDim2.fromScale(placementX,.5)}):Play()
		self.ForceTB.Text = ("%."..self.Digits.."f"):format(new)
		self.Value = new
		SetValueCombined(self,firstRun)
	end
	
	local DropdownFunct = nil
	local DropdownCurrent = nil

	function DropdownTbl.new(parent, options)
		assert(options.Selections,"Selections is missing")
		assert(table.find(options.Selections,options.Default),"Default Selection is Missing")

		local self, newFrame, default = DoCombined(DropdownTbl, "Dropdown", parent, options)
		
		self.SelectionsFrame = newFrame
		self.DropdownButton = newFrame:WaitForChild("DropdownButton")
		
		self.Dropdown = C.UI.DropdownFrame
		local DropdownEx = C.Examples.DropdownButtonEx
		
		self.DropdownVisible = false
		
		local function ToggleDropdown()
			if DropdownCurrent then
				if DropdownCurrent ~= self then
					DropdownCurrent.DropdownVisible = false
				end
				DropdownCurrent = nil
			end
			if DropdownFunct then
				C.RemoveGlobalConnection(DropdownFunct)
				DropdownFunct = nil
				DropdownCurrent = nil
			end
			for num, button in ipairs(self.Dropdown:GetChildren()) do
				if button:IsA("TextButton") then
					button:Destroy()
				end
			end
			self.DropdownVisible = not self.DropdownVisible
			if self.DropdownVisible then
				DropdownCurrent = self
				for num, name in ipairs(self.Selections) do
					if name ~= self.Value then
						local newDropdownEx = DropdownEx:Clone()
						newDropdownEx.Text = name
						newDropdownEx.Parent = self.Dropdown
						newDropdownEx.Position = UDim2.fromScale(0,newDropdownEx.AbsoluteSize.Y*(num-1))
						newDropdownEx.Parent = self.Dropdown
						C.ButtonClick(newDropdownEx,function()
							ToggleDropdown()
							self:SetValue(name)
						end)
					end
				end
				local function UpdLoc()
					if self.DropdownButton.AbsolutePosition.Y + self.Dropdown.AbsoluteSize.Y + self.DropdownButton.AbsoluteSize.Y 
						< C.GUI.AbsoluteSize.Y then
						self.Dropdown.Position = UDim2.fromOffset(self.DropdownButton.AbsolutePosition.X,
							self.DropdownButton.AbsolutePosition.Y + self.DropdownButton.AbsoluteSize.Y + self.Dropdown.AbsoluteSize.Y)
					else
						self.Dropdown.Position = UDim2.fromOffset(self.DropdownButton.AbsolutePosition.X,
							self.DropdownButton.AbsolutePosition.Y)
					end
				end
				DropdownFunct = C.AddGlobalConnection(RunS.RenderStepped:Connect(UpdLoc))
				UpdLoc()
				self.Dropdown.AnchorPoint = Vector2.new(0, 1)
			end
			self.Dropdown.Visible = self.DropdownVisible
		end
		
		C.ButtonClick(self.DropdownButton,ToggleDropdown)

		self:SetValue(default,true,true)

		return self
	end

	function DropdownTbl:SetValue(new,instant,firstRun)
		self.DropdownButton.Text = new
		self.Value = new
		SetValueCombined(self,firstRun)
	end
	
	function UserListTbl.new(parent,options)
		assert(options.Limit,`{options.Title} doesn't have Limits`)
		local self, newFrame, default = DoCombined(UserListTbl,"UserList",parent,options)
		self.Limit = options.Limit
		self.MainList = newFrame:WaitForChild("MainList")
		self.EnterTB = newFrame:WaitForChild("EnterTB")
		self.AddButton = newFrame:WaitForChild("AddButton")
		self.LimitTL = newFrame:WaitForChild("LimitTL")
		local function AddedButton()
			if #self.Value >= self.Limit then
				C.AddNotification("Maxed","You have the maximum number in the list!")
				return
			elseif self.EnterTB.Text:len() < 3 then
				C.AddNotification("Unavailable","You have entered an invalid username/id!")
				return
			end
			C.TblAdd(self.Value,self.EnterTB.Text)
			self:SetValue(self.Value)
			self.EnterTB.Text = ""
		end
		C.ButtonClick(self.AddButton,AddedButton)
		self.EnterTB.FocusLost:Connect(function(enterPressed)
			if enterPressed then
				AddedButton()
			end
		end)
		self:SetValue(default,true,true)
	end
	function UserListTbl:SetValue(new,instant,firstRun)
		local newList = {}
		C.ClearChildren(self.MainList)
		for num, identification in ipairs(new) do
			local success, user, id = C.GetUserNameAndId(identification)
			if not success then
				continue
			elseif id == C.plr.UserId then
				C.AddNotification("Unavailable","You cannot add yourself as a friend")
				continue
			end
			local OneListEx = C.Examples.OneListEx:Clone()
			OneListEx.Name = id
			OneListEx:WaitForChild("UserTL").Text = user
			C.ButtonClick(OneListEx:WaitForChild("DeleteButton"),function()
				C.TblRemove(self.Value,id)
				self:SetValue(self.Value)
			end)
			OneListEx.Parent = self.MainList
			table.insert(newList,id)
		end
		if #newList ~= #new then
			C.AddNotification("Friend Loading Failed", "Some friends have failed to render!")
		end
		self.LimitTL.Text = `{#newList}/{self.Limit}`
		self.Value = newList
		SetValueCombined(self,firstRun)
	end


	function TextboxTbl.new(parent, options)
		assert(options.Min,"Min is missing")
		assert(options.Max,"Max is missing")
		assert(options.Default,"Default is missing")
		
		local self, newFrame, default = DoCombined(TextboxTbl, "Textbox", parent, options)

		self.Min = options.Min
		self.Max = options.Max

		self.LimitTL = newFrame:WaitForChild("LimitTL")
		self.SetTB = newFrame:WaitForChild("SetTB")

		self.LimitTL.Text = `{self.Min}-{self.Max}`

		self.SetTB.FocusLost:Connect(function(enterPressed)
			RunS.RenderStepped:Wait()
			self:SetValue(self.SetTB.Text, false)
		end)

		C.ButtonClick(newFrame:WaitForChild("EnterButton"),function()
			self:SetValue(self.SetTB.Text)
		end)

		self:SetValue(default,true,true)

		return self
	end
		
	function TextboxTbl:SetValue(new,instant,firstRun)
		if new:len() > self.Max then
			new = new:sub(1,self.Max)
		elseif new:len() < self.Min then
			new = new .. string.rep("E",self.Min - new:len())
		end
		self.SetTB.Text = new
		self.Value = new
		SetValueCombined(self,firstRun)
	end

	
	
	for identity, tbl in pairs(C.UI.Options) do
		-- Define the __call metamethod
		--[[setmetatable(tbl, {
			__call = function(tbl, ...)
				return tbl.new(...)
			end
		})--]]
	end
	
	
end
