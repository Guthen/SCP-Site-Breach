include("shared.lua")

function ENT:Draw()
    self:DrawShadow( false )
    
    local wep = LocalPlayer():GetActiveWeapon()
    if not wep:IsValid() then return end

    if wep:GetClass() == "scp_sb_teams_spawner" then
        self:DrawModel()

    	local ang = self:GetAngles()
    	local pos = self:GetPos()

    	ang:RotateAroundAxis(ang:Up(), -90)
    	ang:RotateAroundAxis(ang:Forward(), 90)
    	ang:RotateAroundAxis(ang:Right(), 0)

        ang.y = LocalPlayer():GetAngles().y - 90

    	cam.Start3D2D(pos, ang, .25)
    		draw.SimpleText( team.GetName( self:GetTeamID() ), "DermaLarge", 0, -75, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    	cam.End3D2D()
    end
end
