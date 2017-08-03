local status = {}
local discordrelay = discordrelay

function status.Handle(input,previous,future)
    if input.author.bot ~= true and discordrelay.util.startsWith("status", input.content) then
        local embeds = {}
        local amount = player.GetCount()
        local cache = discordrelay.AvatarCache -- todo check if not nil
        for i,ply in pairs(player.GetAll()) do
            local commid = util.SteamIDTo64(ply:SteamID()) -- move to player meta?
            embeds[i] = {
                ["author"] = {
                    ["name"] = ply:Nick(),["icon_url"] = cache[commid],
                    ["url"] = "http://steamcommunity.com/profiles/" .. commid
                },
                ["color"] = (ply:IsAFK() ~= nil and ply:IsAFK()) and 0xffff00 or 0x00b300
            }
        end
        if amount > 0 then
            discordrelay.ExecuteWebhook(discordrelay.webhookid, discordrelay.webhooktoken, {
                ["username"] = "Server status:",
                ["avatar_url"] = discordrelay.avatar,
                ["content"] = "**Hostname:** "..GetHostName().."\n**Uptime:** "..string.FormattedTime(SysTime()/3600,"%02i:%02i:%02i").."\n**Map:** `"..game.GetMap().."`\n**Players:** "..amount.."/"..game.MaxPlayers(),
                ["embeds"] = embeds
        })
        else
            discordrelay.ExecuteWebhook(discordrelay.webhookid, discordrelay.webhooktoken, {
                ["username"] = discordrelay.username,
                ["avatar_url"] = discordrelay.avatar,
                ["embeds"] = {
                    [1] = {
                        ["title"] = "Server status:",
                        ["description"] = "No Players are currently on the Server...",
                        ["type"] = "rich",
                        ["color"] = 0x5a5a5a
                    }
                }
            })
        end
    end
end

function status.Remove()
    if discordrelay.modules.status then
        discordrelay.modules.status = nil
    end
end

return status
