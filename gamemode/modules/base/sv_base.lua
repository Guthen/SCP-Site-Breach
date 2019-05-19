-----------------------------
--  > SCP - Site Breach <  --
--     > sv_base.lua <     --
-----------------------------

--  > Gamemode Hooks <  --

function GM:PreCleanupMap()
end

--------------------------
--  > PostCleanupMap <  --
--------------------------
function GM:PostCleanupMap()
    RunConsoleCommand( "scpsb_load_entities_spawner" ) -- load entities spawner
    RunConsoleCommand( "scpsb_load_teams_spawner" ) -- load teams spawner
    RunConsoleCommand( "scpsb_load_keycards" ) -- load keycards

    timer.Simple( 1, function()
        for _, v in pairs( ents.FindByClass( "scp_sb_entity_spawner" ) ) do -- spawn class entity at cleanup
            v:SpawnClassEntity()
        end
    end )
end

-----------------------
--  > PlayerSpawn <  --
-----------------------
function GM:PlayerSpawn( ply )
    player_manager.SetPlayerClass( ply, "player_default" )

    --  > UnSpectate <  --
    ply:UnSpectate()

    --  > Hands <  --
    ply:SetupHands()

    --  > Team <  --
    local _team = SCPSiteBreach.chooseTeam()
    if _team == TEAM_UNASSIGNED then _team = 1 end
    if not ply:IsSpectator() then -- don't be a spectator if you haven't played
        while _team == TEAM_SPECTATOR do
            _team = math.random( #SCPSiteBreach.GetTeams() )
        end
        ply:GodDisable()
    else
        return
    end

    ply:ChangeTeam( _team ) -- sv_players.lua
end

-----------------------
--  > PlayerDeath <  --
-----------------------
function GM:PlayerDeath( ply, inf, atk )
    --  > Ragdoll <  --
    local ragdoll = ply:GetRagdollEntity()
    if ragdoll and ragdoll:IsValid() then
        ragdoll:Remove()

        if ply:IsSpectator() then return end
        local _ragdoll = ents.Create( "prop_ragdoll" )
              _ragdoll:SetModel( ply:GetModel() )
              _ragdoll:SetPos( ply:GetPos() )
              _ragdoll:Spawn()
    end
    --  > Weapons <  --
    local weaps = ply:GetWeapons()
    for k, v in pairs( weaps ) do
        local weap = ents.Create( v:GetClass() )
              weap:SetPos( ply:GetPos() + Vector( 0, 0, 25+5*k ) )
              weap:Spawn()
    end
    --  > Sound <  --
    if not ply:IsSpectator() then ply:EmitSound( "guthen_scp/player/Die" .. math.random( 2, 3 ) .. ".ogg" ) end

    --  > Var <  --
    ply:SetSpectator( true )
end

----------------------------
--  > PlayerDeathSound <  --
----------------------------
function GM:PlayerDeathSound( ply )
    return true
end

--------------------------
--  > PlayerFootstep <  --
--------------------------
function GM:PlayerFootstep( ply, _, foot, sound )
    local id = (foot+1) * math.random( 1, 4 ) -- sound id

    local mat = ""
    if string.find( sound, "metal" ) then mat = "Metal" end -- if metal

    local run = "Step"
    local vel = ply:GetVelocity():Length()
    if ply:GetRunSpeed()-2 < vel and vel < ply:GetRunSpeed()+2 then run = "Run" end -- if run

    if vel < 100 then return true end -- don't play sound if crouch walk

    local snd = "guthen_scp/player/" .. run .. mat .. id .. ".ogg"
    ply:EmitSound( snd ) -- play footstep sound
    return true
end

-------------------------------------
--  > PlayerCanHearPlayersVoice <  --
-------------------------------------
function GM:PlayerCanHearPlayersVoice( list, talk )
    if list:IsSpectator() and talk:IsSpectator() then return true end -- spectators
    if list:GetPos():DistToSqr( talk:GetPos() ) < 500*500 then return true, true end -- distance
    return false
end
