-----------------------------
--  > SCP - Site Breach <  --
--   > sh_players.lua <    --
-----------------------------

--  > Network <  --
util.AddNetworkString( "SCPSiteBreach:SetBottomMessage" )

--  > Meta <  --

local Player = FindMetaTable( "Player" )

--  > Player Functions <  --

function Player:SetSpectator( bool )
    self:SetNWBool( "SCPSiteBreach:IsSpectator", bool )
    if bool then
        self:Spawn()
        self:ChangeTeam( TEAM_SPECTATOR )
        self:UnSpectate()
    end
end

function Player:SetSpectatePlayer( ply )
    local id = math.random( #player.GetAll() )
    local trg = ply or Entity( id )
    if player.GetCount() > 1 then -- dangerous if it's singleplayer
        while trg == self do
            id = math.random( #player.GetAll() )
            trg = Entity( id )
        end
    end
    self:Spectate( OBS_MODE_CHASE )
    self:SpectateEntity( trg )

    self:SetNWInt( "SCPSiteBreach:SpectatorTarget", id )
end

function Player:ChangeTeam( _team )
    local teamTab = SCPSiteBreach.GetTeam( _team )
    if not teamTab then return false end

    self:SetTeam( _team )

    self:SetModel( table.Random( teamTab.models ) ) -- model

    self:SetWalkSpeed( teamTab.walkSpd or 150 ) -- walk speed
    self:SetRunSpeed( teamTab.runSpd or 250 ) -- run speed

    self:SetHealth( teamTab.health or 100 ) -- health
    self:SetMaxHealth( teamTab.health or 100 ) -- max health
    self:SetArmor( teamTab.armor or 100 ) -- armor

    --PrintTable( SCPSiteBreach.teamsSpawns )
    local spawns = SCPSiteBreach.teamsSpawns[ self:Team() ]
    if spawns then -- if teams spawns then set pos/angles
        local spawn = table.Random( spawns )
        if spawn then
            self:SetPos( spawn.pos )
            self:SetAngles( spawn.ang )
        end
    end

    self:StripWeapons()
    for _, v in pairs( teamTab.weapons ) do -- weapons
        local wep = weapons.Get( v )
        if wep and wep.AdminOnly and not self:IsAdmin() then continue end
        self:Give( v )
    end

    return true
end
