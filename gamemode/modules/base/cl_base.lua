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

-------------------------
--  > PrePlayerDraw <  --
-------------------------
function GM:PrePlayerDraw( ply ) -- players can't see spectator
    --ply:MarkShadowAsDirty()
    if ply:Team() == TEAM_SPECTATOR then ply:DestroyShadow() return true end
    return false
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
