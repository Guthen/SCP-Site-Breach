-----------------------------
--  > SCP - Site Breach <  --
--   > sh_players.lua <    --
-----------------------------

local Player = FindMetaTable( "Player" )

--  > Player Functions <  --

--------------------------------
--  > Player:IsSpectator() <  --
--  > RETURNS IF SPECTATOR <  --
--------------------------------
function Player:isSpectator()
    return self:GetNWBool( "SCPSiteBreach:IsSpectator", false )
end

----------------------------------------------
--  > Player:SetBottomMessage( message ) <  --
----------------------------------------------
function Player:setBottomMessage( msg )
    if not msg or not isstring( msg ) then return end

    net.Start( "SCPSiteBreach:SetBottomMessage" )
        net.WriteString( msg )
    net.Send( self )
end

--------------------------
--  > Player:IsSCP() <  --
--  > RETURNS IF SCP <  --
--------------------------
function Player:isSCP()
    if self:Team() == TEAM_UNASSIGNED then return false end

    local t = SCPSiteBreach.teams[ self:Team() ]
    if not t then return false end

    local a = SCPSiteBreach.alliances[ t.alliance ]
    return a and a.isSCP
end

--------------------------
--  > Player:Is106() <  --
--  > RETURNS IF 106 <  --
--------------------------
function Player:isSCP106()
    return self:Team() == SCP_106
end

--------------------------
--  > Player:Is049() <  --
--  > RETURNS IF 049 <  --
--------------------------
function Player:isSCP049()
    return self:Team() == SCP_049
end
