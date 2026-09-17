local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/88lkk/Pandaware/refs/heads/main/main.lua"))()
local Window = Library:Window("pandaware")

local Remotes = ReplicatedStorage.Remotes

do
	Window:Toggle("AntiWarp", function(Toggle)
		if Toggle then
			local Save = {
				Position = nil,
				Cam = nil,
				Velocity = nil
			}

			local CanSave = true

			Mark("AntiWarp", LocalPlayer.CharacterAdded:Connect(function(Char)
				CanSave = false

				local Root = Char:WaitForChild("HumanoidRootPart")
				if not Root then return end

				Root.CFrame = Save.Position
				Root.Velocity = Save.Velocity
				Camera.CFrame = Save.Cam

				CanSave = true
			end))
			
			Loop("AntiWarp", function()
				task.wait()

				if not CanSave then return end
				
				local Char = LocalPlayer.Character
				if Char then
					local Root = Char:FindFirstChild("HumanoidRootPart")
					if Root then
						Save.Position = Root.CFrame
						Save.Velocity = Root.Velocity
					end
				end

				Save.Cam = Camera.CFrame
			end)
		else
			Unloop("AntiWarp")
			Unmark("AntiWarp")
		end
	end)
end

do
	local Cache = {}
	Window:Toggle("Noclip", function(Toggle)
		if Toggle then
			local Char = LocalPlayer.Character
			if Char then
				for _, Part in Char:GetChildren() do
					if Part:IsA("BasePart") then
						Cache[Part.Name] = Part.CanCollide
					end
				end
			end

			Loop("Noclip", function()
				RunService.Stepped:Wait()

				local Char = LocalPlayer.Character
				if not Char then return end

				for _, Part in Char:GetChildren() do
					if Part:IsA("BasePart") then
						Part.CanCollide = false
					end
				end
			end)
		else
			Unloop("Noclip")

			local Char = LocalPlayer.Character
			if Char then
				for Name, Collide in Cache do
					local Found = Char:FindFirstChild(Name)
					if not Found then continue end

					Found.CanCollide = Collide
				end

				-- For some reason can collide doesn't
				-- enable back collisions until u change state
				local Hum = Char:FindFirstChildOfClass("Humanoid")
				if Hum then
					Hum:ChangeState(2)
				end
			end

			Cache = {}
		end
	end)
end

do
	local Courses = workspace.ObstacleCourses
	local Rep = LocalPlayer.leaderstats.Rep
	local Farm = false

	Window:Toggle("RepFarm", function(Toggle)
		if Toggle then
			Farm = Toggle

			Loop("Farm", function()
				task.wait()

				local Char = LocalPlayer.Character
				if not Char then return end

				local Hum = Char:FindFirstChildOfClass("Humanoid")
				if not Hum then return end

				local Cooldown = tick()
				local Old = Char:GetPivot()

				for _, C in Courses:GetChildren() do
					if C:IsA("Model") and C.Name:sub(1, 3) == "Obs" then
						local Detection = C.Detection
						local Touch = C.ObstacleCourse
						
						repeat
							Char:PivotTo(Detection.CFrame)
							Hum:ChangeState(2)
							for _, Part in Char:GetChildren() do
								if Part:IsA("BasePart") then
									Part.Velocity = Vector3.new(0, math.random(-5, 5), 0)
									Part.RotVelocity = Vector3.zero
								end
							end
							task.wait()
						until not Farm or not Char or not Hum or LocalPlayer:FindFirstChild(C.Name)

						repeat
							Char:PivotTo(Touch.CFrame * CFrame.new(0, 3, 0))
							Hum:ChangeState(2)
							for _, Part in Char:GetChildren() do
								if Part:IsA("BasePart") then
									Part.Velocity = Vector3.new(0, math.random(-5, 5), 0)
									Part.RotVelocity = Vector3.zero
								end
							end
							task.wait()
						until not Farm or not Char or not Hum or not LocalPlayer:FindFirstChild(C.Name)

						if not Farm or not Char or not Hum then break end
					end
				end

				if Char and Old then
					task.wait()
					Char:PivotTo(Old)
				end

				repeat task.wait() until (tick() - Cooldown) >= 125
			end)
		else
			Unloop("Farm")
		end
	end)
end

do
	local MorphDelay = 0.1
	local MorphFolder = workspace.Morphs

	Window:Toggle("MorphSpam", function(Toggle)
		if Toggle then
			Loop("MorphSpam", function()
				task.wait()

				local Char = LocalPlayer.Character
				if not Char then return end

				for _, Morph in MorphFolder:GetChildren() do
					if Morph:IsA("Model") then
						task.spawn(function()
							local Button = Morph.MorphButton
							Button.CanCollide = false
							Button.CFrame = Char:GetPivot()
							task.wait()
							if Button then
								Button.CFrame = CFrame.new(0, 9e5, 0)
							end
						end)
						task.wait(MorphDelay)
					end
				end
			end)
		else
			Unloop("MorphSpam")
		end
	end)
end
