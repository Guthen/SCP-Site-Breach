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
--  > Get Every Teams <  --
---------------------------
SCPSiteBreach.GetTeams = function()
    return SCPSiteBreach.teams
end

--  > Load Teams <  --
for k, v in pairs( SCPSiteBreach.teams ) do
    team.SetUp( k, v.name or "Unnamed", v.color or Color( 50, 50, 50 ) )
end
