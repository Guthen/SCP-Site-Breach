-----------------------------
--  > SCP - Site Breach <  --
--   > sv_keycard.lua <    --
-----------------------------

--  > Gamemode Hooks <  --

function GM:PlayerUse( ply, ent )
    if ply:IsSpectator() then return false end

    if SCPSiteBreach.keycardAvailableClass[ ent:GetClass() ] then -- it's an keycard available class
        local entLVL = ent:GetNWInt( "SCPSiteBreach:LVL", 0 )
        if not entLVL or entLVL == 0 then return true end -- no LVL :(

        local plyLVL = ply:GetActiveWeapon().SCPSiteBreachLVL
        if not plyLVL then
            ply:EmitSound( "guthen_scp/interact/KeycardUse2.ogg" )
            ply:SetBottomMessage( "You don't have any keycard to pass !" )
            return false  -- player don't have LVL weapon
        elseif plyLVL < entLVL then
            ply:EmitSound( "guthen_scp/interact/KeycardUse2.ogg" )
            ply:SetBottomMessage( "You need a keycard LVL " .. entLVL .. " to open the doors !" )
            return false -- player have keycard but not the required LVL
        end

        ply:EmitSound( "guthen_scp/interact/KeycardUse1.ogg" )
        ply:SetBottomMessage( "The doors are opening !" )
        return true -- good, player passed all conditions
    end

    return true
end
