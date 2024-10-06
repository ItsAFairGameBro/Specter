local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",UserList="UserList"}

local RunS = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")
local absoluteMaximumDirtDistance = 20
local function Static(C,Settings)

end

return function (C,Settings)
    Static(C,Settings)

    return {
        Category = {
            Name = "Doomspire",
            Title = "Doomspire Brickbattle",
            Image = nil, -- Set Image to nil in order to get game image!
            Layout = 20,
        },
        Tab = {
            {
				Title = "Weapon Stats",
				Tooltip = "Hacks weapon stats to allow you to perform at your best ;)\nReset required",
				Layout = 0, Instances = {}, Functs={}, Original = {},
				Shortcut = "WeaponStats",Default=true, DontActivate=true,
                PreModify = function(self, tbl, key)
                    --if not self.Original[key] then
                    for key, val in pairs(tbl) do
                        if (key ~= "TeamsFiltered") then
                            self.Original[key] = typeof(val) == "table" and C.DeepCopy(tbl[key]) or val
                        end
                    end
                    --end
                end,
                SetEnabled = function(self, en)
                    for num, mod in ipairs(C.getgc(true)) do
                        local ModSettings = typeof(mod) == "table" and rawget(mod, "Settings")
                        if ModSettings and typeof(ModSettings) == "table" and rawget(ModSettings,"Rocket") then
                            --C.setclipboard(print(mod))
                            if (not en) then
                                for key, val in pairs(self.Original) do
                                    rawset(mod,key,val)
                                end
                            else
                                self:PreModify(mod, "Settings")
                                local RocketStats = rawget(ModSettings,"Rocket")
                                local BombStats = rawget(ModSettings, "Bomb")
                                --print("Modified Bomb.Reload from",rawget(BombStats,"Reload"),"to 0.0")
                                rawset(RocketStats,"ReloadTime",1)
                                rawset(RocketStats,"Speed",600)
                                rawset(RocketStats, "Radius", 600)
                                rawset(RocketStats, "MaxMassToDestroy", 300)


                                rawset(ModSettings,"TeamKill",true)
                                rawset(BombStats, "ReloadTime", 4)
                                rawset(BombStats, "Radius", 600)
                                rawset(BombStats, "ExplosionForce", 0)--1e6 * (rawget(BombStats, "Radius") / 12))
                                rawset(BombStats, "Damage", 1000)
                                rawset(BombStats, "MaxMassToDestroy", 300)
                            end
                        end
                    end
                end,
                RunOnDestroy = function(self)
                    self:SetEnabled(false)
                end,
				Activate = function(self,newValue)
                    self:SetEnabled(newValue)
                end,
                Events = {
                    MyCharAdded=function(self,theirPlr,theirChar,firstRun)
                        --[[table.insert(self.Functs,theirPlr:WaitForChild("Backpack").ChildAdded:Connect(function(newTool)
                            self:NewInstance(newTool)
                        end))--]]
                        task.delay(.5,self.Activate,self,self.RealEnabled)
					end,
                },
            },
        }
    }
end





