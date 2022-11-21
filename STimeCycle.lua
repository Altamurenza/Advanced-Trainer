-- STIMECYCLE.LUA
-- AUTHOR	: ALTAMURENZA


--[[
	-----------------------
	# CHALKBOARD UI CHECK #
	-----------------------
]]

if type(shared.CBUI_Database) ~= "table" then
	main = function()
		while true do
			Wait(0)
			
			MinigameSetAnnouncement("ERROR: Missing CUIF!", true)
		end
	end
end


--[[
	----------------------
	# SET UNIVERSAL PATH #
	----------------------
]]

shared.DIR = "storage/emulated/0/Android/data/com.rockstargames.bully/files/BullyOrig/Scripts"


--[[
	-------------
	# CALL INIT #
	-------------
]]

local F, E = loadfile(shared.DIR.."/TRAINER/SYSTEM/ADVT_INIT.lur")
if F then
	F()
else
	main = function()
		CB_Print("ADVT_INIT: "..(tostring(E) == "parser not loaded" and "Uncompiled!" or "Cannot read or missing!"), 30)
		TutorialShowMessage("See READ ME.txt!", 5000, true)
		
		while true do
			Wait(0)
		end
	end
end