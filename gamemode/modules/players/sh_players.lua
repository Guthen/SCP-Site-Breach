-----------------------------
--  > SCP - Site Breach <  --
--   > sh_players.lua <    --
-----------------------------

local Player = FindMetaTable( "Player" )

--  > Player Functions <  --

function Player:IsSpectator()
    return self:GetNWBool( "SCPSiteBreach:IsSpectator", false )
end

function Player:SetBottomMessage( msg )
    if not msg or not isstring( msg ) then return end

    net.Start( "SCPSiteBreach:SetBottomMessage" )
        net.WriteString( msg )
    net.Send( self )
end

--------------------------
--  > Player:IsSCP() <  --
--------------------------
function Player:IsSCP()
    if self:Team() == TEAM_UNASSIGNED then return false end

    local t = SCPSiteBreach.teams[ self:Team() ]
    if not t then return false end

    local a = SCPSiteBreach.alliances[ t.alliance ]
    return a and a.isSCP
end
