-- MGARCADE.LUA
-- AUTHOR	: ALTAMURENZA


--[[
	-------------------------------------
	# INSERT IMPORTSCRIPT TO GLOBAL ENV #
	-------------------------------------
]]

_G.ImportScript = function(SCRIPT)
	while IsStreamingBusy() do
		Wait(0)
	end
	
	ImportScript(SCRIPT)
	if SCRIPT ~= "Test/Missions/RunMissionLib.lua" then
		MissionSetup, MissionCleanup, main = nil, nil, nil
	end
end


--[[
	-----------------------------
	# LOAD, EXECUTE, & CLEAN UP #
	-----------------------------
]]

dofile(shared.SMAE_LoadFile and "storage/emulated/0/Android/data/com.rockstargames.bully/files/BullyOrig/Scripts/TRAINER/SYSTEM/IMG/"..shared.SMAE_LoadFile..".lur" or "storage/emulated/0/Android/data/com.rockstargames.bully/files/BullyOrig/Scripts/TRAINER/SYSTEM/IMG/ARCADE.lur")

if shared.SMAE_LoadFile == "CREDIT" then
	_G.PSH = _G.PlayerSetHealth
	_G.PlayerSetHealth = function(HEALTH)
		if HEALTH == 200 then
			CreateThread("RollCredits")
			CameraFade(1000, 0)
			Wait(1001)
			
			while true do
				Wait(0)
				
				if IsButtonBeingPressed(7, 0) then
					MissionSucceed(false, false, false)
				end
			end
		else
			_G.PSH(HEALTH)
		end
	end
	
	_G.RC = _G.RollCredits
	_G.RollCredits = function()
		_G.RC()
		
		MissionSucceed(false, false, false)
	end
	
	_G.MissionSetup = function()
		MissionDontFadeIn()
		PlayerSetControl(0)
		
		CreditLoadDB()
	end
	
	_G.MissionCleanup = function()
		PlayerSetControl(1)
		CreditUnLoadDB()
		
		_G.PlayerSetHealth = _G.PSH
	end
end

shared.SMAE_LoadFile = nil


--[[
	---------------------------------------
	# REMOVE IMPORTSCRIPT FROM GLOBAL ENV #
	---------------------------------------
]]

_G.ImportScript = nil