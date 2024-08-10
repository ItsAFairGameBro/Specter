local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",Textbox="Textbox",UserList="UserList"}
local SG = game:GetService("StarterGui")
local RS = game:GetService("ReplicatedStorage")
local PhysicsS = game:GetService"PhysicsService"
local UIS = game:GetService("UserInputService")
local AS = game:GetService("AssetService")
return function(C,Settings)
	return {
		Category = {
			Name = "Developer",
			Title = "Developer",
			Image = 11860859170,
			Layout = 50,
            AfterMisc = true,
		},
		Tab = {
			{
				Title = "OpenConsole",
				Tooltip = "Opens Developers Console",
				Layout = 1,Type="NoToggle",Keybind=Enum.KeyCode.F1.Name,
				Shortcut = "DevelopersConsole",
				Activate = function(self,newValue)
					SG:SetCore("DevConsoleVisible", not SG:GetCore("DevConsoleVisible"))
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
				Tooltip = "Prints all INCOMING messages from remote events to the console.",
				Layout = 12,Functs={},
				Shortcut = "PrintRemoteSpy",
                Activate = function(self,newValue)
                    for num, event in ipairs(C.getinstances()) do
                        if event:IsA("RemoteEvent") then
                            table.insert(self.Functs,event.OnClientEvent:Connect(function(...)
                                print(`[Remote Event Spy]: {event:GetFullName()}`,...)
                            end))
                        end
                    end
                end,
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
				Options = {
					
				}
			},
		}
	}
end
