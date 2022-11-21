-- ADVT_THREAD.LUA
-- AUTHOR	: ALTAMURENZA


--[[---------------------------
	# GENERAL PURPOSED THREAD #
	---------------------------
]]

SMAE_GENERAL = function()
	local IS_IDLING = function()
		return type(shared.SMAE.Idle[1][1]) == "string" and PedIsPlaying(gPlayer, shared.SMAE.Idle[1][1], true) or false
	end
	local IDLE_RESET = function()
		if IS_IDLING() then
			PlayerStopAllActionControllers()
		end
	end
	local IDLE_SET = function()
		if not PedIsPlaying(gPlayer, shared.SMAE.Idle[1][1], true) then
			PedSetActionNode(gPlayer, shared.SMAE.Idle[1][1], shared.SMAE.Idle[1][2])
		end
	end
	
	local IS_FREE = function(PED, STYLE, MOVEMENT)
		return PedIsPlaying(PED, "/Global/Player/Default_KEY", true) or PedIsPlaying(PED, STYLE.."/Default_KEY", true) or
			PedIsPlaying(PED, "/Global/"..MOVEMENT.."/Default_KEY/ExecuteNodes/Free/WalkBasic", true) or
			PedIsPlaying(PED, "/Global/"..MOVEMENT.."/Default_KEY/ExecuteNodes/Free/RunBasic", true) or
			PedIsPlaying(PED, "/Global/"..MOVEMENT.."/Default_KEY/ExecuteNodes/Free/SprintBasic", true)
	end
	local TARGET = {}
	
	while true do
		Wait(0)
		
		shared.SMAE.X, shared.SMAE.Y, shared.SMAE.Z = PlayerGetPosXYZ()
		
		TARGET[1], TARGET[2] = PedGetTargetPed(gPlayer), PedGetGrappleTargetPed(gPlayer)
		
		-------------------------------------
		-- # MOVEMENT & IDLE CONFIGURATIONS #
		-------------------------------------
		
		if shared.SMAE.Movement[1] ~= "Player" and PedHasWeapon(gPlayer, -1) and not shared.gMindControl and shared.gActiveControl then
			if PedGetFlag(gPlayer, 11) then
				PedSetFlag(gPlayer, 11, false)
			end
			
			if IsButtonBeingPressed(7, 0) then
				shared.SMAE.Movement[3], shared.SMAE.Movement[4] = shared.SMAE.Movement[3] + 1, GetTimer()
			elseif GetTimer() >= shared.SMAE.Movement[4] + 300 then
				shared.SMAE.Movement[3] = 0
			end
			
			if IsButtonBeingReleased(7, 0) then
				shared.SMAE.Movement[5] = GetTimer()
			end
			
			if (IS_FREE(gPlayer, shared.SMAE.Player[2][1], shared.SMAE.Movement[1]) or IS_IDLING()) and not PedGetFlag(gPlayer, 2, true) and not PlayerIsInAnyVehicle() then
				if 0.1 <= abs(GetStickValue(16, 0)) + abs(GetStickValue(17, 0)) then
					shared.SMAE.Movement[2] = true
					
					if shared.SMAE.Movement[3] > 1 or IsButtonPressed(7, 0) or GetTimer() < shared.SMAE.Movement[4] + 200 then
						PedSetActionNode(gPlayer, "/Global/"..shared.SMAE.Movement[1].."/Default_KEY/ExecuteNodes/Free/"..(shared.SMAE.Movement[3] > 1 and "SprintBasic" or ((IsButtonPressed(7, 0) or GetTimer() < shared.SMAE.Movement[4] + 200) and "RunBasic" or "WalkBasic")), "Act/Anim/"..shared.SMAE.Movement[1]..".act")
					end
					
					if IsButtonBeingPressed(8, 0) then
						PedSetActionNode(gPlayer, "/Global/Player/JumpActions/Jump", "Act/Anim/Player.act")
					end
					
					if IsButtonPressed(9, 0) and PedIsValid(TARGET[1]) then
						PedSetActionNode(gPlayer, "/Global/Actions/Grapples/RunningTakedown", "Act/Globals.act")
					end
					
					if IsButtonBeingPressed(6, 0) and PedIsPlaying(gPlayer, "/Global/"..shared.SMAE.Movement[1].."/Default_KEY/ExecuteNodes/Free/RunBasic", true) then
						PedSetActionNode(gPlayer, "/Global/Actions/Offense/RunningAttacks/RunningAttacksDirect","Act/Globals.act")
					elseif IsButtonBeingPressed(6, 0) and PedIsPlaying(gPlayer, "/Global/"..shared.SMAE.Movement[1].."/Default_KEY/ExecuteNodes/Free/SprintBasic", true) then
						PedSetActionNode(gPlayer, "/Global/Player/Attacks/Strikes/RunningAttacks/HeavyAttacks/RunShoulder", "Act/Player.act")
					end
				elseif shared.SMAE.Movement[2] then
					shared.SMAE.Movement[2] = false
					PedSetActionNode(gPlayer, unpack(shared.SMAE.Player[2]))
				end
			end
		end
		
		if shared.SMAE.Idle[2] then
			IDLE_SET()
			
			if IS_IDLING() then
				if CTRL.N(15, 0) and not shared.SMAE.Movement[2] then
					IDLE_RESET()
					
					Wait(100)
					PedSetFlag(gPlayer, 2, true)
				end
				
				if PedIsValid(TARGET[1]) or CTRL.N(11, 0) or CTRL.N(13, 0) or CTRL.N(6, 0) or CTRL.N(9, 0) or CTRL.N(8, 0) or F.PMOVING() then
					IDLE_RESET()
				end
			end
		end
		
		----------------------
		-- # TOGGLE SETTINGS #
		----------------------
		
		if shared.SMAE.Settings.Immortal then
			if PedGetFlag(gPlayer, 58) == false then
				PedSetFlag(gPlayer, 58, true)
			end
			
			if PedGetHealth(gPlayer) < 1 then
				local ENEMY = PedGetWhoHitMeLast(gPlayer)
				
				PedSetActionNode(gPlayer, "/Global/HitTree/KnockOuts/"..(PedIsValid(ENEMY) and (PedIsFacingObject(gPlayer, ENEMY, 2, 180) and "Front/KD_DROP_Default" or "Rear/Rear") or "Front/KD_DROP_Default"), "Act/HitTree.act")
				PedSetHealth(gPlayer, 50)
			else
				if PedIsValid(TARGET[2]) and PlayerGetPunishmentPoints() > 200 then
					if ({[0] = true, [7] = true, [8] = true})[PedGetFaction(TARGET[2])] then
						PlayerSetPunishmentPoints(0)
					end
				end
			end
		end
		if shared.SMAE.Settings.Transparent then
			if PedGetFlag(gPlayer, 9) == false then
				PedSetFlag(gPlayer, 9, true)
			end
		else
			if PedGetFlag(gPlayer, 9) == true then
				PedSetFlag(gPlayer, 9, false)
			end
		end
		if shared.SMAE.Settings.Instant or shared.SMAE.Settings.Mute or shared.SMAE.Settings.Harmony then
			for _, PED in {PedFindInAreaXYZ(0, 0, 0, 999999)} do
				if PedIsValid(PED) and PED ~= gPlayer then
					
					if shared.SMAE.Settings.Instant then
						if PedIsHit(PED, 2, 25) and PedGetWhoHitMeLast(PED) == gPlayer then
							PedApplyDamage(PED, PedGetHealth(PED) + 5)
						end
					end
					
					if shared.SMAE.Settings.Mute and not PedGetFlag(PED, 129) then
						PedSetFlag(PED, 129, true)
					end
					
					if shared.SMAE.Settings.Harmony and not PedGetFlag(PED, 19) then
						PedSetFlag(PED, 19, true)
					end
				end
			end
		end
		if shared.SMAE.Settings.Innocent then
			DisablePunishmentSystem(true)
			
			if PedGetFlag(gPlayer, 117) then
				PedSetFlag(gPlayer, 117, false)
			end
			
			if PlayerGetPunishmentPoints() > 0 then
				PlayerSetPunishmentPoints(0)
			end
			
			for S, _ in pairs({[66] = true, [67] = true, [68] = true, [78] = true, [79] = true}) do
				if PedHasGeneratedStimulusOfType(gPlayer, S) then
					PedRemoveStimulus(gPlayer, S)
				end
			end
		end
		if shared.SMAE.Settings.Shot and not shared.gMindControl and shared.gActiveControl then
			if type(shared.gRapidShot) ~= "table" then
				shared.gRapidShot = {}
				
				shared.gRapidShot.SG_T = GetTimer()
				shared.gRapidShot.BL_T = GetTimer()
			end
			
			shared.gRapidShot.Free = true
			
			for _, N in ipairs({"BlockHits", "BellyDown", "BellyUp", "SitOnWall", "TreeCheck", "Dead", "Climb_ON_BOT", "HoistUp_Spawns", "Jump", "HitTree"}) do
				if PedMePlaying(gPlayer, N) then
					shared.gRapidShot.Free = false
					
					break
				end
			end
			
			if shared.gRapidShot.Free and not PlayerIsInAnyVehicle() and not PedGetFlag(gPlayer, 2) then
				if PedHasWeapon(gPlayer, 305) or PedHasWeapon(gPlayer, 396) then
					if GetStickValue(12, 0) >= 1 and shared.gRapidShot.SG_T + 300 < GetTimer() then
						PedSetActionNode(gPlayer, "/Global/Gun/Gun/Actions/Controller/UpperBody/FireActions/SpudG/Release", "Act/Weapons/Gun.act")
						shared.gRapidShot.SG_T = GetTimer()
					end
					
					if IsButtonBeingReleased(12, 0) or PedIsHit(gPlayer, 2, 25) then
						PedLockTarget(gPlayer, -1)
						PlayerStopAllActionControllers()
					end
				end
				
				if PedHasWeapon(gPlayer, 307) and IsButtonBeingReleased(12, 0) then
					if shared.gRapidShot.BL_T + 300 < GetTimer() then
						PedSetActionNode(gPlayer, "/Global/Gun", "Act/Weapons/Gun.act")
						shared.gRapidShot.BL_T = GetTimer()
					end
				end
			end
		end
		if shared.SMAE.Settings.Ammo then
			if not PedGetFlag(gPlayer, 24) then
				PedSetFlag(gPlayer, 24, true)
			end
			
			if not PedHasWeapon(gPlayer, -1) and IsButtonBeingReleased(12, 0) then
				GiveAmmoToPlayer(({[305] = 316, [396] = 316, [307] = 308})[PedGetWeapon(gPlayer)] or PedGetWeapon(gPlayer), 50, false)
			end
		end
		if shared.SMAE.Settings.Lonely then
			StopPedProduction(true)
		end
		if shared.SMAE.Settings.CS_Music then
			MusicAllowPlayDuringCutscenes(true)
		end
		if not shared.SMAE.Settings.Trouble then
			ToggleHUDComponentVisibility(0, false)
		end
		if not shared.SMAE.Settings.Health then
			ToggleHUDComponentVisibility(4, false)
		end
		if not shared.SMAE.Settings.Map then
			ToggleHUDComponentVisibility(11, false)
		end
		if shared.SMAE.Settings.Lap then
			ToggleHUDComponentVisibility(10, true)
		end
		
		if shared.SMAE.Settings.Cinematic then
			CameraSetWidescreen(true)
		end
		if shared.SMAE.Settings.Fire then
			EffectSetGymnFireOn(true)
		end
		if shared.SMAE.Settings.Muddy then
			EffectBlindedbyMud()
		end
		
		-------------
		-- # ETCERA #
		-------------
		
		if PedHasWeapon(gPlayer, 328) or PedHasWeapon(gPlayer, 426) then
			HUDPhotographySetColourUpgrade(PedHasWeapon(gPlayer, 426))
		end
		
		for BUTTON = 0, 15 do
			if _G["IsButton"..(BUTTON == 9 and "" or "Being").."Pressed"](BUTTON, 0) and not shared.SMAE.Button.Hold[BUTTON] then
				shared.SMAE.Button.Hold[BUTTON] = true
			end
			
			if IsButtonBeingReleased(BUTTON, 0) and shared.SMAE.Button.Hold[BUTTON] then
				shared.SMAE.Button.Hold[BUTTON] = false
			end
		end
	end
end


--[[
	----------------------------
	# CUSTOMIZED STRAFE THREAD #
	----------------------------
]]

SMAE_STRAFE = function()
	local GET_NODE = function(TABLE)
		local RANDOM = random(1, table.getn(TABLE))
		
		return TABLE[RANDOM][1], TABLE[RANDOM][2]
	end
	
	local GET_TWIN = function(TABLE, MODE, DATA)
		local RESULT = {}
		
		for I, SOURCE in ipairs(TABLE) do
			if SOURCE.ANIM ~= DATA.ANIM then
				if MODE == "BIND" then
					if SOURCE.KEY == DATA.KEY and SOURCE.GRAPPLE == DATA.GRAPPLE and SOURCE.MOUNT == DATA.MOUNT then
						table.insert(RESULT, {SOURCE.ANIM, SOURCE.ACT})
					end
				end
			end
		end
		
		table.insert(RESULT, {DATA.ANIM, DATA.ACT})
		
		return RESULT
	end
	
	local SET_ANIM = function(PED, ANIM, ACT)
		if PED == gPlayer then
			PedSetAITree(gPlayer, "/Global/DarbyAI", "Act/AI_DARBY_2_B.act")
			PedSetFlag(gPlayer, 87, true)
			
			if ANIM == "/Global/WrestlingACT/Attacks/Grapples/Grapples/BackGrapples/Choke" and not PedGetFlag(gPlayer, 2) then
				PedSetFlag(gPlayer, 2, true)
				_G.RESTORE_CROUCH = true
			end
			
			PedSetActionNode(gPlayer, ANIM, ACT)
			
			if _G.RESTORE_CROUCH then
				PedSetFlag(gPlayer, 2, false)
				_G.RESTORE_CROUCH = nil
			end
			
			PedSetFlag(gPlayer, 87, false)
			PedSetAITree(gPlayer, "/Global/PlayerAI", "Act/PlayerAI.act")
		else
			PedSetActionNode(PED, ANIM, ACT)
		end
	end
	
	local TARGET = {}
	
	while true do
		TARGET = {PedGetTargetPed(gPlayer), PedGetGrappleTargetPed(gPlayer)}
		
		if PedHasWeapon(gPlayer, -1) and not shared.PlayerInClothingManager and not shared.playerShopping and not shared.gMindControl and shared.gActiveControl then
			for N1, STRAFE_BIND in ipairs(shared.SMAE.Strafe.Bind) do
				if not STRAFE_BIND.GRAPPLE and not STRAFE_BIND.MOUNT then
					if PedMePlaying(gPlayer, "DEFAULT_KEY") and not PedMePlaying(gPlayer, "RisingAttacks") and _G["IsButton"..(STRAFE_BIND.KEY == 9 and "" or "Being").."Pressed"](STRAFE_BIND.KEY, 0) then
						if STRAFE_BIND.KEY == 9 then
							if PedIsValid(TARGET[1]) then
								SET_ANIM(gPlayer, GET_NODE(GET_TWIN(
									shared.SMAE.Strafe.Bind, "BIND", {ANIM = STRAFE_BIND.ANIM, ACT = STRAFE_BIND.ACT, KEY = STRAFE_BIND.KEY, GRAPPLE = STRAFE_BIND.GRAPPLE, MOUNT = STRAFE_BIND.MOUNT}
								)))
							end
						else
							SET_ANIM(gPlayer, GET_NODE(GET_TWIN(
								shared.SMAE.Strafe.Bind, "BIND", {ANIM = STRAFE_BIND.ANIM, ACT = STRAFE_BIND.ACT, KEY = STRAFE_BIND.KEY, GRAPPLE = STRAFE_BIND.GRAPPLE, MOUNT = STRAFE_BIND.MOUNT}
							)))
						end
					end
				end
				
				if STRAFE_BIND.GRAPPLE and PedIsValid(TARGET[2]) and ((PedMePlaying(gPlayer, "Hold_Idle") and PedMePlaying(gPlayer, "GrappleRotate")) or PedMePlaying(gPlayer, "Punch_Hold_Idle")) and _G["IsButton"..(STRAFE_BIND.KEY == 9 and "" or "Being").."Pressed"](STRAFE_BIND.KEY, 0) then
					SET_ANIM(gPlayer, GET_NODE(GET_TWIN(
						shared.SMAE.Strafe.Bind, "BIND", {ANIM = STRAFE_BIND.ANIM, ACT = STRAFE_BIND.ACT, KEY = STRAFE_BIND.KEY, GRAPPLE = STRAFE_BIND.GRAPPLE, MOUNT = STRAFE_BIND.MOUNT}
					)))
				end
				
				if STRAFE_BIND.MOUNT and PedIsValid(TARGET[2]) and PedMePlaying(gPlayer, "MountIdle") and not PedMePlaying(gPlayer, "Rcv") and _G["IsButton"..(STRAFE_BIND.KEY == 9 and "" or "Being").."Pressed"](STRAFE_BIND.KEY, 0) then
					SET_ANIM(gPlayer, GET_NODE(GET_TWIN(
						shared.SMAE.Strafe.Bind, "BIND", {ANIM = STRAFE_BIND.ANIM, ACT = STRAFE_BIND.ACT, KEY = STRAFE_BIND.KEY, GRAPPLE = STRAFE_BIND.GRAPPLE, MOUNT = STRAFE_BIND.MOUNT}
					)))
				end
			end
			
			for N2, STRAFE_ETC in ipairs(shared.SMAE.Strafe.Other) do
				if PedIsPlaying(gPlayer, STRAFE_ETC.TRIGGER, true) then
					if STRAFE_ETC.METHOD == 1 then
						SET_ANIM(gPlayer, GET_NODE(GET_TWIN(
							shared.SMAE.Strafe.Other, "OTHER", {ANIM = STRAFE_ETC.ANIM, ACT = STRAFE_ETC.ACT, TRIGGER = STRAFE_ETC.TRIGGER, KEY = STRAFE_ETC.KEY, METHOD = STRAFE_ETC.METHOD}
						)))
					else
						local PASS = true
						
						while true do
							while PedIsPlaying(gPlayer, STRAFE_ETC.TRIGGER, true) do
								if PedIsHit(gPlayer, 2, 25) then
									PASS = false; break
								end
								
								Wait(0)
							end
							
							if PASS then
								SET_ANIM(gPlayer, GET_NODE(GET_TWIN(
									shared.SMAE.Strafe.Other, "OTHER", {ANIM = STRAFE_ETC.ANIM, ACT = STRAFE_ETC.ACT, TRIGGER = STRAFE_ETC.TRIGGER, KEY = STRAFE_ETC.KEY, METHOD = STRAFE_ETC.METHOD}
								)))
							end
							
							break
						end
					end
				end
			end
			
			if table.getn(shared.SMAE.Strafe.Block) > 0 then
				if PedIsValid(TARGET[1]) and PedMePlaying(gPlayer, "DEFAULT_KEY") and (PedMePlaying(TARGET[1], "Offense") or PedMePlaying(TARGET[1], "Attacks") or PedMePlaying(TARGET[1], "Counter") or PedMePlaying(TARGET[1], "RisingAttacks")) then
					local SLOT = random(1, table.getn(shared.SMAE.Strafe.Block))
					
					SET_ANIM(gPlayer, shared.SMAE.Strafe.Block[SLOT].ANIM, shared.SMAE.Strafe.Block[SLOT].ACT)
				end
			end
		end
		
		if PedMePlaying(gPlayer, "DEFAULT_KEY") and shared.SMAE.Player[2][1] == "/Global/J_Damon" then
			if IsButtonPressed(9, 0) and PedIsValid(PedGetTargetPed(gPlayer)) then
				PedSetActionNode(gPlayer, "/Global/J_Damon/Offense/SpecialStart/StartRun", "Act/Anim/J_Damon.act")
			end
		end
		
		Wait(0)
	end
end


--[[
	-----------------------------
	# REPROGRAMMED STYLE THREAD #
	-----------------------------
]]

SMAE_STYLE = function()
	local IS_SAFELY_PRESSED = function(B, C, P)
		if type(shared.STRAFE_KEY) == "table" and shared.STRAFE_KEY[B] then
			return false
		end
		
		if _G["IsButton"..(B == 9 and "" or "Being").."Pressed"](B, C) then
			return true
		end
		return false
	end
	
	local IS_ADULT_MALE = function(PED)
		local ID = {
			[56] = true, [76] = true, [77] = true, [84] = true, [86] = true, [89] = true, [100] = true, [101] = true,
			[103] = true, [104] = true, [105] = true, [108] = true, [113] = true, [114] = true, [115] = true, [116] = true,
			[116] = true, [123] = true, [124] = true, [127] = true, [128] = true, [144] = true, [148] = true, [149] = true,
			[152] = true, [156] = true, [180] = true, [190] = true, [194] = true, [195] = true, [222] = true, [223] = true,
			[236] = true, [237] = true, [252] = true, [253] = true, [254] = true,
		}
		
		return ID[F.PGID(PED)] or false
	end
	
	local IS_ADULT_FEMALE = function(PED)
		local ID = {
			[78] = true, [79] = true, [80] = true, [81] = true, [120] = true, [143] = true, [191] = true, [192] = true, [193] = true,
		}
		
		return ID[F.PGID(PED)] or false
	end
	
	local IS_TEACHER_MALE = function(PED)
		local ID = {
			[55] = true, [56] = true, [57] = true, [61] = true, [64] = true, [65] = true, [229] = true, [248] = true, [249] = true,
		}
			
		return ID[F.PGID(PED)] or false
	end
	
	local IS_TEACHER_FEMALE = function(PED)
		local ID = {
			[54] = true, [58] = true, [59] = true, [60] = true, [62] = true, [63] = true, [58] = true, [221] = true
		}
			
		return ID[F.PGID(PED)] or false
	end
	
	local IS_STUDENT_FEMALE = function(PED)
		local ID = {
			[2] = true, [3] = true, [14] = true, [25] = true, [38] = true, [39] = true, [48] = true, [67] = true, [90] = true,
			[93] = true, [94] = true, [95] = true, [96] = true, [166] = true, [167] = true, [175] = true, [180] = true,
			[181] = true, [182] = true, [230] = true
		}
		
		return ID[F.PGID(PED)] or false
	end
	
	local IS_PREFECT = function(PED)
		local ID = {
			[49] = true, [50] = true, [51] = true, [52] = true,
		}
		
		return ID[F.PGID(PED)] or false
	end
	
	local IS_ORDERLY = function(PED)
		local ID = {
			[53] = true, [158] = true,
		}
		
		return ID[F.PGID(PED)] or false
	end
	
	local SET_ANIM = function(PED, ANIM, ACT, AI, TARGET)
		local IS_CHOKE = false
		
		if AI then
			PedSetAITree(gPlayer, "/Global/DarbyAI", "Act/AI_DARBY_2_B.act")
		end
		if TARGET then
			PedSetFlag(gPlayer, 87, true)
		end
		
		PedSetActionNode(PED, ANIM, ACT)
		
		if TARGET then
			PedSetFlag(gPlayer, 87, false)
		end
		if AI then
			PedSetAITree(gPlayer, "/Global/PlayerAI", "Act/PlayerAI.act")
		end
	end
	
	local NEXT_ANIM = function(ANIM, ACT, TRIGGER, MS, AI, TARGET)
		local TIMER = {GetTimer(), false}
		while true do
			Wait(0)
			
			if PedMePlaying(gPlayer, TRIGGER) then
				if TIMER[1] + MS < GetTimer() then
					if IsButtonBeingPressed(6, 0) then
						TIMER[2] = true
						break
					end
				end
			else
				break
			end
		end
		
		if TIMER[2] then
			SET_ANIM(gPlayer, ANIM, ACT, AI, TARGET)
		end
		
		return TIMER[2]
	end
	
	local QUEST_EXCEPTION = {
		"1_02B", "3_08", "2_08", "2_09", "3_01C", "4_05", "4_06", "6_01", "5_03", "3_R09_J3",
		"C_WRESTLING_1", "C_WRESTLING_2", "C_WRESTLING_3", "C_WRESTLING_4", "C_WRESTLING_5",
		"1_11x1", "1_11x2", "3_R09_P3", "2_R11_Chad", "2_R11_Bryce", "2_R11_Justin", "2_R11_Parker",
		"2_R11_Random", "C_Dodgeball_1", "C_Dodgeball_2", "C_Dodgeball_3", "C_Dodgeball_4",
		"C_Dodgeball_5", "3_01C"
	}
	
	while true do
		Wait(0)
		
		if not PedIsModel(gPlayer, 0) or shared.SMAE.Player[2][1] ~= "/Global/Player" then
			
			if not PedIsModel(gPlayer, 0) then
				if shared.PlayerInClothingManager then
					PlayerSwapModel("player")
					while shared.PlayerInClothingManager do
						Wait(0)
					end
					
					F.SWAP(true, shared.SMAE.Player[1], shared.SMAE.Player[2])
				end
				
				if shared.playerShopping then
					PlayerSwapModel("player")
					while shared.playerShopping do
						Wait(0)
					end
					
					F.SWAP(true, shared.SMAE.Player[1], shared.SMAE.Player[2])
				end
				
				for _, M in ipairs(QUEST_EXCEPTION) do
					if MissionActiveSpecific(M) then
						F.SWAP(true, "player", {"/Global/Player", "Act/Anim/Player.act"})
					end
				end
			end
			
			if not shared.gMindControl and shared.gActiveControl then
				if PedMePlaying(gPlayer, "DEFAULT_KEY") then
					local PED = PedGetTargetPed(gPlayer)
					
					if PedIsValid(PED) then
						local X, Y, Z = PedGetPosXYZ(PED)
						local DISTANCE = abs(shared.SMAE.X - X) + abs(shared.SMAE.Y - Y) + abs(shared.SMAE.Z - Z)
						
						if not PedGetFlag(gPlayer, 2) then
							local TAUNT = PedIsModel(gPlayer, 0) and "PLAYER_TAUNT" or "TAUNT"
							local GREET = PedIsModel(gPlayer, 0) and "PLAYER_GREET" or "GREET"
							
							if shared.SMAE.Player[2][1] ~= "/Global/Player" and PedHasWeapon(gPlayer, -1) then
								if IS_SAFELY_PRESSED(8, 0) then
									if PedMePlaying(gPlayer, "DEFAULT_KEY") then
										if DISTANCE > 2 or PedMePlaying(PED, "HitTree") then
											PedSetActionNode(gPlayer, "/Global/Player/Social_Speech/Taunts", "Act/Player.act")
											
											if not SoundSpeechPlaying(gPlayer, TAUNT) then
												SoundPlayAmbientSpeechEvent(gPlayer, TAUNT)
											end
										else
											if PedGetHealth(PED) > GameGetPedStat(PED, 63) then
												PedSetActionNode(gPlayer, "/Global/Player/Social_Actions/HarassMoves/Shove_Still/Shove", "Act/Player.act")
												
												if not SoundSpeechPlaying(gPlayer, TAUNT) then
													SoundPlayAmbientSpeechEvent(gPlayer, TAUNT)
												end
											else
												if PedGetHealth(PED) > 0 and PedMePlaying(PED, "DEFAULT_KEY") then
													PedSetGrappleTarget(gPlayer, PED)
													PedSetActionNode(gPlayer, "/Global/Ambient/SocialAnims/SocialHumiliateAttack/AnimLoadTrigger", "Act/Anim/Ambient.act")
												else
													PedSetActionNode(gPlayer, "/Global/Player/Social_Speech/Taunts", "Act/Player.act")
													
													if not SoundSpeechPlaying(gPlayer, TAUNT) then
														SoundPlayAmbientSpeechEvent(gPlayer, TAUNT)
													end
												end
											end
										end
									end
								end
								
								if IS_SAFELY_PRESSED(7, 0) then
									if not F.PMOVING() then
										PedSetActionNode(gPlayer, "/Global/Player/Social_Speech/Greet_Speech", "Act/Player.act")
										
										if not SoundSpeechPlaying(gPlayer, GREET) then
											SoundPlayAmbientSpeechEvent(gPlayer, GREET)
										end
									end
								end
							elseif (shared.SMAE.Player[2][1] == "/Global/Player" or not PedHasWeapon(gPlayer, -1)) then
								if IS_SAFELY_PRESSED(8, 0) then
									if PedMePlaying(gPlayer, "DEFAULT_KEY") then
										if not SoundSpeechPlaying(gPlayer, TAUNT) then
											SoundPlayAmbientSpeechEvent(gPlayer, TAUNT)
										end
									end
								elseif IS_SAFELY_PRESSED(7, 0) then
									if not F.PMOVING() then
										if not SoundSpeechPlaying(gPlayer, GREET) then
											SoundPlayAmbientSpeechEvent(gPlayer, GREET)
										end
									end
								end
							end
						else
							if IS_SAFELY_PRESSED(9, 0) then
								PedSetActionNode(gPlayer, IsButtonPressed(7, 0) and "/Global/Actions/Grapples/RunningTakedown" or "/Global/Actions/Grapples/Front/Grapples/GrappleAttempt", "Act/Globals.act")
							end
						end
					end
				end
				
				if GetStickValue(17, 0) < 0.08 and shared.SMAE.Player[2][1] ~= "/Global/Player" and PedHasWeapon(gPlayer, -1) and IS_SAFELY_PRESSED(15, 0) then
					PedSetFlag(gPlayer, 2, not PedGetFlag(gPlayer, 2))
				end
				
				if shared.SMAE.Player[2][1] ~= "/Global/Player" and PedHasWeapon(gPlayer, -1) then
					if not MissionActiveSpecific("3_B") and not PedGetFlag(gPlayer, 2) then
						PedSetAITree(gPlayer, "/Global/PlayerAI", "Act/PlayerAI.act")
					end
				
					if PedMePlaying(gPlayer, "DEFAULT_KEY") and IS_SAFELY_PRESSED(6, 0) and not PedIsValid(PedGetGrappleTargetPed(gPlayer)) and not PlayerIsInAnyVehicle() and not ATTACKING_STYLE then
						if not ({["/Global/N_Earnest"] = true, ["/Global/DO_Melee_A"] = true, ["/Global/Hobo_Blocker"] = true, ["/Global/WrestlingACT"] = true, ["/Global/AN_DOG"] = true, ["/Global/PunchBagBS"] = true})[shared.SMAE.Player[2][1]] then
							PedSetActionNode(gPlayer, shared.SMAE.Player[2][1].."/Default_KEY/ExecuteNodes/LocomotionOverride/Combat/CombatBasic", shared.SMAE.Player[2][2])
							
							ATTACKING_STYLE = true
						end
					end
				end
			end
			
			if ATTACKING_STYLE then
				if not PUNCH_TIMER then
					PUNCH_TIMER = GetTimer()
				else
					if PUNCH_TIMER + 300 < GetTimer() then
						TAKE_ACTION = "HEAVY"
					else
						if IsButtonBeingReleased(6, 0) then
							TAKE_ACTION = "LIGHT"
						end
					end
				end
				
				if TAKE_ACTION then
					local TARGET = PedGetTargetPed(gPlayer)
					
					if shared.SMAE.Player[2][1] == "/Global/BOSS_Russell" then
						if TAKE_ACTION == "LIGHT" then
							if PedIsValid(TARGET) and (PedMePlaying(TARGET, "BellyUp") or PedMePlaying(TARGET, "BellyDown") or PedMePlaying(TARGET, "SitOnWall")) then
								SET_ANIM(gPlayer, "/Global/BOSS_Russell/Offense/GroundAttack/GroundStomp1", "Act/Anim/BOSS_Russell.act")
							else
								SET_ANIM(gPlayer, "/Global/BOSS_Russell/Offense/Short/Strikes/LightAttacks/OverHand", "Act/Anim/BOSS_Russell.act", true)
							end
						else
							SET_ANIM(gPlayer, "/Global/BOSS_Russell/Offense/Medium/Strikes/HeavyAttacks/HammerStrike_L", "Act/Anim/BOSS_Russell.act")
						end
					end
					
					if shared.SMAE.Player[2][1] == "/Global/BOSS_Darby" then
						if TAKE_ACTION == "LIGHT" then
							SET_ANIM(gPlayer, "/Global/BOSS_Darby/Offense/Medium/Medium/HeavyAttacks/JAB", "Act/Anim/BOSS_Darby.act", true, true)
							
							local ACTION = NEXT_ANIM("/Global/BOSS_Darby/Offense/Medium/Medium/HeavyAttacks/JAB/Cross", "Act/Anim/BOSS_Darby.act", "JAB", 300, true)
							if ACTION then
								ACTION = NEXT_ANIM("/Global/BOSS_Darby/Offense/Short/Strikes/LightAttacks/LeftHook", "Act/Anim/BOSS_Darby.act", "Cross", 300, true)
								
								if ACTION then
									NEXT_ANIM("/Global/BOSS_Darby/Offense/Short/Strikes/LightAttacks/LeftHook/FinishingCross", "Act/Anim/BOSS_Darby.act", "LeftHook", 350, true)
								end
							end
						else
							SET_ANIM(gPlayer, "/Global/BOSS_Darby/Offense/Short/Grapples/HeavyAttacks/Catch_Throw", "Act/Anim/BOSS_Darby.act")
						end
					end
					
					if shared.SMAE.Player[2][1] == "/Global/G_Johnny" then -- missing movement (3)
						if TAKE_ACTION == "LIGHT" then
							SET_ANIM(gPlayer, "/Global/G_Johnny/Offense/Short/Strikes/LightAttacks/Combo2/Jab", "Act/Anim/G_Johnny.act", true, true)
							
							local ACTION = NEXT_ANIM("/Global/G_Johnny/Offense/Short/Strikes/LightAttacks/Combo2/Jab/RightHook", "Act/Anim/G_Johnny.act", "Jab", 200, true, true)
							if ACTION then
								NEXT_ANIM("/Global/G_Johnny/Offense/Short/Strikes/LightAttacks/Combo2/Jab/RightHook/LeftHook", "Act/Anim/G_Johnny.act", "RightHook", 250, true, true)
							end
						else
							SET_ANIM(gPlayer, "/Global/G_Johnny/Offense/"..(random(1, 2) == 1 and "Short/Strikes/HeavyKick/HeavyKick" or "Medium/Strikes/HeavyAttack/HeavyKick"), "Act/Anim/G_Johnny.act", true, true)
						end
					end
					
					if shared.SMAE.Player[2][1] == "/Global/J_Ted" then
						if TAKE_ACTION == "LIGHT" then
							SET_ANIM(gPlayer, "/Global/J_Ted/Offense/Short/Strikes/LightAttacks/JAB", "Act/Anim/J_Ted.act", true, true)
							
							local ACTION = NEXT_ANIM("/Global/J_Ted/Offense/Short/Strikes/LightAttacks/JAB/Elbow", "Act/Anim/J_Ted.act", "JAB", 350, true, true)
							if ACTION then
								NEXT_ANIM("/Global/J_Ted/Offense/Short/Strikes/LightAttacks/JAB/Elbow/HeavyAttacks/Uppercut", "Act/Anim/J_Ted.act", "Elbow", 400, true, true)
							end
						else
							SET_ANIM(gPlayer, "/Global/J_Ted/Offense/Medium/Grapples/GrapplesAttempt", "Act/Anim/J_Ted.act", true, true)
						end
					end
					
					if shared.SMAE.Player[2][1] == "/Global/DO_Edgar" then
						if TAKE_ACTION == "LIGHT" then
							SET_ANIM(gPlayer, "/Global/DO_Edgar/Offense/Short/LightAttacks/Punch1", "Act/Anim/DO_Edgar.act", true)
							
							local ACTION = NEXT_ANIM("/Global/DO_Edgar/Offense/Short/LightAttacks/Punch1/Punch2", "Act/Anim/DO_Edgar.act", "Punch1", 350, true)
							if ACTION then
								NEXT_ANIM("/Global/DO_Edgar/Offense/Short/LightAttacks/Punch1/Punch2/HeavyAttacks/Punch3", "Act/Anim/DO_Edgar.act", "Punch2", 400, true)
							end
						else
							SET_ANIM(gPlayer, "/Global/DO_Striker_A/Offense/Medium/HeavyAttacks/OverhandSwing", "Act/Anim/DO_Striker_A.act", true, true)
						end
					end
					
					if shared.SMAE.Player[2][1] == "/Global/Nemesis" then
						if TAKE_ACTION == "LIGHT" then
							SET_ANIM(gPlayer, "/Global/Nemesis/Offense/Short/Strikes/LightAttacks/LeftHook", "Act/Anim/Nemesis.act", true, true)
							
							local ACTION = NEXT_ANIM("/Global/Nemesis/Offense/Short/Strikes/LightAttacks/LeftHook/RightCross", "Act/Anim/Nemesis.act", "LeftHook", 300, true, true)
							if ACTION then
								NEXT_ANIM("/Global/Nemesis/Offense/Short/Strikes/LightAttacks/LeftHook/RightCross/HeavyAttacks/HeavyPunch2", "Act/Anim/Nemesis.act", "RightCross", 300, true, true)
							end
						else
							SET_ANIM(gPlayer, "/Global/Nemesis/Offense/Short/Strikes/HeavyAttacks/HeavyPunch1", "Act/Anim/Nemesis.act", true)
						end
					end
					
					if shared.SMAE.Player[2][1] == "/Global/Russell_102" then
						if TAKE_ACTION == "LIGHT" then
							SET_ANIM(gPlayer, "/Global/Russell_102/Offense/Short/Strikes/LightAttacks/WindMill_R", "Act/Anim/Russell_102.act", true)
							
							NEXT_ANIM("/Global/Russell_102/Offense/Short/Strikes/LightAttacks/WindMill_R/WindMill_L", "Act/Anim/Russell_102.act", "WindMill_R", 300, true)
						else
							SET_ANIM(gPlayer, "/Global/Russell_102/Offense/Short/Medium/RisingAttacks", "Act/Anim/Russell_102.act", true)
						end
					end
					
					if shared.SMAE.Player[2][1] == "/Global/P_Bif" then -- buggy style, no matter what
						if TAKE_ACTION == "LIGHT" then
							SET_ANIM(gPlayer, "/Global/P_Bif/Offense/Short/LightAttacks/JAB", "act/anim/P_Bif.act", true)
							
							NEXT_ANIM("/Global/P_Bif/Offense/Short/LightAttacks/JAB/Cross", "act/anim/P_Bif.act", "JAB", 300, true)
						else
							SET_ANIM(gPlayer, "/Global/P_Bif/Offense/Short/HeavyAttacks/"..(random(1, 2) == 1 and "LeftHook" or "RightHook"), "act/anim/P_Bif.act", true, true)
						end
					end
					
					if shared.SMAE.Player[2][1] == "/Global/Norton" and PedHasWeapon(gPlayer, 324) then -- light and heavy attack does not work, recommended to remove (1)
						if TAKE_ACTION == "LIGHT" then
							SET_ANIM(gPlayer, "/Global/Norton/Offense/Short/"..(random(1, 2) == 1 and "Swing1" or "Swing2"), "Act/Anim/3_05_Norton.act", true)
						else
							SET_ANIM(gPlayer, "/Global/Norton/Offense/Medium/Unblockable/PowerSwing", "Act/Anim/3_05_Norton.act", true)
						end
					end
					
					if shared.SMAE.Player[2][1] == "/Global/J_Damon" then -- missing movement (1)
						SET_ANIM(gPlayer, "/Global/J_Damon/Offense/Medium/Grapples/GrapplesAttempt", "Act/Anim/J_Damon.act", true)
					end
					
					if shared.SMAE.Player[2][1] == "/Global/Authority" then
						SET_ANIM(gPlayer, "/Global/Authority/Defense/Counter/Counter", "Act/Anim/Authority.act", true)
					end
					
					if shared.SMAE.Player[2][1] == "/Global/LE_Orderly_A" then
						SET_ANIM(gPlayer, "/Global/LE_Orderly_A/Offense/Short/Grapple/GrappleAttempt", "Act/Anim/LE_Orderly_A.act", true)
					end
					
					if shared.SMAE.Player[2][1] == "/Global/TE_Secretary" then
						SET_ANIM(gPlayer, "/Global/TE_Secretary/Offense/Short/HeavyAttacks/NutKick", "Act/Anim/TE_Secretary.act", true)
					end
					
					if shared.SMAE.Player[2][1] == "/Global/TE_Female_A" then
						SET_ANIM(gPlayer, "/Global/TE_Female_A/Offense/Short/Grapples/GrappleAttempt", "Act/Anim/TE_Female_A.act", true)
					end
					
					if shared.SMAE.Player[2][1] == "/Global/B_Striker_A" then
						if TAKE_ACTION == "LIGHT" then
							SET_ANIM(gPlayer, "/Global/B_Striker_A/Offense/Short/Strikes/LightAttacks/Windmill_R", "Act/Anim/B_Striker_A.act", true)
							
							NEXT_ANIM("/Global/B_Striker_A/Offense/Short/Strikes/LightAttacks/Windmill_R/Windmill_L", "Act/Anim/B_Striker_A.act", "Windmill_R", 350, true)
						else
							SET_ANIM(gPlayer, "/Global/B_Striker_A/Offense/Short/Strikes/HeavyAttacks/GutKick/GutKick_R", "Act/Anim/B_Striker_A.act")
						end
					end
					
					if shared.SMAE.Player[2][1] == "/Global/1_03_Davis" then
						if TAKE_ACTION == "LIGHT" then
							SET_ANIM(gPlayer, "/Global/1_03_Davis/Offense/Short/Strikes/LightAttacks/Windmill_R", "Act/Anim/1_03_Davis.act", true)
							
							NEXT_ANIM("/Global/1_03_Davis/Offense/Short/Strikes/LightAttacks/Windmill_R/Windmill_L", "Act/Anim/1_03_Davis.act", "Windmill_R", 350, true)
						else
							SET_ANIM(gPlayer, "/Global/1_03_Davis/Offense/Short/Strikes/HeavyAttacks/"..(random(1, 2) == 1 and "GutKick/GutKick_R" or "SwingPunch/SwingPunch_R"), "Act/Anim/1_03_Davis.act")
						end
					end
					
					if shared.SMAE.Player[2][1] == "/Global/P_Striker_A" then
						if TAKE_ACTION == "LIGHT" then
							SET_ANIM(gPlayer, "/Global/P_Striker_A/Offense/Short/Strikes/LightAttacks/JAB", "Act/Anim/P_Striker_A.act", true, true)
							
							local ACTION = NEXT_ANIM("/Global/P_Striker_A/Offense/Short/Strikes/LightAttacks/JAB/Cross", "Act/Anim/P_Striker_A.act", "JAB", 300, true)
							if ACTION then
								NEXT_ANIM("/Global/P_Striker_A/Offense/Short/Strikes/LightAttacks/LeftHook", "Act/Anim/P_Striker_A.act", "Cross", 300, true)
							end
						else
							SET_ANIM(gPlayer, "/Global/P_Striker_A/Offense/Short/Strikes/HeavyAttacks/Uppercut", "Act/Anim/P_Striker_A.act")
						end
					end
					
					if shared.SMAE.Player[2][1] == "/Global/P_Striker_B" then
						if TAKE_ACTION == "LIGHT" then
							SET_ANIM(gPlayer, "/Global/P_Striker_B/Offense/Short/Strikes/LightAttacks/LeftJab", "Act/Anim/P_Striker_B.act", true)
							
							local ACTION = NEXT_ANIM("/Global/P_Striker_B/Offense/Short/Strikes/LightAttacks/LeftJab/Hook", "Act/Anim/P_Striker_B.act", "LeftJab", 200, true)
							if ACTION then
								NEXT_ANIM("/Global/P_Striker_B/Offense/Short/Strikes/HeavyAttacks/Hook2", "Act/Anim/P_Striker_B.act", "Hook", 300, true)
							end
						else
							SET_ANIM(gPlayer, "/Global/P_Striker_B/Offense/Short/Strikes/Unblockable/HeavyPunchCharge", "act/anim/P_Striker_B.act")
						end
					end
					
					if shared.SMAE.Player[2][1] == "/Global/P_Grappler_A" then
						if TAKE_ACTION == "LIGHT" then
							SET_ANIM(gPlayer, "/Global/P_Grappler_A/Offense/Short/Strikes/LightAttacks/LeftJabHead", "Act/Anim/P_Grappler_A.act", true)
							
							NEXT_ANIM("/Global/P_Grappler_A/Offense/Short/Strikes/LightAttacks/LeftJabHead/LeftJabBody", "Act/Anim/P_Grappler_A.act", "LeftJabHead", 300, true)
						else
							SET_ANIM(gPlayer, "/Global/P_Grappler_A/Offense/Short/Strikes/Unblockable/HeavyPunchCharge", "Act/Anim/P_Grappler_A.act")
						end
					end
					
					if shared.SMAE.Player[2][1] == "/Global/G_Striker_A" then
						if TAKE_ACTION == "LIGHT" then
							if PedIsValid(TARGET) and (PedMePlaying(TARGET, "BellyUp") or PedMePlaying(TARGET, "BellyDown") or PedMePlaying(TARGET, "SitOnWall")) then
								SET_ANIM(gPlayer, "/Global/G_Striker_A/Offense/GroundAttack/GroundPunch", "Act/Anim/G_Striker_A.act", true)
							else
								SET_ANIM(gPlayer, "/Global/G_Striker_A/Offense/Short/Strikes/LightAttacks/RightHook", "Act/Anim/G_Striker_A.act", true)
								
								local ACTION = NEXT_ANIM("/Global/G_Striker_A/Offense/Short/Strikes/LightAttacks/RightHook/LeftHook", "Act/Anim/G_Striker_A.act", "RightHook", 250, true)
								if ACTION then
									NEXT_ANIM("/Global/G_Striker_A/Offense/Short/Strikes/LightAttacks/RightHook/LeftHook/RightStomach", "Act/Anim/G_Striker_A.act", "LeftHook", 300, true, true)
								end
							end
						else
							SET_ANIM(gPlayer, "/Global/G_Striker_A/Offense/Short/Strikes/HeavyAttacks/HeavyKnee", "Act/Anim/G_Striker_A.act", true)
						end
					end
					
					if shared.SMAE.Player[2][1] == "/Global/G_Melee_A" then
						if TAKE_ACTION == "LIGHT" then
							if PedIsValid(TARGET) and (PedMePlaying(TARGET, "BellyUp") or PedMePlaying(TARGET, "BellyDown") or PedMePlaying(TARGET, "SitOnWall")) then
								SET_ANIM(gPlayer, "/Global/G_Melee_A/Offense/GroundAttack/GroundPunch", "Act/Anim/G_Melee_A.act", true)
							else
								SET_ANIM(gPlayer, "/Global/G_Melee_A/Offense/Short/Strikes/LightAttacks/RightHook", "Act/Anim/G_Melee_A.act", true)
								
								local ACTION = NEXT_ANIM("/Global/G_Melee_A/Offense/Short/Strikes/LightAttacks/RightHook/LeftHook", "Act/Anim/G_Melee_A.act", "RightHook", 400, true)
								if ACTION then
									NEXT_ANIM("/Global/G_Melee_A/Offense/Short/Strikes/LightAttacks/RightHook/LeftHook/RightStomach", "Act/Anim/G_Melee_A.act", "LeftHook", 300, true)
								end
							end
						else
							SET_ANIM(gPlayer, "/Global/G_Melee_A/Offense/Medium/Strikes/HeavyAttacks/HeavyKick", "act/anim/G_Melee_A.act", true)
						end
					end
					
					if shared.SMAE.Player[2][1] == "/Global/G_Grappler_A" then
						if TAKE_ACTION == "LIGHT" then
							SET_ANIM(gPlayer, "/Global/G_Grappler_A/Offense/Short/Strikes/HeavyAttacks/RightHook", "Act/Anim/G_Grappler_A.act", true)
							
							NEXT_ANIM("/Global/G_Grappler_A/Offense/Short/Strikes/HeavyAttacks/RightHook/Uppercut", "Act/Anim/G_Grappler_A.act", "RightHook", 300, true)
						else
							SET_ANIM(gPlayer, "/Global/G_Grappler_A/Offense/Short/Strikes/HeavyAttacks/BootKick", "act/anim/G_Grappler_A.act", true)
						end
					end
					
					if shared.SMAE.Player[2][1] == "/Global/G_Ranged_A" then
						if TAKE_ACTION == "LIGHT" then
							SET_ANIM(gPlayer, "/Global/G_Ranged_A/Offense/Short/Strikes/LightAttacks/RightHook", "Act/Anim/G_Ranged_A.act", true)
							
							NEXT_ANIM("/Global/G_Ranged_A/Offense/Short/Strikes/LightAttacks/RightHook/HeavyKnee", "Act/Anim/G_Ranged_A.act", "RightHook", 300, true)
						else
							SET_ANIM(gPlayer, "/Global/G_Ranged_A/Offense/Medium/Strikes/HeavyAttacks/HeavyKnee", "Act/Anim/G_Ranged_A.act")
						end
					end
					
					if shared.SMAE.Player[2][1] == "/Global/N_Striker_A" then
						if TAKE_ACTION == "LIGHT" then
							SET_ANIM(gPlayer, "/Global/N_Striker_A/Offense/Short/Strikes/LightAttacks/NerdJab", "Act/Anim/N_Striker_A.act", true)
							
							NEXT_ANIM("/Global/N_Striker_A/Offense/Short/Strikes/LightAttacks/NerdJab/NerdHook", "Act/Anim/N_Striker_A.act", "NerdJab", 300, true)
						else
							SET_ANIM(gPlayer, "/Global/N_Striker_A/Offense/Short/Strikes/HeavyAttacks/FatSlap", "Act/Anim/N_Striker_A.act", true)
						end
					end
					
					if shared.SMAE.Player[2][1] == "/Global/N_Striker_B" then -- buggy style, no matter what
						if TAKE_ACTION == "LIGHT" then
							SET_ANIM(gPlayer, "/Global/N_Striker_B/Offense/Short/Strikes/LightAttacks/NerdJab", "Act/Anim/N_Striker_B.act", true)
							
							NEXT_ANIM("/Global/N_Striker_B/Offense/Short/Strikes/LightAttacks/NerdJab/NerdHook", "Act/Anim/N_Striker_B.act", "NerdJab", 200, true)
						else
							SET_ANIM(gPlayer, "/Global/N_Striker_B/Offense/Short/Strikes/HeavyAttacks/Flail", "Act/Anim/N_Striker_B.act", true)
						end
					end
					
					if shared.SMAE.Player[2][1] == "/Global/N_Ranged_A" then
						if TAKE_ACTION == "LIGHT" then
							SET_ANIM(gPlayer, "/Global/N_Ranged_A/Offense/Short/Strikes/LightAttacks/NerdJab", "Act/Anim/N_Ranged_A.act", true)
							
							NEXT_ANIM("/Global/N_Ranged_A/Offense/Short/Strikes/LightAttacks/NerdJab/NerdHook", "Act/Anim/N_Ranged_A.act", "NerdJab", 300, true)
						else
							SET_ANIM(gPlayer, "/Global/N_Ranged_A/Offense/Medium/Strikes/HeavyAttacks/Spear", "Act/Anim/N_Ranged_A.act", true, true)
						end
					end
					
					if shared.SMAE.Player[2][1] == "/Global/J_Striker_A" then 
						if TAKE_ACTION == "LIGHT" then
							SET_ANIM(gPlayer, "/Global/J_Striker_A/Offense/Short/Strikes/LightAttacks/JAB", "Act/Anim/J_Striker_A.act", true)
							
							local ACTION = NEXT_ANIM("/Global/J_Striker_A/Offense/Short/Strikes/LightAttacks/JAB/Elbow", "Act/Anim/J_Striker_A.act", "JAB", 350, true)
							if ACTION then
								NEXT_ANIM("/Global/J_Striker_A/Offense/Short/Strikes/LightAttacks/JAB/Elbow/HeavyAttacks/Uppercut", "Act/Anim/J_Striker_A.act", "Elbow", 400, true)
							end
						else
							SET_ANIM(gPlayer, "/Global/J_Striker_A/Offense/Medium/Grapples/GrapplesAttempt", "Act/Anim/J_Striker_A.act", true)
						end
					end
					
					if shared.SMAE.Player[2][1] == "/Global/J_Melee_A" then
						if TAKE_ACTION == "LIGHT" then
							SET_ANIM(gPlayer, "/Global/J_Melee_A/Offense/Short/Strikes/LightAttacks/RightHand", "Act/Anim/J_Melee_A.act", true)
							
							NEXT_ANIM("/Global/J_Melee_A/Offense/Short/Strikes/LightAttacks/RightHand/LeftHand", "Act/Anim/J_Melee_A.act", "RightHand", 300, true)
						else
							SET_ANIM(gPlayer, "/Global/J_Melee_A/Offense/Medium/Strikes/HeavyAttacks/HeavyRight", "Act/Anim/J_Melee_A.act", true)
						end
					end
					
					if shared.SMAE.Player[2][1] == "/Global/J_Grappler_A" then
						SET_ANIM(gPlayer, "/Global/J_Grappler_A/Offense/Medium/Strikes/HeavyAttacks/RightPunch", "Act/Anim/J_Grappler_A.act", true)
						
						NEXT_ANIM("/Global/J_Grappler_A/Offense/Medium/Strikes/HeavyAttacks/RightPunch/Axehandle", "Act/Anim/J_Grappler_A.act", "RightPunch", 500, true)
					end
					
					if shared.SMAE.Player[2][1] == "/Global/J_Mascot" then -- buggy movement, heavy attack does not work (1)
						if TAKE_ACTION == "LIGHT" then
							SET_ANIM(gPlayer, "/Global/J_Mascot/Offense/Medium/Strikes/LightAttacks/WindMill_R", "Act/Anim/J_Mascot.act", true)
							
							local ACTION = NEXT_ANIM("/Global/J_Mascot/Offense/Medium/Strikes/LightAttacks/WindMill_R/WindMill_L", "Act/Anim/J_Mascot.act", "WindMill_R", 300, true)
							if ACTION then
								NEXT_ANIM("/Global/J_Mascot/Offense/Medium/Strikes/LightAttacks/WindMill_R/WindMill_L/HeavyAttacks/SwingPunch_R", "Act/Anim/J_Mascot.act", "WindMill_L", 300, true)
							end
						else
							SET_ANIM(gPlayer, "/Global/J_Mascot/Offense/Short/Heavy/Stunners/HeadButt", "Act/Anim/J_Mascot.act", true)
						end
					end
					
					if shared.SMAE.Player[2][1] == "/Global/DO_Striker_A" then
						if TAKE_ACTION == "LIGHT" then
							SET_ANIM(gPlayer, "/Global/DO_Striker_A/Offense/Short/DO_StrikeCombo/LightAttacks/Punch1", "Act/Anim/DO_Striker_A.act", true, true)
							
							local ACTION = NEXT_ANIM("/Global/DO_Striker_A/Offense/Short/DO_StrikeCombo/LightAttacks/Punch1/Punch2", "Act/Anim/DO_Striker_A.act", "Punch1", 350, true, true)
							if ACTION then
								NEXT_ANIM("/Global/DO_Striker_A/Offense/Short/DO_StrikeCombo/LightAttacks/Punch1/Punch2/HeavyAttacks/Punch3", "Act/Anim/DO_Striker_A.act", "Punch2", 400, true, true)
							end
						else
							SET_ANIM(gPlayer, "/Global/DO_Striker_A/Offense/Medium/HeavyAttacks/OverhandSwing", "Act/Anim/DO_Striker_A.act", true)
						end
					end
					
					if shared.SMAE.Player[2][1] == "/Global/DO_Grappler_A" then
						if TAKE_ACTION == "LIGHT" then
							SET_ANIM(gPlayer, "/Global/DO_Grappler_A/Offense/Short/DO_StrikeCombo/LightAttacks/Punch1", "Act/Anim/DO_Grappler_A.act", true, true)
							
							local ACTION = NEXT_ANIM("/Global/DO_Grappler_A/Offense/Short/DO_StrikeCombo/LightAttacks/Punch1/Punch2", "Act/Anim/DO_Grappler_A.act", "Punch1", 350, true, true)
							if ACTION then
								NEXT_ANIM("/Global/DO_Grappler_A/Offense/Short/DO_StrikeCombo/LightAttacks/Punch1/Punch2/HeavyAttacks/Punch3", "Act/Anim/DO_Grappler_A.act", "Punch2", 400, true, true)
							end
						else
							SET_ANIM(gPlayer, "/Global/DO_Grappler_A/Offense/OldMedium/OldBikeGrap/GrapplesAttempt", "Act/Anim/DO_Grappler_A.act", true)
						end
					end
					
					if shared.SMAE.Player[2][1] == "/Global/GS_Male_A" then
						if TAKE_ACTION == "LIGHT" then
							SET_ANIM(gPlayer, "/Global/GS_Male_A/Offense/Short/LightAttacks/SloppyJAB", "Act/Anim/GS_Male_A.act", true)
							
							NEXT_ANIM("/Global/GS_Male_A/Offense/Short/LightAttacks/SloppyJAB/SloppyCross", "Act/Anim/GS_Male_A.act", "SloppyJAB", 250, true)
						else
							SET_ANIM(gPlayer, "/Global/GS_Male_A/Offense/Short/HeavyAttacks/Shove2Hand", "Act/Anim/GS_Male_A.act", true)
						end
					end
					
					if shared.SMAE.Player[2][1] == "/Global/GS_Female_A" then
						if TAKE_ACTION == "LIGHT" then
							SET_ANIM(gPlayer, "/Global/GS_Female_A/Offense/Short/Strikes/LightAttacks/Slap", "Act/Anim/GS_Female_A.act", true, true)
						else
							SET_ANIM(gPlayer, "/Global/GS_Female_A/Offense/Short/Strikes/HeavyAttacks/NutKick", "Act/Anim/GS_Female_A.act", true, true)
						end
					end
					
					if shared.SMAE.Player[2][1] == "/Global/CV_Female_A" then
						if TAKE_ACTION == "LIGHT" then
							SET_ANIM(gPlayer, "/Global/CV_Female_A/Offense/Short/LightAttacks/Slap", "Act/Anim/CV_Female_A.act", true, true)
						else
							SET_ANIM(gPlayer, "/Global/CV_Female_A/Offense/Short/HeavyAttacks/NutKick", "Act/Anim/CV_Female_A.act", true, true)
						end
					end
					
					if shared.SMAE.Player[2][1] == "/Global/CV_Male_A" then -- movement does not work (1)
						if TAKE_ACTION == "LIGHT" then
							SET_ANIM(gPlayer, "/Global/CV_Male_A/Offense/Short/LightAttacks/SloppyJAB", "act/anim/CV_Male_A.act", true)
							
							NEXT_ANIM("/Global/CV_Male_A/Offense/Short/LightAttacks/SloppyJAB/SloppyCross", "Act/Anim/CV_Male_A.act", "SloppyJAB", 200, true)
						else
							SET_ANIM(gPlayer, "/Global/CV_Male_A/Defense/Counter/Counter", "Act/Anim/CV_Male_A.act", true)
						end
					end
					
					if shared.SMAE.Player[2][1] == "/Global/CV_OLD" then
						SET_ANIM(gPlayer, "/Global/CV_OLD/Offense/Short/HeavyAttacks/Spear", "Act/Anim/CV_OLD.act", true)
					end
					
					if shared.SMAE.Player[2][1] == "/Global/Crazy_Basic" then -- T-pose (1)
						if TAKE_ACTION == "LIGHT" then
							SET_ANIM(gPlayer, "/Global/Crazy_Basic/Offense/Short/Short/Strikes/LightAttacks/WindMill_R", "Act/Anim/Crazy_Basic.act", true)
							
							NEXT_ANIM("/Global/Crazy_Basic/Offense/Short/Short/Strikes/LightAttacks/WindMill_R/WindMill_L", "Act/Anim/Crazy_Basic.act", "Windmill_R", 350, true)
						else
							SET_ANIM(gPlayer, "/Global/Crazy_Basic/Offense/Medium/GrapplesNEW/GrapplesAttempt", "Act/Anim/Crazy_Basic.act", true)
						end
					end
					
					if shared.SMAE.Player[2][1] == "/Global/TO_Siamese" then
						if TAKE_ACTION == "LIGHT" then
							SET_ANIM(gPlayer, "/Global/TO_Siamese/Offense/Short/LightAttacks/Slap", "Act/Anim/TO_Siamese.act", true)
						else
							SET_ANIM(gPlayer, "/Global/TO_Siamese/Offense/Short/HeavyAttacks/NutKick", "Act/Anim/TO_Siamese.act", true)
						end
					end
					
					if shared.SMAE.Player[2][1] == "/Global/CV_Drunk" then
						if TAKE_ACTION == "LIGHT" then
							SET_ANIM(gPlayer, "/Global/CV_Drunk/Offense/Short/LightAttacks/SloppyJAB", "act/anim/CV_Drunk.act", true)
							
							NEXT_ANIM("/Global/CV_Drunk/Offense/Short/LightAttacks/SloppyJAB/SloppyCross", "Act/Anim/CV_Drunk.act", "SloppyJAB", 300, true)
						else
							SET_ANIM(gPlayer, "/Global/CV_Drunk/Defense/Counter/Counter", "Act/Anim/CV_Drunk.act", true)
						end
					end
					
					if shared.SMAE.Player[2][1] == "/Global/GS_Fat_A" then
						if PedIsFemale(gPlayer) then
							if TAKE_ACTION == "LIGHT" then
								SET_ANIM(gPlayer, "/Global/GS_Fat_A/Offense/Short/Strikes/LightAttacks/Slap", "Act/Anim/GS_Fat_A.act", true)
							else
								SET_ANIM(gPlayer, "/Global/GS_Fat_A/Offense/Short/Strikes/HeavyAttacks/NutKick", "Act/Anim/GS_Fat_A.act", true)
							end
						else
							SET_ANIM(gPlayer, "/Global/GS_Fat_A/Offense/Short/Stationary/Shove2hand", "Act/Anim/GS_Fat_A.act", true)
						end
					end
					
					if PedMePlaying(gPlayer, "CombatBasic") then
						PedSetActionNode(gPlayer, unpack(shared.SMAE.Player[2]))
					end
					
					ATTACKING_STYLE, PUNCH_TIMER, TAKE_ACTION = nil, nil, nil
				else
					if PedMePlaying(gPlayer, "HitTree") or PedIsValid(PedGetGrappleTargetPed(gPlayer)) or PlayerIsInAnyVehicle() then
						ATTACKING_STYLE, PUNCH_TIMER = nil, nil
					end
				end
			end
		end
		
		if PedHasWeapon(gPlayer, 309) then
			if PedIsPlaying(gPlayer, "/Global/Player/Social_Actions/HarassMoves/Shove_Still/Shove/SmashInnaFaceStink", true) then
				local IS_CHEATING = PedGetFlag(gPlayer, 24)
				
				PedSetFlag(gPlayer, 24, true)
				repeat
					Wait(0)
				until not PedIsPlaying(gPlayer, "/Global/Player/Social_Actions/HarassMoves/Shove_Still/Shove/SmashInnaFaceStink", true)
				
				PedSetFlag(gPlayer, 24, IS_CHEATING)
				if IS_CHEATING then
					GiveAmmoToPlayer(309, 1, false)
				end
			end
		end
	end
end

--[[
	--------------------------
	# CUSTOMIZED IDLE THREAD #
	--------------------------
]]

SMAE_VEHICLE = function()
	local REGULAR = {
		[275] = true, [286] = true, [288] = true, [290] = true, [291] = true, [292] = true,
		[293] = true, [294] = true, [295] = true, [296] = true, [297] = true,
	}
	
	local UNIQUE = {
		[285] = true, [287] = true, [298] = true,
	}
	
	while true do
		Wait(0)
		
		if not shared.gOverrideVehicleSettings then
			local TABLE = VehicleFindInAreaXYZ(0, 0, 0, 9999999)
			
			if type(TABLE) == "table" then
				for _, VEH in ipairs(TABLE) do
					if VehicleIsValid(VEH) then
						local POS = {VehicleGetPosXYZ(VEH)}
						
						if not PlayerIsInAnyVehicle() and PedMePlaying(gPlayer, "DEFAULT_KEY") and not PedIsValid(PedGetTargetPed(gPlayer)) then
							if math.abs(shared.SMAE.X - POS[1]) + math.abs(shared.SMAE.Y - POS[2]) + math.abs(shared.SMAE.Z - POS[3]) <= (VehicleIsModel(VEH, 288) and 6 or 4) and IsButtonBeingReleased(15, 0) then
								PedSetFlag(gPlayer, 2, false)
								
								if REGULAR[VehicleGetModelId(VEH)] then
									local AVAILABLE = true
									
									for _, PED in {PedFindInAreaXYZ(0, 0, 0, 999999)} do
										if PedIsValid(PED) and PED ~= gPlayer then
											if VehicleFromDriver(PED) == VEH and PedMePlaying(PED, "Driver") then
												AVAILABLE = false
											end
										end
									end
									
									if AVAILABLE then
										if VehicleGetModelId(VEH) ~= 275 then
											PedEnterVehicle(gPlayer, VEH)
											PedSetActionNode(gPlayer, "/Global/Vehicles/Cars/MoveToVehicle/MoveToVehicleLHS/MoveTo", "Act/Vehicles.act")
											
											while PedIsPlaying(gPlayer, "/Global/Vehicles/Cars/MoveToVehicle/MoveToVehicleLHS/MoveTo", true) do
												Wait(0)
											end
											
											if not PedMePlaying(gPlayer, "Vehicles_CarRide") and not PedMePlaying(gPlayer, "GetInVehicle") then
												PedSetActionNode(gPlayer, "/Global/Vehicles/Cars/MoveToVehicle/AtCar/GetInVehicle/LeftHandSide/Sedan", "Act/Vehicles.act")
											end
										else
											PedEnterVehicle(gPlayer, VEH)
											PedSetActionNode(gPlayer, "/Global/Vehicles/Motorcycle/MoveToVehicle", "Act/Vehicles.act")
											
											local SIDE, TIMER = "LHS", GetTimer()
											while PedIsPlaying(gPlayer, "/Global/Vehicles/Motorcycle/MoveToVehicle", true) do
												if PedMePlaying(gPlayer, "MoveToVehicleRHS") then
													SIDE = "RHS"
												end
												
												if TIMER + 5000 < GetTimer() then
													PedSetActionNode(gPlayer, "/Global/1_03/animations/DavisWait/release", "Act/Conv/1_03.act")
												end
												
												Wait(0)
											end
											
											if not PedMePlaying(gPlayer, "Vehicles_Ride") and not PedMePlaying(gPlayer, "GetInVehicle") then
												PedSetActionNode(gPlayer, "/Global/Vehicles/Bikes/MoveToVehicle/AtBike"..SIDE.."/BikeUpright/GetInVehicle", "Act/Vehicles.act")
												while not PedIsInVehicle(gPlayer, VEH) do
													Wait(0)
												end
												
												PlayerDetachFromVehicle()
												while PedIsInVehicle(gPlayer, VEH) do
													Wait(0)
												end
												
												PedSetActionNode(gPlayer, "/Global/Vehicles/Motorcycle/MoveToVehicle/AtBike/GetInVehicle/Base/GetOn", "Act/Vehicles.act")
											end
										end
									end
								
								elseif UNIQUE[VehicleGetModelId(VEH)] then
									local AVAILABLE = true
									
									for _, PED in {PedFindInAreaXYZ(0, 0, 0, 999999)} do
										if PedIsValid(PED) and PED ~= gPlayer then
											if VehicleFromDriver(PED) == VEH then AVAILABLE = false end
										end
									end
									
									if AVAILABLE then
										PedWarpIntoCar(gPlayer, VEH)
										
										while IsButtonBeingReleased(15, 0) do
											Wait(0)
										end
									end
								end
							end
						end
					end
				end
			end
			
			if PlayerIsInAnyVehicle() then
				local VEHICLE = VehicleFromDriver(gPlayer)
				
				if UNIQUE[VehicleGetModelId(VEHICLE)] then
					if IsButtonBeingReleased(9, 0) then
						local POS = {{PedGetOffsetInWorldCoords(gPlayer, random(1, 2) == 1 and 1.5 or -1.5, 0, 0)}, {PedGetOffsetInWorldCoords(gPlayer, 0, 0, 0)}}
						
						VehicleStop(VEHICLE)
						PedWarpOutOfCar(gPlayer, VEHICLE)
						Wait(50)
						
						PlayerSetPosSimple(POS[1][1], POS[1][2], POS[1][3])
						VehicleSetPosXYZ(VEHICLE, POS[2][1], POS[2][2], POS[2][3])
						Wait(500)
					end
				end
				
				if VehicleIsModel(VEHICLE, 275) or VehicleIsModel(VEHICLE, 295) then
					if TOGGLE_VEHICLE_SIREN == nil then
						TOGGLE_VEHICLE_SIREN = false
					end
					
					if IsButtonBeingPressed(8, 0) then
						TOGGLE_VEHICLE_SIREN = not TOGGLE_VEHICLE_SIREN
						VehicleEnableSiren(VEHICLE, TOGGLE_VEHICLE_SIREN)
					end
				end
			end
		end
	end
end


--[[
	--------------------------
	# CUSTOMIZED IDLE THREAD #
	--------------------------
]]

SMAE_IDLE = function()
	local DELAY = GetTimer()
	
	while true do
		Wait(0)
		
		if type(shared.SMAE.Idle[1][1]) == "string" then
			
			if PedIsPlaying(gPlayer, shared.SMAE.Idle[1][1], true) then
				repeat
					Wait(0)
				until not shared.SMAE.Idle[2] or F.PMOVING() or PedIsValid(PedGetGrappleTargetPed(gPlayer)) or PedIsValid(PedGetTargetPed(gPlayer)) or not PedIsPlaying(gPlayer, shared.SMAE.Idle[1][1], true) or PedGetFlag(gPlayer, 2) == true or not PedHasWeapon(gPlayer, -1) or PedIsHit(gPlayer, 2) or shared.PlayerInClothingManager or shared.playerShopping
				
				shared.SMAE.Idle[2], IDLE_TIMER = false, 0
				
				repeat
					if PedMePlaying(gPlayer, "DEFAULT_KEY") and not F.PMOVING() and PedHasWeapon(gPlayer, -1) and not PedIsValid(PedGetTargetPed(gPlayer)) and PedGetFlag(gPlayer, 2) == false and not shared.PlayerInClothingManager and not shared.playerShopping then
						if DELAY + 100 <= GetTimer() then
							IDLE_TIMER, DELAY = IDLE_TIMER + 1, GetTimer()
						end
					else
						IDLE_TIMER, DELAY = 0, GetTimer()
					end
					
					Wait(0)
				until IDLE_TIMER == 50 or shared.SMAE.Idle[2] or type(shared.SMAE.Idle[1][1]) ~= "string"
				
				if type(shared.SMAE.Idle[1][1]) == "string" then
					shared.SMAE.Idle[2] = true
				end
			end
		end
	end
end