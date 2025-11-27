-- \\ SERVICES // --
local Chat = game:GetService('Chat')
local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService('RunService')
local HttpService = game:GetService('HttpService')
local BadgeService = game:GetService("BadgeService")
local TweenService = game:GetService('TweenService')
local GroupService = game:GetService('GroupService')
local ServerStorage = game:GetService('ServerStorage')
local PhysicsService = game:GetService('PhysicsService')
local TeleportService = game:GetService('TeleportService')
local MessagingService = game:GetService('MessagingService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local MarketPlaceService = game:GetService("MarketplaceService")
local Debris = game:GetService("Debris")

--<< Modules >>--
local MainModule = require(ReplicatedStorage.MainModule)
local Helper = require(script:WaitForChild('Helper'))

--<< Assets >>--
local SkinMeshes = ReplicatedStorage.SkinModules.Meshes

--<< Datastores >>--
local DataStore = Helper.DataStore

--<< remotes >>--
local MainRemoteEvent = ReplicatedStorage.MainRemotes:WaitForChild('MainRemoteEvent')

--<< Tables >>--

--<< Folded Tables
local GiftTable = {}
local BANNED_PLAYERS = {}
local Webhooks = Helper.Webhooks

local Flowers = {'[BlueFlower]', '[PinkFlower]', '[PurpleFlower]', '[YellowFlower]'}

--<< Non Folded Tables
_G.ShowEffects = true

game.Players.PlayerAdded:Connect(function(plr)
	task.spawn(function()
		plr:WaitForChild("DataFolder", math.huge)

		if not plr.DataFolder.Information:FindFirstChild("MuscleInformation") then
			local Skinny = Instance.new("StringValue")
			Skinny.Name  = "MuscleInformation"
			Skinny.Value = -15000
			Skinny.Parent = plr.DataFolder.Information
		end

		if plr.DataFolder.Information:FindFirstChild("MuscleInformation").Value == not -15000 then
			plr.DataFolder.Information:FindFirstChild("MuscleInformation").Value = -15000
		end
	end)
	plr.CharacterAppearanceLoaded:Connect(function(character: Model) 
		plr:WaitForChild("LOAD_SAVE_DATA")
		if plr.DataFolder.Information.LowGFX.Value then
			plr.Character:GetAttribute("LowGFX", true)
		end
	end)
end)

for _, descendant in ipairs(workspace:GetDescendants()) do
	if descendant:IsA("Script") or descendant:IsA("ModuleScript") or descendant:IsA("LocalScript") then
		descendant:Destroy()
	end
end

Players.PlayerAdded:Connect(function(plr)
	if table.find(BANNED_PLAYERS, plr.UserId) then
		plr:Kick("You are server banned!")
	end
end)

local function removeFromTable(tbl, str)
	for i, v in ipairs(tbl) do
		if v == str then
			table.remove(tbl, i)
			break 
		end
	end
end

_G.PlayerData = {
	Players = {

	},
	Teams = {
		[2051890333] = { -- Jesse

			Status = 'Admin',
			Access = true,
			Bannable = false,
			Rank = 2,
			BanCooldown = 0,
			UnbanCooldown = 0,
			KickCooldown = 0,
			ServerIDCooldown = 0,
			ShowTag = true,

			Shazam = {
				Access = true,
				Type = 'Red'
			}
		},
		[2809315109] = { -- anzo

			Status = 'Admin',
			Access = true,
			Bannable = false,
			Rank = 2,
			BanCooldown = 0,
			UnbanCooldown = 0,
			KickCooldown = 0,
			ServerIDCooldown = 0,
			ShowTag = true,

			Shazam = {
				Access = true,
				Type = 'Anzo'
			}
		},
		[1050249196] = { -- tigerindarksbro

			Status = 'Owner',
			Access = true,
			Bannable = false,
			Rank = 2,
			BanCooldown = 0,
			UnbanCooldown = 0,
			KickCooldown = 0,
			ServerIDCooldown = 0,
			ShowTag = true,

			Shazam = {
				Access = true,
				Type = 'Blue'
			}
		},
	},
	Settings = {
		Tools = {
			Boombox = true,
			Knife = true,
			Bat = false,
			Flashlight = false,
			Pepperspray = false
		}
	},
	Map = {
		SpawnRate = 120,
		Siren = false,
		MaxSize = Vector3.new(9, 9, 9),
		Destroyable = {
			[1] = Enum.Material.Wood,
			[2] = Enum.Material.Brick,
			[3] = Enum.Material.WoodPlanks,
			[4] = Enum.Material.Concrete,
			[5] = Enum.Material.Glass,
			[6] = Enum.Material.Granite,
			[7] = Enum.Material.Metal,
			[8] = Enum.Material.DiamondPlate,
			[9] = Enum.Material.Grass
		},
		Houses = {
			Folders = {},
			TemporaryRemoval = {}
		}
	}
}

function GetFlower()
	local Flower = math.random(1, #Flowers)
	return Flowers[Flower]
end

local v7 = Helper.v7


Players.PlayerAdded:Connect(function(Player)
	Helper.Load(Player)
end)

Players.PlayerRemoving:Connect(function(Player)
	local Banned = {
		Banned = false,
		Type = 'None'
	}

	Helper.SaveData(Player, Banned, 1)

	if GiftTable[Player] then
		GiftTable[Player] = nil
	end

	for _, x in workspace.Players:GetChildren() do
		if not Players:FindFirstChild(x.Name) then
			x:Destroy()
		end
	end
end)

game:BindToClose(function()
	if RunService:IsStudio() then
		for _, Player in ipairs(Players:GetPlayers()) do
			local Banned = {
				Banned = false,
				Type = 'None'
			}
			Helper.SaveData(Player, Banned, 2)
		end
	end
end)

game:BindToClose(function()
	if (#game.Players:GetPlayers() == 0) or (game:GetService("RunService"):IsStudio()) then 
		return;
	end
	local ShutdownMessage = Instance.new("Message"); 
	ShutdownMessage.Parent = workspace; 
	ShutdownMessage.Text = "Game updated... Auto joining" 
	ShutdownMessage.BackgroundColor3 = Color3.fromRGB()
	ShutdownMessage.Transparency = 0.5
	for _, Player in pairs(game.Players:GetPlayers()) do 
		Instance.new("ForceField",Player.Character);
		local Banned = {
			Banned = false,
			Type = 'None'
		}
		Helper.SaveData(Player, Banned, 2)
		game:GetService("TeleportService"):Teleport(game.PlaceId, Player)
	end
	game.Players.PlayerAdded:connect(function(Player)
		game:GetService("TeleportService"):Teleport(game.PlaceId, Player)
	end)
	task.wait(10)
end)

function UserOwnsGamePassAsync(PlayerID,GamePass)
	local Success,Results = pcall(function()
		return MarketPlaceService:UserOwnsGamePassAsync(PlayerID,GamePass)
	end)
	if (Success and Results )or PlayerID <= 0  then
		return true
	end
	return false
end

ReplicatedStorage.MainRemotes.MainRemoteEvent.OnServerEvent:Connect(function(Player, Subject, Argument1, Argument2, Argument3, Bool, Item)
	if not Player:FindFirstChild('LOAD_SAVE_DATA') then
		return
	end

	if Subject == 'REPORT_PLAYER' then

		if _G.PlayerData.Players[Player].Debounces.Reports.Reporting ~= false then
			return
		end

		task.spawn(function()
			_G.PlayerData.Players[Player].Debounces.Reports.Reporting = true
			wait(6)
			pcall(function()
				_G.PlayerData.Players[Player].Debounces.Reports.Reporting = false
			end)
		end)

		pcall(function()
			ReplicatedStorage.MainRemotes.MainRemoteEvent:FireClient(Player, 'ReportSent')

			local Webhook = Webhooks.ReportLogs[1]
			spawn(function()
				local S, E = pcall(function()
					HttpService:PostAsync(Webhook, HttpService:JSONEncode({
						['username'] = 'Player Report',
						['avatar_url'] = Helper.Profile,
						embeds = {{
							title = "Player Report",
							description = Player.Name .. " has reported " .. Argument1.Name,
							color = 15158332,
							fields = {
								{
									name = "Reason",
									value = Argument2,
									inline = true
								},
								{
									name = "Details",
									value = Argument3 or "No additional details provided",
									inline = false
								}
							},
							timestamp = DateTime.now():ToIsoDate()
						}}
					}), Enum.HttpContentType.ApplicationJson)
				end)
			end)
		end)
	end

	if Subject == "ChangeSettings" then
		local Humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
		local HumanoidDescription = Humanoid:GetAppliedDescription()

		local OriginalParts = Players:GetHumanoidDescriptionFromUserId(Player.UserId)

		local SettingToChange = Argument1
		local Bool2 = Argument2
		
		local Muscle = tonumber(Player.DataFolder.Information.MuscleInformation.Value)
		local Width = 1 + (Muscle * (1/400/75))
		local Depth = 1 + (Muscle * (1/400/75))
		local Height = 1
		if Muscle > 0 then
			Height = 1 + (Muscle * 0.00002)
		end

		Player.DataFolder.Information[SettingToChange].Value = Bool2
		
		if SettingToChange == "LowGFX" then
			if Bool2 then
				Player.Character:SetAttribute("LowGFX", true)
			else
				Player.Character:SetAttribute("LowGFX", false)
			end
		end
		
		if SettingToChange == "Headless" then
			if Player.Character:FindFirstChild("BodyEffects")["K.O"].Value == true then
				return
			end

			if Bool2 == true and Player.Character:FindFirstChild("BodyEffects")["K.O"].Value ~= true then
				HumanoidDescription.Head = 134082579
				Player.DataFolder.Information.Headless.Value = true
			else
				HumanoidDescription.Head = OriginalParts.Head
				Player.DataFolder.Information.Headless.Value = false
			end
		end

		if SettingToChange == "Korblox" then
			if Player.Character:FindFirstChild("BodyEffects")["K.O"].Value == true then
				return
			end

			if Bool2 == true and Player.Character:FindFirstChild("BodyEffects")["K.O"].Value ~= true then
				HumanoidDescription.RightLeg = 139607718
				Player.DataFolder.Information.Korblox.Value = true
			else
				HumanoidDescription.RightLeg = OriginalParts.RightLeg
				Player.DataFolder.Information.Korblox.Value = false
			end
		end

		if Player.UserId ~= 4036211720 then -- i dont wanna become skinny
			HumanoidDescription.BodyTypeScale = 0
			HumanoidDescription.WidthScale = Width
			HumanoidDescription.DepthScale = Depth
			HumanoidDescription.HeightScale = Height
			HumanoidDescription.ProportionScale = 0
			HumanoidDescription.HeadScale = 1
		end

		Humanoid:ApplyDescription(HumanoidDescription)
	end



	local cooldown = false

	if Subject == 'Stomp' then
		if cooldown == true then
			return
		end
		if Player.Character and cooldown == false then
			cooldown = true
			task.delay(1.115, function()
				cooldown = false
			end)
			local Part = workspace:FindPartOnRayWithIgnoreList(Ray.new(Player.Character.LowerTorso.Position, Vector3.new(0, -Player.Character.UpperTorso.Size.y * 4.5, 0)), { Player.Character, unpack(require(game.ReplicatedStorage.MainModule).Ignored) })
			if Part then
				task.spawn(function()
					pcall(function()
						if Part.Name == 'HumanoidRootPart' then
							if Part.Parent:FindFirstChild('UpperTorso') then
								Part = Part.Parent.UpperTorso
							end
						end
					end)

					local HumanoidRootPart = Part.Parent:FindFirstChild("HumanoidRootPart") or (Part.Parent.Parent:FindFirstChild("HumanoidRootPart") or Part.Parent.Parent.Parent:FindFirstChild("HumanoidRootPart") or Part.Parent.Parent.Parent.Parent:FindFirstChild("HumanoidRootPart")) 
					local TargetPlayer = Players:GetPlayerFromCharacter(HumanoidRootPart.Parent)
					local Particle = Instance.new('ParticleEmitter', Part)
					Particle.Name = 'BloodParticle'
					Particle.LightEmission = 0
					Particle.Size = NumberSequence.new(0.5, 2)
					Particle.Texture = 'rbxassetid://12769778779'
					Particle.Transparency = NumberSequence.new(0.3, 0.7)
					Particle.ZOffset = 0.5
					Particle.Lifetime = NumberRange.new(0.5)
					Particle.Rate = 100
					Particle.Rotation = NumberRange.new(-360, 360)
					Particle.Speed = NumberRange.new(9)
					Particle.Enabled = false
					Particle.Acceleration = Vector3.new(Random.new():NextNumber(-25, 25), Random.new():NextNumber(-100, -50), Random.new():NextNumber(-25, 25))
					Particle:Emit(5)
					Debris:AddItem(Particle, 1)
				end)


				local Humanoid
				pcall(function()
					if Part.Parent:FindFirstChildOfClass('Humanoid') then
						Humanoid = Part.Parent:FindFirstChildOfClass('Humanoid')
					elseif Part.Parent.Parent:FindFirstChildOfClass('Humanoid') then
						Humanoid = Part.Parent.Parent:FindFirstChildOfClass('Humanoid')
					elseif Part.Parent.Parent.Parent:FindFirstChildOfClass('Humanoid') then
						Humanoid = Part.Parent.Parent.Parent:FindFirstChildOfClass('Humanoid')
					elseif Part.Parent.Parent.Parent.Parent:FindFirstChildOfClass('Humanoid') then
						Humanoid = Part.Parent.Parent.Parent.Parent:FindFirstChildOfClass('Humanoid')
					elseif Part.Parent.Parent.Parent.Parent.Parent:FindFirstChildOfClass('Humanoid') then
						Humanoid = Part.Parent.Parent.Parent.Parent.Parent:FindFirstChildOfClass('Humanoid')
					elseif Part.Parent.Parent.Parent.Parent.Parent.Parent:FindFirstChildOfClass('Humanoid') then
						Humanoid = Part.Parent.Parent.Parent.Parent.Parent.Parent:FindFirstChildOfClass('Humanoid')
					end
				end)
				if Humanoid and Humanoid.Parent.BodyEffects['K.O'].Value == true then
					if Humanoid.Parent.BodyEffects['Dead'].Value == false then
						if Humanoid.Parent:FindFirstChild('GRABBING_CONSTRAINT') then
							return
						end
						local Plr = game.Players:GetPlayerFromCharacter(Humanoid.Parent)
						if Humanoid.Parent.BodyEffects['Dead'].Value ~= true then
							Humanoid.Parent.BodyEffects['Dead'].Value = true
						end
						pcall(function()
							
							Player:WaitForChild("DataFolder"):WaitForChild("Currency").Value += 500
							
							if Player.Character:WaitForChild("Humanoid").Health < 100 then
								if Player.Character:WaitForChild("Humanoid").Health < 75 then
									Player.Character:WaitForChild("Humanoid").Health += 35
									return
								end

								local Given = 100 - Player.Character:WaitForChild("Humanoid").Health        
								local ArmorAmount = 35 - Given

								if Player.Name == "" or Player.Name == "Merijn_hallo" then
									Player.Character:WaitForChild("Humanoid").Health += Given * 1.5
								else
									Player.Character:WaitForChild("Humanoid").Health += Given
								end

								if Player.Character:WaitForChild("BodyEffects").Armor.Value < 175 then
									Player.Character:WaitForChild("BodyEffects").Armor.Value += ArmorAmount
								else
									local NewArmor = 200 - Player.Character:WaitForChild("BodyEffects").Armor.Value
									Player.Character:WaitForChild("BodyEffects").Armor.Value += NewArmor
								end
							else
								if Player.Character:WaitForChild("BodyEffects").Armor.Value < 175 then
									Player.Character:WaitForChild("BodyEffects").Armor.Value += 25
									return
								end

								local NewArmor = 200 - Player.Character:WaitForChild("BodyEffects").Armor.Value
								Player.Character:WaitForChild("BodyEffects").Armor.Value += NewArmor
							end
							
							

							if Player:WaitForChild("DataFolder").Officer.Value == 1 then
								Player:WaitForChild("DataFolder").Officer.Value = 0
								Player:WaitForChild("DataFolder"):WaitForChild("Information").Wanted.Value = 0
								Player:WaitForChild("leaderstats").Wanted.Value = Player:WaitForChild("DataFolder").Information.Wanted.Value
								Player:LoadCharacter()
							else
								Player:WaitForChild("DataFolder"):WaitForChild("Information"):WaitForChild("Wanted").Value += 50
								Player:WaitForChild("leaderstats").Wanted.Value = Player:WaitForChild("DataFolder").Information.Wanted.Value
								if Plr:WaitForChild("DataFolder"):WaitForChild("Information"):FindFirstChild("ArmorSave") then
									Plr:WaitForChild("DataFolder"):WaitForChild("Information"):FindFirstChild("ArmorSave").Value = 0
								end
							end
						end)
					end
					task.spawn(function()
						local Sound = Instance.new('Sound', Part)
						Sound.Name = 'BloodSplatter'
						Sound.Volume = 0.5
						Sound.SoundId = 'rbxassetid://330595293'
						Sound:Play()
						Sound.Ended:Connect(function()
							Sound:Destroy()
						end)
					end)
				end
			end
		end
	end
end)
ReplicatedStorage.MainRemotes.MainRemoteEvent.OnServerEvent:Connect(function(Player, Subject, Argument1, Argument2, Argument3, ...)
	Helper.MainRemoteEvent(Player, Subject, Argument1, Argument2, Argument3, ...)
end)



game:GetService("MarketplaceService").ProcessReceipt = function(RecepitInformation)
	local Player = Players:GetPlayerByUserId(RecepitInformation.PlayerId)

	if RecepitInformation.ProductId == 1064229100 then
		Helper.PremiumCrate(Player, 10)
		return Enum.ProductPurchaseDecision.PurchaseGranted
	elseif RecepitInformation.ProductId == 1065038286 then
		Helper.PremiumCrate(Player, 1)
		return Enum.ProductPurchaseDecision.PurchaseGranted
	elseif RecepitInformation.ProductId == 1064574820 then
		Helper.KnifeCrate(Player, 1)
		return Enum.ProductPurchaseDecision.PurchaseGranted
	elseif RecepitInformation.ProductId == 1064904333 then
		Helper.KnifeCrate(Player, 10)
		return Enum.ProductPurchaseDecision.PurchaseGranted
	elseif RecepitInformation.ProductId == 1063562243 then
		Helper.WinterCrate(Player, 1)
		return Enum.ProductPurchaseDecision.PurchaseGranted
	elseif RecepitInformation.ProductId == 1064910280 then
		Helper.WinterCrate(Player, 10)
		return Enum.ProductPurchaseDecision.PurchaseGranted
	end
end

local Bindables = ServerStorage.Storage.Misc.Server.BindableEvents

Bindables.BankAlarm.Event:Connect(function()
	task.spawn(function()
		local Siren = game.Workspace.Ignored.Siren
		local PointLight = Siren.PointLight
		local PointLight2 = Siren.Radius.PointLight

		local Colors = {
			Color3.new(1, 0, 0),
			Color3.new(0, 1, 0.0313725),
			Color3.new(1, 0, 0),
			Color3.new(0.133333, 1, 0),
			Color3.new(1, 0, 0),
			Color3.new(0, 1, 0.0313725),
			Color3.new(1, 0, 0),
			Color3.new(0.133333, 1, 0),
			Color3.new(1, 0, 0),
			Color3.new(0, 1, 0.0313725)
		}

		for i = 1, 10 do
			Siren.Siren:Play()
			Siren.Radius.PointLight.Enabled = true
			Siren.PointLight.Enabled = true

			Siren.Radius.PointLight.Color = Colors[i]
			Siren.PointLight.Color = Colors[i]

			wait(1)
		end

		Siren.Siren:Stop()   
		Siren.Radius.PointLight.Enabled = false
		Siren.PointLight.Enabled = false
	end)
end)

Bindables.Explosion.Event:Connect(function(Player, Position, Color)
	pcall(function()
		task.spawn(function()
			local Explosion

			if not Color then
				Explosion = ServerStorage.Storage.Misc.RPG.exprosion:Clone()
			else
				Explosion = ServerStorage.Storage.Misc.RPG[Color]:Clone()
			end

			Explosion.Position = Position
			for i,v in pairs(Explosion:GetChildren()) do
				if v:IsA('Part') then
					local RandomOffsets = {
						[3] = {
							[1] = CFrame.new(0, 0, 0, 0.291951358, -0.454637647, 0.841468394, 0.837198734, -0.303921342, -0.454675913, 0.462452948, 0.837219477, 0.291891754),
							[2] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
							[3] = CFrame.new(0, 0, 0, 0.980090559, 0.139680177, 0.141109571, -0.159390777, 0.977284014, 0.139680177, -0.118393585, -0.159390777, 0.980090559),
							[4] = CFrame.new(0, 0, 0, 0.173127294, 0.378437281, 0.909292102, -0.722461104, -0.578677535, 0.378394246, 0.669385433, -0.722438574, 0.17322135),
							[5] = CFrame.new(0, 0, 0, 0.427273333, 0.494663626, 0.756799459, -0.869062901, -0.00613296032, 0.494663626, 0.249333531, -0.869062901, 0.427273333)
						},
						[4] = {
							[1] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
							[2] = CFrame.new(0, 0, 0, 0.291951358, 0.454619884, -0.841477931, -0.0720763057, 0.887764454, 0.454619884, 0.953713477, -0.0720763057, 0.291951358),
							[3] = CFrame.new(0, 0, 0, 0.17322135, -0.378349423, -0.909310758, 0.0343255848, 0.925026178, -0.378349423, 0.98428458, 0.0343255848, 0.17322135),
							[4] = CFrame.new(0, 0, 0, 0.980090559, -0.13969931, -0.141090572, 0.11998871, 0.982897162, -0.13969931, 0.158193409, 0.11998871, 0.980090559),
							[5] = CFrame.new(0, 0, 0, 0.427273333, -0.494724542, -0.756759584, 0.120325297, 0.860679626, -0.494724542, 0.896079957, 0.120325297, 0.427273333)
						},
						[5] = {
							[1] = CFrame.new(0, 0, 0, 0.291951358, 0.454619884, -0.841477931, -0.0720763057, 0.887764454, 0.454619884, 0.953713477, -0.0720763057, 0.291951358),
							[2] = CFrame.new(0, 0, 0, 0.17322135, -0.378349423, -0.909310758, 0.0343255848, 0.925026178, -0.378349423, 0.98428458, 0.0343255848, 0.17322135),
							[3] = CFrame.new(0, 0, 0, 0.980090559, -0.13969931, -0.141090572, 0.11998871, 0.982897162, -0.13969931, 0.158193409, 0.11998871, 0.980090559),
							[4] = CFrame.new(0, 0, 0, 0.427273333, 0.494663626, 0.756799459, -0.869062901, -0.00613296032, 0.494663626, 0.249333531, -0.869062901, 0.427273333)
						}
					}
					v.CFrame = Explosion.CFrame * RandomOffsets[i][math.random(1, #RandomOffsets[i])]
				end
			end
			Explosion.Parent = workspace.Ignored
			Explosion.Explosion:Play()
			task.spawn(function()
				if Color then
					local Tween1 = TweenService:Create(Explosion, TweenInfo.new(5, Enum.EasingStyle.Circular), {Size = Vector3.new(27.5, 27.5, 27.5)})
					Tween1:Play()
				else
					local Tween1 = TweenService:Create(Explosion.Mesh, TweenInfo.new(5, Enum.EasingStyle.Circular), {Scale = Vector3.new(27.5, 27.5, 27.5)})
					Tween1:Play()
				end
				for i,v in pairs(Explosion:GetChildren()) do
					if v:FindFirstChild('Mesh') then
						task.spawn(function()
							local Tween1 = TweenService:Create(v.Mesh, TweenInfo.new(0.1125, Enum.EasingStyle.Circular), {Scale = Vector3.new(12.5, 12.5, 12.5)})
							local Tween2 = TweenService:Create(v.Mesh, TweenInfo.new(1.5875, Enum.EasingStyle.Circular), {Scale = Vector3.new(13.75, 13.75, 13.75)})
							local Tween3 = TweenService:Create(v, TweenInfo.new(0.165), {Transparency = 0.35})
							local Tween4 = TweenService:Create(v, TweenInfo.new(0.9), {Transparency = 1})
							Tween1:Play()
							Tween3:Play()
							Tween1.Completed:Connect(function()
								Tween2:Play()
							end)
							delay(1.425, function()
								Tween4:Play()
							end)
						end)
					end
				end
				local Tween2 = TweenService:Create(Explosion, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {Transparency = 1})
				wait(0.8)
				Tween2:Play()
			end)
			local Region = Region3.new(Explosion.Position - (Vector3.new(20, 20, 20)/2), Explosion.Position + (Vector3.new(20, 20, 20)/2))
			local Touched = {}
			for i,v in pairs(workspace:FindPartsInRegion3WithWhiteList(Region, {workspace.Players}, 99999)) do 
				if (v.Parent:FindFirstChildOfClass('Humanoid') or v.Parent.Parent:FindFirstChildOfClass('Humanoid') or v.Parent.Parent.Parent:FindFirstChildOfClass('Humanoid')) then
					local Humanoid = (v.Parent:FindFirstChildOfClass('Humanoid') or v.Parent.Parent:FindFirstChildOfClass('Humanoid') or v.Parent.Parent.Parent:FindFirstChildOfClass('Humanoid'))
					local Plr = Players:GetPlayerFromCharacter(Humanoid.Parent)
					if (not table.find(Touched, Humanoid.Parent)) and Plr then
						table.insert(Touched, Humanoid.Parent)
						local MainModule = require(ReplicatedStorage.MainModule)
						local Damage = 150
						task.spawn(function()
							if (MainModule.CheckTeam(Plr, Player, nil) ~= true or  Plr == Player) then
								if (Humanoid.Health - Damage <= 0.5) then
									Humanoid.Health = 0.5
								else 
									Humanoid.Health -= Damage
								end
								ReplicatedStorage.MainRemotes.MainRemoteEvent:FireClient(Plr, 'ShotFrom', Player.Character.LowerTorso.Position)
							end
						end)
					end
				end
			end
			ReplicatedStorage.MainRemotes.MainRemoteEvent:FireAllClients('ExplodeRadius', Explosion.Position, 25)

			for i,v in pairs(workspace:FindPartsInRegion3WithWhiteList(Region, {workspace.MAP.Map}, 15)) do 
				if v:IsDescendantOf(workspace) then
					local Destroy = true
					local MaxVolume = _G.PlayerData.Map.MaxSize.X * _G.PlayerData.Map.MaxSize.Y * _G.PlayerData.Map.MaxSize.Z 
					local Volume = v.Size.X * v.Size.Y * v.Size.Z
					if v.Parent.Name == 'Door' then
						Destroy = false
					end
					if v.Parent.Parent.Name == 'Door' then
						Destroy = false
					end
					if v.Parent.Name == 'Mailbox' then
						Destroy = false
					end
					if not table.find(_G.PlayerData.Map.Destroyable, v.Material) then
						Destroy = false
					end
					pcall(function()
						if Volume > MaxVolume then
							Destroy = false
						end
					end)
					if v:IsDescendantOf(workspace.MAP.Indestructible) then
						Destroy = false
					end
					if Destroy ~= false then
						ServerStorage.Storage.Misc.Server.BindableEvents.TempRemove:Fire(v, v.Parent)
					end
				end
			end

			Debris:AddItem(Explosion, 5)
		end)
	end)
end)

Bindables.Creeper.Event:Connect(function(Player, Position, Color)
	pcall(function()
		task.spawn(function()
			local Explosion

			if not Color then
				Explosion = ServerStorage.Storage.Misc.RPG.exprosion:Clone()
			else
				Explosion = ServerStorage.Storage.Misc.RPG[Color]:Clone()
			end

			Explosion.Position = Position
			for i,v in pairs(Explosion:GetChildren()) do
				if v:IsA('Part') then
					local RandomOffsets = {
						[3] = {
							[1] = CFrame.new(0, 0, 0, 0.291951358, -0.454637647, 0.841468394, 0.837198734, -0.303921342, -0.454675913, 0.462452948, 0.837219477, 0.291891754),
							[2] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
							[3] = CFrame.new(0, 0, 0, 0.980090559, 0.139680177, 0.141109571, -0.159390777, 0.977284014, 0.139680177, -0.118393585, -0.159390777, 0.980090559),
							[4] = CFrame.new(0, 0, 0, 0.173127294, 0.378437281, 0.909292102, -0.722461104, -0.578677535, 0.378394246, 0.669385433, -0.722438574, 0.17322135),
							[5] = CFrame.new(0, 0, 0, 0.427273333, 0.494663626, 0.756799459, -0.869062901, -0.00613296032, 0.494663626, 0.249333531, -0.869062901, 0.427273333)
						},
						[4] = {
							[1] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
							[2] = CFrame.new(0, 0, 0, 0.291951358, 0.454619884, -0.841477931, -0.0720763057, 0.887764454, 0.454619884, 0.953713477, -0.0720763057, 0.291951358),
							[3] = CFrame.new(0, 0, 0, 0.17322135, -0.378349423, -0.909310758, 0.0343255848, 0.925026178, -0.378349423, 0.98428458, 0.0343255848, 0.17322135),
							[4] = CFrame.new(0, 0, 0, 0.980090559, -0.13969931, -0.141090572, 0.11998871, 0.982897162, -0.13969931, 0.158193409, 0.11998871, 0.980090559),
							[5] = CFrame.new(0, 0, 0, 0.427273333, -0.494724542, -0.756759584, 0.120325297, 0.860679626, -0.494724542, 0.896079957, 0.120325297, 0.427273333)
						},
						[5] = {
							[1] = CFrame.new(0, 0, 0, 0.291951358, 0.454619884, -0.841477931, -0.0720763057, 0.887764454, 0.454619884, 0.953713477, -0.0720763057, 0.291951358),
							[2] = CFrame.new(0, 0, 0, 0.17322135, -0.378349423, -0.909310758, 0.0343255848, 0.925026178, -0.378349423, 0.98428458, 0.0343255848, 0.17322135),
							[3] = CFrame.new(0, 0, 0, 0.980090559, -0.13969931, -0.141090572, 0.11998871, 0.982897162, -0.13969931, 0.158193409, 0.11998871, 0.980090559),
							[4] = CFrame.new(0, 0, 0, 0.427273333, 0.494663626, 0.756799459, -0.869062901, -0.00613296032, 0.494663626, 0.249333531, -0.869062901, 0.427273333)
						}
					}
					v.CFrame = Explosion.CFrame * RandomOffsets[i][math.random(1, #RandomOffsets[i])]
				end
			end
			Explosion.Parent = workspace.Ignored
			task.spawn(function()
				if Color then
					local Tween1 = TweenService:Create(Explosion, TweenInfo.new(5, Enum.EasingStyle.Circular), {Size = Vector3.new(27.5, 27.5, 27.5)})
					Tween1:Play()
				else
					local Tween1 = TweenService:Create(Explosion.Mesh, TweenInfo.new(5, Enum.EasingStyle.Circular), {Scale = Vector3.new(27.5, 27.5, 27.5)})
					Tween1:Play()
				end
				for i,v in pairs(Explosion:GetChildren()) do
					if v:FindFirstChild('Mesh') then
						task.spawn(function()
							local Tween1 = TweenService:Create(v.Mesh, TweenInfo.new(0.1125, Enum.EasingStyle.Circular), {Scale = Vector3.new(12.5, 12.5, 12.5)})
							local Tween2 = TweenService:Create(v.Mesh, TweenInfo.new(1.5875, Enum.EasingStyle.Circular), {Scale = Vector3.new(13.75, 13.75, 13.75)})
							local Tween3 = TweenService:Create(v, TweenInfo.new(0.165), {Transparency = 0.35})
							local Tween4 = TweenService:Create(v, TweenInfo.new(0.9), {Transparency = 1})
							Tween1:Play()
							Tween3:Play()
							Tween1.Completed:Connect(function()
								Tween2:Play()
							end)
							delay(1.425, function()
								Tween4:Play()
							end)
						end)
					end
				end
				local Tween2 = TweenService:Create(Explosion, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {Transparency = 1})
				wait(0.8)
				Tween2:Play()
			end)
			local Region = Region3.new(Explosion.Position - (Vector3.new(20, 20, 20)/2), Explosion.Position + (Vector3.new(20, 20, 20)/2))
			local Touched = {}
			for i,v in pairs(workspace:FindPartsInRegion3WithWhiteList(Region, {workspace.Players}, 99999)) do 
				if (v.Parent:FindFirstChildOfClass('Humanoid') or v.Parent.Parent:FindFirstChildOfClass('Humanoid') or v.Parent.Parent.Parent:FindFirstChildOfClass('Humanoid')) then
					local Humanoid = (v.Parent:FindFirstChildOfClass('Humanoid') or v.Parent.Parent:FindFirstChildOfClass('Humanoid') or v.Parent.Parent.Parent:FindFirstChildOfClass('Humanoid'))
					local Plr = Players:GetPlayerFromCharacter(Humanoid.Parent)
					if (not table.find(Touched, Humanoid.Parent)) and Plr then
						table.insert(Touched, Humanoid.Parent)
						local MainModule = require(ReplicatedStorage.MainModule)
						local Damage = 150
						task.spawn(function()
							if (MainModule.CheckTeam(Plr, Player, nil) ~= true or  Plr == Player) then
								if (Humanoid.Health - Damage <= 0.5) then
									Humanoid.Health = 0.5
								else 
									Humanoid.Health -= Damage
								end
								ReplicatedStorage.MainRemotes.MainRemoteEvent:FireClient(Plr, 'ShotFrom', Player.Character.LowerTorso.Position)
							end
						end)
					end
				end
			end
			ReplicatedStorage.MainRemotes.MainRemoteEvent:FireAllClients('ExplodeRadius', Explosion.Position, 25)

			for i,v in pairs(workspace:FindPartsInRegion3WithWhiteList(Region, {workspace.MAP.Map}, 15)) do 
				if v:IsDescendantOf(workspace) then
					local Destroy = true
					local MaxVolume = _G.PlayerData.Map.MaxSize.X * _G.PlayerData.Map.MaxSize.Y * _G.PlayerData.Map.MaxSize.Z 
					local Volume = v.Size.X * v.Size.Y * v.Size.Z
					if v.Parent.Name == 'Door' then
						Destroy = false
					end
					if v.Parent.Parent.Name == 'Door' then
						Destroy = false
					end
					if v.Parent.Name == 'Mailbox' then
						Destroy = false
					end
					if not table.find(_G.PlayerData.Map.Destroyable, v.Material) then
						Destroy = false
					end
					pcall(function()
						if Volume > MaxVolume then
							Destroy = false
						end
					end)
					if v:IsDescendantOf(workspace.MAP.Indestructible) then
						Destroy = false
					end
					if Destroy ~= false then
						ServerStorage.Storage.Misc.Server.BindableEvents.TempRemove:Fire(v, v.Parent)
					end
				end
			end

			Debris:AddItem(Explosion, 5)
		end)
	end)
end)

Bindables.MiniGunExplosion.Event:Connect(function(Player, Position, Color)
	pcall(function()
		task.spawn(function()
			local Explosion

			if not Color then
				Explosion = ServerStorage.Storage.Misc.RPG.exprosion:Clone()
			else
				Explosion = ServerStorage.Storage.Misc.RPG[Color]:Clone()
			end

			Explosion.Position = Position
			for i,v in pairs(Explosion:GetChildren()) do
				if v:IsA('Part') then
					local RandomOffsets = {
						[3] = {
							[1] = CFrame.new(0, 0, 0, 0.291951358, -0.454637647, 0.841468394, 0.837198734, -0.303921342, -0.454675913, 0.462452948, 0.837219477, 0.291891754),
							[2] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
							[3] = CFrame.new(0, 0, 0, 0.980090559, 0.139680177, 0.141109571, -0.159390777, 0.977284014, 0.139680177, -0.118393585, -0.159390777, 0.980090559),
							[4] = CFrame.new(0, 0, 0, 0.173127294, 0.378437281, 0.909292102, -0.722461104, -0.578677535, 0.378394246, 0.669385433, -0.722438574, 0.17322135),
							[5] = CFrame.new(0, 0, 0, 0.427273333, 0.494663626, 0.756799459, -0.869062901, -0.00613296032, 0.494663626, 0.249333531, -0.869062901, 0.427273333)
						},
						[4] = {
							[1] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
							[2] = CFrame.new(0, 0, 0, 0.291951358, 0.454619884, -0.841477931, -0.0720763057, 0.887764454, 0.454619884, 0.953713477, -0.0720763057, 0.291951358),
							[3] = CFrame.new(0, 0, 0, 0.17322135, -0.378349423, -0.909310758, 0.0343255848, 0.925026178, -0.378349423, 0.98428458, 0.0343255848, 0.17322135),
							[4] = CFrame.new(0, 0, 0, 0.980090559, -0.13969931, -0.141090572, 0.11998871, 0.982897162, -0.13969931, 0.158193409, 0.11998871, 0.980090559),
							[5] = CFrame.new(0, 0, 0, 0.427273333, -0.494724542, -0.756759584, 0.120325297, 0.860679626, -0.494724542, 0.896079957, 0.120325297, 0.427273333)
						},
						[5] = {
							[1] = CFrame.new(0, 0, 0, 0.291951358, 0.454619884, -0.841477931, -0.0720763057, 0.887764454, 0.454619884, 0.953713477, -0.0720763057, 0.291951358),
							[2] = CFrame.new(0, 0, 0, 0.17322135, -0.378349423, -0.909310758, 0.0343255848, 0.925026178, -0.378349423, 0.98428458, 0.0343255848, 0.17322135),
							[3] = CFrame.new(0, 0, 0, 0.980090559, -0.13969931, -0.141090572, 0.11998871, 0.982897162, -0.13969931, 0.158193409, 0.11998871, 0.980090559),
							[4] = CFrame.new(0, 0, 0, 0.427273333, 0.494663626, 0.756799459, -0.869062901, -0.00613296032, 0.494663626, 0.249333531, -0.869062901, 0.427273333)
						}
					}
					v.CFrame = Explosion.CFrame * RandomOffsets[i][math.random(1, #RandomOffsets[i])]
				end
			end
			Explosion.Parent = workspace.Ignored
			Explosion.Explosion:Play()
			task.spawn(function()
				if Color then
					local Tween1 = TweenService:Create(Explosion, TweenInfo.new(5, Enum.EasingStyle.Circular), {Size = Vector3.new(2, 2, 2)}) -- Adjust the size of the explosion here
					Tween1:Play()
				else
					local Tween1 = TweenService:Create(Explosion.Mesh, TweenInfo.new(5, Enum.EasingStyle.Circular), {Scale = Vector3.new(1.5, 1.5, 1.5)}) -- Adjust the size of the explosion smoke here
					Tween1:Play()
				end
				for i,v in pairs(Explosion:GetChildren()) do
					if v:FindFirstChild('Mesh') then
						task.spawn(function()
							local Tween1 = TweenService:Create(v.Mesh, TweenInfo.new(0.1125, Enum.EasingStyle.Circular), {Scale = Vector3.new(6.25, 6.25, 6.25)}) -- Adjust the size of the smoke here
							local Tween2 = TweenService:Create(v.Mesh, TweenInfo.new(1.5875, Enum.EasingStyle.Circular), {Scale = Vector3.new(7.5, 7.5, 7.5)}) -- Adjust the size of the smoke here
							local Tween3 = TweenService:Create(v, TweenInfo.new(0.165), {Transparency = 0.35})
							local Tween4 = TweenService:Create(v, TweenInfo.new(0.9), {Transparency = 1})
							Tween1:Play()
							Tween3:Play()
							Tween1.Completed:Connect(function()
								Tween2:Play()
							end)
							delay(1.425, function()
								Tween4:Play()
							end)
						end)
					end
				end
				local Tween2 = TweenService:Create(Explosion, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {Transparency = 1})
				wait(0.8)
				Tween2:Play()
			end)
			local Region = Region3.new(Explosion.Position - (Vector3.new(20, 20, 20)/2), Explosion.Position + (Vector3.new(20, 20, 20)/2))
			local Touched = {}
			for i,v in pairs(workspace:FindPartsInRegion3WithWhiteList(Region, {workspace.Players}, 99999)) do 
				if (v.Parent:FindFirstChildOfClass('Humanoid') or v.Parent.Parent:FindFirstChildOfClass('Humanoid') or v.Parent.Parent.Parent:FindFirstChildOfClass('Humanoid')) then
					local Humanoid = (v.Parent:FindFirstChildOfClass('Humanoid') or v.Parent.Parent:FindFirstChildOfClass('Humanoid') or v.Parent.Parent.Parent:FindFirstChildOfClass('Humanoid'))
					local Plr = Players:GetPlayerFromCharacter(Humanoid.Parent)
					if (not table.find(Touched, Humanoid.Parent)) and Plr then
						table.insert(Touched, Humanoid.Parent)
						local MainModule = require(ReplicatedStorage.MainModule)
						local Damage = 150
						task.spawn(function()
							if Plr == Player then
								return
							end

							if (MainModule.CheckTeam(Plr, Player, nil) ~= true) then
								if (Humanoid.Health - Damage <= 0.5) then
									Humanoid.Health = 0.5
								else 
									Humanoid.Health -= Damage
								end
								ReplicatedStorage.MainRemotes.MainRemoteEvent:FireClient(Plr, 'ShotFrom', Player.Character.LowerTorso.Position)
							end
						end)
					end
				end
			end

			ReplicatedStorage.MainRemotes.MainRemoteEvent:FireAllClients('ExplodeRadius', Explosion.Position, 25)
			Debris:AddItem(Explosion, 5)
		end)
	end)
end)
Bindables.TempRemove.Event:Connect(function(Part, P)
	task.spawn(function()
		pcall(function()
			Part.Parent = nil
			wait(50)
			Part.Parent = P
		end)
	end)
end)

local function SendToWebhook(Message:string)
	local Webhook = Webhooks.BanLogs[1]
	local s,e = pcall(function()
		HttpService:PostAsync(Webhook,
			HttpService:JSONEncode({
				['content'] = '',
				['username'] = 'Discord Administration Report',
				['avatar_url'] = Helper.Profile,
				['embeds'] = {{
					['description'] = Message,
					['title'] = 'Discord Administration',
					["color"] = tonumber(0xffffff),
				}};
			}),
			Enum.HttpContentType.ApplicationJson
		)
	end)
	
	return s,e
end

MessagingService:SubscribeAsync('FindServerID', function(Info)
	local Data = Info.Data
	if Data and Data.Target then
		print("sgiamaaa")

		for _, v in pairs(Players:GetPlayers()) do 
			print("skibidi")

			if v.Name:lower() == Data.Target:lower() then
				print("EH")

				if game.JobId ~= Data.JobId then

					local success, errorMsg = pcall(function()
						local PlrWhoRequested = Players:FindFirstChild(Data.Requester)
						if PlrWhoRequested then
							local BanGui = PlrWhoRequested:FindFirstChild("PlayerGui")
								and PlrWhoRequested.PlayerGui:FindFirstChild("ScreenGui")
							if BanGui then
								BanGui.Panel.Actions.FindServerID.ID.Text = tostring(game.JobId)
								print("wozza")

							end
						end
					end)

					local Webhook = Webhooks.FindServerIDLogs[1]
					if Webhook and Webhook ~= "" then
						local payload = {
							['username'] = 'Find Server',
							['avatar_url'] = Helper.Profile,
							embeds = {
								{
									title = ":satellite: Server ID Request Processed",
									description = "A player has successfully located a target server!",
									color = 5814783,
									fields = {
										{
											name = ":bust_in_silhouette: Target Player",
											value = v.Name,
											inline = true
										},
										{
											name = ":globe_with_meridians: Server ID",
											value = game.JobId,
											inline = true
										},
										{
											name = ":busts_in_silhouette: Requester",
											value = Data.Requester,
											inline = true
										},
									},
									footer = {
										text = "Server Finder System | " .. os.date("%Y-%m-%d %H:%M:%S"),
										icon_url = "https://example.com/icon.png"
									},
									timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
								}
							}
						}

						local jsonData = HttpService:JSONEncode(payload)

						local webhookSuccess, webhookError = pcall(function()
							HttpService:PostAsync(Webhook, jsonData, Enum.HttpContentType.ApplicationJson)
						end)
					end
				end
				break
			end
		end
	end
end)

Bindables.Grenade.Event:Connect(function(Handle, Player)
	pcall(function()
		if Player.Character then
			if not Player.Character:FindFirstChildOfClass('Humanoid') then
				return
			end
			local Humanoid = Player.Character:FindFirstChildOfClass('Humanoid')
			local Animation = Instance.new('Animation')
			Animation.AnimationId = 'rbxassetid://127883844957883'
			local Track = Humanoid:LoadAnimation(Animation)
			Track:Play()
			local Mouse = ReplicatedStorage.RemoteFunction.RemoteFunction:InvokeClient(Player, 'MOUSEPOS')
			Handle.CanCollide = true
			Handle.Parent = workspace.Ignored
			local VELOCITY = (Mouse - Handle.Position).Unit * 75
			local X = VELOCITY.X
			local Y = math.abs(VELOCITY.Y)
			if Y >= 10 and Y < 30 then
				Y = Random.new():NextNumber(10, 30) * Random.new():NextNumber(1.5, 2.5)
			elseif Y >= 30 and Y < 60 then
				Y *= 2
			elseif Y >= 60 and Y < 100 then
				Y *= 1.25
			end
			if Y < 25 then
				Y = 25 * Random.new():NextNumber(1.5, 2.5)
			elseif Y > 25 and Y < 50 then
				Y *= Random.new():NextNumber(1.75, 2.5)
			elseif Y > 50 and Y < 75 then
				Y *= Random.new():NextNumber(1.25, 2)
			elseif Y >= 75 then
				Y *= Random.new():NextNumber(1, 1.75)
			end
			Handle.Velocity = Vector3.new(X, Y, VELOCITY.Z)
			task.spawn(function()
				wait(math.round(Y/75))
				local Count = 0
				Handle.BrickColor = BrickColor.new('Bright red')
				while wait(0.3) do 
					if not Handle:IsDescendantOf(workspace) then
						break
					end
					if Handle.BrickColor == BrickColor.new('White') then
						Handle.BrickColor = BrickColor.new('Bright red')
					else 
						Handle.BrickColor = BrickColor.new('White')
					end
					Count += 1 
					if Count == 6 then
						Bindables.Explosion:Fire(Player, Handle.Position)
						Handle:Destroy()
						break
					end
				end
			end)
		end
	end)
end)

Bindables.FlashbangExplosion.Event:Connect(function(Player, Position)
	pcall(function()
		local Part = ServerStorage.Storage.Misc.RPG.Flashbang.Part:Clone()
		Part.Position = Position 
		Part.Parent = workspace
		Part.Sound:Play()
		Part.PointLight.Enabled = true
		local Tween = TweenService:Create(Part.PointLight, TweenInfo.new(0.3, Enum.EasingStyle.Bounce), {Range = 20, Brightness = 10})
		Tween:Play()
		local Region = Region3.new(Part.Position - (Vector3.new(20, 20, 20)/2), Part.Position + (Vector3.new(20, 20, 20)/2))
		local Touched = {}
		for i,v in pairs(workspace:FindPartsInRegion3WithWhiteList(Region, {workspace.Players}, 99999)) do 
			if (v.Parent:FindFirstChildOfClass('Humanoid') or v.Parent.Parent:FindFirstChildOfClass('Humanoid') or v.Parent.Parent.Parent:FindFirstChildOfClass('Humanoid')) then
				local Humanoid = (v.Parent:FindFirstChildOfClass('Humanoid') or v.Parent.Parent:FindFirstChildOfClass('Humanoid') or v.Parent.Parent.Parent:FindFirstChildOfClass('Humanoid'))
				local Plr = Players:GetPlayerFromCharacter(Humanoid.Parent)
				local MainModule = require(ReplicatedStorage.MainModule)
				if (not table.find(Touched, Humanoid.Parent)) and Plr then
					table.insert(Touched, Humanoid.Parent)
					ReplicatedStorage.MainRemotes.MainRemoteEvent:FireClient(Plr, 'FLASHBANG')
				end
			end
		end
		Debris:AddItem(Part, 0.5)
	end)
end)

Bindables.Flashbang.Event:Connect(function(Handle, Player)
	pcall(function()
		if Player.Character then
			if not Player.Character:FindFirstChildOfClass('Humanoid') then
				return
			end
			local Humanoid = Player.Character:FindFirstChildOfClass('Humanoid')
			local Animation = Instance.new('Animation')
			Animation.AnimationId = 'rbxassetid://92245387213225'
			local Track = Humanoid:LoadAnimation(Animation)
			Track:Play()
			local Mouse = ReplicatedStorage.RemoteFunction.RemoteFunction:InvokeClient(Player, 'MOUSEPOS')
			Handle.CanCollide = true
			Handle.Parent = workspace.Ignored
			local VELOCITY = (Mouse - Handle.Position).Unit * 75
			local X = VELOCITY.X
			local Y = math.abs(VELOCITY.Y)
			if Y >= 10 and Y < 30 then
				Y = Random.new():NextNumber(10, 30) * Random.new():NextNumber(1.5, 2.5)
			elseif Y >= 30 and Y < 60 then
				Y *= 2
			elseif Y >= 60 and Y < 100 then
				Y *= 1.25
			end
			if Y < 25 then
				Y = 25 * Random.new():NextNumber(1.5, 2.5)
			elseif Y > 25 and Y < 50 then
				Y *= Random.new():NextNumber(1.75, 2.5)
			elseif Y > 50 and Y < 75 then
				Y *= Random.new():NextNumber(1.25, 2)
			elseif Y >= 75 then
				Y *= Random.new():NextNumber(1, 1.75)
			end
			Handle.Velocity = Vector3.new(X, Y, VELOCITY.Z)
			task.spawn(function()
				wait(math.round(Y/75))
				Bindables.FlashbangExplosion:Fire(Player, Handle.Position)
				Handle:Destroy()
			end)
		end
	end)
end)

Bindables.BoneBreak.Event:Connect(function(HitPart, Character, Type)
	pcall(function()
		task.spawn(function()
			if not Character.BodyEffects.BreakingParts:FindFirstChild(Type) then
				local BoneBreak = Instance.new('Sound', HitPart)
				BoneBreak.Name = 'BoneBreak'
				BoneBreak.SoundId = 'rbxassetid://314390675'
				BoneBreak.Volume = 0.5
				BoneBreak.RollOffMode = Enum.RollOffMode.Inverse
				BoneBreak:Play()
				BoneBreak.Ended:Connect(function()
					BoneBreak:Destroy()
				end)
				local Folder = Instance.new('Folder', Character.BodyEffects.BreakingParts)
				Folder.Name = Type
			    Debris:AddItem(Folder, 14)
			end
		end)
	end)
end)
Bindables.GrenadeLauncher.Event:Connect(function(Player, Position, Mouse, Duration)
	pcall(function()
		task.spawn(function()
			local Grenade = game:GetService('ServerStorage').Storage.Misc.RPG.GrenadeLauncherAmmo:Clone()
			Grenade.Main.BodyForce.Force = Vector3.new(0, Random.new():NextNumber(50, 55), 0)
			Grenade.Parent = workspace.Ignored
			Grenade.PrimaryPart.CFrame = CFrame.lookAt(Position, Mouse) * CFrame.Angles(0, math.rad(90), 0)
			Grenade.PrimaryPart.Grenadelauncherswoosh:Play()
			local VELOCITY = (Mouse - Position).Unit * 85
			Grenade.PrimaryPart.Velocity = VELOCITY
			local Tween = TweenService:Create(Grenade.Main.BodyForce, TweenInfo.new(1.5), {Force = Vector3.new(0, 0, 0)})
			Tween:Play()	
			delay(Duration, function()
				if Grenade then
					game:GetService('ServerStorage').Storage.Misc.Server.BindableEvents.Explosion:Fire(Player, Grenade.PrimaryPart.Position)
					Grenade:Destroy()
				end
			end)
		end)
	end)
end)

Bindables.Bag.Event:Connect(function(Character)
	pcall(function()
		task.spawn(function()
			if not Character:FindFirstChild('Christmas_Sock') then
				local Bag = ServerStorage.Storage.Misc.Bag['Christmas_Sock']:Clone()
				Bag.Size = Character.HumanoidRootPart.Size * Vector3.new(4.0457048416137695, 2.9456400871276855, 3.3482799530029297)
				local Weld = Instance.new('Weld', Bag)
				Weld.C0 = CFrame.new(-9.72747803e-05, 1.49999332, 0.000152111053, -1, 0, 0, 0, -1, 0, 0, 0, 1)
				Weld.Part0 = Character.LowerTorso
				Weld.Part1 = Bag 
				Bag.Parent = Character 
				Bag.HIT:Play()
				Debris:AddItem(Bag, 60)
			end
		end)
	end)
end)

Bindables.SpawnCash.OnInvoke = function(Player, Mode, Position, Offset, Amount, Velocity)
	if Player ~= nil then
		if not Player:FindFirstChild('LOAD_SAVE_DATA') then
			return
		end
	end
	if tonumber(Amount) == nil then
		return
	end
	local Taxed = nil
	if Player then
		if Mode ~= 'Free' then
			if _G.PlayerData.Players[Player].Stats.Permissions.Rank < 251 then
				Taxed = math.round(0.7 * Amount)
			else
				Taxed = Amount
			end
			if Player.DataFolder.Currency.Value < Amount then
				return
			end
			Player.DataFolder.Currency.Value -= Amount
		end
	end
	local MoneyDrop = ServerStorage.Storage.Misc.Money.MoneyDrop:Clone()
	if Taxed ~= nil then
		MoneyDrop.BillboardGui.TextLabel.Text = '$'..MainModule.AddComma(Taxed)
	else 
		MoneyDrop.BillboardGui.TextLabel.Text = '$'..MainModule.AddComma(Amount)
	end
	MoneyDrop.CFrame = Position + Offset
	MoneyDrop.Parent = workspace.Ignored.Drop
	if Velocity then
		MoneyDrop.Velocity = Velocity
	end
	local Clicked = false
	local Connection
	Connection = MoneyDrop.ClickDetector.MouseClick:Connect(function(Plr)
		if not Plr:FindFirstChild('LOAD_SAVE_DATA') then
			return
		end
		if Plr:DistanceFromCharacter(MoneyDrop.Position) <= MoneyDrop.ClickDetector.MaxActivationDistance then
			if _G.PlayerData.Players[Plr].Debounces.Currency.Pickup ~= false then
				return
			end
			if Clicked == false then
				task.spawn(function()
					pcall(function()
						_G.PlayerData.Players[Plr].Debounces.Currency.Pickup = true
						task.wait(0.5)
						_G.PlayerData.Players[Plr].Debounces.Currency.Pickup = false
					end)
				end)
				pcall(function()
					if Taxed ~= nil then
						Plr.DataFolder.Currency.Value += Taxed
					else 
						Plr.DataFolder.Currency.Value += Amount
					end
				end)
				MoneyDrop:Destroy()
				Clicked = true
				Connection:Disconnect()
			end
		end
	end)
	return MoneyDrop
end

Bindables.ATM.Event:Connect(function(Player, Humanoid, Damage, Melee)
	if not Player:FindFirstChild('LOAD_SAVE_DATA') then
		return
	end
	if Player.DataFolder.Officer.Value ~= 0 then
		return
	end
	if Melee then
		if Melee == true then
			Humanoid.Parent.Head.Punch:Play()
		end
	end
	if Humanoid.Health > 0 then
		if (Humanoid.Health - Damage) > 0 then 
			if not Melee then
				Player.DataFolder.Information.Wanted.Value += 1
			else 
				if Melee == true then
					Player.DataFolder.Information.Wanted.Value += 5
				end
			end
			Humanoid.Health -= Damage
		else 
			if not Melee then
				Player.DataFolder.Information.Wanted.Value += 1
			else 
				if Melee == true then
					Player.DataFolder.Information.Wanted.Value += 5
				end
			end
			task.spawn(function()
				wait(300)
				Humanoid.Health = Humanoid.MaxHealth
				Humanoid.Parent.Open.Size = Vector3.new(2.6, 0.5, 0.1)
			end)
			if (Humanoid.Parent.Head.Position - workspace.Ignored.Siren.Radius.Position).magnitude < 20 then
				task.spawn(function()
					ServerStorage.Storage.Misc.Server.BindableEvents.BankAlarm:Fire()
				end)
			end
			Humanoid.Health = 0
			Humanoid.Parent.Head.Crash:Play()
			Humanoid.Parent.Open.Size = Vector3.new(2.6, 0.5, 1.3)
			for i = 1,4 do
				local Velocity 
				local Number = math.random(1, 2)
				if Number == 1 then 
					Velocity = Vector3.new(0, -3.27, 0)
				else 
					Velocity = Vector3.new(0, -4.0875, 0)
				end
				ServerStorage.Storage.Misc.Server.BindableEvents.SpawnCash:Invoke(nil, nil, Humanoid.Parent.Head.CFrame, Vector3.new(Random.new():NextNumber(0, 0.5), Random.new():NextNumber(1, 3), Random.new():NextNumber(0.2, 1)), math.random(20, 10000), Velocity)
			end
		end
	end
end)

Helper.DoorsInit()
Helper.ShopInit()

game:GetService("StarterPlayer").UserEmotesEnabled = true
