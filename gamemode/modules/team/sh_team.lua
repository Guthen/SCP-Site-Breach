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

--  > Default Teams <  --
TEAM_SPECTATOR = SCPSiteBreach.AddTeam( "Spectator", -- spectator should never be deleted
    {
        models =
            {
                "models/player/combine_soldier.mdl",
            },
        weapons = {},
        description = "",
        color = Color( 109, 109, 109 ),
        health = 0,
        armor = 0,
        alliance = "Spectator",
    } )

local shouldLoadTeam = hook.Call( "SCPSiteBreach:OnDefaultTeamsAdded" )
local shouldLoadSCP = hook.Call( "SCPSiteBreach:OnDefaultSCPsAdded" )
if shouldLoadTeam or shouldLoadTeam == nil then
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
            description =
                "You are a Class-D. Find every items that can be usefull. Team Up with other Class-D or Chaos Member. Be aware of the Foundation Personnel Members and the SCPs.",
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
            description = "You are a Scientist. Use SCP-914 to upgrade your keycard. Team Up with other Foundation Personnel Members. Be aware of the Class-D and the SCPs.",
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
            description = "You are a Guard. Escort and protect other Foundation Personnel Members. Be aware of the Class-D and the SCPs.",
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
            description = "You are a Mobile-Task-Force Squad Member of Epsilon-11. Kill every Class-D or Chaos Members on your sight. Escort Foundation Personnel out of the Site. Be aware of the SCPs.",
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
            description = "You are a Chaos Insurgency Member. Kill every Foundation Member Personnel. Escort Class-D out of the Site. Be aware of the SCPs.",
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
end
if shouldLoadSCP or shouldLoadSCP == nil then
    -------------------
    --  > SCP-049 <  --
    -------------------
    SCP_049 = SCPSiteBreach.AddTeam( "SCP-049",
        {
            models =
                {
                    "models/player/scp/049/scp.mdl",
                },
            weapons =
                {
                    "scp_sb_scp_049",
                },
            description = "You are the Plague Doctor. Kill everyone on your way. Transform your victims into zombies. Avoid weaponed people. Team Up with other SCPs.",
            color = Color( 247, 66, 69 ),
            health = 7500,
            armor = 255,
            walkSpd = 115,
            runSpd = 115,
            max = 1,
            alliance = "SCPs",
        } )
    SCP_0492 = SCPSiteBreach.AddTeam( "SCP-049-2",
        {
            models =
                {
                    "models/player/zombie_classic.mdl",
                },
            weapons =
                {
                    "",
                },
            description = "You are the Plague Doctor's Zombie. Kill everyone on your way. Follow SCP-049 and collaborate together. Avoid weaponed people. Team Up with other SCPs.",
            color = Color( 247, 66, 69 ),
            health = 1500,
            armor = 100,
            walkSpd = 135,
            runSpd = 255,
            max = 0,
            spawnByScript = true, -- don't spawn by the gamemode
            alliance = "SCPs",
        } )
    -------------------
    --  > SCP-106 <  --
    -------------------
    SCP_106 = SCPSiteBreach.AddTeam( "SCP-106",
        {
            models =
                {
                    "models/player/scp/106/scp.mdl",
                },
            weapons =
                {
                    "scp_sb_scp_106",
                },
            description = "You are the Old Man. Teleport everyone in your dimension. You can walk trought doors and props. Avoid Tesla Gates and be aware of the Femur Breaker. Team Up with other SCPs.",
            color = Color( 247, 66, 69 ),
            health = 15000,
            armor = 255,
            walkSpd = 100,
            runSpd = 100,
            max = 1,
            alliance = "SCPs",
        } )
    -------------------
    --  > SCP-173 <  --
    -------------------
    SCP_173 = SCPSiteBreach.AddTeam( "SCP-173",
        {
            models =
                {
                    "models/player/scp/173/scp.mdl",
                },
            weapons =
                {
                    "scp_sb_scp_173",
                },
            description = "You are the Statue. You can only move on sight break or when people blink. Break the neck of everyone. Avoid the MTF Squad. Team Up with other SCPs.",
            color = Color( 247, 66, 69 ),
            health = 10000,
            armor = 255,
            walkSpd = 550,
            runSpd = 550,
            max = 1,
            alliance = "SCPs",
        } )
end

--  > Load Teams <  --
SCPSiteBreach.teamsSpawns = SCPSiteBreach.teamsSpawns or {}
for k, v in pairs( SCPSiteBreach.teams ) do
    SCPSiteBreach.teamsSpawns[ k ] = SCPSiteBreach.teamsSpawns[ k ] or {}
    SCPSiteBreach.allianceTeams[ v.alliance ] = SCPSiteBreach.allianceTeams[ v.alliance ] or {}

    if v.max and v.max <= 0 then v.max = game.MaxPlayers() end -- set max if 0

    team.SetUp( k, v.name or "Unnamed", v.color or Color( 50, 50, 50 ) ) -- set teams

    if SCPSiteBreach.alliances[ v.alliance ].isSCP then -- add SCPs to table
        table.insert( SCPSiteBreach.scps, k )
    end

    table.insert( SCPSiteBreach.allianceTeams[ v.alliance ], k )
end

-- models/player/scp/035/scp.mdl
-- models/props/scp/scp035/035_mask.mdl
-- models/player/scp/049/scp.mdl
-- models/player/scp/106/scp.mdl
-- models/player/scp/966/scp.mdl
-- models/player/scp/939/scp.mdl
