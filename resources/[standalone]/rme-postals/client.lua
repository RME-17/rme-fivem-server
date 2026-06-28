-- ===========================================================================
-- RME Postals - client  (DIAGNOSTIC BUILD)
--
-- This build is instrumented to find out WHY nothing is showing:
--   1) Prints to console (F8) when the resource starts  -> confirms it loaded
--   2) /postalping command -> chat + console print       -> confirms it runs
--   3) Always draws a bright "RME POSTAL TEST" in the middle of the pause map
--      -> confirms whether DrawText can render over the pause menu at all
--   4) Always shows a calibration readout on the map
--
-- Once we know which of these appear, we lock in the real fix.
-- ===========================================================================

print("[rme-postals] client started - resource is loaded")

local postals = Config.Postals
local style   = Config.Style
local bounds  = Config.Bounds
local calCfg  = Config.Calibration

local ax, bx, ay, by = nil, nil, nil, nil
local haveScaleX, haveScaleY = false, false
local samples = {}
local lastPointer = nil

local function resetCalibration()
	samples = {}
	ax, bx, ay, by = nil, nil, nil, nil
	haveScaleX, haveScaleY = false, false
	lastPointer = nil
end

local function sampleAndSolve()
	local w = GetPauseMapPointerWorldPosition()
	if not w then return end
	local wx, wy = w.x, w.y
	if (wx > -1.0 and wx < 1.0) and (wy > -1.0 and wy < 1.0) then
		lastPointer = nil
		return
	end
	lastPointer = w

	local cx = GetControlNormal(0, 239)
	local cy = GetControlNormal(0, 240)

	table.insert(samples, 1, { cx = cx, cy = cy, wx = wx, wy = wy })
	while #samples > calCfg.sampleCount do table.remove(samples) end

	local loX, hiX, loY, hiY
	for _, s in ipairs(samples) do
		if not loX or s.wx < loX.wx then loX = s end
		if not hiX or s.wx > hiX.wx then hiX = s end
		if not loY or s.wy < loY.wy then loY = s end
		if not hiY or s.wy > hiY.wy then hiY = s end
	end
	local newest = samples[1]

	if loX and hiX and (hiX.wx - loX.wx) > calCfg.minSpread then
		ax = (hiX.cx - loX.cx) / (hiX.wx - loX.wx)
		haveScaleX = true
	end
	if loY and hiY and (hiY.wy - loY.wy) > calCfg.minSpread then
		ay = (hiY.cy - loY.cy) / (hiY.wy - loY.wy)
		haveScaleY = true
	end

	local aspect = GetAspectRatio(false)
	if aspect <= 0.0 then aspect = 16.0 / 9.0 end
	if haveScaleX and not haveScaleY then ay = -ax * aspect
	elseif haveScaleY and not haveScaleX then ax = -ay / aspect end

	if ax and newest then bx = newest.cx - ax * newest.wx end
	if ay and newest then by = newest.cy - ay * newest.wy end
end

local function drawTextAt(sx, sy, txt, scale, r, g, b, a)
	SetTextFont(0)
	SetTextScale(0.0, scale)
	SetTextColour(r, g, b, a)
	SetTextCentre(true)
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawText(sx, sy)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsPauseMenuActive() then
			sampleAndSolve()

			-- (3) ALWAYS-ON TEST TEXT - if you can read this on the map,
			-- DrawText works over the pause menu and the problem is calibration.
			drawTextAt(0.5, 0.5, "RME POSTAL TEST", 0.9, 255, 60, 60, 255)
			drawTextAt(0.5, 0.55, "if you see this, draw works", 0.45, 255, 255, 0, 255)

			-- (4) Calibration readout
			local dbg = string.format(
				"samples=%d  pointer=%s  ax=%s ay=%s",
				#samples,
				lastPointer and "OK" or "none",
				ax and string.format("%.5f", ax) or "-",
				ay and string.format("%.5f", ay) or "-")
			drawTextAt(0.5, 0.04, dbg, 0.4, 0, 255, 120, 255)

			-- Real postal draw (works once calibrated AND if draw renders)
			if lastPointer and ax and bx and ay and by then
				for i = 1, #postals do
					local p = postals[i]
					local sx = ax * p.x + bx
					local sy = ay * p.y + by
					if sx > bounds.minX and sx < bounds.maxX
						and sy > bounds.minY and sy < bounds.maxY then
						SetTextFont(style.font)
						SetTextScale(0.0, style.scale)
						SetTextColour(style.r, style.g, style.b, style.a)
						SetTextCentre(true)
						if style.outline then SetTextOutline() end
						SetTextEntry("STRING")
						AddTextComponentString(p.code)
						DrawText(sx, sy)
					end
				end
			end
		else
			if #samples > 0 then resetCalibration() end
			Citizen.Wait(150)
		end
	end
end)

RegisterCommand("postalping", function()
	print("[rme-postals] /postalping -> resource IS running")
	TriggerEvent("chat:addMessage", { args = { "^2[rme-postals]", "resource is running - draw test active on the map" } })
end, false)
