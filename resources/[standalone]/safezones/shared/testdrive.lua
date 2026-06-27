function KOJA.Shared.getZoneConfigById(zoneId)
    if zoneId == nil then return nil end
    local id = tostring(zoneId):match('^%s*(.-)%s*$')
    if not id or id == '' then return nil end
    for _, z in ipairs(Config.Zones or {}) do
        if z.id and tostring(z.id) == id then
            return z
        end
    end
    return nil
end

local function vec3From(v)
    if not v then return nil end
    if type(v) == 'vector3' then return v end
    if type(v) == 'table' and v.x and v.y and v.z then
        return vector3(v.x + 0.0, v.y + 0.0, v.z + 0.0)
    end
    return nil
end

function KOJA.Shared.resolveTestDriveSettings(zoneId)
    local td = Config.TestDrive
    if not td or not td.Enabled then return nil end
    local z = KOJA.Shared.getZoneConfigById(zoneId)
    local ov = z and type(z.testDrive) == 'table' and z.testDrive or nil

    local coords = vec3From(ov and ov.coords) or vec3From(td.coords)
    local heading = (ov and tonumber(ov.heading)) or tonumber(td.heading)
    if heading == nil and z and z.coords then
        heading = z.coords.w
    end
    heading = (heading and heading + 0.0) or 0.0

    if not coords and td.SpawnOffset and z and z.coords then
        local c, off = z.coords, td.SpawnOffset
        coords = vector3(c.x + off.x, c.y + off.y, c.z + off.z)
        heading = (c.w or 0.0) + (off.w or 0.0)
    end

    if not coords then return nil end

    local secondslimit = (ov and (tonumber(ov.secondslimit) or tonumber(ov.seconds)))
        or tonumber(td.secondslimit) or tonumber(td.SecondsLimit) or 90

    local price = (ov and tonumber(ov.price)) or tonumber(td.price) or 0

    local cancelKey = (ov and (tonumber(ov.cancelKey) or tonumber(ov.cancelControl)))
        or tonumber(td.cancelKey) or tonumber(td.CancelControl) or 73

    return {
        coords = coords,
        heading = heading,
        secondslimit = math.max(1, math.floor(secondslimit)),
        price = math.max(0, math.floor(price)),
        cancelKey = math.floor(cancelKey),
    }
end
