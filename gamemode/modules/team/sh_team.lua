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
    } )

-------------------
--  > Class-D <  --
-------------------
TEAM_CLASSD = SCPSiteBreach.AddTeam( "Class-D",
    {
        models =
            {
                "models/player/aperture_science/male_09.mdl",
            },
        weapons = {},
        color = Color( 244, 142, 65 ),
        health = 100,
        armor = 0,
        walkSpd = 150,
        runSpd = 250,
    } )

-------------------
-- > Scientist < --
-------------------
TEAM_SCIENTIST = SCPSiteBreach.AddTeam( "Scientist",
    {
        models =
            {
                "models/player/scpsci_male_01.mdl",
                "models/player/scpsci_male_02.mdl",
                "models/player/scpsci_male_03.mdl",
                "models/player/scpsci_male_04.mdl",
                "models/player/scpsci_male_05.mdl",
                "models/player/scpsci_male_06.mdl",
                "models/player/scpsci_male_07.mdl",
                "models/player/scpsci_male_08.mdl",
                "models/player/scpsci_male_09.mdl",
            },
        weapons = {},
        color = Color( 244, 211, 65 ),
        health = 100,
        armor = 0,
        walkSpd = 150,
        runSpd = 250,
    } )

-------------------
--   > Guard <   --
-------------------
TEAM_GUARD = SCPSiteBreach.AddTeam( "Guard",
    {
        models =
            {
                "models/player/swat.mdl",
            },
        weapons =
            {
                "weapon_smg1",
                "weapon_stunstick",
            },
        color = Color( 66, 137, 244 ),
        health = 100,
        armor = 50,
        walkSpd = 150,
        runSpd = 250,
    } )

--  > Load Teams <  --
for k, v in pairs( SCPSiteBreach.teams ) do
    team.SetUp( k, v.name or "Unnamed", v.color or Color( 50, 50, 50 ) )
end
