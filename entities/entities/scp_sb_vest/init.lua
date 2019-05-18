AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()
	self:SetModel( "models/props/scp/vest/vest.mdl" )
	self:PhysicsInit( SOLID_NONE )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_NONE )

	self.armor = 100 -- how many armor we give
end

function ENT:Use( _, ply )
	if ply:Armor() >= 255 then return end

	ply:SetArmor( math.Clamp( ply:Armor() + self.armor, 0, 255 ) )
end
