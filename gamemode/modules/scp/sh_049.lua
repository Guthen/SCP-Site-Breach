-----------------------------
--  > SCP - Site Breach <  --
--      > sh_049.lua <     --
-----------------------------

--------------------------
--  > PlayerFootstep <  --
--------------------------
hook.Add( "PlayerFootstep", "SCPSiteBreach:SCP049", function( ply, _, foot )
    if not ply:isSCP049() then return end

    ply:EmitSound( "guthen_scp/049/Step" .. math.Clamp( foot + math.random( 0, 2 ), 1, 3 ) .. ".ogg" )
    return true
end )
