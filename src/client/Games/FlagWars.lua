local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",UserList="UserList"}

local RS = game:GetService("ReplicatedStorage")
local function Static(C,Settings)
    --[[table.insert(C.EventFunctions,function()
		local function MapAdded()
            C.Map = workspace:WaitForChild("Normal")
            C.FireEvent("MapAdded",nil,C.Map)
            C.AddObjectConnection(C.Map,"MapRemoved",C.Map.Destroying:Connect(function()
                
                C.FireEvent("MapRemoved",nil,C.Map)
            end))
        end
        C.StringWait(RS,"Remotes.Gameplay.LoadingMap").OnClientEvent:Connect(MapAdded)
        if workspace:FindFirstChild("Normal") then
            MapAdded()
        end

    end)--]]
end

return function (C,Settings)
    Static(C,Settings)

    return {
        Category = {
            Name = "FlagWars",
            Title = "Flag Wars",
            Image = nil, -- Set Image to nil in order to get game image!
            Layout = 20,
        },
        Tab = {
            {
				Title = "Weapon Stats",
				Tooltip = "Creates infinite ammo, firerate, and accuracy hack; re-equip on enable/disable",
				Layout = 0, Instances = {}, Functs={},
				Shortcut = "WeaponStats",Default=true, DontActivate=true,
                NewInstance = function(self,newTool)
                    local config = newTool:WaitForChild("Configuration",10)
                    if not config or not newTool:IsA("Tool") then
                        return
                    end
                    local function SetStat(config,name,newValue,doInsert)
                        local val = config:FindFirstChild(name)
                        if not val and doInsert then
                            val = Instance.new((typeof(newValue)=="string" and "StringValue")
                                or (typeof(newValue)=="boolean" and "BoolValue")
                                or (typeof(newValue)=="number" and "NumberValue"), config)
                            val.Name = name
                            table.insert(self.Instances,val)
                        elseif not val then
                            return
                        end
                        if self.RealEnabled then
                            C.SetPartProperty(val,"Value",self.Shortcut,newValue,true)
                        else
                            C.ResetPartProperty(val,"Value",self.Shortcut)
                        end
                    end
                    SetStat(config,"RecoilMin",0)
                    SetStat(config,"RecoilMax",0)
                    SetStat(config,"RecoilDecay",0)
                    SetStat(config,"TotalRecoilMax",0)
                    SetStat(config,"MinSpread",0)
                    SetStat(config,"MaxSpread",0)
                    SetStat(config,"ShotCooldown",0)
                    SetStat(config,"Cooldown",0)
                    SetStat(config,"SwingCooldown",0)
                    SetStat(config,"HitRate",0)

                    SetStat(config,"FireMode","Automatic",true)
                    SetStat(config.Parent,"CurrentAmmo",69)
                end,
				Activate = function(self,newValue)
                    local toolsToLoop = C.plr:WaitForChild("Backpack"):GetChildren()
                    local curTool = C.char:FindFirstChildWhichIsA("Tool")
                    if curTool then
                        table.insert(toolsToLoop,curTool)
                    end
                    for num, tool in ipairs(toolsToLoop) do
                        task.spawn(self.NewInstance,self,tool)
                    end
                end,
                Events = {
                    MyCharAdded=function(self,theirPlr,theirChar,firstRun)
                        table.insert(self.Functs,theirPlr:WaitForChild("Backpack").ChildAdded:Connect(function(newTool)
                            self:NewInstance(newTool)
                        end))
                        task.delay(.5,self.Activate,self)
					end,
                },
            },
            {
				Title = "Close Hit",
				Tooltip = "Hits the closest user",
				Layout = 1, Instances = {}, Functs={},
				Shortcut = "ClosestHit",Default=true,
                Activate = function(self,newValue)
                    C.HookNamecall(self.Shortcut,newValue and {"fireserver"},function(method,args)
                        local event = args[1]
                        if tostring(event) == "WeaponHit" then
                            local ClosestHead, Distance = C.getClosest()
                            if ClosestHead then
                                local dataTbl = args[3]
                                dataTbl["part"] = ClosestHead
                                dataTbl["h"] = ClosestHead
    
                                --[[dataTbl["p"] = ClosestHead.Position
                                dataTbl["d"] = Distance
                                dataTbl["m"] = ClosestHead.Material
                                dataTbl['n'] = -(ClosestHead.Position - C.char.PrimaryPart.Position).Unit
                                dataTbl["maxDist"] = Distance + .3
                                dataTbl["t"] = 1--]]
    
                                --dataTbl[""] = ClosestHead
                                --print("DataTbl",dataTbl)
                                return "Override", args
                            else
                                --print("did nothing")
                                return true--do nothing lol, don't kill yaself!
                            end
                        end
                        return false -- do not change!
                    end)
                end
            },
            {
				Title = "Hit Hack",
				Tooltip = "Hits the closest user",
				Layout = 4, Instances = {}, Functs={},
				Shortcut = "ClosestHit",Default=true,
                Activate = function(self,newValue)
                    C.HookNamecall(self.Shortcut,newValue and {"fireserver"},function(newSc,method,self,args)
                        local event = self
                        print(tostring(event))
                        if tostring(event) == "WeaponHit" then
                            local ClosestHead, Distance = C.getClosest()
                            print("CLosest",ClosestHead)
                            if ClosestHead then
                                local dataTbl = args[2]
                                dataTbl["part"] = ClosestHead
                                dataTbl["h"] = ClosestHead
    
                                --[[dataTbl["p"] = ClosestHead.Position
                                dataTbl["d"] = Distance
                                dataTbl["m"] = ClosestHead.Material
                                dataTbl['n'] = -(ClosestHead.Position - C.char.PrimaryPart.Position).Unit
                                dataTbl["maxDist"] = Distance + .3
                                dataTbl["t"] = 1--]]
    
                                --dataTbl[""] = ClosestHead
                                --print("DataTbl",dataTbl)
                                return "Override", args
                            else
                                --print("did nothing")
                                return--do nothing lol, don't kill yaself!
                            end
                        end
                        return -- do not change!
                    end)
                end
            },
            {
				Title = "Disable Killwall",
				Tooltip = "Disables SOME Kill bricks!",
				Layout = 20,Functs={},
				Shortcut = "NoKillBricks",Default=true,
                NewInMap = function(self,part)
                    if part:IsA("BasePart") and part:FindFirstChildWhichIsA("TouchTransmitter") then
                        if self.RealEnabled then
                            C.SetPartProperty(part,"CanTouch",self.Shortcut,false)
                        else
                            C.ResetPartProperty(part,"CanTouch",self.Shortcut)
                        end
                    end
                end,
                Activate = function(self,newValue)
                    local CurMap = C.StringWait(workspace,"Core.CurrentMap")
                    for num, touchPart in ipairs(CurMap:GetChildren()) do
                        self:NewInMap(touchPart)
                    end
                    table.insert(self.Functs,CurMap.ChildAdded:Connect(function(new)
                        self:NewInMap(new)
                    end))
                end,
            },
            
        },
    }
end





