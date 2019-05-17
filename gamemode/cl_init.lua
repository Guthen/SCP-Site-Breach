-----------------------------
--  > SCP - Site Breach <  --
--     > cl_init.lua <     --
-----------------------------

--  > Core Include <  --
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
        include( _fol )
        print( "SCPSiteBreach -     Load shared : " .. _fol )
    end

    --  > Client <  --
    local _cl = file.Find( _folName .. "cl_*.lua", "LUA" )
    for _, cl in pairs( _cl ) do
        local _fol = _folName .. cl
        include( _fol )
        print( "SCPSiteBreach -     Load client : " .. _fol )
    end
end
print( "SCPSiteBreach - Stop loading modules\n" )

hook.Call( "SCPSiteBreach:PostLoadModules" )
