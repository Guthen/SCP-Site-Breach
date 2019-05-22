-----------------------------
--  > SCP - Site Breach <  --
--   > sv_spectator.lua <  --
-----------------------------

--  > Network <  --
util.AddNetworkString( "SCPSiteBreach:ChangeSpectatorTarget" )

net.Receive( "SCPSiteBreach:ChangeSpectatorTarget", function( _, ply )
    if not ply:IsSpectator() then return end

    local isLeft = net.ReadBool()
    if isLeft == nil then return end

    local curId = ply:GetNWInt( "SCPSiteBreach:SpectatorTarget", 1 )
    local id
    if isLeft then
        id = curId - 1 >= 1 and curId - 1 or player.GetCount()
    else
        id = curId + 1 <= player.GetCount() and curId + 1 or 1
    end

    ply:SetNWInt( "SCPSiteBreach:SpectatorTarget", id )
    ply:SpectateEntity( player.GetAll()[ id ] )
end )
--  > Gamemode Hooks <  --

-------------------------------
--  > PlayerCanPickupItem <  --
-------------------------------
function GM:PlayerCanPickupItem( ply )
    return not ply:IsSpectator()
end

---------------------------
--  > PostPlayerDeath <  --
---------------------------
hook.Add( "PostPlayerDeath", "SCPSiteBreach:SpectateMode", function( ply )
    ply:SetSpectatePlayer() -- sv_players.lua
end )
