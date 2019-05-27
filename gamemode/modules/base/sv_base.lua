-----------------------------
--  > SCP - Site Breach <  --
--     > sv_base.lua <     --
-----------------------------

--  > Network <  --
util.AddNetworkString( "SCPSiteBreach:PlaySound" )

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

function GM:PlayerInitialSpawn( ply )
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
    if not ply:Team() == TEAM_SPECTATOR then return ply:ChangeTeam( ply:Team() ) end

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

    --  > Var <  --
    ply:SetNWInt( "SCPSiteBreach:Stamina", 20 )
    ply:SetNWInt( "SCPSiteBreach:Blink", 20 )

    --  > Blink <  --
    if timer.Exists( "SCPSiteBreach:Blink" .. ply:UserID() ) then timer.Remove( "SCPSiteBreach:Blink" .. ply:UserID() ) end
    if not ply:IsSCP() then -- if not scp then don't blink
        timer.Create( "SCPSiteBreach:Blink" .. ply:UserID() , .25, 0, function()
            if ply:IsSpectator() then return end

            local blink = ply:GetNWInt( "SCPSiteBreach:Blink", 20 ) -- get
            if blink >= 0 then
                ply:SetNWInt( "SCPSiteBreach:Blink", blink - 1 ) -- lose
                blink = blink - 1 -- refresh
            end
            if blink == -1 then
                ply:ScreenFade( SCREENFADE.OUT, Color( 0, 0, 0 ), .1, .2 )
                ply:SetNWBool( "SCPSiteBreach:IsBlink", true )
                timer.Simple( .3, function()
                    if ply:IsValid() then
                        ply:SetNWInt( "SCPSiteBreach:Blink", 20 )
                        ply:SetNWBool( "SCPSiteBreach:IsBlink", false )
                        ply:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0 ), .1, .1 )
                    end
                end )
            end
        end )
    end
end

-----------------------
--  > PlayerDeath <  --
-----------------------
function GM:PlayerDeath( ply, inf, atk )
    --  > Ragdoll <  --
    local ragdoll = ply:GetRagdollEntity()
    local _ragdoll
    if ragdoll and ragdoll:IsValid() then
        ragdoll:Remove()

        if ply:IsSpectator() then return end
        _ragdoll = ents.Create( "prop_ragdoll" )
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

    ply:SetNWInt( "SCPSiteBreach:Stamina", 20 )
    ply:SetNWInt( "SCPSiteBreach:Blink", 20 )
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

    if ply:KeyDown( IN_WALK ) then return true end

    if ply:KeyDown( IN_SPEED ) then -- stamina lose
        if timer.Exists( "SCPSiteBreach:Stamina" .. ply:UserID() ) then -- destroy stamina gain
            timer.Remove( "SCPSiteBreach:Stamina" .. ply:UserID() )
        end

        local stamina = ply:GetNWInt( "SCPSiteBreach:Stamina", 20 )
        if stamina >= 0 then
            ply:SetNWInt( "SCPSiteBreach:Stamina", stamina - 1 ) -- you sprint, you lose
        end
        if stamina - 1 <= 0 then
            ply:SetRunSpeed( ply:GetWalkSpeed() )
        else
            ply:SetRunSpeed( SCPSiteBreach.teams[ ply:Team() ].runSpd )
        end
        if stamina <= 9 and stamina % 3 == 0 then
            ply:EmitSound( "guthen_scp/player/breath" .. math.random( 1, 4 ) .. ".ogg" ) -- some sound
        end
    else -- stamina gain
        local stamina = ply:GetNWInt( "SCPSiteBreach:Stamina", 20 )
        timer.Simple( 1, function() -- wait a time
            if stamina == ply:GetNWInt( "SCPSiteBreach:Stamina", 20 ) then -- if stamina is same as before
                timer.Create( "SCPSiteBreach:Stamina" .. ply:UserID(), .25, 0, function() -- gain
                    local stamina = ply:GetNWInt( "SCPSiteBreach:Stamina", 20 )
                    ply:SetNWInt( "SCPSiteBreach:Stamina", math.Clamp( stamina + 1, 0, 20 ) )
                    if stamina + 1 >= 20 or ply:IsSpectator() then timer.Remove( "SCPSiteBreach:Stamina" .. ply:UserID() ) end -- if max then destroy
                end )
            end
        end )
    end

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

---------------------------------
--  > PlayerCanPickupWeapon <  --
---------------------------------
function GM:PlayerCanPickupWeapon( ply, wep )
    if ply:HasWeapon( wep:GetClass() ) then return false end -- don't get the same weapon

    if wep.AdminOnly then -- no admin swep for users
        if ply:IsSuperAdmin() then return true else return false end
    end

    if not wep.IsGive then -- take manually non-gived weapons (see: sv_players.lua)
        if ply:KeyDown( IN_USE ) then
            if not ply:GetEyeTrace().Entity == wep then return false end
            return true
        else
            return false
        end
    end

    return true
end

function GM:PlayerDroppedWeapon( ply, wep )
    wep.IsGive = false
end

function GM:PlayerNoClip( ply, state )
    local wep = ply:GetActiveWeapon() and ply:GetActiveWeapon():IsValid() and ply:GetActiveWeapon():GetClass()
    if wep then
        if wep == "scp_sb_keycards_config" or wep == "scp_sb_teams_spawner" or wep == "scp_sb_entities_spawner" then return true end
    end
    return not state
end
