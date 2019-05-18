-----------------------------
--  > SCP - Site Breach <  --
--   > cl_spectator.lua <  --
-----------------------------

--  > Gamemode Hooks <  --

-------------------------
--  > PrePlayerDraw <  --
-------------------------
function GM:PrePlayerDraw( ply ) -- players can't see spectator
    --ply:MarkShadowAsDirty()
    if ply:Team() == TEAM_SPECTATOR then ply:DestroyShadow() return true end
    return false
end
