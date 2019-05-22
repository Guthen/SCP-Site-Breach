-----------------------------
--  > SCP - Site Breach <  --
--     > sh_team.lua <     --
-----------------------------

if not SCPSiteBreach then
    return print( "SCPSiteBreach - 'team' module can't be loaded." )
end
SCPSiteBreach.teams = SCPSiteBreach.teams or {}

--  > Server Customs Functions <  --

---------------------------
--      > Add Team <     --
---------------------------
SCPSiteBreach.AddTeam = function( _name, _table )
    if not _name or not isstring( _name ) then return print( "SCPSiteBreach - Failed to create team (#1)" ) end
    if not _table or not istable( _table ) then return print( "SCPSiteBreach - Failed to create team (#2)" ) end

    if not _table.alliance then return error( "SCPSiteBreach - The alliance of team : '" .. _name .. "' must be informed !", 2 ) end
    if not SCPSiteBreach.alliances[ _table.alliance ] then return error( "SCPSiteBreach - The alliance '" .. _table.alliance .. "' must be created !", 2 ) end

    local _id = #SCPSiteBreach.teams+1

    _table.name = _name
    SCPSiteBreach.teams[_id] = _table

    return _id
end

---------------------------
--  > Get Every Teams <  --
---------------------------
SCPSiteBreach.GetTeams = function()
    return SCPSiteBreach.teams
end

---------------------------
--  > Get Team By ID <   --
---------------------------
SCPSiteBreach.GetTeam = function( _id )
    return SCPSiteBreach.teams[_id]
end

hook.Call( "SCPSiteBreach:OnDefaultsTeamAdded" )

--  > Default Teams <  --

TEAM_SPECTATOR = SCPSiteBreach.AddTeam( "Spectator",
    {
        models =
            {
                "models/player/combine_soldier.mdl",
            },
        weapons = {},
        color = Color( 109, 109, 109 ),
        health = 0,
        armor = 0,
        alliance = "Spectator",
    } )

-------------------
--  > Class-D <  --
-------------------
TEAM_CLASSD = SCPSiteBreach.AddTeam( "Class-D",
    {
        models =
            {
                "models/player/humans/class_d/class_d_1.mdl",
                "models/player/humans/class_d/class_d_2.mdl",
                "models/player/humans/class_d/class_d_3.mdl",
                "models/player/humans/class_d/class_d_4.mdl",
                "models/player/humans/class_d/class_d_5.mdl",
                "models/player/humans/class_d/class_d_6.mdl",
                "models/player/humans/class_d/class_d_7.mdl",
            },
        weapons = {},
        color = Color( 244, 142, 65 ),
        health = 100,
        armor = 0,
        walkSpd = 150,
        runSpd = 250,
        max = 0,
        alliance = "Class-D",
    } )

-------------------
-- > Scientist < --
-------------------
TEAM_SCIENTIST = SCPSiteBreach.AddTeam( "Scientist",
    {
        models =
            {
                "models/player/humans/class_scientist/class_scientist_1.mdl",
                "models/player/humans/class_scientist/class_scientist_2.mdl",
                "models/player/humans/class_scientist/class_scientist_3.mdl",
                "models/player/humans/class_scientist/class_scientist_4.mdl",
                "models/player/humans/class_scientist/class_scientist_5.mdl",
                "models/player/humans/class_scientist/class_scientist_6.mdl",
                "models/player/humans/class_scientist/class_scientist_7.mdl",
            },
        weapons =
            {
                "scp_sb_keycard_lvl_2",
            },
        color = Color( 244, 211, 65 ),
        health = 100,
        armor = 0,
        walkSpd = 150,
        runSpd = 250,
        max = math.floor( game.MaxPlayers() / 3 ),
        alliance = "Foundation",
    } )

-------------------
--   > Guard <   --
-------------------
TEAM_GUARD = SCPSiteBreach.AddTeam( "Guard",
    {
        models =
            {
                "models/player/humans/class_scientist/class_securety/class_securety.mdl",
            },
        weapons =
            {
                "scp_sb_keycard_lvl_3",
                "tfa_scp_mp5",
            },
        color = Color( 66, 137, 244 ),
        health = 100,
        armor = 50,
        walkSpd = 150,
        runSpd = 250,
        max = math.floor( game.MaxPlayers() / 2 ),
        alliance = "Foundation",
    } )

-------------------
--   > MTF <   --
-------------------
TEAM_MTF = SCPSiteBreach.AddTeam( "MTF - Epsilon-11",
    {
        models =
            {
                "models/player/swat.mdl",
            },
        weapons =
            {
                "scp_sb_keycard_lvl_4",
                "tfa_scp_p90",
            },
        color = Color( 28, 25, 211 ),
        health = 100,
        armor = 150,
        walkSpd = 150,
        runSpd = 250,
        max = math.floor( game.MaxPlayers() / 2 ),
        alliance = "Foundation",
        respawnableTeam = true, -- if we only can be this job at the respawn time
        respawnSound = "guthen_scp/site/mtf_annoucement.ogg",
    } )

-------------------
--   > MTF <   --
-------------------
TEAM_CIM = SCPSiteBreach.AddTeam( "Chaos Insurgency Member",
    {
        models =
            {
                "models/player/phoenix.mdl",
            },
        weapons =
            {
                "scp_sb_keycard_lvl_4",
                "tfa_scp_m249",
            },
        color = Color( 24, 210, 127 ),
        health = 100,
        armor = 150,
        walkSpd = 150,
        runSpd = 250,
        max = math.floor( game.MaxPlayers() / 2 ),
        alliance = "Chaos",
        respawnableTeam = true, -- if we only can be this job at the respawn time
        respawnSound = "guthen_scp/site/chaos_annoucement.ogg",
    } )

--  > Load Teams <  --
SCPSiteBreach.teamsSpawns = SCPSiteBreach.teamsSpawns or {}
for k, v in pairs( SCPSiteBreach.teams ) do
    SCPSiteBreach.teamsSpawns[ k ] = SCPSiteBreach.teamsSpawns[ k ] or {}
    SCPSiteBreach.allianceTeams[ v.alliance ] = SCPSiteBreach.allianceTeams[ v.alliance ] or {}

    if v.max and v.max <= 0 then v.max = game.MaxPlayers() end

    team.SetUp( k, v.name or "Unnamed", v.color or Color( 50, 50, 50 ) )

    table.insert( SCPSiteBreach.allianceTeams[ v.alliance ], k )
end

-- models/player/scp/035/scp.mdl
-- models/props/scp/scp035/035_mask.mdl
-- models/player/scp/049/scp.mdl
-- models/player/scp/106/scp.mdl
-- models/player/scp/966/scp.mdl
-- models/player/scp/939/scp.mdl
