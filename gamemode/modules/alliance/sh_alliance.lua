-----------------------------
--  > SCP - Site Breach <  --
--   > sh_alliance.lua <   --
-----------------------------

SCPSiteBreach.alliances = SCPSiteBreach.alliances or {}
SCPSiteBreach.allianceTeams = SCPSiteBreach.allianceTeams or {}

SCPSiteBreach.AddAlliance = function( _name, _table )
    if not _name or not isstring( _name ) then return print( "SCPSiteBreach - Failed to create alliance (#1)" ) end
    if not _table or not istable( _table ) then return print( "SCPSiteBreach - Failed to create alliance (#2)" ) end

    SCPSiteBreach.alliances[_name] = _table
end

--  > Default Alliances <  --
hook.Add( "SCPSiteBreach:OnDefaultsTeamAdded", "SCPSiteBreach:LoadAlliances", function()
    SCPSiteBreach.alliances = SCPSiteBreach.alliances or {}

    SCPSiteBreach.AddAlliance( "Spectator",
        {
            respawnableAlliance = false, -- if in this alliance, some teams are respawnable
            isSpectator = true,
        } )

    SCPSiteBreach.AddAlliance( "Class-D",
        {
            respawnableAlliance = false, -- if in this alliance, some teams are respawnable
        } )

    SCPSiteBreach.AddAlliance( "Foundation",
        {
            respawnableAlliance = true, -- if in this alliance, some teams are respawnable
        } )

    SCPSiteBreach.AddAlliance( "Chaos",
        {
            respawnableAlliance = true, -- if in this alliance, some teams are respawnable
        } )
end )
