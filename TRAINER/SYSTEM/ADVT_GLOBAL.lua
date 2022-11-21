-- ADVT_GLOBAL.LUA
-- AUTHOR	: ALTAMURENZA


--[[
	-------------------
	# SHARED VARIABLE #
	-------------------
]]

shared.SMAE = {}

shared.SMAE.X = nil
shared.SMAE.Y = nil
shared.SMAE.Z = nil
shared.SMAE.Player = {"Player", {"/Global/Player", "Act/Anim/Player.act"}}
shared.SMAE.Movement = {"Player", false, 0, GetTimer(), GetTimer()}
shared.SMAE.Idle = {{}, false}

shared.SMAE.Setup = {}
shared.SMAE.Option = 1

shared.SMAE.GUI = false
shared.SMAE.SubGUI = false

shared.SMAE.Button = {}
shared.SMAE.Button.Hold = {}
shared.SMAE.Button.Scroll = GetTimer()

shared.SMAE.Strafe = {}
shared.SMAE.Strafe.Bind = {}
shared.SMAE.Strafe.Other = {}
shared.SMAE.Strafe.Block = {}

shared.SMAE.AudioVol = 1.1

shared.SMAE.Settings = {}

shared.SMAE.Settings.Immortal = false
shared.SMAE.Settings.Transparent = false
shared.SMAE.Settings.Instant = false
shared.SMAE.Settings.Innocent = false
shared.SMAE.Settings.Shot = false
shared.SMAE.Settings.Ammo = false
shared.SMAE.Settings.Shop = false

shared.SMAE.Settings.Mute = false
shared.SMAE.Settings.Mayhem = {false, nil, {}}
shared.SMAE.Settings.Harmony = false
shared.SMAE.Settings.Lonely = false

shared.SMAE.Settings.Art = false
shared.SMAE.Settings.Math = false
shared.SMAE.Settings.Timer = false
shared.SMAE.Settings.Cutscene = false

shared.SMAE.Settings.GameAudio = true
shared.SMAE.Settings.CS_Music = false

shared.SMAE.Settings.Trouble = true
shared.SMAE.Settings.Health = true
shared.SMAE.Settings.Map = true
shared.SMAE.Settings.Lap = false

shared.SMAE.Settings.Cinematic = false
shared.SMAE.Settings.Fire = false
shared.SMAE.Settings.Muddy = false

shared.SMAE.Settings.FPS = false


--[[
	--------------------
	# SHORTEN MATH LIB #
	--------------------
]]

sin = math.sin
asin = math.asin
cos = math.cos
acos = math.acos
tan = math.tan
atan = math.atan
atan2 = math.atan2
floor = math.floor
ceil = math.ceil
abs = math.abs
sqrt = math.sqrt
randomseed = math.randomseed
random = math.random
deg = math.deg
pow = math.pow
rad = math.rad
exp = math.exp


--[[
	---------------
	# CONTROL LIB #
	---------------
]]

CTRL = {
	N = function(ID, C)
		if _G["IsButton"..(ID == 9 and "" or "Being").."Pressed"](ID, C) then
			shared.SMAE.Button.Scroll = GetTimer()
			
			return true
		end
		return false
	end,
	
	F = function(ID, C)
		if shared.SMAE.Button.Hold[ID] then
			if shared.SMAE.Button.Scroll + 800 < GetTimer() then
				return true
			end
		end
		if IsButtonBeingReleased(ID, C) then
			shared.SMAE.Button.Scroll = GetTimer()
		end
		
		return false
	end,
	
	W = function(ID, C)
		while not IsButtonBeingReleased(ID, C) do
			Wait(0)
		end
	end
}


--[[
	----------------
	# FUNCTION LIB #
	----------------
]]

F = type(F) ~= "table" and {
	
	-- camera
	
	CFOLLOW = function(PED)
		CameraFollowPed(PED)
		
		if PED ~= gPlayer then
			SoundSetAudioFocusCamera()
		else 
			SoundSetAudioFocusPlayer()
		end
	end,
	
	CSPOT = function(OBJECT, FUNC)
		local DIST, CP, CH, MODE, ROT = 5, 0, 0, {MOVE = {1, "VERTICAL"}, HEIGHT = {1, "FIX", 0}}, {CURRENT = 0, LAST = 0}
		local INIT, CM, PP = false, {X = 0, Y = 0, Z = 0, LX = 0, LY = 0, LZ = 0}, {PlayerGetPosXYZ()}
		
		if not DIR_2D then
			DIR_2D, DIR_3D = function(H, D)
				return -math.sin(H) * D, math.cos(H) * D
			end, function(P, H, D)
				return math.cos(P) * -math.sin(H) * D, math.cos(P) * math.cos(H) * D, math.sin(P) * D
			end
		end
		
		TutorialShowMessage("M: "..MODE.MOVE[2].."\nH: "..MODE.HEIGHT[2], -1, true)
		shared.gActiveControl = false
		
		while not IsButtonBeingPressed(2, 0) do
			Wait(0)
			
			if PedIsValid(gPlayer) then
				if not PedIsPlaying(gPlayer, "/Global/1_06/HoboFly", true) then
					PedSetActionNode(gPlayer, "/Global/1_06/HoboFly", "Act/Conv/1_06.act")
				end
				
				PedSetInvulnerable(gPlayer, true)
				PlayerSetPosSimple(PP[1], PP[2], PP[3])
				PedSetWeapon(gPlayer, -1, 0)
				
				if IsButtonBeingPressed(15, 0) then
					MODE.MOVE[1] = MODE.MOVE[1] + 1 > ((type(OBJECT) == "table" and OBJECT.TYPE == "PROJ") and 3 or 4) and 1 or MODE.MOVE[1] + 1
					MODE.MOVE[2] = ({[1] = "VERTICAL", [2] = "HORIZONTAL", [3] = (type(OBJECT) == "table" and OBJECT.TYPE == "PROJ") and "SHOOT" or "DISTANCE", [4] = "ROTATION"})[MODE.MOVE[1]]
					
					TutorialShowMessage("M: "..MODE.MOVE[2].."\nH: "..MODE.HEIGHT[2], -1, true)
				end
				
				if IsButtonBeingPressed(11, 0) then
					MODE.HEIGHT[1] = MODE.HEIGHT[1] + 1 > 3 and 1 or MODE.HEIGHT[1] + 1
					MODE.HEIGHT[2] = ({[1] = "FIX", [2] = "UP", [3] = "DOWN"})[MODE.HEIGHT[1]]
					MODE.HEIGHT[3] = ({[1] = 0, [2] = 0.1, [3] = -0.1})[MODE.HEIGHT[1]]
					
					TutorialShowMessage("M: "..MODE.MOVE[2].."\nH: "..MODE.HEIGHT[2], -1, true)
				end
				
				DIST = DIST + (MODE.MOVE[2] == "DISTANCE" and (GetStickValue(8, 0) - GetStickValue(6, 0)) or 0)
				
				CP = CP + (MODE.MOVE[2] == "HORIZONTAL" and (GetStickValue(8, 0) - GetStickValue(6, 0)) or 0) / 20
				CH = CH + (MODE.MOVE[2] == "VERTICAL" and (GetStickValue(8, 0) - GetStickValue(6, 0)) or 0) / 20
				
				local PX, PY, PZ = PlayerGetPosXYZ()
				local X1, Y1 = DIR_2D(CH, GetStickValue(17, 0)/10)
				local X2, Y2 = DIR_2D(CH + math.pi/2, GetStickValue(16, 0)/10)
				
				local CX, CY, CZ = DIR_3D(CP, CH, -DIST)
				
				if not INIT then
					CM.X, CM.Y, CM.Z, INIT = PX + CX, PY + CY, PZ + CZ + 1.5, true
				else
					CM.X, CM.Y, CM.Z = CM.X + X1 + X2, CM.Y + Y1 + Y2, CM.Z + (MODE.HEIGHT[3])
				end
				
				local CAMX, CAMY, CAMZ = CM.X or PX + CX, CM.Y or PY + CY, CM.Z or PZ + CZ + 1.5
				local LOOKX, LOOKY, LOOKZ = CM.X - CX, CM.Y - CY, CM.Z - CZ
				
				if type(OBJECT) == "table" then
					if OBJECT.TYPE == "PROP" then
						ROT.CURRENT = ROT.CURRENT - (MODE.MOVE[2] == "ROTATION" and (GetStickValue(8, 0) - GetStickValue(6, 0)) or 0) * 5
						ROT.CURRENT = ROT.CURRENT > 360 and 0 or (ROT.CURRENT < 0 and 360 or ROT.CURRENT)
						
						if CM.LX ~= LOOKX or CM.LY ~= LOOKY or CM.LZ ~= LOOKZ or ROT.LAST ~= ROT.CURRENT then
							if OBJECT[1] then
								DeletePersistentEntity(OBJECT[1], OBJECT[2])
							end
							
							OBJECT[1], OBJECT[2] = CreatePersistentEntity(OBJECT[3], LOOKX, LOOKY, LOOKZ, ROT.CURRENT, AreaGetVisible())
							CM.LX, CM.LY, CM.LZ, ROT.LAST = LOOKX, LOOKY, LOOKZ, ROT.CURRENT
						end
					end
					
					if OBJECT.TYPE == "PROJ" and MODE.MOVE[2] == "SHOOT" then
						local X, Y, Z = DIR_3D(CP, CH, 0.5)
						
						if (CTRL.F(6, 0) or CTRL.F(8, 0)) and OBJECT[3] < GetTimer() then
							CreateProjectile(OBJECT[1], CM.X, CM.Y, CM.Z, CTRL.F(6, 0) and X or X / 20, CTRL.F(6, 0) and Y or Y / 20, Z, OBJECT[2])
							OBJECT[3] = GetTimer() + 100
						end
						
						if (CTRL.N(6, 0) or CTRL.N(8, 0)) then
							CreateProjectile(OBJECT[1], CM.X, CM.Y, CM.Z, CTRL.N(6, 0) and X or X / 20, CTRL.N(6, 0) and Y or Y / 20, Z, OBJECT[2])
						end
					end
				end
				
				CameraSetXYZ(CAMX, CAMY, CAMZ, LOOKX, LOOKY, LOOKZ)
			else
				break
			end
		end
		
		if type(FUNC) == "function" then
			if type(OBJECT) == "table" and OBJECT.TYPE == "PROP" then
				if not SPAWNED_OBJECT then
					SPAWNED_OBJECT = {}
				end
				
				table.insert(SPAWNED_OBJECT, {OBJECT[3], OBJECT[1], OBJECT[2], CM.LX, CM.LY, CM.LZ, ROT.CURRENT, AreaGetVisible()})
			end
			
			FUNC(CM.LX, CM.LY, CM.LZ, (type(OBJECT) == "table" and OBJECT.TYPE == "PROP") and ROT.CURRENT or nil)
		end
		
		PlayerStopAllActionControllers()
		PedSetInvulnerable(gPlayer, false)
		
		TutorialShowMessage("CONFIRMED!", 2500, true)
		CameraReturnToPlayer()
		
		shared.gActiveControl = true
	end,
	
	-- pedestrian
	
	PGID = function(PED)
		for ID = 0, 258 do
			if PedIsModel(PED, ID) then
				return ID
			end
		end
		
		return random(0, 258)
	end,
	
	PTREE = function(PED)
		local DATA = {
			"Player",
			"AN_DOG",
			"Authority",
			"B_Striker_A",
			"1_03_Davis",
			"BOSS_Darby",
			"BOSS_Russell",
			"Crazy_Basic",
			"CV_Drunk",
			"CV_Female_A",
			"CV_Male_A",
			"CV_OLD",
			"DO_Edgar",
			"DO_Grappler_A",
			"DO_Melee_A",
			"DO_Striker_A",
			"G_Grappler_A",
			"G_Johnny",
			"G_Melee_A",
			"G_Ranged_A",
			"G_Striker_A",
			"Norton",
			"GS_Fat_A",
			"GS_Female_A",
			"GS_Male_A",
			"Hobo_Blocker",
			"J_Damon",
			"J_Grappler_A",
			"J_Mascot",
			"J_Melee_A",
			"J_Striker_A",
			"J_Ted",
			"LE_Orderly_A",
			"N_Earnest",
			"N_Ranged_A",
			"N_Striker_A",
			"N_Striker_B",
			"Nemesis",
			"P_Bif",
			"P_Grappler_A",
			"P_Striker_A",
			"P_Striker_B",
			"2_07_Gord",
			"PunchBagBS",
			"Russell_102",
			"TE_Female_A",
			"TE_Secretary",
			"TO_Siamese",
			"WrestlingACT",
			"BoxingPlayer",
		}
		
		for I, V in ipairs(DATA) do
			if PedIsPlaying(PED, "/Global/"..V, true) then
				return V == "Norton" and {"/Global/Norton", "Act/Anim/3_05_Norton.act"} or {"/Global/"..V, "Act/Anim/"..V..".act"}
			end
		end
		
		local ID = random(1, table.getn(DATA))
		return DATA[ID] == "Norton" and {"/Global/Norton", "Act/Anim/3_05_Norton.act"} or {"/Global/"..DATA[ID], "Act/Anim/"..DATA[ID]..".act"}
	end,
	
	PALLY = function(PED, TARGET, CHAIN)
		if PedIsValid(PED) then
			
			if not CHAIN then
				PedRecruitAlly(PED, TARGET)
			else
				local LEADER = PED
				
				while PedHasAllyFollower(LEADER) do
					LEADER = PedGetAllyFollower(LEADER)
				end
				PedRecruitAlly(LEADER, TARGET)
			end
		end
	end,
	
	PSORT = function(M, IP, R)
		-- M	= measurement, true = by distance, false = by health
		-- IP	= include player
		-- R	= maximum range (optional)
		
		local T = {ORDER = {}, MAXN = -1}
		local X, Y, Z = PlayerGetPosXYZ()
		
		if M and IP then
			T.ORDER[0], T.MAXN = gPlayer, 0
		end
		
		for _, PED in {PedFindInAreaXYZ(0, 0, 0, 99999)} do
			if PedIsValid(PED) and ((not M and IP) and true or PED ~= gPlayer) and PedGetHealth(PED) > 0 then
				local PX, PY, PZ = PedGetPosXYZ(PED)
				local DIST = sqrt((X - PX)*(X - PX) + (Y - PY)*(Y - PY) + (Z - PZ)*(Z - PZ))
				
				if type(R) == "number" then
					if DIST < R then
						local VAL = floor(M and DIST or PedGetHealth(PED))
						
						T.ORDER[T.ORDER[VAL] and VAL + 1 or VAL], T.MAXN = PED, VAL > T.MAXN and VAL or T.MAXN
					end
				else
					local VAL = floor(M and DIST or PedGetHealth(PED))
					
					T.ORDER[T.ORDER[VAL] and VAL + 1 or VAL], T.MAXN = PED, VAL > T.MAXN and VAL or T.MAXN
				end
			end
		end
		
		return T
	end,
	
	PCHOOSE = function(IP)
		local TEST_POP = F.PSORT(true)
		if TEST_POP.MAXN == -1 then
			TutorialShowMessage("THERE'S NO ONE HERE!", 2500, true)
			return nil
		end
		
		local X, Y, Z = PlayerGetPosXYZ()
		local PED, COUNT = nil, IP and -1 or 0
		
		while true do
			Wait(0)
			
			PlayerLockButtonInputsExcept(true, 18, 19)
			
			PedSetInvulnerable(gPlayer, true)
			PlayerSetPosSimple(X, Y, Z)
			
			local RESHUFFLE = function(NUM)
				local PS = F.PSORT(true, IP)
				
				COUNT = (not PED or not PedIsValid(PED)) and 0 or COUNT + NUM
				while not PS.ORDER[COUNT] do
					COUNT = COUNT + NUM < 0 and PS.MAXN or (COUNT + NUM > PS.MAXN and 0 or COUNT + NUM)
				end
				
				F.CFOLLOW(PS.ORDER[COUNT])
				return PS.ORDER[COUNT]
			end
			
			PED = (type(PED) == "nil" or not PedIsValid(PED) or CTRL.N(6, 0) or CTRL.N(12, 0) or CTRL.F(6, 0) or CTRL.F(12, 0)) and RESHUFFLE(1) or ((CTRL.N(8, 0) or CTRL.F(8, 0)) and RESHUFFLE(-1) or PED)
			if CTRL.N(11, 0) or CTRL.N(2, 0) then
				break
			end
			
			MinigameSetAnnouncement("- "..STR.PEDNAME(PedGetName(PED), false).." -\n[Weapon] CONFIRM", true)
		end
		
		if CTRL.N(11, 0) then
			CTRL.W(11, 0)
		end
		
		PedSetInvulnerable(gPlayer, false)
		PlayerStopAllActionControllers()
		
		PlayerLockButtonInputsExcept(false)
		MinigameSetAnnouncement("", true)
		
		F.CFOLLOW(gPlayer)
		
		return CTRL.N(2, 0) and nil or PED
	end,
	
	SWAP = function(PLAYER, MODEL, STYLE)
		if type(PLAYER) == "boolean" then
			
			local PED = PLAYER and gPlayer or F.PCHOOSE()
			if PedIsValid(PED) then
				PedSwapModel(PED, MODEL)
				
				if PED == gPlayer then
					if STYLE[1] == "/Global/CV_Male_A" then
						PedSetActionTree(PED, "/Global/GS_Male_A", "Act/Anim/GS_Male_A.act")
					elseif STYLE[1] == "/Global/J_Damon" then
						PedSetActionTree(PED, "/Global/J_Striker_A", "Act/Anim/J_Striker_A.act")
					elseif STYLE[1] == "/Global/G_Johnny" then
						PedSetActionTree(PED, "/Global/G_Striker_A", "Act/Anim/G_Striker_A.act")
					else
						if STYLE[1] == "/Global/Norton" then
							while not PedHasWeapon(PED, 324) do
								PedSetWeapon(PED, 324, 1); Wait(0)
							end
						end
						
						PedSetActionTree(PED, unpack(STYLE))
					end
					
					PedSetAITree(PED, "/Global/PlayerAI", "Act/PlayerAI.act")
					PedSetInfiniteSprint(PED, true)
					
					shared.SMAE.Player[1], shared.SMAE.Player[2] = MODEL, STYLE[1] == "/Global/CV_Male_A" and {"/Global/GS_Male_A", "Act/Anim/GS_Male_A.act"} or STYLE
					
					for _, TABLE in ipairs(shared.SMAE.Setup[2].Data["'OPEN BASIC'"].Data) do
						if string.find(STYLE[1], TABLE.Code, 1) then
							shared.SMAE.Movement[1] = TABLE.Code
							
							break
						end
					end
					
					shared.SMAE.Movement[1] = ({["BoxingPlayer"] = "GS_Male_A", ["G_Johnny"] = "G_Melee_A", ["CV_Male_A"] = "GS_Male_A", ["J_Damon"] = "J_Striker_A"})[shared.SMAE.Movement[1]] or shared.SMAE.Movement[1]
				else
					PedSetActionTree(PED, unpack(STYLE))
				end
			end
		end
	end,
	
	STYLE = function(PLAYER, CODE)
		if type(PLAYER) == "boolean" then
			
			local PED = PLAYER and gPlayer or F.PCHOOSE()
			if PedIsValid(PED) then
				if CODE == "3_05_Norton" then
					while not PedHasWeapon(PED, 324) do
						PedSetWeapon(PED, 324, 1); Wait(0)
					end
					
					PedSetActionTree(PED, "/Global/Norton", "Act/Anim/"..CODE..".act")
				elseif CODE == "CV_Male_A" and PED == gPlayer then
					PedSetActionTree(PED, "/Global/GS_Male_A", "Act/Anim/GS_Male_A.act")
				elseif CODE == "J_Damon" and PED == gPlayer then
					PedSetActionTree(PED, "/Global/J_Striker_A", "Act/Anim/J_Striker_A.act")
				elseif CODE == "G_Johnny" and PED == gPlayer then
					PedSetActionTree(PED, "/Global/G_Striker_A", "Act/Anim/G_Striker_A.act")
				else
					PedSetActionTree(PED, "/Global/"..CODE, "Act/Anim/"..CODE..".act")
				end
				
				PedSetAITree(PED, "/Global/"..(PED == gPlayer and "PlayerAI" or "AI"), "Act/"..(PED == gPlayer and "PlayerAI" or "AI/AI")..".act")
				
				if PED == gPlayer then
					PedSetInfiniteSprint(PED, true)
					
					shared.SMAE.Player[2] = CODE == "3_05_Norton" and {"/Global/Norton", "Act/Anim/3_05_Norton.act"} or {"/Global/"..CODE, "Act/Anim/"..CODE..".act"}
					shared.SMAE.Movement[1] = ({["BoxingPlayer"] = "GS_Male_A", ["G_Johnny"] = "G_Melee_A", ["CV_Male_A"] = "GS_Male_A", ["J_Damon"] = "J_Striker_A"})[CODE] or CODE
				end
			end
		end
	end,
	
	WEAPON = function(PLAYER, CODE)
		if type(PLAYER) == "boolean" then
			local PED = PLAYER and gPlayer or F.PCHOOSE()
			
			if PedIsValid(PED) then
				PedSetWeapon(PED, CODE, 50, false)
			end
		else
			PickupCreateXYZ(CODE, shared.SMAE.X + random(-2, 2), shared.SMAE.Y + random(-2, 2), shared.SMAE.Z)
		end
	end,
	
	SPEECH = function(PLAYER, CODE)
		local PED = PLAYER and gPlayer or F.PCHOOSE()
		
		SoundStopCurrentSpeechEvent(PED)
		SoundPlayAmbientSpeechEvent(PED, CODE)
	end,
	
	CNPC = function(INDEX, AMBIENT, COMPANION)
		local PX, PY, PZ = PlayerGetPosXYZ()
		local PED = PedCreateXYZ(INDEX == 0 and math.random(2, 258) or INDEX, PX + math.random(-2, 2), PY + math.random(-2, 2), PZ)
		
		if INDEX == 0 then
			PedSwapModel(PED, "player")
		end
		
		if AMBIENT then
			PedMakeAmbient(PED)
		end
		
		if type(COMPANION) == "boolean" then
			if COMPANION == true then
				F.PALLY(gPlayer, PED, true)
			else
				PedSetPedToTypeAttitude(PED, 13, 0)
				PedSetEmotionTowardsPed(PED, gPlayer, 0)
				
				PedAttackPlayer(PED, 3)
			end
		end
	end,
	
	PGAN = function(PED)
		local NODE, ACT = "/Global/", "- UNKNOWN ACT -"
		
		for N1, PED_NODES in ipairs(shared.SMAE.Nodes) do
			if PedIsPlaying(PED, NODE..PED_NODES, true) then
				NODE = NODE..PED_NODES.."/"
				N1 = 1
			end
		end
		for N2, PED_ACTS in ipairs(shared.SMAE.Acts) do
			if PedIsPlaying(PED, "/Global/"..PED_ACTS[1], true) then
				ACT = PED_ACTS[2]
			end
		end
		
		return NODE, ACT
	end,
	
	PMOVING = function()
		return GetStickValue(16, 0) > 0.08 or GetStickValue(16, 0) < -0.08 or GetStickValue(17, 0) > 0.08 or GetStickValue(17, 0) < -0.08
	end,
	
	PMOVE = function(PED)
		local DIST, CP, CH, MODE = 4, 0, PedGetHeading(PED), {CAMERA = {1, "VERTICAL"}, HEIGHT = {1, "FIX", 0}}
		local NAME, PP = STR.PEDNAME(PedGetName(PED), false), {PlayerGetPosXYZ()}
		
		if not DIR_2D then
			DIR_2D, DIR_3D = function(H, D)
				return -math.sin(H) * D, math.cos(H) * D
			end, function(P, H, D)
				return math.cos(P) * -math.sin(H) * D, math.cos(P) * math.cos(H) * D, math.sin(P) * D
			end
		end
		
		TutorialShowMessage("M: "..MODE.CAMERA[2].."\nH: "..MODE.HEIGHT[2], -1, true)
		shared.gActiveControl = false
		
		while not IsButtonBeingPressed(2, 0) do
			Wait(0)
			
			if PedIsValid(PED) then
				if IsButtonBeingPressed(15, 0) then
					MODE.CAMERA[1] = MODE.CAMERA[1] + 1 > 3 and 1 or MODE.CAMERA[1] + 1
					MODE.CAMERA[2] = ({[1] = "VERTICAL", [2] = "HORIZONTAL", [3] = "DISTANCE"})[MODE.CAMERA[1]]
					
					TutorialShowMessage("M: "..MODE.CAMERA[2].."\nH: "..MODE.HEIGHT[2], -1, true)
				end
				
				if IsButtonBeingPressed(11, 0) then
					MODE.HEIGHT[1] = MODE.HEIGHT[1] + 1 > 3 and 1 or MODE.HEIGHT[1] + 1
					MODE.HEIGHT[2] = ({[1] = "FIX", [2] = "UP", [3] = "DOWN"})[MODE.HEIGHT[1]]
					MODE.HEIGHT[3] = ({[1] = 0, [2] = 0.1, [3] = -0.1})[MODE.HEIGHT[1]]
					
					TutorialShowMessage("M: "..MODE.CAMERA[2].."\nH: "..MODE.HEIGHT[2], -1, true)
				end
				
				PedSetEffectedByGravity(PED, false)
				PedSetWeapon(gPlayer, -1, 0)
				
				if PED ~= gPlayer then
					PlayerSetPosSimple(PP[1], PP[2], PP[3])
					PedSetInvulnerable(gPlayer, true)
					
					if not PedIsPlaying(gPlayer, "/Global/1_06/HoboFly", true) then
						PedSetActionNode(gPlayer, "/Global/1_06/HoboFly", "Act/Conv/1_06.act")
					end
				end
				
				if not PedIsPlaying(PED, "/Global/1_06/HoboFly", true) then
					PedSetActionNode(PED, "/Global/1_06/HoboFly", "Act/Conv/1_06.act")
				end
				
				local INV = DIST < 0 and -1 or 1
				DIST = DIST + (MODE.CAMERA[2] == "DISTANCE" and (GetStickValue(8, 0) - GetStickValue(6, 0)) or 0) * 0.2
				
				CP = CP + (MODE.CAMERA[2] == "HORIZONTAL" and (GetStickValue(8, 0) - GetStickValue(6, 0)) or 0) / 25 * INV
				CH = CH + (MODE.CAMERA[2] == "VERTICAL" and (GetStickValue(8, 0) - GetStickValue(6, 0)) or 0) / 20
				
				local PX, PY, PZ = PedGetPosXYZ(PED)
				local X1, Y1 = DIR_2D(CH, GetStickValue(17, 0)/10 * 7 * INV)
				local X2, Y2 = DIR_2D(CH + math.pi/2, GetStickValue(16, 0)/10 * 7 * INV)
				
				PX, PY, PZ = PX + X1 + X2, PY + Y1 + Y2, PZ + (MODE.HEIGHT[3])
				
				if PED == gPlayer then
					PlayerFaceHeading(CH)
					PlayerSetPosSimple(PX, PY, PZ)
				else
					PedFaceHeading(PED, CH * 57.3)
					PedSetPosXYZ(PED, PX, PY, PZ)
				end
				
				local CX, CY, CZ = DIR_3D(CP, CH, -DIST)
				
				local CAMX, CAMY, CAMZ = PX + CX, PY + CY, PZ + CZ + 1.5
				local LOOKX, LOOKY, LOOKZ = PX, PY, PZ + 1.5
				
				CameraSetXYZ(CAMX, CAMY, CAMZ, LOOKX, LOOKY, LOOKZ)
			else
				break
			end
		end
		
		if PedIsValid(PED) then
			PedSetEffectedByGravity(PED, true)
			PedSetActionNode(PED, "/Global", "Globals.act")
		end
		
		if PED ~= gPlayer then
			PlayerStopAllActionControllers()
			PedSetInvulnerable(gPlayer, false)
		end
		
		TutorialShowMessage("CONFIRMED!", 2500, true)
		CameraReturnToPlayer()
		
		shared.gActiveControl = true
	end,
	
	-- hud
	
	HCLOCK = function(YES)
		_G[(YES and "Unp" or "P").."auseGameClock"]()
	end,
	
	HCLR = function(YES, CLOCK)
		for I, V in ipairs({{0, not YES}, {4, not YES}, {11, not YES}}) do
			ToggleHUDComponentVisibility(unpack(V))
		end
		
		if CLOCK then
			F.HCLOCK(not YES)
		end
	end,
	
	HBUTTON = function(ACTIVE, ID)
		ButtonHistoryIgnoreController(true)
		ButtonHistoryClearSequence()
		
		ToggleHUDComponentVisibility(21, ACTIVE)
		
		if ACTIVE and type(ID) == "number" then
			ButtonHistoryAddSequence(ID, false)
			ButtonHistorySetSequenceTime(10)
		end
		
		ButtonHistoryIgnoreController(false)
	end,
	
	-- animation group
	
	LOADANIM = function(ACT)
		if not shared.SMAE.AGL then
			shared.SMAE.AGL = {
				['Act/Conv/1_01.act'] = {"Hang_Talking", "NPC_AggroTaunt", "Area_School", "SBULL_A", "POI_Smoking", "B_Striker", "NPC_Adult"},
				['Act/Conv/1_02.act'] = {"1_02_MeetWithGary", "TE_FEMALE", "Russell", "F_Girls", "NPC_AggroTaunt", "F_Douts", "Hang_Talking", "Area_School", "SBULL_A", "NPC_Adult", "HUMIL_6-5VPLY", "NIS_1_02", "NIS_1_02B"},
				['Act/Conv/1_02B.act'] = {"1_02BYourSchool", "SGEN_I", "3_04WrongPtTown", "G_Johnny", "SNERD_I", "SNERD_S", "KISSF", "NIS_1_02", "SBULL_X"},
				['Act/Conv/1_03.act'] = {"1_03The Setup", "NIS_1_03", "POI_Smoking", "Hang_Talking", "GEN_Social", "Cheer_Cool2", "NPC_Adult", "TSGate", "SCgrdoor", "Sbarels1", "Area_School", "Px_Rail", "DO_Grap"},
				['Act/Conv/1_04.act'] = {"1_04TheSlingshot", "Hang_Workout", "NIS_1_04"},
				['Act/Conv/1_05.act'] = {"2_08WeedKiller", "GEN_Social", "F_Pref", "Px_Sink", "Px_Gen", "NPC_Cheering", "POI_Smoking", "HUMIL_5-8F_A"},
				['Act/Conv/1_06.act'] = {"DO_Striker", "DO_StrikeCombo", "Boxing", "NPC_AggroTaunt", "Hobo_Cheer", "NPC_Adult"},
				['Act/Conv/1_07.act'] = {"1_03The Setup", "1_07_SaveBucky", "TSGate", "F_Nerds", "Hang_Jock", "NPC_AggroTaunt", "Hang_Talking", "1_07_Sk8Board", "NIS_1_07"},
				['Act/Conv/1_08.act'] = {"NPC_AggroTaunt", "Area_School", "Px_Sink", "TE_Female", "N_Striker_B", "MG_Craps", "F_Girls", "NIS_1_08_1", "1_08_MandPuke", "Px_Tlet"},
				['Act/Conv/1_09.act'] = {"1_09_Candidate", "NPC_Mascot", "NIS_1_09", "1_03The Setup", "IDLE_NERD_A", "Cheer_Nerd1"},
				['Act/Anim/1_10.act'] = {"1_10Betrayal", "Px_RedButton", "MINI_Lock"},
				['Act/Conv/1_11X1.act'] = {"3_04WrongPtTown"},
				['Act/Conv/1_11X2.act'] = {"POI_Smoking", "POI_WarmHands", "Halloween", "W_PooBag", "Px_Sink", "NIS_1_11", "MINI_React"},
				['Act/Conv/1_G1.act'] = {"MINI_Lock", "1_G1_TheDiary", "1_03The Setup", "MINI_Lock", "1_07_SaveBucky"},
				['Act/Conv/1_S01.act'] = {"Hang_Talking", "F_Adult", "NPC_Adult", "WeaponUnlock"},
				['Act/Conv/2_01.act'] = {"2_01LastMinuteShop", "NIS_2_01"},
				--['Act/Conv/2_02.act'] = {},
				['Act/Conv/2_03i.act'] = {"TadGates", "NIS_2_03", "MINI_Lock"},
				['Act/Conv/2_04.act'] = {"NIS_2_04", "3_R08RaceLeague", "Cheer_Girl3", "Cheer_Nerd3", "Cheer_Posh3", "Cheer_Cool2", "3_G3"},
				['Act/Conv/2_05.act'] = {"2_05TadsHouse"},
				['Act/Conv/2_06.act'] = {"IDLE_SEXY_C", "NIS_2_06_1"},
				['Act/Conv/2_07.act'] = {"2_07BeachRumble", "Boxing"},
				['Act/Conv/2_08.act'] = {"Px_Urinal", "NPC_AggroTaunt", "2_08WeedKiller", "SGEN_S", "NPC_Chat_1", "Hang_Talking", "MINI_Lock"},
				['Act/Conv/2_B.act'] = {"N2B Dishonerable", "NIS_2_B", "Boxing"},
				['Act/Conv/2_G2.act'] = {"F_Girls", "NPC_Love", "2_G2CarnivalDate", "2_G2_GiftExchange"},
				['Act/Conv/2_R03.act'] = {"NIS_0_00A", "F_Adult", "2_R03PaperRoute", "SBULL_S"},
				--['Act/Conv/2_S02.act'] = {},
				['Act/Conv/2_S04.act'] = {"2_S04CharSheets", "NIS_2_S04", "F_Girls", "F_Nerds", "Cheer_Nerd1", "Hang_Talking", "NPC_Cheering", "POI_Smoking", "POI_Booktease", "NPC_AggroTaunt", "LE_Orderly", "GEN_Social", "IDLE_GSF"},
				['Act/Conv/2_S05.act'] = {"2_S05_CooksCrush", "Hobos"},
				['Act/Conv/2_S06.act'] = {"GEN_Social", "F_Girls", "Px_RedButton", "IDLE_SEXY_C", "NPC_Shopping"},
				['Act/Conv/3_01.act'] = {"NPC_Love", "NIS_3_01", "MINI_React"},
				['Act/Conv/3_01D.act'] = {"Santa_lap"},
				['Act/Conv/3_02.act'] = {"NIS_3_02"},
				--['Act/Conv/3_03.act'] = {},
				['Act/Conv/3_04.act'] = {"Cheer_Cool3", "NPC_Spectator", "Cheer_Nerd1", "Cheer_Cool1", "NPC_Adult", "3_04WrongPtTown", "SNERD_I", "SNERD_S"},
				['Act/Conv/3_05.act'] = {"Area_Tenements", "Sitting_Boys", "POI_Smoking", "G_Grappler"},
				['Act/Conv/3_07.act'] = {"Hang_Talking"},
				['Act/Conv/3_08.act'] = {"Try_Clothes", "MINI_Lock", "NIS_3_08"},
				['Act/Conv/3_09.act'] = {"1_G1_TheDiary", "1_06ALittleHelp"},
				['Act/Conv/3_B.act'] = {"3_BFightJohnnyV", "NIS_3_B"},
				['Act/Conv/3_G3.act'] = {"3_G3", "Cheer_Girl3", "Cheer_Cool2", "NIS_3_G3"},
				['Act/Conv/3_R09.act'] = {"NIS_3_R09_N", "Cheer_Nerd3", "Hang_Talking", "NIS_3_R09_N", "NIS_3_R09_P", "3_R09_J", "WeaponUnlock"},
				['Act/Conv/3_S03.act'] = {"NIS_3_S03", "NIS_3_S03_B"},
				['Act/Conv/3_S11.act'] = {"Hang_Talking", "LE_ORDERLY", "F_CRAZY", "NIS_3_S11"},
				['Act/Conv/3_XM.act'] = {"NPC_Adult"},
				['Act/Conv/4_01.act'] = {"F_Girls", "ChLead_Idle", "SHWR", "UBO"},
				['Act/Conv/4_02.act'] = {"F_NERDS", "IDLE_NERD_C"},
				['Act/Conv/4_03.act'] = {"F_JOCKS", "DodgeBall"},
				['Act/Conv/4_04.act'] = {"Ambient", "Hang_Jock", "NPC_Adult", "4_04_FunhouseFun", "NPC_AggroTaunt"},
				['Act/Conv/4_05.act'] = {"F_Girls", "NPC_Mascot", "Hang_Workout", "IDLE_JOCK_A", "Russell", "Px_Ladr", "Cheer_Cool1"},
				['Act/Conv/4_06.act'] = {"4_06BIGGAME", "Hang_Workout", "NPC_CHEERING", "GEN_SOCIAL", "PX_TLET", "POI_ChLead", "NIS_4_06"},
				['Act/Conv/4_G4.act'] = {"MINIGraf", "Hang_Jock", "Hang_Talking", "NPC_Love", "NPC_NeedsResolving", "POI_Smoking", "GEN_Socia", "IDLE_SEXY_C", "SGIRL_F"},
				['Act/Conv/4_B2.act'] = {"NPC_AggroTaunt", "NIS_4_B2", "SGIRL_S"},
				['Act/Conv/5_01.act'] = {"5_01Grp", "F_Nerds", "NIS_5_01"},
				['Act/Conv/5_02.act'] = {"5_02PrVandalized", "NPC_Love", "NPC_ADULT", "Hang_Moshing", "LE_Orderly", "Cheer_Cool1", "Cheer_Cool2", "Cheer_Gen3", "DodgeBall", "POI_Smoking", "IDLE_DOUT_C", "NIS_5_02"},
				['Act/Conv/5_03.act'] = {"Hang_Talking", "AsyBars", "G_Striker", "F_CRAZY"},
				['Act/Conv/5_04.act'] = {"Ambient3", "NIS_5_04"},
				['Act/Conv/5_05.act'] = {"Dodgeball", "Dodgeball2", "SAUTH_U", "1_03The Setup", "QPed", "NIS_5_05"},
				['Act/Conv/5_07a.act'] = {"NIS_5_07", "F_Adult", "ChLead_Idle"},
				['Act/Conv/5_09.act'] = {"5_09MakingAMark", "W_SprayCan", "NPC_Adult"},
				['Act/Conv/5_G5.act'] = {"MINI_React", "NIS_5_G5"},
				['Act/Conv/6_02.act'] = {"NIS_6_02", "6_02CompMayh"},
				['Act/Conv/6_02gdorm.act'] = {"Area_Tenements", "W_Snowshwl"},
				['Act/Conv/C2.act'] = {"MINI_React"},
				['Act/Conv/C3_1.act'] = {"MINI_React", "Cheer_Cool2", "Cheer_Cool3", "Dodgeball", "POI_ChLead", "C_Wrestling", "Dodgeball2", "Ambient", "Cheer_Gen3", "NPC_AggroTaunt"},
				['Act/Conv/C4.act'] = {"MINICHEM", "WeaponUnlock", "MINI_React", "NPC_Spectator", "NPC_Adult", "MG_Craps"},
				['Act/Conv/C5.act'] = {"WeaponUnlock", "MINI_React"},
				['Act/Conv/C6.act'] = {"MINIBIKE", "SHOPBIKE", "MINICHEM", "MINI_React", "NPC_Spectator", "NPC_Adult"},
				['Act/Conv/C7.act'] = {"NPC_Adult", "UBO", "MINI_React", "ENGLISHCLASS", "SBULL_X"},
				['Act/Conv/DodgeballGame.act'] = {"Dodgeball", "Dodgeball2", "Cheer_Gen3", "MINI_REACT", "NPC_AggroTaunt"},
				['Act/Conv/MGSocPen.act'] = {"MINI_React", "BBALL_21", "NPC_Cheering"}, 
				['Act/Anim/GraffitiCleanup.act'] = {"MINIGRAF", "W_Thrown"},
				['Act/Anim/HighStriker.act'] = {"Car_Ham"},
			}
		end
		
		if shared.SMAE.AGL[ACT] then
			for _, A in ipairs(shared.SMAE.AGL[ACT]) do
				if not shared.SMAE.AG[A] and not HasAnimGroupLoaded(A) then
					LoadAnimationGroup(A)
					
					if table.getn(shared.SMAE.AG) > 70 then
						if HasAnimGroupLoaded(shared.SMAE.AG[1]) then
							UnLoadAnimationGroup(shared.SMAE.AG[1])
						end
						table.remove(shared.SMAE.AG, 1)
					end
					table.insert(shared.SMAE.AG, A)
				end
			end
		end
	end
} or F


--[[
	--------------
	# STRING LIB #
	--------------
]]

STR = {}

STR.PEDNAME = function(STRING, FULL)
	local SUB = {
		N_Jimmy = FULL and "Jimmy Hopkins" or "Jimmy",
		N_Zoe = FULL and "Zoe Taylor" or "Zoe",
		N_Beatrice = FULL and "Beatrice Trudeau" or "Beatrice",
		N_Algernon = FULL and "Algernon Papadopoulus" or "Algernon",
		N_Fatty = FULL and "Fatty Johnson" or "Fatty",
		N_Melvin = FULL and "Melvin O'Connor" or "Melvin",
		N_Thad = FULL and "Thad Carlson" or "Thad",
		N_Bucky = FULL and "Bucky Pasteur" or "Bucky",
		N_Cornelius = FULL and "Cornelius Johnson" or "Cornelius",
		N_Earnest = FULL and "Earnest Jones" or "Earnest",
		N_Donald = FULL and "Donald Anderson" or "Donald",
		N_Damon = FULL and "Damon West" or "Damon",
		N_Kirby = FULL and "Kirby Olsen" or "Kirby",
		N_Mandy = FULL and "Mandy Wiles" or "Mandy",
		N_Dan = FULL and "Dan Wilson" or "Dan",
		N_Luis = FULL and "Luis Luna" or "Luis",
		N_Casey = FULL and "Casey Harris" or "Casey",
		N_Bo = FULL and "Bo Jackson" or "Bo",
		N_Ted = FULL and "Ted Thompson" or "Ted",
		N_Juri = FULL and "Juri Karamazov" or "Juri",
		N_Peanut = FULL and "Peanut Romano" or "Peanut",
		N_Hal = FULL and "Hal Esposito" or "Hal",
		N_Johnny = FULL and "Johnny Vincent" or "Johnny",
		N_Lefty = FULL and "Lefty Macini" or "Lefty",
		N_Lola = FULL and "Lola Lombardi" or "Lola",
		N_Lucky = FULL and "Lucky De Luca" or "Lucky",
		N_Vance = FULL and "Vance Medici" or "Vance",
		N_Ricky = FULL and "Ricky Pucino" or "Ricky",
		N_Norton = FULL and "Norton Williams" or "Norton",
		N_Gord = FULL and "Gord Vendome" or "Gord",
		N_Tad = FULL and "Tad Spencer" or "Tad",
		N_Chad = FULL and "Chad Morris" or "Chad",
		N_Bif = FULL and "Bif Taylor" or "Bif",
		N_Justin = FULL and "Justin Vandervelde" or "Justin",
		N_Bryce = FULL and "Bryce Montrose" or "Bryce",
		N_Darby = FULL and "Darby Harrington" or "Darby",
		N_Pinky = FULL and "Pinky Gauthier" or "Pinky",
		N_Angie = FULL and "Angie Ng" or "Angie",
		N_Parker = FULL and "Parker Ogilvie" or "Parker",
		N_Jerry = "Jerry",
		N_Otto = FULL and "Otto Tyler" or "Otto",
		N_Leon = "Leon",
		N_Duncan = "Duncan",
		N_Henry = "Henry",
		N_Gurney = "Gurney",
		N_Omar = FULL and "Omar Romero" or "Omar",
		N_Max = FULL and "Max MacTavish" or "Max",
		N_Seth = FULL and "Seth Kolbe" or "Seth",
		N_Edward = FULL and "Edward Seymour" or "Edward",
		N_Karl = FULL and "Karl Branting" or "Karl",
		N_Theo = "Theo",
		N_MissPeabody = FULL and "Mrs. Peabody" or "Peabody",
		N_MrBurton = FULL and "Mr. Burton" or "Burton",
		N_MrLuntz = FULL and "Mr. Luntz" or "Luntz",
		N_MrGalloway = FULL and "Mr. Galloway" or "Galloway",
		N_Edna = "Edna",
		N_MissWinston = FULL and "Miss Danvers" or "Danvers",
		N_MrsMcRae = FULL and "Mrs. McRae" or "McRae",
		N_MrHattrick = FULL and "Mr. Hattrick" or "Hattrick",
		N_MrsCarvin = FULL and "Mrs. Carvin" or "Carvin",
		N_MsPhillips = FULL and "Ms. Phillips" or "Phillips",
		N_MrSlawter = FULL and "Dr. Slawter" or "Slawter",
		N_DrCrabblesnitch = FULL and "Dr. Crabblesnitch" or "Crabblesnitch",
		N_Sheldon = FULL and "Sheldon Thompson" or "Sheldon",
		N_Christy = FULL and "Christy Martin" or "Christy",
		N_Gloria = FULL and "Gloria Jackson" or "Gloria",
		N_Pedro = FULL and "Pedro De La Hoya" or "Pedro",
		N_Constantinos = FULL and "Constantinos Brakus" or "Constantinos",
		N_Ray = FULL and "Ray Hughes" or "Ray",
		N_Ivan = FULL and "Ivan Alexander" or "Ivan",
		N_Trevor = FULL and "Trevor Moore" or "Trevor",
		N_Eunice = FULL and "Eunice Pound" or "Eunice",
		N_Russell = FULL and "Russell Northtop" or "Russell",
		N_DrBambillo = FULL and "Dr. Bambillo" or "Bambillo",
		N_MrSullivan = FULL and "Mr. Sullivan" or "Sullivan",
		N_MsKopke = FULL and "Miss Kopke" or "Kopke",
		N_MsRushinski = FULL and "Ms. Rushinski" or "Rushinski",
		N_MsIsaacs = FULL and "Ms. Isaacs" or "Isaacs",
		N_BethanyJones = FULL and "Bethany Jones" or "Bethany",
		N_ORourke = "O'Rouke",
		N_OfficerMonson = FULL and "Officer Monson" or "Monson",
		N_ZackOwens = FULL and "Zack Owens" or "Owens",
		N_Trent = FULL and "Trent Northwick" or "Trent",
		N_TobiasMason = FULL and "Tobias Mason" or "Tobias",
		N_MrGrant = FULL and "Grant" or "Hobo",
		N_Mascot = FULL and "Jimmy Hopkins" or "Mascot",
		N_MrOh = FULL and "Mr. Oh" or "Oh",
		N_Edgar = FULL and "Edgar Munsen" or "Edgar",
		N_OfficerWilliams = FULL and "Officer Williams" or "Williams",
		N_Davis = FULL and "Davis White" or "Davis",
		N_MrBreckindale = FULL and "Mr. Brekindale" or "Brekindale",
		N_MrDoolin = FULL and "Mr. Doolin" or "Doolin",
		N_Troy = FULL and "Troy Miller" or "Troy",
		N_Nate = "Nate",
		N_MrCarmichael = FULL and "Mr. Carmichael" or "Carmichael",
		N_NickyCharles = FULL and "Nicky Charles" or "Nicky",
		N_DrWatts = FULL and "Dr. Watts" or "Watts",
		N_MissAbby = FULL and "Miss Abby" or "Abby",
		N_Mihailovich = "Mihailovich",
		N_Freeley = "Freeley",
		N_Dorsey = "Dorsey",
		N_Hector = "Hector",
		N_Osbourne = "Osbourne",
		N_MariaTheresa = "Maria Theresa",
		N_Bob = "Bob",
		N_Chuck = "Chuck",
		N_Ian = "Ian",
		N_Fenwick = "Fenwick",
		N_Neil = "Neil",
		N_MrSvenson = "Mr. Svenson",
		N_Denny = "Denny",
		N_Gary = FULL and "Gary Smith" or "Gary",
		N_Krakauer = "Krakauer",
		N_MrMoratti = FULL and "Mr. Moratti" or "Moratti",
		N_Peter = FULL and "Pete Kowalski" or "Peter",
		N_MrSmith = FULL and "Alon Smith" or "Smith",
		N_Rat = "Rat",
		N_Melody = FULL and "Melody Adams" or "Melody",
		N_Karen = FULL and "Karen Johnson" or "Karen",
		N_Gordon = FULL and "Gordon Wakefield" or "Gordon",
		N_Brandy = "Brandy",
		N_Pitbull = "Dog",
		N_Lance = FULL and "Lance Jackson" or "Lance",
		N_Crystal = "Crystal",
		N_MrMartin = FULL and "Mr. Martin" or "Martin",
		N_Ethan = FULL and "Ethan Robinson" or "Ethan",
		N_Wade = FULL and "Wade Martin" or "Wade",
		N_Tom = FULL and "Tom Gurney" or "Tom",
		N_MrRamirez = FULL and "Mr. Ramirez" or "Ramirez",
		N_MrHuntingdon = FULL and "Mr. Huntingdon" or "Huntingdon",
		N_MrWiggins = FULL and "Mr. Wiggins" or "Wiggins",
		N_Floyd = "Floyd",
		N_Stan = "Stan",
		N_Handy = "Handy",
		N_gGregory = "Gregory",
		N_MrBuba = FULL and "Mr. Bubas" or "Buba",
		N_MrGordon = FULL and "Mr. Gordon" or "Gordon",
		N_MrsLisburn = FULL and "Mrs. Lisburn" or "Lisburn",
		N_Betty = "Betty",
		N_Lightning = "Lighning",
		N_Zeke = "Zeke",
		N_Alfred = "Alfred",
		N_Paris = "Paris",
		N_Courtney = "Courtney",
		N_Delilah = FULL and "Delilah Jezebel" or "Delilah",
		N_Drew = "Drew",
		N_Castillo = FULL and "Mr. Castillo" or "Castillo",
		N_McInnis = "McInnis",
		N_MrJohnson = "Mr. Johnson",
		N_PunchBag = "PunchBag",
		N_Matthews = FULL and "Mr. Matthews" or "Matthews",
		N_Peters = FULL and "Miss Peters" or "Peters",
		N_TEMP = "Unnamed",
	}
	
	return SUB[STRING] or "Unknown"
end

STR.VEHNAME = function(VEHICLE)
	local SUB = {
		[272] = "Green BMX",
		[273] = "Retro Bike",
		[274] = "Crap Bike",
		[279] = "Bicycle",
		[278] = "Red BMX",
		[277] = "Blue BMX",
		[280] = "Mountain Bike",
		[281] = "Lade Bike",
		[283] = "Aquaberry Bike",
		[282] = "Racer Bike",
		
		[276] = "Scooter",
		[275] = "Cop Bike",
		
		[286] = "Taxi",
		[290] = "Limo",
		[291] = "Delivery Truck",
		[292] = "Foreign Car",
		[293] = "Regular Car",
		[295] = "Cop Car",
		[294] = "70 Wagon",
		[296] = "Domestic Car",
		[297] = "Truck",
		[288] = "Dozer",
		
		[284] = "Mower",
		[289] = "Go-Kart",
		[298] = "Alien Spaceship 1",
		[287] = "Alien Spaceship 2",
		[285] = "Alien Spaceship 3",
	}
	
	return SUB[VehicleGetModelId(VEHICLE)] or "Unknown"
end

STR.COLORNAME = function(COLOR)
	local SUB = {
		[0] = "Black",
		[1] = "White",
		[2] = "Dark Blue",
		[3] = "Cherry Red",
		[4] = "Midnight Blue",
		[5] = "Purple",
		[6] = "Yellow",
		[7] = "Striking Blue",
		[8] = "Light Blue",
		[9] = "Green",
		[10] = "Red 01",
		[11] = "Red 02",
		[12] = "Red 03",
		[13] = "Red 04",
		[14] = "Red 05",
		[15] = "Red 06",
		[16] = "Red 07",
		[17] = "Red 08",
		[18] = "Red 09",
		[19] = "Red 10",
		[20] = "Orange 01",
		[21] = "Orange 02",
		[22] = "Orange 03",
		[23] = "Orange 04",
		[24] = "Orange 05",
		[25] = "Orange 06",
		[26] = "Orange 07",
		[27] = "Orange 08",
		[28] = "Orange 09",
		[29] = "Orange 10",
		[30] = "Yellow 01",
		[31] = "Yellow 02",
		[32] = "Yellow 03",
		[33] = "Yellow 04",
		[34] = "Yellow 05",
		[35] = "Yellow 06",
		[36] = "Yellow 07",
		[37] = "Yellow 08",
		[38] = "Yellow 09",
		[39] = "Yellow 10",
		[40] = "Green 01",
		[41] = "Green 02",
		[42] = "Green 03",
		[43] = "Green 04",
		[44] = "Green 05",
		[45] = "Green 06",
		[46] = "Green 07",
		[47] = "Green 08",
		[48] = "Green 09",
		[49] = "Green 10",
		[50] = "Blue 01",
		[51] = "Blue 02",
		[52] = "Blue 03",
		[53] = "Blue 04",
		[54] = "Blue 05",
		[55] = "Blue 06",
		[56] = "Blue 07",
		[57] = "Blue 08",
		[58] = "Blue 09",
		[59] = "Blue 10",
		[60] = "Purple 01",
		[61] = "Purple 02",
		[62] = "Purple 03",
		[63] = "Purple 04",
		[64] = "Purple 05",
		[65] = "Purple 06",
		[66] = "Purple 07",
		[67] = "Purple 08",
		[68] = "Purple 09",
		[69] = "Purple 10",
		[70] = "Grey 01",
		[71] = "Grey 02",
		[72] = "Grey 03",
		[73] = "Grey 04",
		[74] = "Grey 05",
		[75] = "Grey 06",
		[76] = "Grey 07",
		[77] = "Grey 08",
		[78] = "Grey 09",
		[79] = "Grey 10",
		[80] = "Light 01",
		[81] = "Light 02",
		[82] = "Light 03",
		[83] = "Light 04",
		[84] = "Light 05",
		[85] = "Light 06",
		[86] = "Light 07",
		[87] = "Light 08",
		[88] = "Light 09",
		[89] = "Light 10",
		[90] = "Dark 01",
		[91] = "Dark 02",
		[92] = "Dark 03",
		[93] = "Dark 04",
		[94] = "Dark 05",
		[95] = "Blue",
		[96] = "Green",
		[97] = "Red",
		[98] = "Blue",
		[99] = "Off White"
	}
	
	return SUB[COLOR] or "Unknown"
end


--[[
	---------------------------
	# ILLEGAL SHARED VARIABLE #
	---------------------------
]]

shared.gActiveControl = true


--[[
	--------------------
	# ILLEGAL FUNCTION #
	--------------------
]]

local PlayerSetControl = _G.PlayerSetControl
_G.PlayerSetControl = function(CONTROL)
	PlayerSetControl(CONTROL)
	shared.gActiveControl = CONTROL == 1 and true or false
end
local ClothingBuildPlayer = _G.ClothingBuildPlayer
_G.ClothingBuildPlayer = function()
	if PedIsModel(gPlayer, 0) then
		ClothingBuildPlayer()
	end
end

local PedSetStealthBehavior = _G.PedSetStealthBehavior
_G.PedSetStealthBehavior = function(PED, BEHAVIOUR, CALLBACK)
	if not shared.EmptyCallback then
		shared.EmptyCallback = function(PED) end
	end
	PedSetStealthBehavior(PED, BEHAVIOUR, shared.SMAE.Settings.Transparent and shared.EmptyCallback or CALLBACK)
end
local PedIsSpotted = _G.PedIsSpotted
_G.PedIsSpotted = function(PED, ID)
	if shared.SMAE.Settings.Transparent and OBJECT == gPlayer then
		return false
	end
	return PedIsSpotted(PED, ID)
end
local PedCanSeeObject = _G.PedCanSeeObject
_G.PedCanSeeObject = function(PED, OBJECT, POOL)
	if shared.SMAE.Settings.Transparent and OBJECT == gPlayer then
		return false
	end
	return PedCanSeeObject(PED, OBJECT, POOL)
end

local ClothingStoreAdd = _G.ClothingStoreAdd
_G.ClothingStoreAdd = function(CATEGORY, ITEM, PRICE)
	ClothingStoreAdd(CATEGORY, ITEM, shared.SMAE.Settings.Shop and 0 or PRICE)
end
local BarberShopAdd = _G.BarberShopAdd
_G.BarberShopAdd = function(GROUP, HAIRSTYLE, PRICE)
	BarberShopAdd(GROUP, HAIRSTYLE, shared.SMAE.Settings.Shop and 0 or PRICE)
end
local ShopAddItem = _G.ShopAddItem
_G.ShopAddItem = function(ARG1, ARG2, ARG3, ARG4, ARG5, ARG6, ARG7)
	ShopAddItem(ARG1, ARG2, ARG3, ARG4, shared.SMAE.Settings.Shop and 0 or ARG5, ARG6, ARG7)
end
local TattooStoreAdd = _G.TattooStoreAdd
_G.TattooStoreAdd = function(ARG1, ARG2, ARG3, ARG4, ARG5)
	TattooStoreAdd(ARG1, ARG2, ARG3, shared.SMAE.Settings.Shop and 0 or ARG4, ARG5)
end

local MGCA_SetEnemySpeed = _G.MGCA_SetEnemySpeed
_G.MGCA_SetEnemySpeed = function(TYPE, SPEED)
	MGCA_SetEnemySpeed(TYPE, shared.SMAE.Settings.Art and 0 or SPEED)
end
local MGCA_SetExploderTimeOut = _G.MGCA_SetExploderTimeOut
_G.MGCA_SetExploderTimeOut = function(TIMER)
	MGCA_SetExploderTimeOut(shared.SMAE.Settings.Art and 0 or TIMER)
end
local MGCA_SetExploderDebrisCount = _G.MGCA_SetExploderDebrisCount
_G.MGCA_SetExploderDebrisCount = function(COUNT)
	MGCA_SetExploderDebrisCount(shared.SMAE.Settings.Art and 0 or COUNT)
end
local MGCA_SetExploderDebrisSpeed = _G.MGCA_SetExploderDebrisSpeed
_G.MGCA_SetExploderDebrisSpeed = function(SPEED)
	MGCA_SetExploderDebrisSpeed(shared.SMAE.Settings.Art and 0 or SPEED)
end

local ClassMathValidAnswer = _G.ClassMathValidAnswer
_G.ClassMathValidAnswer = function()
	if shared.SMAE.Settings.Math then
		if not CBUI_IsActive() and not CB_IsRunning() then
			return true
		end
		return ClassMathValidAnswer()
	end
	
	return shared.SMAE.Settings.Math and true or ClassMathValidAnswer()
end
local ClassMathAnswerGiven = _G.ClassMathAnswerGiven
_G.ClassMathAnswerGiven = function()
	return shared.SMAE.Settings.Math and true or ClassMathAnswerGiven()
end
local ClassMathGetScorePercentage = _G.ClassMathGetScorePercentage
_G.ClassMathGetScorePercentage = function()
	return shared.SMAE.Settings.Math and 100 or ClassMathGetScorePercentage()
end
local ClassMathSetScoreMsg = _G.ClassMathSetScoreMsg
_G.ClassMathSetScoreMsg = function(ARG1, ARG2)
	ClassMathSetScoreMsg(shared.SMAE.Settings.Math and 0 or ARG1, ARG2)
end

local ClassBiologySetTimer = _G.ClassBiologySetTimer
_G.ClassBiologySetTimer = function(ARG1, ARG2)
	ClassBiologySetTimer(shared.SMAE.Settings.Timer and ARG1 or 999999, ARG2)
end
local ClassEnglishSetTimer = _G.ClassEnglishSetTimer
_G.ClassEnglishSetTimer = function(ARG1, ARG2)
	ClassEnglishSetTimer(shared.SMAE.Settings.Timer and ARG1 or 999999, ARG2)
end
local ClassGeographySetTimer = _G.ClassGeographySetTimer
_G.ClassGeographySetTimer = function(ARG1, ARG2)
	ClassGeographySetTimer(shared.SMAE.Settings.Timer and ARG1 or 999999, ARG2)
end
local ClassMathSetTimer = _G.ClassMathSetTimer
_G.ClassMathSetTimer = function(ARG1, ARG2)
	ClassMathSetTimer(shared.SMAE.Settings.Timer and ARG1 or 999999, ARG2)
end
local LawnMowingSetTimer = _G.LawnMowingSetTimer
_G.LawnMowingSetTimer = function(TIMER)
	LawnMowingSetTimer(shared.SMAE.Settings.Timer and TIMER or 999999)
end
local MissionTimerStart = _G.MissionTimerStart
_G.MissionTimerStart = function(TIMER)
	MissionTimerStart(shared.SMAE.Settings.Timer and TIMER or 999999)
end

local GetCutsceneTime = _G.GetCutsceneTime
_G.GetCutsceneTime = function()
	return shared.SMAE.Settings.Cutscene and 999999 or GetCutsceneTime()
end

local SoundContinue = _G.SoundContinue
_G.SoundContinue = function()
	if shared.SMAE.Settings.GameAudio then
		SoundContinue()
	end
end


--[[
	----------------------
	# USER INTERFACE LIB #
	----------------------
]]

UI_MANAGER = function(TEXT, SELECTION, SUB_UI)
	local PREV_TEXT = CBUI_GetText()
	local PREV_OPT, PREV_OPT_TRUE = CBUI_GetOption()
	
	local SUB, CHOICE = {}, 1
	
	if type(SELECTION) == "table" then
		for ID = 1, table.getn(SELECTION) do
			table.insert(SUB, SELECTION[ID])
		end
	else
		table.insert(SUB, SELECTION)
	end
	
	table.insert(SUB, "'RETURN'")
	table.insert(SUB, "'EXIT'")
	
	CBUI_SetText(TEXT)
	CBUI_SetOption({"< SCROLL >", "", "< "..CHOICE.." >\n"..SUB[CHOICE]}, 3)
	
	repeat
		Wait(0)
		
		if CBUI_0() then
			CHOICE = CHOICE + 1 > table.getn(SUB) and 1 or CHOICE + 1
			CBUI_SetOption({"< SCROLL >", "", "< "..CHOICE.." >\n"..SUB[CHOICE]}, 3)
		end
	until CBUI_1()
	
	if CBUI_IsActive() then
		if SUB[CHOICE] == "'RETURN'" then
			CBUI_SetText(PREV_TEXT)
			CBUI_SetOption(PREV_OPT, PREV_OPT_TRUE)
			
			return nil
		elseif SUB[CHOICE] == "'EXIT'" then
			if shared.SMAE.SubGUI then
				CBUI_SetText("- MAIN MENU -\n"..shared.SMAE.Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Title)
				CBUI_SetOption({"PREV", "", "NEXT"}, 3)
				
				shared.SMAE.SubGUI = false
			else
				shared.SMAE.GUI = false
				
				CBUI_Close()
			end
			
			return nil
		else
			if SUB_UI == true then
				shared.SMAE.SubGUI = true
			end
			
			return SUB[CHOICE]
		end
	end
	
	return nil
end

UI_ADJUST = function(TEXT, VAL, ADD, MIN, MAX, PERCENT)
	local PREV_TEXT = CBUI_GetText()
	local PREV_OPT, PREV_OPT_TRUE = CBUI_GetOption()
	
	local SUB, CHOICE = {
		"INCREASE", "DECREASE", "'RETURN'", "'EXIT'"
	}, 1
	
	CBUI_SetText(TEXT.." : "..(PERCENT and string.format("%.0f", (VAL / MAX) * 100) or VAL))
	CBUI_SetOption({"< SCROLL >", "", "< "..CHOICE.." >\n"..SUB[CHOICE]}, 3)
	
	while true do
		Wait(0)
		
		if CBUI_IsActive() then
			if CBUI_0() then
				CHOICE = CHOICE + 1 > table.getn(SUB) and 1 or CHOICE + 1
				
				CBUI_SetOption({"< SCROLL >", "", "< "..CHOICE.." >\n"..SUB[CHOICE]}, 3)
			end
			
			if CBUI_1() then
				if SUB[CHOICE] ~= "'RETURN'" and SUB[CHOICE] ~= "'EXIT'" then
					VAL = CHOICE == 1 and (VAL + ADD > MAX and MIN or VAL + ADD) or (VAL - ADD < MIN and MAX or VAL - ADD)
					
					CBUI_SetText(TEXT.." : "..(PERCENT and string.format("%.0f", (VAL / MAX) * 100) or VAL))
				else
					break
				end
			end
		else
			break
		end
	end
	
	if CBUI_IsActive() then
		if SUB[CHOICE] == "'RETURN'" then
			CBUI_SetText(PREV_TEXT)
			CBUI_SetOption(PREV_OPT, PREV_OPT_TRUE)
			
			return VAL
		elseif SUB[CHOICE] == "'EXIT'" then
			if shared.SMAE.SubGUI then
				CBUI_SetText("- MAIN MENU -\n"..shared.SMAE.Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Title)
				CBUI_SetOption({"PREV", "", "NEXT"}, 3)
				
				shared.SMAE.SubGUI = false
			else
				shared.SMAE.GUI = false
				
				CBUI_Close()
			end
			
			return VAL
		end
	end
	
	return nil
end