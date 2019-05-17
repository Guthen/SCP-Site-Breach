-----------------------------
--  > SCP - Site Breach <  --
--     > sh_debug.lua <    --
-----------------------------

concommand.Add( "scpsb_getmodels", function()
    local fol = "models/player/"
    local mdls, folders = file.Find( fol .. "*", "GAME" )

    for _, v in pairs( folders ) do
        print( "Models folders : ".. fol .. v )
    end
    for _, v in pairs( mdls ) do
        print( "    Model : ".. fol .. v )
    end
end )

concommand.Add( "scpsb_cleanup", function( ply )
    if ply:IsSuperAdmin() then game.CleanUpMap() end
end )
