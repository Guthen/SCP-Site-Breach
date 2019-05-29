-----------------------------
--  > SCP - Site Breach <  --
--    > sv_round.lua <     --
-----------------------------

local nReady = 0
local totalDeath = totalDeath or 0
local scpKill = scpKill or 0

SCPSiteBreach.roundActive = SCPSiteBreach.roundActive or false
SCPSiteBreach.roundEnd = SCPSiteBreach.roundEnd or false

SCPSiteBreach.respawnableTeamsTime = 60

--  > Network <  --
util.AddNetworkString( "SCPSiteBreach:RoundStartHUD" )
util.AddNetworkString( "SCPSiteBreach:RoundEndHUD" )

util.AddNetworkString( "SCPSiteBreach:RoundStartReady" )

net.Receive( "SCPSiteBreach:RoundStartReady", function( _, ply )
    if not ply:IsValid() or ply:Alive() then return end
    if roundActive then return end

    nReady = nReady + 1

    if nReady >= math.ceil( game.MaxPlayers()/2 - #player.GetBots() ) then
        timer.Simple( 1, function()
            local _players = player.GetAll()
            _players = table.Shuffle( _players )

            for _, v in ipairs( _players ) do
                v:UnLock()
                v:Spawn()
            end

            timer.Simple( 1, function()
                SCPSiteBreach.roundActive = true

                timer.Create( "SCPSiteBreach:RespawnableTeams", SCPSiteBreach.respawnableTeamsTime, 0, function() -- spawn mtf..
                    SCPSiteBreach.SpawnRespawnableTeams()
                end )

                hook.Call( "SCPSiteBreach:OnRoundStartEnd" )
            end )
        end )
    end
end )

--  > Gamemode Hooks <  --

----------------------------
--  > PlayerDeathThink <  --
----------------------------
function GM:PlayerDeathThink( ply )
    if ply:IsBot() then return false end
    if not SCPSiteBreach.roundActive then return false end
end

-------------------------
--  > Round Control <  --
-------------------------
function GM:roundStart()
    nReady = 0
    SCPSiteBreach.roundActive = false
    SCPSiteBreach.roundEnd = false

    hook.Call( "SCPSiteBreach:OnRoundStart" )

    RunConsoleCommand( "scpsb_cleanup" ) -- clean up the map
    for _, v in pairs( player.GetAll() ) do
        v:setSpectator( false )
        v:KillSilent()
        v:Lock()
    end

    net.Start( "SCPSiteBreach:RoundStartHUD" ) -- pop-up the hud
    net.Broadcast()
end

function GM:roundEnd( winner )
    if SCPSiteBreach.roundEnd then return end
    SCPSiteBreach.roundEnd = true

    hook.Call( "SCPSiteBreach:OnRoundEnd" )

    net.Start( "SCPSiteBreach:RoundEndHUD" ) -- pop-up the hud
        net.WriteString( winner or "" )
        net.WriteInt( totalDeath, 16 )
        net.WriteInt( scpKill, 16 )
    net.Broadcast()

    timer.Simple( 10, function() -- start a new game after 10 sec
        RunConsoleCommand( "scpsb_round_start" )
    end )
end

SCPSiteBreach.SpawnRespawnableTeams = function()
    if not SCPSiteBreach.roundActive then return end
    if SCPSiteBreach.roundEnd then return end

    hook.Call( "SCPSiteBreach:OnSpawnRespawnableTeams" )

    local spectators = team.GetPlayers( TEAM_SPECTATOR )
    if #spectators <= 0 then return end -- if no death do nothing

    local a = {} --  get the respawnables alliances
    for k, v in pairs( SCPSiteBreach.alliances ) do
        if v.respawnableAlliance then table.insert( a, k ) end
    end
    SCPSiteBreach.respawnableAlliance = table.Random( a )

    local t = {} -- get the respawnables teams
    for k, v in pairs( SCPSiteBreach.teams ) do
        if v.alliance == SCPSiteBreach.respawnableAlliance then
            if v.respawnableTeam then
                --print( team.GetName( k ), v.alliance, SCPSiteBreach.respawnableAlliance )
                table.insert( t, k )
            end
        end
    end

    if #t <= 0 then return end -- if no respawnables teams then do nothing
    local _team = table.Random( t )
          _team = SCPSiteBreach.teams[ _team ]

    if _team.respawnSound then
        net.Start( "SCPSiteBreach:PlaySound" )
            net.WriteString( _team.respawnSound )
        net.Broadcast()
    end

    for _, v in pairs( spectators ) do -- get the death people
        local _team = table.Random( t )

        v:SetSpectator( false )
        v:Spawn()
        v:ChangeTeam( _team )
    end
end

------------------------------
--  > PlayerInitialSpawn <  --
------------------------------
function GM:PlayerInitialSpawn( ply )
    if SCPSiteBreach.roundActive then return ply:SetSpectator( true ) end -- set spectator if round is active

    RunConsoleCommand( "scpsb_round_start" ) -- start the round if not active
end

hook.Add( "PlayerDeath", "SCPSiteBreach:RoundStats", function( ply, inf, atk )
    totalDeath = totalDeath + 1 -- add death
    if not ply:isSCP() and atk:isSCP() then scpKill = scpKill + 1 end -- add scp kill
end )

hook.Add( "PostPlayerDeath", "SCPSiteBreach:RoundEnd", function( ply )
    timer.Simple( 1, function()
        if not SCPSiteBreach.roundActive then return end
        if SCPSiteBreach.roundEnd then return end

        local a = {}
        for k, v in pairs( SCPSiteBreach.allianceTeams ) do
            if SCPSiteBreach.alliances[ k ].isSpectator then continue end

            for _, _v in pairs( v ) do
                if #team.GetPlayers( _v ) > 0 then a[k] = true end
            end
        end

        local count = 0
        local firstK = ""
        for k, _ in pairs( a ) do
            count = count + 1
            if count == 1 then firstK = k end
        end

        if count <= 1 then
            GAMEMODE:roundEnd( firstK )
        end
    end )
end )
