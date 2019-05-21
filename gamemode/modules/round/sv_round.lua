-----------------------------
--  > SCP - Site Breach <  --
--    > sv_round.lua <     --
-----------------------------

local nReady = 0
SCPSiteBreach.roundActive = false

--  > Network <  --
util.AddNetworkString( "SCPSiteBreach:RoundStartHUD" )
util.AddNetworkString( "SCPSiteBreach:RoundStartReady" )

net.Receive( "SCPSiteBreach:RoundStartReady", function( _, ply )
    if not ply:IsValid() or ply:Alive() then return end
    if roundActive then return end

    nReady = nReady + 1

    if nReady >= math.ceil( game.MaxPlayers()/2 - #player.GetBots() ) then
        SCPSiteBreach.roundActive = true
        timer.Simple( 1, function()
            for _, v in pairs( player.GetAll() ) do
                v:UnLock()
                v:Spawn()
            end

            hook.Call( "SCPSiteBreach:OnRoundStartEnd" )
        end )
    end
end )

--  > Gamemode Hooks <  --

function GM:PlayerDeathThink( ply )
    if ply:IsBot() then return false end
    if not SCPSiteBreach.roundActive then return false end
end

function GM:RoundStart()
    nReady = 0
    SCPSiteBreach.roundActive = false

    hook.Call( "SCPSiteBreach:OnRoundStart" )

    RunConsoleCommand( "scpsb_cleanup" ) -- clean up the map
    for _, v in pairs( player.GetAll() ) do
        v:SetSpectator( false )
        v:KillSilent()
        v:Lock()
    end

    net.Start( "SCPSiteBreach:RoundStartHUD" ) -- pop-up the hud
    net.Broadcast()
end

function GM:PlayerInitialSpawn( ply )
    print( SCPSiteBreach.roundActive )
    if SCPSiteBreach.roundActive then return ply:SetSpectator( true ) end -- set spectator if round is active
    RunConsoleCommand( "scpsb_round_start" ) -- start the round if not active
end
