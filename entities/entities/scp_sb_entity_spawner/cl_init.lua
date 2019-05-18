include("shared.lua")

function ENT:Draw()
    if not LocalPlayer():GetActiveWeapon():IsValid() or not LocalPlayer():GetActiveWeapon() == "scp_sb_entities_spawner" then return end

    self:DrawModel()
    self:DestroyShadow()

	local ang = self:GetAngles()
	local pos = self:GetPos()

	ang:RotateAroundAxis(ang:Up(), -90)
	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), 0)

    ang.y = LocalPlayer():GetAngles().y - 90

	cam.Start3D2D(pos, ang, .25)
		draw.SimpleText( self:GetClassEntity(), "DermaLarge", 0, -75, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	cam.End3D2D()
end
