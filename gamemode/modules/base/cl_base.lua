-----------------------------
--  > SCP - Site Breach <  --
--     > cl_base.lua <     --
-----------------------------

--	> Customs Functions <  --
SCPSiteBreach.drawCircle = function( x, y, ang, rad, seg )
	local circle = {}
	table.insert( circle, { x = x, y = y, u = 0.5, v = 0.5 } )

	for i = 0, ang, seg do
		local _ang = math.rad( i )
		table.insert( circle, { x = x + math.cos( _ang ) * rad, y = y + math.sin( _ang ) * rad, u = .5, v = .5 } )
	end

	table.insert( circle, { x = x, y = y, u = .5, v = .5 } )

	surface.DrawPoly( circle )
	return circle
end

--	> Fonts <  --
for i = 20, 60 do
	surface.CreateFont( "SCPSiteBreach:Font" .. i, {
		font = "Coolvetica", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = i,
		weight = 500,
	} )
end

--	> Network <  --
net.Receive( "SCPSiteBreach:PlaySound", function()
	local snd = net.ReadString()
	if not snd then return end

	surface.PlaySound( snd )
end )

--  > Gamemode Hooks <  --

--------------------
--  > HUDPaint <  --
--------------------
--function GM:HUDPaint()
--end

function GM:HUDDrawTargetID()
end

SCPSiteBreach.shouldDraw =
{
	["CHudCrosshair"] = false,
}

function GM:HUDShouldDraw( name )
	if SCPSiteBreach.shouldDraw[ name ] == false then return false end
	return true
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
