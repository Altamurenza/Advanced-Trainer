-- ADVT_INIT.LUA
-- AUTHOR	: ALTAMURENZA


--[[
	------------------
	# LAUNCH TRAINER #
	------------------
]]

main = function()
	while not SystemIsReady() or AreaIsLoading() do
		Wait(0)
	end
	
	-----------------------------
	-- # IMPORT REQUIRED SCRIPT #
	-----------------------------
	
	for _, S in ipairs({"ADVT_GLOBAL", "ADVT_THREAD", "ADVT_UI", "TABLE/ADVT_TABLE_01", "TABLE/ADVT_TABLE_02"}) do
		local F, E = loadfile("storage/emulated/0/Android/data/com.rockstargames.bully/files/BullyOrig/Scripts/TRAINER/SYSTEM/"..S..".lur")
		
		if F then
			F()
		else
			CB_Print(S..": "..(tostring(E) == "parser not loaded" and "Uncompiled!" or "Cannot read or missing!"), 30)
			TutorialShowMessage("See READ ME.txt!", 5000, true)
			
			while true do
				Wait(0)
			end
		end
	end
	
	---------------------------
	-- # REGISTER UNUSED AREA #
	---------------------------
	
	for I, S in pairs({[22] = "AreaScripts/Island3.lua", [31] = "AreaScripts/TestArea.lua"}) do
		AreaRegisterAreaScript(I, S)
	end
	
	--------------------
	-- # LAUNCH THREAD #
	--------------------
	
	for _, T in ipairs({"SMAE_GENERAL", "SMAE_STRAFE", "SMAE_STYLE", "SMAE_VEHICLE"}) do
		CreateThread(T)
	end
	
	-------------------------------
	-- # LOAD REQUIRED ANIM GROUP #
	-------------------------------
	
	shared.SMAE.AG = {}
	shared.SMAE.EssentialAG = {
		"Authority", "Boxing", "Russell", "Nemesis", "B_Striker", "CV_Female", "CV_Male",
		"DO_Edgar", "DO_Grap", "DO_StrikeCombo", "DO_Striker", "F_Adult", "F_BULLY", "F_Douts",
		"F_Girls", "F_Greas", "F_Jocks", "F_Nerds", "F_OldPeds", "F_Pref", "F_Preps", "G_Grappler",
		"G_Johnny", "G_Striker", "Grap", "J_Damon", "J_Grappler", "J_Melee", "J_Ranged", "J_Striker",
		"LE_Orderly", "N_Ranged", "N_Striker", "N_Striker_A", "N_Striker_B", "P_Grappler",
		"P_Striker", "PunchBag", "Qped", "Rat_Ped", "Russell_Pbomb", "Straf_Dout", "Straf_Fat",
		"Straf_Female", "Straf_Male", "Straf_Nerd", "Straf_Prep", "Straf_Savage", "Straf_Wrest",
		"TE_Female", "MINI_React",
	}
	for _, A in ipairs(shared.SMAE.EssentialAG) do
		if HasAnimGroupLoaded(A) == false then
			LoadAnimationGroup(A)
			shared.SMAE.AG[A] = true
		end
	end
	
	-----------------------------
	-- # IMPORT OPTIONAL SCRIPT #
	-----------------------------
	
	for ID = 0, 20 do
		local FILE, ERROR = loadfile("storage/emulated/0/Android/data/com.rockstargames.bully/files/BullyOrig/Scripts/TRAINER/LOCAL/ADVT_SCRIPT_"..ID..".lur")
		
		if FILE then
			FILE()
		end
	end
	
	----------------
	-- # LAUNCH UI #
	----------------
	
	MAIN_UI()
end


--[[
	-----------------------------
	# TIME CYCLE (UNUSED MAYBE) #
	-----------------------------
]]

function F_AttendedClass()
    if IsMissionCompleated("3_08") and not IsMissionCompleated("3_08_PostDummy") then
        return
    end
    SetSkippedClass(false)
    PlayerSetPunishmentPoints(0)
end
function F_MissedClass()
    if IsMissionCompleated("3_08") and not IsMissionCompleated("3_08_PostDummy") then
        return
    end
    SetSkippedClass(true)
    StatAddToInt(166)
end
function F_AttendedCurfew()
    if not PedInConversation(gPlayer) and not MissionActive() then
        TextPrintString("You got home in time for curfew", 4)
    end
end
function F_MissedCurfew()
    if not PedInConversation(gPlayer) and not MissionActive() then
        TextPrint("TM_TIRED5", 4, 2)
    end
end
function F_StartClass()
    if IsMissionCompleated("3_08") and not IsMissionCompleated("3_08_PostDummy") then
        return
    end
end
function F_EndClass()
    if IsMissionCompleated("3_08") and not IsMissionCompleated("3_08_PostDummy") then
        return
    end
end
function F_StartMorning()
    F_UpdateTimeCycle()
end
function F_EndMorning()
    F_UpdateTimeCycle()
end
function F_StartLunch()
    if IsMissionCompleated("3_08") and not IsMissionCompleated("3_08_PostDummy") then
        F_UpdateTimeCycle()
        return
    end
    F_UpdateTimeCycle()
end
function F_EndLunch()
    F_UpdateTimeCycle()
end
function F_StartAfternoon()
    F_UpdateTimeCycle()
end
function F_EndAfternoon()
    F_UpdateTimeCycle()
end
function F_StartEvening()
    F_UpdateTimeCycle()
end
function F_EndEvening()
    F_UpdateTimeCycle()
end
function F_StartCurfew_SlightlyTired()
    F_UpdateTimeCycle()
end
function F_StartCurfew_Tired()
    F_UpdateTimeCycle()
end
function F_StartCurfew_MoreTired()
    F_UpdateTimeCycle()
end
function F_StartCurfew_TooTired()
    F_UpdateTimeCycle()
end
function F_EndCurfew_TooTired()
    F_UpdateTimeCycle()
end
function F_EndTired()
    F_UpdateTimeCycle()
end
function F_Nothing()
end
function F_ClassWarning()
    if IsMissionCompleated("3_08") and not IsMissionCompleated("3_08_PostDummy") then
        return
    end
    local l_23_0 = math.random(1, 2)
end
function F_UpdateTimeCycle()
    if not IsMissionCompleated("1_B") then
        local l_24_0 = GetCurrentDay(false)
        if l_24_0 < 0 or l_24_0 > 2 then
            SetCurrentDay(0)
        end
    end
    F_UpdateCurfew()
end
function F_UpdateCurfew()
    local l_25_0 = shared.gCurfewRules
    if not l_25_0 then
        l_25_0 = F_CurfewDefaultRules
    end
    l_25_0()
end
function F_CurfewDefaultRules()
    local l_26_0 = ClockGet()
    if l_26_0 >= 23 or l_26_0 < 7 then
        shared.gCurfew = false
    else
        shared.gCurfew = false
    end
end