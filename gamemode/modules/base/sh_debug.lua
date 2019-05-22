-----------------------------
--  > SCP - Site Breach <  --
--     > sh_debug.lua <    --
-----------------------------

concommand.Add( "scpsb_getmodels", function( _, _, _, arg )
    local fol = "models/" .. ( arg or "" )
    local mdls, folders = file.Find( fol .. "*", "GAME" )

    for _, v in pairs( folders ) do
        print( "Models folders : ".. fol .. v )
    end
    for _, v in pairs( mdls ) do
        print( "    Model : ".. fol .. v )
    end
end )

concommand.Add( "scpsb_getweapons", function( _, _, _, arg )
    if not arg or string.len( arg ) <= 1 then return print( "SCPSiteBreach - You must return an argument" ) end
    local i = 0
    for _, v in pairs( weapons.GetList() ) do
        if not v.ClassName then continue end
        if string.find( v.ClassName:lower(), ( arg or "" ):lower() ) then print( v.ClassName ) i = i + 1 end
    end
    if i <= 0 then return print( "SCPSiteBreach - Found no weapons" ) end
end )

concommand.Add( "scpsb_giveweapon", function( ply, _, args )
    if not ply:IsSuperAdmin() then return end
    if not args[1] then return end

    ply:Give( args[1] )
end )

concommand.Add( "scpsb_round_start", function( ply )
    if ply:IsValid() and not ply:IsSuperAdmin() then return end
    if CLIENT then return end

    GAMEMODE:RoundStart()
end )

concommand.Add( "scpsb_round_end", function( ply )
    if ply:IsValid() and not ply:IsSuperAdmin() then return end
    if CLIENT then return end

    GAMEMODE:RoundEnd()
end )

concommand.Add( "scpsb_config", function( ply )
    if not ply:IsValid() or not ply:IsSuperAdmin() then return end

    ply:Give( "scp_sb_teams_spawner" )
    ply:Give( "scp_sb_entities_spawner" )
    ply:Give( "scp_sb_keycards_config" )
end )

concommand.Add( "scpsb_teleport_everyone", function( ply )
    if not ply:IsValid() or not ply:IsSuperAdmin() then return end

    for k, v in pairs( player.GetAll() ) do
        if v == ply then continue end

        local ang = math.rad( math.random( 360 ) )
        v:SetPos( ply:GetPos() + Vector( math.cos( ang )*50, math.sin( ang )*50, 0 ) )
    end
end )

concommand.Add( "scpsb_cleanup", function( ply )
    if not ply:IsValid() or ply:IsSuperAdmin() then game.CleanUpMap() end
end )

concommand.Add( "scpsb_unspectator", function( ply )
    if not ply:IsSuperAdmin() then return end

    ply:SetNWBool( "SCPSiteBreach:IsSpectator", false )
    ply:Spawn()
end )

concommand.Add( "scpsb_kill", function( ply )
    if not ply:IsSuperAdmin() then return end

    local ent = ply:GetEyeTrace().Entity
    if not ent:IsValid() or not ent:IsPlayer() then return end

    ent:Kill()
end )

--  > Entities Spawner <  --

concommand.Add( "scpsb_save_entities_spawner", function( ply )
    if ply:IsValid() and not ply:IsSuperAdmin() then return print( "SCPSiteBreach - " .. ply:Name() .. " is not allowed to load entities spawner." ) end
    if CLIENT then return end

    if not file.Exists( "scp_sb", "DATA" ) then -- create dir if not exists
        file.CreateDir( "scp_sb" )
    end

    if not file.Exists( "scp_sb/" .. game.GetMap(), "DATA" ) then -- create dir if not exists
        file.CreateDir( "scp_sb/" .. game.GetMap() )
    end

    local _ents = {}
    local i = 0 -- get number of saved entities
    for _, v in pairs( ents.FindByClass( "scp_sb_entity_spawner" ) ) do -- add data to a table
        table.insert( _ents, { pos = v:GetPos(), ang = v:GetAngles(), class = v:GetClassEntity(), chance = v:GetChance() or 1 } )
        i = i + 1
    end

    file.Write( "scp_sb/" .. game.GetMap() .. "/entities_spawner.txt", util.TableToJSON( _ents ) ) -- save table to json
    print( "SCPSiteBreach - All Entities Spawner have been saved (" .. i .. " entities)" )
end )

concommand.Add( "scpsb_load_entities_spawner", function( ply )
    if ply:IsValid() and not ply:IsSuperAdmin() then return print( "SCPSiteBreach - " .. ply:Name() .. " is not allowed to load entities spawner." ) end
    if CLIENT then return end

    if not file.Exists( "scp_sb", "DATA" ) then -- create dir if not exists
        return print( "SCPSiteBreach - Directory doesn't exists" )
    end

    if not file.Exists( "scp_sb/" .. game.GetMap(), "DATA" ) then -- create dir if not exists
        return print( "SCPSiteBreach - Map Directory doesn't exists" )
    end

    if not file.Exists( "scp_sb/" .. game.GetMap() .. "/entities_spawner.txt", "DATA" ) then -- create dir if not exists
        return print( "SCPSiteBreach - File doesn't exists" )
    end

    local _ents = file.Read( "scp_sb/" .. game.GetMap() .. "/entities_spawner.txt", "DATA" ) -- read data
    _ents = util.JSONToTable( _ents )

    for _, v in pairs( ents.FindByClass( "scp_sb_entity_spawner" ) ) do -- remove all others entities
        v:Remove()
    end

    local i = 0
    for _, v in pairs( _ents ) do -- spawn the entities
        local ent = ents.Create( "scp_sb_entity_spawner" )
              ent:SetPos( v.pos )
              ent:SetAngles( v.ang )
              ent:Spawn()
              ent:SetClassEntity( v.class )
              ent:SetChance( v.chance )

        i = i + 1
    end

    print( "SCPSiteBreach - All Entities Spawner have been loaded (" .. i .. " entities)" )
end )

--  > Teams Spawners <  --

concommand.Add( "scpsb_save_teams_spawner", function( ply )
    if ply:IsValid() and not ply:IsSuperAdmin() then return print( "SCPSiteBreach - " .. ply:Name() .. " is not allowed to load teams spawner." ) end
    if CLIENT then return end

    if not file.Exists( "scp_sb", "DATA" ) then -- create dir if not exists
        file.CreateDir( "scp_sb" )
    end

    if not file.Exists( "scp_sb/" .. game.GetMap(), "DATA" ) then -- create dir if not exists
        file.CreateDir( "scp_sb/" .. game.GetMap() )
    end

    local _ents = {}
    local i = 0 -- get number of saved entities
    for _, v in pairs( ents.FindByClass( "scp_sb_team_spawner" ) ) do -- add data to a table
        table.insert( _ents, { pos = v:GetPos(), ang = v:GetAngles(), team = v:GetTeamID() } )
        i = i + 1
    end

    file.Write( "scp_sb/" .. game.GetMap() .. "/teams_spawner.txt", util.TableToJSON( _ents ) ) -- save table to json
    print( "SCPSiteBreach - All Teams Spawner have been saved (" .. i .. " entities)" )
end )

concommand.Add( "scpsb_load_teams_spawner", function( ply )
    if ply:IsValid() and not ply:IsSuperAdmin() then return print( "SCPSiteBreach - " .. ply:Name() .. " is not allowed to load teams spawner." ) end
    if CLIENT then return end

    if not file.Exists( "scp_sb", "DATA" ) then -- create dir if not exists
        return print( "SCPSiteBreach - Directory doesn't exists" )
    end

    if not file.Exists( "scp_sb/" .. game.GetMap(), "DATA" ) then -- create dir if not exists
        return print( "SCPSiteBreach - Map Directory doesn't exists" )
    end

    if not file.Exists( "scp_sb/" .. game.GetMap() .. "/teams_spawner.txt", "DATA" ) then -- create dir if not exists
        return print( "SCPSiteBreach - File doesn't exists" )
    end

    local _ents = file.Read( "scp_sb/" .. game.GetMap() .. "/teams_spawner.txt", "DATA" ) -- read data
    _ents = util.JSONToTable( _ents )

    for _, v in pairs( ents.FindByClass( "scp_sb_team_spawner" ) ) do -- remove all others entities
        v:Remove()
    end

    for _, v in pairs( SCPSiteBreach.teamsSpawns ) do -- reset all points
        table.Empty( v )
    end

    local i = 0
    for _, v in pairs( _ents ) do -- spawn the entities
        local ent = ents.Create( "scp_sb_team_spawner" )
              ent:SetPos( v.pos )
              ent:SetAngles( v.ang )
              ent:Spawn()
              ent:SetTeamID( v.team )

        table.insert( SCPSiteBreach.teamsSpawns[ v.team ], v )

        i = i + 1
    end

    print( "SCPSiteBreach - All Teams Spawner have been loaded (" .. i .. " entities)" )
end )
