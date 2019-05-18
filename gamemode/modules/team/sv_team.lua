-----------------------------
--  > SCP - Site Breach <  --
--     > sv_team.lua <     --
-----------------------------

--  > Check <  --
if not SCPSiteBreach then
    return
end
SCPSiteBreach.teams = SCPSiteBreach.teams or {}

--  > Network <  --
util.AddNetworkString( "SCPSiteBreach:TeamHUD" )

--  > Server Hooks <  --

hook.Add( "PlayerSpawn", "SCPSiteBreach:TeamHUD", function( ply )
    timer.Simple( .1, function()
        net.Start( "SCPSiteBreach:TeamHUD" )
        net.Send( ply )
    end )
end )
