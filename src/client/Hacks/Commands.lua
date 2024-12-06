local ChangeHistoryService = game:GetService("ChangeHistoryService")
local GuiService = game:GetService("GuiService")
local PhysicsService = game:GetService("PhysicsService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local PS = game:GetService("Players")
local TeleportS = game:GetService("TeleportService")
local CS = game:GetService("CollectionService")
local DS = game:GetService("Debris")
local CP = game:GetService("ContentProvider")
local SG = game:GetService("StarterGui")
local HS = game:GetService("HttpService")
local AS = game:GetService("AssetService")

local MaxRelativeDist = 50
local MaxFlingSpeed = 1e6

local BodyColorsNamesArray = {}
local BodyColorsColorArray = {}
local InvalidBrickColor = BrickColor.new(0) -- Creates invalid brickcolor

for i = 1, 1032 do
    local BrickColorValue = BrickColor.new(i)
    if BrickColorValue ~= InvalidBrickColor then
        table.insert(BodyColorsNamesArray, BrickColorValue.Name)
        --BodyColorsColorArray[BrickColorValue.Name] = BrickColorValue.Color
    end
end
local BodyColorPropertyNames = {"LeftArmColor","RightArmColor","LeftLegColor","RightLegColor","TorsoColor","HeadColor"}

return function(C,Settings)
    local Serializer = C.LoadModule("Modules/Serializer")
    C.getgenv().serializedDesc = C.getgenv().serializedDesc or {}
    C.getgenv().currentDesc = C.getgenv().currentDesc or {}
    C.getgenv().Outfits = C.getgenv().Outfits or {}
    C.CommandFunctions = {
        ["refresh"]={
            Parameters={},
            AfterTxt="%s",
            Priority=10,
            RequiresRefresh=true,
            Run=function(args)
                C.Refresh()
                return true
            end,
        },
        --[[["reset_settings"]={
            Parameters=false,
            AfterTxt="%s",
            RequiresRefresh=true,
            Run=function(args)
                C.AvailableHacks.Basic[99].ActivateFunction(true, true)
                return true,"Successful"
            end,
        },--]]
        ["freecam"]={
            Parameters={},
            AfterTxt="%s",
            RequiresRefresh=true,
            Run=function(args)
                C.hackData.World.Freecam:SetValue(not C.hackData.World.Freecam.RealEnabled)
                return true
            end,
        },
        ["spectate"]={
            Parameters={{Type="Player"}},
            AfterTxt=" %s",
            RequiresRefresh=true,
            Functs = {},
            RunOnDestroy = function(self)
                C.ClearFunctTbl(self.Functs)
                C.Spectate()
            end,
            TheirCharAdded = function(self, theirPlr, theirChar)
                local theirHuman = theirChar:WaitForChild("Humanoid",15)
                if theirHuman then
                    C.Spectate(theirChar)
                end
            end,
            Run=function(self,args)
                self:RunOnDestroy()

                local theirPlr = args[1][1]
                table.insert(self.Functs, theirPlr.CharacterAdded:Connect(function(newChar)
                    self:TheirCharAdded(theirPlr, newChar)
                end))
                table.insert(self.Functs, theirPlr.AncestryChanged:Connect(function()
                    C.CreateSysMessage(`Stopped spectating because {C.GetPlayerName(theirPlr)} left`, Color3.fromRGB(0,255,255))
                    self:Run({{C.plr}})
                end))
                if theirPlr.Character then
                    self:TheirCharAdded(theirPlr, theirPlr.Character)
                end
                return true,"Successful"
            end,
        },
        ["cloth"] = C.hackData.Developer and {
            Parameters={{Type="Players",SupportsNew = true, AllowFriends = true}},
            AfterTxt = " to nothing!",
            Run = function(self, args)
                local SetDesc
                if args[1] == "new" then
                    SetDesc = C.getgenv().JoinPlayerMorphDesc
                else
                    SetDesc = C.getgenv().currentDesc[args[1][1].Name]
                end
                SetDesc = SetDesc or Instance.new("HumanoidDescription")
                -- Apply Transformation
                SetDesc.Shirt = 0
                SetDesc.Pants = 0
                local r1, r2 = C.CommandFunctions.morph.SetPlayersToDescription(C.CommandFunctions.morph, args[1], SetDesc)
                if not r1 then
                    return r1, r2
                end
                return true, args[2]
            end,
        } or nil,
        ["bodycolor"] = {
            Parameters={{Type="Players",SupportsNew = true, AllowFriends = true},
                {Type="Options",Options=BodyColorsNamesArray,Optional=true}},
            Alias = {"color"},
            AfterTxt = " to %s!",
            Run = function(self, args)
                local SetDesc
                if args[1] == "new" then
                    SetDesc = C.getgenv().JoinPlayerMorphDesc
                else
                    SetDesc = C.getgenv().currentDesc[args[1][1].Name]
                end
                SetDesc = SetDesc or Instance.new("HumanoidDescription")
                -- Apply Color Transformation
                local AppliedColor = args[2] and (BodyColorsColorArray[args[2]] or BrickColor.new(args[2]).Color) or C
                for _, property in ipairs(BodyColorPropertyNames) do
                    C.SetPartProperty(SetDesc, property, "BodyColor", AppliedColor, true, true)
                end
                local r1, r2 = C.CommandFunctions.morph.SetPlayersToDescription(C.CommandFunctions.morph, args[1], SetDesc)
                if not r1 then
                    return r1, r2
                end
                return true, args[2]
            end,
        },
        ["morph"]={
            Parameters={{Type="Players",SupportsNew = true, AllowFriends = true},{Type="Friend"}},
            AfterTxt=" to %s%s",Priority=-3,
            RestoreInstances={["Hammer"]=true,["Gemstone"]=true,["PackedGemstone"]=true,["PackedHammer"]=true},
            GetHumanoidDesc=function(self,userID,outfitId)
                local success, desc
                while not success do
                    success,desc = pcall(PS[outfitId and "GetHumanoidDescriptionFromOutfitId" or "GetHumanoidDescriptionFromUserId"], PS,outfitId or userID)
                    if not success then
                        task.wait(.3)
                    end
                end
                desc.Name = userID .. (outfitId and ("/"..outfitId) or "")
                return  desc
            end,
            DoAnimationEffect = nil, --"Fade",
            AnimationEffectFunctions={
                Fade = {
                    Tween = function(self,targetChar,loopList,visible,instant)
                        local newTransparency = visible and 0 or 1
                        local property = "Transparency"--targetChar == plr.Character and "LocalTransparencyModifier" or "Transparency"
                        for num, part in ipairs(loopList) do
                            if (part:IsA("BasePart") or part:IsA("Decal")) and
                                ((not visible and part.Transparency<1) or (part:GetAttribute("PreviousTransparency"))) then
                                local PreviousTransparency = part:GetAttribute('PreviousTransparency') or part.Transparency
                                part:SetAttribute("PreviousTransparency",PreviousTransparency)
                                if instant then
                                    part[property] = visible and PreviousTransparency or newTransparency
                                else
                                    TS:Create(part,TweenInfo.new(1),{[property] = visible and PreviousTransparency or newTransparency}):Play();
                                end
                            end
                        end
                    end,
                    Start = function(self,targetChar)
                        self:Tween(targetChar,targetChar:GetDescendants(),false,false)
                        task.wait(1)
                    end,
                    Update = function(self,targetChar,part)
                       self:Tween(targetChar,{part},false,true)
                    end,
                    End = function(self,targetChar)
                       self:Tween(targetChar,targetChar:GetDescendants(),true,false)
                    end,
                },
                Bury = {
                    Tween = function(self,targetChar,visible,instant)
                        local newTransparency = visible and 0 or 1
                        local property = "HipHeight"
                        local theirHuman = targetChar:WaitForChild("Humanoid")
                        if theirHuman then
                            TS:Create(theirHuman, TweenInfo.new(1), {[property] = (visible and 0 or -C.getHumanoidHeight(targetChar))}):Play()
                        end
                    end,
                    Start = function(self,targetChar)
                        self:Tween(targetChar,false,false)
                        task.wait(2)
                    end,
                    Update = function(self,targetChar,part)

                    end,
                    End = function(self,targetChar)
                       self:Tween(targetChar,true,false)
                    end,
                }
            },
            Headless={146574359,826042567,1287648573,1091344783,1001407414,1568359906},--"courteney_820","z_baeby","kitcat4681","bxnny_senpxii","queen","army"},
            BannedHeadlessItems = {16687323428,12064732367},
            MorphPlayer=function(self,targetChar, humanDesc, dontUpdate, dontAddCap, isDefault)
                local AnimationEffectData = not dontAddCap and C.CommandFunctions.morph.AnimationEffectFunctions[C.CommandFunctions.morph.DoAnimationEffect]

                local targetHuman = targetChar:FindFirstChild("Humanoid")
                local oldHumanDesc = targetHuman:FindFirstChild("HumanoidDescription")
                local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
                if not targetHuman or targetHuman.Health <=0 or not targetHRP or not oldHumanDesc then
                    return
                end
                if AnimationEffectData then
                    AnimationEffectData:Start(targetChar)
                end
                for _, prop in ipairs({"HeadScale","BodyTypeScale","DepthScale","HeightScale","ProportionScale","WidthScale"}) do
                    humanDesc[prop] = oldHumanDesc[prop]
                end
                --local wasAnchored = targetHRP.Anchored
                --humanDesc.Name = "CharacterDesc"
                if not dontUpdate then
                    local myCurrentDesc = C.getgenv().currentDesc[targetChar.Name]
                    if myCurrentDesc and humanDesc~=myCurrentDesc then
                        if myCurrentDesc:GetAttribute("HeadColor_OriginalValue") then
                            for _, property in ipairs(BodyColorPropertyNames) do
                                local SetValue = myCurrentDesc:GetAttribute(property .. "_Request_BodyColor")
                                C.SetPartProperty(humanDesc, property, "BodyColor", SetValue, true, true)
                            end
                        end
                        myCurrentDesc:Destroy()
                    end
                    if not isDefault then
                        C.getgenv().currentDesc[targetChar.Name] = humanDesc
                        if not C.getgenv().JoinPlayerMorphDesc or humanDesc.Name ~= C.getgenv().JoinPlayerMorphDesc.Name then
                            C.getgenv().serializedDesc[targetChar.Name] = Serializer.serialize(humanDesc)
                        else
                            C.getgenv().serializedDesc[targetChar.Name] = nil
                        end
                    else
                        C.getgenv().currentDesc[targetChar.Name] = nil
                        C.getgenv().serializedDesc[targetChar.Name] = nil
                    end
                    self.Enabled = C.GetDictLength(C.getgenv().currentDesc) > 0
                end
                local isR6 = targetHuman.RigType == Enum.HumanoidRigType.R6

                local oldHuman = targetHuman
                local newHuman = oldHuman:Clone()--(isR6 and false) and Instance.new("Humanoid") or oldHuman:Clone()----oldHuman:Clone()


                local newHuman_Animator = newHuman:FindFirstChild("Animator")
                if newHuman_Animator then
                    newHuman_Animator:Destroy() -- Prevents LoadAnimation error spams
                end
                local oldChar_ForceField = targetChar:FindFirstChild("ForceField",true)

                newHuman.Name = "FakeHuman"
                newHuman.Parent = targetChar
                C.AddGlobalInstance(newHuman)
                local Instances2Restore = {}
                for num, accessory in ipairs(targetChar:GetDescendants()) do
                    if self.RestoreInstances[accessory.Name] then
                        accessory.Parent = workspace
                        C.AddGlobalInstance(accessory)
                        table.insert(Instances2Restore,accessory)
                    elseif accessory:IsA("Accessory") or accessory:IsA("Pants") or accessory:IsA("Shirt") or accessory:IsA("ShirtGraphic") then
                        accessory:Destroy()
                    end
                end
                for num, instanceName in ipairs({"Shirt","Pants"}) do
                    local instance = targetChar:FindFirstChild(instanceName)
                    if instance then
                        if instanceName=="Shirt" then
                            instance.ShirtTemplate = humanDesc.Shirt
                        elseif instanceName=="Pants" then
                            instance.PantsTemplate = humanDesc.Pants
                        end
                    end
                end
                if not dontAddCap and C.gameName == "FleeMain" then
                    for num, capsule in ipairs(CS:GetTagged("Capsule")) do
                        C.CommandFunctions.morph.CapsuleAdded(capsule,true)
                    end
                end
                local HeadlessActive = false
                if not isDefault and humanDesc.Head ~= 86498048 and table.find(self.Headless, tonumber(humanDesc.Name:split("/")[1])) then
                    humanDesc.Head = 15093053680
                    humanDesc.Face = 0
                    HeadlessActive = true
                    local Accessories = humanDesc:GetAccessories(true)
                    for key = #Accessories, 1, -1 do
                        local accessory = Accessories[key]
                        if table.find(self.BannedHeadlessItems, accessory.AssetId) then
                            table.remove(Accessories,key)
                        end
                    end
                    humanDesc:SetAccessories(Accessories, true)
                end
                local AnimationUpdateConnection
                if AnimationEffectData and AnimationEffectData.Update then
                    AnimationUpdateConnection = targetChar.DescendantAdded:Connect(function(part)
                        if part:IsA("BasePart") then
                            AnimationEffectData:Update(targetChar,part)
                        end
                    end)
                end
                while not pcall(newHuman.ApplyDescriptionReset,newHuman,humanDesc) do
                    task.wait(1)
                end
                if workspace.CurrentCamera.CameraSubject == newHuman then
                    workspace.CurrentCamera.CameraSubject = oldHuman
                end
                if oldChar_ForceField and oldChar_ForceField.Parent then
                    oldChar_ForceField.Parent = targetChar:FindFirstChild("HumanoidRootPart")
                end
                for num, instance in ipairs(Instances2Restore) do
                    if instance.Parent then
                        instance.Parent = targetChar
                        C.RemoveGlobalInstance(instance)
                    end
                end
                if HeadlessActive then
                    for _, obj in ipairs(targetChar:GetDescendants()) do
                        if obj:IsA("Decal") and obj.Parent and obj.Parent.Name == "Head" then
                            obj:Destroy()
                        end
                    end
                end
                newHuman.Parent = nil
                DS:AddItem(newHuman,3)
                if AnimationEffectData then
                    AnimationEffectData:End(targetChar)
                end
                if AnimationUpdateConnection then
                    AnimationUpdateConnection:Disconnect()
                end
            end,
            Functs={},
            RunOnDestroy = function(self)
                C.ClearFunctTbl(self.Functs)
            end,
            --[[CapsuleAdded=function(self,capsule,noAddFunct)
                local function childAdded(child)
                    if child:IsA("Model") and child:WaitForChild("Humanoid",5) then
                        local humanDesc = C.getgenv().currentDesc[child.Name]
                        if humanDesc then
                            task.wait(.3)
                            local orgColor = child:WaitForChild("Head").Color
                            local myClone = humanDesc:Clone()
                            for num, prop in ipairs({"LeftArmColor","RightArmColor","LeftLegColor","RightLegColor","TorsoColor","HeadColor"}) do
                                myClone[prop] = orgColor
                            end
                            C.CommandFunctions.morph:MorphPlayer(child,myClone,true,true)
                            DS:AddItem(myClone,15)
                        end
                    end
                end

                if not noAddFunct then
                    table.insert(C.CommandFunctions.morph.Functs,capsule.ChildAdded:Connect(childAdded))
                end
                if not capsule:FindFirstChild("PodTrigger") then
                    for num, child in ipairs(capsule:GetChildren()) do
                        task.spawn(childAdded,child)
                    end
                end
            end,--]]
            Events = {
                CharAdded=function(self,theirPlr,theirChar,firstRun)
                    local theirHuman = theirChar:WaitForChild("Humanoid")
                    local PrimPart = theirHuman and theirChar:WaitForChild("HumanoidRootPart", 15)
                    if not theirHuman or not PrimPart then
                        print("TheirHuman Or PrimPart Not Found")
                        return
                    end
                    CP:PreloadAsync({theirChar})
                    if firstRun then
                        task.wait(.83) --Avatar loaded wait!
                    else
                        task.wait(.63) --Avatar loaded wait!
                    end
                    if not theirChar.Parent then
                        return
                    end
                    local currentChar = C.getgenv().currentDesc[theirPlr.Name]
                    if C.hackData.NavalWarefare then
                        task.wait(3)
                    end
                    if firstRun and not currentChar then
                        local JoinPlayerMorphDesc = C.getgenv().JoinPlayerMorphDesc
                        print(theirChar,"first run: joinplayerrmorphdesc")
                        if JoinPlayerMorphDesc then
                            JoinPlayerMorphDesc = JoinPlayerMorphDesc:Clone()
                            C.getgenv().currentDesc[theirPlr.Name] = JoinPlayerMorphDesc
                            --C.getgenv().serializedDesc[theirPlr.Name] = Serializer.serialize(JoinPlayerMorphDesc)
                            --print(theirChar,"first run set to",JoinPlayerMorphDesc)
                            self:MorphPlayer(theirChar,JoinPlayerMorphDesc,false,true)
                        end
                    elseif not firstRun and currentChar then
                        self:MorphPlayer(theirChar,currentChar,true,not firstRun)
                    end
                end,
                --CapturedRemoved = function(self, theirPlr, theirChar)
                --    task.wait(1)
                --    local foundChar
                --    for _, freezePod in ipairs(C.FreezingPods) do
                --        local theChar = freezePod:FindFirstChild(theirPlr.Name, true)
                --        if theChar then
                --            foundChar = theChar
                --            break
                --        end
                --    end
                --    if foundChar then
                --        print("Found Freeze",foundChar)
                --        local BodyColors = foundChar:FindFirstChildWhichIsA("BodyColors")
                --        self.Events.CharAdded(self, theirPlr, foundChar, true)
                --    end
                --end,
                NewFreezingPod = function(self, capsule)
                    local function childAdded(child)
                        if child:IsA("Model") and child:WaitForChild("Humanoid",5) then
                            local humanDesc = C.getgenv().currentDesc[child.Name]
                            if humanDesc then
                                --CP:PreloadAsync({child})
                                local orgColor = child:WaitForChild("Head").Color
                                local myClone = humanDesc:Clone()
                                for num, prop in ipairs(BodyColorPropertyNames) do
                                    myClone[prop] = orgColor
                                end
                                self:MorphPlayer(child,myClone,true,true)
                                DS:AddItem(myClone,15)
                            end
                        end
                    end

                    table.insert(self.Functs,capsule.ChildAdded:Connect(childAdded))
                    if not capsule:WaitForChild("PodTrigger",.5) then
                        for num, child in ipairs(capsule:GetChildren()) do
                            task.spawn(childAdded,child)
                        end
                    end
                end,
            },
            RealEnabled = C.getgenv().MorphEnabled,
            Run=function(self,args)
                local selectedName = (args[2] == "" and "no") or args[2]--C.checkFriendsPCALLFunction(args[2])[1]
                selectedName = selectedName ~= "no" and selectedName[2] or selectedName
                if not selectedName then
                    return false,`User Not Found: {args[2]}`--C.CreateSysMessage(`User Not Found: {args[2]}`)
                end
                local outfitData
                if args[3] and args[3] ~= "" then
                    if not C.getgenv().Outfits[selectedName.UserId] then
                        local wasSuccess,err = C.CommandFunctions.outfits:Run({selectedName})
                        if not wasSuccess then
                            return false, "Outfit Getter Err " .. tostring(err)
                        end
                    end
                    if not C.getgenv().Outfits[selectedName.UserId] then
                        return false, `Outfit not found for user {selectedName.UserName}, {selectedName.UserId}`
                    end
                    if tonumber(args[3]) then
                        args[3] = tonumber(args[3])
                    else
                        local list = C.StringStartsWith(C.getgenv().Outfits[selectedName.UserId], args[3])
                        if #list == 0 then
                            return false, "Outfit Name Not Found ("..tostring(args[3])..")"
                        end
                        args[3] = list[1][1];
                    end
                    outfitData = C.getgenv().Outfits[selectedName.UserId][args[3]]
                else
                    args[3] = nil
                end
                local defaultHumanDesc = selectedName~="no" and
                    (args[3] and PS:GetHumanoidDescriptionFromOutfitId(outfitData.id) or PS:GetHumanoidDescriptionFromUserId(selectedName.UserId))
                if defaultHumanDesc == nil then
                    return false, "HumanoidDesc returned NULL for all players!"
                end
                local savedDescription = selectedName~="no"
                    and C.CommandFunctions.morph:GetHumanoidDesc(selectedName.UserId,args[3] and outfitData.id)
                --((args[3] and PS:GetHumanoidDescriptionFromOutfitId(outfitData.id)) or PS:GetHumanoidDescriptionFromUserId(selectedName.UserId))
                if args[3] and not outfitData then
                    return false, `Outfit {args[3]} not found!`
                end
                local ret, str = self:SetPlayersToDescription(args[1], savedDescription)
                if not ret then
                    return false, str
                end
                return true,args[2]=="" and "nothing" or selectedName.UserName,outfitData and (" " ..outfitData.name) or ""
            end,
            SetPlayersToDescription = function(self, players, savedDescription)
                self.RealEnabled = true
                C.getgenv().MorphEnabled = true
                if players=="new" or #players > 1 then
                    if C.getgenv().JoinPlayerMorphDesc and C.getgenv().JoinPlayerMorphDesc ~= savedDescription then
                        C.getgenv().JoinPlayerMorphDesc:Destroy()
                    end
                    if not savedDescription then
                        C.getgenv().JoinPlayerMorphDesc = nil
                        C.getgenv().serializedDesc.new = nil
                    else
                        C.getgenv().JoinPlayerMorphDesc = savedDescription
                        C.getgenv().serializedDesc.new = Serializer.serialize(C.getgenv().JoinPlayerMorphDesc)
                    end
                end
                if players~="new" then
                    for num, theirPlr in ipairs(players) do

                        local desc2Apply = savedDescription or PS:GetHumanoidDescriptionFromUserId(theirPlr.UserId)
                        if not desc2Apply then
                            return false, `HumanoidDesc returned NULL for {theirPlr.Name}`
                        end
                        if theirPlr.Character then
                            task.spawn(C.CommandFunctions.morph.MorphPlayer,C.CommandFunctions.morph,theirPlr.Character,desc2Apply,false,false,selectedName == "no")
                        elseif not savedDescription then
                            if C.getgenv().currentDesc[theirPlr.Name]
                                and C.getgenv().currentDesc[theirPlr.Name] ~= desc2Apply then
                                C.getgenv().currentDesc[theirPlr.Name]:Destroy()
                            end
                            C.getgenv().currentDesc[theirPlr.Name] = desc2Apply
                        else
                            if C.getgenv().currentDesc[theirPlr.Name] then
                                C.getgenv().currentDesc[theirPlr.Name]:Destroy()
                            end
                            C.getgenv().currentDesc[theirPlr.Name] = nil
                        end
                        --(selectedName=="no" and theirPlr.UserId or PS:GetUserIdFromNameAsync(selectedName)))
                    end
                end
                return true
            end
        },
        ["unmorph"]={
            Parameters={{Type="Players"}},
            AfterTxt="",
            SupportsNew=true,
            Run=function(self,args)
                C.CommandFunctions.morph:Run({args[1],""})
                return true
            end,
        },
        ["outfits"]={
            Parameters={{Type="Friend"}},
            AfterTxt="%s",
            Run=function(self,args)
                local selectedName = args[1]--local index, selectedName = table.unpack(C.checkFriendsPCALLFunction(args[1])[1] or {})
                C.getgenv().Outfits = C.getgenv().Outfits or {}
                if not selectedName then
                    return false, "User Not Found ("..tostring(args[1])..")"
                end
                local results,bodyResult = "",C.getgenv().Outfits[selectedName.UserId]
                if not C.getgenv().Outfits[selectedName.UserId] then
                    local success,result = pcall(C.request,{Url="https://avatar.roblox.com/v1/users/"..selectedName.UserId.."/outfits",Method="GET",
                        Cookies={[".ROBLOSECURITY"]="CC5437678DF919BEDBCF4E13015BFB5AB984AC1772F3159199BBC3B154AEB901513BDF667123CF732E6119F5433EB7C74F3FD957AFBD778B0E7315205A9A05AA1FDD7BAEE276728F0016FBCC8EF5ECA807E14FD676CBE001C63A142E8B7958F438634ACCAFA8FC5C85A0881E6BD0105996C11DE5BE7CBC1A7D905E7B9622A228030373B31746E0FB4E052E297A7D3F12AAF4D6E649FE1AADD71B576085BE01AD83692B2AB3557D0E29CA12E2DA6B11338C157BC9F224D689699DA4CEBCDBC087933B7DF32A4CE0FC1A818499F7CCFE2001720871A0D655B86A1FA9D71FC918261EA0B031A80529998253D2DE8773F9120190C5102674D6D994AD59C1856606C32B3DFEEC8FA6145E178997F772BBB68A37D65C99CB651B76FA53A6A3ED2D277B8C0B8128324A81122A70D8EBCF4E36FD0665D1959C8DA858E6764E6223F0C19D2DD9B51EF6FAAF352BF31AFE05CDDE26DA801B74CD583138ACF997DBFA057B7C86549C31F256F9A2AE31AE829A5AD5111F424F80A5ABE312C060114AD79724E4F5D320805DEF02DC80FE59F1AE779AE1816C69EF046B884D284A17FC5C5349DA4A2DD1CAB8DA59180C28E27A375EF079B40643199BBD48C7D985F56536165D02300773C2097B5A90DB3B22D0D45FBC4B4B413C4044CD909509F51C1C39E4DB29F02F7F56A0828504AA64CDAD8C2ABE3ABF21B0C1472B9D3A8E5280217C63C00E4499665A7D140DCB8B955A7C1A163B9C6CFEB7FBC000246687D9F5EABA387D75067CD86694AC14EE49409DFEC381E26AF560031E589E33E8AAC74CCAA24634C7C306F2B579339AD4B0368F7ACA8B546A0594C8DEEDB2E008F79CBE0FC33A69ADF270AAF19EFFB14B816DB9045BE1B729040DAD4EBC115426E03807BFAD9BB3ECCAD275F7A796D8CE8259B80DF6C96CE8C9EA08EDFDF230224172860D5F454D9251728800FE119899D3AAC3BFC24B37BEFA86277259DBC3A8496F33AC770592FA1976C278B9D0A663BE56C248082109B0A3A5809EDBA34AC90E4D02FDA340B97197D596F9D8FF557979F76229975738E40B69DCAFDB66C5AFD195F9379C5858C09F9D309E"}})
                    if not success then
                        return false, "Http Error "..result
                    elseif not result.Success then
                        return false, "Http Error2 "..result.StatusMessage
                    else
                        bodyResult = HS:JSONDecode(result.Body).data;
                        for num = #bodyResult,1,-1 do--for num, val in ipairs(bodyResult) do
                            local val = bodyResult[num];
                            if val.isEditable then
                                val.SortName = val.name
                            else
                                table.remove(bodyResult,num)
                            end
                        end
                        C.getgenv().Outfits[selectedName.UserId] = bodyResult;
                    end
                end
                for num, val in ipairs(bodyResult) do
                    results..="\n"..num.."/"..val.name
                end
                return true, results
            end,
        },
        ["teleport"]={
            Parameters={{Type="Player",ExcludeMe=true}},
            AfterTxt="",
            Run=function(self,args)
                local theirPlr = args[1][1]
                local theirChar = theirPlr.Character
                if not theirChar then
                    return false, `Character not found for {theirPlr.Name}`
                end
                local HRP = theirChar:FindFirstChild("HumanoidRootPart")
                if not HRP then
                    return false, `HRP not found for {theirPlr.Name}`
                end
                C.CommandFunctions.unfollow:Run()
                C.DoTeleport(HRP.CFrame * CFrame.new(0,0,3))
                return true,nil--theirPlr.Name
            end,
        },
        ["time"]={
            Parameters={},
            AfterTxt="Connected for %i m, %.1f s (%is total)",
            Run=function(self,args)
                return true,math.floor(time()/60), time()%60, time()
            end,
        },
        ["follow"]={
            Parameters={{Type="Player"},{Type="Number",Min=-MaxRelativeDist,Max=MaxRelativeDist,Default=5}, {Type="Number",Min=-MaxRelativeDist,Max=MaxRelativeDist,Default=0}},
            AfterTxt="",
            Priority=-3,
            isFollowing=-1,
            ForcePlayAnimations={},
            MyPlayingAnimations={},
            Run=function(self,args)
                local theirPlr = args[1][1]
                local theirChar = theirPlr.Character
                if not theirChar then
                    return false, `Character not found for {theirPlr.Name}`
                end
                local HRP = theirChar.PrimaryPart
                if not HRP then
                    return false, `HRP not found for {theirPlr.Name}`
                end
                local dist = args[2]=="" and 5 or tonumber(args[2])
                if not dist then
                    return false, `Invalid Number {args[2]}`
                end

                --C.CommandFunctions.follow.isFollowing = theirPlr.UserId
                --print("Set To",C.CommandFunctions.follow.isFollowing,theirPlr.UserId)

                local saveChar = C.char
                C.CommandFunctions.unfollow:Run()
                if not theirPlr or theirPlr == C.plr then
                    return true
                end
                C.isFollowing = theirPlr
                RunS:BindToRenderStep("Follow"..C.SaveIndex,69,function(delta: number)
                    --print(plr:GetAttribute("isFollowing") ~= theirPlr.UserId,plr:GetAttribute("isFollowing"),theirPlr.UserId)
                    --while isFollowing == theirPlr and HRP and HRP.Parent and saveChar.Parent and not C.C.isCleared do
                    --if (plr:GetAttribute("isFollowing") ~= theirPlr.UserId or not HRP or not HRP.Parent or C.C.isCleared) then
                    --	return
                    --end
                    if not theirPlr.Parent or theirPlr.Parent ~= PS then
                        C.CommandFunctions.unfollow:Run()
                        C.CreateSysMessage(`Followed User {theirPlr.Name} has left the game!`)
                        return
                    end
                    if not HRP or not HRP.Parent then
                        theirChar = theirPlr.Character
                        if theirChar and theirChar.PrimaryPart then
                            HRP = theirChar.PrimaryPart
                        end
                    end

                    local setCFrame = dist == 0 and HRP.CFrame or CFrame.new(HRP.CFrame * Vector3.new(0,0,dist),HRP.Position)

                    setCFrame += HRP.AssemblyLinearVelocity * 0.06 -- Ping

                    C.DoTeleport(setCFrame)

                    if C.char and C.char.PrimaryPart and not C.CommandFunctions.fling.FlingThread then
                        C.char.PrimaryPart.AssemblyAngularVelocity = Vector3.new()
                        C.char.PrimaryPart.AssemblyLinearVelocity = Vector3.new()
                    end
                    --[[for num, animTrack in ipairs(saveChar.Humanoid.Animator:GetPlayingAnimationTracks()) do
                        if animTrack then
                            local myAnimTrack = C.CommandFunctions.follow.MyPlayingAnimations[animTrack]
                            if not myAnimTrack then
                                myAnimTrack = C.human.Animator:LoadAnimation(animTrack.Animation)
                                table.insert(C.CommandFunctions.follow.ForcePlayAnimations,animTrack)--C.C.human:LoadAnimation(animTrack.Animator)
                                C.CommandFunctions.follow.MyPlayingAnimations[animTrack] = myAnimTrack
                            end
                            myAnimTrack:AdjustSpeed(animTrack.Speed)
                            if animTrack.IsPlaying then
                                myAnimTrack:Play()
                            else
                                myAnimTrack:Stop()
                            end
                        end
                    end--]]



                    -- * CFrame.new(0,C.getHumanoidHeight(C.char),dist))
                    --task.wait()
                    --end
                    --if isFollowing == theirPlr then
                    --	isFollowing = false
                    --end
                end)
                --task.spawn(function()
                --end)
                return true
            end,
        },
        ["unfollow"]={
            Parameters={},
            AfterTxt="%s",
            RunOnDestroy=function(self)
                self:Run({})
            end,
            Run=function(self,args)
                if not C.isFollowing then
                    return false, "Not Following Any User ("..tostring(C.isFollowing)..")"
                end
                local theirPlr = C.isFollowing
                local str = `{theirPlr or 'Unknown'}`
                C.isFollowing = nil
                --C.CommandFunctions.follow.isFollowing = -1
                RunS:UnbindFromRenderStep("Follow"..C.SaveIndex)
                for num, myAnimTrack in pairs(C.CommandFunctions.follow.MyPlayingAnimations) do
                    myAnimTrack:Stop(0)
                end
                C.CommandFunctions.follow.MyPlayingAnimations = {}
                C.CommandFunctions.follow.ForcePlayAnimations = {}
                return true,str
            end,
        },
        ["rejoin"]={
            Parameters={{Type="Options",Default="same",Options={"same","new","small","any"}}},
            AfterTxt="%s", Connection = nil,
            Run=function(self,args,promptOverride)
                --local RootPlaceInfo = AS:GetGamePlacesAsync():GetCurrentPage()[1]
                --local RootPlaceId = RootPlaceInfo.PlaceId
                --if game.PlaceId ~= RootPlaceId then
                    --if not promptOverride and not C.Prompt("Join Root PlaceID?","Are you sure that you want to rejoin? This will take you to the Root Place: "..RootPlaceInfo.Name,"Y/N") then
                    --    return true, "Cancelled"
                    --end
                    --RootPlaceId = game.PlaceId
                    --if args[1] == "same" then
                        --args[1] = "any"
                    --end
                --end
                local RootPlaceId = game.PlaceId
                if args[1] == "new" or args[1] == "small" then
                    local result, servers = pcall(game.HttpGet,game,`https://games.roblox.com/v1/games/{RootPlaceId}/servers/0?sortOrder={
                        args[1]=="small" and 1 or 2}&excludeFullGames=true&limit=100`)
                    if not result then
                        return false, "Request Failed: "..servers
                    end
                    local result2, decoded = pcall(HS.JSONDecode,HS,servers)
                    if not result2 then
                        return false, "Request Decode Failed: "..decoded
                    end

                    local ServerJobIds = {}

                    for i, v in ipairs(decoded.data) do
                        if v.id ~= game.JobId then
                            ServerJobIds[#ServerJobIds + 1] = v.id
                        end
                    end
                    local bool = #ServerJobIds ~= 0
                    if not bool then
                        return false, "No other servers found. Try ;rejoin any"
                    end

                    local random = C.Randomizer:NextInteger(1,#ServerJobIds)
                    --TeleportS:TeleportToPlaceInstance(game.PlaceId,ServerJobIds[random],C.plr)
                    C.ServerTeleport(RootPlaceId,ServerJobIds[random])
                elseif args[1] == "any" then
                    C.ServerTeleport(RootPlaceId,nil) -- Leave blank to indicate that you want to join any server
                elseif args[1] == "same" then
                    --TeleportS:TeleportToPlaceInstance(game.PlaceId,game.JobId,C.plr)
                    if #PS:GetPlayers() <= 1 then
                        --return false, "Requires at least 1 other player. Try ;rejoin any"
                    end
                    C.ServerTeleport(RootPlaceId,game.JobId)
                else
                    error("[Commands]: Teleport Cmd Invalid Arg[1] "..args[1])
                end
                self.Connection = TeleportS.TeleportInitFailed:Connect(function(player, teleportResult, errorMessage, placeId, teleportOptions)
                    if player ~= C.plr then
                        return
                    end
                    print("ErrorMsg",errorMessage)
                    self:Run({"any"})
                    GuiService:ClearError()
                end)
                local MyConn = self.Connection
                task.delay(20,function()
                    if self.Connection == MyConn then
                        self.Connection:Disconnect()
                        self.Connection = nil
                    end
                end)
                return true, args[1]:sub(1,1):upper() .. args[1]:sub(2) .. " Server"
            end,
        },
        ["console"]={
            Parameters={},
            AfterTxt="%s",
            Run=function(self,args)
                SG:SetCore("DevConsoleVisible",not SG:GetCore("DevConsoleVisible"))
                return true
            end,
        },
        ["unfling"]={
            Parameters={},
            AfterTxt="%s",
            --RunOnDestroy=function(self)
            --    self:Run({})
           -- end,
            ResetVel = function(self)
                if C.char then
                    for num, part in ipairs(C.char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            C.hrp.AssemblyLinearVelocity = Vector3.zero
                            C.hrp.AssemblyAngularVelocity = Vector3.zero
                        end
                    end
                end
            end,
            Run=function(self,args,notpback,nodeletethread)
                if self.Parent.fling.FlingThread then
                    if not nodeletethread then -- if its not our current thread
                        C.StopThread(self.Parent.fling.FlingThread)
                    end
                    self.Parent.fling.FlingThread = nil
                end
                self.Parent.fling:SetFling(false)
                self.Parent.unfollow:Run()
                if C.hrp then
                    C.hrp.AssemblyLinearVelocity, C.hrp.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
                end
                self:ResetVel()
                if notpback and not self.OldLoc and C.hrp then
                    self.OldLoc = C.hrp:GetPivot()
                elseif not notpback and self.OldLoc and C.char then
                    C.human:ChangeState(Enum.HumanoidStateType.Landed)
                    task.spawn(C.char.PivotTo, C.char, self.OldLoc)
                    self.OldLoc = nil
                end
                return true
            end,
        },
        ["servers"]={
            Parameters={},
            AfterTxt="%s",
            Run=function(self,args)
                C.ToggleServersVisiblity()
                return true, ""
            end,
        },
        ["places"]={
            Parameters={},
            AfterTxt="%s",
            Run=function(self,args)
                C.ToggleServersVisiblity("Place")
                return true, ""
            end,
        },
        ["friends"]={
            Parameters={},
            AfterTxt="%s",
            Run=function(self,args)
                C.ToggleServersVisiblity("Friend")
                return true, ""
            end,
        },
        ["fling"]={
            Parameters={{Type="Players"},{Type="Number",Min=-MaxFlingSpeed,Max=MaxFlingSpeed,Default=5}},
            AfterTxt="%s",
            FlingThread=nil,
            OldLoc=nil,
            ActionFrame=nil,
            SetFling=function(self,enabled,speed,doLoopFling)
                if enabled then
                    C.SetPartProperty(workspace,"FallenPartsDestroyHeight", "fling",-1e4)
                else
                    C.ResetPartProperty(workspace,"FallenPartsDestroyHeight","fling")
                end
                RunS:UnbindFromRenderStep("Spin"..C.SaveIndex)
                if enabled then
                    C.AddOverride(C.hackData.Blatant.Noclip, "fling")
                    RunS:BindToRenderStep("Spin"..C.SaveIndex,69,function()
                        if C.hrp and self.Enabled then
                            C.hrp.AssemblyAngularVelocity = Vector3.new(1,0,1) * (speed or 1)*1e4
                            C.hrp.AssemblyLinearVelocity = Vector3.zero
                        end
                    end)
                    self.ActionFrame = C.AddAction({Name="fling",Title=`{doLoopFling and "Loop " or ""}Flinging..`,Tags={"RemoveOnDestroy"},
                    Time=function(ActionClone,info)
                        ActionClone.Time.Text = "Loading.."
                    end,Stop=function(onRequest)
                        self.Parent.unfling:Run()
                    end,}) or self.ActionFrame
                else
                    C.RemoveOverride(C.hackData.Blatant.Noclip, "fling")
                    C.RemoveAction("fling")
                    C.Spectate(C.plr.Character)
                end
                self.Enabled = enabled -- Toggle Events
                self.Events.MyCharAdded(self,C.plr,nil,nil)
            end,
            Run=function(self,args,doLoopFling)
                C.TblRemove(args[1],C.plr) -- don't fling yourself!
                if #args[1] == 0 then
                    self.Parent.unfling:Run() -- teleport back too!
                else
                    self.Parent.unfling:Run(nil,true,false)
                end
                if #args[1] == 0 then
                    return true, "Stopped"-- do nothing if there's nothing to fling or just yourself!
                end
                local wasSeated = C.human:GetState() == Enum.HumanoidStateType.Seated
                self.FlingThread = task.spawn(function()
                    local FallenDestroyHeight = C.GetPartProperty(workspace,"FallenPartsDestroyHeight")
                    repeat
                        for num, thisPlr in ipairs(args[1]) do
                            self:SetFling(true,args[2],doLoopFling)
                            local LastSpeedTime
                            for i = 0,30,1 do
                                local theirChar = thisPlr.Character
                                local theirHuman = theirChar and theirChar:FindFirstChild("Humanoid")
                                local theirPrim = theirChar and theirChar.PrimaryPart
                                if C.hrp and theirPrim and not PhysicsService:CollisionGroupsAreCollidable(C.hrp.CollisionGroup,theirPrim.CollisionGroup) then
                                    C.CreateSysMessage(`Fling cannot work because you  with {thisPlr.Name}!`)
                                    task.spawn(self.Parent.unfling.Run,self.Parent.unfling)
                                    return
                                end
                                if self.ActionFrame:FindFirstChild("Time") then
                                    self.ActionFrame.Time.Text = `{thisPlr.Name} ({i}/30)`
                                end
                                C.Spectate(theirChar)
                                local exit = false
                                local timeLeft = 0
                                repeat
                                    if thisPlr.Parent ~= PS or not theirChar or not theirHuman or theirHuman:GetState() == Enum.HumanoidStateType.Dead or theirHuman.Health <= 0 or not theirPrim then
                                        exit = true
                                        break
                                    end
                                    if (theirPrim.AssemblyAngularVelocity).Magnitude > 50 then
                                        if not LastSpeedTime then
                                            LastSpeedTime = os.clock()
                                        elseif (os.clock() - LastSpeedTime > 1) then
                                            exit = true
                                            break -- We did enough damage!
                                        end
                                    else
                                        LastSpeedTime = nil
                                    end

                                    if C.hrp then
                                        local SeatPart = theirHuman.SeatPart
                                        local Target
                                        if not SeatPart or not SeatPart.Parent then
                                            Target = thisPlr.Character:GetPivot()
                                            Target += theirPrim.AssemblyLinearVelocity * .06
                                        else
                                            Target = SeatPart.Parent:GetPivot()
                                        end

                                        if Target.Y < FallenDestroyHeight + 12 then
                                            Target += Vector3.new(0, FallenDestroyHeight - Target.Y + 12,0)
                                        end
                                        C.DoTeleport(Target)
                                    end
                                    timeLeft += task.wait(1/6)
                                until timeLeft >= 0.15

                                if exit then
                                    break
                                end
                            end

                            if not wasSeated and C.human:GetState() == Enum.HumanoidStateType.Seated then --check if seated
                                C.human:ChangeState(Enum.HumanoidStateType.Running) --get out if you are
                            end
                        end
                        if doLoopFling then
                            task.wait(.15)
                        end
                    until not doLoopFling
                    self.Parent.unfling:Run(nil,false,true)
                end)
                return true
            end,
            Events={MyCharAdded=function(self,theirPlr,theirChar,firstRun)
                C.SetHumanoidTouch(self.Enabled,"fling")
            end}
        },
        ["lfling"]={
            Parameters={{Type="Players"},{Type="Number",Min=-MaxFlingSpeed,Max=MaxFlingSpeed,Default=5}},
            AfterTxt="%s",
            Run = function(self,args)
                return self.Parent.fling:Run(args,true)
            end
        },
        --["nick"]={
        --    Parameters={{Type="Players"},{Type="String",Min=1, Max = 20,Optional = true}},
        --    Run = function(self, args)
        --        local nickName = args[2]
        --        if nickName == "" then
        --            for num, theirPlr in ipairs(args[1]) do
        --                self.PlayerInstances[theirPlr] = nil
        --            end
        --        else
        --            for num, theirPlr in ipairs(args[1]) do
        --                self.PlayerInstances[theirPlr] = self.PlayerInstances[theirPlr] or {}
        --            end
        --        end
        --        C.ClearFunctTbl(self.Functs)
        --        local function NewInsert(newChild)
        --            if (newChild:IsA("TextLabel") and newChild.Text == )
        --        end
        --        table.insert(self.Functs, game.DescendantAdded:Connect())
        --    end,
        --    PlayerInstances = {},
        --    PlayerConnections = {},
        --    Functs = {},
        --},
    }
end