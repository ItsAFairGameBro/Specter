local Types = {Toggle="Toggle",Slider="Slider",Dropdown="Dropdown",Textbox="Textbox",UserList="UserList"}
local SG = game:GetService("StarterGui")
local PhysicsS = game:GetService"PhysicsService"
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
				Layout = 1,Type="NoToggle",Keybind=Enum.KeyCode.F9.Name,
				Shortcut = "DevelopersConsole",
				Activate = function(self,newValue)
					SG:SetCore("DevelopersConsole", not SG:GetCore("DevelopersConsole"))
				end,
				Options = {
					
				}
			},
            {
				Title = "Collisions Groups",
				Tooltip = "Prints Collisions Groups To Console",
				Layout = 2,Type="NoToggle",
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
				Title = "Collisions Groups",
				Tooltip = "Prints Collisions Groups To Console",
				Layout = 3,
				Shortcut = "CollisionGroups",
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
						C.DoActivate(self.Activate,self,self.EnTbl.En)
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
                        ["OriginalCollide"]=true,["OrgSize"]=true,["WeirdCanCollide"]=true,["Opened"]=true,["SaveVolume"]=true,['ClearedHackGUI1']=true}
                    local function printAtt(obj)
                        for _,instance in ipairs(ignoreList) do
                            if instance:IsAncestorOf(obj) then
                                return
                            end 
                        end
                        local printStr
                        for attribute, val in pairs(obj:GetAttributes()) do
                            if not ignoreList[attribute] then
                                if not printStr then
                                    printStr = "\tOBJ ["..obj:GetFullName().."]:"
                                end
                                printStr..="\n\t\t"..attribute.."="..tostring(val)
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
                    
                    warn(("[Attribute Search] Search Finished! Loop through %s instances in %.2f seconds!"):format(C.comma_value(loop(game)),os.clock()-start))     
				end,
				Options = {
					
				}
			},
		}
	}
end
