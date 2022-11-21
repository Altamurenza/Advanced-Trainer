-- DEBUG MEMORY FOR ADVANCED TRAINER UPDATE 1.1 (or beyond)
-- AUTHOR	: ALTAMURENZA


--[[
	This is a script template for Advanced Trainer plugin. 
	If anyone has interest to make a plug in, this is the way how you can create one.
	
	Also, don't forget to name the compiled script as ADVT_SCRIPT_0.lur - ADVT_SCRIPT_20.lur.
	
	If ADVT_SCRIPT_0.lur is already exist, name it as ADVT_SCRIPT_1.lur.
	If ADVT_SCRIPT_1.lur is already exist, name it as ADVT_SCRIPT_2.lur.
	So on..
]]


if not shared.gAdvancedTrainer_DebugMemoryThread then
	ADVT_DEBUG_MEMORY = function()
		local MEMORY = 0
		while true do
			MEMORY = gcinfo()
			
			if type(MEMORY) == 'number' then
				TextAddParamNum(MEMORY)
				TextPrint('INT', 0.5, 2)
			end
			
			Wait(0)
		end
	end
	
	shared.gAdvancedTrainer_DebugMemoryThread = CreateThread('ADVT_DEBUG_MEMORY')
end
