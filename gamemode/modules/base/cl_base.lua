-----------------------------
--  > SCP - Site Breach <  --
--     > cl_base.lua <     --
-----------------------------

--  > Gamemode Hooks <  --

--------------------
--  > HUDPaint <  --
--------------------
function GM:HUDPaint()
end

-----------------------------
--  > PostDrawViewModel <  --
-----------------------------
function GM:PostDrawViewModel( vm, ply, weapon ) -- players hands on weapons
	if weapon.UseHands or not weapon:IsScripted() then
		local hands = LocalPlayer():GetHands()
		if hands:IsValid() then hands:DrawModel() end
	end
end
