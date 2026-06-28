-- ===========================================================================
-- RME Postals - client
-- Draws postal numbers on the pause map.
--
-- The pause map can be panned and zoomed, so a hardcoded world->screen
-- transform does not work. Instead we self-calibrate every frame:
--   * GetPauseMapPointerWorldPosition() = world coords under the cursor
--   * GetControlNormal(0, 239/240)      = cursor position in screen space (0-1)
-- Pairing those two as the cursor moves lets us solve the (affine) mapping
--   screenX = ax * worldX + bx
--   screenY = ay * worldY + by
-- which stays correct no matter how the player zooms or pans.
-- ===========================================================================

local postals = Config.Postals
local style   = Config.Style
local bounds  = Config.Bounds
local calCfg  = Config.Calibration

-- Solved transform components.
local ax, bx, ay, by = nil, nil, nil, nil
local haveScaleX, haveScaleY = false, false

-- Recent { cx, cy, wx, wy } cursor samples (most-recent first).
local samples = {}
local lastPointer = nil -- last valid pointer world pos (gates drawing to map tab)

local function resetCalibration()
	samples = {}
	ax, bx, ay, by = nil, nil, nil, nil
	haveScaleX, haveScaleY = false, false
	lastPointer = nil
end

-- Pull one cursor<->world sample and (re)solve the transform.
local function sampleAndSolve()
	local w = GetPauseMapPointerWorldPosition()
	if not w then return end
	local wx, wy = w.x, w.y

	-- On non-map pause tabs the pointer reads ~0,0 -> treat as invalid.
	if (wx > -1.0 and wx < 1.0) and (wy > -1.0 and wy < 1.0) then
		lastPointer = nil
		return
	end
	lastPointer = w

	local cx = GetControlNormal(0, 239) -- cursor X (0-1)
	local cy = GetControlNormal(0, 240) -- cursor Y (0-1)

	table.insert(samples, 1, { cx = cx, cy = cy, wx = wx, wy = wy })
	while #samples > calCfg.sampleCount do
		table.remove(samples)
	end

	-- Scale from the most-separated recent samples; offset from newest sample
	-- (so panning keeps the mapping anchored to the current view).
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

	-- The pause map is an orthographic top-down view, so X and Y share the same
	-- world scale (only the sign and screen aspect ratio differ). If we have one
	-- axis but not the other yet, derive the missing one so codes can show
	-- immediately after the first bit of cursor movement.
	local aspect = GetAspectRatio(false)
	if aspect <= 0.0 then aspect = 16.0 / 9.0 end
	if haveScaleX and not haveScaleY then
		ay = -ax * aspect
	elseif haveScaleY and not haveScaleX then
		ax = -ay / aspect
	end

	if ax and newest then bx = newest.cx - ax * newest.wx end
	if ay and newest then by = newest.cy - ay * newest.wy end
end

local function drawPostal(sx, sy, txt)
	SetTextFont(style.font)
	SetTextScale(0.0, style.scale)
	SetTextColour(style.r, style.g, style.b, style.a)
	SetTextCentre(true)
	if style.outline then SetTextOutline() end
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawText(sx, sy)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsPauseMenuActive() then
			sampleAndSolve()

			if lastPointer and ax and bx and ay and by then
				for i = 1, #postals do
					local p = postals[i]
					local sx = ax * p.x + bx
					local sy = ay * p.y + by
					if sx > bounds.minX and sx < bounds.maxX
						and sy > bounds.minY and sy < bounds.maxY then
						drawPostal(sx, sy, p.code)
					end
				end
			end

			if Config.Dev then
				SetTextFont(0)
				SetTextScale(0.0, 0.4)
				SetTextColour(255, 220, 0, 255)
				SetTextOutline()
				SetTextEntry("STRING")
				local dbg = string.format(
					"postals: samples=%d ax=%s bx=%s ay=%s by=%s",
					#samples,
					ax and string.format("%.5f", ax) or "-",
					bx and string.format("%.4f", bx) or "-",
					ay and string.format("%.5f", ay) or "-",
					by and string.format("%.4f", by) or "-")
				AddTextComponentString(dbg)
				DrawText(0.02, 0.02)
			end
		else
			if #samples > 0 then resetCalibration() end
			Citizen.Wait(150)
		end
	end
end)

RegisterCommand("postaldev", function()
	Config.Dev = not Config.Dev
	print("[rme-postals] dev readout: " .. tostring(Config.Dev))
end, false)
