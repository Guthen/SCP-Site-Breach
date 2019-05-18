AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()
	self:SetModel( "models/props/scp/firstaidkit/firstaidkit.mdl" )
	self:PhysicsInit( SOLID_NONE )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_NONE )

	self.health = 100 -- how many armor we give
end

function ENT:Use( _, ply )
	if ply:Health() >= ply:GetMaxHealth() then return end

	ply:SetHealth( math.Clamp( ply:Health() + self.health, 0, 100 ) )
end
