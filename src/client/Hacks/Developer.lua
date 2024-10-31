local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",Textbox="Textbox",UserList="UserList"}
local RunService = game:GetService("RunService")
local SocialService = game:GetService("SocialService")
local SG = game:GetService("StarterGui")
local CG = game:GetService("CoreGui")
local RS = game:GetService("ReplicatedStorage")
local PhysicsS = game:GetService"PhysicsService"
local LS = game:GetService("LogService")
local UIS = game:GetService("UserInputService")
local AS = game:GetService("AssetService")

return function(C,Settings)
    return {
		Category = {
			Name = "Developer",
			Title = "Developer",
			Image = 11860859170,
			Layout = 8,
            AfterMisc = true,
		},
		Tab = {
            {
				Title = "Clear Logs",
				Tooltip = "Clears the console's logs",
				Layout = 0,Type="NoToggle",
				Shortcut = "ClearLogs",
				Activate = function(self,newValue)
                    C.getgenv().LogCutoffTimeStamp = #LS:GetLogHistory()
                    local ScrollList = C.StringWait(CG,"DevConsoleMaster.DevConsoleWindow.DevConsoleUI.MainView.ClientLog", math.huge)
                    if ScrollList then
                        C.ClearChildren(ScrollList, C.getgenv().LogCutoffTimeStamp)
                    end
                    
                    --C.getgenv().LogCutoffTimeStamp = os.time() + 1
                    --local tblInsert = table.insert
                    --local tskSpawn = task.spawn
					--local Old
                    --Old = C.HookMethod("__namecall",self.Shortcut, function(newSc,method,self)
                    --    tskSpawn(print, "yooo")
                    --    if (self == LS) then
                    --        local LatestTimeStamp = rawget(rawget(C, "getgenv"), "LogCutoffTimeStamp")
                    --        local Results = Old(self)
                    --        local Returns = {}
                    --        for num, item in ipairs(Results) do
                    --            if (rawget(item, 'timestamp') > LatestTimeStamp) then
                    --                tblInsert(Returns, item)
                    --            end
                    --        end
                    --        return "Override", {Returns}
                    --    end
                    --end,{"getloghistory","getlogHistory"})
				end,
				Options = {

				}
			},
			{
				Title = "OpenConsole",
				Tooltip = "Opens Developers Console",
				Layout = 1,Type="NoToggle",Keybind=Enum.KeyCode.F1.Name,
				Shortcut = "DevelopersConsole",
                Threads = {},
                ForceScrollToBottom = function(self)
                    local ScrollList = C.StringWait(CG,"DevConsoleMaster.DevConsoleWindow.DevConsoleUI.MainView.ClientLog")
                    local timeLeft = 1
                    repeat
                        if not ScrollList.Parent then
                            break
                        end
                        ScrollList.CanvasPosition = Vector2.new(0, 9999999)
                        timeLeft -= RunService.RenderStepped:Wait()
                    until timeLeft <= 0
                end,
				Activate = function(self,newValue)
					SG:SetCore("DevConsoleVisible", not SG:GetCore("DevConsoleVisible"))
                    self:ForceScrollToBottom()
				end,
				Options = {

				}
			},
            {
				Title = "Collisions Groups",
				Tooltip = "Prints Collisions Groups To Console",
				Layout = 3,Type="NoToggle",
				Shortcut = "CollisionGroups",
				Activate = function(self,newValue)
                    local CollisionGroups = PhysicsS:GetRegisteredCollisionGroups()
                    for key, val in ipairs(CollisionGroups) do
                        print(val.name.." (id=" .. key ..") collides:")
                        for num, val2 in pairs(CollisionGroups) do
                            print("\t"..val2.name,PhysicsS:CollisionGroupsAreCollidable(val2.name,val.name),"\n")
                        end
                    end
				end,
				Options = {

				}
			},
            {
				Title = "Teleport Detection",
				Tooltip = "Prints whenever any parts of your character are teleported!",
				Layout = 4,
				Shortcut = "TeleportDetection",
                WhitelistedNames={"UpperTorso", "Torso", "Head", "Head", "HumanoidRootPart"} ,
				Activate = function(self,newValue)
                    if not newValue or not C.char then return end
                    for num, instance in ipairs(C.char and C.char:GetChildren() or {}) do
                        if instance:IsA("BasePart") or table.find(self.WhitelistedNames,instance.Name) then
                            table.insert(self.Functs,instance:GetPropertyChangedSignal("CFrame"):Connect(function()
                                print(instance:GetFullName():gsub(C.char:GetFullName(),"Char") .. " Teleported!")
                            end))
                        end
                    end
				end,
                Functs={},
				Events = {
                    MyCharAdded=function(self,theirPlr,theirChar,firstRun)
						C.DoActivate(self,self.Activate,self.RealEnabled)
					end,
				}
			},
            {
				Title = "Attribute Scan",
				Tooltip = "Searches through nearly everything in the game for hidden attributes to edit!",
				Layout = 2,Type="NoToggle",
				Shortcut = "AttributeScanner",
				Activate = function(self,newValue)
                    local ignoreParents = {[game.CoreGui]=true}
                    local ignoreList = {["OrgColor"]=true,["OrgTrans"]=true,['wallclip']=true,['HackGUI1']=true,["LastTP"]=true,
                        ["OriginalCollide"]=true,["OrgSize"]=true,["WeirdCanCollide"]=true,["Opened"]=true,["SaveVolume"]=true,['ClearedHackGUI1']=true,
						["RealFuel"]=true}
					local ignoreRegex = {"[%a%d]+_OriginalValue","[%a%d]+_Request_","[%a%d]+_RequestCount"}
                    local function printAtt(obj)
                        for _,instance in ipairs(ignoreList) do
                            if instance:IsAncestorOf(obj) then
                                return
                            end
                        end
                        local printStr
                        for attribute, val in pairs(obj:GetAttributes()) do
							local hasRegex = false
							for num, val in ipairs(ignoreRegex) do
								if attribute:gmatch(val)() then
									hasRegex = true
									break
								end
							end
                            if not ignoreList[attribute] and not hasRegex then
                                if not printStr then
                                    printStr = "\tOBJ ["..obj:GetFullName().."]:"
                                end
                                printStr..="\n\t\t"..attribute.."="..tostring(val) .. " (" .. typeof(val) .. ")"
                            end
                        end
                        if printStr then
                            print(printStr)
                        end
                    end
                    local function loop(obj,instsScanned)
                        instsScanned = (instsScanned or 0) + 1
                        printAtt(obj)
                        if ignoreParents[obj] then
                            return -- don't go through ignoreparents!
                        end
                        for num, instance in ipairs(obj:GetChildren()) do
                            instsScanned = loop(instance,instsScanned)
                            if num%40==0 then
                                game["Run Service"].RenderStepped:Wait()
                            end
                        end
                        return instsScanned
                    end
                    local start = os.clock()

                    warn("[Attribute Search] Search Beggining...")

                    local Count = C.comma_value(loop(game))

                    warn(("[Attribute Search] Search Finished! Loop through %s instances in %.2f seconds!"):format(Count,os.clock()-start))
				end,
				Options = {

				}
			},
            {
				Title = "Print Remote Event Spy",
				Tooltip = "Prints all messages from remote events to the console.",
				Layout = 2,Functs={},
				Shortcut = "PrintRemoteSpy",
                IgnoreList = {[88070565] --[[BLOXBURG]] = {"FloorPos","LookDir","GetServerTime","CheckOwnsAsset","GetIKTargets","FirstPlayerExperience_IsFirstTime"}},
                Activate = function(self,newValue)
                    if newValue and self.EnTbl.Inbound then
                        for num, event in ipairs(C.getinstances()) do
                            if event:IsA("RemoteEvent") then
                                table.insert(self.Functs,event.OnClientEvent:Connect(function(...)
                                    local RemoteNames = rawget(C,"RemoteNames")
                                    local MyRemoteName = RemoteNames and rawget(RemoteNames,event) or event:GetFullName()
                                    print(`[Inbound Remote Spy]: {MyRemoteName}`,...)
                                end))
                            end
                        end
                    end
                    local IgnoreList = self.IgnoreList[game.GameId] or {}
                    local TblFind = C.TblFind
                    C.HookMethod("__namecall",self.Shortcut,newValue and self.EnTbl.Outbound and function(theirScript,method,self,...)
                        local RemoteNames = rawget(C,"RemoteNames") or {}
                        local MyRemoteName = rawget(RemoteNames,self) or self.Name
                        if not TblFind(IgnoreList,MyRemoteName) then
                            task.spawn(print,`[Outbound Remote Spy]: "{theirScript}" on {MyRemoteName}:{method}() w/ path {debug.traceback()}; args`,...)
                        end
                        --require(game:GetService("Players").SuitedForBans12.PlayerScripts.Modules.CharacterHandler)["_attachedEvent"].Event:Connect(function(...) warn("attach",...) end) warn("Hook")
                    end,{"fireserver","invokeserver"})
                end,
                Options = {
                    {
						Type = Types.Toggle,
						Title = "Inbound",
						Tooltip = "Tracks all requests coming TO the client (RemoteEvents)! Warning: DOES NOT TRACK REMOTE FUNCTIONS",
						Layout = 1,Default=true,
						Shortcut="Inbound",
                        Activate = C.ReloadHack,
					},
                    {
						Type = Types.Toggle,
						Title = "Outbound",
						Tooltip = "Tracks all requests going TO the server (RemoteEvents/RemoteFunctions)!",
						Layout = 2,Default=true,
						Shortcut="Outbound",
                        Activate = C.ReloadHack,
					},
                },
            },
            {
				Title = "Find Game Scripts",
				Tooltip = "Finds all the scripts in Player object and character",
				Layout = 6,Type="NoToggle",
				Shortcut = "FindAllScripts",
				Activate = function(self,newValue)
                    local ignoreParents = {[game.CoreGui]=true}
                    local ignoreList = {["OrgColor"]=true,["OrgTrans"]=true,['wallclip']=true,['HackGUI1']=true,["LastTP"]=true,
                        ["OriginalCollide"]=true,["OrgSize"]=true,["WeirdCanCollide"]=true,["Opened"]=true,["SaveVolume"]=true,['ClearedHackGUI1']=true,
						["RealFuel"]=true}
					local ignoreRegex = {"[%a%d]+_OriginalValue","[%a%d]+_Request_","[%a%d]+_RequestCount"}
                    local function printScr(obj)
                        if obj and (obj:IsA("LocalScript") or (obj.ClassName == "Script" and obj.RunContext == Enum.RunContext.Client)) then
							print(`[OBJ {obj.Parent:GetFullName()}]: {obj.Name}, {obj.Enabled}`)
						end
                    end
                    local function loop(obj,instsScanned)
                        instsScanned = (instsScanned or 0) + 1
                        if not obj then
                            return instsScanned
                        end
                        printScr(obj)
                        if ignoreParents[obj] then
                            return -- don't go through ignoreparents!
                        end
                        for num, instance in ipairs(obj:GetChildren()) do
                            instsScanned = loop(instance,instsScanned)
                            if num%40==0 then
                                game["Run Service"].RenderStepped:Wait()
                            end
                        end
                        return instsScanned
                    end
                    local start = os.clock()

                    warn("[Script Search] Search Beggining...")

                    local Count = C.comma_value(loop(game))

                    warn(("[Script Search] Search Finished! Loop through %s instances in %.2f seconds!"):format(Count,os.clock()-start))
				end,
				Options = {

				}
			},
            {
				Title = "Find Nil Scripts",
				Tooltip = "Finds scripts parented to nil",
				Layout = 5,Type="NoToggle",
				Shortcut = "FindNilScripts",
				Activate = function(self,newValue)
                    pcall(function()
                        for num, scr in ipairs(C.getrunningscripts()) do
                            if scr.Parent == workspace or scr.Parent == nil then
                                print(scr)
                            end
                        end
                    end)
				end,
				Options = {

				}
			},

            {
                Title = "Get Place Ids",Type="NoToggle",
                Tooltip = "Prints place ids for the current game",
                Layout=6,
                Shortcut = "GetPlaceIds",
                Activate = function(self,newValue)

                    local placePages = AS:GetGamePlacesAsync()

                    while true do
                        for _, place in placePages:GetCurrentPage() do
                            print({
                                Name = place.Name,
                                PlaceId=place.PlaceId
                            })
                        end
                        if placePages.IsFinished then
                            break
                        end
                        placePages:AdvanceToNextPageAsync()
                    end
                end
            },
            {
				Title = "Check Events",
				Tooltip = "Prints events in a table format to the console",
				Layout = 7,Type="NoToggle",NoStudio = true,
				Shortcut = "CheckEvents",
                EventsToCheck = {
                    [UIS] = {
                        --[["TouchEnded",
                        "TouchLongPress",
                        "TouchMoved",
                        "TouchPan",
                        "TouchPinch",
                        "TouchRotate",
                        "TouchStarted",
                        "TouchSwipe",--]]
                        "TouchTap",
                        "TouchTapInWorld"
                    }
                },
				Activate = function(self,newValue)
                    local tbl = {}
                    for instance, connections in pairs(self.EventsToCheck) do
                        local curTbl1 = {}
                        for num, connName in ipairs(connections) do
                            local curTbl2 = {}
                            for num2, connection in ipairs(C.getconnections(instance[connName])) do
                                table.insert(curTbl2, {imhere=true,
                                    --Enabled=connection.Enabled,
                                    --ForeignState=connection.ForeignState,
                                    --LuaConnection=connection.LuaConnection,
                                })
                            end
                            curTbl1[connName] = curTbl2
                        end
                        tbl[instance] = curTbl1
                    end
                    print("Client Connections:",tbl)
				end,
			},
            {
				Title = "Get GameID",
				Tooltip = "Sets the GameID to clipboard",
				Layout = 10,Type="NoToggle",NoStudio = true,
				Shortcut = "SetGameToClipBoard",
				Activate = function(self,newValue)
                    C.setclipboard(game.GameId)
				end,
			},
            C.Executor == "Cryptic" and {
				Title = "Improve GUI",
				Tooltip = "Improves the UI, which supports:\nCryptic",
				Layout = 30, Default = true,
				Shortcut = "ImproveGUI", Instances = {},
				Activate = function(self,newValue,firstRun)
                    if C.Executor == "Cryptic" then
                        local MainFrame = CG:FindFirstChild("MainShell",true).MainFrame

                        local ConsoleTab = C.StringWait(MainFrame,"Console Tab")
                        local ScrollingFrame = ConsoleTab:WaitForChild("ScrollingFrame")
                        local UIListLayout = ScrollingFrame:WaitForChild("UIListLayout")

                        C.SetPartProperty(UIListLayout,"Padding",self.Shortcut,newValue and UDim.new(0,0) or C)

                        if not newValue then return end

                        local ClearButton = Instance.new("TextButton",ConsoleTab)
                        ClearButton.Name = "ClearButton"
                        ClearButton.Text = "Clear"
                        ClearButton.TextScaled = true
                        ClearButton.Size = UDim2.fromScale(.1,.1)
                        ClearButton.Position = UDim2.fromScale(0.1,0)
                        ClearButton.AnchorPoint = Vector2.new(0,1)
                        ClearButton.ZIndex = 99999

                        table.insert(self.Instances, ClearButton)
                        C.ButtonClick(ClearButton,function()
                            C.ClearChildren(ScrollingFrame)
                            ScrollingFrame.CanvasSize = UDim2.new()
                            ScrollingFrame.CanvasPosition = Vector2.new(0,0)
                        end)
                    else
                        --"not doing anything lol"
                        error(`Unknown Improvement Executor`)
                    end
				end,
				Options = {

				}
			},
		}
	}
end
