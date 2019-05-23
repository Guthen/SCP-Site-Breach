-----------------------------
--  > SCP - Site Breach <  --
--     > shared.lua <      --
-----------------------------

--  > Global Table Definition <  --
SCPSiteBreach = {}
SCPSiteBreach.Name = "SCP - Site Breach"
SCPSiteBreach.Author = "Guthen"
SCPSiteBreach.Website = "https://discord.gg/P9ECj4W"

--  > Gamemode Definition <  --
GM.Name     =   SCPSiteBreach.Name
GM.Author   =   SCPSiteBreach.Author
GM.Website  =   SCPSiteBreach.Website

--  > Some Functions <  --

function table.Shuffle( _table )
    if not _table or not istable( _table ) then return {} end
    if #_table == 0 then return _table end

    local _t = {}
    for k, v in pairs( _table ) do
        _t[k] = v
    end

    local t = {}
    for i = 1, #_table do
        local k = math.random( #_t )

        table.insert( t, _t[k] )
        table.remove( _t, k )
    end

    return t
end
