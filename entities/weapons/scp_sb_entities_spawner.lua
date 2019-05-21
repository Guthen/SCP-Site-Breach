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

--  > Network <  --
if SERVER then
    util.AddNetworkString( "SCPSiteBreach:ESPanel" )
    util.AddNetworkString( "SCPSiteBreach:ESInfo" )
end

--  > Variables <  --
local entities =
    {
        "item_healthkit",
        "item_healthvial",
        "item_battery",
        "item_ammo_pistol",
        "scp_sb_firstaidkit",
        "scp_sb_vest",
        "scp_sb_keycard_lvl_1",
        "scp_sb_keycard_lvl_2",
        "scp_sb_keycard_lvl_3",
        "scp_sb_keycard_lvl_4",
        "scp_sb_keycard_lvl_5",
    }
local curChance = 1 -- btw 0 - 1

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
          ent:SetClassEntity( entities[ply:GetNWInt( "SCPSiteBreach:CurEntity", 1 )] )
          ent:SetChance( ply:GetNWInt( "SCPSiteBreach:CurChance", 1 ) )
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
    if not canReload or not SERVER then return end

    net.Start( "SCPSiteBreach:ESPanel" )
    net.Send( self:GetOwner() )

    canReload = false
    timer.Simple( .5, function() canReload = true end )
end

function SWEP:DrawHUD()
    draw.SimpleText( "Current Entity: " .. entities[LocalPlayer():GetNWInt( "SCPSiteBreach:CurEntity", 1 )], "DermaDefault", ScrW()/2+50, ScrH()/2, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    draw.SimpleText( "Current Chance: " .. math.floor( LocalPlayer():GetNWInt( "SCPSiteBreach:CurChance", 1 ) * 100 ).. "%", "DermaDefault", ScrW()/2+50, ScrH()/2+15, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    draw.SimpleText( "# Entities Spawners: " .. #ents.FindByClass( "scp_sb_entity_spawner" ), "DermaDefault", ScrW()/2+50, ScrH()/2+30, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
end

function SWEP:OnReloaded()
    print( "SCPSiteBreach - " .. self.PrintName .. " has been loaded !" )
end

-----------------
--  > PANEL <  --
-----------------
    if CLIENT then
    net.Receive( "SCPSiteBreach:ESPanel", function()
        if not LocalPlayer():IsSuperAdmin() then return end

        local w, h = 400, 500
        local frame = vgui.Create( "DFrame" )
              frame:SetSize( w, h )
              frame:Center()
              frame:SetTitle( "Entity Spawner Panel" )
              frame:MakePopup()

        local scroll = vgui.Create( "DScrollPanel", frame )
              scroll:SetPos( 3, 25 )
              scroll:SetSize( w-6, h-100 )

        local chance = vgui.Create( "DNumberWang", frame )
              chance:SetPos( 80, h-60 )
              chance:SetSize( 40, 15 )
              chance:SetFraction( LocalPlayer():GetNWFloat( "SCPSiteBreach:CurChance", 1 ) )
              chance.OnValueChange = function( self )
                  net.Start( "SCPSiteBreach:ESInfo" )
                    net.WriteInt( LocalPlayer():GetNWInt( "SCPSiteBreach:CurEntity" ), 32 )
                    net.WriteFloat( self:GetFraction() )
                  net.SendToServer()
              end

        local y = 0
        for k, v in pairs( entities ) do

            local but = scroll:Add( "DButton" )
                  but:SetPos( 0, 5 + 40*y )
                  but:SetSize( 390, 35 )
                  but:SetText( v )
                  but.DoClick = function()
                      net.Start( "SCPSiteBreach:ESInfo" )
                        net.WriteInt( k, 32 )
                        net.WriteFloat( chance:GetFraction() )
                      net.SendToServer()
                      frame:Remove()
                  end

            y = y + 1

        end

        local label = vgui.Create( "DLabel", frame )
              label:SetPos( 5, h-60 )
              label:SetText( "Chance (%) :" )
              label:SizeToContents()

        local save = vgui.Create( "DButton", frame )
              save:SetPos( 5, h-40 )
              save:SetSize( 190, 35 )
              save:SetText( "Save Entities Spawner" )
              save.DoClick = function()
                  RunConsoleCommand( "scpsb_save_entities_spawner" )
                  frame:Remove()
              end

        local load = vgui.Create( "DButton", frame )
              load:SetPos( 205, h-40 )
              load:SetSize( 190, 35 )
              load:SetText( "Load Entities Spawner" )
              load.DoClick = function()
                    RunConsoleCommand( "scpsb_load_entities_spawner" )
                    frame:Remove()
              end

        local clean = vgui.Create( "DButton", frame )
              clean:SetPos( 205, h-60 )
              clean:SetSize( 190, 15 )
              clean:SetText( "Clean-Up" )
              clean.DoClick = function()
                    RunConsoleCommand( "scpsb_cleanup" )
                    frame:Remove()
              end
    end )
else
    net.Receive( "SCPSiteBreach:ESInfo", function( _, ply )
        if not ply:IsSuperAdmin() then return end

        ply:SetNWInt( "SCPSiteBreach:CurEntity", net.ReadInt( 32 ) or 1 )
        ply:SetNWFloat( "SCPSiteBreach:CurChance", net.ReadFloat() or 1 )
    end )
end
