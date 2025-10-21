--print("Begin Loading Main")

local PS = game:GetService("Players")
local RunS = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")
local HS = game:GetService("HttpService")
local CG = game:GetService("CoreGui")
local SP = game:GetService("StarterPlayer")
local MPS = game:GetService("MarketplaceService")
local TextChatService = game:GetService("TextChatService")
local VirtualUser = game:GetService("VirtualUser")
local LS = game:GetService("Lighting")

--print("services loaded")

local PreCached = true
local isStudio = RunS:IsStudio()
local PrintName = "[Module Loader]"

if isStudio then
	task.wait(1 - time())
end

local C = {}
local allDisabled = {
	firetouchinterest = false,
}
local executorName = not isStudio and identifyexecutor()
local enExecutor = (isStudio and allDisabled) or (executorName=="Cryptic" and {firetouchinterest=true}) or {firetouchinterest=true}
C.Executor = executorName
--print("1")
local function RegisterFunctions()
	local firetouchinterest = firetouchinterest
	if not enExecutor.firetouchinterest or not firetouchinterest then

		firetouchinterest = function(part1,part2,number)--creates a fake touch function
			local thread
			thread = task.spawn(function(dt)
				C.SetPartProperty(part2,"CanCollide","firetouchinterest",false)
				C.SetPartProperty(part2,"Transparency","firetouchinterest",1)
				C.SetPartProperty(part2,"Size","firetouchinterest",Vector3.one * 1e3)
				C.SetPartProperty(part2,"CFrame","firetouchinterest",part1:GetPivot() * CFrame.new(Vector3.new(0,0,-2)+part1.AssemblyLinearVelocity/60))
				C.SetPartProperty(part2,"Anchored","firetouchinterest",false)
				local touching = 0
				while true do
					if table.find(part2:GetTouchingParts(), part1) then
						touching+=1
						if touching==4 then break end
					else
						touching = 0
					end
					part2.AssemblyLinearVelocity = (part1.Position - part2.Position) * 60 --* (6*(1+part1.AssemblyLinearVelocity.Magnitude))
					RunS.PreSimulation:Wait()
				end
				C.ResetPartProperty(part2,"CanCollide","firetouchinterest")
				C.ResetPartProperty(part2,"Transparency","firetouchinterest")
				C.ResetPartProperty(part2,"Size","firetouchinterest")
				C.ResetPartProperty(part2,"CFrame","firetouchinterest")
				C.ResetPartProperty(part2,"Anchored","firetouchinterest")
			end)
			C.StopThread(thread)
		end
	end
	--Generic Functions
	function C.yieldForeverFunct()
		game:WaitForChild("SuckMyPPOrYoureGay",math.huge)
	end
	--Studio Functions
	C.checkcaller = isStudio and (function() return true end) or checkcaller
	C.getconnections = isStudio and (function(signal) return {} end) or getconnections
	C.getrenv = isStudio and function() return _G end or getrenv
	C.getgenv = isStudio and function() return _G end or getgenv
	C.getsenv = isStudio and (function() return {} end) or getsenv
	C.getgc = isStudio and function () return {} end or getgc
	C.loadstring = isStudio and function() return function() end end or loadstring
	C.getnamecallmethod = isStudio and (function() return "" end) or getnamecallmethod
	C.getcallingscript = isStudio and (function() return nil end) or getcallingscript
	C.hookfunction = isStudio and function(a,b) return C.checkcaller end or hookfunction
	C.hookmetamethod = isStudio and function() return end or hookmetamethod
	C.newcclosure = isStudio and function(funct) return funct end or newcclosure
	C.gethui = isStudio and function() return C.PlayerGui end or gethui
	C.getgenv().setfpscap_function = nil
	C.setfpscap = setfpscap or function(TARGET_FRAME_RATE)
		assert(TARGET_FRAME_RATE, "[C.setfpscap]: TARGET_FRAME_RATE is nil or false!")

		if C.getgenv().setfpscap_function then
			C.RemoveGlobalConnection(C.getgenv().setfpscap_function)
		end
		if TARGET_FRAME_RATE == 0 or not TARGET_FRAME_RATE then
			C.getgenv().setfpscap_function = nil
		else
			local frameStart = os.clock()
			C.getgenv().setfpscap_function = C.AddGlobalConnection(RunS.PreSimulation:Connect(function()
				while os.clock() - frameStart < 1 / TARGET_FRAME_RATE do
					-- We do nothing until the target time has elapsed
				end
			
				-- Mark the start of the next frame right before this one is rendered
				frameStart = os.clock()
			end))
		end
	end
	C.firetouchinterest = function(part1,part2,number)
		if not firetouchinterest then
			return
		end
		local CanTouch1, CanTouch2 = part1.CanTouch, part2.CanTouch
		part1.CanTouch, part2.CanTouch = true, true
		if part1.Parent and part2.Parent then
			if number then
				pcall(firetouchinterest,part1,part2,number)
			else
				pcall(firetouchinterest,part1,part2,0)
				task.spawn(pcall,firetouchinterest,part1,part2,1)
			end
		end
		part1.CanTouch, part2.CanTouch = CanTouch1, CanTouch2
	end
	local keyCodeMap = {
		[Enum.KeyCode.A] = "0x41",
		[Enum.KeyCode.B] = "0x42",
		[Enum.KeyCode.C] = "0x43",
		[Enum.KeyCode.D] = "0x44",
		[Enum.KeyCode.E] = "0x45",
		[Enum.KeyCode.F] = "0x46",
		[Enum.KeyCode.G] = "0x47",
		[Enum.KeyCode.H] = "0x48",
		[Enum.KeyCode.I] = "0x49",
		[Enum.KeyCode.J] = "0x4A",
		[Enum.KeyCode.K] = "0x4B",
		[Enum.KeyCode.L] = "0x4C",
		[Enum.KeyCode.M] = "0x4D",
		[Enum.KeyCode.N] = "0x4E",
		[Enum.KeyCode.O] = "0x4F",
		[Enum.KeyCode.P] = "0x50",
		[Enum.KeyCode.Q] = "0x51",
		[Enum.KeyCode.R] = "0x52",
		[Enum.KeyCode.S] = "0x53",
		[Enum.KeyCode.T] = "0x54",
		[Enum.KeyCode.U] = "0x55",
		[Enum.KeyCode.V] = "0x56",
		[Enum.KeyCode.W] = "0x57",
		[Enum.KeyCode.X] = "0x58",
		[Enum.KeyCode.Y] = "0x59",
		[Enum.KeyCode.Z] = "0x5A",
		[Enum.KeyCode.Space] = "0x20",
		[Enum.KeyCode.LeftShift] = "0xA0",
		[Enum.KeyCode.RightShift] = "0xA1",
		[Enum.KeyCode.LeftControl] = "0xA2",
		[Enum.KeyCode.RightControl] = "0xA3",
		[Enum.KeyCode.LeftAlt] = "0xA4",
		[Enum.KeyCode.RightAlt] = "0xA5",
		[Enum.KeyCode.Escape] = "0x1B",
		[Enum.KeyCode.Return] = "0x0D",
		[Enum.KeyCode.Backspace] = "0x08",
		[Enum.KeyCode.Tab] = "0x09",
		-- Add more mappings as needed
	}
	function C.firekey(keyCode: Enum.KeyCode,enabled: boolean | nil)
		local virtualKeyCode = keyCodeMap[keyCode]

		if virtualKeyCode then
			if enabled then
				VirtualUser:SetKeyDown(virtualKeyCode)
			elseif enabled == false then
				VirtualUser:SetKeyUp(virtualKeyCode)
			else
				VirtualUser:SetKeyDown(virtualKeyCode)
				RunS.RenderStepped:Wait()
				VirtualUser:SetKeyUp(virtualKeyCode)
			end
		else
			warn("KeyCode not mapped: " .. tostring(keyCode))
		end
	end
	C.fireclickdetector = isStudio and function() return end or fireclickdetector
	function C.firesignal(Signal, ...)
		for num, mySignal in ipairs(C.getconnections(Signal)) do
			local Enabled = mySignal.Enable
			if not Enabled then
				mySignal:Enable()
			end
			mySignal:Fire(...)
			if not Enabled then
				mySignal:Disable()
			end
		end
	end
	function C.fireproximityprompt(ProximityPrompt, Amount, Skip)
		assert(ProximityPrompt, "Argument #1 Missing or nil")
		assert(typeof(ProximityPrompt) == "Instance" and ProximityPrompt:IsA("ProximityPrompt"), "Attempted to fire a Value that is not a ProximityPrompt")

		local HoldDuration = ProximityPrompt.HoldDuration
		if Skip then
			ProximityPrompt.HoldDuration = 0
		end

		for i = 1, Amount or 1 do
			ProximityPrompt:InputHoldBegin()
			if Skip then
				local Start = os.clock()
				repeat
					RunS.Heartbeat:Wait()
				until os.clock() - Start > HoldDuration
			end
			ProximityPrompt:InputHoldEnd()
		end
		ProximityPrompt.HoldDuration = HoldDuration
	end
	C.setclipboard = isStudio and function() return end or function(input: string, notifyMsg: string)
		setclipboard(tostring(input))
        C.AddNotification(`Copied{notifyMsg and " " .. notifyMsg or ""}`,`Successfully copied to clipboard!`)
	end
	C.getloadedmodules = isStudio and function() return {C.PlayerScripts.PlayerModule.ControlModule} end or getloadedmodules
	C.getrunningscripts = isStudio and function () return {} end or getrunningscripts
	C.getinstances = isStudio and function () return game:GetDescendants() end or getinstances
	C.request = not isStudio and request
	C.isfolder = not isStudio and isfolder
	C.readfile = isStudio and function(path) local mod = C.StringFind(LS, `Files/{path}`, "/") return mod and C.require(mod) end or readfile
	C.isfile = isStudio and function(path) return C.readfile(path) ~= false end or isfile
	C.makefolder = not isStudio and makefolder
	C.writefile = not isStudio and writefile
	C.setscriptable = not isStudio and setscriptable
	C.request = isStudio and function() end or request
	local requireFunctsToRun = isStudio and {require} or {getrenv().require,require,getsenv}
	function C.require(ModuleScript: Script)
		local success, result
		for num, funct in ipairs(requireFunctsToRun) do
			success, result = pcall(funct,ModuleScript)
			if result ~= "Cannot require a non-RobloxScript module from a RobloxScript" then
				break
			end
		end
		if not success then
			warn("[Specter C.require]: Failed To Load Module "..tostring(ModuleScript)..": "..tostring(result))
			C.yieldForeverFunct()
		end
		return result
	end

	--Important In-Game Functions
	function C.GenerateGUID()
		return HS:GenerateGUID(false)
	end
end

RegisterFunctions() -- Loads Studio and Hack Compatiblity
C.AuthenticationTokens = {"E1A20E20BC76E4DEEBEAC13AAFA9A5C033DCD7073FD11265C333B100F358FA6032CD1D08E717A2BA76B2C25B904152CDABDFCF16AC0649C6DBAB767A91731273AC084CF3375EA436519D6BEA35FDB8B73E4948CE576D703451CE9662ED9ED19F96437AAF9E7DB5F6B8AFB6483E397D203553853708FB594601A1D52DADB80D4EEC9AFE7D189B935A31B31598A5C2B5EA827C5BE16683C9110A3CCD2BFCB129E580621F85065910477CDFBA4AB94B68500C41BCB333B4A78DCC5066596E69F465AB8E9EF21E279B7E30DF9302CD765A6296A1DC4BF7467D06F2FB5781923E4E6828F8DB5F3554F54C73B6FA0C926C8ED7BF39FD6A1FCF19AB2EFC15B049AE7A234E4DD5F87A3D448DC6089DEEA14AC246854E63C058F46571D9D6F3809C4579F6695956F44FD691574C52BDDF8797DDC1933AA1E596048353421A62D0CFB056DBB20B69F0F18121CE218BBBB0134F263EEAF0E5673D77E28E7FB730D83748342EF92C00048A703FD83513728EEACC8F4E6980FB1ADB87C445080AA529C45A46EDA6FA135371CABA0BC1B75B072FBF1462A0DC61424569EA18ED29B0687408ADBD9ED634F4C3038B47F7693B60DA0E9BC6656B6D6C83A97604CE1…",
    "5B517736612854890E25C0953E3A73761C4E295EDDC7EA35D1D9F881CB9CD0077B2D8E195F593BC08AE0351C42ED60786BE49DC7886291E4679F1704044BAE257A0CB596CB6D8787FDD4201D5F34E90F2226DE8E6BFE80DB5C04B4496CB1928E73101B81EB8CF9DA265F0847C0ECF21D545C38EB95D1993C22407C19A8626A426C46FEA8F0FB94EA64CE84EAD75F574F2B25AB51035B0BF8E69F126CD61352B3CDF1138E9E70C41D6D6B821E8E1D97CF1BDD8E7297D19135DE47C65E96ECFDF019076B7C425CCFD4D090C0B96038C44D4C0AECF75A174EA961615BD35052CEADBAA28B7D428D5C357D0808E2723972A2558A50C320576F83CD82FADBDB3C5182D7856A837F03DF04237BB698D132B8EF8BE8A60E7F177F001FD25A672375CC639F9BA4680430071EBCB6483ADA3718D3611E6DC21C2B72EF335C35BC66A7A31446D96FEFCF31B3D2CD23865EAA56F618A3C22F0F5938084CB9256531550135DEAB9DAF31243C0062E503EEA7BF941DFF606AE24F2DA0ACDD45D37045CCF924DB170DC31ED0826EFF863ED70724A3B1D917E38E0B5713EE89191EC9032C2403E99D2DDF0E3A62CEFB6D98FD0277EBEFE34864DD350459D3AE9CA",
	"EA77C5C16FC3B13DBE51983F1603A9902595AF5EC8B60C8D8D66E9B5CB424C6D1BED7D39FDDC1663093C9D767D6BE9843FACF45D1AB7E846E73B78C6C7A29ED9E84747E859A1D1441D557D434B56CA9FA747511A789ABF60E42509C39B812A74124D2E52C9F4C6CEAC893570BE9DA5BF660660ABAA431426B210787862AE073BBFF0AE04524CD123D3B24DAFF311EBA429CC0BC3F52731372C34B5A3F3DB9F7C314CBB15530C04C3D7F8C339C49C6A54F1867705A13AA8068EDAEBF6F3EC369AA465CE5FBFDD559E5DABC4CDD18E848D6AB3006B5ADF33183DD8070999B98DBED22A1816C01DC167D6A729A74342B72C5209768378A84ED50DC32D4F63EBB3067B7A2C899EA6EA1FCA9CB20D82EE222E63254CE278ED53EC8E650EAAF55B6A5656A992FE7380DB6BB8191DD8C717FA7FED1A6875D0ABCB39B2E0D152679EB19B4C9602CEDDC149916836EDB06E6975F1804AB801E7D99CE2807FEABDCF8384DF74B1B109E316FCAE60F1BD2119D5DB62294C9472E0D64EE3649AFAFB1B0BE3D22FDDCABFEF3526ABAFA7EBF700B78AF193949345B75C925C18002EA45A34D3BC60577685616B833254AE196A1F4A306B3186A329DC08C0C9368…",
	"3CE6A9D4E9E23BBEA603898C18CD84D57FFBA10C22C0AAC9290280FD7E0C9064040CF1644694D04707B0B3D854BE21B06697912CE59DEB9BB29898879282602904469640344DFEC3622B56321C5356D5846C3B58E8B013FCFDFB610F4E08A76E687A127D34C3E9FF7032AAB224798288A47F45D3B4EBD0450C6669C4AD2000436D819F7A75FDECADB6896BED08B4026728B601342E4862325765030FC26066D729C289501D4800BEFED500BAD39977E527581C5DF28E9E01AA6E4D4215E47CA71EE962673BD90A6C1E4D5F4E8EDDC991B5DDBA8CCBF61F444BAE78CEF67982110E3F421D3FE6FD37776B655A95D53518847D2CE1FDAE284F78EBFC529A6802E3899665B96D3E59587EF3E4BB5288F532410DFCFF4B181032A9905BF721D625891099EFB743079C66AA745EACE791DA4F66003C295F82DF60710669EAC254EE9F8C8D23E8B8A7955F660796DC960A3DA5E710A3F59B0FCD30BA8DA4732A8B83F3746F783A6C0DA4374DDE7AFA62289252E7DEE1FD2293AB2830099FAC350D8ACAA89E132C24A39D92A3B3CC92AB65DA8FFD7611C3F1C34E2A3D4E4516043E6C495FB6CB544C5B38DFEA98EA0FBEFE35A86C1426DCC0CB17185E4…",
	"A6BF75A9E9B5028C36CB67E60F984C5D68746BBEC7CBF731943468E1408EED818E9E19356B839A3A958BC478C94C8C514B2BEAB9A9BE459B61FA5CD46DAAFBEBF8CE2ABCA10EED072F895D6592C78B11F215A6090B13AC31D9426CC18B0B62D2EE6A2ED9231BB08CC882EC5CF1CD6DAC22F35A6CD5BF95A22599693F5104A77496A438706BB88E4F1B79F25FC14C57DBA1146B9D185FD24EC08103C1F46C142176BAFBF46E21C85A2252218743C3071AE10ECFC84A6ABF11AC1E50361418C7DFA6B8A370E911DB1B0325D66EA6CBEA4787F653528A8D187285D90EC95D350AAAE92A2BE01B81D424ACA6573ADB6FB1AE262D677B5418FD22D6F86759B9EBD856F1C60C79A61FECEF077308DC1CF7296B2EF8DC4E3D9B9A7C15FD8C96F4494AD206EE8EF20A5CF567687D42548E9BBAB8F41043CB272D3DF371FF4BA0AB077B388252D839C6640507EA2A95B8A46C098BB0D873A57750D3ED1972A30E540A2F4FBDF0773E6778694B9B6F9DCE0017EBDB9463DE7680E28B629144599F7076734DD0435F7D93DA8FA4680432A059D93934C6626FD2D888ED8D90D4442DB9CEA23857C335761A82DDEEFA9A5D1BE8037AD094FDBF34AE1D18C3995A77DD38DCF3FF00ED3EE6B0958A1836AEAA391FF358FB068A67A12579180AF7E4EF4C16D8DAC61DEEB40FCAB7D1F1CC44CD54EF7C40B7DFA7D8B75D7B3FBFC7DEE1A49CB078E8E8CAC7EF282AABB7BF6FC5C4A953F6E9CF4FE96160950B13200CD41B82A6227BFAD76E43BF071A7E289EED2D4F49112ACC41999FFD59B39802A2EE5DBF7ECAC7B2994C835CFA3CFF9D4542A70FF15EAEA97105DA4FE05F367E1D5DCCDF686222A91EEF53BECAD6C3C99B7BBE884B2C61370237CEAA4DEFED8DFCBC74D79B805F986BFFBF99DBB16ADD9A541CDBC43415883C5440466768869C22C3BFC39D1BA9FEE8D4D2DE01C309C8F4457933393710F7654EBD2B273FCFFC1A064222D562A061E4975824C632E1BD67D09D5F550B740BB6398B126F33367E3F69CEF4E62C4C6B8D267478088DB5E91A907E991FCD835C3D61CDC1B43D67B3E0A19C93C99BD6CCC261EE71BA82D7B635D480DCE9419FDDAA9BED",
	"B0510E7ADDF595261B43E82DAF84FC1FFF324D4A75B34DDD131FC54F2AC32CD245C7401E800DC7D7E22C820367B82C99CFBDCDF4725A061D7EAFFD581D2840D59D455158FEB25EEACFD9F273DE12D64D9FACD3342247FD125FEBC27A8656407784677970CB9E775631C6B241AFE2187AD1B5E90871BDBFC029B82C7B3FD6B1300BDF465453653F0787320697CC503F651A3B55F9EC571B089AB1E1A0B4F99BF24A53A44A8C0B982C97E62D1ADC8714C65F6D0A54D383255203D8B87988708F8FA4DAE15516ADE0BE444B247522B173AAB712E9BFCF669658D11FD5C916A959577E011A16B49C0EA7CBCB07113FE2347B7F458B6C386DC5D6E4D8E5A7E04ACFCB74BAB18EBE886D5F995171042263821E8E6E241002DF3E61AE5A46100089DFA81EC9DA5492D118FD064C60C45B158F5BDCD4397B111065EB436921ABDA8223838ABAD44DDC70601CF1B534C62570F475D76FCB116AA81CF4557C6D53455B87DBFF93EBC2DA3034333456BD84F58258C2A0895160EE36F005E22F2B0C7B748779E353A7DB97406B44B6516116D572F7B706AE62187ADC75738BAD4B61CC2FC153C8C759A0C206485DDFFF6B61959CEDCEA17D6E17855AE9CC6CE65422602EAC884192766210A78B59043B9A344C33E8DA8774E41A44BC53A38659C72984AEBE2C59382345EB48F4D0E5C0CB59F51546E51D97DF3A6843537FA9E81B8A6401B704E9F91A5419FD01A1D8FB6A4D69D730C79D619B744BC391983D6644CE3CCA007CD1720B78EF83E9382ABA3F687FB7F6D6202CFBD22B1F51B39285559E227B976377C619D4CD4EE5E83AB1E2060E33740EAB4E1C6CF90AFC093E70D516F432592EF37FEC33130FD6CA7879040948AAEA9953784CB6E24FF75F041F4E489EA050247D029D73997EEC568748B34CFB14BE78B84CAF534A9B80ED75F29B8B4C8E130C5B627B370851514A72C532A7A34C211A486D87AAD0CC46C8C49E104A98413CE3009F7A8FD76E849AE294805CA1C3EF43C17F9C9BF451995FFC7A673F05AFE6569A5847053D179D57FF41ED3888C8502F72DA2330C2C8FF5FDE4E6ECA726A99C918EDBF794E4FF3F02AB506CE54AB3CEA562F557D",
	"49CC676B4F908C803F7D4F51F2787E1426AEDAE4E5236AC8E801DA8F9C129FE166CE297F63D3CFEBD1D9C415B1891CB79A94CFE7FDA0D886DB155F8E9DBA62B3C0F0722B4D15AC90FE32E6E4C0DBF692AA35DE0E0B32F82A06A130283AA25697698AE8483266DEB7B80703D76166197D0D43C3D7EE8ECFA2471AAC9581E061C879649424429D121A07F66D58EFCD65991DD6DFF1855E1BCD7B89DA71751D52CFE422F17F4D5E25CB75A573039EE761479B67926404867D2B434904A03DA5046435C88F079F63A869802A2E940B0098999FAE8B318187840E3F5580A44C7861688AD591E0A87E5C8C6A2B28A69E2276AC562DEBFA0EC9F5B29C212825FFF3750C7F2188CBAB0988FCFA7C99054F00870C96AE96C5FBDBE53E06EC5594734FCFFC14391C74575FB56095D6A5D220CE9F827DF20CDD689A07FA1BFB2BD2417464D2D58B28FD8114428D23A0AB8E754299C3A73AF790347CFB603E17A589FE4F788FE547AED51E36470D06E52E52BEC039264F9E2DF469950F6193D786283CAE9F82EFDDA4D59A226E57520A6F0263E327EA63E7B6F15CAB91223A3086A51C325E497B88316525CA3EE533E58A1DAD9DF0E3E09D57745BD5900CEE196C996F41BEA8F55B60BEF2B129453D2DF424855F0B939532A4198FBF9FEF9CD79ADD655E41C7E5B8178F5C521E1F5495925114AE8B90A078F8CC90B1BDA2DF8B0D15ACC93173658F1A3B11AAA06C6E79B051FF9FACBD1802B69B21070FE8B59F71B66F26EB15477921DD6A427A28E02FCE4ADD9BD9EE8842E15A4EA883264CB54A1988A55DA6547EC637B191E0F271CBB180BDFE67A423C7B7AC8DA8CCDA1F2A090C5A4F13E99075912E63ED0D5B9E6FBE463FA47265845505B0EF980E56AAF7174355ABB2285D35498FB52692F619CEA743CF3F769FF5A34223DBA548502E774CA36EB4668C0FFBFF22F73B7B18D653AFF430A09D46B0F99CB7ABB75EAB21F5FD3E917778000AF15C06C4827241ADB2DC67F3A86FE92642CD05E9D3DCA3ED158E1C3F93A7756A764BD458F4724D0011C2BEE78407E88D573B68728E3CEB0C7ED349AE75276C590A0AA27C0193E7214C8F3748A8D554D878957B",
	"4C42E6493C73874F2C1E2B2646B41C99FA8D74CD9DBFF8674FAC062AC0341DB6123AFFDC68CC8E116F27EA69E4B4B030D2594F93C539678C18A3CE013351B75F6B63C3AC169346AE07A082F6D0C93FF43914DDD80C1FBACFCC05F38A634272829CDA20594FB2277D2E7BBB5FA2D9A60E9B819AF7B9C8406E90C3BE46DF0FF74EACA3F57F925BD354A43CDAC4591B591F8021EA3ACDA9E6429618150B5D86F019A39177861FA898B586B994E4E17809AD4010A65AC5C4B7BF8F5EB4BB3F860B56FFB6C3B4E589A44F9DD01A9833A03118B58AECE0502ABDFDCC0730D1DA20F71E27A395E68A807BBC92D2F96E231D82993A7F15EABA812F04CC283776A42CCF54188DE39DFE706DE2F71C28D3CB3992A5F3D6DE48F114BEAAB02C5B0AB802115F993737A87BA1CD47F348B96429916A30EE22F5B64B7307FBEDD81221061170E214988BBBF8B3FD1B9688D329E4C9D6F4CD2072B3BA66EB4BE28F85970E520AD87213C0018A173F8474560FCD92A7FA10606BF1F9EEBDDEE0E84E3805D2591E96B8F3163BAA2B856ECA0F246A7CAC50351440765F4EAB3551398B2A2AF7226D093DBFAB6F57C978E68A53FCE14A2A2A8801AE0AE6EAB39F4343BAF3A51BE1113AAC3B576A63F976C371DAE7A88CDB462C33D4BDF85B59234FF840958C1C2DEE665FDE66B1A9A1FED23BFDC4CACAAE67DCE3E3EE25C14A9AC012F7729DF24CA078FDB2E7DD0D6F606F32A3C8C4A18073DB94613FF84392BBE0A4BDB49687AB5D8AAE6D138DD33B03A88A324E914F2A87C2807D1D08B019C82E8D30897D9E9F203E5EBD75A25684BBDE604E468F557D1A6AC4EDB5A9332DC4B8F0A2E8E75E801443BB863B68A16E2DC231928485A02A49D9DE75409D0B7206B7CE42FE92CEEDFAAC09D9F97F4362493F144A37E26D393A3C5C2CC86005E5ECF75744A65E4136368F39F24A47B605AEFB72D1490DEDBECAC6EC91A7848FA1A5AFC9A53A8F6CEEC418168040FF09F3598327A528B07B31223C319230D4A99001A2C45ADB2A83D2C4AC136B5D8DBBC7763CEE394EB9CE7B66B15FF4BCABC71A26B1B5BD1452D934FEBC32A82AB0834484D33F31C431B94181CC893B315C",
	"62BEB0A1D3199CF665D57228469BE73383CE163F83054CF2193182000BF1B7C4B8592B7DDFE5EEB04311A43BF4465672857EED7AD4E56898C2D2A7367D31D7F349F48BA1CA0FA419AB82E69FC859D06FAD8C0B38E8F7EA8FD8D3FD5A0677B5AF29311409538BE0625343A64BA28C0D3D0EDE72E731846A245649213814F240436A55EB48AC4C37726C4F0586C69F5952F507F08A6F07B1F3E4F1E991604C75AA31D1BCAA32DEAC8D08E3ED575A0A0D57AE0DC10B126E219092430546B7C7EC9A8ED7A1FF65BDC56B8D7A7F454C1FC5CF109552E4F98DC3B967920F8B87362EDAE7AC7CA7D4EE63546FCF3C59F99745E1B001D1C194C99D33C58EBCA6DF6AB4AA6689E5BD799A2A424B07F607E0137188CDDB31470BA312A5416624DADEA45C65FEB778718B0C5BA4E9456333436ADE7292F4C2EB0EE87E4A323D74B1FCECD9385AF0AB80E3202F2476FBC6AFCD963AA08688A15EB194FE858AA0D77EDFCBCCA4B980FECD536EFE58BD20A43CB74AF313B75C7CEC1DFA8B4FE7985C35E13D97F35321FC550306CE7EBBEE56411F6968CA0290212C527C23B141E1680A45DF387ADEC41DD7D4BC0203927357B1A1B928536CAAA99E725B4757F122FD55FAD7D91104A3F2B0B12B60EA67984BC701223C25C6FABCC2AECDD535618256BCCC0A32A4ABB18449C94C87DC2DF30A4018E881F9EE1C40E9AEBBFEF451664DF2E1B6B7AD33FF151509DEA28E8FA41CBAD634B5B1B4D1B77F309F77FDADC41C4A4C193E22BF814CD04AF8DC3401472D26EA82B91EC5E354632AC67364975551A84E37D07FEC15CFD2B4BC2B9ED24E7CEC288921BF6BBC633081F9ED540FD15AF53BA26412C2645CABE0A2B523D5C5B1030406E4E906B183FC0BC8480982D6799D5F7271BE864406A6F10551A57FC11383C154805041E44DEE7C0750BB862421D5B344369E07EC9E1F6542604ABF939AA46E31871EA77D08542142A40FDF67BA7CC2B04E53D25C70FE472FCBC09C629942F29E0D6E7AF05E8506CD802D0D9DDA00F9996D4A717ED35D5CBF4CE13BC06771DE4B2AB0747CA45E0731FD3FF2E6DBF0F5A060EE8474F077ABBE0559D5452908ACAE3D3A058A8969",
	"AC8A5D52028EE025A164993B2EA4875AC6AAA4FEA29FB4E075CBC5A274C748221BEAD115BABD671751EAA4D2CF503CEEB1A5145B5EB696ACE4DC226A7C8F6ACF667494D0594AC1A5430034F1C5F6333AB1529293BEAC8B386EAD8EB8815E4F16DE4E4735DEF210B9307D934CB69E1C281A22067B349C3BFEEAD2EE7DF1DBD0E301FF1A2D4174800790E2F431362AD1D2597E8F3E7D6AC1288BDDFD4554D7B1D2982ABA85A57A00F5ECA685EE006E4259503C89D34127C021A0045082A42C9ECC2EC1B8295435AAF4BE3DFCC42126891C3B31CCBF53A40E7DE969B083AEA2F7BA3FBB146CB7F87737201F4A71C57D3314E352EE00B531C3EBD4FA345DDFABEDCA66B3A74433523AAC392255B32FF83EFD8FC4B252DFDF283378BB7FA64EAD407C17363425EE28E2A17F83D702B63C03486E47FC895D95914B926E34D09D89EB2EF04E20D442EB1C5C4A929DF0E4E5447D09D0C832F807286CB32B8730A83685DECF045AF89F95A5492433E74936F2B2B94614519296BE31C583210A4833DCD2D35A3E057E546FDFF9524051B2AA7C74A3B7E238FCCD30B4E4D8983537FED0D2752BBE24FD7A7A4E451C8B9F597843010D0DC4B06CBA38BE1B8C0CB836C7F259D56CD93723DD743F2A1B5BEE2C8A3AF68C9B3C3CA2CEA6A84AE15C993CD8629F56C23002424AE6C2BBBB54238E97EF5AE96ABBF1649B45A545B57FB92C5235C85D296EDD5201C5FEF0192E1EE8DB5F780FFBF8DAE12B8C16AB6DE046074545258EE71D0EB3F0DA4E94171CD607DE8F80967CC9FE4875CA283649904C4B8617FA97FA2A9C20D77DCE8860357D136D4E981DE3189DEE055966F0DA84611ACA09783EFA8E96EA3FB94543BFA2304A5B675F2732B0834B6FAD740BFFA8CFD618C7023808FD2B62319C7259EC1E8C764FCFDFA9087922FBE0FBEE25D0512BA888093D94068A528C67A8C147469ADCE81BF75D79460FB68F758231F1F9FE97305587E8D84DAD23D464D2A8F76DA057D8EB75475E5F3801C421338176CFB661EEEF465D9AE55583DDD6734CF6722FA05F9DC992ACE9E12268BA2A545506590C6953CD82928E18D590465ADCE0C8B8CDF35BE76FEC1AA462B5612FA3222DD6089F4A34823A6DDFFD3C",
}
C.isStudio = isStudio
C.plr = PS.LocalPlayer
C.StartUp = true
if C.getgenv().Defaults then
	C.Defaults = C.getgenv().Defaults
else
	C.Defaults = {WalkSpeed = SP.CharacterWalkSpeed, JumpPower = SP.CharacterJumpPower, Gravity = workspace.Gravity,
		Username = C.plr.Name,DisplayName = C.plr.DisplayName, AutoJumpEnabled = SP.AutoJumpEnabled}
	C.getgenv().Defaults = C.Defaults
end
C.HighestNumber = 2^63-1 -- Largest integer possible
C.PlayerGui = C.plr:WaitForChild("PlayerGui")
task.spawn(function()
	C.PlayerScripts = C.plr:WaitForChild("PlayerScripts",100)
end)
C.BaseUrl = "https://github.com/ItsAFairGameBro/Specter/%s/main/src/client"
if C.getgenv().enHacks then
	C.enHacks = C.getgenv().enHacks
else
	C.enHacks = {}
	C.getgenv().enHacks = C.enHacks
end
C.getgenv().ProfileId = C.getgenv().ProfileId or ""
C.getgenv().AlreadyRanScripts = C.getgenv().AlreadyRanScripts or {}
C.hackData = {}
C.events = {}
C.keybinds = {}
C.functs, C.threads = {}, {} -- global connections/threads
C.instances = {} -- global instances
C.friends = {}
C.playerfuncts = {} -- player connections
C.objectfuncts = {} -- instance connections
C.preloadedModule = {}
C.forcePropertyFuncts = {}
C.BindedActions = {} -- key binds
C.CharacterAddedEventFuncts = {}
C.PlayerAddedEventFuncts = {}
C.EventFunctions, C.InsertCommandFunctions = {}, {}
C.Camera = workspace.CurrentCamera -- updated later in Events
C.Randomizer = Random.new()
C.PartConnections = {}
C.ChatVersion = Enum.ChatVersion.TextChatService -- Forcefully
C.BotUsers = {`lexxy4life`,`theweirdspook`,`lifeisoofs`,`itsagoodgamebro`,`itsagoodgamebros`,`bottingforthewin`}
C.AdminUsers = {`suitedforbans`,`suitedforbans2`,`suitedforbans3`,`suitedforbans4`,`suitedforbans5`,
`suitedforbans6`,`suitedforbans7`,`suitedforbans8`,`suitedforbans9`,`suitedforbans10`,`suitedforbans11`,`suitedforbans12`,
`biglugger2017`,`sssnsss74`,`itsagoodgamebro`,`itsagoodgamebros`,`lifeisoofs`,`averynotafkbot3`,`theweirdspook`,`lexxy4life`,
`yvettecarreno08`}
if not C.getgenv().PlaceName then
	C.getgenv().PlaceName = MPS:GetProductInfo(game.PlaceId).Name
end
C.Debugs = {All = false,
	Destroy = false,
	Module = false,
	Load = false,
	Teleport = false,
	Override = false,
	Thread = false,
	SaveSystem = false,
	RenderHighlight=false,
	AntiCheat = true,
}
--print("2")

local Settings = C.getgenv().SETTINGS
if not Settings then
	Settings = {
		ServerSaveDeleteTime = 3600 * 24, -- Time before deletion
        StartDisabled = false, -- Starts everything disabled, regardless of your saved settings
        ConnectAllEvents = false, -- Connects every event [EXPENSIVE]
	}
	C.getgenv().SETTINGS = Settings
end
C.getgenv().C = C

function C.DebugMessage(type,message)
	local PreDebugMessage = `[{C.SaveIndex or "Unreg"}/%s]: `
	assert(C.Debugs[type]~=nil, `{PreDebugMessage}Message Type Not Found: "{tostring(type)}" in an attempt to create message: "{message}"`)
	if not C.Debugs[type] and not C.Debugs.All then
		return false
	end
	print(`{PreDebugMessage:format(type)}{message}`)
	return true
end

function C.StringWait(start,path,timeout,seperationChar)
	if not start or (C.isStudio and start == CG) then return end
	local current = start
	local pathTbl = path:split(seperationChar or ".")
	for i,v in ipairs(pathTbl) do
		local next = current:WaitForChild(v,timeout)
		if next then
			current = next
		else
			warn(debug.traceback(`C.StringWait failed to find {v} in {current} from {start} (timeout = {timeout})`))
			return
		end
	end
	return current
end

function C.StringFind(start,path,seperationChar,recursionEnabled)
	if not start then return end
	local current = start
	local pathTbl = path:split(seperationChar or ".")
	for i,v in ipairs(pathTbl) do
		local next = current:FindFirstChild(v,recursionEnabled)
		if next then
			current = next
		else
			--warn("C.StringFind failed to find "..v.." in "..current:GetFullName().." from "..tostring(start))
			return
		end
	end
	return current
end

function C.AddGlobalInstance(instance)
	table.insert(C.instances,instance)
end

function C.RemoveGlobalInstance(instance)
	return C.TblRemove(C.instances,instance)
end

local ModulesLoaded = 0
function C.RunLink(githubLink,gitType,name)
    local RequestFinished = false
	local URL = githubLink:format(gitType:lower(),name);
    task.delay(3,function()
        if (not RequestFinished) then
            RequestFinished = true
            print("[C.RunLink]: Module Yielding For > 3 seconds: "..name.." [PRESUMING DEAD]")
            C.RunLink(githubLink, gitType, name)
        end
    end)
	local success, response = pcall(game.HttpGet,game,URL,false)
    if RequestFinished then
        print("[C.RunLink]: Module Yielding Callback-ed after alloted time: "..name)
        return
    end
    RequestFinished = true
	if not success then
		return warn(PrintName.." Error Requesting Script " .. name .. ":" ..response)
	end
	local scriptName = URL:sub(20)
	scriptName = scriptName:sub(scriptName:find("/")+1)
	scriptName = scriptName:sub(1,scriptName:find("/")-1):gsub("-"," ")
	local success3, codeString
	if URL:find("blob")~=nil then
		local startText = '"blob":{"rawLines":'
		local endText = ',"stylingDirectives":'
		local startAddress = response:find(startText) + startText:len()
		local endAddress = response:find(endText) -- endText:len()
		response = response:sub(startAddress,endAddress-1)
		local success2, decodedJSON = pcall(HS.JSONDecode,HS,response)

		if not success2 then
			return warn(PrintName.." Error Parsing JSON: "..decodedJSON)
		end

		success3, codeString = pcall(table.concat, decodedJSON, "\n")

		if not success3 then
			return warn(PrintName.." Error Parsing Code: "..codeString)
		end
	elseif URL:find("raw") then
		codeString = response
	end

	local success4, compiledFunction = pcall(loadstring,codeString)

	if not success4 then
		return warn(PrintName.." Error Compiling Code: "..compiledFunction)
	elseif not compiledFunction then
		return warn(PrintName.." Loadstring Failed: Syntax Error!\n\n\t\tCheck Github or DM author!")
	end
    ModulesLoaded+=1
	return compiledFunction()
end
--print("3")

C.SaveModules = {}
local LoadedModules = {}
function GetModule(path: string)
    -- All paths start from src and to the lua file
	-- local path = moduleName:find("/") and moduleName or ("Modules/"..moduleName)
	if isStudio then
		local moduleRet = require(C.StringWait(script,path,nil,"/"))
		if typeof(moduleRet) == "function" then
			return moduleRet(C, Settings)
		else
			return moduleRet
		end
	else
		local gitType = "blob"
		local githubLink = C.BaseUrl .. "/%s.lua"
        assert(C.preloadedModule[path], `{path} does not have a preloaded module!`)
		local result = C.preloadedModule[path]
        if PreCached and not LoadedModules[path] then
            LoadedModules[path] = true
            result = loadstring(result)
            assert(result, `Compiler Error: {path}`)
            result = result()
            C.preloadedModule[path] = result
        elseif not PreCached and not result then
            result = C.RunLink(githubLink,gitType,path)
        end
        assert(result, `Module Path Load Failed: {path}`)
		if typeof(result) == "function" then
			return result(C,Settings)
		else
			return result
		end
	end
end
function HttpUrlDecode(str)
	local output, t = string.gsub(str,"%%(%x%x)",function(hex)
		return string.char(tonumber(hex,16))
	end)
	return output
end
function C.LoadModule(moduleName: string)
	local informalSplit = moduleName:split("/")
	local informalName = informalSplit[#informalSplit]
	local Ret = C.SaveModules[informalName]
	if Ret then
		return Ret
	end
	local DisplayName = HttpUrlDecode(moduleName)
	local Start = os.clock()
	C.DebugMessage("Module",`Loading {DisplayName}`)
	local Mod = GetModule(moduleName)
	C.SaveModules[informalName] = Mod
	C.DebugMessage("Module",(`Loaded {DisplayName} in %.2f seconds`):format(os.clock()-Start))
	return Mod
end
--print("modules p reload")

local ModulesToPreload = {"Hacks/Blatant","Hacks/Friends","Hacks/Render","Hacks/Utility","Hacks/World","Hacks/Settings","Binds","CoreEnv","CoreLoader","Env","Events","GuiElements","HackOptions"}
if not C.isStudio and not PreCached then
	for num, module in ipairs(ModulesToPreload) do

		local gitType = "blob"
		local githubLink = C.BaseUrl .. "/%s.lua"
		local path = module:find("/") and module or ("Modules/"..module)
		local moduleParams = module:split("/")
		local informalSplit = module:split("/")
		local informalName = informalSplit[#informalSplit]
		task.delay(0.1 * (num), C.RunLink, githubLink,gitType,path)
	end
    --local startWait = os.clock()
	while ModulesLoaded < #ModulesToPreload do
		RunS.RenderStepped:Wait()
	end
    --print(("Module Loading Wait: %.1fs"):format(os.clock() - startWait))
end

--Load hooks immediately
local originalNamecall = nil
local getgenv = getgenv
local debFunct, traceback, tskWait, coroYield = C.DebugMessage, debug.traceback, task.wait, coroutine.yield
local tskSpawn, tskDelay = task.spawn, task.delay
local yieldForeverFunct
function yieldForeverFunct()
	tskSpawn(debFunct,"AntiCheat",traceback("Yielding Forever"))
	--tskWait(highestNum)
	--while true do
	coroYield()--Yields the thread forever
	--end

	warn(traceback(`YIELDING COMPLETE!? THIS IS NOT SUPPOSED TO HAPPEN. PLEASE CHECCK C.yieldForeverFunct`))
	yieldForeverFunct() -- Run it again sucker!
end
C.yieldForeverFunct = yieldForeverFunct
C.getgenv().SavedHookData = C.getgenv().SavedHookData or {}
C.getgenv().realhookfunction = C.getgenv().realhookfunction or C.getgenv().hookfunction
local MetaMethods = {"__index","__namecall","__newindex"}
local AllowHookMethod = true;
function C.HookFunc(funct, name, hook)
    local SavedStorage = getgenv().SavedHookData[funct]
    if not SavedStorage then
        if not hook then
            return
        end
        SavedStorage = {Name = name, Hook = hook}
        local localCheckCaller = C.checkcaller
        local OldMethod
        OldMethod = C.hookfunction(funct, hook, function(...)
            if not localCheckCaller() then
                local currFunc = rawget(SavedStorage,"Hook")
                if currFunc then
                    return currFunc(...)
                end
            end
            return OldMethod(...)
        end)
        SavedStorage.OldMethod = OldMethod
        getgenv().SavedHookData[funct] = SavedStorage
    else
        assert(SavedStorage.Name == name, `[C.HookFunction]: {SavedStorage.Name} does not match {name}!`)
        SavedStorage.Hook = hook
    end
    return SavedStorage.OldMethod
end
local callDepth = 0
function C.GetPropertySafe(instance, property)
	local indexHook = rawget(rawget(rawget(C,"getgenv")(),"SavedHookData"),"__index")
	if not indexHook then
		return instance[property]
	else
		local originalIndex = rawget(indexHook,"OldFunction") -- Access original __index
		return originalIndex(instance, property)
	end
end
local DISABLEDHOOKS = false
function C.HookMethod(hook, name, runFunct, methods, source)
	if C.isStudio or (not C.getgenv().SavedHookData[hook] and not runFunct) or DISABLEDHOOKS then
		return
    elseif not AllowHookMethod then
        warn("Hook Method Disabled; Attempt For:",hook,name)
        return
	end
	assert(name ~= "OldFunction", `[C.HookMethod]: {name} is a reserved method! Please use a different one!`)
	assert(hook ~= "__namecall" or #methods ~= 0, `[C.HookMethod]: __namecall {name} hooks require at least one method, but none was specified`)
	if not C.getgenv().SavedHookData[hook] then
		-- Hook the namecall function
		local gameId = game.GameId
		local checkcaller = C.checkcaller
		local gmatch, gsub, getType = string.gmatch, string.gsub, typeof
		local getVal, setVal = rawget, rawset
		local traceback = debug.traceback
		local strFind = string.find
		local orgToStr = tostring
		local strLen, toStr = string.len, function(instance)
			local myType = getType(instance);
			if (myType == "table") then
				return "tbl"
			elseif myType == "Instance" then
				return orgToStr(instance)
			elseif myType == "number" or myType == "string" then
				return instance
			end
			return orgToStr(instance)
		end
		local getcallingscript,getnamecallmethod,lower,tblFind,tblPack,tblUnpack = C.getcallingscript,getnamecallmethod,string.lower,table.find,table.pack,unpack
		local additionalCallerName = {["SayMessageRequest"]=true,["getloghistory"]=true,["getlogHistory"]=true,["Value"]=true}
		local additionalMethodName = {["sendasync"]=true}
		local additionalAvoidLower = {["getlogHistory"] = true}

		--[[if (not C.getgenv().hookedDebugInfo) then
			C.getgenv().hookedDebugInfo = true
			local OldDebug
			OldDebug = hookfunction(debug.info, function(num, arg, ...)
				if (arg == "f") then
					print("Bypassing hook!",debug.traceback())
					return OldDebug(num + 2, arg, ...)
				elseif (arg == "s") then
					return "[C]"
				elseif (arg == "l") then
					return 1
				elseif (arg == "n") then
					return ""
				elseif (arg == "a") then
					return 0
				end
				return OldDebug(num, arg, ...)
			end)
			print("HOOKED DEBUG.INFO")
		end--]]
		local exceeded = false
		local myHooks = {}

		C.getgenv().SavedHookData[hook] = myHooks

		local HookType = ((source or typeof(hook)=="function") and "hookfunction")
			or (typeof(hook)=="string" and "hookmetamethod")

		assert(hookfunction,`[C.HookMethod]: Unknown HookType: {hook}!`)
		for num, methodName in ipairs(methods or {}) do
			assert(methodName == lower(methodName),`[C.HookMethod]: {toStr(methodName)} is not lowercase!`)
		end

		local OriginFunct
		local function CallFunction(self,...)
			if strFind(traceback(nil, 2), "function CallFunction") ~= nil then--callDepth > 10 then
				-- setclipboard(traceback("CALL"))
				warn(traceback(`Recursion prevented: {callDepth}`),self,...)
				return OriginFunct(self, ...)
			elseif callDepth >= 100 and false then
				if not exceeded then
					exceeded = true
					warn(traceback(`InCall limited exceeded: {callDepth}`),self,...)
				end
				return OriginFunct(self, ...)
				-- if callDepth > 2 then
					-- warn(find(traceback(`InCall occured with args: {callDepth}`)),self,...)
				-- end
			end
			callDepth = callDepth + 1
			-- Get the method being called
			local method
            -- if (lower(getnamecallmethod() or "") == "getloghistory"
            --     or (... and getType(...) == "string" and lower(...) == "getloghistory")) then
			-- 	tskSpawn(print, "LOG", self, ...)
			-- end
			if HookType=="hookmetamethod" then
				if hook == "__namecall" then
					method = getnamecallmethod()
				else
					method = (...)
				end
                --Basic safety..
				if lower(method) == "name" then
					return OriginFunct(self, ...)
				end
			elseif HookType == "hookfunction" then
				method = self
			end
			if method and getType(method) == "string" then
				if not rawget(additionalAvoidLower, method) then
					method = lower(method)
				end
				local parsed, count = gsub(method, "\000.*", "")
				if strLen(parsed) > 0 and count <= 1 then
					method = parsed
				elseif count > 1 then
					warn(`Parsed Method Count {count} For Method: {toStr(self)} {method}`)
				else
					warn(`Empty Message Parsed from {toStr(self)} {method}. Copied to clipboard for further inspection.`)
					getVal(C,"setclipboard")(method)
				end
			end
			--if getVal(additionalCallerName,toStr(self)) or getVal(additionalMethodName,method) or toStr(self) == "RBXGeneral" then
			--	tskSpawn(print,self,method,checkcaller(),getVal(additionalMethodName,method))
			--end

			local Override = getVal(additionalCallerName,toStr(self)) or getVal(additionalMethodName,method)
			local isGameScript = not checkcaller()
			 -- Check if the caller is not a local script
			 if isGameScript or Override then
                local theirScript = getcallingscript()
				--if not theirScript and "WalkSpeed"==({...})[1] then
				--	tskSpawn(print,`method walkspeed {toStr(method)}`)
				--end
				if theirScript or Override then
					if gameId == 1160789089 and toStr(theirScript) == "BAC_" then
                        error("BAC_")
						if hook == "__index" then
							tskSpawn(debFunct,"AntiCheat",`Sending yielding forever function for script {toStr(theirScript)}`)
							return coroYield -- Return the function to run forever haha!!
						else
							tskSpawn(debFunct,"AntiCheat",`Yielding forever on script {toStr(theirScript)}`)
							workspace:WaitForChild("POO POO PEE PEE")--coroYield()
							error("coroutine thread was attempting to be resumed for script "..theirScript.Name)
							return
						end
					end--]]
					-- Block FireServer or InvokeServer methods
					for name, list in pairs(myHooks) do
						if (name == "OldFunction") then
							continue
						end
						local indexes = getVal(list,2)
						if not indexes or tblFind(indexes,method) then -- Authorization
							--myPrint("Authorized",theirScript)
							local isRunning = true
							tskDelay(3, function()
								if isRunning then
									isRunning = false
									callDepth = callDepth - 1
									warn(`[C.{HookType}]: Hook is taking > 3 seconds to run with id = {name}; method = {method}; orgScript = {theirScript}`)
								end
							end)
							local operation,returnData = getVal(list,3)(theirScript,method,self,...)
							if not isRunning then
								warn(`[C.{HookType}]: Hook RESUMED > 3 seconds to run with id = {name}; method = {method}; orgScript = {theirScript}`)
								return OriginFunct(self, ...)
							end
							isRunning = false
							if operation then
								if operation == "Override" or operation == "FireSeperate" then
									assert(typeof(getVal(returnData,1)) == typeof(self),
										`Invalid Override Argument 1; Expected same type as self {self} with id = {name}; method = {method}; origin = {theirScript}`)
								end
								callDepth = callDepth - 1
								if operation == "Spoof" then
									return tblUnpack(returnData)
								elseif operation == "Override" then
									return OriginFunct(tblUnpack(returnData))
								elseif operation == "FireSeperate" then
									return tskSpawn(OriginFunct,tblUnpack(returnData))
								elseif operation == "Cancel" then
									return -- Cancelled
								elseif operation == "Yield" then
									if hook == "__index" then
										return yieldForeverFunct -- Return the function to run forever haha!!
									else
										return yieldForeverFunct()
									end
								else
									warn(`[C.{HookType}]: Unknown Operation for {name}: {operation}. Letting Function Run!`)
									return OriginFunct(self, ...)
								end
							end
						end
					end
                end
            end
			callDepth = callDepth - 1
			return OriginFunct(self,...)
		end
		--[[if HookType == "hookfunction" and typeof(hook) == "string" and source then -- we'll do this the old way then!
			OriginFunct = rawget(source,hook)
			rawset(source,hook,CallFunction)
			print("Origin",OriginFunct,hook,source)
		else--]]
		OriginFunct = (HookType == "hookmetamethod" and C.hookmetamethod(source or game, hook, (CallFunction)))
			or (HookType == "hookfunction" and C.hookfunction(hook, CallFunction))
		C.getgenv().SavedHookData[hook].OldFunction = OriginFunct
		--end
	end
	if runFunct then
		C.getgenv().SavedHookData[hook][name] = {name,methods,runFunct}
		return C.getgenv().SavedHookData[hook].OldFunction
	else
		C.getgenv().SavedHookData[hook][name] = nil
	end
end
--print("6")

--[[function C.HookNamecall(name,methods,runFunct)
	error"SHOULDN't be running"
	if C.isStudio or (not C.getgenv().NamecallHooks and not methods) then
		return
	end
    if not C.getgenv().NamecallHooks then
		warn("STARTING HOOKNAMECALL (should only happen once)")
        -- Hook the namecall function
		local checkcaller = C.checkcaller
        local getcallingscript,getnamecallmethod,lower,tblFind,tblPack,tblUnpack = C.getcallingscript,getnamecallmethod,string.lower,table.find,table.pack,table.unpack

		local myHooks = {}
        C.getgenv().NamecallHooks = myHooks
        originalNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            -- Check if the caller is not a local script
            if not checkcaller() and self.Name ~= "CharacterSoundEvent" then
                -- Get the method being called
                local method = lower(getnamecallmethod())
                local theirScript = getcallingscript()
                -- Block FireServer or InvokeServer methods
                for name, list in pairs(myHooks) do
                    if tblFind(list[1],method) then -- Authorization
                        local operation,returnData = list[2](theirScript,method,self,...)
                        if operation then
                            if operation == "Override" then
                                return tblUnpack(returnData)
                            elseif operation == "Cancel" then
                                return
                            elseif operation == "Yield" then
                                C.yieldForeverFunct()
								warn("[C.HookNameCall:] YIELDING COMPLETE!?")
								return
                            else
                                warn(`[C.HookNameCall]: Unknown Operation for {name}: {operation}. Letting Remote Run!`)
                            end
                        end
                    end
                end
            end

            -- If the caller is a local script, call the original namecall method
            return originalNamecall(self, ...)
        end))
    end
    if methods then
        C.getgenv().NamecallHooks[name] = {methods,runFunct}
    else
        C.getgenv().NamecallHooks[name] = nil
    end
end
function C.HookFunction(name,orgFunct,runFunct)
	C.getgenv().FunctionHooks = C.getgenv().FunctionHooks or {}
	if C.isStudio or (not C.getgenv().FunctionHooks[orgFunct] and not runFunct) then
		return
	end
    if not C.getgenv().FunctionHooks[orgFunct] then
		warn("STARTING FUNCTIONCALL FOR FUNCT (should only happen once per function)")
        -- Hook the namecall function
		local checkcaller = C.checkcaller
        local getcallingscript,getnamecallmethod,lower,tblFind,tblPack,tblUnpack = C.getcallingscript,getnamecallmethod,string.lower,table.find,table.pack,table.unpack

		local myHooks = {}
        C.getgenv().FunctionHooks[orgFunct] = myHooks
        originalNamecall = C.hookfunction(orgFunct, function(self, ...)
            -- Check if the caller is not a local script
            if not checkcaller() then
                -- Get the method being called
                local theirScript = getcallingscript()
                -- Block FireServer or InvokeServer methods
                for name, list in pairs(myHooks) do
					local operation,returnData = list[1](theirScript,self,...)
					if operation then
						if operation == "Override" then
							return tblUnpack(returnData)
						elseif operation == "Cancel" then
							return
						elseif operation == "Yield" then
							C.yieldForeverFunct()
							warn("[C.HookFunction:] YIELDING COMPLETE!?")
							return
						else
							warn(`[C.HookFunction]: Unknown Operation for {name}: {operation}. Letting Remote Run!`)
						end
                    end
                end
            end

            -- If the caller is a local script, call the original namecall method
            return originalNamecall(self, ...)
        end)
    end
    if runFunct then
        C.getgenv().FunctionHooks[orgFunct][name] = {runFunct}
    else
        C.getgenv().FunctionHooks[orgFunct][name] = nil
    end
end--]]


--Load AntiCheat Immediately!
C.LoadModule("Modules/AntiCheat")
return C.LoadModule("Modules/CoreLoader")