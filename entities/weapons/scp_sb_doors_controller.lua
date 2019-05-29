SWEP.PrintName			    = "SCP:SB - Door Controller"
SWEP.Author			        = "Guthen"
SWEP.Instructions		    = "Left click to control doors settings."

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

SWEP.ViewModel			    = "models/weapons/v_357.mdl"
SWEP.WorldModel			    = "models/weapons/w_357.mdl"

SWEP.SCPSiteBreachDroppable = false -- if you want to drop it after death

--  > Network <  --
if SERVER then
    util.AddNetworkString( "SCPSiteBreach:DCPanel" )
    util.AddNetworkString( "SCPSiteBreach:DCSettings" )
end

--  > Functions <  --

function SWEP:PrimaryAttack() -- create entities spawner
    if CLIENT then return end

    local ply = self:GetOwner()
    if not ply:IsValid() or not ply:Alive() then return end

    local ent = ply:GetEyeTrace().Entity
    print( ent)
    if not ent or not ent:IsValid() then return end
    if not ent:isDoor() then return end

    self.Weapon:SetNextPrimaryFire( CurTime() + .5 )

    net.Start( "SCPSiteBreach:DCPanel" )
        net.WriteEntity( ent )
    net.Send( ply )
end

function SWEP:SecondaryAttack() -- remove entities spawner in sphere
end

function SWEP:DrawHUD()
    local ent = LocalPlayer():GetEyeTrace().Entity
    if not ent or not ent:IsValid() then return end
    if not ent:isDoor() then return end
    draw.SimpleText( "[LMB] Configure the Door Controller", "DermaDefault", ScrW()/2+50, ScrH()/2, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
end

function SWEP:OnReloaded()
    print( "SCPSiteBreach - " .. self.PrintName .. " has been loaded !" )
end

-----------------
--  > PANEL <  --
-----------------
    if CLIENT then
    net.Receive( "SCPSiteBreach:DCPanel", function()
        if not LocalPlayer():IsSuperAdmin() then return end

        local w, h = 400, 500
        local frame = vgui.Create( "DFrame" )
              frame:SetSize( w, h )
              frame:Center()
              frame:SetTitle( "PANEL - Door Controller" )
              frame:MakePopup()

        local scroll = vgui.Create( "DScrollPanel", frame )
              scroll:SetPos( 3, 25 )
              scroll:SetSize( w-6, h-100 )

        local chance = vgui.Create( "DNumberWang", frame )
              chance:SetPos( 80, h-60 )
              chance:SetSize( 40, 15 )
              chance:SetFraction( LocalPlayer():GetNWFloat( "SCPSiteBreach:CurChance", 1 ) )
              chance.OnValueChange = function( self )
                  net.Start( "SCPSiteBreach:DCSettings" )
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
