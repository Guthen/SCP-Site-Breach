-----------------------------
--  > SCP - Site Breach <  --
--    > cl_round.lua <     --
-----------------------------

--	> RoundStartHUD <  --
net.Receive( "SCPSiteBreach:RoundStartHUD", function()
	hook.Remove( "HUDPaint", "SCPSiteBreach:RoundEndHUD" )
	hook.Remove( "HUDPaint", "SCPSiteBreach:TeamHUD" )

	local w, h = ScrW(), ScrH()
	local ang = 360
	local isReady = false
	hook.Add( "HUDPaint", "SCPSiteBreach:RoundStartHUD", function()
		if player.GetCount() >= math.ceil( game.MaxPlayers()/3 ) then
			if ang > 0 then
				ang = ang - .25
			elseif not isReady then
				net.Start( "SCPSiteBreach:RoundStartReady" )
				net.SendToServer()

				isReady = true
			end
		else
			if ang < 360 then ang = ang + .25 end
		end
		if LocalPlayer():Alive() then hook.Remove( "HUDPaint", "SCPSiteBreach:RoundStartHUD" ) end
		draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10 ) ) -- background

		--draw.RoundedBox( 0, w/2 - 125, h/2 - 125, 250, 250, Color( 160, 160, 160 ) ) -- outline
		surface.SetDrawColor( Color( 160, 160, 160 ) )
		draw.NoTexture()
		SCPSiteBreach.drawCircle( w/2, h/2, 360, 136, 2 ) -- circle outline

		surface.SetDrawColor( Color( 255, 255, 255 ) )
		SCPSiteBreach.drawCircle( w/2, h/2, ang, 136, 2 ) -- circle

		surface.SetDrawColor( Color( 10, 10, 10 ) )
		SCPSiteBreach.drawCircle( w/2, h/2, 360, 126, 2 )
		--draw.RoundedBox( 4, w/2 - 120, h/2 - 120, 240, 240, Color( 10, 10, 10 ) ) -- inside

		--draw.RoundedBox( 0, w/2 - 125, h/2 - 176, 250, 51, Color( 10, 10, 10 ) ) -- top
		--draw.RoundedBox( 0, w/2 - 125, h/2 + 125, 250, 54, Color( 10, 10, 10 ) ) -- bottom
		--draw.RoundedBox( 0, w/2 - 176, h/2 - 125, 51, 250, Color( 10, 10, 10 ) ) -- left
		--draw.RoundedBox( 0, w/2 + 125, h/2 - 125, 51, 250, Color( 10, 10, 10 ) ) -- right

		draw.SimpleText( player.GetCount(), "SCPSiteBreach:Font60", w/2, h/2-5, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( "Connected", "SCPSiteBreach:Font22", w/2, h/2+30, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end )
end )


--	> RoundEndHUD <  --
net.Receive( "SCPSiteBreach:RoundEndHUD", function()
	hook.Remove( "HUDPaint", "SCPSiteBreach:RoundStartHUD" )
	hook.Remove( "HUDPaint", "SCPSiteBreach:TeamHUD" )

	local w, h = ScrW(), ScrH()
	local alpha = 0

	local blackAlpha = 0
	local blackOn = false
	timer.Simple( 7, function() blackOn = true end )

	local teamWin = net.ReadString()
		  teamWin = string.len( teamWin ) > 1 and teamWin or "Unknow"

	local totalDeath = net.ReadInt( 16 ) or 0
	local scpKill = net.ReadInt( 16 ) or 0

	hook.Add( "HUDPaint", "SCPSiteBreach:RoundEndHUD", function()
		alpha = Lerp( FrameTime()*5, alpha, 255 )

		if blackOn then
			blackAlpha = Lerp( FrameTime()*3, blackAlpha, 275 )
		end

		draw.SimpleTextOutlined( "ROUND STATISTICS :", "SCPSiteBreach:Font50", w/2, h/3-15, Color( 255, 255, 255, alpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color( 10, 10, 10, alpha ) )
		draw.SimpleTextOutlined( teamWin .. " has win this round !", "SCPSiteBreach:Font30", w/2, h/3+30, Color( 255, 255, 255, alpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color( 10, 10, 10, alpha ) )
		draw.SimpleTextOutlined( totalDeath .. " people died during this round.", "SCPSiteBreach:Font25", w/2, h/3+60, Color( 255, 255, 255, alpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color( 10, 10, 10, alpha ) )
		draw.SimpleTextOutlined( "SCPs killed " .. scpKill .. " people.", "SCPSiteBreach:Font25", w/2, h/3+90, Color( 255, 255, 255, alpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color( 10, 10, 10, alpha ) )
		--draw.SimpleTextOutlined( "2 SCPs have been destroyed or contained", "SCPSiteBreach:Font25", w/2, h/3+120, Color( 255, 255, 255, alpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color( 10, 10, 10, alpha ) )

		draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10, blackAlpha ) )
	end )
end )
