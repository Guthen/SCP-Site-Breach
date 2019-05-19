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

--  > Custom Functions <  --

SCPSiteBreach.chooseTeam = function()
    for k, v in pairs( SCPSiteBreach.teams ) do

        local count = #team.GetPlayers( k )
        for _k, _v in pairs( SCPSiteBreach.teams ) do

            local _count = #team.GetPlayers( _k )
            if count < _count then return k end

        end

    end
    return 2
end

--  > Server Hooks <  --

hook.Add( "PlayerSpawn", "SCPSiteBreach:TeamHUD", function( ply )
    timer.Simple( .2, function()
        net.Start( "SCPSiteBreach:TeamHUD" )
        net.Send( ply )
    end )
end )
