local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/sxazyhub-ai/librery_k1ll/refs/heads/main/k1ll.lua", true))() 

local window = library:AddWindow("K1LLL COMUNITY ┃ PUBLIC KILLING ", {
    main_color = Color3.fromRGB(0, 0, 0),
    min_size = Vector2.new(500, 870),
    can_resize = false,
})

local Player = game:GetService("Players").LocalPlayer

local MainTab = window:AddTab("          Main          ")
local KillingTab = window:AddTab("          Killing          ")
local GodmodeTab = window:AddTab("     GodMode     ")
MainTab:Show()

local function checkCharacter()
    if not game.Players.LocalPlayer.Character then
        repeat task.wait() until game.Players.LocalPlayer.Character
    end
    return game.Players.LocalPlayer.Character
end

local function gettool()
    for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v.Name == "Punch" and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
        end
    end
    game.Players.LocalPlayer.muscleEvent:FireServer("punch", "leftHand")
    game.Players.LocalPlayer.muscleEvent:FireServer("punch", "rightHand")
end

local function isPlayerAlive(player)
    return player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and
           player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0
end

local function killPlayer(target)
    if not isPlayerAlive(target) then return end
    local character = checkCharacter()
    if character and character:FindFirstChild("LeftHand") then
        pcall(function()
            firetouchinterest(target.Character.HumanoidRootPart, character.LeftHand, 0)
            firetouchinterest(target.Character.HumanoidRootPart, character.LeftHand, 1)
            gettool()
        end)
    end
end

local player = game:GetService("Players").LocalPlayer

local comboActive = false
local eggLoop, characterAddedConn

local function ensureEggEquipped()
    if not comboActive or not player.Character then return end
    
    local eggsInHand = 0
    for _, item in ipairs(player.Character:GetChildren()) do
        if item.Name == "Protein Egg" then
            eggsInHand += 1
            if eggsInHand > 1 then
                item.Parent = player.Backpack
            end
        end
    end
    
    if eggsInHand == 0 then
        local egg = player.Backpack:FindFirstChild("Protein Egg")
        if egg then
            egg.Parent = player.Character
        end
    end
end

local comboSwitch = KillingTab:AddSwitch("Kill while dead (needs Protein Egg)", function(bool)
    comboActive = bool
    
    if bool then
        changeSpeedSizeRemote:InvokeServer("changeSize", 0/0)
        
        eggLoop = task.spawn(function()
            while comboActive do
                ensureEggEquipped()
                task.wait(0.2)
            end
        end)
        
        characterAddedConn = player.CharacterAdded:Connect(function(newChar)
            task.wait(0.5)
            ensureEggEquipped()
        end)
        
        ensureEggEquipped()
        
    else
        if eggLoop then task.cancel(eggLoop) end
        if characterAddedConn then characterAddedConn:Disconnect() end
    end
end)

    local vu155 = false

local switch = KillingTab:AddSwitch("Safe Spot For Killing", function(p156)
       vu155 = p156
        spawn(function()
            while vu155 do
                local v157 = game.Players.LocalPlayer
                local v158 = (v157.Character or v157.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart", 0.1)
                if v158 then
                    v158.CFrame = CFrame.new(- 12510.5, - 1.6537845134735107, 28019.103515625)
                end
                wait()
            end
        end)

end)


KillingTab:AddButton("Size nan", function()
    local args = {"changeSize", 0/0}
    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("changeSpeedSizeRemote"):InvokeServer(unpack(args))
end)

_G.whitelistedPlayers = _G.whitelistedPlayers or {}
_G.blacklistedPlayers = _G.blacklistedPlayers or {}

local function isWhitelisted(player)
    for _, name in ipairs(_G.whitelistedPlayers) do
        if name:lower() == player.Name:lower() then
            return true
        end
    end
    return false
end

local function isBlacklisted(player)
    for _, name in ipairs(_G.blacklistedPlayers) do
        if name:lower() == player.Name:lower() then
            return true
        end
    end
    return false
end

local function getPlayerDisplayText(player)
    return player.DisplayName .. " | " .. player.Name
end

local whitelistDropdown = KillingTab:AddDropdown("Add to Whitelist", function(selectedText)
    local playerName = selectedText:match("| (.+)$")
    if playerName then
        playerName = playerName:gsub("^%s*(.-)%s*$", "%1") 
        for _, name in ipairs(_G.whitelistedPlayers) do
            if name:lower() == playerName:lower() then return end
        end
        table.insert(_G.whitelistedPlayers, playerName)
    end
end)

local switch = KillingTab:AddSwitch("Auto Kill", function(bool)
    _G.killAll = bool
    if bool then
        if not _G.killAllConnection then
            local lastExecution = 0
            local executionInterval = 0.225
            local currentTargetIndex = 1
            
            _G.killAllConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if not _G.killAll then return end
                
                if tick() - lastExecution >= executionInterval then
                    lastExecution = tick()
                    
                    local players = game:GetService("Players"):GetPlayers()
                    local validTargets = {}
                    
                    for _, player in ipairs(players) do
                        if player ~= game.Players.LocalPlayer and not isWhitelisted(player) and isPlayerAlive(player) then
                            table.insert(validTargets, player)
                        end
                    end
                    
                    if #validTargets > 0 then
                        if currentTargetIndex > #validTargets then
                            currentTargetIndex = 1
                        end
                        
                        killPlayer(validTargets[currentTargetIndex])
                        currentTargetIndex = currentTargetIndex + 1
                    end
                end
            end)
        end
    else
        if _G.killAllConnection then
            _G.killAllConnection:Disconnect()
            _G.killAllConnection = nil
        end
    end
end)


local switch = KillingTab:AddSwitch("Whitelist Friends", function(bool)
    _G.whitelistFriends = bool

    if bool then
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player:IsFriendsWith(game.Players.LocalPlayer.UserId) then
                local playerName = player.Name
                local alreadyWhitelisted = false
                for _, name in ipairs(_G.whitelistedPlayers) do
                    if name:lower() == playerName:lower() then
                        alreadyWhitelisted = true
                        break
                    end
                end
                if not alreadyWhitelisted then
                    table.insert(_G.whitelistedPlayers, playerName)
                end
            end
        end

        game.Players.PlayerAdded:Connect(function(player)
            if _G.whitelistFriends and player:IsFriendsWith(game.Players.LocalPlayer.UserId) then
                local playerName = player.Name
                local alreadyWhitelisted = false
                for _, name in ipairs(_G.whitelistedPlayers) do
                    if name:lower() == playerName:lower() then
                        alreadyWhitelisted = true
                        break
                    end
                end
                if not alreadyWhitelisted then
                    table.insert(_G.whitelistedPlayers, playerName)
                end
            end
        end)
    end
end)

local blacklistDropdown = KillingTab:AddDropdown("Add to Blacklist", function(selectedText)
    local playerName = selectedText:match("| (.+)$")
    if playerName then
        playerName = playerName:gsub("^%s*(.-)%s*$", "%1") 
        for _, name in ipairs(_G.blacklistedPlayers) do
            if name:lower() == playerName:lower() then return end
        end
        table.insert(_G.blacklistedPlayers, playerName)
    end
end)

for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
    if player ~= game.Players.LocalPlayer then
        local displayText = getPlayerDisplayText(player)
        whitelistDropdown:Add(displayText)
        blacklistDropdown:Add(displayText)
    end
end

game:GetService("Players").PlayerAdded:Connect(function(player)
    if player ~= game.Players.LocalPlayer then
        local displayText = getPlayerDisplayText(player)
        whitelistDropdown:Add(displayText)
        blacklistDropdown:Add(displayText)
    end
end)

local blacklistKillSwitch = KillingTab:AddSwitch("Auto Kill Players", function(bool)
    _G.killBlacklistedOnly = bool
    if bool then
        if not _G.blacklistKillConnection then
            _G.blacklistKillConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if _G.killBlacklistedOnly then
                    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                        if player ~= game.Players.LocalPlayer and isBlacklisted(player) then
                            killPlayer(player)
                        end
                    end
                end
            end)
        end
    else
        if _G.blacklistKillConnection then
            _G.blacklistKillConnection:Disconnect()
            _G.blacklistKillConnection = nil
        end
    end
end)


local selectedPlayerToSpectate = nil
local spectating = false
local currentTargetConnection = nil
local camera = workspace.CurrentCamera

local function updateSpectateTarget(player)
    if currentTargetConnection then
        currentTargetConnection:Disconnect()
    end
    
    if player and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            camera.CameraSubject = humanoid
            currentTargetConnection = player.CharacterAdded:Connect(function(newChar)
                task.wait(0.2)
                local newHumanoid = newChar:FindFirstChildOfClass("Humanoid")
                if newHumanoid then
                    camera.CameraSubject = newHumanoid
                end
            end)
        end
    end
end

local function updatePlayerList()
    return game.Players:GetPlayers()
end

local specdropdown = KillingTab:AddDropdown("Choose Player", function(text)
    for _, player in ipairs(updatePlayerList()) do
        local optionText = player.DisplayName .. " | " .. player.Name
        if text == optionText then
            selectedPlayerToSpectate = player
            if spectating then
                updateSpectateTarget(player)
            end
            break
        end
    end
end)

local spectateSwitch = KillingTab:AddSwitch("Spectate", function(bool)
    spectating = bool
    if spectating and selectedPlayerToSpectate then
        updateSpectateTarget(selectedPlayerToSpectate)
    else
        if currentTargetConnection then
            currentTargetConnection:Disconnect()
            currentTargetConnection = nil
        end
        local localPlayer = game.Players.LocalPlayer
        if localPlayer.Character then
            local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                camera.CameraSubject = humanoid
            end
        end
    end
end)

for _, player in ipairs(updatePlayerList()) do
    specdropdown:Add(player.DisplayName .. " | " .. player.Name)
end

game.Players.PlayerAdded:Connect(function(player)
    specdropdown:Add(player.DisplayName .. " | " .. player.Name)
end)

game.Players.PlayerRemoving:Connect(function(player)
    if selectedPlayerToSpectate and selectedPlayerToSpectate == player then
        selectedPlayerToSpectate = nil
        if spectating then
            spectateSwitch:Set(false)
        end
    end
end)

local ringPart = nil
local ringColor = Color3.fromRGB(50, 163, 255)
local ringTransparency = 0.6
_G.showDeathRing = false
_G.deathRingRange = 20

local function updateRingSize()
    if not ringPart then return end
    local diameter = (_G.deathRingRange or 20) * 2
    ringPart.Size = Vector3.new(0.2, diameter, diameter)
end

KillingTab:AddTextBox("Range 1-140", function(text)
    local range = tonumber(text)
    if range then
        _G.deathRingRange = math.clamp(range, 1, 140)
        updateRingSize()
    end
end)

local function toggleRingVisual()
    if _G.showDeathRing then
        ringPart = Instance.new("Part")
        ringPart.Shape = Enum.PartType.Cylinder
        ringPart.Material = Enum.Material.Neon
        ringPart.Color = ringColor
        ringPart.Transparency = ringTransparency
        ringPart.Anchored = true
        ringPart.CanCollide = false
        ringPart.CastShadow = false
        updateRingSize()
        ringPart.Parent = workspace
    elseif ringPart then
        ringPart:Destroy()
        ringPart = nil
    end
end

local function updateRingPosition()
    if not ringPart then return end
    local character = checkCharacter()
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        ringPart.CFrame = rootPart.CFrame * CFrame.Angles(0, 0, math.rad(90))
    end
end

local deathRingSwitch = KillingTab:AddSwitch("Death Ring", function(bool)
    _G.deathRingEnabled = bool
    
    if bool then
        if not _G.deathRingConnection then
            _G.deathRingConnection = game:GetService("RunService").Heartbeat:Connect(function()
                updateRingPosition()
                
                local character = checkCharacter()
                local myPosition = character and character:FindFirstChild("HumanoidRootPart") and character.HumanoidRootPart.Position
                if not myPosition then return end

                for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                    if player ~= game.Players.LocalPlayer and not isWhitelisted(player) and isPlayerAlive(player) then
                        local distance = (myPosition - player.Character.HumanoidRootPart.Position).Magnitude
                        if distance <= (_G.deathRingRange or 20) then
                            killPlayer(player)
                        end
                    end
                end
            end)
        end
    else
        if _G.deathRingConnection then
            _G.deathRingConnection:Disconnect()
            _G.deathRingConnection = nil
        end
    end
end)

local visualRingSwitch = KillingTab:AddSwitch("Show Ring", function(bool)
    _G.showDeathRing = bool
    toggleRingVisual()
end)
deathRingSwitch:Set(false)
visualRingSwitch:Set(false)

local whitelistLabel = KillingTab:AddLabel("Whitelist: None")

KillingTab:AddButton("Clear", function()
    _G.whitelistedPlayers = {}
end)

local blacklistLabel = KillingTab:AddLabel("Blacklist: None")

KillingTab:AddButton("Clear", function()
    _G.blacklistedPlayers = {}
end)

local function updateWhitelistLabel()
    if #_G.whitelistedPlayers == 0 then
        whitelistLabel.Text = "Whitelist: None"
    else
        whitelistLabel.Text = "Whitelist: " .. table.concat(_G.whitelistedPlayers, ", ")
    end
end

local function updateBlacklistLabel()
    if #_G.blacklistedPlayers == 0 then
        blacklistLabel.Text = "Blacklist: None"
    else
        blacklistLabel.Text = "Blacklist: " .. table.concat(_G.blacklistedPlayers, ", ")
    end
end

task.spawn(function()
    while true do
        updateWhitelistLabel()
        updateBlacklistLabel()
        task.wait(0.2)
    end
end)

local autoGoodKarma = false
local autoBadKarma = false

KillingTab:AddSwitch("Auto Kill Evil Karma", function(bool)
    autoBadKarma = bool
    task.spawn(function()
        while autoBadKarma do
            local playerChar = LocalPlayer.Character
            local rightHand = playerChar and playerChar:FindFirstChild("RightHand")
            local leftHand = playerChar and playerChar:FindFirstChild("LeftHand")
            if playerChar and rightHand and leftHand then
                for _, target in ipairs(Players:GetPlayers()) do
                    if target ~= LocalPlayer then
                        local evilKarma = target:FindFirstChild("evilKarma")
                        local goodKarma = target:FindFirstChild("goodKarma")
                        if evilKarma and goodKarma and evilKarma:IsA("IntValue") and goodKarma:IsA("IntValue") and goodKarma.Value > evilKarma.Value then
                            local rootPart = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                            if rootPart then
                                firetouchinterest(rightHand, rootPart, 1)
                                firetouchinterest(leftHand, rootPart, 1)
                                firetouchinterest(rightHand, rootPart, 0)
                                firetouchinterest(leftHand, rootPart, 0)
                            end
                        end
                    end
                end
            end
            task.wait(0.01)
        end
    end)
end)

KillingTab:AddSwitch("Auto Kill Good Karma", function(bool)
    autoGoodKarma = bool
    task.spawn(function()
        while autoGoodKarma do
            local playerChar = LocalPlayer.Character
            local rightHand = playerChar and playerChar:FindFirstChild("RightHand")
            local leftHand = playerChar and playerChar:FindFirstChild("LeftHand")
            if playerChar and rightHand and leftHand then
                for _, target in ipairs(Players:GetPlayers()) do
                    if target ~= LocalPlayer then
                        local evilKarma = target:FindFirstChild("evilKarma")
                        local goodKarma = target:FindFirstChild("goodKarma")
                        if evilKarma and goodKarma and evilKarma:IsA("IntValue") and goodKarma:IsA("IntValue") and evilKarma.Value > goodKarma.Value then
                            local rootPart = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                            if rootPart then
                                firetouchinterest(rightHand, rootPart, 1)
                                firetouchinterest(leftHand, rootPart, 1)
                                firetouchinterest(rightHand, rootPart, 0)
                                firetouchinterest(leftHand, rootPart, 0)
                            end
                        end
                    end
                end
            end
            task.wait(0.01)
        end
    end)
end)

GodmodeTab:AddLabel("PACK SPAM & PETS").TextSize = 30

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local running = false

local function getRemote()
    local rEvents = ReplicatedStorage:FindFirstChild("rEvents")
    if rEvents then
        return rEvents:FindFirstChild("equipPetEvent")
    end
end

local function unequipAll(remote, petsFolder)
    for _, folder in pairs(petsFolder:GetChildren()) do
        if folder:IsA("Folder") then
            for _, pet in pairs(folder:GetChildren()) do
                remote:FireServer("unequipPet", pet)
            end
        end
    end
end

local function getPetsByName(folder, name)
    local t = {}
    for _, pet in pairs(folder:GetChildren()) do
        if pet.Name == name then
            table.insert(t, pet)
        end
    end
    return t
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local running = false

local function getRemote()
    local rEvents = ReplicatedStorage:FindFirstChild("rEvents")
    if not rEvents then return end
    return rEvents:FindFirstChild("equipPetEvent")
end

local function unequipAll(remote, petsFolder)
    for _, folder in pairs(petsFolder:GetChildren()) do
        if folder:IsA("Folder") then
            for _, pet in pairs(folder:GetChildren()) do
                remote:FireServer("unequipPet", pet)
            end
        end
    end
end

local function getPets(folder, name)
    local t = {}
    for _, pet in pairs(folder:GetChildren()) do
        if pet.Name == name then
            table.insert(t, pet)
        end
    end
    return t
end

GodmodeTab:AddButton("Start Pack Spam", function()
    if running then return end
    running = true

    task.spawn(function()
        local petsFolder = LocalPlayer:FindFirstChild("petsFolder")
        if not petsFolder then
            warn("petsFolder not found")
            running = false
            return
        end

        local unique = petsFolder:FindFirstChild("Unique")
        if not unique then
            warn("Unique folder not found")
            running = false
            return
        end

        local remote = getRemote()
        if not remote then
            warn("equipPetEvent not found")
            running = false
            return
        end

        while running do
            -- ===== Mighty Monster =====
            unequipAll(remote, petsFolder)
            task.wait(0.1)

            local mighty = getPets(unique, "Mighty Monster")

            for i = 1, math.min(7, #mighty) do
                if not running then return end
                remote:FireServer("equipPet", mighty[i])
                task.wait(0.025)
            end

            task.wait(0.01)

            -- ===== Wild Wizard =====
            unequipAll(remote, petsFolder)
            task.wait(0.1)

            local wizard = getPets(unique, "Wild Wizard")

            for i = 1, math.min(0, #wizard) do
                if not running then return end
                remote:FireServer("equipPet", wizard[i])
                task.wait(0.025)
            end

            task.wait(0.1)
        end
    end)
end)



GodmodeTab:AddButton("Stop Pack Spam", function()
    running = false
    print("[PackSpam]: Stopped")
end)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local function equipPet(petName)
    local petsFolder = LocalPlayer:FindFirstChild("petsFolder")
    if not petsFolder then
        warn("petsFolder not found")
        return
    end

    local uniqueFolder = petsFolder:FindFirstChild("Unique")
    if not uniqueFolder then
        warn("Unique folder not found")
        return
    end

    local remote = ReplicatedStorage:FindFirstChild("rEvents")
    if remote then
        remote = remote:FindFirstChild("equipPetEvent")
    end

    if not remote then
        warn("equipPetEvent not found")
        return
    end

    -- Unequip all
    for _, folder in pairs(petsFolder:GetChildren()) do
        if folder:IsA("Folder") then
            for _, pet in pairs(folder:GetChildren()) do
                remote:FireServer("unequipPet", pet)
            end
        end
    end

    task.wait(0.2)

    -- Find pets
    local petsToEquip = {}
    for _, pet in pairs(uniqueFolder:GetChildren()) do
        if pet.Name == petName then
            table.insert(petsToEquip, pet)
        end
    end

    -- Equip max 8
    for i = 1, math.min(8, #petsToEquip) do
        remote:FireServer("equipPet", petsToEquip[i])
        task.wait(0.1)
    end
end

-- MAKE SURE GodmodeTab EXISTS BEFORE THIS
if GodmodeTab then
    GodmodeTab:AddButton("Equip Wild Wizard", function()
        equipPet("Wild Wizard")
    end)

    GodmodeTab:AddButton("Equip Mighty Monster", function()
        equipPet("Mighty Monster")
    end)
else
    warn("GodmodeTab is nil")
end

MainTab:AddLabel("Settings").TextSize = 30

MainTab:AddTextBox("Speed", function(value)
    local selectedSpeed = value
 
    _G.AutoSpeed = true
 
    if _G.AutoSpeed then
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = tonumber(selectedSpeed)
        end
    end
end)
 
MainTab:AddTextBox("Size", function(value)
    local selectedSize = value
 
    _G.AutoSize = true
 
    if _G.AutoSize then
        game:GetService("ReplicatedStorage").rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", tonumber(selectedSize))
    end
end)

MainTab:AddLabel("Essenttals:").TextSize = 30

local function removePortals()
    for _, portal in pairs(game:GetDescendants()) do
        if portal.Name == "RobloxForwardPortals" then
            portal:Destroy()
        end
    end
    if _G.AdRemovalConnection then
        _G.AdRemovalConnection:Disconnect()
    end

    _G.AdRemovalConnection = game.DescendantAdded:Connect(function(descendant)
        if descendant.Name == "RobloxForwardPortals" then
            descendant:Destroy()
        end
    end)
end
removePortals()

MainTab:AddButton("Load Infinite Yield", function()
loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end)
   
 MainTab:AddButton("Load Anti Lag", function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/juywvm/-Roblox-Projects-/main/____Anti_Afk_Remastered_______"))()
    end)    

local parts = {}
local partSize = 2048
local totalDistance = 50000
local startPosition = Vector3.new(-2, -9.5, -2)

local function createAllParts()
    local numberOfParts = math.ceil(totalDistance / partSize)
    
    for x = 0, numberOfParts - 1 do
        for z = 0, numberOfParts - 1 do
            local function createPart(pos, name)
                local part = Instance.new("Part")
                part.Size = Vector3.new(partSize, 1, partSize)
                part.Position = pos
                part.Anchored = true
                part.Transparency = 1
                part.CanCollide = true
                part.Name = name
                part.Parent = workspace
                return part
            end
            
            table.insert(parts, createPart(startPosition + Vector3.new(x*partSize,0,z*partSize), "Part_Side_"..x.."_"..z))
            table.insert(parts, createPart(startPosition + Vector3.new(-x*partSize,0,z*partSize), "Part_LeftRight_"..x.."_"..z))
            table.insert(parts, createPart(startPosition + Vector3.new(-x*partSize,0,-z*partSize), "Part_UpLeft_"..x.."_"..z))
            table.insert(parts, createPart(startPosition + Vector3.new(x*partSize,0,-z*partSize), "Part_UpRight_"..x.."_"..z))
        end
    end
end
task.spawn(createAllParts)

local walkonwaterSwicth =MainTab:AddSwitch("Walk on Water", function(bool)
    for _, part in ipairs(parts) do
        if part and part.Parent then
            part.CanCollide = bool
        end
    end
end)
walkonwaterSwicth:Set(false)

local running = false

local running = false

local running = false

local running = false
local thread

local running = false
local thread

local antiKnockbackSwitch = MainTab:AddSwitch("Anti Fling", function(bool)
    if bool then
        local playerName = game.Players.LocalPlayer.Name
        local character = game.Workspace:FindFirstChild(playerName)
        if character then
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.MaxForce = Vector3.new(100000, 0, 100000)
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                bodyVelocity.P = 1250
                bodyVelocity.Parent = rootPart
            end
        end
    else
        local playerName = game.Players.LocalPlayer.Name
        local character = game.Workspace:FindFirstChild(playerName)
        if character then
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local existingVelocity = rootPart:FindFirstChild("BodyVelocity")
                if existingVelocity and existingVelocity.MaxForce == Vector3.new(100000, 0, 100000) then
                    existingVelocity:Destroy()
                end
            end
        end
    end
end)
antiKnockbackSwitch:Set(true)

local switch = MainTab:AddSwitch("Lock Position", function(Value)
    if Value then
        -- Lock Position
        local currentPos = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        getgenv().posLock = game:GetService("RunService").Heartbeat:Connect(function()
            if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = currentPos
            end
        end)
    else
        -- Unlock Position
        if getgenv().posLock then
            getgenv().posLock:Disconnect()
            getgenv().posLock = nil
        end
    end
end)


MainTab:AddButton("Rejoin", function()
    local TeleportService = game:GetService("TeleportService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local localPlayer = Players.LocalPlayer
local username = localPlayer.Name
local userId = localPlayer.UserId

local Player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local muscleEvent = Player:WaitForChild("muscleEvent")
local antiAFKConnection

local SpecsTab = window:AddTab("Specs")

SpecsTab:AddLabel("Player Stats:").TextSize = 24

local playerToInspect = nil

local emojiMap = {
    ["Time"] = utf8.char(0x1F55B),
    ["Stats"] = utf8.char(0x1F4CA),
    ["Strength"] = utf8.char(0x1F4AA),
    ["Rebirths"] = utf8.char(0x1F504),
    ["Durability"] = utf8.char(0x1F6E1),
    ["Kills"] = utf8.char(0x1F480),
    ["Agility"] = utf8.char(0x1F3C3),
    ["Evil Karma"] = utf8.char(0x1F608),
    ["Good Karma"] = utf8.char(0x1F607),
    ["Brawls"] = utf8.char(0x1F94A)
}

local statDefinitions = {
    { name = "Strength", statName = "Strength" },
    { name = "Rebirths", statName = "Rebirths" },
    { name = "Durability", statName = "Durability" },
    { name = "Agility", statName = "Agility" },
    { name = "Kills", statName = "Kills" },
    { name = "Evil Karma", statName = "evilKarma" },
    { name = "Good Karma", statName = "goodKarma" },
    { name = "Brawls", statName = "Brawls" }
}

local function getCurrentPlayers()
    local playersList = {}
    for _, p in ipairs(Players:GetPlayers()) do
        table.insert(playersList, p)
    end
    return playersList
end

local specdropdown = SpecsTab:AddDropdown("Choose Player", function(text) 
    for _, player in ipairs(getCurrentPlayers()) do
        local optionText = player.DisplayName .. " | " .. player.Name
        if text == optionText then
            playerToInspect = player
            updateStatLabels(playerToInspect)
            break
        end
    end
end)

for _, player in ipairs(getCurrentPlayers()) do
    specdropdown:Add(player.DisplayName .. " | " .. player.Name)
end

Players.PlayerAdded:Connect(function(player)
    specdropdown:Add(player.DisplayName .. " | " .. player.Name)
end)

Players.PlayerRemoving:Connect(function(player)
    specdropdown:Clear()
    for _, p in ipairs(getCurrentPlayers()) do
        specdropdown:Add(p.DisplayName .. " | " .. p.Name)
    end
end)

local playerNameLabel = SpecsTab:AddLabel("Name: N/A")
playerNameLabel.TextSize = 20

local playerUsernameLabel = SpecsTab:AddLabel("Username: N/A")
playerUsernameLabel.TextSize = 20

local statLabels = {}
for _, info in ipairs(statDefinitions) do
    statLabels[info.name] = SpecsTab:AddLabel(emojiMap[info.name] .. " " .. info.name .. ": 0 (0)")
    statLabels[info.name].TextSize = 20
end

local function formatNumber(n)
    if n >= 1e15 then
        return string.format("%.1fqa", n/1e15)
    elseif n >= 1e12 then
        return string.format("%.1ft", n/1e12)
    elseif n >= 1e9 then
        return string.format("%.1fb", n/1e9)
    elseif n >= 1e6 then
        return string.format("%.1fm", n/1e6)
    elseif n >= 1e3 then
        return string.format("%.1fk", n/1e3)
    else
        return tostring(n)
    end
end

local function formatWithCommas(n)
    local formatted = tostring(math.floor(n))
    while true do
        formatted, k = formatted:gsub("^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
end


local function updateStatLabels(targetPlayer)
    if not targetPlayer then return end

    playerNameLabel.Text = "Name: " .. targetPlayer.DisplayName
    playerUsernameLabel.Text = "Username: " .. targetPlayer.Name

    local leaderstats = targetPlayer:FindFirstChild("leaderstats")
    if not leaderstats then return end

    for _, info in ipairs(statDefinitions) do
        local statObject

        if leaderstats:FindFirstChild(info.statName) then
            statObject = leaderstats:FindFirstChild(info.statName)
        elseif targetPlayer:FindFirstChild(info.statName) then
            statObject = targetPlayer:FindFirstChild(info.statName)
        end

        if statObject then
            local value = statObject.Value
            local emoji = emojiMap[info.name] or ""
            statLabels[info.name].Text = string.format(
                "%s %s: %s (%s)",
                emoji,
                info.name,
                formatNumber(value),
                formatWithCommas(value)
            )
        else
            statLabels[info.name].Text = emojiMap[info.name] .. " " .. info.name .. ": 0 (0)"
        end
    end
end

task.spawn(function()
    while true do
        if playerToInspect then
            updateStatLabels(playerToInspect)
        end
        task.wait(0.2)
    end
end)

SpecsTab:AddLabel("————————————————————————————")

SpecsTab:AddLabel("Advanced Stats:").TextSize = 24

local enemyHealthLabel = SpecsTab:AddLabel("Enemy Health: N/A")
enemyHealthLabel.TextSize = 20
enemyHealthLabel.TextColor3 = Color3.fromRGB(0, 140, 255)

local playerDamageLabel = SpecsTab:AddLabel("Your Damage: N/A")
playerDamageLabel.TextSize = 20
playerDamageLabel.TextColor3 = Color3.fromRGB(255, 0, 0)

local hitsToKillLabel = SpecsTab:AddLabel("Hits to Kill: N/A")
hitsToKillLabel.TextSize = 20
hitsToKillLabel.TextColor3 = Color3.fromRGB(255, 0, 0)



local function calculateEnemyHealth(targetPlayer)
    if not targetPlayer then return 0 end

    local baseDura = 0
    local durabilityStat = targetPlayer:FindFirstChild("Durability") 
        or (targetPlayer:FindFirstChild("leaderstats") and targetPlayer.leaderstats:FindFirstChild("Durability"))
    if durabilityStat then
        baseDura = durabilityStat.Value
    end

    local totalMultiplier = 1

    local ultFolder = targetPlayer:FindFirstChild("ultimatesFolder")
    if ultFolder then
        local infernalHealth = ultFolder:FindFirstChild("Infernal Health")
        if infernalHealth then
            local upgrades = infernalHealth.Value or 0
            totalMultiplier = totalMultiplier + 0.15 * upgrades
        end
    end

    local equippedPetsFolder = targetPlayer:FindFirstChild("equippedPets")
    if equippedPetsFolder then
        local petBonus = 0
        for _, petValue in ipairs(equippedPetsFolder:GetChildren()) do
            if petValue:IsA("ObjectValue") and petValue.Value then
                local petNameLower = string.lower(petValue.Value.Name)
                if petNameLower:match("mighty") and petNameLower:match("monster") then
                    petBonus = petBonus + 0.5
                end
            end
        end
        totalMultiplier = totalMultiplier + petBonus
    end

    local totalHealth = baseDura * totalMultiplier
    return totalHealth
end

local function calculateLocalPlayerDamage()
    local strengthStat = nil
    local leaderstats = Player:FindFirstChild("leaderstats")
    if leaderstats then
        strengthStat = leaderstats:FindFirstChild("Strength")
    end
    if not strengthStat then return 0 end

    local baseDamage = strengthStat.Value * 0.0667
    local totalMultiplier = 1

    local ultFolder = Player:FindFirstChild("ultimatesFolder")
    if ultFolder then
        local demonDamage = ultFolder:FindFirstChild("Demon Damage")
        if demonDamage then
            local upgrades = demonDamage.Value or 0
            totalMultiplier = totalMultiplier + 0.1 * upgrades
        end
    end

    local equippedPetsFolder = Player:FindFirstChild("equippedPets")
    if equippedPetsFolder then
        local petBonus = 0
        for _, petValue in ipairs(equippedPetsFolder:GetChildren()) do
            if petValue:IsA("ObjectValue") and petValue.Value then
                local petNameLower = string.lower(petValue.Value.Name)
                if petNameLower:match("wild") and petNameLower:match("wizard") then
                    petBonus = petBonus + 0.5
                end
            end
        end
        totalMultiplier = totalMultiplier + petBonus
    end

    baseDamage = baseDamage * totalMultiplier
    return baseDamage
end



local function calculateHitsToKill(health, damage)
    if damage <= 0 then return "∞" end
    local hits = math.ceil(health / damage)
    if hits > 100 then
        return "∞"
    elseif hits < 1 then
        return 1
    else
        return hits
    end
end

local function updateAdvancedStats(targetPlayer)
    if not targetPlayer then
        enemyHealthLabel.Text = "Enemy Health: N/A"
        playerDamageLabel.Text = "Your Damage: N/A"
        hitsToKillLabel.Text = "Hits to Kill: N/A"
        return
    end
    local enemyHealth = calculateEnemyHealth(targetPlayer)
    local playerDamage = calculateLocalPlayerDamage()
    local hitsToKill = calculateHitsToKill(enemyHealth, playerDamage)
    enemyHealthLabel.Text = string.format("Enemy Health: %s (%s)", formatNumber(enemyHealth), formatWithCommas(enemyHealth))
    playerDamageLabel.Text = string.format("Your Damage: %s (%s)", formatNumber(playerDamage), formatWithCommas(playerDamage))
    hitsToKillLabel.Text = string.format("Hits to Kill: %s", tostring(hitsToKill))
end

task.spawn(function()
    while true do
        if playerToInspect then
            updateAdvancedStats(playerToInspect)
        else
            updateAdvancedStats(nil)
        end
        task.wait(0.1)
    end
end)

local Killer = window:AddTab("Better Killing")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local playerWhitelist = {}
local targetPlayerNames = {}
local autoGoodKarma = false
local autoBadKarma = false
local autoKill = false
local killTarget = false
local spying = false
local autoPunchNoAnim = false
local targetDropdownItems = {}
local availableTargets = {}

local titleLabel = Killer:AddLabel("Select damage or durability pet")
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.Merriweather 
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

local dropdown = Killer:AddDropdown("Select Pet", function(text)
    local petsFolder = game.Players.LocalPlayer.petsFolder
    for _, folder in pairs(petsFolder:GetChildren()) do
        if folder:IsA("Folder") then
            for _, pet in pairs(folder:GetChildren()) do
                game:GetService("ReplicatedStorage").rEvents.equipPetEvent:FireServer("unequipPet", pet)
            end
        end
    end
    task.wait(0.2)

    local petName = text
    local petsToEquip = {}

    for _, pet in pairs(game.Players.LocalPlayer.petsFolder.Unique:GetChildren()) do
        if pet.Name == petName then
            table.insert(petsToEquip, pet)
        end
    end

    local maxPets = 8
    local equippedCount = math.min(#petsToEquip, maxPets)

    for i = 1, equippedCount do
        game:GetService("ReplicatedStorage").rEvents.equipPetEvent:FireServer("equipPet", petsToEquip[i])
        task.wait(0.1)
    end
end)

local Wild_Wizard = dropdown:Add("Wild Wizard")
local Powerful_Monster = dropdown:Add("Mighty Monster")


Killer:AddSwitch("Auto Good Karma", function(bool)
    autoGoodKarma = bool
    task.spawn(function()
        while autoGoodKarma do
            local playerChar = LocalPlayer.Character
            local rightHand = playerChar and playerChar:FindFirstChild("RightHand")
            local leftHand = playerChar and playerChar:FindFirstChild("LeftHand")
            if playerChar and rightHand and leftHand then
                for _, target in ipairs(Players:GetPlayers()) do
                    if target ~= LocalPlayer then
                        local evilKarma = target:FindFirstChild("evilKarma")
                        local goodKarma = target:FindFirstChild("goodKarma")
                        if evilKarma and goodKarma and evilKarma:IsA("IntValue") and goodKarma:IsA("IntValue") and evilKarma.Value > goodKarma.Value then
                            local rootPart = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                            if rootPart then
                                firetouchinterest(rightHand, rootPart, 1)
                                firetouchinterest(leftHand, rootPart, 1)
                                firetouchinterest(rightHand, rootPart, 0)
                                firetouchinterest(leftHand, rootPart, 0)
                            end
                        end
                    end
                end
            end
            task.wait(0.01)
        end
    end)
end)

Killer:AddSwitch("Auto Bad Karma", function(bool)
    autoBadKarma = bool
    task.spawn(function()
        while autoBadKarma do
            local playerChar = LocalPlayer.Character
            local rightHand = playerChar and playerChar:FindFirstChild("RightHand")
            local leftHand = playerChar and playerChar:FindFirstChild("LeftHand")
            if playerChar and rightHand and leftHand then
                for _, target in ipairs(Players:GetPlayers()) do
                    if target ~= LocalPlayer then
                        local evilKarma = target:FindFirstChild("evilKarma")
                        local goodKarma = target:FindFirstChild("goodKarma")
                        if evilKarma and goodKarma and evilKarma:IsA("IntValue") and goodKarma:IsA("IntValue") and goodKarma.Value > evilKarma.Value then
                            local rootPart = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                            if rootPart then
                                firetouchinterest(rightHand, rootPart, 1)
                                firetouchinterest(leftHand, rootPart, 1)
                                firetouchinterest(rightHand, rootPart, 0)
                                firetouchinterest(leftHand, rootPart, 0)
                            end
                        end
                    end
                end
            end
            task.wait(0.01)
        end
    end)
end)


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local friendWhitelistActive = false

Killer:AddSwitch("Auto Whitelist Friends", function(state)
    friendWhitelistActive = state

    if state then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and LocalPlayer:IsFriendsWith(player.UserId) then
                if not table.find(_G.whitelistedPlayers, player.Name) then
                    table.insert(_G.whitelistedPlayers, player.Name)
                    print(player.Name .. " (amigo) aÃ±adido a Whitelist")
                end
            end
        end

        Players.PlayerAdded:Connect(function(player)
            if friendWhitelistActive and player ~= LocalPlayer and LocalPlayer:IsFriendsWith(player.UserId) then
                if not table.find(_G.whitelistedPlayers, player.Name) then
                    table.insert(_G.whitelistedPlayers, player.Name)
                    print(player.Name .. " (amigo) aÃ±adido a Whitelist")
                end
            end
        end)
    else
        for i = #_G.whitelistedPlayers, 1, -1 do
            local friend = Players:FindFirstChild(_G.whitelistedPlayers[i])
            if friend and LocalPlayer:IsFriendsWith(friend.UserId) then
                print(_G.whitelistedPlayers[i] .. " (amigo) eliminado de Whitelist")
                table.remove(_G.whitelistedPlayers, i)
            end
        end
    end
end)




local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

_G.whitelistedPlayers = _G.whitelistedPlayers or {}

local whitelistDropdownItems = {}
local selectedWhitelist = nil

-- Dropdown con DisplayName
local whitelistDropdown = Killer:AddDropdown("Add to Whitelist", function(displayName)
    for _, player in ipairs(Players:GetPlayers()) do
        if player.DisplayName == displayName then
            if not table.find(_G.whitelistedPlayers, player.Name) then
                table.insert(_G.whitelistedPlayers, player.Name) -- guardamos Name real
            end
            selectedWhitelist = player.Name
            print(player.Name .. " agregado a Whitelist")
            break
        end
    end
end)

-- BotÃ³n para remover jugador seleccionado de whitelist
Killer:AddButton("Remove Selected Whitelist", function()
    if selectedWhitelist then
        for i, v in ipairs(_G.whitelistedPlayers) do
            if v == selectedWhitelist then
                table.remove(_G.whitelistedPlayers, i)
                print(selectedWhitelist .. " eliminado de Whitelist")
                break
            end
        end
        selectedWhitelist = nil
    end
end)

-- Inicializar con jugadores actuales
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        whitelistDropdown:Add(player.DisplayName)
        whitelistDropdownItems[player.Name] = player.DisplayName
    end
end

-- Cuando entra un jugador nuevo
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        whitelistDropdown:Add(player.DisplayName)
        whitelistDropdownItems[player.Name] = player.DisplayName
    end
end)

-- Cuando un jugador se va
Players.PlayerRemoving:Connect(function(player)
    if whitelistDropdownItems[player.Name] then
        whitelistDropdownItems[player.Name] = nil
        whitelistDropdown:Clear()
        for _, displayName in pairs(whitelistDropdownItems) do
            whitelistDropdown:Add(displayName)
        end
    end

    for i = #_G.whitelistedPlayers, 1, -1 do
        if _G.whitelistedPlayers[i] == player.Name then
            table.remove(_G.whitelistedPlayers, i)
        end
    end
end)


Killer:AddSwitch("Auto Kill", function(bool)
    autoKill = bool

    task.spawn(function()
        while autoKill do
            local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local rightHand = character:FindFirstChild("RightHand")
            local leftHand = character:FindFirstChild("LeftHand")

            -- Asegurar que tengas el Punch equipado
            local punch = LocalPlayer.Backpack:FindFirstChild("Punch")
            if punch and not character:FindFirstChild("Punch") then
                punch.Parent = character
            end

            if rightHand and leftHand then
                for _, target in ipairs(Players:GetPlayers()) do
                    if target ~= LocalPlayer and target.Character then
                        -- ðŸ”¹ Checar si estÃ¡ en Whitelist
                        local isWhitelisted = false
                        for _, name in ipairs(_G.whitelistedPlayers) do
                            if name:lower() == target.Name:lower() then
                                isWhitelisted = true
                                break
                            end
                        end

                        -- Solo atacar si NO estÃ¡ en la Whitelist
                        if not isWhitelisted then
                            local rootPart = target.Character:FindFirstChild("HumanoidRootPart")
                            local humanoid = target.Character:FindFirstChild("Humanoid")
                            if rootPart and humanoid and humanoid.Health > 0 then
                                pcall(function()
                                    firetouchinterest(rightHand, rootPart, 1)
                                    firetouchinterest(leftHand, rootPart, 1)
                                    firetouchinterest(rightHand, rootPart, 0)
                                    firetouchinterest(leftHand, rootPart, 0)
                                end)
                            end
                        end
                    end
                end
            end

            task.wait(0.05)
        end
    end)
end)


local targetDropdownItems = {}
local targetPlayerNames = {}
local selectedTarget = nil

local function waitForCharacter()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    repeat task.wait() until LocalPlayer:FindFirstChild("Backpack")
    return char
end

local function ensurePunch(char)
    local punch = char:FindFirstChild("Punch") or LocalPlayer.Backpack:FindFirstChild("Punch")
    if not punch then
        for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
            if tool.Name == "Punch" then
                punch = tool
                break
            end
        end
    end
    if punch then
        punch.Parent = char
        return punch
    end
    return nil
end

local targetDropdown = Killer:AddDropdown("Select Target", function(displayName)
    for _, player in ipairs(Players:GetPlayers()) do
        if player.DisplayName == displayName then
            if not table.find(targetPlayerNames, player.Name) then
                table.insert(targetPlayerNames, player.Name)
            end
            selectedTarget = player.Name
            break
        end
    end
end)

Killer:AddButton("Remove Selected Target", function()
    if selectedTarget then
        for i, v in ipairs(targetPlayerNames) do
            if v == selectedTarget then
                table.remove(targetPlayerNames, i)
                break
            end
        end
        selectedTarget = nil
    end
end)

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        targetDropdown:Add(player.DisplayName)
        targetDropdownItems[player.Name] = player.DisplayName
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        targetDropdown:Add(player.DisplayName)
        targetDropdownItems[player.Name] = player.DisplayName
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if targetDropdownItems[player.Name] then
        targetDropdownItems[player.Name] = nil
        targetDropdown:Clear()
        for _, displayName in pairs(targetDropdownItems) do
            targetDropdown:Add(displayName)
        end
    end
    for i = #targetPlayerNames, 1, -1 do
        if targetPlayerNames[i] == player.Name then
            table.remove(targetPlayerNames, i)
        end
    end
end)

Killer:AddSwitch("Start Kill Target", function(state)
    killTarget = state
    if state then
        task.spawn(function()
            while killTarget do
                local char = LocalPlayer.Character
                if not char then
                    char = waitForCharacter()
                end

                local punch = ensurePunch(char)
                local rightHand = char:FindFirstChild("RightHand")
                local leftHand = char:FindFirstChild("LeftHand")

                if not (rightHand and leftHand) then
                    task.wait(0.1)
                    continue
                end

                if punch then
                    pcall(function()
                        LocalPlayer.muscleEvent:FireServer("punch", "rightHand")
                        LocalPlayer.muscleEvent:FireServer("punch", "leftHand")
                    end)
                end

                for _, name in ipairs(targetPlayerNames) do
                    local target = Players:FindFirstChild(name)
                    if target and target ~= LocalPlayer and target.Character then
                        local root = target.Character:FindFirstChild("HumanoidRootPart")
                        local hum = target.Character:FindFirstChild("Humanoid")
                        if root and hum and hum.Health > 0 then
                            pcall(function()
                                firetouchinterest(rightHand, root, 1)
                                firetouchinterest(leftHand, root, 1)
                                firetouchinterest(rightHand, root, 0)
                                firetouchinterest(leftHand, root, 0)
                            end)
                        end
                    end
                end

                task.wait(0.04)
            end
        end)
    end
end)

local spyTargetDropdownItems = {}
local targetPlayerName = nil

local spyTargetDropdown = Killer:AddDropdown("Select View Target", function(displayName)
    for _, player in ipairs(Players:GetPlayers()) do
        if player.DisplayName == displayName then
            targetPlayerName = player.Name
            break
        end
    end
end)

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        spyTargetDropdown:Add(player.DisplayName)
        spyTargetDropdownItems[player.Name] = player.DisplayName
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        spyTargetDropdown:Add(player.DisplayName)
        spyTargetDropdownItems[player.Name] = player.DisplayName
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if player ~= LocalPlayer then
        spyTargetDropdownItems[player.Name] = nil
        spyTargetDropdown:Clear()
        for _, displayName in pairs(spyTargetDropdownItems) do
            spyTargetDropdown:Add(displayName)
        end
    end
end)

Killer:AddSwitch("View Player", function(bool)
    spying = bool
    if not spying then
        local cam = workspace.CurrentCamera
        cam.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") or LocalPlayer
        return
    end
    task.spawn(function()
        while spying do
            local target = Players:FindFirstChild(targetPlayerName)
            if target and target ~= LocalPlayer then
                local humanoid = target.Character and target.Character:FindFirstChild("Humanoid")
                if humanoid then
                    workspace.CurrentCamera.CameraSubject = humanoid
                end
            end
            task.wait(0.1)
        end
    end)
end)

local button = Killer:AddButton("Remove Punch Anim", function()
    local blockedAnimations = {
        ["rbxassetid://3638729053"] = true,
        ["rbxassetid://3638767427"] = true,
    }

    local function setupAnimationBlocking()
        local char = game.Players.LocalPlayer.Character
        if not char or not char:FindFirstChild("Humanoid") then return end

        local humanoid = char:FindFirstChild("Humanoid")

        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            if track.Animation then
                local animId = track.Animation.AnimationId
                local animName = track.Name:lower()

                if blockedAnimations[animId] or
                    animName:match("punch") or
                    animName:match("attack") or
                    animName:match("right") then
                    track:Stop()
                end
            end
        end

        if not _G.AnimBlockConnection then
            local connection = humanoid.AnimationPlayed:Connect(function(track)
                if track.Animation then
                    local animId = track.Animation.AnimationId
                    local animName = track.Name:lower()

                    if blockedAnimations[animId] or
                        animName:match("punch") or
                        animName:match("attack") or
                        animName:match("right") then
                        track:Stop()
                    end
                end
            end)

            _G.AnimBlockConnection = connection
        end
    end

    setupAnimationBlocking()

    local function overrideToolActivation()
        local function processTool(tool)
            if tool and (tool.Name == "Punch" or tool.Name:match("Attack") or tool.Name:match("Right")) then
                if not tool:GetAttribute("ActivatedOverride") then
                    tool:SetAttribute("ActivatedOverride", true)

                    local connection = tool.Activated:Connect(function()
                        task.wait(0.05)

                        local char = game.Players.LocalPlayer.Character
                        if char and char:FindFirstChild("Humanoid") then
                            for _, track in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
                                if track.Animation then
                                    local animId = track.Animation.AnimationId
                                    local animName = track.Name:lower()

                                    if blockedAnimations[animId] or
                                        animName:match("punch") or
                                        animName:match("attack") or
                                        animName:match("right") then
                                        track:Stop()
                                    end
                                end
                            end
                        end
                    end)

                    if not _G.ToolConnections then
                        _G.ToolConnections = {}
                    end
                    _G.ToolConnections[tool] = connection
                end
            end
        end

        for _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
            processTool(tool)
        end

        local char = game.Players.LocalPlayer.Character
        if char then
            for _, tool in pairs(char:GetChildren()) do
                if tool:IsA("Tool") then
                    processTool(tool)
                end
            end
        end

        if not _G.BackpackAddedConnection then
            _G.BackpackAddedConnection = game.Players.LocalPlayer.Backpack.ChildAdded:Connect(function(child)
                if child:IsA("Tool") then
                    task.wait(0.1)
                    processTool(child)
                end
            end)
        end

        if not _G.CharacterToolAddedConnection and char then
            _G.CharacterToolAddedConnection = char.ChildAdded:Connect(function(child)
                if child:IsA("Tool") then
                    task.wait(0.1)
                    processTool(child)
                end
            end)
        end
    end

    overrideToolActivation()

    if not _G.AnimMonitorConnection then
        _G.AnimMonitorConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if tick() % 0.5 < 0.01 then
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    for _, track in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
                        if track.Animation then
                            local animId = track.Animation.AnimationId
                            local animName = track.Name:lower()

                            if blockedAnimations[animId] or
                                animName:match("punch") or
                                animName:match("attack") or
                                animName:match("right") then
                                track:Stop()
                            end
                        end
                    end
                end
            end
        end)
    end

    if not _G.CharacterAddedConnection then
        _G.CharacterAddedConnection = game.Players.LocalPlayer.CharacterAdded:Connect(function(newChar)
            task.wait(1)
            setupAnimationBlocking()
            overrideToolActivation()

            if _G.CharacterToolAddedConnection then
                _G.CharacterToolAddedConnection:Disconnect()
            end

            _G.CharacterToolAddedConnection = newChar.ChildAdded:Connect(function(child)
                if child:IsA("Tool") then
                    task.wait(0.1)
                    processTool(child)
                end
            end)
        end)
    end
end)

function RecoveryPunch()
    if _G.AnimBlockConnection then
        _G.AnimBlockConnection:Disconnect()
        _G.AnimBlockConnection = nil
    end
    if _G.AnimMonitorConnection then
        _G.AnimMonitorConnection:Disconnect()
        _G.AnimMonitorConnection = nil
    end
    if _G.ToolConnections then
        for _, conn in pairs(_G.ToolConnections) do
            if conn then conn:Disconnect() end
        end
        _G.ToolConnections = nil
    end
    if _G.BackpackAddedConnection then
        _G.BackpackAddedConnection:Disconnect()
        _G.BackpackAddedConnection = nil
    end
    if _G.CharacterToolAddedConnection then
        _G.CharacterToolAddedConnection:Disconnect()
        _G.CharacterToolAddedConnection = nil
    end
    if _G.CharacterAddedConnection then
        _G.CharacterAddedConnection:Disconnect()
        _G.CharacterAddedConnection = nil
    end
end

Killer:AddButton("Recover Punch Anim", function()
    RecoveryPunch()
end)

Killer:AddSwitch("Auto Punch [without animation]", function(state)
	autoPunchNoAnim = state
	if state then
		task.spawn(function()
			while autoPunchNoAnim do
				local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
				repeat task.wait() until LocalPlayer:FindFirstChild("Backpack")

				local punch = char:FindFirstChild("Punch") or LocalPlayer.Backpack:FindFirstChild("Punch")

				if not punch then
					for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
						if tool.Name == "Punch" then
							tool.Parent = char
						end
					end
					task.wait(0.05)
					continue
				end

				if punch.Parent ~= char then
					punch.Parent = char
				end

				pcall(function()
					LocalPlayer.muscleEvent:FireServer("punch", "rightHand")
					LocalPlayer.muscleEvent:FireServer("punch", "leftHand")
				end)

				task.wait(0.03)
			end
		end)
	else
		autoPunchNoAnim = false
	end
end)


Killer:AddSwitch("Auto Punch", function(state)
	_G.fastHitActive = state
	if state then
		task.spawn(function()
			while _G.fastHitActive do
				local punch = LocalPlayer.Backpack:FindFirstChild("Punch")
				if punch then
					punch.Parent = LocalPlayer.Character
					if punch:FindFirstChild("attackTime") then
						punch.attackTime.Value = 0
					end
				end
				task.wait(0.1)
			end
		end)
		task.spawn(function()
			while _G.fastHitActive do
				local punch = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Punch")
				if punch then
					punch:Activate()
				end
				task.wait(0.1)
			end
		end)
	else
		local punch = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Punch")
		if punch then
			punch.Parent = LocalPlayer.Backpack
		end
	end
end)





local godModeToggle = false
Killer:AddSwitch("God mode", function(State)
    godModeToggle = State
    if State then
        task.spawn(function()
            while godModeToggle do
                game:GetService("ReplicatedStorage").rEvents.brawlEvent:FireServer("joinBrawl")
                task.wait()
            end
        end)
    end
end)
Killer:AddButton("Size 30", function()
    game:GetService("ReplicatedStorage").rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", 30)
end)

Killer:AddButton("Size 2", function()
    game:GetService("ReplicatedStorage").rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", 2)
end)

local following = false
local followTarget = nil

local function followPlayer(targetPlayer)
    local myChar = LocalPlayer.Character
    local targetChar = targetPlayer.Character

    if not (myChar and targetChar) then return end
    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")

    if myHRP and targetHRP then
        local followPos = targetHRP.Position - (targetHRP.CFrame.LookVector * 3)
        myHRP.CFrame = CFrame.new(followPos, targetHRP.Position)
    end
end

local followDropdown = Killer:AddDropdown("Teleport player", function(selectedDisplayName)
    if selectedDisplayName and selectedDisplayName ~= "" then
        -- Buscar jugador por DisplayName
        local target = nil
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.DisplayName == selectedDisplayName then
                target = plr
                break
            end
        end

        if target then
            followTarget = target.Name -- Guardamos Name real para seguir
            following = true
            print("âœ… Started following:", target.Name)
            followPlayer(target)
        end
    end
end)

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        followDropdown:Add(player.DisplayName)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        followDropdown:Add(player.DisplayName)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    followDropdown:Clear()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            followDropdown:Add(plr.DisplayName)
        end
    end

    if followTarget == player.Name then
        followTarget = nil
        following = false
    end
end)

Killer:AddButton("Dejar de Seguir", function()
    following = false
    followTarget = nil
    print("â›” Stopped following")
end)

task.spawn(function()
    while task.wait(0.01) do
        if following and followTarget then
            local target = Players:FindFirstChild(followTarget)
            if target then
                followPlayer(target)
            else
                following = false
                followTarget = nil
            end
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if following and followTarget then
        local target = Players:FindFirstChild(followTarget)
        if target then
            followPlayer(target)
        end
    end
end)

local godDamageActive = false


Killer:AddSwitch("auto slams", function(state)
    godDamageActive = state
    if state then
        task.spawn(function()
            while godDamageActive do
                local player = LocalPlayer
                local groundSlam = player.Backpack:FindFirstChild("Ground Slam") or (player.Character and player.Character:FindFirstChild("Ground Slam"))

                if groundSlam then
                    if groundSlam.Parent == player.Backpack then
                        groundSlam.Parent = player.Character
                    end
                    if groundSlam:FindFirstChild("attackTime") then
                        groundSlam.attackTime.Value = 0
                    end
                    player.muscleEvent:FireServer("slam")
                    groundSlam:Activate()
                end

                task.wait(0.1)
            end
        end)
    end
end)
Killer:AddLabel("Dead Ring:").TextSize = 22

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ringPart = nil
local ringColor = Color3.fromRGB(50, 163, 255)
local ringTransparency = 0.6
_G.showDeathRing = false
_G.deathRingRange = 20
_G.deathRingEnabled = false

local function updateRingSize()
    if not ringPart then return end
    local d = (_G.deathRingRange or 20) * 2
    ringPart.Size = Vector3.new(0.2, d, d)
end

Killer:AddTextBox("Range 1-150", function(text)
    local r = tonumber(text)
    if r then
        _G.deathRingRange = math.clamp(r, 1, 150)
        updateRingSize()
    end
end)

local function toggleRingVisual()
    if _G.showDeathRing then
        ringPart = Instance.new("Part")
        ringPart.Shape = Enum.PartType.Cylinder
        ringPart.Material = Enum.Material.Neon
        ringPart.Color = ringColor
        ringPart.Transparency = ringTransparency
        ringPart.Anchored = true
        ringPart.CanCollide = false
        ringPart.CastShadow = false
        updateRingSize()
        ringPart.Parent = workspace
    elseif ringPart then
        ringPart:Destroy()
        ringPart = nil
    end
end

local function updateRingPosition()
    if not ringPart then return end
    local c = LocalPlayer.Character
    if not c or not c:FindFirstChild("HumanoidRootPart") then return end
    ringPart.CFrame = c.HumanoidRootPart.CFrame
        * CFrame.new(0, -2.3, 0)
        * CFrame.Angles(0, 0, math.rad(90))
end

local function isPlayerAlive(plr)
    local c = plr.Character
    if not c then return false end
    local h = c:FindFirstChild("Humanoid")
    return h and h.Health > 0
end

local function isWhitelisted(plr)
    if not _G.whitelistedPlayers then return false end
    for _, n in ipairs(_G.whitelistedPlayers) do
        if n:lower() == plr.Name:lower() then
            return true
        end
    end
    return false
end

local function equipPunch()
    local char = LocalPlayer.Character
    if not char then return nil end

    local punch = char:FindFirstChild("Punch") or LocalPlayer.Backpack:FindFirstChild("Punch")
    if punch then
        punch.Parent = char
        return punch
    end

    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if tool.Name == "Punch" then
            tool.Parent = char
            return tool
        end
    end
    return nil
end

local function unequipPunch()
    local char = LocalPlayer.Character
    if not char then return end
    local punch = char:FindFirstChild("Punch")
    if punch then
        punch.Parent = LocalPlayer.Backpack
    end
end

local function killPlayer(plr)
    local char = LocalPlayer.Character
    if not char then return end

    local punch = equipPunch()
    if not punch then return end

    local right = char:FindFirstChild("RightHand")
    local left = char:FindFirstChild("LeftHand")
    if not right or not left then return end

    local targetRoot = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end

    pcall(function()
        firetouchinterest(right, targetRoot, 1)
        firetouchinterest(left, targetRoot, 1)
        firetouchinterest(right, targetRoot, 0)
        firetouchinterest(left, targetRoot, 0)
    end)

    pcall(function()
        if LocalPlayer:FindFirstChild("muscleEvent") then
            LocalPlayer.muscleEvent:FireServer("punch", "rightHand")
            LocalPlayer.muscleEvent:FireServer("punch", "leftHand")
        end
    end)
end

Killer:AddSwitch("Death Ring", function(state)
    _G.deathRingEnabled = state

    if state then
        if not _G.deathRingConnection then
            _G.deathRingConnection = game:GetService("RunService").Heartbeat:Connect(function()
                updateRingPosition()

                local c = LocalPlayer.Character
                local rp = c and c:FindFirstChild("HumanoidRootPart")
                if not rp then return end

                local someoneInRange = false

                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and not isWhitelisted(plr) and isPlayerAlive(plr) then
                        local dist = (rp.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                        if dist <= (_G.deathRingRange or 20) then
                            someoneInRange = true
                            killPlayer(plr)
                        end
                    end
                end

                if someoneInRange == false then
                    unequipPunch()
                end
            end)
        end
    else
        if _G.deathRingConnection then
            _G.deathRingConnection:Disconnect()
            _G.deathRingConnection = nil
        end
        unequipPunch()
    end
end)

Killer:AddSwitch("Show Ring", function(state)
    _G.showDeathRing = state
    toggleRingVisual()
end)

local Lighting = game:GetService("Lighting")

-- Tabla para registrar los tiempos disponibles
local timeOptions = {
    "Morning",
    "Noon",
    "Afternoon",
    "Sunset",
    "Night",
    "Midnight",
    "Dawn",
    "Early Morning"
}

local timeDropdown = Killer:AddDropdown("change time", function(selection)
    -- Reset antes de aplicar
    Lighting.Brightness = 2
    Lighting.FogEnd = 100000
    Lighting.Ambient = Color3.fromRGB(127,127,127)

    if selection == "Morning" then
        Lighting.ClockTime = 6
        Lighting.Brightness = 2
        Lighting.Ambient = Color3.fromRGB(200, 200, 255)
    elseif selection == "Noon" then
        Lighting.ClockTime = 12
        Lighting.Brightness = 3
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    elseif selection == "Afternoon" then
        Lighting.ClockTime = 16
        Lighting.Brightness = 2.5
        Lighting.Ambient = Color3.fromRGB(255, 220, 180)
    elseif selection == "Sunset" then
        Lighting.ClockTime = 18
        Lighting.Brightness = 2
        Lighting.Ambient = Color3.fromRGB(255, 150, 100)
        Lighting.FogEnd = 500
    elseif selection == "Nigth" then
        Lighting.ClockTime = 20
        Lighting.Brightness = 1.5
        Lighting.Ambient = Color3.fromRGB(100, 100, 150)
        Lighting.FogEnd = 800
    elseif selection == "Midnight" then
        Lighting.ClockTime = 0
        Lighting.Brightness = 1
        Lighting.Ambient = Color3.fromRGB(50, 50, 100)
        Lighting.FogEnd = 400
    elseif selection == "Dawn" then
        Lighting.ClockTime = 4
        Lighting.Brightness = 1.8
        Lighting.Ambient = Color3.fromRGB(180, 180, 220)
    elseif selection == "Early Morning" then
        Lighting.ClockTime = 2
        Lighting.Brightness = 1.2
        Lighting.Ambient = Color3.fromRGB(100, 120, 180)
    end
end)

for _, option in ipairs(timeOptions) do
    timeDropdown:Add(option)
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local titleLabel = Killer:AddLabel("Add the display name or initials of his clan")
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.Merriweather 
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

local fileName = "GenesisBlacklist_"..LocalPlayer.Name..".txt"
local blacklistWords = {}
local active = {}
local attackDelay = 0.06
local characterLoaded = false
local autoPunchActive = false

local function trim(s) 
	return s:match("^%s*(.-)%s*$") 
end

local function parseList(text)
	blacklistWords = {}
	if not text or text == "" then return end
	for w in string.gmatch(text, "[^,]+") do
		local t = trim(w):lower()
		if t ~= "" then table.insert(blacklistWords, t) end
	end
end

if isfile(fileName) then
	parseList(readfile(fileName))
else
	writefile(fileName, "")
end

local function saveList()
	writefile(fileName, table.concat(blacklistWords, ","))
end

local function nameMatchesAny(player)
	if not player then return false end
	local dn = (player.DisplayName or ""):lower()
	for _, w in ipairs(blacklistWords) do
		if w ~= "" and string.find(dn, w, 1, true) then
			return true
		end
	end
	return false
end

local function refreshActive()
	for k in pairs(active) do active[k] = nil end

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and nameMatchesAny(plr) then
			active[plr] = true
		end
	end
end

function isAnyActive()
	for _ in pairs(active) do
		return true
	end
	return false
end

local function getHands(char)
	repeat task.wait() until char and char:FindFirstChild("RightHand")
	local right = char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm")
	local left = char:FindFirstChild("LeftHand") or char:FindFirstChild("Left Arm")
	return right, left
end

local function ensurePunchEquipped()
	if not isAnyActive() then return nil end  -- 🔥 NO EQUIPAR si no hay targets

	local char = LocalPlayer.Character
	if not char then return nil end

	local punch = char:FindFirstChild("Punch") or LocalPlayer.Backpack:FindFirstChild("Punch")

	if punch and punch.Parent ~= char then
		punch.Parent = char
	end

	if not punch then
		task.defer(function()
			for i = 1, 40 do
				if not isAnyActive() then return end -- 🔥 Detener si ya no hay targets
				local p = LocalPlayer.Backpack:FindFirstChild("Punch")
				if p then
					p.Parent = LocalPlayer.Character
					break
				end
				task.wait(0.1)
			end
		end)
	end

	return char:FindFirstChild("Punch")
end

local function waitForCharacter()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	characterLoaded = true

	task.spawn(function()
		repeat task.wait() until LocalPlayer:FindFirstChild("Backpack")

		if isAnyActive() then  -- 🔥 SOLO EQUIPAR si hay alguien de la blacklist
			for i = 1, 60 do
				local punch = LocalPlayer.Backpack:FindFirstChild("Punch")
				if punch then
					punch.Parent = char
					break
				end
				task.wait(0.1)
			end
		end
	end)

	return char
end

blacklistLabel = Killer:AddLabel("")
blacklistLabel.Text = (#blacklistWords == 0 and "Blacklist: (empty)" or "Blacklist: "..table.concat(blacklistWords, ","))

local blacklistBox = Killer:AddTextBox("Add to Blacklist", function(txt)
	parseList((table.concat(blacklistWords, ",")..","..txt))
	saveList()
	blacklistLabel.Text = (#blacklistWords == 0 and "Blacklist: (empty)" or "Blacklist: "..table.concat(blacklistWords, ","))

	refreshActive()
	if not isAnyActive() then autoPunchActive = false end
end, {["placeholder"] = "Ej: MVX, Sigma, Juan"})

local removeBox = Killer:AddTextBox("Remove from Blacklist", function(txt)
	local toRemove = {}
	for w in string.gmatch(txt, "[^,]+") do
		local t = trim(w):lower()
		if t ~= "" then table.insert(toRemove, t) end
	end

	for _, word in ipairs(toRemove) do
		for i = #blacklistWords, 1, -1 do
			if blacklistWords[i] == word then
				table.remove(blacklistWords, i)
			end
		end
	end

	saveList()
	blacklistLabel.Text = (#blacklistWords == 0 and "Blacklist: (empty)" or "Blacklist: "..table.concat(blacklistWords, ","))

	refreshActive()

	if not isAnyActive() then autoPunchActive = false end
end)

RunService.Heartbeat:Connect(function()
	refreshActive()
end)

task.spawn(function()
	while true do
		task.wait(attackDelay)

		if not isAnyActive() then
			continue
		end

		if not LocalPlayer.Character then continue end
		if not characterLoaded then continue end

		local punch = ensurePunchEquipped()
		if not punch then continue end

		local char = LocalPlayer.Character
		local rightHand, leftHand = getHands(char)

		for plr in pairs(active) do
			if plr and plr.Character then
				local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
				local hum = plr.Character:FindFirstChild("Humanoid")

				if hrp and hum and hum.Health > 0 then
					pcall(function()
						LocalPlayer.muscleEvent:FireServer("punch", "rightHand")
						LocalPlayer.muscleEvent:FireServer("punch", "leftHand")
					end)

					pcall(function()
						firetouchinterest(rightHand, hrp, 1)
						firetouchinterest(leftHand, hrp, 1)
						firetouchinterest(rightHand, hrp, 0)
						firetouchinterest(leftHand, hrp, 0)
					end)
				end
			end
		end
	end
end)

Players.PlayerAdded:Connect(function(plr)
	plr:GetPropertyChangedSignal("DisplayName"):Connect(function()
		refreshActive()
	end)
end)

LocalPlayer.CharacterAdded:Connect(function()
	characterLoaded = false
	task.wait(0.2)

	waitForCharacter()
	refreshActive()

	if isAnyActive() then
		task.defer(function()
			for i = 1, 50 do
				if not isAnyActive() then break end
				ensurePunchEquipped()
				task.wait(0.15)
			end
		end)
	end
end)

waitForCharacter()
refreshActive()
