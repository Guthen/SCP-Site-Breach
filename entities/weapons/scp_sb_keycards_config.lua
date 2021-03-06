SWEP.PrintName			    = "SCP:SB - Keycard Config"
SWEP.Author			        = "Guthen"
SWEP.Instructions		    = "Left click to set an access from a button. Right click to remove an access from a button. Reload to change the access level."

SWEP.Spawnable              = true
SWEP.AdminOnly              = true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo		    = "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		    = "none"

SWEP.Weight	                = 5
SWEP.AutoSwitchTo		    = false
SWEP.AutoSwitchFrom		    = false

SWEP.Slot			        = 1
SWEP.SlotPos			    = 2
SWEP.DrawAmmo			    = false
SWEP.DrawCrosshair		    = true

SWEP.ViewModel			    = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel			    = "models/weapons/w_stunbaton.mdl"

SWEP.SCPSiteBreachLVL       = 5
SWEP.SCPSiteBreachDroppable = false -- if you want to drop it after death

--  > Functions <  --

function SWEP:PrimaryAttack() -- create entities spawner
    local ply = self:GetOwner()
    if not ply:IsValid() or not ply:Alive() then return end

    if CLIENT then return end

    self.Weapon:SetNextPrimaryFire( CurTime() + 1 )

    local ent = ply:GetEyeTrace().Entity
    if not ent:IsValid() or not SCPSiteBreach.keycardAvailableClass[ ent:GetClass() ] then return end

    ent:SetNWInt( "SCPSiteBreach:LVL", ply:GetNWInt( "SCPSiteBreach:CurAccess", 1 ) ) -- set

    if SERVER then -- SERVER only because CLIENT spam chat
        ply:ChatPrint( "SCPSiteBreach - The target has been set on LVL " .. ent:GetNWInt( "SCPSiteBreach:LVL", 0 ) )
    end
end

function SWEP:SecondaryAttack() -- remove entities spawner in sphere
    local ply = self:GetOwner()
    if not ply:IsValid() or not ply:Alive() then return end

    if CLIENT then return end

    self.Weapon:SetNextSecondaryFire( CurTime() + 1 )

    local ent = ply:GetEyeTrace().Entity
    if not ent:IsValid() or not SCPSiteBreach.keycardAvailableClass[ ent:GetClass() ] then return end

    ent:SetNWInt( "SCPSiteBreach:LVL", nil ) -- erased

    if SERVER then -- SERVER only because CLIENT spam chat
        ply:ChatPrint( "SCPSiteBreach - The target's LVL has been erased !" )
    end
end

local canReload = true
function SWEP:Reload()
    if not canReload then return end

    if CLIENT then return end

    local ply = self:GetOwner()
    if not ply:IsValid() or not ply:Alive() then return end

    ply:SetNWInt( "SCPSiteBreach:CurAccess", ply:GetNWInt( "SCPSiteBreach:CurAccess", 1 ) >= 5 and 1 or ply:GetNWInt( "SCPSiteBreach:CurAccess", 1 ) + 1 )

    canReload = false
    timer.Simple( .1, function() canReload = true end )
end

function SWEP:DrawHUD()
    draw.SimpleText( "Current LVL: " .. ply:GetNWInt( "SCPSiteBreach:CurAccess", 1 ), "DermaDefault", ScrW()/2+50, ScrH()/2, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    local trg = self:GetOwner():GetEyeTrace().Entity
    if not trg or not trg:IsValid() then return end
    draw.SimpleText( "Target Class: " .. trg:GetClass() or "nil", "DermaDefault", ScrW()/2+50, ScrH()/2+15, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    if trg:IsValid() and trg:GetNWInt( "SCPSiteBreach:LVL", 0 ) then
        draw.SimpleText( "Target LVL: " .. trg:GetNWInt( "SCPSiteBreach:LVL", 0 ), "DermaDefault", ScrW()/2+50, ScrH()/2+30, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    end
end
