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
SCPSiteBreach.respawnableAlliance = "Chaos"

SCPSiteBreach.chooseTeam = function()
    local manySCPs = math.floor( ( player.GetCount() - #team.GetPlayers( TEAM_SPECTATOR ) - #SCPSiteBreach.getSCPPlayers() ) / 4 )
    if manySCPs > 0 then
        local SCPs = SCPSiteBreach.getSCPTeams()
        local nSCPs = #SCPs

        for k, v in pairs( table.Shuffle( SCPs ) ) do
            local count = #team.GetPlayers( v )

            if count < SCPSiteBreach.GetTeam( v ).max then
                return scp
            end
        end
    end

    local lessPlTeam = TEAM_CLASSD

    for k, v in pairs( SCPSiteBreach.GetTeams() ) do
        if TEAM_SPECTATOR == k then continue end
        if v.spawnByScript then continue end

        if SCPSiteBreach.roundActive then -- get mtf/other team if the round is active (respawn time)
            if not v.respawnableTeam then continue end
            if SCPSiteBreach.respawnableAlliance == v.alliance then
                return k
            end
        end
        if v.respawnableTeam then continue end -- can't be mtf/other team if round is not active

        local count = #team.GetPlayers( k )
        if count == 0 then return k end

        for _k, _v in pairs( SCPSiteBreach.GetTeams() ) do
            if TEAM_SPECTATOR == k then continue end
            if k == _k then continue end
            if _v.spawnByScript then continue end

            if SCPSiteBreach.roundActive then -- get mtf/other team if the round is active (respawn time)
                if not _v.respawnableTeam then continue end
                if SCPSiteBreach.respawnableAlliance == _v.alliance then
                    return _k
                end
            end
            if _v.respawnableTeam then continue end -- can't be mtf/other team if round is not active

            local _count = #team.GetPlayers( _k )
            if count > _count then
                if _v.max and _count + 1 > _v.max then continue end
                lessPlTeam = _k
            end
        end
    end

    return lessPlTeam -- return CLASSD team if not found
end

--  > Server Hooks <  --

hook.Add( "PlayerSpawn", "SCPSiteBreach:TeamHUD", function( ply )
    local should = hook.Call( "SCPSiteBreach:ShouldShowTeamHUD", _, ply, team )
    if should == nil or should == true then
        timer.Simple( .2, function()
            net.Start( "SCPSiteBreach:TeamHUD" )
            net.Send( ply )
        end )
    end
end )
