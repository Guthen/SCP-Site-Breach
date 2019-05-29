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

SCPSiteBreach.drawMeter = function( mat, x, y, xOff, many )
	surface.SetMaterial( mat )
	for i = 0, many do
		surface.DrawTexturedRect( x + i * mat:Width() * xOff, y, mat:Width(), mat:Height() )
	end
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

local eyeMat = Material( "scp_content/BlinkIcon.png" )
local runMat = Material( "scp_content/sprinticon.png" )
local sneakMat = Material( "scp_content/sneakicon.png" )

local blinkMat = Material( "scp_content/BlinkMeter.jpg" )
local staminaMat = Material( "scp_content/StaminaMeter.jpg" )

--	> Blink & Stamina HUD <  --
hook.Add( "HUDPaint", "SCPSiteBreach:HUD", function()

	--	> Icons <  --
	surface.SetDrawColor( Color( 255, 255, 255 ) )
	draw.NoTexture()

	surface.DrawOutlinedRect( 30, ScrH() - 120, 34, 34 ) -- blink

	surface.DrawOutlinedRect( 30, ScrH() - 60, 34, 34 ) -- run / crouch

	surface.SetMaterial( eyeMat ) -- blink icon
	surface.DrawTexturedRect( 32, ScrH() - 118, 30, 30 )

	if input.IsControlDown() or LocalPlayer():KeyDown( IN_WALK ) then -- if crouch or if walk
		surface.SetMaterial( sneakMat ) -- crouch icon
	else
		surface.SetMaterial( runMat ) -- run icon
	end
	surface.DrawTexturedRect( 32, ScrH() - 58, 30, 30 ) -- crouch / run

	--	> Run/Blink Meter <  --
	surface.DrawOutlinedRect( 70, ScrH() - 120, 196, 18 ) -- blink outline
	SCPSiteBreach.drawMeter( blinkMat, 72, ScrH() - 118, 1.15, LocalPlayer():GetNWInt( "SCPSiteBreach:Blink", 20 ) )

	surface.DrawOutlinedRect( 70, ScrH() - 60, 196, 18 ) -- run outline
	SCPSiteBreach.drawMeter( staminaMat, 72, ScrH() - 58, 1.15, LocalPlayer():GetNWInt( "SCPSiteBreach:Stamina", 20 ) )

end )

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
