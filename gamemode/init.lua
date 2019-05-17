-----------------------------
--  > SCP - Site Breach <  --
--      > init.lua <       --
-----------------------------

--  > Core Include <  --
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

include( "shared.lua" )

--  > DEFINE <  --
DEFINE_BASECLASS( "gamemode_base" )

--  > Load Modules <  --
hook.Call( "SCPSiteBreach:PreLoadModules" )

local folName = GM.FolderName .. "/gamemode/modules/"
local _, dirs = file.Find( folName .. "*", "LUA" )

print( "SCPSiteBreach - " .. os.date( "%d/%m/%Y - %H:%M:%S", os.time() ) .. "\n" )
print( "SCPSiteBreach - Start loading modules (" .. folName .. ")" )
for _, v in pairs( dirs ) do
    local _folName = folName .. v .. "/"

    --  > Shared <  --
    local _sh = file.Find( _folName .. "sh_*.lua", "LUA" )
    for _, sh in pairs( _sh ) do
        local _fol = _folName .. sh
        AddCSLuaFile( _fol )
        include( _fol )
        print( "SCPSiteBreach -     Load/Add shared : " .. _fol )
    end

    --  > Client <  --
    local _cl = file.Find( _folName .. "cl_*.lua", "LUA" )
    for _, cl in pairs( _cl ) do
        local _fol = _folName .. cl
        AddCSLuaFile( _fol)
        print( "SCPSiteBreach -     Add client : " .. _fol )
    end

    --  > Server <  --
    local _sv = file.Find( _folName .. "sv_*.lua", "LUA" )
    for _, sv in pairs( _sv ) do
        local _fol = _folName .. sv
        include( _fol )
        print( "SCPSiteBreach -     Load server : " .. _fol )
    end
end
print( "SCPSiteBreach - Stop loading modules\n" )

hook.Call( "SCPSiteBreach:PostLoadModules" )
