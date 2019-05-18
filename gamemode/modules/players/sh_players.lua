-----------------------------
--  > SCP - Site Breach <  --
--   > sh_players.lua <    --
-----------------------------

local Player = FindMetaTable( "Player" )

--  > Player Functions <  --

function Player:IsSpectator()
    return self:GetNWBool( "SCPSiteBreach:IsSpectator", false )
end
