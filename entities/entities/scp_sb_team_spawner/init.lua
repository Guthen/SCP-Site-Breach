AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()
	self:SetModel( "models/hunter/blocks/cube025x025x025.mdl" )
	self:PhysicsInit( SOLID_NONE )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_NONE )

    self:SetColor( Color( 10, 10, 160 ) )
end
