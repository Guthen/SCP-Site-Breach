-----------------------------
--  > SCP - Site Breach <  --
--     > sv_team.lua <     --
-----------------------------

--  > Check <  --
if not SCPSiteBreach then
    return
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
    print( _id )
    return _id
end

---------------------------
--  > Get Team By ID <   --
---------------------------
SCPSiteBreach.GetTeam = function( _id )
    return SCPSiteBreach.teams[_id]
end

--  > Default Teams <  --

-------------------
--  > Class-D <  --
-------------------
TEAM_CLASSD = SCPSiteBreach.AddTeam( "Class-D",
    {
        models =
            {
                "models/player/aperture_science/male_09.mdl",
            },
        weapons =
            {
                "weapon_pistol",
                "weapon_crowbar",
            },
        health = 100,
        armor = 0,
        walkSpd = 150,
        runSpd = 250,
    } )

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
        weapons =
            {
                "",
            },
        health = 100,
        armor = 0,
        walkSpd = 150,
        runSpd = 250,
    } )

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
        health = 100,
        armor = 50,
        walkSpd = 150,
        runSpd = 250,
    } )
