ENT.Type            = "anim"
ENT.Base            = "base_entity"

ENT.PrintName		= "SCP:SB - Entity Spawner"
ENT.Category 		= "SCP : Site Breach"
ENT.Spawnable 		= false

function ENT:SetupDataTables()
    self:NetworkVar( "String", 0, "ClassEntity" )
end
