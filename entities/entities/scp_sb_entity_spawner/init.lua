AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()
	self:SetModel( "models/hunter/blocks/cube025x025x025.mdl" )
	self:PhysicsInit( SOLID_NONE )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_NONE )

	self:SetChance( 1 )

    self:SetColor( Color( 10, 160, 10 ) )
end

function ENT:SpawnClassEntity()
    if string.len( self:GetClassEntity() ) == 0 then return end

	local chance = self:GetChance()
	local _chance = math.random( 1, math.ceil( 1/chance ) )

	if chance == 1 or _chance == math.ceil( 1/chance ) then
	    local ent = ents.Create( self:GetClassEntity() )
	          ent:SetPos( self:GetPos() + Vector( 0, 0, 10 ) )
	          ent:SetAngles( self:GetAngles() )
	          ent:Spawn()
	end
end
