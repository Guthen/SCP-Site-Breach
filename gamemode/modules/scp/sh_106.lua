-----------------------------
--  > SCP - Site Breach <  --
--      > sh_106.lua <     --
-----------------------------

local TroughtClass =
{
    [ "prop_static" ] = true,
    [ "prop_physics" ] = true,
    [ "prop_dynamic" ] = true,
    [ "prop_rotating_door" ] = true,
    [ "func_door" ] = true,
    [ "func_rotating_door" ] = true,
}

--------------------------
--  > PlayerFootstep <  --
--------------------------
hook.Add( "PlayerFootstep", "SCPSiteBreach:SCP106", function( ply, _, foot )
    if not ply:IsSCP106() then return end

    ply:EmitSound( "guthen_scp/106/StepPD" .. foot + math.random( 0, 1 ) .. ".ogg" )
    return true
end )

-----------------------
--  > PlayerSpawn <  --
-----------------------
hook.Add( "PlayerSpawn", "SCPSiteBreach:SCP106", function( ply )
    timer.Simple( 0, function()
        if ply:IsSCP106() then
            ply:SetCustomCollisionCheck( true )
        else
            ply:SetCustomCollisionCheck( false )
        end
    end )
end )

-------------------------
--  > ShouldCollide <  --
-------------------------
hook.Add( "ShouldCollide", "SCPSiteBreach:SCP106", function( ent1, ent2 )
    if ( ent1:IsValid() and ent1:IsPlayer() ) and ( ent2:IsValid() and TroughtClass[ ent2:GetClass() ] ) then
        if ent1:IsSCP106() then
            return false
        end
    end
end )
