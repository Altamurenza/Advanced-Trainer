-- TATTOOS.lua
-- AUTHOR	: ALTAMURENZA


if not shared.gAccessTattoosRoom then
	dofile("storage/emulated/0/Android/data/com.rockstargames.bully/files/BullyOrig/Scripts/TRAINER/SYSTEM/IMG/TATTOO.lur")
else
	function main()
		DATLoad("SP_Trailer.dat", 0)
		DATLoad("Tattoos.dat", 0)
		
		F_PreDATInit()
		DATInit()
		
		shared.gAreaDataLoaded = true
		shared.gAreaDATFileLoaded[16] = true
		
		repeat
			Wait(0)
		until AreaGetVisible() ~= 16 or SystemShouldEndScript()
		DATUnload(0)
		
		shared.gAreaDataLoaded = false
		shared.gAreaDATFileLoaded[16] = false
	end
end