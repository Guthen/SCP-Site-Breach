ENT.Type            = "anim"
ENT.Base            = "base_entity"

ENT.PrintName		= "SCP:SB - Team Spawner"
ENT.Category 		= "SCP : Site Breach"
ENT.Spawnable 		= false

function ENT:SetupDataTables()
    self:NetworkVar( "Int", 0, "TeamID" )
end
