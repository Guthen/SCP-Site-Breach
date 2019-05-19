AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()
	self:SetModel( "models/props/scp/firstaidkit/firstaidkit.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end

	self.health = 100 -- how many health we give
end

function ENT:Use( _, ply )
	if ply:Health() >= ply:GetMaxHealth() then return end

	ply:SetHealth( math.Clamp( ply:Health() + self.health, 0, 100 ) )

	ply:SetBottomMessage( "You heal yourself and you feel better !" )

	self:EmitSound( "guthen_scp/interact/PickItem" .. math.random( 1, 2 ) .. ".ogg" )
	self:Remove()
end
