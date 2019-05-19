AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()
	self:SetModel( "models/props/scp/vest/vest.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end

	self.armor = 150 -- how many armor we give
end

function ENT:Use( _, ply )
	if ply:Armor() >= 255 then return end

	ply:SetArmor( math.Clamp( ply:Armor() + self.armor, 0, 255 ) )

	ply:SetBottomMessage( "You equip a vest and you feel more in security !" )

	self:EmitSound( "guthen_scp/interact/PickItem" .. math.random( 1, 2 ) .. ".ogg" )
	self:Remove()
end
