local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",UserList="UserList"}

local RunS = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")
local absoluteMaximumDirtDistance = 20
local function Static(C,Settings)
    function C.getClosestDirt(location: Vector3)
        local myHRPPos = location or (C.char and C.char.PrimaryPart and C.char:GetPivot().Position)
        if not myHRPPos then return end
        local selDirt, maxDist, closestAngle = nil, absoluteMaximumDirtDistance, 360
        for num, part in pairs(workspace.Core.CurrentDirt:GetDescendants()) do
            if part:IsA("BasePart") then
                local d = (part.Position - myHRPPos).Magnitude
                --local angle = math.round(math.abs(C.AngleOffFromCFrame(C.hrp:GetPivot(),part.Position))/10)*10
                if (((not selDirt or part.Position.Y - 0.5 < selDirt.Position.Y) and d < maxDist) or (selDirt and part.Position.Y+0.5 < selDirt.Position.Y)) then
                        --and (angle < closestAngle) and d < absoluteMaximumDirtDistance then
                    selDirt, maxDist, closestAngle = part, d, nil
                end
            end
        end
        return selDirt, maxDist
    end
    -- Map Added is lowkey just team added -.-
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
                        if not val and doInsert and self.RealEnabled then
                            val = Instance.new((typeof(newValue)=="string" and "StringValue")
                                or (typeof(newValue)=="boolean" and "BoolValue")
                                or (typeof(newValue)=="number" and "NumberValue"), config)
                            val.Name = name
                            table.insert(self.Instances,val)
                        elseif not val then
                            return
                        end
                        C.ResetPartProperty(val,"Value",self.Shortcut)
                        if self.RealEnabled then
                            C.SetPartProperty(val,"Value",self.Shortcut,newValue)
                        --else
                            --C.ResetPartProperty(val,"Value",self.Shortcut)
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
				Title = "Gun Hit",
				Tooltip = "Hits the closest user",
				Layout = 4,AlwaysActivate=true,
				Shortcut = "GunHit",Default=true,
                Activate = function(self,newValue)
                    local EnTbl = self.EnTbl
                    local tblClone, tblPack = table.clone, table.pack
                    local getVal, setVal = rawget, rawset
                    C.HookMethod("__namecall",self.Shortcut,newValue and function(newSc,method,self,arg1,arg2,...)
                        if tostring(self) == "WeaponHit" then
                            local ClosestHead, Distance = C.getClosest(nil,getVal(arg2,"p"))
                            if ClosestHead then--and Distance < 50 then
                                -- Table Clone: Security Prevention
                                arg2 = tblClone(arg2)
                                setVal(arg2,"part",ClosestHead)
                                setVal(arg2,"p",ClosestHead.Position)
                                setVal(arg2,"h",ClosestHead)

                                --[[dataTbl["p"] = ClosestHead.Position
                                dataTbl["d"] = Distance
                                dataTbl["m"] = ClosestHead.Material
                                dataTbl['n'] = -(ClosestHead.Position - C.char.PrimaryPart.Position).Unit
                                dataTbl["maxDist"] = Distance + .3
                                dataTbl["t"] = 1--]]
                                return "Override", tblPack(arg1,arg2,...)
                            elseif EnTbl.NoSelfKill then
                                --task.delay(1,print,"Canceled; none found")
                                return "Cancel"--do nothing lol, don't kill yaself!
                            end
                        end
                        
                    end,{"fireserver"})
                end,
                Options = {
                    {
						Type = Types.Toggle,
						Title = "No Self Kill",
						Tooltip = "Disabling hitting yourself with explosive weapons",
						Layout = 1,Default=true,
						Shortcut="NoSelfKill",
					},
                },
            },
            false and {
				Title = "Sword Hit",
				Tooltip = "Hits the closest user",
				Layout = 5,
				Shortcut = "SwordHit",Default=true,
                Activate = function(self,newValue)
                    local tblClone, tblPack = table.clone, table.pack
                    C.HookMethod("__namecall",self.Shortcut,newValue and function(newSc,method,self,arg1,arg2,arg3,...)
                        if tostring(self) == "ClientCast-Replication" then
                            local ClosestHead, Distance = C.getClosest(nil,arg3.Position)
                            if ClosestHead then--and Distance < 50 then
                                arg2 = ClosestHead.Parent.Humanoid
                                -- Table Clone: Security Prevention
                                arg3 = tblClone(arg3)
                                arg3["Instance"] = ClosestHead

                                -- Fake the signal into firing, meanwhile firing our own
                                task.spawn(self.FireServer,self,arg1,arg2,arg3,...)

                                task.spawn(print,"HIT PLR")
                                return "Cancel"
                            else
                                -- Doesn't matter, do nothing!
                            end
                        end
                        
                    end,{"fireserver"})
                end
            },
            {
				Title = "Auto Bore",
				Tooltip = "Automatically digs nearby dirt near you; must have Shovel equipped",
				Layout = 10,Threads={},DontActivate = true,
				Shortcut = "AutoBore",Default=true,
                Run = function(self)
                    local DigEvent = C.StringWait(RS,"Events.Dig")

                    while true do
                        local dirt, distance = C.getClosestDirt()
                        if dirt and distance < absoluteMaximumDirtDistance then
                            --warn("Distance",tostring(distance))
                            for s = 1, 4, 1 do
                                task.spawn(DigEvent.FireServer,DigEvent,"Shovel",dirt)
                            end
                        end
                        RunS.RenderStepped:Wait()
                    end
                end,
                Activate = function(self,newValue)
                    if not newValue then
                        return--stop it!
                    end
                    --for s = 1, 10, 1 do
                    --    table.insert(self.Threads,task.spawn(self.Run,self))
                    --end
                    self:Run()
                end,
                Events = {
                    MyCharAdded=function(self,theirPlr,theirChar,firstRun)
						C.DoActivate(self,self.Activate,self.RealEnabled)
					end,
                }
            },
            {
				Title = "Loop Capture",
				Tooltip = "Captures the flag the fastest possible",
				Layout = 15,Functs={},Threads={},
				Shortcut = "LoopCature",Default=true,
                Activate = function(self,newValue)
                    C.RemoveAction(self.Shortcut)
                    C.LoadPlayerCoords(self.Shortcut)
                    if not newValue then
                        return
                    end
                    local EnemyTeam = C.plr.Team == "Team Blue" and "Team Red" or "Team Blue"
                    local AllyFlag = game:GetService("Workspace").Core.Flags[C.plr.Team.Name].Base
                    local EnemyFlag = game:GetService("Workspace").Core.Flags[EnemyTeam].Base
                    local info = {Name=self.Shortcut,Title="Loop Capture",Tags={"RemoveOnDestroy"},Stop=function()
                        self:Activate(false)
                    end}
                    local actionClone = C.AddAction(info)
                    C.SavePlayerCoords(self.Shortcut)
                    C.DoTeleport(EnemyFlag.Position)
                    --while true do
                        
                    --end
                end,
                Events = {
                    MyTeamAdded = function(self,theirPlr,newTeamName)
						C.DoActivate(self,self.Activate,self.RealEnabled)
					end,
                }
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
                Activate = function(self)
                    local CurMap = C.StringWait(workspace,"Core.CurrentMap")
                    for num, touchPart in ipairs(CurMap:GetChildren()) do
                        self:NewInMap(touchPart)
                    end
                    table.insert(self.Functs,CurMap.ChildAdded:Connect(function(new)
                        self:NewInMap(new)
                    end))
                end,
                Events = {
                    MyTeamAdded = function(self,theirPlr,newTeamName)
						C.DoActivate(self,self.Activate,self.RealEnabled)
					end,
                }
            },
            
            --[[
                local args = {
                    [1] = "Shovel",
                    [2] = workspace.Core.CurrentDirt.Chunk4.dirt
                }

                game:GetService("ReplicatedStorage").Events.Dig:FireServer(unpack(args))
            ]]
            
        },
    }
end





