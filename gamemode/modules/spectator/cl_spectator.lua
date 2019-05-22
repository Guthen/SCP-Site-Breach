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

--------------------
--  > HUDPaint <  --
--------------------
local canMouse = true
hook.Add( "HUDPaint", "SCPSiteBreach:SpectatorHUD", function()
    if not LocalPlayer():IsSpectator() then return end

    if canMouse and ( input.IsMouseDown( MOUSE_LEFT ) or input.IsMouseDown( MOUSE_RIGHT ) ) then
        if input.IsMouseDown( MOUSE_LEFT ) then
            net.Start( "SCPSiteBreach:ChangeSpectatorTarget" )
                net.WriteBool( true )
            net.SendToServer()
        elseif input.IsMouseDown( MOUSE_RIGHT ) then
            net.Start( "SCPSiteBreach:ChangeSpectatorTarget" )
                net.WriteBool( false )
            net.SendToServer()
        end
        canMouse = false
        timer.Simple( .5, function() canMouse = true end )
    end

    local id = LocalPlayer():GetNWInt( "SCPSiteBreach:SpectatorTarget", 1 )
    local ent = Entity( id )

    draw.SimpleTextOutlined( "You are spectating :", "SCPSiteBreach:Font35", ScrW()/2, ScrH()/1.1, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( ent:Name(), "SCPSiteBreach:Font30", ScrW()/2, ScrH()/1.05, team.GetColor( ent:Team() ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color( 0, 0, 0 ) )
end )
