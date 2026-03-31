-- VELX-SCRIPT + FPS BOOST

local player = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local remote = rs:WaitForChild("AttackEvent")

-- FPS BOOST
local lighting = game:GetService("Lighting")

lighting.GlobalShadows = false
lighting.FogEnd = 9e9
lighting.Brightness = 1

settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

for _,v in pairs(game:GetDescendants()) do
    if v:IsA("BasePart") then
        v.Material = Enum.Material.SmoothPlastic
        v.Reflectance = 0
    end
    
    if v:IsA("Decal") or v:IsA("Texture") then
        v:Destroy()
    end
    
    if v:IsA("ParticleEmitter") 
    or v:IsA("Trail") 
    or v:IsA("Fire") 
    or v:IsA("Smoke") then
        v:Destroy()
    end
end

-- UI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "TestUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,230,0,260)
frame.Position = UDim2.new(0.4,0,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
frame.Active = true
frame.Draggable = true

local function btn(y,text)
    local b = Instance.new("TextButton",frame)
    b.Size = UDim2.new(1,0,0,30)
    b.Position = UDim2.new(0,0,0,y)
    b.Text = text
    return b
end

local speed = btn(0,"Speed OFF")
local hit   = btn(35,"Auto Hit OFF")
local spam  = btn(70,"Spam 0.1s OFF")
local far   = btn(105,"Far Hit OFF")
local stress= btn(140,"Stress OFF")
local fps   = btn(175,"FPS Boost ON")

local speedOn,hitOn,spamOn,farOn,stressOn=true,false,false,false,false

local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- SPEED
speed.MouseButton1Click:Connect(function()
    speedOn = not speedOn
    hum.WalkSpeed = speedOn and 100 or 16
    speed.Text = "Speed "..(speedOn and "ON" or "OFF")
end)

-- AUTO HIT
hit.MouseButton1Click:Connect(function()
    hitOn = not hitOn
    hit.Text = "Auto Hit "..(hitOn and "ON" or "OFF")
end)

-- SPAM
spam.MouseButton1Click:Connect(function()
    spamOn = not spamOn
    spam.Text = "Spam "..(spamOn and "ON" or "OFF")
end)

-- FAR HIT
far.MouseButton1Click:Connect(function()
    farOn = not farOn
    far.Text = "Far Hit "..(farOn and "ON" or "OFF")
end)

-- STRESS
stress.MouseButton1Click:Connect(function()
    stressOn = not stressOn
    stress.Text = "Stress "..(stressOn and "ON" or "OFF")
end)

-- LOOP
task.spawn(function()
    while true do
        if hitOn or spamOn or stressOn or farOn then

            local repeatCount = stressOn and 5 or 1

            for i = 1, repeatCount do
                for _,npc in pairs(workspace:GetDescendants()) do
                    if npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") and npc.Name == "NPC" then
                        
                        local dist = (npc.HumanoidRootPart.Position - root.Position).Magnitude
                        
                        if farOn then
                            if dist < 150 then
                                remote:FireServer(npc)
                            end
                        else
                            if dist < 30 then
                                remote:FireServer(npc)
                            end
                        end

                    end
                end
            end
        end

        task.wait(stressOn and 0.05 or (spamOn and 0.1 or 0.3))
    end
end)
