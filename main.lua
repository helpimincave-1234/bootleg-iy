--i made this because i was bored
--and because infinite yield sucks
local date = os.date("*t")
if getgenv().bootlegiyloaded == true then
    error("BOOTLEG IY ALREADY LOADED, PLEASE DETACH", 0)
    return
end

function isNumber(str)
    if tonumber(str) ~= nil or str == "inf" then
        return true
    end
end

function missing(t, f, fallback)
    if type(f) == t then return f end
    warn("api not found: " .. tostring(f))
    return
end

local function getRoot(char)
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end

--HELPIMINCAVE VIBECODED THIS FUNCTION BOO THEM BOOO BOOO BOOO BOOO
local function hexToString(hex)
    local str = ""
    -- Iterate over the hex string in pairs of characters
    for i = 1, #hex, 2 do
        -- Convert each pair of hex characters to a byte and append it to the result string
        local byte = tonumber(hex:sub(i, i+1), 16)  -- Convert hex pair to a number
        if byte then
            str = str .. string.char(byte)  -- Convert byte to character and add to the result
        end
    end
    return str
end

local function round(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

getgenv().bootlegiyloaded = true

local Clip

local version = "0.0.2"

identifyexecutor = missing("function", identifyexecutor, function(...) return ... end)
isfile = missing("function", isfile, function(...) return ... end)
readfile = missing("function", readfile, function(...) return ... end)
delfile = missing("function", delfile, function(...) return ... end)
appendfile = missing("function", appendfile, function(...) return ... end)
cloneref = missing("function", cloneref, function(...) return ... end)
getgenv = missing("function", getgenv, function(...) return ... end)
gethui = missing("function", gethui, function(...) return ... end)

local char = game.Players.LocalPlayer.Character

local UserInputService = cloneref(game:GetService("UserInputService"))
local RunService = cloneref(game:GetService("RunService"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local SoundService = cloneref(game:GetService("SoundService"))
local TweenService = cloneref(game:GetService("TweenService"))
local HttpService = cloneref(game:GetService("HttpService"))
local players = cloneref(game:GetService("Players"))
local Players = cloneref(game:GetService("Players"))


local bootlegIY = Instance.new("ScreenGui")
local holder = Instance.new("Frame")
local title = Instance.new("TextLabel")
local cmdbar = Instance.new("TextBox")
local cmds = Instance.new("ScrollingFrame")
local list = Instance.new("UIListLayout")

bootlegIY.Name = "bootlegIY"
bootlegIY.Parent = gethui()
bootlegIY.ZIndexBehavior = Enum.ZIndexBehavior.Global
bootlegIY.ResetOnSpawn = false
bootlegIY.DisplayOrder = 100

holder.Name = "holder"
holder.Parent = bootlegIY
holder.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
holder.BorderColor3 = Color3.fromRGB(0, 0, 0)
holder.BorderSizePixel = 0
holder.Position = UDim2.new(1, -250, 1, -220)
holder.Size = UDim2.new(0, 250, 0, 220)

list.Parent = cmds

title.Name = "title"
title.Parent = holder
title.BackgroundColor3 = Color3.fromRGB(36, 36, 37)
title.BorderColor3 = Color3.fromRGB(0, 0, 0)
title.BorderSizePixel = 0
title.Size = UDim2.new(0, 250, 0, 20)
title.Font = Enum.Font.SourceSans
title.Text = "bootleg IY FE v" .. version
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18.000

cmdbar.Name = "cmdbar"
cmdbar.Parent = holder
cmdbar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
cmdbar.BackgroundTransparency = 1.000
cmdbar.BorderColor3 = Color3.fromRGB(0, 0, 0)
cmdbar.BorderSizePixel = 0
cmdbar.Position = UDim2.new(0, 5, 0, 20)
cmdbar.Size = UDim2.new(0, 240, 0, 25)
cmdbar.Font = Enum.Font.SourceSans
cmdbar.PlaceholderText = "command bar (;)"
cmdbar.Text = ""
cmdbar.ClearTextOnFocus = false
cmdbar.TextColor3 = Color3.fromRGB(255, 255, 255)
cmdbar.TextSize = 18.000
cmdbar.TextXAlignment = Enum.TextXAlignment.Left

cmds.Name = "cmds"
cmds.Parent = holder
cmds.Active = true
cmds.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
cmds.BackgroundTransparency = 1.000
cmds.BorderColor3 = Color3.fromRGB(0, 0, 0)
cmds.BorderSizePixel = 0
cmds.Position = UDim2.new(0, 5, 0, 45)
cmds.Size = UDim2.new(0, 245, 0, 175)
cmds.ScrollBarThickness = 8
cmds.VerticalScrollBarInset = Enum.ScrollBarInset.Always
cmds.ScrollingDirection = Enum.ScrollingDirection.Y

if date.month == 4 and date.day == 1 then
    title.Text = "fortnite hack v" .. version
elseif date.month == 12 and date.day == 25 then
    title.Text = "merry christmas hohoho"
end

local commands = {}

function addcmd(name, aliases, callback)
    commands[name] = callback

    if aliases then
        for _, alias in ipairs(aliases) do
            commands[alias] = callback
        end
    end

    local label = Instance.new("TextLabel")
    label.Parent = cmds
    label.Size = UDim2.new(1, -10, 0, 20)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.SourceSans
    label.TextSize = 16
    label.Text = name

    if aliases then
        label.Text = label.Text .. "/" .. table.concat(aliases, "/") .. ""
    end
end

UserInputService.InputBegan:Connect(function (inp, gpe)
    if gpe then return end

    if inp.KeyCode == Enum.KeyCode.Semicolon then
        cmdbar:CaptureFocus()
    end
end)

local function parseInput(text)
    local args = {}
    local current = ""
    local inQuotes = false

    for i = 1, #text do
        local char = text:sub(i, i)

        if char == '"' then
            inQuotes = not inQuotes
        elseif char == " " and not inQuotes then
            if current ~= "" then
                table.insert(args, current)
                current = ""
            end
        else
            current = current .. char
        end
    end

    if current ~= "" then
        table.insert(args, current)
    end

    local cmdName = table.remove(args, 1)

    if commands[cmdName] then
        return cmdName, args
    end

    for command, _ in pairs(commands) do
        -- Compare aliases or main command directly
        if table.find(commandAliases[command] or {}, cmdName) then
            cmdName = command
            break
        end
    end

    return cmdName, args
end

local function refreshCommandList(filter)
    for _, child in ipairs(cmds:GetChildren()) do
        if child:IsA("TextLabel") then
            child.Visible = true

            if filter and filter ~= "" then
                if not child.Text:lower():find(filter:lower(), 1, true) then
                    child.Visible = false
                end
            end
        end
    end
end

function execCmd(commandText)
    local cmdName, args = parseInput(commandText)
    if commands[cmdName] then
        local speaker = game.Players.LocalPlayer
        commands[cmdName](unpack(args), speaker)
    else
        warn("Unknown command: " .. cmdName)
    end
end

addcmd("", {}, function() end)

addcmd("unctest", {}, function()
    local UNC_Checkup = {}
    function UNC_Checkup.checkenv(fenv)
        local failed = 0
        local success = 0
        local missing_aliases = 0

        local test = function(name, aliases)
            local parts = name:split(".")
            local func = parts[1]
            local member = parts[2]

            if fenv[func] ~= nil then
                if member then
                    if type(fenv[func]) == "table" and fenv[func][member] then
                        print("✅ " .. name)
                        success = success + 1
                    else
                        warn("⛔ " .. name .. " failed")
                        failed = failed + 1
                    end
                else
                    print("✅ " .. func)
                    success = success + 1
                end
            else
                warn("⛔ " .. name .. " failed")
                failed = failed + 1
            end

            if #aliases > 0 then
                for _, alias in ipairs(aliases) do
                    local a_parts = alias:split(".")
                    local a_func = a_parts[1]
                    local a_member = a_parts[2]

                    if fenv[a_func] ~= nil then
                        if a_member then
                            if type(fenv[a_func]) == "table" and fenv[a_func][a_member] then
                                print("✅ " .. alias)
                            else
                                warn("⚠️ " .. alias .. " failed")
                            end
                        else
                            print("✅ " .. a_func)
                        end
                    else
                        missing_aliases = missing_aliases + 1
                    end
                end
            end
        end

        -- ALL UNC TESTS
        test("cache.invalidate", {})
        test("cache.iscached", {})
        test("cache.replace", {})
        test("cloneref", {})
        test("compareinstances", {})
        test("checkcaller", {})
        test("clonefunction", {})
        test("getcallingscript", {})
        test("getscriptclosure", {"getscriptfunction"})
        test("hookfunction", {"replaceclosure"})
        test("iscclosure", {})
        test("islclosure", {})
        test("isexecutorclosure", {"checkclosure", "isourclosure"})
        test("loadstring", {})
        test("newcclosure", {})
        test("rconsoleclear", {"consoleclear"})
        test("rconsolecreate", {"consolecreate"})
        test("rconsoledestroy", {"consoledestroy"})
        test("rconsoleinput", {"consoleinput"})
        test("rconsoleprint", {"consoleprint"})
        test("rconsolesettitle", {"rconsolename", "consolesettitle"})
        test("crypt.base64encode", {"crypt.base64.encode", "crypt.base64_encode", "base64.encode", "base64_encode"})
        test("crypt.base64decode", {"crypt.base64.decode", "crypt.base64_decode", "base64.decode", "base64_decode"})
        test("crypt.encrypt", {})
        test("crypt.decrypt", {})
        test("crypt.generatebytes", {})
        test("crypt.generatekey", {})
        test("crypt.hash", {})
        test("debug.getconstant", {})
        test("debug.getconstants", {})
        test("debug.getinfo", {})
        test("debug.getproto", {})
        test("debug.getprotos", {})
        test("debug.getstack", {})
        test("debug.getupvalue", {})
        test("debug.getupvalues", {})
        test("debug.setconstant", {})
        test("debug.setstack", {})
        test("debug.setupvalue", {})
        test("readfile", {})
        test("listfiles", {})
        test("writefile", {})
        test("makefolder", {})
        test("appendfile", {})
        test("isfile", {})
        test("isfolder", {})
        test("delfolder", {})
        test("delfile", {})
        test("loadfile", {})
        test("dofile", {})
        test("isrbxactive", {"isgameactive"})
        test("mouse1click", {})
        test("mouse1press", {})
        test("mouse1release", {})
        test("mouse2click", {})
        test("mouse2press", {})
        test("mouse2release", {})
        test("mousemoveabs", {})
        test("mousemoverel", {})
        test("mousescroll", {})
        test("fireclickdetector", {})
        test("getcallbackvalue", {})
        test("getconnections", {})
        test("getcustomasset", {})
        test("gethiddenproperty", {})
        test("sethiddenproperty", {})
        test("gethui", {})
        test("getinstances", {})
        test("getnilinstances", {})
        test("isscriptable", {})
        test("setscriptable", {})
        test("setrbxclipboard", {})
        test("getrawmetatable", {})
        test("hookmetamethod", {})
        test("getnamecallmethod", {})
        test("isreadonly", {})
        test("setrawmetatable", {})
        test("setreadonly", {})
        test("identifyexecutor", {"getexecutorname"})
        test("lz4compress", {})
        test("lz4decompress", {})
        test("messagebox", {})
        test("queue_on_teleport", {"queueonteleport"})
        test("request", {"http.request", "http_request"})
        test("setclipboard", {"toclipboard"})
        test("setfpscap", {})
        test("getgc", {})
        test("getgenv", {})
        test("getloadedmodules", {})
        test("getrenv", {})
        test("getrunningscripts", {})
        test("getscriptbytecode", {"dumpstring"})
        test("getscripthash", {})
        test("getscripts", {})
        test("getsenv", {})
        test("getthreadidentity", {"getidentity", "getthreadcontext"})
        test("setthreadidentity", {"setidentity", "setthreadcontext"})
        test("Drawing", {})
        test("Drawing.new", {})
        test("Drawing.Fonts", {})
        test("isrenderobj", {})
        test("getrenderproperty", {})
        test("setrenderproperty", {})
        test("cleardrawcache", {})
        test("WebSocket", {})
        test("WebSocket.connect", {})
        
        return success, failed, missing_aliases
    end

    -- RUN THE TEST
    local s, f, m = UNC_Checkup.checkenv(getgenv())
    local total = s + f
    local percent = math.floor((s / total) * 100)

    print("\n--- [ UNC RESULTS ] ---")
    print("✅ Passed: " .. s)
    print("⛔ Failed: " .. f)
    print("⚠️ Missing Aliases: " .. m)
    print("📊 Compatibility: " .. percent .. "%")
    print("-----------------------")
end)

addcmd("april fool", {"april"}, function() 
    title.Text = "fortnite hack v" .. version
end)

local CFspeed = 50
addcmd("cframefly", {"cfly", "cffly"}, function (args, speaker)
    speaker.Character:FindFirstChildOfClass('Humanoid').PlatformStand = true
    local Head = speaker.Character:WaitForChild("Head")
    Head.Anchored = true
    if CFloop then CFloop:Disconnect() end
    CFloop = RunService.Heartbeat:Connect(function(deltaTime)
        local moveDirection = speaker.Character:FindFirstChildOfClass('Humanoid').MoveDirection * (CFspeed * deltaTime)
        local headCFrame = Head.CFrame
        local camera = workspace.CurrentCamera
        local cameraCFrame = camera.CFrame
        local cameraOffset = headCFrame:ToObjectSpace(cameraCFrame).Position
        cameraCFrame = cameraCFrame * CFrame.new(-cameraOffset.X, -cameraOffset.Y, -cameraOffset.Z + 1)
        local cameraPosition = cameraCFrame.Position
        local headPosition = headCFrame.Position

        local objectSpaceVelocity = CFrame.new(cameraPosition, Vector3.new(headPosition.X, cameraPosition.Y, headPosition.Z)):VectorToObjectSpace(moveDirection)
        Head.CFrame = CFrame.new(headPosition) * (cameraCFrame - cameraPosition) * CFrame.new(objectSpaceVelocity)
    end)
end)

addcmd("uncfly", {"uncfly"}, function (args, speaker)
    -- Disable the flying behavior by disconnecting the flying loop if it exists
    if CFloop then
        CFloop:Disconnect()
        CFloop = nil
    end

    -- Restore the character's normal movement by disabling PlatformStand
    local humanoid = speaker.Character:FindFirstChildOfClass('Humanoid')
    if humanoid then
        humanoid.PlatformStand = false
    end

    -- Un-anchor the head so it can move normally with physics again
    local Head = speaker.Character:FindFirstChild("Head")
    if Head then
        Head.Anchored = false
    end
end)

local function updateAutoComplete(inputText)
    for _, child in ipairs(cmds:GetChildren()) do
        if child:IsA("TextLabel") then
            if child.Text:lower():find(inputText:lower(), 1, true) then
                child.Visible = true
            else
                child.Visible = false
            end
        end
    end
end

addcmd("httpget", {"http"}, function(args)
    loadstring(game:HttpGet(tostring(args)))()
end)

addcmd("detach", {"de", "remove"}, function()
    bootlegIY:Destroy()
    getgenv().bootlegiyloaded = false
end)

local Noclipping = nil
addcmd('noclip',{},function(args, speaker)
    Clip = false
    wait(0.1)
    local function NoclipLoop()
        if Clip == false and speaker.Character ~= nil then
            for _, child in pairs(speaker.Character:GetDescendants()) do
                if child:IsA("BasePart") and child.CanCollide == true and child.Name ~= floatName then
                    child.CanCollide = false
                end
            end
        end
    end
    Noclipping = RunService.Stepped:Connect(NoclipLoop)
end)



addcmd('clip',{'unnoclip', 'yesclip'},function(args, speaker)
    if Noclipping then
        Noclipping:Disconnect()
    end
    Clip = true
end)

addcmd('togglenoclip',{},function(args, speaker)
    if Clip then
        execCmd('noclip')
    else
        execCmd('clip')
    end
end)

addcmd("dance", {"emote"}, function()
    local danceAnim = Instance.new("Animation")
    danceAnim.AnimationId = "rbxassetid://182491277"
    local humanoid = char:FindFirstChild("Humanoid")
    humanoid:LoadAnimation(danceAnim):Play()
end)

cmdbar:GetPropertyChangedSignal("Text"):Connect(function()
    updateAutoComplete(cmdbar.Text)
end)

cmdbar.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local commandText = cmdbar.Text
        local cmdName, args = parseInput(commandText)

        if commands[cmdName] then
            local speaker = game.Players.LocalPlayer
            commands[cmdName](unpack(args), speaker)
        else
            warn("Unknown command: " .. cmdName)
        end

        cmdbar.Text = ""
    end
end)

flinging = false
addcmd('fling',{},function(args, speaker)
    flinging = false
    for _, child in pairs(speaker.Character:GetDescendants()) do
        if child:IsA("BasePart") then
            child.CustomPhysicalProperties = PhysicalProperties.new(math.huge, 0.3, 0.5)
        end
    end
    execCmd('noclip')
    wait(.1)
    local flingy = Instance.new("BodyAngularVelocity")
    flingy.Name = "FLINGYY!11!11!"
    flingy.Parent = getRoot(speaker.Character)
    flingy.AngularVelocity = Vector3.new(0,99999,0)
    flingy.MaxTorque = Vector3.new(0,math.huge,0)
    flingy.P = math.huge
    local Char = speaker.Character:GetChildren()
    for i, v in next, Char do
        if v:IsA("BasePart") then
            v.CanCollide = false
            v.Massless = true
            v.Velocity = Vector3.new(0, 0, 0)
        end
    end
    flinging = true
    local function flingDiedF()
        execCmd('unfling')
    end
    flingDied = speaker.Character:FindFirstChildOfClass('Humanoid').Died:Connect(flingDiedF)
    repeat
        flingy.AngularVelocity = Vector3.new(0,99999,0)
        wait(.2)
        flingy.AngularVelocity = Vector3.new(0,0,0)
        wait(.1)
    until flinging == false
end)

addcmd('unfling',{'nofling'},function(args, speaker)
    execCmd('clip')
    if flingDied then
        flingDied:Disconnect()
    end
    flinging = false
    wait(.1)
    local speakerChar = speaker.Character
    if not speakerChar or not getRoot(speakerChar) then return end
    for i,v in pairs(getRoot(speakerChar):GetChildren()) do
        if v.ClassName == 'BodyAngularVelocity' then
            v:Destroy()
        end
    end
    for _, child in pairs(speakerChar:GetDescendants()) do
        if child.ClassName == "Part" or child.ClassName == "MeshPart" then
            child.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5)
        end
    end
end)

addcmd('togglefling',{},function(args, speaker)
    if flinging then
        execCmd('unfling')
    else
        execCmd('fling')
    end
end)

addcmd("speed", {"sp"}, function(args)
    if #args > 0 then
        local speed = tonumber(args)
        if speed then
            char.Humanoid.WalkSpeed = speed
        else
            warn("Invalid speed value")
        end
    else
        warn("No speed value provided")
    end
end)

addcmd("fesounds", {"feS"}, function()
    SoundService.RespectFilteringEnabled = true
end)

addcmd("nonfesounds", {"nonfeS"}, function()
    SoundService.RespectFilteringEnabled = false
end)

addcmd("phonk", {"THOSE WHO KNOW💀"}, function()
    local char = game.Players.LocalPlayer.Character
    if char then
        local s = Instance.new("Sound")
        s.Volume = 10
        s.SoundId = "rbxassetid://140675348569592"
        s.Parent = char:FindFirstChild("HumanoidRootPart")
        s:Play()  
        print("sigma")
    else
        warn("no sigma")
    end
end)

addcmd("tp", {"teleport"}, function(args)
    local targetPlayer = game.Players:FindFirstChild(args[1])
    if targetPlayer then
        local targetChar = targetPlayer.Character
        if targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = targetChar.HumanoidRootPart.CFrame
        else
            warn("Target player does not have a HumanoidRootPart!")
        end
    else
        warn("Player not found!")
    end
end)

addcmd("fps", {"togglefps"}, function()
    local fpsTextLabel = Instance.new("TextLabel")
    fpsTextLabel.Parent = bootlegIY
    fpsTextLabel.Position = UDim2.new(0.95, 0, 0, 0)
    fpsTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    fpsTextLabel.BackgroundTransparency = 1
    fpsTextLabel.Font = Enum.Font.SourceSans
    fpsTextLabel.TextSize = 18

    game:GetService("RunService").RenderStepped:Connect(function()
        fpsTextLabel.Text = "FPS: " .. math.floor(1 / game:GetService("RunService").Heartbeat:Wait())
    end)
end)

addcmd("invisible", {"invis", "ghost"}, function(args)
    local character = game.Players.LocalPlayer.Character
    if character then
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Transparency = 1 
            end
        end
        print("You are now invisible!")
    else
        warn("Character not found!")
    end
end)

addcmd("uninvisible", {"uninvis", "unghost"}, function(args)
    local character = game.Players.LocalPlayer.Character
    if character then
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Transparency = 0
            end
        end
        print("You are now invisible!")
    else
        warn("Character not found!")
    end
end)

addcmd("gravity", {"setgravity"}, function(args, speaker)
    local gravity = tonumber(args)
    if gravity then
        game.Workspace.Gravity = gravity
        print("Gravity set to " .. gravity)
    else
        warn("Invalid gravity value.")
    end
end)

addcmd("headsit", {"hsit"}, function(args, speaker)
    local char = speaker.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and getRoot(char)
    if not humanoid or not root then return end

    local closestChar
    local closestDist = math.huge

    for _, model in pairs(workspace:GetChildren()) do
        if model:IsA("Model") and model ~= char then
            local hum = model:FindFirstChildOfClass("Humanoid")
            local head = model:FindFirstChild("Head")
            local r = getRoot(model)

            if hum and head and r then
                local dist = (r.Position - root.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closestChar = model
                end
            end
        end
    end

    if not closestChar then
        warn("No character found")
        return
    end

    local targetHead = closestChar:FindFirstChild("Head")
    if not targetHead then return end

    -- sit animation
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://507768133"
    local track = humanoid:LoadAnimation(anim)
    track:Play()

    humanoid.Sit = true

    -- position above head
    root.CFrame = targetHead.CFrame * CFrame.new(0, 2.2, 0)

    local bp = Instance.new("BodyPosition")
    bp.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    bp.P = 1e5
    bp.D = 1000
    bp.Position = root.Position
    bp.Parent = root

    local loop
    loop = game:GetService("RunService").Heartbeat:Connect(function()
        if not char or not closestChar or not targetHead then
            loop:Disconnect()
            return
        end

        bp.Position = targetHead.Position + Vector3.new(0, 2.2, 0)

        -- auto unheadsit on jump
        if humanoid.Jump or humanoid:GetState() == Enum.HumanoidStateType.Jumping then
            bp:Destroy()
            track:Stop()
            humanoid.Sit = false
            loop:Disconnect()
        end
    end)
end)

local orbiting = false
local orbitLoop

addcmd("youtube", {}, function()
    print("youtube")
end)

addcmd("japan", {}, function()
    Instance.new("Hint", workspace).Text =  "#🇯🇵 Japan is turning footsteps into electricity! Using piezoelectric tiles, every step you take generates a small amount of energy. Millions of steps together can power LED lights and displays in busy places like Shibuya Station. A brilliant way to create a sustainable and smart city turning m..."
end)

addcmd("chatfilter", {}, function()
    local function censorGui(gui)
        for _, v in ipairs(gui:GetDescendants()) do
            if v:IsA("TextLabel") or v:IsA("TextButton") then
                v.Text = "#######"
            end
        end
    end

    censorGui(game.CoreGui)
    censorGui(game.Workspace)
    censorGui(game.Players.LocalPlayer:WaitForChild("PlayerGui"))
end)

addcmd("crash", {"DO NOT RUN THIS!!!"}, function()
    while true do end
end)


addcmd("orbit", {}, function(args, speaker)
    local targetName = args[1]
    local speed = tonumber(args[2]) or 2
    local radius = tonumber(args[3]) or 6

    local char = speaker.Character
    local root = getRoot(char)
    if not root then return end

    local targetChar

    if targetName then
        local plr = game.Players:FindFirstChild(targetName)
        if not plr or not plr.Character then
            warn("Target not found")
            return
        end
        targetChar = plr.Character
    else
        targetChar = char
    end

    local targetRoot = getRoot(targetChar)
    if not targetRoot then return end

    orbiting = true
    local angle = 0

    if orbitLoop then orbitLoop:Disconnect() end

    orbitLoop = game:GetService("RunService").Heartbeat:Connect(function(dt)
        if not orbiting then return end
        if not targetRoot or not root then return end

        angle = angle + dt * speed
        local x = math.cos(angle) * radius
        local z = math.sin(angle) * radius

        local pos = targetRoot.Position + Vector3.new(x, 2, z)
        root.CFrame = CFrame.new(pos, targetRoot.Position)
    end)
end)

addcmd("bring", {"brng"}, function(args, caller)
    if args[1] == "all" then
            local a = game.Workspace[args[1]]
        if a:FindFirstChildOfClass("Humanoid") then
            a:MoveTo(char.HumanoidRootPart.Position)
        end
    else
        local a = game.Workspace[args[1]]
        if a:FindFirstChildOfClass("Humanoid") then
            a:MoveTo(char.HumanoidRootPart.Position)
        end
    end
end)

addcmd("unorbit", {}, function()
    orbiting = false
    if orbitLoop then
        orbitLoop:Disconnect()
        orbitLoop = nil
    end
end)

addcmd("sound", {}, function(args)
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://" .. args
    s.Volume = args[2]
    s.Parent = char:FindFirstChild("HumanoidRootPart")
    s.Looped = false
end)

local count = 0
for _, _ in pairs(commands) do
    count = count + 1
end
print(count)

cmds.CanvasSize = UDim2.new(0, 0, 0, count * 16) 

print("bootlegIY loaded \n caller: \n executor: " .. identifyexecutor() .. " | game: " .. game.Name )
