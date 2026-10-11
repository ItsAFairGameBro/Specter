import importlib.util
import os
from contextlib import contextmanager
from pathlib import Path
import subprocess
import shutil
import uuid
import unittest
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location("bundle", ROOT / "compile.py")
bundle = importlib.util.module_from_spec(spec)
spec.loader.exec_module(bundle)
LUAU = Path(os.environ.get("LUAU", ROOT / ".tools/luau/luau.exe"))


@contextmanager
def workspace_temp():
    # Inherit workspace ACLs. Python 3.14's private Windows temp-directory ACL
    # excludes the restricted execution identity used by the local runner.
    path = ROOT / (".test-" + uuid.uuid4().hex)
    path.mkdir()
    try:
        yield path
    finally:
        assert path.resolve().parent == ROOT.resolve()
        shutil.rmtree(path)


def section(path, start, end):
    source = (ROOT / path).read_text(encoding="utf-8")
    return source[source.index(start):source.index(end, source.index(start))]


class BuildTests(unittest.TestCase):
    def test_import_has_no_build_side_effect(self):
        with patch.object(Path, "read_text", side_effect=AssertionError("import read source")):
            module = importlib.util.module_from_spec(spec)
            spec.loader.exec_module(module)

    def test_build_is_deterministic_and_preserves_previous_on_failure(self):
        with workspace_temp() as directory:
            root = Path(directory)
            init = root / "init.client.lua"
            init.write_text(bundle.PLACEHOLDER, encoding="utf-8")
            (root / "z.lua").write_text("return 2", encoding="utf-8")
            (root / "a.lua").write_text("return 1", encoding="utf-8")
            output = bundle.compile_client(root)
            first = output.read_bytes()
            bundle.compile_client(root)
            self.assertEqual(first, output.read_bytes())
            self.assertLess(first.index(b'["a"]'), first.index(b'["z"]'))
            with patch.object(bundle.os, "replace", side_effect=OSError("locked")):
                with self.assertRaises(OSError):
                    bundle.compile_client(root)
            self.assertEqual(first, output.read_bytes())
            self.assertEqual({p.name for p in root.iterdir()}, {"init.client.lua", "a.lua", "z.lua", "full_code.lua"})
            init.write_text("no placeholder", encoding="utf-8")
            with self.assertRaises(ValueError):
                bundle.compile_client(root)
            self.assertEqual(first, output.read_bytes())

    def test_reject_invalid_values(self):
        for value in [float("nan"), float("inf"), float("-inf")]:
            with self.assertRaises(ValueError):
                bundle.to_luau(value)
        with self.assertRaises(TypeError):
            bundle.to_luau(object())

    def test_verification_failure_preserves_bundle(self):
        with workspace_temp() as root:
            (root / "init.client.lua").write_text(bundle.PLACEHOLDER, encoding="utf-8")
            output = bundle.compile_client(root)
            previous = output.read_bytes()
            failed = subprocess.CompletedProcess([], 1, "", "syntax error")
            with patch.object(bundle, "find_compiler", return_value="compiler"), patch.object(bundle.subprocess, "run", return_value=failed):
                with self.assertRaisesRegex(ValueError, "syntax error"):
                    bundle.compile_client(root, verify=True)
            self.assertEqual(previous, output.read_bytes())
            self.assertEqual({p.name for p in root.iterdir()}, {"init.client.lua", "full_code.lua"})


@unittest.skipUnless(LUAU.is_file(), "Set LUAU to the Luau CLI executable")
class RuntimeTests(unittest.TestCase):
    def run_luau(self, source):
        with workspace_temp() as directory:
            script = Path(directory) / "test.luau"
            script.write_text(source, encoding="utf-8")
            result = subprocess.run([str(LUAU), str(script)], capture_output=True, text=True, timeout=20)
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_gui_window_and_popup_layers(self):
        code = section('src/client/Modules/GuiElements.lua', 'local Layers =', 'local function CreateOtherElements')
        self.run_luau(r'''
local objects = {}
local Instance = {new=function(class)
    local object = {ClassName=class, ZIndex=1}
    table.insert(objects, object)
    return object
end}
local function value(...) return {...} end
local Color3 = {fromRGB=value}
local ColorSequence, ColorSequenceKeypoint = {new=value}, {new=value}
local Font, UDim, Vector2, Vector3 = {new=value}, {new=value}, {new=value}, {new=value}
local UDim2 = {new=value, fromOffset=value}
local Enum = setmetatable({}, {__index=function(_, group)
    return setmetatable({}, {__index=function(_, name) return group .. "." .. name end})
end})
local C = {UI={}, Examples={}, AddGlobalInstance=function() end,
    SetImage=function(object, image) object.Image=image end}
''' + code + r'''
local gui, categories, tabs, tooltip = LoadCore(C)
local function child(parent, name)
    for _, object in objects do
        if object.Parent == parent and object.Name == name then return object end
    end
    error("Missing child " .. name)
end
local function above(front, back)
    -- Compare the first differing siblings, as Roblox Sibling ordering does.
    local function path(object)
        local result = {}
        while object ~= gui do
            assert(object.Parent, "Object must be attached to the GUI")
            table.insert(result, 1, object)
            object = object.Parent
        end
        return result
    end
    local a, b = path(front), path(back)
    for i = 1, math.min(#a, #b) do
        if a[i] ~= b[i] then return a[i].ZIndex > b[i].ZIndex end
    end
    return #a > #b
end
assert(gui.ZIndexBehavior == Enum.ZIndexBehavior.Sibling)
assert(above(C.UI.MainHUD, C.UI.HUDBackgroundFade))
assert(above(categories, tabs))
local tab = C.Examples.TabEx
-- Cloned controls retain their local layers when a window moves in the stack.
tab.Parent = tabs
tab.ZIndex = 50000
local expand = child(C.Examples.HackButtonEx, "HackExpand")
C.Examples.HackButtonEx.Parent = child(tab, "ScrollTab")
assert(above(child(tab, "HeaderTab"), expand))
assert(above(C.UI.DropdownFrame, expand))
assert(above(C.UI.DropdownFrame, tooltip))
assert(above(C.UI.SecondaryHUD, expand))
local promptButtons = child(C.UI.PromptFrame, "PromptButtons")
assert(above(child(promptButtons, "Yes"), C.UI.SecondaryHUD))
assert(above(child(promptButtons, "No"), C.UI.ChatAutoComplete))
assert(above(child(promptButtons, "Ok"), C.UI.VisibilityButton))
assert(above(C.UI.ChatAutoComplete, C.UI.Commandbar))
local row = C.Examples.HackButtonEx
local label, backing = child(row, "KeybindLabel"), child(row, "KeybindBacking")
assert(not label.Visible and not backing.Visible)
assert(above(label, backing))
assert(above(child(row, "KeybindButton"), backing))
local action = C.Examples.ActionsEx
action.Parent = child(C.UI.Actions, "ScrollTab")
assert(above(child(action, "StopButton"), C.UI.MainHUD))
assert(above(C.UI.PromptFrame, child(action, "StopButton")))
''')

    def test_string_round_trips(self):
        values = ['quote" and \\ slash', '\x00\x017', '\nleading newline\n', 'ends\n]', 'ends\n]=', '\n]]\n]=]\n]==]\n', '\r\nCRLF\r\n', 'Unicode: \u2705']
        checks = [f"assert({bundle.to_luau(value)} == {bundle.quote_string(value)})" for value in values]
        checks.append('local t = ' + bundle.to_luau({'key"\\': [True, False, 3.5, {'x': 'a"b'}]}))
        checks.append('assert(t["key\\\"\\\\"][1] == true and t["key\\\"\\\\"][2] == false)')
        checks.append('local multilineKey = ' + bundle.to_luau({'\nkey': 3}))
        checks.append('assert(multilineKey["\\nkey"] == 3)')
        self.run_luau('\n'.join(checks))

    def test_factory_scope_lazy_loading_and_clean_output(self):
        modules = {
            "Modules/Scope": 'local value = C\nreturn function(c) return value == nil and c.marker end',
            "Modules/Strings": '-- trailing comment\nreturn [=[\n  keep whitespace\n\n]=] -- eof',
            "Modules/Lazy": 'error("must not execute until loaded")',
            "Modules/Varargs": 'return select("#", ...)',
        }
        entry = 'local C = {marker = 42}\n' + bundle.PLACEHOLDER + '''
assert(type(C.preloadedModule["Modules/Lazy"]) == "function")
assert(C.preloadedModule["Modules/Scope"]()(C) == 42)
assert(C.preloadedModule["Modules/Strings"]() == "  keep whitespace\\n\\n")
assert(C.preloadedModule["Modules/Varargs"]() == 0)
'''
        for clean in (False, True):
            with self.subTest(clean=clean):
                self.run_luau(bundle.render_bundle(entry, modules, clean=clean))

    def test_compaction_preserves_luau_literals_and_token_boundaries(self):
        source = r'''
-- remove this comment
local a = "-- literal \\" .. '-- also literal'
local b = [==[  whitespace

-- inside literal ]=] ]==]
--[==[ a long comment with " and ` and ]] ]==]
local c = `prefix {({value = `inner {"-- not a comment"}`}).value} suffix`
local d = "escaped\\z string"
local e = "\z
  whitespace removed by Luau"
local x = 5 - -- keep operators separate
 -2
return {a, b, c, d, e, x}
'''
        compact = bundle.compact_luau(source)
        self.assertNotIn("remove this comment", compact)
        self.run_luau(
            "local original = assert(loadstring(" + bundle.to_luau(source) + "))()\n"
            "local compact = assert(loadstring(" + bundle.to_luau(compact) + "))()\n"
            "for i, value in original do assert(compact[i] == value, tostring(i)) end"
        )

    def test_deferred_and_compact_modules_compile(self):
        modules = bundle.list_lua_files(ROOT / "src/client")
        compact = {key: bundle.compact_luau(value) for key, value in modules.items()}
        self.run_luau("local modules = " + bundle.to_luau(compact) + '''
for key, source in modules do
    local compiled, err = loadstring(source)
    assert(compiled, key .. ": " .. tostring(err))
end
''')
        self.run_luau("local modules = " + bundle.module_factories(modules) + '''
assert(type(modules["Modules/Env"]) == "function")
assert(type(modules["Games/FleeTheFacility"]) == "string")
assert(type(modules["Scripts/Dark%20Dex"]) == "string")
''')

    def test_compaction_preserves_all_module_bytecode(self):
        compiler = bundle.find_compiler()
        if not compiler:
            self.skipTest("Set LUAU_COMPILE to the official Luau compiler")
        with workspace_temp() as directory:
            original = directory / "original.luau"
            compact = directory / "compact.luau"
            for key, source in bundle.list_lua_files(ROOT / "src/client").items():
                with self.subTest(module=key):
                    original.write_text(source, encoding="utf-8")
                    compact.write_text(bundle.compact_luau(source), encoding="utf-8")
                    bytecodes = []
                    for path in (original, compact):
                        result = subprocess.run([compiler, "--text", "--dump-constants", "-g0", str(path)], capture_output=True, timeout=20)
                        self.assertEqual(result.returncode, 0, result.stderr.decode("utf-8"))
                        bytecodes.append(result.stdout)
                    self.assertEqual(bytecodes[0], bytecodes[1], key)

    def test_factory_loader_cache_and_retry(self):
        loader = section('src/client/init.client.lua', 'C.SaveModules = {}', '--Load hooks immediately')
        self.run_luau('''
local isStudio, PreCached = false, true
local Settings = {marker=7}
local C = {BaseUrl="url", preloadedModule={}, DebugMessage=function() end}
local bodyCalls, initCalls, retryCalls = 0, 0, 0
C.preloadedModule["Modules/Factory"] = function(...)
    assert(select("#", ...) == 0)
    bodyCalls += 1
    return function(c, settings)
        initCalls += 1
        assert(c == C and settings == Settings)
        return {marker=settings.marker}
    end
end
C.preloadedModule["Modules/RetryFactory"] = function()
    retryCalls += 1
    if retryCalls == 1 then error("retry") end
    return {ok=true}
end
''' + loader + '''
local first = C.LoadModule("Modules/Factory")
assert(C.LoadModule("Modules/Factory") == first)
assert(bodyCalls == 1 and initCalls == 1 and first.marker == 7)
assert(not pcall(C.LoadModule, "Modules/RetryFactory"))
assert(C.LoadModule("Modules/RetryFactory").ok and retryCalls == 2)
''')

    def test_loader_debug_toggles_and_failure_messages(self):
        loader = section('src/client/init.client.lua', 'C.SaveModules = {}', '--Load hooks immediately')
        self.run_luau('''
local isStudio, PreCached = false, true
local Settings = {}
-- Preloaded modules must not require a remote BaseUrl.
local C = {Debugs={Module=false,All=false}, preloadedModule={}}
local messages = {}
function C.DebugMessage(_, message) table.insert(messages, message) end
''' + loader + '''
C.preloadedModule["Modules/Silent"] = function() return {ok=true} end
assert(C.LoadModule("Modules/Silent").ok and #messages == 0)
C.Debugs.Module = true
C.preloadedModule["Modules/Log%20Me"] = function() return {ok=true} end
assert(C.LoadModule("Modules/Log%20Me").ok)
assert(#messages == 2 and messages[1] == "Loading Modules/Log Me")
assert(C.LoadModule("Modules/Log%20Me").ok and #messages == 2)
C.Debugs.Module = false
C.preloadedModule["Modules/Enable"] = function()
    C.Debugs.All = true
    return {ok=true}
end
assert(C.LoadModule("Modules/Enable").ok and #messages == 3)
assert(string.find(messages[3], "Loaded Modules/Enable", 1, true))
C.Debugs.All = false
local ok, err = pcall(C.LoadModule, "Modules/Missing")
assert(not ok and string.find(err, "does not have a preloaded module!", 1, true))
C.preloadedModule["Modules/Nil"] = function() return nil end
ok, err = pcall(C.LoadModule, "Modules/Nil")
assert(not ok and string.find(err, "Module Path Load Failed: Modules/Nil", 1, true))
C.preloadedModule["Modules/Nil"] = function() return {retried=true} end
assert(C.LoadModule("Modules/Nil").retried)
''')

    def test_all_embedded_modules_preserve_source_and_compile(self):
        modules = bundle.list_lua_files(ROOT / "src/client")
        source = "local modules = " + bundle.to_luau(modules) + "\n"
        for key, value in modules.items():
            source += f"assert(modules[{bundle.quote_string(key)}] == {bundle.quote_string(value)})\n"
        source += "for key, value in modules do local compiled, err = loadstring(value); assert(compiled, key .. ': ' .. tostring(err)) end"
        self.run_luau(source)

    def test_serializer_round_trip(self):
        source = (ROOT / "src/client/Modules/Serializer.lua").read_text(encoding="utf-8")
        mock = (ROOT / "tests/roblox_mock.luau").read_text(encoding="utf-8")
        checks = r'''
local root = Instance.new("Model")
root.Name = "root"
local child = Instance.new("Part")
child.Name, child.Parent = "child", root
root.PrimaryPart = child
local weld = Instance.new("Weld")
weld.Parent, weld.Part0, weld.Part1 = root, child, child
local mesh = Instance.new("SpecialMesh")
mesh.Parent, mesh.Scale = root, Vector3.new(2, 3, 4)
local emitter = Instance.new("ParticleEmitter")
emitter.Parent, emitter.SpreadAngle = child, Vector2.new(12, 34)
child.Position = Vector3.new(5, 6, 7)
root.WorldPivot = CFrame.new(1, 2, 3, 1, 0, 0, 0, 1, 0, 0, 0, 1)
local packet = rose.serialize(root)
assert(type(packet.classes) == "table")
-- A numeric CFrame array must have no string key that breaks JSON encoding.
for _, prop in pairs(packet.tree[3]) do
    if type(prop[2]) == "table" then assert(prop[2].n == nil) end
end
local result = rose.deserialize(packet)
assert(result.Name == "root")
assert(result.PrimaryPart.Name == "child")
assert(result.PrimaryPart.Parent == result)
assert(result.PrimaryPart.Position.X == 5)
assert(result.WorldPivot:GetComponents() == 1)
local foundWeld, foundEmitter = false, false
for _, c in result:GetChildren() do
    if c.ClassName == "Weld" then
        foundWeld = true
        assert(c.Part0 == result.PrimaryPart and c.Part1 == result.PrimaryPart)
    end
    if c.ClassName == "Part" then
        for _, e in c:GetChildren() do
            if e.ClassName == "ParticleEmitter" then
                foundEmitter = true
                assert(e.SpreadAngle.X == 12 and e.SpreadAngle.Y == 34)
            end
        end
    end
end
assert(foundWeld and foundEmitter)
-- New packets identify classes independently of registry iteration order.
local newId = #packet.classes + 1
packet.classes[newId], packet.tree[2] = "Model", newId
assert(rose.deserialize(packet).ClassName == "Model")
-- Existing version-2 packets without a registry remain readable.
local legacy = rose.serialize(root)
legacy.classes = nil
assert(rose.deserialize(legacy).PrimaryPart.Name == "child")
-- Separate operations must reset the reference scope.
local nextRoot = Instance.new("Model")
local other = Instance.new("Part")
other.Parent, nextRoot.PrimaryPart = nextRoot, other
assert(rose.deserialize(rose.serialize(nextRoot)).PrimaryPart.Parent ~= root)
local desc = Instance.new("HumanoidDescription")
desc.Name, desc.HeightScale = "avatar", 1.5
assert(rose.deserialize(rose.serialize(desc)).HeightScale == 1.5)
'''
        self.run_luau(mock + '\nlocal rose = (function()\n' + source + '\nend)()\n' + checks)

    def test_cleanup_and_table_equality(self):
        env = "src/client/Modules/Env.lua"
        code = section(env, '\tfunction C.ClearFunctTbl', '\t--Clear Children')
        equality = section(env, '\tfunction C.AreTablesEqual', '\tlocal savedFriendsCashe')
        self.run_luau(r'''
local C = {functs = {}, threads = {}, playerfuncts = {}, objectfuncts = {}}
function C.TblAdd(t, v) table.insert(t, v) end
function C.TblRemove(t, v)
    local i = table.find(t, v)
    if i then table.remove(t, i) return true end
end
function C.StopThread(t) coroutine.close(t) end
function connection()
    return {Connected = true, Disconnect = function(self) self.Connected = false end}
end
''' + code + equality + r'''
C.ClearFunctTbl(nil)
C.ClearThreadTbl(nil)
C.RemoveAllPlayerConnections({})
local thread = coroutine.create(function() coroutine.yield() end)
local conn = connection()
C.functs = {conn}
C.AddGlobalThread(thread)
assert(C.RemoveGlobalThread(thread))
assert(#C.threads == 0 and C.functs[1] == conn and conn.Connected)
local callback
local object = {Destroying = {Connect = function(_, cb) callback = cb return connection() end}}
local a, b = connection(), connection()
C.AddObjectConnection(object, "a", a)
C.AddObjectConnection(object, "b", b)
callback()
assert(not a.Connected and not b.Connected and C.objectfuncts[object] == nil)
C.RemoveObjectConnection(object, "a")
assert(C.AreTablesEqual({x={a=1}}, {x={a=1}}))
assert(not C.AreTablesEqual({x=1}, {x=1,y=2}))
assert(not C.AreTablesEqual({x={a=1}}, {x={a=1,b=2}}))
''')

    def test_module_paths_and_retry_after_failure(self):
        code = section('src/client/init.client.lua', 'C.SaveModules = {}', '--Load hooks immediately')
        self.run_luau(r'''
local isStudio, PreCached = false, true
local attempts = 0
local script = {}
local require = function(module) return module end
local C = {BaseUrl="url/%s", preloadedModule = {
    ["Modules/Same"] = "return {origin='module'}",
    ["Games/Same"] = "return {origin='game'}",
    ["Modules/Retry"] = "return function() return 42 end",
    ["Modules/Broken"] = "this is invalid",
}}
local Settings = {}
function C.DebugMessage() end
''' + code + r'''
assert(C.LoadModule("Modules/Same").origin == "module")
assert(C.LoadModule("Games/Same").origin == "game")
assert(not pcall(C.LoadModule, "Modules/Broken"))
C.preloadedModule["Modules/Broken"] = "return {ok=true}"
assert(C.LoadModule("Modules/Broken").ok)
assert(C.LoadModule("Modules/Retry") == 42)
PreCached = false
C.BaseUrl = "url/%s"
function C.RunLink() attempts += 1 return {remote=true} end
assert(C.LoadModule("Modules/Remote").remote and attempts == 1)
isStudio = true
function C.StringWait(_, path)
    assert(path == "Scripts/Save Instance")
    return {studio=true}
end
assert(C.LoadModule("Scripts/Save%20Instance").studio)
''')

    def test_camera_listener_is_reused_and_detached(self):
        code = section('src/client/Hacks/Utility.lua', '\t\t\t\t\t--Lock Camera Orientation', '\t\t\t\t\tself:SetAutoJump()')
        self.run_luau(r'''
local function signal()
    local s = {connections={}, created=0}
    function s:Connect(cb)
        self.created += 1
        local c = {Connected=true, callback=cb}
        function c:Disconnect() self.Connected=false end
        table.insert(self.connections, c)
        return c
    end
    function s:Fire()
        for _, c in table.clone(self.connections) do
            if c.Connected then c.callback() end
        end
    end
    return s
end
local Enum = {CameraType={Custom="Custom", Track="Track"}}
local function camera()
    local c = {CameraType="Custom", Changed=signal()}
    function c:GetPropertyChangedSignal() return self.Changed end
    return c
end
local a, b = camera(), camera()
local workspace = {CurrentCamera=a, Changed=signal()}
function workspace:GetPropertyChangedSignal() return self.Changed end
local C = {TblRemove=function(t,v) table.remove(t, table.find(t,v)) end}
local self, EnTbl = {Functs={}}, {LockCamera=true}
''' + code + r'''
for _ = 1, 10 do
    a.CameraType = "Custom"
    a.Changed:Fire()
    assert(a.CameraType == "Track")
end
assert(a.Changed.created == 1 and #self.Functs == 2)
workspace.CurrentCamera=b
workspace.Changed:Fire()
assert(not a.Changed.connections[1].Connected)
assert(b.CameraType == "Track" and b.Changed.created == 1)
workspace.CurrentCamera=nil
workspace.Changed:Fire()
assert(not b.Changed.connections[1].Connected and #self.Functs == 1)
''')

    def test_event_replay_caches(self):
        code = section('src/client/Modules/Events.lua', '    C.SaveEvents = ', '    local HasAttachment')
        equality = section('src/client/Modules/Env.lua', '\tfunction C.AreTablesEqual', '\tlocal savedFriendsCashe')
        self.run_luau('local C = {events={}}\nlocal Settings = {}\n' + equality + code + r'''
C.FireEvent("TowerAdded", nil, "tower")
assert(#C.SaveEvents.Tower == 1)
C.FireEvent("TowerRemoved", nil, "tower")
assert(#C.SaveEvents.Tower == 0)
C.FireEvent("BeastHammerAdded", false, "hammer")
assert(#C.SaveEvents.OthersBeastHammer == 1)
C.FireEvent("BeastHammerRemoved", false, "hammer")
assert(#C.SaveEvents.OthersBeastHammer == 0)
''')

    def test_shared_key_binding_removal_is_independent(self):
        code = section('src/client/Modules/Binds.lua', '\tfunction C.BindAction', '\t--Set Binds for UI')
        self.run_luau(r'''
local C = {BindedActions={}, keybinds={}, enHacks={Test={One={},Two={}}}}
local actions = {}
local CAS = {}
function CAS:BindActionAtPriority(name, cb) actions[name]=cb end
function CAS:UnbindAction(name) actions[name]=nil end
local UIS = {IsKeyDown=function() return false end}
local Enum = {KeyCode={}, UserInputState={Begin="Begin"}}
local key = {Name="K"}
local parent = {Category={Name="Test"}}
local one, two = {Parent=parent, Shortcut="One"}, {Parent=parent, Shortcut="Two"}
''' + code + r'''
C.AddKeybind(key, one)
C.AddKeybind(key, two)
assert(C.keybinds[one].Name ~= C.keybinds[two].Name)
C.RemoveKeybind(one)
assert(actions[C.keybinds[two].Name] ~= nil and C.enHacks.Test.One.Keybind == nil)
assert(C.enHacks.Test.Two.Keybind == "K")
''')

    def test_profile_loading_preserves_live_ui_tables(self):
        api = section('src/client/Modules/CoreEnv.lua', '\tfunction C.API', '\tlocal function CreateStoragePath')
        reload = section('src/client/Modules/CoreEnv.lua', '\tfunction C:ReloadStates()', '\tfunction C:SaveProfile()')
        load = section('src/client/Modules/CoreEnv.lua', '\tfunction C:LoadProfile(', '\tfunction C:StartAutoSave()')
        self.run_luau(r'''
local saved = {En=true, Speed=5}
local omitted = {En=false}
local env = {ProfileId="Before"}
local C = {enHacks={Test={Feature=saved, Omitted=omitted}}, hackData={Test={}}, StartUp=false}
function C.getgenv() return env end
function C.DebugMessage() end
function C.AddNotification() end
local warn = function() end
local Enum = {KeyCode={}}
local data = {
    ["SpecterV2/Profiles/Next.json"]={Hacks={Test={Feature={En=false, Speed=12}}}},
    ["SpecterV2/Profiles/Corrupt.json"]={WrongKey=true},
}
C.readfile = function(path) return path end
C.isfile = function(path) return data[path] ~= nil end
local HS = {JSONDecode=function(_, path) return data[path] end}
local Serializer = {}
local feature = {Default=true, Options={}}
function feature:SetValue(value) saved.En=value end
local option = {Shortcut="Speed", Default=3}
function option:SetValue(value) saved.Speed=value end
feature.Options = {option}
local missing = {Default=true}
function missing:SetValue(value) omitted.En=value end
C.hackData.Test = {Feature=feature, Omitted=missing}
''' + api + reload + load + r'''
assert(C:LoadProfile("Next"))
assert(C.enHacks.Test.Feature == saved and saved.Speed == 12 and saved.En == false)
assert(C.enHacks.Test.Omitted == omitted and omitted.En == true)
assert(env.ProfileId == "Next")
assert(not C:LoadProfile("Missing"))
assert(env.ProfileId == "Next" and saved.Speed == 12)
assert(not C:LoadProfile("Corrupt"))
assert(env.ProfileId == "Next" and saved.Speed == 12)
C.StartUp = true
assert(C:LoadProfile("Default") and env.ProfileId == "Default")
''')

    def test_remote_loader_raw_source_and_timeout(self):
        code = section('src/client/init.client.lua', 'function C.RunLink', '--print("3")')
        self.run_luau(r'''
local C = {}
local PrintName = "test"
local warnings = {}
local warn = function(message) table.insert(warnings, message) end
local now, cancelled, hanging = 0, false, false
local os = {clock=function() return now end}
local task = {
    spawn=function(f) if not hanging then f() end return {} end,
    wait=function() now += 1 end,
    cancel=function() cancelled=true end,
}
local response = "return {ok=true}"
local game = {HttpGet=function(_, url)
    assert(url == "https://raw.githubusercontent.com/owner/repo/main/src/Module.lua")
    return response
end}
''' + code + r'''
local url = "https://github.com/owner/repo/%s/main/src/%s.lua"
assert(C.RunLink(url, "blob", "Module").ok)
assert(C.RunLink(url, "raw", "Module").ok)
response = "not valid source"
assert(C.RunLink(url, "blob", "Module") == nil and #warnings == 1)
hanging = true
assert(C.RunLink(url, "blob", "Module") == nil)
assert(cancelled and now == 15 and #warnings == 2)
''')

    def test_option_defaults_and_slider_without_digits(self):
        combined = section('src/client/Modules/HackOptions.lua', '\tlocal function SetValueCombined', '\tfunction ToggleTbl.new')
        slider = section('src/client/Modules/HackOptions.lua', '\tfunction SliderTbl.new', '\tlocal DropdownFunct')
        dropdown = section('src/client/Modules/HackOptions.lua', '\tlocal DropdownFunct', '\tfunction UserListTbl.new')
        self.run_luau(r'''
local SliderTbl, DropdownTbl = {}, {}
local signal = {Connect=function() end}
local function widget()
    return {AbsoluteSize={X=100,Y=20}, AbsolutePosition={X=0,Y=0},
        FocusLost=signal, InputBegan=signal, InputChanged=signal, InputEnded=signal,
        WaitForChild=function() return widget() end}
end
local savedDefault
local function DoCombined(tbl, _, _, options)
    local frame = {WaitForChild=function() return widget() end}
    local self = setmetatable(options, {__index=tbl})
    self.EnHackTbl = {}
    return self, frame, savedDefault or options.Default
end
local C = {UI={DropdownFrame={}}, Examples={DropdownButtonEx={}}, ButtonClick=function() end}
local TS = {Create=function() return {Play=function() end} end}
local TweenInfo = {new=function() end}
local UDim2 = {fromScale=function() end}
''' + combined + slider + dropdown + r'''
local slider = SliderTbl.new({}, {Min=0, Max=10, Default=3, Shortcut="value"})
assert(slider.Digits == 0 and slider.Step == 1 and slider.Value == 3)
assert(slider:FormatValue(2.7) == 3)
local dropdown = DropdownTbl.new({}, {Selections={"first", "second"}, Default=1, Shortcut="choice"})
assert(dropdown.Value == "first")
savedDefault = "removed option"
dropdown = DropdownTbl.new({}, {Selections={"first", "second"}, Default=2, Shortcut="choice"})
assert(dropdown.Value == "second")
assert(not pcall(DropdownTbl.new, {}, {Selections={}, Default=1, Shortcut="choice"}))
''')

    def test_destroy_completion_survives_cleanup_errors(self):
        code = section('src/client/Modules/CoreEnv.lua', '\t\tlocal RemoveOnDestroyIndex = 0', '\t\tfor category, groupedTabData')
        self.run_luau(r'''
local C = {DebugMessage=function() end}
local warned = false
local warn = function() warned = true end
local task = {spawn=function(f) f() end, delay=function() end}
''' + code + r'''
RunOnDestroy({Shortcut="failing", RunOnDestroy=function() error("cleanup failed") end}, "test")
assert(warned and RemoveOnDestroyIndex == 0 and next(ThingsToRemove) == nil)
''')

    def test_api_retry_and_profile_reference_preservation(self):
        code = section('src/client/Modules/CoreEnv.lua', '\tfunction C.API', '\tlocal function CreateStoragePath')
        self.run_luau(r'''
local C = {}
function C.AddNotification() end
local warn = function() end
local waits = 0
local task = {wait = function() waits += 1 end}
''' + code + r'''
local count = 0
local function unreliable()
    count += 1
    if count < 3 then error("retry") end
    return "ok"
end
local success, value = C.API(unreliable, nil, -1)
assert(success and value == "ok" and count == 3 and waits == 2)
count, waits = 0, 0
success = C.API(unreliable, nil, 2)
assert(not success and count == 2 and waits == 1)
local options = {En=true, Speed=7, Removed=true}
local settings = {Movement=options}
UpdateSavedTable(settings, {Movement={En=false, Speed=12}})
assert(settings.Movement == options and options.Speed == 12 and options.En == false and options.Removed == nil)
UpdateSavedTable(settings, {}, true)
assert(settings.Movement == options and next(options) == nil)
''')


if __name__ == "__main__":
    unittest.main()

