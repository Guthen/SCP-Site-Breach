SWEP.PrintName			    = "SCP:SB - Entities Spawner" -- This will be shown in the spawn menu, and in the weapon selection menu
SWEP.Author			        = "Guthen" -- These two options will be shown when you have the weapon highlighted in the weapon selection menu
SWEP.Instructions		    = "Left click to add an entity spawn. Right click to remove an entity spawn. Reload to change an entity class."

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

SWEP.ViewModel			    = "models/weapons/v_pistol.mdl"
SWEP.WorldModel			    = "models/weapons/w_pistol.mdl"

--  > Variables <  --
local entities =
    {
        "item_healthkit",
        "item_healthvial",
        "item_battery",
        "item_ammo_pistol",
    }
local curEnt = 1

--  > Functions <  --

function SWEP:PrimaryAttack() -- create entities spawner
    local ply = self:GetOwner()
    if not ply:IsValid() or not ply:Alive() then return end

    self.Weapon:SetNextPrimaryFire( CurTime() + .5 )

    if CLIENT then return end -- CLIENT can't create entities

    local ent = ents.Create( "scp_sb_entity_spawner" )
          if not ent:IsValid() then return end
          ent:SetPos( ply:GetEyeTrace().HitPos + Vector( 0, 0, 10 ) )
          ent:SetAngles( Angle( 0, ply:GetAngles().y, 0 ) )
          ent:Spawn()
          ent:SetClassEntity( entities[curEnt] )
end

function SWEP:SecondaryAttack() -- remove entities spawner in sphere
    local ply = self:GetOwner()
    if not ply:IsValid() or not ply:Alive() then return end

    self.Weapon:SetNextSecondaryFire( CurTime() + .25 )

    local _ents = ents.FindInSphere( ply:GetEyeTrace().HitPos, 10 )
    for _, v in pairs( _ents ) do
        if v:GetClass() == "scp_sb_entity_spawner" then v:Remove() end
    end
end

local canReload = true
function SWEP:Reload()
    if not canReload then return end

    curEnt = curEnt >= #entities and 1 or curEnt + 1

    canReload = false
    timer.Simple( .5, function() canReload = true end )
end

function SWEP:DrawHUD()
    draw.SimpleText( "Current Entity: " .. entities[curEnt], "DermaDefault", ScrW()-5, 5, Color( 255, 255, 255 ), TEXT_ALIGN_RIGHT )
end
