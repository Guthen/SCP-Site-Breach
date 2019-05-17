-----------------------------
--  > SCP - Site Breach <  --
--     > sv_base.lua <     --
-----------------------------

--  > Gamemode Hooks <  --

-------------------------
--  > -- Players -- <  --
-------------------------

-----------------------
--  > PlayerSpawn <  --
-----------------------
function GM:PlayerSpawn( ply )
    player_manager.SetPlayerClass( ply, "player_default" )

    --  > Team <  --
    local team = math.random( #SCPSiteBreach.GetTeams() )
    local teamTab = SCPSiteBreach.GetTeam( team )
    if not teamTab then return print( "SCPSiteBreach - Failed to get Team " .. team .. " informations" ) end

    ply:SetModel( table.Random( teamTab.models ) ) -- model

    ply:SetWalkSpeed( teamTab.walkSpd or 150 ) -- walk speed
    ply:SetRunSpeed( teamTab.runSpd or 250 ) -- run speed

    ply:SetHealth( teamTab.health or 100 ) -- health
    ply:SetMaxHealth( teamTab.health or 100 ) -- max health
    ply:SetArmor( teamTab.armor or 100 ) -- armor

    for _, v in pairs( teamTab.weapons ) do -- weapons
        ply:Give( v )
    end

    print( ply:Name() .. " has joined Team " .. team  )
end

-----------------------
--  > PlayerDeath <  --
-----------------------
function GM:PlayerDeath( ply, inf, atk )
    --  > Weapons <  --
    local weaps = ply:GetWeapons()
    for k, v in pairs( weaps ) do
        local weap = ents.Create( v:GetClass() )
              weap:SetPos( ply:GetPos() + Vector( 0, 0, 25+5*k ) )
              weap:Spawn()
    end
    --  > Ragdoll <  --
    local ragdoll = ply:GetRagdollEntity()
    if ragdoll and ragdoll:IsValid() then
        ragdoll:Remove()

        local _ragdoll = ents.Create( "prop_ragdoll" )
              _ragdoll:SetModel( ply:GetModel() )
              _ragdoll:SetPos( ply:GetPos() )
              _ragdoll:Spawn()
    end
end

----------------------------
--  > PlayerDeathSound <  --
----------------------------
function GM:PlayerDeathSound()
    return true
end

--------------------------
--  > PlayerFootstep <  --
--------------------------
function GM:PlayerFootstep( ply, _, foot, sound )
    local id = (foot+1) * math.random( 1, 4 )

    local mat = ""
    if string.find( sound, "metal" ) then mat = "Metal" end

    ply:EmitSound( "guthen_scp/player/Step" .. mat .. id ) -- play walk footstep sound
    return true
end
