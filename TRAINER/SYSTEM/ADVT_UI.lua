-- ADVT_UI.LUA
-- AUTHOR	: ALTAMURENZA


--[[
	-------------
	# MAIN MENU #
	-------------
]]

MAIN_UI = function()
	local OPEN_UI = {0, GetTimer()}
	
	while true do
		Wait(0)
		
		-- ui
		if CBUI_IsActive() and shared.SMAE.GUI then
			if CBUI_0() then
				shared.SMAE.Option = shared.SMAE.Option - 1 < 1 and table.getn(shared.SMAE.Setup) or shared.SMAE.Option - 1
				
				CBUI_SetText("- MAIN MENU -\n"..shared.SMAE.Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Title)
				CBUI_SetOption({"PREV", "", "NEXT"}, 3)
			end
			
			if CBUI_1() then
				shared.SMAE.Option = shared.SMAE.Option + 1 > table.getn(shared.SMAE.Setup) and 1 or shared.SMAE.Option + 1
				
				CBUI_SetText("- MAIN MENU -\n"..shared.SMAE.Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Title)
				CBUI_SetOption({"PREV", "", "NEXT"}, 3)
			end
			
			if CBUI_Select() then
				if shared.SMAE.Setup[shared.SMAE.Option].Function ~= nil then
					shared.SMAE.Setup[shared.SMAE.Option].Function()
					collectgarbage()
				else
					CBUI_SetText("# ERROR #\nMISSING 'shared.SMAE.Setup["..shared.SMAE.Option.."].Function' TO EXECUTE!")
					CBUI_SetOption({"", "OK", ""}, 2)
					
					while true do
						Wait(0)
						
						if CBUI_IsActive() and shared.SMAE.GUI then
							if CBUI_1() then
								break
							end
						else
							break
						end
					end
					
					if CBUI_IsActive() then
						CBUI_SetText("- MAIN MENU -\n"..shared.SMAE.Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Title)
						CBUI_SetOption({"PREV", "", "NEXT"}, 3)
					end
				end
			end
			
			if shared.SMAE.SubGUI then
				shared.SMAE.SubGUI = false
			end
		else
			if shared.SMAE.GUI then
				shared.SMAE.GUI = false
			end
		end
		
		-- activate
		if IsButtonBeingPressed(8, 0) and not shared.SMAE.GUI and not PlayerIsInAnyVehicle() and not CBUI_IsActive() and not CB_IsRunning() and CB_IsSafe() then
			OPEN_UI[1], OPEN_UI[2] = 0, GetTimer()
			
			repeat
				Wait(0)
				
				if OPEN_UI[2] + 1000 < GetTimer() then
					OPEN_UI[1], OPEN_UI[2] = OPEN_UI[1] + 1, GetTimer()
				end
				
				if OPEN_UI[1] < 2 and (IsButtonBeingReleased(8, 0) or PlayerIsInAnyVehicle() or CBUI_IsActive() or CB_IsRunning() or not CB_IsSafe()) then
					break
				end
			until OPEN_UI[1] == 2
			
			if OPEN_UI[1] == 2 then
				CBUI_SetText("- MAIN MENU -\n"..shared.SMAE.Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Title)
				CBUI_SetOption({"PREV", "", "NEXT"}, 3)
				
				CBUI_Show(2)
				shared.SMAE.GUI = true
			end
		end
	end
end


--[[
	------------
	# SUB MENU #
	------------
]]

SUB_CHAR = function()
	local ACTION = UI_MANAGER("- "..shared.SMAE.Setup[shared.SMAE.Option].Title.." -", "'OPEN'", true)
	
	if ACTION == "'OPEN'" then
		CBUI_SetText("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[shared.SMAE.Setup[shared.SMAE.Option].Option].Group.." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[shared.SMAE.Setup[shared.SMAE.Option].Option].Name)
		CBUI_SetOption({"PREV", "", "NEXT"}, 3)
		
		while true do
			Wait(0)
			
			if CBUI_IsActive() and shared.SMAE.SubGUI then
				if CBUI_0() then
					shared.SMAE.Setup[shared.SMAE.Option].Option = shared.SMAE.Setup[shared.SMAE.Option].Option - 1 < 1 and table.getn(shared.SMAE.Setup[shared.SMAE.Option].Data) or shared.SMAE.Setup[shared.SMAE.Option].Option - 1
					
					CBUI_SetText("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[shared.SMAE.Setup[shared.SMAE.Option].Option].Group.." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[shared.SMAE.Setup[shared.SMAE.Option].Option].Name)
					CBUI_SetOption({"PREV", "", "NEXT"}, 3)
				end
				
				if CBUI_1() then
					shared.SMAE.Setup[shared.SMAE.Option].Option = shared.SMAE.Setup[shared.SMAE.Option].Option + 1 > table.getn(shared.SMAE.Setup[shared.SMAE.Option].Data) and 1 or shared.SMAE.Setup[shared.SMAE.Option].Option + 1
					
					CBUI_SetText("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[shared.SMAE.Setup[shared.SMAE.Option].Option].Group.." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[shared.SMAE.Setup[shared.SMAE.Option].Option].Name)
					CBUI_SetOption({"PREV", "", "NEXT"}, 3)
				end
				
				if CBUI_Select() then
					local THING = {
						["SET TO PLAYER"] = {F.SWAP, true, shared.SMAE.Setup[shared.SMAE.Option].Data[shared.SMAE.Setup[shared.SMAE.Option].Option].Model[1], shared.SMAE.Setup[shared.SMAE.Option].Data[shared.SMAE.Setup[shared.SMAE.Option].Option].Tree},
						["SET TO NPC"] = {F.SWAP, false, shared.SMAE.Setup[shared.SMAE.Option].Data[shared.SMAE.Setup[shared.SMAE.Option].Option].Model[1], shared.SMAE.Setup[shared.SMAE.Option].Data[shared.SMAE.Setup[shared.SMAE.Option].Option].Tree},
						["SPAWN PED"] = {F.CNPC, shared.SMAE.Setup[shared.SMAE.Option].Data[shared.SMAE.Setup[shared.SMAE.Option].Option].Index, true, nil},
						["SPAWN AS ALLY"] = {F.CNPC, shared.SMAE.Setup[shared.SMAE.Option].Data[shared.SMAE.Setup[shared.SMAE.Option].Option].Index, true, true},
						["SPAWN AS ENEMY"] = {F.CNPC, shared.SMAE.Setup[shared.SMAE.Option].Data[shared.SMAE.Setup[shared.SMAE.Option].Option].Index, true, false},
					}
					local USER_ACTION = UI_MANAGER("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[shared.SMAE.Setup[shared.SMAE.Option].Option].Name.." -", {"SET TO PLAYER", "SET TO NPC", "SPAWN PED", "SPAWN AS ALLY", "SPAWN AS ENEMY"})
					
					if type(USER_ACTION) == "string" and THING[USER_ACTION] then
						CBUI_Close()
						
						THING[USER_ACTION][1](THING[USER_ACTION][2], THING[USER_ACTION][3], THING[USER_ACTION][4])
						TutorialShowMessage(string.find(USER_ACTION, "SET TO", 1) and "MODEL APPLIED!" or ({["nil"] = "PED", ["true"] = "ALLY", ["false"] = "ENEMY"})[tostring(THING[USER_ACTION][4])].." SPAWNED!", 2500, true) 
					end
				end
			else
				break
			end
		end
	end
end

SUB_MOVEMENT = function()
	local ACTION = UI_MANAGER("- "..shared.SMAE.Setup[shared.SMAE.Option].Title.." -", {"'OPEN BASIC'", "'OPEN CUSTOMIZATION'"}, true)
	
	if ACTION == "'OPEN BASIC'" or ACTION == "'OPEN CUSTOMIZATION'" then
		CBUI_SetText("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Group.." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name)
		CBUI_SetOption({"PREV", "", "NEXT"}, 3)
		
		while true do
			Wait(0)
			
			if CBUI_IsActive() and shared.SMAE.SubGUI then
				if CBUI_0() then
					shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option = shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option - 1 < 1 and table.getn(shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data) or shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option - 1
					
					CBUI_SetText("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Group.." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name)
					CBUI_SetOption({"PREV", "", "NEXT"}, 3)
				end
				
				if CBUI_1() then
					shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option = shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option + 1 > table.getn(shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data) and 1 or shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option + 1
					
					CBUI_SetText("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Group.." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name)
					CBUI_SetOption({"PREV", "", "NEXT"}, 3)
				end
				
				if CBUI_Select() then
					if ACTION == "'OPEN BASIC'" then
						local THING = {
							["SET PLAYER STYLE"] = {F.STYLE, true, shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Code},
							["SET NPC STYLE"] = {F.STYLE, false, shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Code},
						}
						local USER_ACTION = UI_MANAGER("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name.." -", {"SET PLAYER STYLE", "SET NPC STYLE"})
						
						if type(USER_ACTION) == "string" and THING[USER_ACTION] then
							CBUI_Close()
							
							THING[USER_ACTION][1](THING[USER_ACTION][2], THING[USER_ACTION][3], THING[USER_ACTION][4])
							TutorialShowMessage("STYLE APPLIED!", 2500, true)
						end
					else
						local USER_ACTION = UI_MANAGER("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name.." -", string.find(shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name, "(B)", -4) and {"ADD BLOCK", "CLEAR SETUP"} or {"BIND TO BUTTON", "REPLACE ANIM", "AFTER ANIM", "CLEAR SETUP"})
						
						if USER_ACTION == "BIND TO BUTTON" then
							CBUI_Close()
							
							TutorialShowMessage("PRESS ANY BUTTON..", -1, true)
							local BUTTON = nil
							
							repeat
								Wait(0)
								
								if IsButtonBeingPressed(24, 0) then
									BUTTON = 24
								end
								for B = 0, 15 do
									if IsButtonBeingPressed(B, 0) then
										BUTTON = B
									end
								end
							until type(BUTTON) == "number"
							
							table.insert(shared.SMAE.Strafe.Bind, {
								ANIM = shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option][1],
								ACT = shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option][2],
								KEY = BUTTON,
								GRAPPLE = string.find(shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name, "(F)", -4) and true or false,
								MOUNT = string.find(shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name, "(M)", -4) and true or false,
							})
							
							if not shared.SMAE.Strafe.Bind[table.getn(shared.SMAE.Strafe.Bind)].GRAPPLE and not shared.SMAE.Strafe.Bind[table.getn(shared.SMAE.Strafe.Bind)].MOUNT then
								if not shared.STRAFE_KEY then
									shared.STRAFE_KEY = {}
								end
								
								shared.STRAFE_KEY[BUTTON] = true
							end
							
							TutorialShowMessage("ANIM BOUND TO KEY!", 2500, true)
						elseif USER_ACTION == "REPLACE ANIM" then
							CBUI_Close()
							
							TutorialShowMessage("[Zoom In] CONFIRM", -1, true)
							local PLAYING = nil
							
							repeat
								Wait(0)
								
								local NODE, ACT = F.PGAN(gPlayer)
								PLAYING = NODE
							until IsButtonBeingPressed(2, 0) and not PedMePlaying(gPlayer, "DEFAULT_KEY")
							
							table.insert(shared.SMAE.Strafe.Other, {
								ANIM = shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option][1],
								ACT = shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option][2],
								TRIGGER = PLAYING,
								KEY = nil,
								METHOD = 1,
							})
							
							TutorialShowMessage("ANIM REPLACED!", 2500, true)
						elseif USER_ACTION == "AFTER ANIM" then
							CBUI_Close()
							
							TutorialShowMessage("[Zoom In] CONFIRM", -1, true)
							local PLAYING = nil
							
							repeat
								Wait(0)
								
								local NODE, ACT = F.PGAN(gPlayer)
								PLAYING = NODE
							until IsButtonBeingPressed(2, 0) and not PedMePlaying(gPlayer, "DEFAULT_KEY")
							
							table.insert(shared.SMAE.Strafe.Other, {
								ANIM = shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option][1],
								ACT = shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option][2],
								TRIGGER = PLAYING,
								KEY = nil,
								METHOD = 2,
							})
							
							TutorialShowMessage("ANIM ADDED!", 2500, true)
						elseif USER_ACTION == "ADD BLOCK" then
							CBUI_Close()
							
							table.insert(shared.SMAE.Strafe.Block, {
								ANIM = shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option][1],
								ACT = shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option][2],
							})
							
							TutorialShowMessage("BLOCK ANIM ADDED!", 2500, true)
						elseif USER_ACTION == "CLEAR SETUP" then
							local COUNT = 0
							
							if table.getn(shared.SMAE.Strafe.Bind) > 0 then
								COUNT = COUNT + table.getn(shared.SMAE.Strafe.Bind)
								
								for INDEX = 1, table.getn(shared.SMAE.Strafe.Bind) do
									table.remove(shared.SMAE.Strafe.Bind, INDEX)
								end
								
								if type(shared.STRAFE_KEY) == "table" then
									for BUTTON = 0, 15 do
										shared.STRAFE_KEY[BUTTON] = nil
									end
									
									shared.STRAFE_KEY[24] = nil
								end
							end
							
							if table.getn(shared.SMAE.Strafe.Other) > 0 then
								COUNT = COUNT + table.getn(shared.SMAE.Strafe.Other)
								
								for INDEX = 1, table.getn(shared.SMAE.Strafe.Other) do
									table.remove(shared.SMAE.Strafe.Other, INDEX)
								end
							end
							
							if table.getn(shared.SMAE.Strafe.Block) > 0 then
								COUNT = COUNT + table.getn(shared.SMAE.Strafe.Block)
								
								for INDEX = 1, table.getn(shared.SMAE.Strafe.Block) do
									table.remove(shared.SMAE.Strafe.Block, INDEX)
								end
							end
							
							CBUI_Close()
							
							TutorialShowMessage(COUNT > 0 and COUNT.." ANIM DELETED!" or "NO SETUP YET!\n", 2500, true)
						end
					end
				end
			else
				break
			end
		end
	end
end

SUB_VEHICLE = function()
	local ACTION = UI_MANAGER("- "..shared.SMAE.Setup[shared.SMAE.Option].Title.." -", "'OPEN'", true)
	
	if ACTION == "'OPEN'" then
		CBUI_SetText("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[shared.SMAE.Setup[shared.SMAE.Option].Option].Group.." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[shared.SMAE.Setup[shared.SMAE.Option].Option].Name)
		CBUI_SetOption({"PREV", "", "NEXT"}, 3)
		
		while true do
			Wait(0)
			
			if CBUI_IsActive() and shared.SMAE.SubGUI then
				if CBUI_0() then
					shared.SMAE.Setup[shared.SMAE.Option].Option = shared.SMAE.Setup[shared.SMAE.Option].Option - 1 < 1 and table.getn(shared.SMAE.Setup[shared.SMAE.Option].Data) or shared.SMAE.Setup[shared.SMAE.Option].Option - 1
					
					CBUI_SetText("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[shared.SMAE.Setup[shared.SMAE.Option].Option].Group.." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[shared.SMAE.Setup[shared.SMAE.Option].Option].Name)
					CBUI_SetOption({"PREV", "", "NEXT"}, 3)
				end
				
				if CBUI_1() then
					shared.SMAE.Setup[shared.SMAE.Option].Option = shared.SMAE.Setup[shared.SMAE.Option].Option + 1 > table.getn(shared.SMAE.Setup[shared.SMAE.Option].Data) and 1 or shared.SMAE.Setup[shared.SMAE.Option].Option + 1
					
					CBUI_SetText("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[shared.SMAE.Setup[shared.SMAE.Option].Option].Group.." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[shared.SMAE.Setup[shared.SMAE.Option].Option].Name)
					CBUI_SetOption({"PREV", "", "NEXT"}, 3)
				end
				
				if CBUI_Select() then
					local USER_ACTION = UI_MANAGER("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[shared.SMAE.Setup[shared.SMAE.Option].Option].Name.." -", {"SPAWN VEHICLE", "CLEAR SPAWNED VEHICLE"})
					
					if USER_ACTION == "SPAWN VEHICLE" or USER_ACTION == "CLEAR SPAWNED VEHICLE" then
						CBUI_Close()
						
						if USER_ACTION == "SPAWN VEHICLE" then
							local IS_CAR = function(V, MODEL_CHECK)
								local UNRIDEABLE_VEHICLE = {
									[286] = true, [288] = true, [290] = true, [291] = true, [292] = true,
									[293] = true, [294] = true, [295] = true, [296] = true, [297] = true,
								}
								
								if MODEL_CHECK then
									return UNRIDEABLE_VEHICLE[V] or false
								else
									if VehicleIsValid(V) then
										return UNRIDEABLE_VEHICLE[VehicleGetModelId(V)] or false
									end
									
									return false
								end
							end
							
							local CODE = shared.SMAE.Setup[shared.SMAE.Option].Data[shared.SMAE.Setup[shared.SMAE.Option].Option].Code
							
							local POS = {PedGetOffsetInWorldCoords(gPlayer, 0, IS_CAR(CODE, true) and 4 or 1.5, 0)}
							local COUNT = VehicleFindInAreaXYZ(POS[1], POS[2], POS[3], IS_CAR(CODE, true) and 4 or 1.5)
							
							if type(COUNT) ~= "table" then
								if not SPAWNED_VEHICLE then
									SPAWNED_VEHICLE = {}
								end
								
								table.insert(SPAWNED_VEHICLE, VehicleCreateXYZ(CODE, POS[1], POS[2], POS[3]))
								
								VehicleFaceHeading(SPAWNED_VEHICLE[table.getn(SPAWNED_VEHICLE)], PedGetHeading(gPlayer) * 58)
								VehicleSetOwner(SPAWNED_VEHICLE[table.getn(SPAWNED_VEHICLE)], gPlayer)
								
								TutorialShowMessage("VEHICLE SPAWNED!", 2500, true)
							else
								TutorialShowMessage("CAN'T SPAWN VEHICLE!", 2500, true)
							end
						else
							if type(SPAWNED_VEHICLE) == "table" and table.getn(SPAWNED_VEHICLE) > 0 then
								local EXCEPTION = {}
								
								for _, V in ipairs(SPAWNED_VEHICLE) do
									if VehicleIsValid(V) then
										if PedIsInVehicle(gPlayer, V) then
											table.insert(EXCEPTION, V)
										else
											VehicleDelete(V)
										end
									end
								end
								
								local COUNT = table.getn(SPAWNED_VEHICLE) - table.getn(EXCEPTION)
								if COUNT > 0 then
									SPAWNED_VEHICLE = {}
									
									for _, V in ipairs(EXCEPTION) do
										table.insert(SPAWNED_VEHICLE, V)
									end
									
									TutorialShowMessage(COUNT.." VEHICLE"..(COUNT > 1 and "S" or "").." DELETED!", 2500, true)
								else
									TutorialShowMessage("ACTION FAILED!", 2500, true)
								end
							else
								TutorialShowMessage("NO VEHICLE YET!", 2500, true)
							end
						end
					end
				end
			else
				break
			end
		end
	end
end

SUB_ITEM = function()
	local ACTION = UI_MANAGER("- "..shared.SMAE.Setup[shared.SMAE.Option].Title.." -", {"'OPEN WEAPON'", "'OPEN ITEM'", "'OPEN COLLECTIBLE'"}, true)
	
	if ACTION == "'OPEN WEAPON'" or ACTION == "'OPEN ITEM'" or ACTION == "'OPEN COLLECTIBLE'" then
		CBUI_SetText("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Group.." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name)
		CBUI_SetOption({"PREV", "", "NEXT"}, 3)
		
		while true do
			Wait(0)
			
			if CBUI_IsActive() and shared.SMAE.SubGUI then
				if CBUI_0() then
					shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option = shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option - 1 < 1 and table.getn(shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data) or shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option - 1
					
					CBUI_SetText("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Group.." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name)
					CBUI_SetOption({"PREV", "", "NEXT"}, 3)
				end
				
				if CBUI_1() then
					shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option = shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option + 1 > table.getn(shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data) and 1 or shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option + 1
					
					CBUI_SetText("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Group.." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name)
					CBUI_SetOption({"PREV", "", "NEXT"}, 3)
				end
				
				if CBUI_Select() then
					if ACTION == "'OPEN WEAPON'" or ACTION == "'OPEN COLLECTIBLE'" then
						local THING = ACTION == "'OPEN WEAPON'" and {
							["SET WEAPON"] = {F.WEAPON, {true, shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Code}, "WEAPON ATTACHED!"},
							["SET TO NPC"] = {F.WEAPON, {false, shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Code}, "WEAPON ATTACHED!"},
							["DROP WEAPON"] = {F.WEAPON, {"", shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Code}, "WEAPON DROPPED!"},
						} or {
							["SPAWN ALL"] = {CollectiblesSetTypeAvailable, {shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Code, true}, "COLLECTIBLE SPAWNED!"},
							["DESPAWN ALL"] = {CollectiblesSetTypeAvailable, {shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Code, false}, "COLLECTIBLE REMOVED!"},
							["COLLECT ALL"] = {CollectiblesSetAllAsCollected, {shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Code}, "COLLECTIBLE CLEARED!"},
						}
						
						local USER_ACTION = UI_MANAGER("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name.." -", ACTION == "'OPEN WEAPON'" and {"SET WEAPON", "SET TO NPC", "DROP WEAPON"} or {"SPAWN ALL", "DESPAWN ALL", "COLLECT ALL"})
						
						if type(USER_ACTION) == "string" and THING[USER_ACTION] then
							THING[USER_ACTION][1](unpack(THING[USER_ACTION][2]))
							
							CBUI_Close()
							TutorialShowMessage(THING[USER_ACTION][3], 2500, true)
						end
					else
						local SET_AMOUNT = UI_ADJUST(
							shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name,
							ItemGetCurrentNum(shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Code),
							1, 0, 100
						)
						
						if type(SET_AMOUNT) == "number" then
							ItemSetCurrentNum(shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Code, SET_AMOUNT)
						end
					end
				end
			else
				break
			end
		end
	end
end

SUB_STORYLINE = function()
	local ACTION = UI_MANAGER("- "..shared.SMAE.Setup[shared.SMAE.Option].Title.." -", {"'OPEN MAIN STORY'", "'OPEN SIDE STORY'", "'OPEN ACTIVITY'", "'OPEN CLASS'", "'OPEN CUTSCENE'"}, true)
	
	if ACTION == "'OPEN MAIN STORY'" or ACTION == "'OPEN SIDE STORY'" or ACTION == "'OPEN ACTIVITY'" or ACTION == "'OPEN CLASS'" or ACTION == "'OPEN CUTSCENE'" then
		CBUI_SetText("- "..(ACTION ~= "'OPEN CUTSCENE'" and shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Group or "CUTSCENE").." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name)
		CBUI_SetOption({"PREV", "", "NEXT"}, 3)
		
		while true do
			Wait(0)
			
			if CBUI_IsActive() and shared.SMAE.SubGUI then
				if CBUI_0() then
					shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option = shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option - 1 < 1 and table.getn(shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data) or shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option - 1
					
					CBUI_SetText("- "..(ACTION ~= "'OPEN CUTSCENE'" and shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Group or "CUTSCENE").." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name)
					CBUI_SetOption({"PREV", "", "NEXT"}, 3)
				end
				
				if CBUI_1() then
					shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option = shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option + 1 > table.getn(shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data) and 1 or shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option + 1
					
					CBUI_SetText("- "..(ACTION ~= "'OPEN CUTSCENE'" and shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Group or "CUTSCENE").." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name)
					CBUI_SetOption({"PREV", "", "NEXT"}, 3)
				end
				
				if CBUI_Select() then
					if ACTION ~= "'OPEN CUTSCENE'" then
						local SUB = {
							["'OPEN MAIN STORY'"] = "MISSION", ["'OPEN SIDE STORY'"] = "MISSION",
							["'OPEN ACTIVITY'"] = "ACTIVITY", ["'OPEN CLASS'"] = "CLASS",
						}
						local THING = {
							["START "..SUB[ACTION]] = {ForceStartMission, shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Code},
							["SPAWN "..SUB[ACTION]] = {ForceMissionAvailable, shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Code},
							["FINISH"] = {MissionSuccessCountInc, shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Code},
						}
						
						if type(THING["START "..SUB[ACTION]][2]) == "number" then
							THING["START "..SUB[ACTION]][1] = ForceStartMissionIndex
						end
						
						local USER_ACTION = UI_MANAGER(
							"- "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name.." -",
							type(THING["START "..SUB[ACTION]][2]) == "string" and {"START "..SUB[ACTION], "SPAWN "..SUB[ACTION], "FINISH"} or "START "..SUB[ACTION]
						)
						
						if type(USER_ACTION) == "string" and THING[USER_ACTION] then
							if USER_ACTION == "START "..SUB[ACTION] then
								if MissionActive() then
									CBUI_SetText("# ERROR #\nCANNOT START THIS MISSION WHILE MISSION IS RUNNING")
									CBUI_SetOption({"", "OK", ""}, 2)
									
									while true do
										Wait(0)
										
										if CBUI_IsActive() and shared.SMAE.SubGUI then
											if CBUI_1() then
												break
											end
										else
											break
										end
									end
									
									if CBUI_IsActive() then
										CBUI_SetText("- "..(ACTION ~= "'OPEN CUTSCENE'" and shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Group or "CUTSCENE").." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name)
										CBUI_SetOption({"PREV", "", "NEXT"}, 3)
									end
								else
									CBUI_Close()
									
									local UNLOADABLE = {
										["3_03"] = "RENDEZVOUS", ["3_07"] = "CONVERSATION"
									}
									if not UNLOADABLE[THING[USER_ACTION][2]] then
										if string.find(THING[USER_ACTION][2], "GoKart_GP", 1) then
											AreaTransitionXYZ(0, 216.7, 462.6, 5.3)
										end
										
										if THING[USER_ACTION][2] == "2_S05B" then
											AreaTransitionXYZ(0, 440.0, 185.9, 8.3)
										end
									
										THING[USER_ACTION][1](THING[USER_ACTION][2])
									else
										shared.SMAE_LoadFile = UNLOADABLE[THING[USER_ACTION][2]]
										ForceStartMissionIndex(215)
									end
									
									TutorialShowMessage((SUB[ACTION] or "MISSION").." STARTED!", 2500, true)
								end
							else
								if type(THING[USER_ACTION][2]) == "string" then
									CBUI_Close()
									
									THING[USER_ACTION][1](THING[USER_ACTION][2])
									TutorialShowMessage((SUB[ACTION] or "MISSION").." "..(string.find(USER_ACTION, "SPAWN", 1) and "SPAWNED!" or "SKIPPED!"), 2500, true)
								end
							end
						end
					else
						local USER_ACTION = UI_MANAGER(
							"- "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name.." -",
							"PLAY"
						)
						
						if USER_ACTION == "PLAY" then
							CBUI_Close()
							
							local EXCEPTION = {
								["1-1-02"] 		= {5, -705.90, 227.98, 32, 120000},
								["1-02"] 		= {5, -705.90, 227.98, 32, 60000},
								["1-02C"] 		= {0, 187.94, 151.41, 7, 25000},
								["candidate"] 	= {2, -672.17, 307.40, 6, 81833.32},
								["1-09b"] 		= {19, -618.73, 309.03, 77.2, 20000},
								["1-08b"] 		= {0, 187.94, 151.41, 7, 15000},
								["1-1"] 		= {14, -501.58, 324.11, 7, 60000},
								["2-04B"] 		= {0, 225.64, 247.10, 7, 30000},
								["2-09A"] 		= {6, -709.74, 312.35, 33.3, 81733},
								["6-B2"] 		= {6, -709.74, 312.35, 33.3, 81733},
								["weedkiller"] 	= {6, -709.74, 312.35, 33.3, 81733},
								["3-R05"] 		= {4, -595.01, 325.74, 36, 66833},
								["4-B1C2"] 		= {40, -696.61, 61.63, 23, 15000},
								["4-S11"] 		= {14, -501.58, 324.11, 7, 60000},
								["CS_COUNTER"] 	= {14, -501.58, 324.11, 7, 59166.66},
								["FX-TEST"] 	= {2, -631.53, -278.09, 6, 33333},
								["TEST"] 		= {2, -631.53, -278.09, 6, 33333},
							}
							if EXCEPTION[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Code] then
								local A, X, Y, Z = AreaGetVisible(), PlayerGetPosXYZ()
								
								CameraFade(1000, 0)
								Wait(1001)
								
								AreaTransitionXYZ(
									EXCEPTION[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Code][1],
									EXCEPTION[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Code][2],
									EXCEPTION[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Code][3],
									EXCEPTION[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Code][4],
									true
								)
								
								SoundPause()
								
								LoadCutscene(shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Code)
								CutSceneSetActionNode(shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Code)
								LoadCutsceneSound("1-01")
								
								CameraDefaultFOV()
								
								repeat
									Wait(0)
								until IsCutsceneLoaded()
								StartCutscene()
								
								CameraFade(1000, 1)
								Wait(1000)
								
								repeat
									Wait(0)
								until GetCutsceneTime() > EXCEPTION[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Code][5] or IsButtonBeingPressed(7, 0)
								
								SoundFadeWithCamera(true)
								MusicFadeWithCamera(true)
								
								CameraFade(1000, 0)
								Wait(1001)
								
								StopCutscene()
								CutsceneFadeWithCamera(false)
								CameraSetWidescreen(false)
								
								AreaDisableCameraControlForTransition(true)
								SoundStopStream()
								AreaRemoveExtraScene()
								
								AreaTransitionXYZ(A, X, Y, Z, true)
								
								AreaDisableCameraControlForTransition(false)
								CameraReturnToPlayer()
								SoundContinue()
								
								Wait(500)
								CameraFade(1000, 1)
							else
								PlayCutsceneWithLoad(shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Code)
							end
							
							TutorialShowMessage("CUTSCENE PLAYED!", 2500, true)
						end
					end
				end
			else
				break
			end
		end
	end
end

SUB_WORLD = function()
	local ACTION = UI_MANAGER("- "..shared.SMAE.Setup[shared.SMAE.Option].Title.." -", {"'OPEN TELEPORT'", "'OPEN CONDITION'", "'OPEN EVENT'"}, true)
	
	if ACTION == "'OPEN TELEPORT'" or ACTION == "'OPEN CONDITION'" or ACTION == "'OPEN EVENT'" then
		CBUI_SetText("- "..(ACTION == "'OPEN CONDITION'" and shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Group or (ACTION ~= "'OPEN TELEPORT'" and "EVENT" or "TELEPORT")).." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name)
		CBUI_SetOption({"PREV", "", "NEXT"}, 3)
		
		while true do
			Wait(0)
			
			if CBUI_IsActive() and shared.SMAE.SubGUI then
				if CBUI_0() then
					shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option = shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option - 1 < 1 and table.getn(shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data) or shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option - 1
					
					CBUI_SetText("- "..(ACTION == "'OPEN CONDITION'" and shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Group or (ACTION ~= "'OPEN TELEPORT'" and "EVENT" or "TELEPORT")).." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name)
					CBUI_SetOption({"PREV", "", "NEXT"}, 3)
				end
				
				if CBUI_1() then
					shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option = shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option + 1 > table.getn(shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data) and 1 or shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option + 1
					
					CBUI_SetText("- "..(ACTION == "'OPEN CONDITION'" and shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Group or (ACTION ~= "'OPEN TELEPORT'" and "EVENT" or "TELEPORT")).." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name)
					CBUI_SetOption({"PREV", "", "NEXT"}, 3)
				end
				
				if CBUI_Select() then
					if shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Code ~= nil then
						if shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Code[1] ~= AreaLoadSpecialEntities then
							local USER_ACTION = UI_MANAGER("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name.." -", "CONFIRM")
							
							if USER_ACTION == "CONFIRM" then
								CBUI_Close()
								
								if shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Code[2][1] == 16 then
									shared.gAccessTattoosRoom = true
								end
								
								shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Code[1](
									unpack(shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Code[2])
								)
								
								if shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Code[2][1] == 16 then
									shared.gAccessTattoosRoom = false
								end
								
								TutorialShowMessage(({[tostring(AreaTransitionXYZ)] = "TELEPORTED!", [tostring(ChapterSet)] = "SEASON APPLIED!", [tostring(WeatherSet)] = "WEATHER APPLIED!", [tostring(PauseGameClock)] = "CLOCK PAUSED!", [tostring(UnpauseGameClock)] = "CLOCK RESUMED!"})[tostring(shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Code[1])], 2500, true)
							end
						else
							local USER_ACTION = UI_MANAGER("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name.." -", {"ADD", "REMOVE"})
							
							if USER_ACTION == "ADD" or USER_ACTION == "REMOVE" then
								CBUI_Close()
								
								for I = 1, table.getn(shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Code[2]) do
									shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Code[1](
										shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Code[2][I],
										USER_ACTION == "ADD"
									)
								end
								
								AreaEnsureSpecialEntitiesAreCreated()
								TutorialShowMessage("EVENT "..({["ADD"] = "ADDED!", ["REMOVE"] = "REMOVED!"})[USER_ACTION], 2500, true)
							end
						end
					else
						if shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name == "Other" then
							local SET_ID = UI_ADJUST("INDEX", 1, 1, 0, 100)
							
							if type(SET_ID) == "number" then
								WeatherSet(SET_ID)
							end
						else
							local CURRENT_HOUR, CURRENT_MINUTE = ClockGet()
							local SET_HOUR = UI_ADJUST("HOUR", CURRENT_HOUR, 1, 1, 24)
							
							if type(SET_HOUR) == "number" then
								ClockSet(SET_HOUR, 0)
							end
						end
					end
				end
			else
				break
			end
		end
	end
end

SUB_AUDIO = function()
	local ACTION = UI_MANAGER("- "..shared.SMAE.Setup[shared.SMAE.Option].Title.." -", {"'OPEN PLAYLIST'", "'OPEN VOICE'", "'EDIT VOLUME'"}, true)
	
	if ACTION == "'OPEN PLAYLIST'" or ACTION == "'OPEN VOICE'" then
		CBUI_SetText("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Group.." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name)
		CBUI_SetOption({"PREV", "", "NEXT"}, 3)
		
		while true do
			Wait(0)
			
			if CBUI_IsActive() and shared.SMAE.SubGUI then
				if CBUI_0() then
					shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option = shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option - 1 < 1 and table.getn(shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data) or shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option - 1
					
					CBUI_SetText("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Group.." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name)
					CBUI_SetOption({"PREV", "", "NEXT"}, 3)
				end
				
				if CBUI_1() then
					shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option = shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option + 1 > table.getn(shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data) and 1 or shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option + 1
					
					CBUI_SetText("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Group.." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name)
					CBUI_SetOption({"PREV", "", "NEXT"}, 3)
				end
				
				if CBUI_Select() then
					if ACTION == "'OPEN PLAYLIST'" then
						local THING = {
							["PLAY AS STREAM"] = {SoundPlayStream, shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name},
							["PLAY AS AMBIENCE"] = {SoundPlayAmbience, shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name},
							["STOP ALL"] = {SoundStopAmbiences, SoundStopStream},
						}
						local USER_ACTION = UI_MANAGER("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name.." -", {"PLAY AS STREAM", "PLAY AS AMBIENCE", "STOP ALL"})
						
						if type(USER_ACTION) == "string" and THING[USER_ACTION] then
							if USER_ACTION ~= "STOP ALL" then
								THING[USER_ACTION][1](THING[USER_ACTION][2], shared.SMAE.AudioVol)
							else
								THING[USER_ACTION][1](); THING[USER_ACTION][2]()
							end
							
							if CBUI_IsActive() then
								CBUI_SetText("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Group.." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name)
								CBUI_SetOption({"PREV", "", "NEXT"}, 3)
							end
						end
					else
						local USER_ACTION = UI_MANAGER("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name.." -", "PLAY SPEECH")
						
						if USER_ACTION == "PLAY SPEECH" then
							SoundStopCurrentSpeechEvent(gPlayer)
							
							if shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option][1] then
								SoundPlayAmbientSpeechEvent(gPlayer, shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name)
							else
								local SPEECH_ID = shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option][2]
								
								for ID = shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option][2] + 1, 151 do
									if not SoundSpeechPlaying(gPlayer) then
										SoundPlayScriptedSpeechEvent(gPlayer, shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name, ID, "xtralarge")
									else
										shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option][2] = ID - 1
										
										break
									end
								end
								
								if shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option][2] == SPEECH_ID then
									shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option][2] = -1
								end
							end
							
							if CBUI_IsActive() then
								CBUI_SetText("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Group.." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name)
								CBUI_SetOption({"PREV", "", "NEXT"}, 3)
							end
						end
					end
				end
			else
				break
			end
		end
	end
	
	if ACTION == "'EDIT VOLUME'" then
		local SET_VOLUME = UI_ADJUST("VOLUME", shared.SMAE.AudioVol, 0.1, 0, 5, true)
		
		if type(SET_VOLUME) == "number" then
			shared.SMAE.AudioVol = SET_VOLUME
		end
	end
end

SUB_ANIMATION = function()
	local ACTION = UI_MANAGER("- "..shared.SMAE.Setup[shared.SMAE.Option].Title.." -", {"'OPEN CHAPTER 1'", "'OPEN CHAPTER 2'", "'OPEN CHAPTER 3'", "'OPEN CHAPTER 4'", "'OPEN CHAPTER 5'", "'OPEN OTHER'"}, true)
	
	if ACTION == "'OPEN CHAPTER 1'" or ACTION == "'OPEN CHAPTER 2'" or ACTION == "'OPEN CHAPTER 3'" or ACTION == "'OPEN CHAPTER 4'" or ACTION == "'OPEN CHAPTER 5'" or ACTION == "'OPEN OTHER'" then
		CBUI_SetText("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Group.." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name)
		CBUI_SetOption({"PREV", "", "NEXT"}, 3)
		
		while true do
			Wait(0)
			
			if CBUI_IsActive() and shared.SMAE.SubGUI then
				if CBUI_0() then
					shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option = shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option - 1 < 1 and table.getn(shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data) or shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option - 1
					
					CBUI_SetText("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Group.." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name)
					CBUI_SetOption({"PREV", "", "NEXT"}, 3)
				end
				
				if CBUI_1() then
					shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option = shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option + 1 > table.getn(shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data) and 1 or shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option + 1
					
					CBUI_SetText("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Group.." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name)
					CBUI_SetOption({"PREV", "", "NEXT"}, 3)
				end
				
				if CBUI_Select() then
					local USER_ACTION = UI_MANAGER("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name.." -", {"SET TO PLAYER", "SET TO NPC", "SET AS PLAYER IDLE", "CLEAR PLAYER IDLE"})
					CBUI_Close()
					
					F.LOADANIM(shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option][2])
					
					if USER_ACTION == "SET TO PLAYER" or USER_ACTION == "SET TO NPC" then
						local PED = USER_ACTION == "SET TO PLAYER" and gPlayer or F.PCHOOSE(false)
						
						if PedIsValid(PED) then
							PedSetActionNode(PED, shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option][1], shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option][2])
							TutorialShowMessage("ANIM PLAYED!", 2500, true)
						else
							TutorialShowMessage("ACTION FAILED!", 2500, true)
						end
					end
					
					if USER_ACTION == "SET AS PLAYER IDLE" then
						shared.SMAE.Idle[2] = false
						PlayerStopAllActionControllers()
						
						shared.SMAE.Idle[1][1], shared.SMAE.Idle[1][2], shared.SMAE.Idle[2] = shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option][1], shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option][2], true
						
						if not ADVT_IDLE_THREAD then
							ADVT_IDLE_THREAD = CreateThread("SMAE_IDLE")
						end
						TutorialShowMessage("IDLE ANIM ADDED!", 2500, true)
					end
					
					if USER_ACTION == "CLEAR PLAYER IDLE" then
						local DELETE = type(shared.SMAE.Idle[1][1]) == "string"
						
						if DELETE then
							PedSetActionNode(gPlayer, unpack(shared.SMAE.Player[2]))
							
							shared.SMAE.Idle[2] = false
							shared.SMAE.Idle[1][1], shared.SMAE.Idle[1][2] = nil, nil
							
							if ADVT_IDLE_THREAD then
								TerminateThread(ADVT_IDLE_THREAD)
								ADVT_IDLE_THREAD = nil
							end
						end
						
						TutorialShowMessage(DELETE and "IDLE ANIM REMOVED!" or "NO IDLE ANIM!", 2500, true)
					end
				end
			else
				break
			end
		end
	end
end

SUB_FACTION = function()
	local ACTION = UI_MANAGER("- "..shared.SMAE.Setup[shared.SMAE.Option].Title.." -", {"'OPEN FACTION'", "'OPEN RESPECT'", "'OPEN ATTITUDE'"}, true)
	
	if ACTION == "'OPEN FACTION'" or ACTION == "'OPEN RESPECT'" or ACTION == "'OPEN ATTITUDE'" then
		CBUI_SetText("- "..shared.SMAE.Setup[shared.SMAE.Option].Title.." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[shared.SMAE.Setup[shared.SMAE.Option].Option].Name)
		CBUI_SetOption({"PREV", "", "NEXT"}, 3)
		
		while true do
			Wait(0)
			
			if CBUI_IsActive() and shared.SMAE.SubGUI then
				if CBUI_0() then
					shared.SMAE.Setup[shared.SMAE.Option].Option = shared.SMAE.Setup[shared.SMAE.Option].Option - 1 < 1 and table.getn(shared.SMAE.Setup[shared.SMAE.Option].Data) or shared.SMAE.Setup[shared.SMAE.Option].Option - 1
					
					CBUI_SetText("- "..shared.SMAE.Setup[shared.SMAE.Option].Title.." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[shared.SMAE.Setup[shared.SMAE.Option].Option].Name)
					CBUI_SetOption({"PREV", "", "NEXT"}, 3)
				end
				
				if CBUI_1() then
					shared.SMAE.Setup[shared.SMAE.Option].Option = shared.SMAE.Setup[shared.SMAE.Option].Option + 1 > table.getn(shared.SMAE.Setup[shared.SMAE.Option].Data) and 1 or shared.SMAE.Setup[shared.SMAE.Option].Option + 1
					
					CBUI_SetText("- "..shared.SMAE.Setup[shared.SMAE.Option].Title.." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[shared.SMAE.Setup[shared.SMAE.Option].Option].Name)
					CBUI_SetOption({"PREV", "", "NEXT"}, 3)
				end
				
				if CBUI_Select() then
					if ACTION == "'OPEN FACTION'" then
						local USER_ACTION = UI_MANAGER("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[shared.SMAE.Setup[shared.SMAE.Option].Option].Name.." -", "SET TO NPC")
						
						if USER_ACTION == "SET TO NPC" then
							CBUI_Close()
							
							local PED = F.PCHOOSE(false)
							
							if PedIsValid(PED) then
								PedSetFaction(PED, shared.SMAE.Setup[shared.SMAE.Option].Data[shared.SMAE.Setup[shared.SMAE.Option].Option].ID)
							end
						end
					else
						local IS_RESPECT = ACTION == "'OPEN RESPECT'"
						local SET_VAL = UI_ADJUST(
							IS_RESPECT and "RESPECT" or "ATTITUDE",
							IS_RESPECT and GetFactionRespect(shared.SMAE.Setup[shared.SMAE.Option].Data[shared.SMAE.Setup[shared.SMAE.Option].Option].ID) or PedGetTypeToTypeAttitude(shared.SMAE.Setup[shared.SMAE.Option].Data[shared.SMAE.Setup[shared.SMAE.Option].Option].ID, 13), 
							IS_RESPECT and 5 or 1, 
							0, 
							IS_RESPECT and 100 or 4, 
							IS_RESPECT
						)
						
						if type(SET_VAL) == "number" then
							(IS_RESPECT and SetFactionRespect or PedSetDefaultTypeToTypeAttitude)(shared.SMAE.Setup[shared.SMAE.Option].Data[shared.SMAE.Setup[shared.SMAE.Option].Option].ID, IS_RESPECT and SET_VAL or 13, IS_RESPECT and nil or SET_VAL)
						end
					end
				end
			else
				break
			end
		end
	end
end

SUB_APPAREL = function()
	local ACTION = UI_MANAGER("- "..shared.SMAE.Setup[shared.SMAE.Option].Title.." -", {"'OPEN HEAD'", "'OPEN TORSO'", "'OPEN L-HAND'", "'OPEN R-HAND'", "'OPEN LEG'", "'OPEN FEET'", "'OPEN OUTFIT'"}, true)
	
	if ACTION == "'OPEN HEAD'" or ACTION == "'OPEN TORSO'" or ACTION == "'OPEN L-HAND'" or ACTION == "'OPEN R-HAND'" or ACTION == "'OPEN LEG'" or ACTION == "'OPEN FEET'" or ACTION == "'OPEN OUTFIT'" then
		local SUB = {
			["'OPEN HEAD'"] = "HEAD", ["'OPEN TORSO'"] = "TORSO", ["'OPEN L-HAND'"] = "LEFT HAND",
			["'OPEN R-HAND'"] = "RIGHT HAND", ["'OPEN LEG'"] = "LEG", ["'OPEN FEET'"] = "FEET",
			["'OPEN OUTFIT'"] = "OUTFIT",
		}
		
		CBUI_SetText("- "..(SUB[ACTION] == "OUTFIT" and shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Group or (SUB[ACTION] or "UNNAMED")).." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name)
		CBUI_SetOption({"PREV", "", "NEXT"}, 3)
		
		while true do
			Wait(0)
			
			if CBUI_IsActive() and shared.SMAE.SubGUI then
				if CBUI_0() then
					shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option = shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option - 1 < 1 and table.getn(shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data) or shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option - 1
					
					CBUI_SetText("- "..(SUB[ACTION] == "OUTFIT" and shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Group or (SUB[ACTION] or "UNNAMED")).." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name)
					CBUI_SetOption({"PREV", "", "NEXT"}, 3)
				end
				
				if CBUI_1() then
					shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option = shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option + 1 > table.getn(shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data) and 1 or shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option + 1
					
					CBUI_SetText("- "..(SUB[ACTION] == "OUTFIT" and shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Group or (SUB[ACTION] or "UNNAMED")).." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name)
					CBUI_SetOption({"PREV", "", "NEXT"}, 3)
				end
				
				if CBUI_Select() then
					local USER_ACTION = UI_MANAGER("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name.." -", (shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Code == nil and "STORE" or "SET").." "..(SUB[ACTION] or "UNNAMED"))
					
					if USER_ACTION == "SET "..(SUB[ACTION] or "UNNAMED") or USER_ACTION == "STORE "..(SUB[ACTION] or "UNNAMED") then
						CBUI_Close()
						
						if USER_ACTION == "SET "..(SUB[ACTION] or "UNNAMED") then
							if ACTION == "'OPEN OUTFIT'" then
								ClothingSetPlayerOutfit(shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Code)
								ClothingGivePlayerOutfit(shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Code)
							else
								ClothingSetPlayer(shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Code[1], shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Code[2])
								ClothingGivePlayer(shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Code[2], shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Code[1])
							end
							
							if PedIsModel(gPlayer, 0) then
								ClothingBuildPlayer()
							end
							
							TutorialShowMessage((ACTION == "'OPEN OUTFIT'" and "OUTFIT" or "ITEM").." APPLIED!", 2500, true)
						else
							for _, T in ipairs(shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data) do
								if T.Name ~= "STORE ALL" then
									if ACTION == "'OPEN OUTFIT'" then
										ClothingGivePlayerOutfit(T.Code)
									else
										ClothingGivePlayer(T.Code[2], T.Code[1])
									end
								end
							end
							
							TutorialShowMessage((ACTION == "'OPEN OUTFIT'" and "OUTFITS" or "ITEMS").." STORED!", 2500, true)
						end
					end
				end
			else
				break
			end
		end
	end
end

SUB_HAIRCUT = function()
	local ACTION = UI_MANAGER("- "..shared.SMAE.Setup[shared.SMAE.Option].Title.." -", "'OPEN'", true)
	
	if ACTION == "'OPEN'" then
		CBUI_SetText("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[shared.SMAE.Setup[shared.SMAE.Option].Option].Group.." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[shared.SMAE.Setup[shared.SMAE.Option].Option].Name)
		CBUI_SetOption({"PREV", "", "NEXT"}, 3)
		
		while true do
			Wait(0)
			
			if CBUI_IsActive() and shared.SMAE.SubGUI then
				if CBUI_0() then
					shared.SMAE.Setup[shared.SMAE.Option].Option = shared.SMAE.Setup[shared.SMAE.Option].Option - 1 < 1 and table.getn(shared.SMAE.Setup[shared.SMAE.Option].Data) or shared.SMAE.Setup[shared.SMAE.Option].Option - 1
					
					CBUI_SetText("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[shared.SMAE.Setup[shared.SMAE.Option].Option].Group.." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[shared.SMAE.Setup[shared.SMAE.Option].Option].Name)
					CBUI_SetOption({"PREV", "", "NEXT"}, 3)
				end
				
				if CBUI_1() then
					shared.SMAE.Setup[shared.SMAE.Option].Option = shared.SMAE.Setup[shared.SMAE.Option].Option + 1 > table.getn(shared.SMAE.Setup[shared.SMAE.Option].Data) and 1 or shared.SMAE.Setup[shared.SMAE.Option].Option + 1
					
					CBUI_SetText("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[shared.SMAE.Setup[shared.SMAE.Option].Option].Group.." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[shared.SMAE.Setup[shared.SMAE.Option].Option].Name)
					CBUI_SetOption({"PREV", "", "NEXT"}, 3)
				end
				
				if CBUI_Select() then
					local USER_ACTION = UI_MANAGER("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[shared.SMAE.Setup[shared.SMAE.Option].Option].Name.." -", "SET HAIRCUT")
					
					if USER_ACTION == "SET HAIRCUT" then
						CBUI_Close()
						
						ClothingSetPlayersHair(shared.SMAE.Setup[shared.SMAE.Option].Data[shared.SMAE.Setup[shared.SMAE.Option].Option].Code)
						if PedIsModel(gPlayer, 0) then
							ClothingBuildPlayer()
						end
						
						TutorialShowMessage("HAIRCUT APPLIED!", 2500, true)
					end
				end
			else
				break
			end
		end
	end
end

SUB_OBJECT = function()
	local ACTION = UI_MANAGER("- "..shared.SMAE.Setup[shared.SMAE.Option].Title.." -", {"'OPEN PROPERTY'", "'OPEN PROJECTILE'", "'OPEN ALL MESHES'"}, true)
	
	if ACTION == "'OPEN PROPERTY'" or ACTION == "'OPEN PROJECTILE'" or ACTION == "'OPEN ALL MESHES'" then
		local SUB = {
			["'OPEN PROPERTY'"] = "PROPERTY", 
			["'OPEN PROJECTILE'"] = "PROJECTILE", 
			["'OPEN ALL MESHES'"] = "ALL MESHES",
		}
		
		CBUI_SetText("- "..(SUB[ACTION] or "UNNAMED").." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name)
		CBUI_SetOption({"PREV", "", "NEXT"}, 3)
		
		while true do
			Wait(0)
			
			if CBUI_IsActive() and shared.SMAE.SubGUI then
				if CBUI_0() then
					shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option = shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option - 1 < 1 and table.getn(shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data) or shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option - 1
					
					CBUI_SetText("- "..(SUB[ACTION] or "UNNAMED").." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name)
					CBUI_SetOption({"PREV", "", "NEXT"}, 3)
				end
				
				if CBUI_1() then
					shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option = shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option + 1 > table.getn(shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data) and 1 or shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option + 1
					
					CBUI_SetText("- "..(SUB[ACTION] or "UNNAMED").." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name)
					CBUI_SetOption({"PREV", "", "NEXT"}, 3)
				end
				
				if CBUI_Select() then
					local USER_ACTION = UI_MANAGER("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name.." -", ACTION == "'OPEN PROJECTILE'" and "USE" or {"SPAWN", "CLEAR"})
					
					if USER_ACTION == "USE" or USER_ACTION == "SPAWN" then
						CBUI_Close()
						
						if USER_ACTION == "USE" then
							F.CSPOT({TYPE = "PROJ", shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Code, shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Damage, GetTimer() + 100})
						else
							local PX, PY, PZ = PedGetOffsetInWorldCoords(gPlayer, 0, 1.5, 0)
							local CODE = ACTION == "'OPEN PROPERTY'" and "Code" or "Name"
							
							if not SPAWNED_OBJECT then
								SPAWNED_OBJECT = {}
							end
							
							local INDEX, POOL = CreatePersistentEntity(
								shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option][CODE],
								PX, PY, PZ, 0, AreaGetVisible()
							)
							
							if not ADDITIONAL_PROPERTY then
								ADDITIONAL_PROPERTY = function(X, Y, Z, ROT)
									local ADD_ON = {
										["Soda Machine"] = {"pxFraffy", 0},
										["Spud Turret"] = {"WPCannon", 0.75},
										["Ladder (3M)"] = {"pxLad3M", 0},
										["Ladder (4M)"] = {"pxLad4M", 0},
										["Ladder (5M)"] = {"pxLad5M", 0},
										["Ladder (7M)"] = {"pxLad7M", 0},
										["Ladder (10M)"] = {"pxLad10M", 0},
										["Ladder (12M)"] = {"pxLad12M", 0},
									}
									
									if ADD_ON[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name] then
										local INDEX, POOL = CreatePersistentEntity(
											ADD_ON[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name][1],
											X, Y, Z + ADD_ON[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name][2], ROT, AreaGetVisible()
										)
										
										table.insert(SPAWNED_OBJECT, {
											ADD_ON[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name][1], 
											INDEX, POOL, X, Y, Z + ADD_ON[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name][2], ROT, AreaGetVisible()
										})
									end
								end
							end
							
							F.CSPOT({TYPE = "PROP", INDEX, POOL, shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option][CODE]}, ADDITIONAL_PROPERTY)
						end
					end
					
					if USER_ACTION == "CLEAR" then
						CBUI_Close()
						
						local COUNT = SPAWNED_OBJECT and table.getn(SPAWNED_OBJECT) or 0
						if COUNT > 0 then
							for _, CONTENT in ipairs(SPAWNED_OBJECT) do
								DeletePersistentEntity(CONTENT[2], CONTENT[3])
							end
							
							SPAWNED_OBJECT = {}
						end
						TutorialShowMessage(COUNT > 0 and COUNT.." OBJECT"..(COUNT > 1 and "S" or "").." DELETED!" or "NO OBJECT SPAWNED!", 2500, true)
					end
				end
			else
				break
			end
		end
	end
end

SUB_SYSTEM = function()
	local ACTION = UI_MANAGER("- "..shared.SMAE.Setup[shared.SMAE.Option].Title.." -", {"'OPEN TOOL'", "'OPEN TOGGLE'", "'OPEN CREDIT'"}, true)
	
	if ACTION == "'OPEN TOOL'" or ACTION == "'OPEN TOGGLE'" or ACTION == "'OPEN CREDIT'" then
		CBUI_SetText("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Group.." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name)
		CBUI_SetOption({"PREV", "", "NEXT"}, 3)
		
		while true do
			Wait(0)
			
			if CBUI_IsActive() and shared.SMAE.SubGUI then
				if CBUI_0() then
					shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option = shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option - 1 < 1 and table.getn(shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data) or shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option - 1
					
					CBUI_SetText("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Group.." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name)
					CBUI_SetOption({"PREV", "", "NEXT"}, 3)
				end
				
				if CBUI_1() then
					shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option = shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option + 1 > table.getn(shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data) and 1 or shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option + 1
					
					CBUI_SetText("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Group.." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name)
					CBUI_SetOption({"PREV", "", "NEXT"}, 3)
				end
				
				if CBUI_Select() then
					if ACTION == "'OPEN TOOL'" then
						if shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name ~= "Clothing Manager" then
							local USER_ACTION = UI_MANAGER("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name.." -", "SELECT PED")
							
							if USER_ACTION == "SELECT PED" then
								CBUI_Close()
								local PED = F.PCHOOSE(true)
								
								if PedIsValid(PED) then
									if shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name == "Recruit NPC" then
										if PED == gPlayer then
											TutorialShowMessage("PED MUST BE NPC", 2500, true)
										else
											if PedHasAllyFollower(gPlayer) then
												local CONTINUE = true
												
												local LEADER = gPlayer
												while PedHasAllyFollower(LEADER) do
													LEADER = PedGetAllyFollower(LEADER)
													
													if LEADER == PED then
														CONTINUE = false
														break
													end
												end
												
												if CONTINUE then
													F.PALLY(gPlayer, PED, true)
												end
											else
												F.PALLY(gPlayer, PED, true)
											end
										end
									end
									
									if shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name == "Dismiss NPC" then
										if PED == gPlayer then
											TutorialShowMessage("PED MUST BE NPC", 2500, true)
										else
											PedDismissAlly(PedGetAllyLeader(PED), PED)
										end
									end
									
									if shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Group == "STAT" then
										if PED ~= gPlayer then
											F.CFOLLOW(PED)
										end
										
										local NAME = shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name
										local SUB = {
											["Set Health"] = {"HEALTH", PedGetHealth(PED), 9999, PedSetHealth},
											["Set Punishment Points"] = {"POINT", PED == gPlayer and PlayerGetPunishmentPoints() or 0, 300, PedSetPunishmentPoints},
											["Set Animation Speed"] = {"SPEED", GameGetPedStat(PED, 20), 1000, GameSetPedStat},
											["Set Weapon Damage Scale"] = {"DAMAGE", GameGetPedStat(PED, 31), 5000, GameSetPedStat},
										}
										
										local BACKUP = SUB[NAME][2]
										shared.gActiveControl = false
										
										while true do
											Wait(0)
											
											PlayerLockButtonInputsExcept(true, 18, 19)
											PedSetInvulnerable(gPlayer, true)
											PlayerSetPosSimple(shared.SMAE.X, shared.SMAE.Y, shared.SMAE.Z)
											
											SUB[NAME][2] = (CTRL.N(6, 0) or CTRL.N(12, 0) or CTRL.F(6, 0) or CTRL.F(12, 0)) and (SUB[NAME][2] + 1 > SUB[NAME][3] and 0 or SUB[NAME][2] + 1) or ((CTRL.N(8, 0) or CTRL.F(8, 0)) and (SUB[NAME][2] - 1 < 0 and SUB[NAME][3] or SUB[NAME][2] - 1) or SUB[NAME][2])
											if CTRL.N(6, 0) or CTRL.F(6, 0) or CTRL.N(8, 0) or CTRL.F(8, 0) then
												SUB[NAME][4](PED, SUB[NAME][4] == GameSetPedStat and (SUB[NAME][1] == "SPEED" and 20 or 31) or SUB[NAME][2], SUB[NAME][4] == GameSetPedStat and SUB[NAME][2] or nil)
											end
											
											if PedIsDead(PED) or not PedIsValid(PED) or CTRL.N(11, 0) or CTRL.N(2, 0) then
												break
											end
											
											MinigameSetAnnouncement("- "..SUB[NAME][1]..": "..SUB[NAME][2].." -\n[Weapon] OK", true)
										end
										
										MinigameSetAnnouncement("", true)
										
										if CTRL.N(11, 0) then
											CTRL.W(11, 0)
											TutorialShowMessage("CONFIRMED!", 2500, true)
										else
											SUB[NAME][4](PED, SUB[NAME][4] == GameSetPedStat and (SUB[NAME][1] == "SPEED" and 20 or 31) or BACKUP, SUB[NAME][4] == GameSetPedStat and BACKUP or nil)
											TutorialShowMessage("CANCELED!", 2500, true)
										end
										
										PedSetInvulnerable(gPlayer, false)
										PlayerStopAllActionControllers()
										PlayerLockButtonInputsExcept(false)
										
										shared.gActiveControl = true
										
										if PED ~= gPlayer then
											F.CFOLLOW(gPlayer)
										end
									end
									
									if shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name == "Knockout" then
										PedApplyDamage(PED, PedGetMaxHealth(PED) + 1)
									end
									
									if shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name == "Delete NPC" then
										if PED == gPlayer then
											TutorialShowMessage("PED MUST BE NPC", 2500, true)
										else
											PedDelete(PED)
										end
									end
									
									if shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name == "Adjust Position" then
										F.PMOVE(PED)
									end
									
									if shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name == "Mind Control" then
										if PED == gPlayer then
											TutorialShowMessage("PED MUST BE NPC", 2500, true)
										else
											local NPC_STYLE = F.PTREE(PED)
											local NPC_FACTION = PedGetFaction(PED)
											
											PedSetControllerID(PED, 0)
											PedStop(PED)
											PedLockTarget(PED, -1)
											PedSetActionTree(PED, "/Global/Player", "Act/Player.act")
											PedSetAITree(PED, "/Global/PlayerAI", "Act/PlayerAI.act")
											PedSetFaction(PED, 13)
											
											local NAME = STR.PEDNAME(PedGetName(PED), false)
											F.CFOLLOW(PED)
											
											shared.gMindControl = true
											PedSetActionNode(gPlayer, unpack(shared.SMAE.Player[2]))
											
											TutorialShowMessage("[Zoom In] BACK", -1, true)
											local PED_TARGET
											
											while true do
												Wait(0)
												
												PED_TARGET = {PedGetTargetPed(PED), PedGetGrappleTargetPed(PED)}
												
												if PedIsValid(PED) and PedGetHealth(PED) > 0 and PedGetHealth(gPlayer) > 0 and not IsButtonBeingPressed(2, 0) then
													if PedMePlaying(PED, "DEFAULT_KEY") and not PedIsInAnyVehicle(PED) then
														
														if PedHasWeapon(PED, 328) or PedHasWeapon(PED, 426) then
															PlayerLockButtonInputsExcept(true, 0, 1, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 24)
															
															if CameraGetActive() == 13 or CameraGetActive() == 2 then
																CameraSetActive(1, 0.5, false)
															end
														else
															PlayerLockButtonInputsExcept(false)
														end
														
														if PedGetWeapon(PED) ~= PedGetWeapon(gPlayer) then
															if PedGetWeapon(gPlayer) ~= 437 then
																PedDestroyWeapon(PED, PedGetWeapon(PED))
															end
															
															PedSetWeapon(PED, PedGetWeapon(gPlayer) == 437 and -1 or PedGetWeapon(gPlayer), 100)
														end
													end
												else
													break
												end
											end
											
											if PedIsValid(PED) then
												if PedHasWeapon(PED, 328) or PedHasWeapon(PED, 426) then
													PlayerLockButtonInputsExcept(false)
												end
												
												PedSetControllerID(PED, -1)
												PedSetFaction(PED, NPC_FACTION)
												
												PedLockTarget(PED, -1)
												PedSetWeapon(PED, -1)
												
												if PedGetHealth(PED) > 0 then
													PedSetActionTree(PED, unpack(NPC_STYLE))
													PedSetAITree(PED, "/Global/AI", "Act/AI/AI.act")
													PedMakeAmbient(PED)
												else
													PedPlayHitReaction(PED)
												end
											end
											
											PedSetControllerID(gPlayer, 0)
											F.SWAP(true, shared.SMAE.Player[1], shared.SMAE.Player[2])
											PlayerStopAllActionControllers()
											if shared.SMAE.Player[1] == "Player" or shared.SMAE.Player[1] == "player" then
												ClothingBuildPlayer()
											end
											PedSetWeapon(gPlayer, -1)
											
											F.CFOLLOW(gPlayer)
											
											if PedGetHealth(gPlayer) < 1 then
												PedPlayHitReaction(gPlayer)
											end
											
											TutorialShowMessage("RETURNED!", 2500, true)
											shared.gMindControl = false
										end
									end
									
									if shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name == "Manipulate Attack" then
										if PED == gPlayer then
											TutorialShowMessage("PED MUST BE NPC", 2500, true)
										else
											local PREY, COUNT = nil, -1
											local NAME = STR.PEDNAME(PedGetName(PED), false)
											
											while true do
												Wait(0)
												
												PlayerLockButtonInputsExcept(true, 18, 19)
												
												PedSetInvulnerable(gPlayer, true)
												PlayerSetPosSimple(shared.SMAE.X, shared.SMAE.Y, shared.SMAE.Z)
												
												local RESHUFFLE = function(NUM)
													local PS = F.PSORT(true, true)
													
													COUNT = (not PREY or not PedIsValid(PREY)) and 0 or COUNT + NUM
													while not PS.ORDER[COUNT] or PS.ORDER[COUNT] == PED do
														COUNT = COUNT + NUM < 0 and PS.MAXN or (COUNT + NUM > PS.MAXN and 0 or COUNT + NUM)
													end
													
													PedSetActionNode(gPlayer, "/Global", "Act/Globals.act")
													
													F.CFOLLOW(PS.ORDER[COUNT])
													return PS.ORDER[COUNT]
												end
												
												PREY = (type(PREY) == "nil" or not PedIsValid(PREY) or CTRL.N(6, 0) or CTRL.N(12, 0) or CTRL.F(6, 0) or CTRL.F(12, 0)) and RESHUFFLE(1) or ((CTRL.N(8, 0) or CTRL.F(8, 0)) and RESHUFFLE(-1) or PREY)
												if CTRL.N(11, 0) or CTRL.N(2, 0) or not PedIsValid(PED) then
													break
												end
												
												MinigameSetAnnouncement(NAME.." vs "..STR.PEDNAME(PedGetName(PREY), false), true)
											end
											
											MinigameSetAnnouncement("", true)
											
											if CTRL.N(11, 0) then
												CTRL.W(11, 0)
												
												if PREY ~= gPlayer then
													if PedGetFaction(PED) == PedGetFaction(PREY) then
														PedSetPedToTypeAttitude(PED, PedGetFaction(PREY), 3)
														PedSetPedToTypeAttitude(PREY, PedGetFaction(PED), 3)
														
														PedSetEmotionTowardsPed(PED, PREY, 0)
														PedSetEmotionTowardsPed(PREY, PED, 0)
													end
												else
													if PedGetPedToTypeAttitude(PED, 13) == 4 then
														PedSetPedToTypeAttitude(PED, 13, 0)
														PedSetEmotionTowardsPed(PED, PREY, 0)
													end
												end
												
												PedStop(PED)
												PedClearObjectives(PED)
												_G["PedAttack"..(PREY == gPlayer and "Player" or "")](PED, PREY == gPlayer and 3 or PREY, PREY ~= gPlayer and 1 or nil)
												
												TutorialShowMessage("CONFIRMED!", 2500, true)
											else
												if CTRL.N(2, 0) then
													TutorialShowMessage("CANCELED!", 2500, true)
												else
													TutorialShowMessage("PED DOES NOT EXIST", 2500, true)
												end
											end
											
											PedSetInvulnerable(gPlayer, false)
											PlayerStopAllActionControllers()
											PlayerLockButtonInputsExcept(false)
											
											F.CFOLLOW(gPlayer)
										end
									end
									
									if shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name == "Coordinates" then
										if PED ~= gPlayer then
											F.CFOLLOW(PED)
										end
										
										while true do
											Wait(0)
											
											if CTRL.N(2, 0) or CTRL.N(15, 0) then
												break
											end
											
											MinigameSetAnnouncement("[Zoom In] OK | [Crouch] EXIT", true)
										end
										
										if CTRL.N(2, 0) then
											local A, P = AreaGetVisible(), {PedGetPosXYZ(PED)}
											
											P[1] = P[1] and string.format("%.2f", P[1]) or 0
											P[2] = P[2] and string.format("%.2f", P[2]) or 0
											P[3] = P[3] and string.format("%.2f", P[3]) or 0
											
											local H = PedGetHeading(PED) * 57.3
											H = H and string.format("%.0f", H < 0 and H * -1 or H) or 0
											
											CB_Print("AREA = "..A..", X = "..P[1]..", Y = "..P[2]..", Z = "..P[3].."\nHEADING = "..H.." DEG", 60)
										else
											PedGetFlag(gPlayer, 2, false)
										end
										
										MinigameSetAnnouncement("", true)
										
										if CTRL.N(15, 0) then
											TutorialShowMessage("CANCELED!", 2500, true)
										else
											TutorialShowMessage("CONFIRMED!", 2500, true)
										end
										
										if PED ~= gPlayer then
											F.CFOLLOW(gPlayer)
										end
									end
									
									if shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name == "Action Nodes" then
										if PED ~= gPlayer then
											F.CFOLLOW(PED)
										end
										
										local TIMER = GetTimer()
										local NODE, ACT = nil, nil
										
										while true do
											Wait(0)
											
											NODE, ACT = F.PGAN(gPlayer)
											MinigameSetAnnouncement("[Zoom In] OK | [Crouch] EXIT", true)
											
											if CTRL.N(2, 0) or CTRL.N(15, 0) then
												break
											end
										end
										
										MinigameSetAnnouncement("", true)
										
										if CTRL.N(2, 0) then
											CB_Print('"'..NODE..'"\n"'..ACT..'"', 60)
											TutorialShowMessage("CONFIRMED!", 2500, true)
										else
											PedGetFlag(gPlayer, 2, false)
											TutorialShowMessage("CANCELED!", 2500, true)
										end
										
										if PED ~= gPlayer then
											F.CFOLLOW(gPlayer)
										end
									end
								end
							end
						else
							local USER_ACTION = UI_MANAGER("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name.." -", "OPEN")
							
							if USER_ACTION == "OPEN" then
								CBUI_Close()
								
								PlayerSetControl(0)
								CameraFade(500,0)
								Wait(501)
								
								shared.PlayerInClothingManager = true
								
								local CAM = {PedGetOffsetInWorldCoords(gPlayer, 1.5, 3, 1.2)}
								local POS = {PedGetOffsetInWorldCoords(gPlayer, 1.5, 0, 1)}
								
								MissionTimerPause(true)
								
								local HUD_COMPONENT, ANIM_TIMER, CANCEL = {
									{0, false}, {4, false}, {11, false}, {14, true}
								}, GetTimer(), false
								
								for _, HUD in ipairs(HUD_COMPONENT) do
									ToggleHUDComponentVisibility(unpack(HUD))
								end
								
								CameraSetXYZ(CAM[1], CAM[2], CAM[3], POS[1], POS[2], POS[3])
								CameraAllowChange(false)
								CameraAllowScriptedChange(false)
								ClothingBackup()
								Wait(501)
								CameraFade(500, 1)
								
								PedSetActionNode(gPlayer, "/Global/Ambient/MissionSpec/Clothing/TryingOn", "Act/Anim/Ambient.act")
								
								repeat
									Wait(0)
									
									if ANIM_TIMER + 10000 < GetTimer() then
										PedSetActionNode(gPlayer, "/Global/Ambient/MissionSpec/Clothing/TryingOn", "Act/Anim/Ambient.act")
										ANIM_TIMER = GetTimer()
									end
									
									if IsButtonBeingPressed(8, 0) then
										CANCEL = true
										
										break
									end
								until IsButtonBeingPressed(7, 0)
								
								CameraFade(500, 0)
								Wait(501)
								
								if CANCEL == true then
									ClothingRestore()
									ClothingBuildPlayer()
								end
								
								HUD_COMPONENT = {
									{0, true}, {4, true}, {11, true}, {14, false}
								}
								for _, HUD in ipairs(HUD_COMPONENT) do
									ToggleHUDComponentVisibility(unpack(HUD))
								end
								
								PlayerSetControl(1)
								PlayerStopAllActionControllers()
								
								shared.PlayerInClothingManager = false
								
								CameraAllowChange(true)
								CameraAllowScriptedChange(true)
								CameraReturnToPlayer()
								MissionTimerPause(false)
								
								Wait(501)
								CameraFade(500, 1)
							end
						end
					end
					
					if ACTION == "'OPEN TOGGLE'" then
						local REVERSE_STATE = string.find(shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name, "OFF |", 1) and "ON" or "OFF"
						local USER_ACTION = UI_MANAGER("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name.." -", "TURN "..REVERSE_STATE)
						
						if USER_ACTION == "TURN "..REVERSE_STATE then
							if not string.find(shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name, "Mayhem", 1) then
								shared.SMAE.Settings[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Code] = not shared.SMAE.Settings[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Code]
							end
							
							local REVERSE_STRING = {
								["OFF | Immortal"] = "ON | Immortal",
								["ON | Immortal"] = "OFF | Immortal",
								["OFF | Transparent"] = "ON | Transparent",
								["ON | Transparent"] = "OFF | Transparent",
								["OFF | Instant Kill"] = "ON | Instant Kill",
								["ON | Instant Kill"] = "OFF | Instant Kill",
								["OFF | Innocent Man"] = "ON | Innocent Man",
								["ON | Innocent Man"] = "OFF | Innocent Man",
								["OFF | Rapid Shot"] = "ON | Rapid Shot",
								["ON | Rapid Shot"] = "OFF | Rapid Shot",
								["OFF | Unlimited Ammo"] = "ON | Unlimited Ammo",
								["ON | Unlimited Ammo"] = "OFF | Unlimited Ammo",
								["OFF | Free Shop"] = "ON | Free Shop",
								["ON | Free Shop"] = "OFF | Free Shop",
								
								["OFF | Mute"] = "ON | Mute",
								["ON | Mute"] = "OFF | Mute",
								["OFF | Mayhem"] = "ON | Mayhem",
								["ON | Mayhem"] = "OFF | Mayhem",
								["OFF | Harmony"] = "ON | Harmony",
								["ON | Harmony"] = "OFF | Harmony",
								["OFF | Empty World"] = "ON | Empty World",
								["ON | Empty World"] = "OFF | Empty World",
								
								["OFF | Art Freeze"] = "ON | Art Freeze",
								["ON | Art Freeze"] = "OFF | Art Freeze",
								["OFF | Math BOT"] = "ON | Math BOT",
								["ON | Math BOT"] = "OFF | Math BOT",
								["OFF | Unlimited Timer"] = "ON | Unlimited Timer",
								["ON | Unlimited Timer"] = "OFF | Unlimited Timer",
								["OFF | Skip Cutscene"] = "ON | Skip Cutscene",
								["ON | Skip Cutscene"] = "OFF | Skip Cutscene",
								
								["OFF | Game Sound"] = "ON | Game Sound",
								["ON | Game Sound"] = "OFF | Game Sound",
								["OFF | Cutscene Music"] = "ON | Cutscene Music",
								["ON | Cutscene Music"] = "OFF | Cutscene Music",
								
								["OFF | Trouble Meter"] = "ON | Trouble Meter",
								["ON | Trouble Meter"] = "OFF | Trouble Meter",
								["OFF | Health Bar"] = "ON | Health Bar",
								["ON | Health Bar"] = "OFF | Health Bar",
								["OFF | Mini Map"] = "ON | Mini Map",
								["ON | Mini Map"] = "OFF | Mini Map",
								["OFF | Time Lap"] = "ON | Time Lap",
								["ON | Time Lap"] = "OFF | Time Lap",
								
								["OFF | Cinematic"] = "ON | Cinematic",
								["ON | Cinematic"] = "OFF | Cinematic",
								["OFF | On Fire"] = "ON | On Fire",
								["ON | On Fire"] = "OFF | On Fire",
								["OFF | Muddy"] = "ON | Muddy",
								["ON | Muddy"] = "OFF | Muddy",
							}
							
							shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name = REVERSE_STRING[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name] or "Unnamed"
							
							if shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name == "OFF | Immortal" then
								PedSetFlag(gPlayer, 58, false)
							end
							if shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name == "OFF | Innocent Man" then
								DisablePunishmentSystem(false)
								PedSetFlag(gPlayer, 117, true)
							end
							if shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name == "OFF | Unlimited Ammo" then
								PedSetFlag(gPlayer, 24, false)
							end
							if shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name == "OFF | Mute" then
								for _, PED in {PedFindInAreaXYZ(0, 0, 0, 999999)} do
									if PedIsValid(PED) and PED ~= gPlayer and PedGetFlag(PED, 129) then
										PedSetFlag(PED, 129, false)
									end
								end
							end
							if shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name == "OFF | Game Sound" then
								SoundPause()
							end
							if shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name == "ON | Game Sound" then
								SoundContinue()
							end
							if shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name == "OFF | Cutscene Music" then
								MusicAllowPlayDuringCutscenes(false)
							end
							if shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name == "ON | Mayhem" then
								shared.SMAE.Settings.Mayhem[1], shared.SMAE.Settings.Mayhem[2] = true, GetTimer() + 10000
								
								for MF = 0, 11 do
									if type(shared.SMAE.Settings.Mayhem[3][MF]) ~= "table" then
										shared.SMAE.Settings.Mayhem[3][MF] = {}
									end
									
									for EF = 0, 11 do
										if EF ~= MF then
											shared.SMAE.Settings.Mayhem[3][MF][EF] = PedGetTypeToTypeAttitude(MF, EF)
											PedSetDefaultTypeToTypeAttitude(MF, EF, 0)
										end
									end
								end
								
								PedSetGlobalAttitude_Rumble(true)
							end
							if shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name == "OFF | Mayhem" then
								shared.SMAE.Settings.Mayhem[1], shared.SMAE.Settings.Mayhem[2] = false, nil
								
								for F, T in pairs(shared.SMAE.Settings.Mayhem[3]) do
									for O, V in pairs(T) do
										PedSetDefaultTypeToTypeAttitude(F, O, V)
									end
								end
								
								shared.SMAE.Settings.Mayhem[3] = {}
								PedSetGlobalAttitude_Rumble(false)
								
								for _, PED in {PedFindInAreaXYZ(0, 0, 0, 999999)} do
									if PedIsValid(PED) and PED ~= gPlayer then
										if PedMePlaying(PED, "Combat") or PedMePlaying(PED, "Attacks") or PedMePlaying(PED, "Offense") or PedIsValid(PedGetGrappleTargetPed(PED)) then
											PedStop(PED)
											PedClearObjectives(PED)
											
											PedAttack(PED, -1)
										end
									end
								end
							end
							if shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name == "OFF | Harmony" then
								for _, PED in {PedFindInAreaXYZ(0, 0, 0, 999999)} do
									if PedIsValid(PED) and PED ~= gPlayer and PedGetFlag(PED, 19) then
										PedSetFlag(PED, 19, false)
									end
								end
							end
							if shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name == "OFF | Empty World" then
								StopPedProduction(false)
							end
							
							local TURN_OFF = {
								["OFF | Cinematic"] = CameraSetWidescreen,
								["OFF | On Fire"] = EffectSetGymnFireOn,
							}
							if TURN_OFF[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name] then
								TURN_OFF[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name](false)
							end
							local REVERT = {
								["ON | Trouble Meter"] = {0, true},
								["ON | Health Bar"] = {4, true},
								["ON | Mini Map"] = {11, true},
								["OFF | Time Lap"] = {10, false},
							}
							if REVERT[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name] then
								ToggleHUDComponentVisibility(unpack(REVERT[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name]))
							end
							
							if CBUI_IsActive() then
								CBUI_SetText("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Group.." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name)
								CBUI_SetOption({"PREV", "", "NEXT"}, 3)
							end
						end
					end
					
					if ACTION == "'OPEN CREDIT'" then
						local USER_ACTION = UI_MANAGER("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name.." -", "PLAY CREDIT")
						
						if USER_ACTION == "PLAY CREDIT" then
							if shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name == "Bully AE" then
								if not MissionActive() then
									CBUI_Close()
									
									shared.SMAE_LoadFile = "CREDIT"
									ForceStartMissionIndex(215)
								else
									CBUI_SetText("# ERROR #\nCANNOT ROLL CREDITS WHILE ON MISSION!")
									CBUI_SetOption({"", "OK", ""}, 2)
									
									while true do
										Wait(0)
										
										if CBUI_IsActive() and shared.SMAE.SubGUI then
											if CBUI_1() then
												break
											end
										else
											break
										end
									end
									
									if CBUI_IsActive() then
										CBUI_SetText("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Group.." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name)
										CBUI_SetOption({"PREV", "", "NEXT"}, 3)
									end
								end
							else
								if not shared.gAdvancedTrainerCredit then
									shared.gAdvancedTrainerCredit = {
										SEQ = {
											{Delay = 250, Next = 1000, Word = {"A", "d", "v", "a", "n", "c", "e", "d", " ", "T", "r", "a", "i", "n", "e", "r", "\n", "B", "y", ":", " ", "A", "L", "T", "A", "M", "U", "R", "E", "N", "Z", "A"}},
											{Delay = 250, Next = 1500, Word = {"B", "a", "s", "e", "d", " ", "o", "n", " ", "C", "H", "A", "L", "K", "B", "O", "A", "R", "D", " ", "U", "I", " ", "1", ".", "0"}},
											
											{Delay = 150, Next = 750, Word = {"C", "R", "E", "D", "I", "T", "S", ":", "\n", "D", "e", "r", "p", "y", "5", "4", "3", "2", "0", ",", " ", "m", "a", "n", "y", " ", "a", "m", "a", "z", "i", "n", "g", " ", "o", "p", "e", "n", "-", "s", "o", "u", "r", "c", "e", "-", "m", "o", "d", " ", "b", "y", " ", "h", "e", "r"}},
											{Delay = 150, Next = 750, Word = {"CREDITS:\nD", "e", "a", "d", "p", "o", "o", "l", "X", "Y", "Z", ",", " ", "m", "a", "n", "y", " ", "b", "e", "t", "a", " ", "c", "o", "n", "t", "e", "n", "t", " ", "d", "i", "s", "c", "o", "v", "e", "r", "i", "e", "s"}},
											{Delay = 150, Next = 1500, Word = {"CREDITS:\nY", "a", "p", " ", "M", "a", "s", "s", "a", "c", "r", "e", ",", " ", "a", "n", "o", "t", "h", "e", "r", " ", "n", "o", "n", "-", "l", "o", "c", "a", "l", "i", "z", "e", "d", " ", "p", "r", "i", "n", "t", " ", "d", "i", "s", "c", "o", "v", "e", "r", "i", "e", "s"}},
											
											{Delay = 250, Next = 2500, Word = {"C", "h", "e", "c", "k", " ", "o", "u", "t", " ", "t", "h", "e", " ", "o", "f", "f", "i", "c", "i", "a", "l", " ", "t", "h", "r", "e", "a", "d", " ", "o", "n", "l", "y", " ", "a", "t", "\n", "www", ".", "Bully", "-", "Board", ".", "com"}},
										},
										INS = {
											Wait = GetTimer(), Appear = false, Point = function()
												if shared.gAdvancedTrainerCredit.INS.Wait + 800 < GetTimer() then
													shared.gAdvancedTrainerCredit.INS.Appear, shared.gAdvancedTrainerCredit.INS.Wait = not shared.gAdvancedTrainerCredit.INS.Appear, shared.gAdvancedTrainerCredit.INS.Wait
												end
												return shared.gAdvancedTrainerCredit.INS.Appear and "|" or ""
											end
										},
									}
								end
								
								local ORDER = {TEXT = "", TIMER = GetTimer(), SEQ = {HOLD = false, LINE = 1}, WORD = 0},
								
								CBUI_SetText("")
								CBUI_SetOption({"", "OK", ""}, 2)
								
								while true do
									Wait(0)
									
									if CBUI_IsActive() and shared.SMAE.SubGUI then
										if ORDER.SEQ.HOLD then
											if ORDER.TIMER + shared.gAdvancedTrainerCredit.SEQ[ORDER.SEQ.LINE].Next < GetTimer() then
												ORDER.TIMER, ORDER.SEQ.LINE, ORDER.SEQ.HOLD, ORDER.WORD, ORDER.TEXT = GetTimer(), ORDER.SEQ.LINE + 1 > table.getn(shared.gAdvancedTrainerCredit.SEQ) and 1 or ORDER.SEQ.LINE + 1, false, 0, ""
											end
										else
											if ORDER.TIMER + shared.gAdvancedTrainerCredit.SEQ[ORDER.SEQ.LINE].Delay < GetTimer() then
												ORDER.WORD = ORDER.WORD + 1
												
												if ORDER.WORD > table.getn(shared.gAdvancedTrainerCredit.SEQ[ORDER.SEQ.LINE].Word) then
													ORDER.SEQ.HOLD = true
												else
													ORDER.TEXT = ORDER.TEXT..""..shared.gAdvancedTrainerCredit.SEQ[ORDER.SEQ.LINE].Word[ORDER.WORD]
													CBUI_SetText(ORDER.TEXT)
												end
												
												ORDER.TIMER = GetTimer()
											end
										end
										
										if CBUI_1() then
											break
										end
									else
										break
									end
								end
								
								if CBUI_IsActive() then
									CBUI_SetText("- "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Group.." -\n"..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option..") "..shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Data[shared.SMAE.Setup[shared.SMAE.Option].Data[ACTION].Option].Name)
									CBUI_SetOption({"PREV", "", "NEXT"}, 3)
								end
							end
						end
					end
				end
			else
				break
			end
		end
	end
end