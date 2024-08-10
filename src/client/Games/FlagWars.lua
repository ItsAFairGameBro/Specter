local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",UserList="UserList"}

local function Static(C,Settings)

end

return function (C,Settings)

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
				Shortcut = "WeaponStats",Default=true,
                NewInstance = function(self,newTool)
                    local function SetStat(config,instance,newValue,doInsert)
                        local val = config:FindFirstChild(instance)
                        if not val and doInsert then
                            instance = Instance.new((typeof(newValue)=="string" and "StringValue")
                                or (typeof(newValue)=="boolean" and "BoolValue")
                                or (typeof(newValue)=="number" and "NumberValue"), workspace)
                            instance.Name = instance
                            table.insert(self.Instances,instance)
                        else
                            return
                        end
                        if self.RealEnabled then
                            C.SetPartProperty(instance,"Value","WeaponStats",newValue)
                        else
                            C.ResetPartProperty(instance,"Value","WeaponStats")
                        end
                    end
                    local config = newTool:FindFirstChild("Configuration")
                    if not config or not newTool:IsA("Tool") then
                        return
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
                    --SetStat(config,"HasScope",false)

                    SetStat(config,"FireMode","Automatic",true)
                    SetStat(config.Parent,"CurrentAmmo",69)
                    --SetStat(config,"AmmoCapacity",69)
                end,
				Activate = function(self,newValue)
                    for num, tool in ipairs(C.plr:WaitForChild("Backpack"):GetChildren()) do
                        self:NewInstance(tool)
                    end
                end,
                Events = {
                    MyCharAdded=function(self,theirPlr,theirChar,firstRun)
                        table.insert(self.Functs,theirPlr:WaitForChild("Backpack"):Connect(function(newTool)
                            self:NewInstance(newTool)
                        end))
                        task.delay(.5,self.Activate,self)
					end,
                },
            }
        },
    }
end





