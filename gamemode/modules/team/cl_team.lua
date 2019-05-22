-----------------------------
--  > SCP - Site Breach <  --
--     > cl_team.lua <     --
-----------------------------

--  > Check <  --
if not SCPSiteBreach then
    return
end

--  > HUD <  --
net.Receive( "SCPSiteBreach:TeamHUD", function()
    if not LocalPlayer():IsValid() then return end
    local s = 500
    local _team = LocalPlayer():Team()
    local _teamColor = team.GetColor( _team )

    surface.PlaySound( "guthen_scp/horror/Horror" .. math.random( 1, 3 ) .. ".ogg" )

    hook.Add( "HUDPaint", "SCPSiteBreach:TeamHUD", function()
        s = Lerp( FrameTime()*.8, s, -1 )

        _teamColor.a = s

        draw.SimpleTextOutlined( "You play as :", "SCPSiteBreach:Font30", ScrW()/2, ScrH()/4, Color( 255, 255, 255, s ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color( 0, 0, 0, s ) )
        draw.SimpleTextOutlined( team.GetName( _team ), "SCPSiteBreach:Font50", ScrW()/2, ScrH()/4+40, _teamColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color( 0, 0, 0, s ) )

        if s <= 0 then hook.Remove( "HUDPaint", "SCPSiteBreach:TeamHUD" ) end
    end )
end )
