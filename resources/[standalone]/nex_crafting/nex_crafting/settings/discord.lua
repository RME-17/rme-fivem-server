Config = {}

Config.Discord = {
    botToken = "",
    serverId = "",
    adminRoles = {
        "1234567890123456789",
        "1234567890123456789",
    },
}

function Config.GetDiscordSettings()
    return Config.Discord
end

function Config.HasAdminRole(discordRoles)
    if not discordRoles or type(discordRoles) ~= "table" then
        return false
    end

    for _, roleId in ipairs(Config.Discord.adminRoles) do
        for _, playerRole in ipairs(discordRoles) do
            if tostring(roleId) == tostring(playerRole) then
                return true
            end
        end
    end

    return false
end

exports('GetDiscordSettings', Config.GetDiscordSettings)
exports('HasAdminRole', Config.HasAdminRole)
