-----------------------------
--  > SCP - Site Breach <  --
--     > cl_base.lua <     --
-----------------------------

--	> Customs Functions <  --
SCPSiteBreach.drawCircle = function( x, y, ang, rad, seg )
	local circle = {}
	table.insert( circle, { x = x, y = y, u = 0.5, v = 0.5 } )

	for i = 1, ang, seg do
		local _ang = math.rad( i )
		table.insert( circle, { x = x + math.cos( _ang ) * rad, y = y + math.sin( _ang ) * rad } )
	end

	table.insert( circle, { x = x, y = y, u = 0.5, v = 0.5 } )

	surface.DrawPoly( circle )
	return circle
end

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
