-- CONVERSATION.LUA
-- AUTHOR	: ALTAMURENZA


function MissionSetup()
	DATLoad("3_07.DAT", 2)
	DATInit()
	
	LoadAnimationGroup("Hang_Talking")
	AreaTransitionXYZ(14, -507.0, 317.7, 31.4)
end

function MissionCleanup()
	UnLoadAnimationGroup("Hang_Talking")
	DATUnload(2)
end

function main()
  local PEDRO = PedCreatePoint(69, POINTLIST._3_07_PEDRO)
	local JUSTIN = PedCreatePoint(34, POINTLIST._3_07_JUSTIN)
	local TREVOR = PedCreatePoint(73, POINTLIST._3_07_TREVOR)
	
	PedSetActionNode(PEDRO, "/Global/Animations/Listening", "Act/Conv/3_07.act")
	PedSetActionNode(JUSTIN, "/Global/Animations/Talking", "Act/Conv/3_07.act")
	PedSetActionNode(TREVOR, "/Global/Animations/Listening", "Act/Conv/3_07.act")
	
	local ID, FAIL = 0, false
	local DIALOGUE = {
		[1] = {{JUSTIN, "M_3_07", 1, "large"}, 	{"3_07_Speech01", 3, 2}},
		[2] = {{PEDRO, "M_3_07", 2, "large"}, 	{"3_07_Speech02", 3, 2}},
		[3] = {{TREVOR, "M_3_07", 3, "large"}, 	{"3_07_Speech03", 3, 2}},
		[4] = {{JUSTIN, "M_3_07", 4, "large"}, 	{"3_07_Speech04", 5, 2}},
		[5] = {{PEDRO, "M_3_07", 5, "large"}, 	{"3_07_Speech05", 5, 2}},
		[6] = {{JUSTIN, "M_3_07", 6, "large"}, 	{"3_07_Speech06", 3, 2}},
	}
	
	repeat
		Wait(0)
		
		if not FAIL then
			ID = ID + 1
			
			SoundPlayScriptedSpeechEvent(unpack(DIALOGUE[ID][1]))
			TextPrint(unpack(DIALOGUE[ID][2]))
			
			repeat
				Wait(0)
				
				if PedIsHit(PEDRO, 2, 1000) or PedIsHit(JUSTIN, 2, 1000) or PedIsHit(TREVOR, 2, 1000) or AreaGetVisible() ~= 14 then
					FAIL = true
				end
			until not SoundSpeechPlaying(DIALOGUE[ID][1][1]) or FAIL
		else
			break
		end
	until FAIL or ID >= 6
	
	if ID >= 6 then
		Wait(3000)
	end
	
	PedSetActionNode(PEDRO, "/Global", "Globals.act")
	PedSetActionNode(JUSTIN, "/Global", "Globals.act")
	PedSetActionNode(TREVOR, "/Global", "Globals.act")
	
	PedSetAITree(PEDRO, "/Global/AI", "Act/AI/AI.act")
	PedSetAITree(JUSTIN, "/Global/AI", "Act/AI/AI.act")
	PedSetAITree(TREVOR, "/Global/AI", "Act/AI/AI.act")
	
	PedMakeAmbient(PEDRO)
	PedMakeAmbient(JUSTIN)
	PedMakeAmbient(TREVOR)
	
	MissionSucceed(false, false, false)
end
