include("shared.lua")

local pickMat = Material("scp_content/handsymbol2.png")

function ENT:Draw()
	self:DrawModel()

	if LocalPlayer():GetPos():DistToSqr( self:GetPos() ) > 100*100 or not LocalPlayer():Alive() then return end
	local ang = self:GetAngles()
	local pos = self:GetPos()

	ang = LocalPlayer():EyeAngles()
	ang:RotateAroundAxis( ang:Up(), -90 )
	ang:RotateAroundAxis( ang:Forward(), 90 )
	ang:RotateAroundAxis( ang:Right(), 0 )

	cam.Start3D2D(pos, ang, 1)
		surface.SetDrawColor( 255, 255, 255 )
		surface.SetMaterial( pickMat )
		surface.DrawTexturedRect( -4, -14, 8, 8 )
	cam.End3D2D()
end
