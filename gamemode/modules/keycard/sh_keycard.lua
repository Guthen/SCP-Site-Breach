-----------------------------
--  > SCP - Site Breach <  --
--   > sh_keycard.lua <    --
-----------------------------

--  > Variables <  --
SCPSiteBreach.keycardAvailableClass = -- entity class which we can set LVL
    {
        [ "func_button" ] = true,
        [ "class C_BaseEntity" ] = true,
    }

--  > ConCommands <  --

concommand.Add( "scpsb_save_keycards", function( ply )
    if ply:IsValid() and not ply:IsSuperAdmin() then return end
    if CLIENT then return end

    if not file.Exists( "scp_sb", "DATA" ) then -- create dir if not exists
        file.CreateDir( "scp_sb" )
    end

    if not file.Exists( "scp_sb/" .. game.GetMap(), "DATA" ) then -- create dir if not exists
        file.CreateDir( "scp_sb/" .. game.GetMap() )
    end

    local _ents = {}
    local i = 0 -- get number of saved entities
    for k, _ in pairs( SCPSiteBreach.keycardAvailableClass ) do
        for _, v in pairs( ents.FindByClass( k ) ) do -- add data to a table
            if v:GetNWInt( "SCPSiteBreach:LVL", 0 ) <= 0 then continue end
            table.insert( _ents, { mapID = v:MapCreationID(), lvl = v:GetNWInt( "SCPSiteBreach:LVL", 0 ) } )
            i = i + 1
        end
    end

    file.Write( "scp_sb/" .. game.GetMap() .. "/keycards.txt", util.TableToJSON( _ents ) ) -- save table to json
    print( "SCPSiteBreach - All Keycards have been saved (" .. i .. " entities)" )
end )


concommand.Add( "scpsb_load_keycards", function( ply )
    if ply:IsValid() and not ply:IsSuperAdmin() then return print( "SCPSiteBreach - " .. ply:Name() .. " is not allowed to load keycards." ) end
    if CLIENT then return end

    if not file.Exists( "scp_sb", "DATA" ) then -- create dir if not exists
        return print( "SCPSiteBreach - Directory doesn't exists" )
    end

    if not file.Exists( "scp_sb/" .. game.GetMap(), "DATA" ) then -- create dir if not exists
        return print( "SCPSiteBreach - Map Directory doesn't exists" )
    end

    if not file.Exists( "scp_sb/" .. game.GetMap() .. "/keycards.txt", "DATA" ) then -- create dir if not exists
        return print( "SCPSiteBreach - File doesn't exists" )
    end

    local _ents = file.Read( "scp_sb/" .. game.GetMap() .. "/keycards.txt", "DATA" ) -- read data
    _ents = util.JSONToTable( _ents )

    local i = 0
    for _, v in pairs( _ents ) do -- spawn the entities
        local _ent = ents.GetMapCreatedEntity( v.mapID )
              _ent:SetNWInt( "SCPSiteBreach:LVL", v.lvl > 0 and v.lvl or nil ) -- get nil if 0 or lvl

        i = i + 1
    end

    print( "SCPSiteBreach - All Keycards have been loaded (" .. i .. " entities)" )
end )
