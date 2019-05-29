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
    if LocalPlayer():Team() == TEAM_UNASSIGNED then return end
    local s = 500
    local _team = LocalPlayer():Team()
    local _teamColor = team.GetColor( _team )
    local _desc = SCPSiteBreach.GetTeam( _team ).description
          if _desc and isstring( _desc ) then
              _desc = string.Explode( ". ", _desc )
          else
              _desc =
                {
                    "Team's description here.",
                    "Put the value description = 'your desc' in your team's code.",
                    "See example here : 'https://github.com/Guthen/SCP-Site-Breach/blob/master/gamemode/modules/team/sh_team.lua'.",
                }
          end

    surface.PlaySound( "guthen_scp/horror/Horror" .. math.random( 1, 3 ) .. ".ogg" )

    hook.Add( "HUDPaint", "SCPSiteBreach:TeamHUD", function()
        s = Lerp( FrameTime()*.8, s, -1 )

        _teamColor.a = s

        draw.SimpleTextOutlined( "You play as :", "SCPSiteBreach:Font30", ScrW()/2, ScrH()/4, Color( 255, 255, 255, s ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color( 0, 0, 0, s ) )
        draw.SimpleTextOutlined( team.GetName( _team ), "SCPSiteBreach:Font60", ScrW()/2, ScrH()/4+40, _teamColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color( 0, 0, 0, s ) )
        for k, v in pairs( _desc ) do
            draw.SimpleTextOutlined( v, "SCPSiteBreach:Font25", ScrW()/2, ScrH()/4+85 + 30*k, Color( 255, 255, 255, s ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color( 0, 0, 0, s ) )
        end

        if s <= 0 then hook.Remove( "HUDPaint", "SCPSiteBreach:TeamHUD" ) end
    end )
end )
