-----------------------------
--  > SCP - Site Breach <  --
--   > sh_players.lua <    --
-----------------------------

local Player = FindMetaTable( "Player" )

--  > Player Functions <  --

function Player:ChangeTeam( _team )
    local teamTab = SCPSiteBreach.GetTeam( _team )
    if not teamTab then return false end

    self:SetModel( table.Random( teamTab.models ) ) -- model

    self:SetWalkSpeed( teamTab.walkSpd or 150 ) -- walk speed
    self:SetRunSpeed( teamTab.runSpd or 250 ) -- run speed

    self:SetHealth( teamTab.health or 100 ) -- health
    self:SetMaxHealth( teamTab.health or 100 ) -- max health
    self:SetArmor( teamTab.armor or 100 ) -- armor

    self:SetTeam( _team )

    self:StripWeapons()
    for _, v in pairs( teamTab.weapons ) do -- weapons
        if weapons.Get( v ).AdminOnly and not self:IsAdmin() then continue end
        self:Give( v )
    end

    return true
end
