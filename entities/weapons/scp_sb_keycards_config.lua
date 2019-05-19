SWEP.PrintName			    = "SCP:SB - Keycard Config" -- This will be shown in the spawn menu, and in the weapon selection menu
SWEP.Author			        = "Guthen" -- These two options will be shown when you have the weapon highlighted in the weapon selection menu
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
--  > Variables <  --
local curAccess = 1

--  > Functions <  --

function SWEP:PrimaryAttack() -- create entities spawner
    local ply = self:GetOwner()
    if not ply:IsValid() or not ply:Alive() then return end

    self.Weapon:SetNextPrimaryFire( CurTime() + 1 )

    local ent = ply:GetEyeTrace().Entity
    if not ent:IsValid() or not SCPSiteBreach.keycardAvailableClass[ ent:GetClass() ] then return end

    ent.SCPSiteBreachLVL = curAccess -- set

    if SERVER then -- SERVER only because CLIENT spam chat
        ply:ChatPrint( "SCPSiteBreach - The target has been set on LVL " .. ent.SCPSiteBreachLVL )
    end
end

function SWEP:SecondaryAttack() -- remove entities spawner in sphere
    local ply = self:GetOwner()
    if not ply:IsValid() or not ply:Alive() then return end

    self.Weapon:SetNextSecondaryFire( CurTime() + 1 )

    local ent = ply:GetEyeTrace().Entity
    if not ent:IsValid() or not SCPSiteBreach.keycardAvailableClass[ ent:GetClass() ] then return end

    ent.SCPSiteBreachLVL = nil -- erased

    if SERVER then -- SERVER only because CLIENT spam chat
        ply:ChatPrint( "SCPSiteBreach - The target's LVL has been erased !" )
    end
end

local canReload = true
function SWEP:Reload()
    if not canReload then return end

    curAccess = curAccess >= 5 and 1 or curAccess + 1

    canReload = false
    timer.Simple( .5, function() canReload = true end )
end

function SWEP:DrawHUD()
    draw.SimpleText( "Current LVL: " .. curAccess, "DermaDefault", ScrW()/2+50, ScrH()/2, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    local trg = self:GetOwner():GetEyeTrace().Entity
    draw.SimpleText( "Target Class: " .. trg:GetClass() or "nil", "DermaDefault", ScrW()/2+50, ScrH()/2+15, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    if trg:IsValid() and trg.SCPSiteBreachLVL then
        draw.SimpleText( "Target LVL: " .. trg.SCPSiteBreachLVL, "DermaDefault", ScrW()/2+50, ScrH()/2+30, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    end
end
