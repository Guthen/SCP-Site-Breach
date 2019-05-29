-----------------------------
--  > SCP - Site Breach <  --
--      > sh_scp.lua <     --
-----------------------------

if not SCPSiteBreach then
    return print( "SCPSiteBreach - 'scp' module can't be loaded." )
end
SCPSiteBreach.scps = SCPSiteBreach.scps or {}

SCPSiteBreach.getSCPPlayers = function()
    local p = {}
    for _, v in pairs( player.GetAll() ) do
        if v:isSCP() then table.insert( p, v ) end
    end
    return p
end

SCPSiteBreach.getSCPTeams = function()
    return SCPSiteBreach.scps
end

---------------------------------
--  > PlayerCanPickupWeapon <  --
---------------------------------
hook.Add( "PlayerCanPickupWeapon", "SCPSiteBreach:SCP", function( ply, wep )
    if not ply:isSCP() then return end

    if wep.SCPSiteBreachSCP then return true end

    return false
end )
