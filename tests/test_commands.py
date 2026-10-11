"""Command parsing, execution, and palette interaction regression checks."""
import unittest
import test_regressions as support


@unittest.skipUnless(support.LUAU.is_file(), "Set LUAU to the Luau CLI executable")
class CommandTests(unittest.TestCase):
    run_luau = support.RuntimeTests.run_luau

    def source(self, name):
        return (support.ROOT / "src/client/Modules" / (name + ".lua")).read_text(encoding="utf-8")

    def test_command_parsing_and_completion(self):
        self.run_luau("local Input = (function()\n" + self.source("CommandInput") + "\nend)()()\n" + r'''
local tokens = Input.Parse([[;color   me "Dark brown" 12]])
assert(#tokens == 4 and tokens[1] == "color" and tokens[3] == "Dark brown")
assert(select(3, Input.Parse([[color "unfinished]])))
local _, word, first, last, query = Input.Context(";color me bl later", 12)
assert(word == 3 and query == "b")
local text, cursor = Input.Complete(";color me bl later", first, last, "Dark brown")
assert(text == [[;color me "Dark brown" later]])
assert(cursor == 23)
local parsed = Input.Parse(text)
assert(parsed[3] == "Dark brown" and parsed[4] == "later")
local value = [[a "quote" and \ slash]]
local escaped = Input.Complete("cmd ", 5, 5, value)
assert(Input.Parse(escaped)[2] == value)
local commands = {color={}, copy={}, spectate={}}
commands.spec = commands.spectate
local name, data = Input.Resolve(commands, "COLOR")
assert(name == "color" and data == commands.color)
assert(select(3, Input.Resolve(commands, "co")) == "ambiguous")
assert(select(2, Input.Resolve(commands, "spec")) == commands.spectate)
assert(Input.Resolve(commands, "") == nil)
local suggestions = Input.Filter({{"123", "Alice"}, {"Alpha", "Alpha"}, {"123", "Alice"}}, "al")
assert(#suggestions == 2 and suggestions[1][1] == "123")
local _, nextWord = Input.Context(";color me ", 11)
assert(nextWord == 3)
''')

    def test_execution_exact_match_quotes_and_invalid_parameters(self):
        self.run_luau("local Input = (function()\n" + self.source("CommandInput") + "\nend)()()\n" + r'''
local game = {GetService=function() return {UrlEncode=function(_, text) return text end} end}
local Color3 = {fromRGB=function() end}
local ran, notices = nil, {}
local commands = {
    copy={Parameters={{Type="String"}}, Run=function(_, args) ran=args[1] return true end},
    color={Parameters={}, Run=function() ran="color" return true end},
    randomtest={Parameters={{Type="Players"}}, Run=function() error("must not run") end},
    optiontest={Parameters={{Type="Options", Options={"yes"}}}, Run=function() error("must not run") end},
}
local saved = {}
local C = {CommandFunctions=commands, InsertCommandFunctions={}, plr={Name="me"}}
function C.LoadModule(name) if name == "Modules/CommandInput" then return Input end end
function C.getgenv() return saved end
function C.BindEvents() end
function C.CreateSysMessage(message) table.insert(notices, message) end
function C.GetNonFriends() return {} end
function C.StringStartsWith() return {} end
local task = {spawn=function(f, ...) f(...) end}
''' + "\nlocal init = (function()\n" + self.source("CommandCore") + "\nend)()\ninit(C, {})\n" + r'''
C.RunCommand([[;COPY "two words"]], true, false, true)
assert(ran == "two words" and #C.savedCommands == 1)
ran = nil
C.RunCommand(";co", false, false, true)
assert(ran == nil and notices[#notices]:find("Ambiguous"))
C.RunCommand(";randomtest random", false, false, true)
assert(notices[#notices] == "No eligible players found")
C.RunCommand(";optiontest", false, false, true)
assert(notices[#notices]:find("not optional"))
C.RunCommand([[copy "unfinished]], false, false, true)
assert(notices[#notices]:find("quoted argument"))
''')

    def test_typing_does_not_trigger_feature_shortcuts(self):
        code = support.section("src/client/Modules/Binds.lua", "\tfunction C.BindAction", "\t--Set Binds for UI")
        self.run_luau(r'''
local C = {BindedActions={}, keybinds={}, enHacks={Test={Feature={}}}}
local callback, focused, toggles = nil, true, 0
local CAS = {BindActionAtPriority=function(_, _, cb) callback=cb end}
local UIS = {GetFocusedTextBox=function() return focused end, IsKeyDown=function() return false end}
local Enum = {KeyCode={}, UserInputState={Begin="Begin"}, ContextActionResult={Pass="Pass"}}
local feature = {Parent={Category={Name="Test"}}, Shortcut="Feature"}
function feature:SetValue() toggles += 1 end
''' + code + r'''
C.AddKeybind({Name="K"}, feature)
assert(callback("", "Begin") == "Pass" and toggles == 0)
focused = nil
callback("", "Begin")
assert(toggles == 1)
''')

    def test_palette_touch_keyboard_and_submission(self):
        self.run_luau("local Input = (function()\n" + self.source("CommandInput") + "\nend)()()\n" + r'''
local function signal()
    local s = {callbacks={}}
    function s:Connect(callback)
        table.insert(self.callbacks, callback)
        return {Disconnect=function() end}
    end
    function s:Fire(...) for _, callback in ipairs(self.callbacks) do callback(...) end end
    return s
end
local objects = {}
local function widget(class)
    local object = {ClassName=class, ZIndex=60, Text="", CursorPosition=1, signals={},
        AbsoluteSize={X=390,Y=800}, AbsolutePosition={X=0,Y=0}, CanvasPosition={X=0,Y=0},
        Activated=signal(), FocusLost=signal(), ReturnPressedFromOnScreenKeyboard=signal()}
    function object:GetPropertyChangedSignal(name)
        self.signals[name] = self.signals[name] or signal()
        return self.signals[name]
    end
    function object:CaptureFocus() self.focused=true end
    function object:IsFocused() return self.focused end
    function object:ReleaseFocus(enter) self.focused=false self.FocusLost:Fire(enter) end
    function object:Destroy() self.destroyed=true end
    table.insert(objects, object)
    return object
end
local Instance = {new=widget}
local function value(...) return {...} end
local UDim2, UDim, Font, Color3 = {new=value, fromOffset=value}, {new=value}, {new=value}, {new=value, fromRGB=value}
local Vector2 = {new=function(x,y) return {X=x,Y=y} end, zero={X=0,Y=0}}
local Enum = setmetatable({}, {__index=function(_, group)
    return setmetatable({}, {__index=function(_, name) return group .. "." .. name end})
end})
local UIS = widget()
UIS.InputBegan=signal()
UIS.KeyboardEnabled=false
UIS.OnScreenKeyboardVisible=true
UIS.OnScreenKeyboardPosition={X=0,Y=460}
function UIS:GetFocusedTextBox() return nil end
local players = {PlayerAdded=signal(), PlayerRemoving=signal()}
local game = {GetService=function(_, name)
    if name == "UserInputService" then return UIS end
    if name == "GuiService" then return {GetGuiInset=function() return {X=0,Y=24} end} end
    return players
end}
local task = {spawn=function(f, ...) f(...) end, defer=function(f) f() end}
local C = {GUI=widget(), UI={Commandbar=widget(), ChatAutoComplete=widget()},
    CommandFunctions={color={Parameters={{Type="String"}}}, copy={Parameters={}}},
    savedCommands={";copy"}}
function C.LoadModule() return Input end
function C.AddGlobalConnection(connection) return connection end
local executions = {}
function C.RunCommand(text) table.insert(executions, text) end
''' + "\nlocal init = (function()\n" + self.source("CommandPalette") + "\nend)()\ninit(C)\n" + r'''
C.OpenCommandBar()
local bar = C.UI.Commandbar
assert(bar.ShowNativeInput == true and bar.focused)
local panel = bar.Parent
assert(panel.Size[2] <= 420) -- Fits above the keyboard.
local function live(name)
    for i = #objects, 1, -1 do
        if objects[i].Name == name and not objects[i].destroyed then return objects[i] end
    end
end
local row = live("color")
assert(row and row.Size[4] == 44)
-- Tapping a suggestion after focus loss retains the edit context.
bar.CursorPosition = -1
bar:ReleaseFocus(false)
assert(panel.Visible)
row.Activated:Fire()
assert(bar.Text == "color " and bar.focused)
UIS.KeyboardEnabled = true
UIS:GetPropertyChangedSignal("KeyboardEnabled"):Fire()
assert(bar.ShowNativeInput == false)
-- Both mobile return notifications must produce only one execution.
bar.ReturnPressedFromOnScreenKeyboard:Fire()
bar.FocusLost:Fire(true)
assert(#executions == 1 and executions[1] == "color ")
C.OpenCommandBar()
UIS.InputBegan:Fire({KeyCode=Enum.KeyCode.PageUp}, true)
assert(bar.Text == ";copy")
UIS.InputBegan:Fire({KeyCode=Enum.KeyCode.PageDown}, true)
assert(bar.Text == "")
UIS.InputBegan:Fire({KeyCode=Enum.KeyCode.Escape}, true)
assert(not panel.Visible)
''')
