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
        if v:IsSCP() then table.insert( p, v ) end
    end
    return p
end

SCPSiteBreach.getSCPTeams = function()
    return SCPSiteBreach.scps
end
