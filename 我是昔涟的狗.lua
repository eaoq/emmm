local correctKey = "catgusind"
local keyVerified = false
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer
local DataStoreService = game:GetService("DataStoreService")
local verifyStore = DataStoreService:GetDataStore("KnobFarmVerify_"..player.UserId)

pcall(function()
    keyVerified = verifyStore:GetAsync("IsVerified") or false
end)

local keyGui = Instance.new("ScreenGui")
keyGui.Name = "KeyVerifyGui"
keyGui.ResetOnSpawn = false
keyGui.IgnoreGuiInset = true
keyGui.Parent = CoreGui
keyGui.Enabled = not keyVerified

local keyFrame = Instance.new("Frame")
keyFrame.Size = UDim2.new(0,300,0,150)
keyFrame.Position = UDim2.new(0.5,-150,0.5,-75)
keyFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
keyFrame.Parent = keyGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0,12)
UICorner.Parent = keyFrame

local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(0,260,0,40)
keyInput.Position = UDim2.new(0,20,0,30)
keyInput.PlaceholderText = "请输入卡密"
keyInput.BackgroundColor3 = Color3.fromRGB(50,50,50)
keyInput.TextColor3 = Color3.new(1,1,1)
keyInput.ClearTextOnFocus = false
keyInput.Parent = keyFrame

local confirmBtn = Instance.new("TextButton")
confirmBtn.Size = UDim2.new(0,260,0,40)
confirmBtn.Position = UDim2.new(0,20,0,85)
confirmBtn.Text = "验证卡密"
confirmBtn.BackgroundColor3 = Color3.fromRGB(52,199,89)
confirmBtn.TextColor3 = Color3.new(1,1,1)
confirmBtn.Font = Enum.Font.GothamBold
confirmBtn.TextSize = 20
confirmBtn.Parent = keyFrame
Instance.new("UICorner",confirmBtn).CornerRadius = UDim.new(0,8)

confirmBtn.MouseButton1Click:Connect(function()
    if keyInput.Text == correctKey then
        keyVerified = true
        pcall(function()
            verifyStore:SetAsync("IsVerified",true)
        end)
        keyGui:Destroy()
        loadScript()
    else
        keyInput.Text = ""
        keyInput.PlaceholderText = "卡密错误！重新输入"
    end
end)

function loadScript()
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)
local farmenabled = false
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KnobFarmGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = CoreGui
local button = Instance.new("TextButton")
button.Parent = screenGui
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0, 10, 1, -150)
button.Text = "刷门把手: OFF"
button.BackgroundColor3 = Color3.fromRGB(255, 69, 58)
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.GothamBold
button.TextSize = 24
button.BorderSizePixel = 0
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = button

local function startFarm()
    while farmenabled do
        replicatesignal(player.Kill)
        game:GetService("ReplicatedStorage"):WaitForChild("RemotesFolder"):WaitForChild("Statistics"):FireServer()
        task.wait(0.25)
    end
end

button.MouseButton1Click:Connect(function()
    farmenabled = not farmenabled
    if farmenabled then
        button.Text = "刷门把手: ON"
        button.BackgroundColor3 = Color3.fromRGB(52, 199, 89)
        startFarm()
    else
        button.Text = "刷门把手: OFF"
        button.BackgroundColor3 = Color3.fromRGB(255, 69, 58)
    end
end)
end

if keyVerified then
    keyGui:Destroy()
    loadScript()
end