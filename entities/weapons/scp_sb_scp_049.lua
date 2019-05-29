SWEP.PrintName			    = "SCP:SB - SCP-049"
SWEP.Author			        = "Guthen"
SWEP.Instructions		    = "Left click to kill people. Right click on your corpse victim to transform them in zombie"

SWEP.Spawnable              = true

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
SWEP.DrawCrosshair		    = false

SWEP.ViewModel			    = ""
SWEP.WorldModel			    = ""

SWEP.HoldType               = "pistol"

SWEP.SCPSiteBreachLVL       = 5 -- swep lvl to use doors/buttons
SWEP.SCPSiteBreachSCP       = true -- if is an scp swep (use to block access to gate or 914 for example)
SWEP.SCPSiteBreachDroppable = false -- if you want to drop it after death

function SWEP:PrimaryAttack()
    if CLIENT then return end

    local ply = self:GetOwner()
    local ent = ply:GetEyeTrace().Entity
    if not ent:IsValid() or not ent:IsPlayer() then return end
    if ent:IsSCP() then return end
    if ent:GetPos():DistToSqr( ply:GetPos() ) > 50^2 then return end

    ent:TakeDamage( 500, ply, self )
end

function SWEP:SecondaryAttack()
    if CLIENT then return end

    local ply = self:GetOwner()
    local rag = ply:GetEyeTrace().Entity
    if not rag:IsValid() or not rag:GetClass() == "prop_ragdoll" then return end
    if rag:GetPos():DistToSqr( ply:GetPos() ) > 100^2 then return end

    if not rag:GetNWBool( "SCPSiteBreach:DeadBy049", false ) then return end
    local trg = rag:GetNWEntity( "SCPSiteBreach:DeadEntity" )

    if trg:IsValid() and not trg:Alive() then
        trg:SetSpectator( false )
        trg:Spawn()
        trg:ChangeTeam( SCP_0492 )
        trg:SetPos( rag:GetPos() + Vector( 0, 0, 5 ) )

        rag:Remove()
    end
end

function SWEP:DrawHUD()
    local rag = LocalPlayer():GetEyeTrace().Entity
    if not rag:GetNWBool( "SCPSiteBreach:DeadBy049", false ) then return end
    local ent = rag:GetNWEntity( "SCPSiteBreach:DeadEntity" )

    draw.SimpleTextOutlined( "Transform into SCP-049-2 :", "SCPSiteBreach:Font45", ScrW()/2, ScrH()/1.2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( ent:GetName(), "SCPSiteBreach:Font35", ScrW()/2, ScrH()/1.2+50, team.GetColor( ent:Team() ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color( 0, 0, 0 ) )
end
