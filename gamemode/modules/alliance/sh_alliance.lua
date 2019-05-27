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
SCPSiteBreach.AddAlliance( "Spectator", -- spectator alliance should never be deleted
    {
        respawnableAlliance = false, -- if in this alliance, some teams are respawnable
        isSpectator = true,
    } )

local shouldLoadCat = hook.Call( "SCPSiteBreach:OnDefaultCategoriesAdded" )
if shouldLoadCat or shouldLoadCat == nil then
    hook.Add( "SCPSiteBreach:OnDefaultTeamsAdded", "SCPSiteBreach:LoadAlliances", function()
        SCPSiteBreach.alliances = SCPSiteBreach.alliances or {}

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

        SCPSiteBreach.AddAlliance( "SCPs",
            {
                isSCP = true,
                respawnableAlliance = false, -- if in this alliance, some teams are respawnable
            } )
    end )
end
