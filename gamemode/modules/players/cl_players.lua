-----------------------------
--  > SCP - Site Breach <  --
--   > cl_players.lua <    --
-----------------------------

--  > Gamemode Hooks <  --

net.Receive( "SCPSiteBreach:SetBottomMessage", function()
    local msg = net.ReadString()
    hook.Add( "HUDPaint", "SCPSiteBreach:BottomMessage", function()

        draw.SimpleText( msg, "ChatFont", ScrW()/2, ScrH()/1.2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER )

    end )
    timer.Simple( 3, function()
        hook.Remove( "HUDPaint", "SCPSiteBreach:BottomMessage" )
    end )
end )
