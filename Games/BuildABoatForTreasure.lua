local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/88lkk/Pandaware/refs/heads/main/main.lua"))()
local Window = Library:Window("pandaware")

local OtherData = LocalPlayer.OtherData
local Blocks = workspace.Blocks[LocalPlayer.Name]
local Stages = workspace.BoatStages.NormalStages
local ChestTrigger = Stages.TheEnd.GoldenChest.Trigger

do
	local ClaimRemote = workspace.ClaimRiverResultsGold

	-- My optimal config for gold
	local AutoClaim = true
	local ClaimChest = true
	local StartStage = 2
	local ChestClaimStage = 2
	local ChestClaimDelay = 1

	local function CollectStage(StageNumber)
		local Stage = Stages[`CaveStage{StageNumber}`]
		local Collect = Stage.DarknessPart
		local StageData = OtherData[`Stage{StageNumber - 1}`]

		local Char = LocalPlayer.Character
		if not Char then return end

		local Hum = Char:FindFirstChildOfClass("Humanoid")
		if not Hum then return end
		
		repeat
			task.wait()

			if not Char then continue end

			Char:PivotTo(Collect.CFrame * CFrame.new(0, 0, -20))

			for _, BodyPart in Char:GetChildren() do
				if BodyPart:IsA("BasePart") then
					BodyPart.Velocity, BodyPart.RotVelocity = Vector3.zero, Vector3.zero
				end
			end
		until StageData.Value ~= "" or not Char or not Hum or Hum.Health <= 0
	end

	local function TouchChest()
		task.spawn(function()
			local Char = LocalPlayer.Character
			if not Char then return end

			local Hum = Char:FindFirstChildOfClass("Humanoid")
			if not Hum then return end

			repeat
				if not Char or not Hum or Hum.Health <= 0 then continue end

				local Old = ChestTrigger.CFrame
				ChestTrigger.CFrame = Char:GetPivot()
				task.wait()
				ChestTrigger.CFrame = Old
			until OtherData.End.Value ~= "" or not Char or not Hum or Hum.Health <= 0
		end)
	end

	local function Farm()
		local Char = LocalPlayer.Character
		if not Char then return end

		local Hum = Char:WaitForChild("Humanoid")
		if not Hum then return end
		
		for StageNumber = StartStage, 10 do
			local CanContinue = false
			
			task.spawn(function()
				CollectStage(StageNumber)
				CanContinue = true
			end)

			repeat task.wait() until CanContinue or not Char or Hum.Health <= 0

			if StageNumber ~= ChestClaimStage then
				if AutoClaim then
					ClaimRemote:FireServer()
				end
			else
				if ClaimChest then
					task.spawn(function()
						task.wait(ChestClaimDelay)
						TouchChest()
					end)
				end
			end
		end

		if Char then
			Char:BreakJoints()
		end
	end

	Window:Toggle("88lkk's Autofarm", function(Toggled)
		if Toggled then
			Mark("Autofarm", LocalPlayer.CharacterAdded:Connect(Farm))
			Farm()
		else
			Unmark("Autofarm")
		end
	end)
end

do
	local StartQuest = workspace.QuestMakerEvent

	local function GetZone()
		return workspace[`{LocalPlayer.TeamColor}Zone`]
	end

	local function GetQuest()
		local Zone = GetZone()
		return Zone:WaitForChild("Quest")
	end

	local function Place(Name, Pos)
		local BTool = LocalPlayer.Backpack:FindFirstChild("BuildingTool")
		if BTool then
			BTool.Parent = LocalPlayer.Character
		else
			BTool = LocalPlayer.Character:FindFirstChild("BuildingTool")
		end

		if not BTool then return end

		task.spawn(function()
			BTool.RF:InvokeServer(
				Name,
				LocalPlayer.Data[Name].Value,
				nil,
				nil,
				false,
				Pos,
				false
			)
		end)
	end

	local Quests = {
		function()
			local Quest = GetQuest()
			Quest:WaitForChild("Cloud"):WaitForChild("Part1").CFrame = LocalPlayer.Character:GetPivot()
		end,
		function()
			local Quest = GetQuest()
			local Target = Quest:WaitForChild("Target")
			local Done = false

			repeat
				for _, Part in Target:GetChildren() do
					if Part.Name == "Part" and Part:FindFirstChildOfClass("Script") then
						Done = true
						Part.CFrame = LocalPlayer.Character:GetPivot()
						break
					end
				end
				task.wait()
			until Done
		end,
		function()
			local Quest = GetQuest()
			local Ramp = Quest:WaitForChild("Ramp")
			local Done = false

			repeat
				for _, Part in Ramp:GetChildren() do
					if Part.Name == "Part" and Part:FindFirstChildOfClass("TouchTransmitter") then
						Done = true
						Part.CFrame = LocalPlayer.Character:GetPivot()
						break
					end
				end
				task.wait()
			until Done
		end,
		function()
			local Quest = GetQuest()
			local Zone = GetZone()

			repeat
				task.wait()

				if not Quest then break end

				local Butter = Quest:FindFirstChild("Butter")
				if not Butter then continue end

				local Part = Butter:FindFirstChild("PPart")
				if not Part then continue end

				local Click = Part:FindFirstChildOfClass("ClickDetector")
				if not Click then continue end

				fireclickdetector(Click)
			until not Zone:FindFirstChild("Quest")
		end,
		function()
			-- dragon
		end,
		function()
			local Zone = GetZone()
			local Quest = GetQuest()

			local MBox = Quest:WaitForChild("MBox")
			if not MBox then return end

			local PPart = MBox:WaitForChild("PPart")
			if not PPart then return end

			Place("Seat", PPart.CFrame * CFrame.new(2, 0, 0))

			local Finished = false
			Blocks.ChildAdded:Once(function(SeatModel)
				local Char = LocalPlayer.Character
				local Hum = Char.Humanoid
				SeatModel:WaitForChild("Seat"):Sit(Hum)
				repeat task.wait() until Hum.Sit
				Zone.VoteLaunchRE:FireServer()
				task.wait(.5)
				Char:PivotTo(ChestTrigger.CFrame * CFrame.new(0, 0, 0))
				task.wait(5)
				Finished = true
			end)

			repeat task.wait() until Finished
		end,
		function()
			-- broken quest
		end,
		function()
			-- soccer
		end,
		function()
			local Collect = Stages.CaveStage1.DarknessPart
			local StageData = OtherData.Stage0

			local Char = LocalPlayer.Character
			if not Char then return end

			local Hum = Char:FindFirstChildOfClass("Humanoid")
			if not Hum then return end
			
			repeat
				task.wait()

				if not Char then continue end

				Char:PivotTo(Collect.CFrame * CFrame.new(0, -60, -10))

				for _, BodyPart in Char:GetChildren() do
					if BodyPart:IsA("BasePart") then
						BodyPart.Velocity, BodyPart.RotVelocity = Vector3.zero, Vector3.zero
					end
				end
			until StageData.Value ~= "" or not Char or not Hum or Hum.Health <= 0

			LocalPlayer.Character:PivotTo(ChestTrigger.CFrame)
		end
	}

	local Questing = false

	Window:Button("Complete Quests", function()
		if Questing then return end
		Questing = true

		local Zone = GetZone()
		if Zone:FindFirstChild("Quest") then
			StartQuest:FireServer(0)
			repeat task.wait() until not Zone:FindFirstChild("Quest")
			task.wait(1)
		end
		
		for Num, Callback in pairs(Quests) do
			if Num == 7 then
				Num = 8
			end

			if OtherData:FindFirstChild(`Q{Num}`) or Num == 5 or Num == 8 then
				continue
			end

			StartQuest:FireServer(Num)
			Callback()

			local Zone = GetZone()
			repeat task.wait() until not Zone:FindFirstChild("Quest")
			task.wait(1)
		end

		Questing = false
	end)
end

do
	local Clicking = false

	Window:Button("Click Others Blocks", function()
		if Clicking then return end
		Clicking = true

		for _, Folder in workspace.Blocks:GetChildren() do
			if Folder.Name == LocalPlayer.Name then continue end

			for _, Block in Folder:GetChildren() do
				if Block.Name == "CameraDome" then continue end

				local Click = Block:FindFirstChildOfClass("ClickDetector")
				if Click then
					fireclickdetector(Click)
					task.wait()
				end
			end
		end

		Clicking = false
	end)
end

do
	local ChangeTeam = workspace.ChangeTeam
	local TeamList = {}

	for _, T in Teams:GetChildren() do
		if T:IsA("Team") then
			table.insert(TeamList, T)
		end
	end

	Window:Button("Crash Server", function()
		for _ = 1, 5000 do
			for _, Team in TeamList do
				ChangeTeam:FireServer(Team)
			end
		end
	end)
end
