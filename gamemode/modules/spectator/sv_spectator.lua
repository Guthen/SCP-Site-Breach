-----------------------------
--  > SCP - Site Breach <  --
--   > sv_spectator.lua <  --
-----------------------------

--  > Gamemode Hooks <  --

---------------------------------
--  > PlayerCanPickupWeapon <  --
---------------------------------
function GM:PlayerCanPickupWeapon( ply, wep )
    if wep.AdminOnly and ply:IsAdmin() then return true end
    return not ply:IsSpectator()
end

-------------------------------
--  > PlayerCanPickupItem <  --
-------------------------------
function GM:PlayerCanPickupItem( ply )
    return not ply:IsSpectator()
end

---------------------
--  > PlayerUse <  --
---------------------
function GM:PlayerUse( ply, ent )
    if ply:IsSpectator() then return false end
    return true
end

------------------------
--  > PlayerNoClip <  --
------------------------
function GM:PlayerNoClip( ply )
    return ply:IsSpectator()
end
