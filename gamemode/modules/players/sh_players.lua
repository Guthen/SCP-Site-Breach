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
