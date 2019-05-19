-----------------------------
--  > SCP - Site Breach <  --
--    > cl_round.lua <     --
-----------------------------

--	> RoundStartHUD <  --
net.Receive( "SCPSiteBreach:RoundStartHUD", function()
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

		draw.RoundedBox( 0, w/2 - 125, h/2 - 125, 250, 250, Color( 160, 160, 160 ) ) -- outline

		surface.SetDrawColor( Color( 255, 255, 255 ) )
		draw.NoTexture()
		SCPSiteBreach.drawCircle( w/2, h/2, ang, 176, 2 ) -- circle

		draw.RoundedBox( 4, w/2 - 120, h/2 - 120, 240, 240, Color( 10, 10, 10 ) ) -- inside

		draw.RoundedBox( 0, w/2 - 125, h/2 - 176, 250, 51, Color( 10, 10, 10 ) ) -- top
		draw.RoundedBox( 0, w/2 - 125, h/2 + 125, 250, 54, Color( 10, 10, 10 ) ) -- bottom
		draw.RoundedBox( 0, w/2 - 176, h/2 - 125, 51, 250, Color( 10, 10, 10 ) ) -- left
		draw.RoundedBox( 0, w/2 + 125, h/2 - 125, 51, 250, Color( 10, 10, 10 ) ) -- right


		draw.SimpleText( "Round Start", "ScoreboardDefaultTitle", w/2, h/2 - 35, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( player.GetCount() .. " / " .. game.MaxPlayers(), "ScoreboardDefaultTitle", w/2, h/2+15, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end )
end )
