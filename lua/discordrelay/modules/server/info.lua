local info = {}
local discordrelay = discordrelay

function info.Handle(input, previous, future)
    if input.author.bot ~= true and discordrelay.util.startsWith(input.content, "info") then
        local who = string.Trim(string.sub(input.content, 6, -1))
        if who == "" then
            discordrelay.ExecuteWebhook(discordrelay.webhookid, discordrelay.webhooktoken, {
                ["username"] = discordrelay.username,
                ["avatar_url"] = discordrelay.avatar,
                ["content"] = "```Shows info about a user.```\n<:poseparameter:289507359699632129> = ping\n:heartpulse: = health\n:clock: = time on server\n :first_place: = JRPG level\nhttps://cdn.discordapp.com/attachments/273575417401573377/375370730780622850/unknown.png",
            })
        else
            local ply
            for _,_ply in pairs(player.GetAll()) do
                if _ply:Nick():lower():find(who, 1, true) then
                    ply = _ply
                    break
                end
            end
            if ply and IsValid(ply) then
                local cache = discordrelay.AvatarCache
                local commid = util.SteamIDTo64(ply:SteamID())
                local emojis = {
                    ["🚗"] = ply:InVehicle(),
                    ["⌨"] = ply:IsTyping(),
                    ["⏲"] = ply:IsTimingOut(),
                    ["❄"] = ply:IsFrozen(),
                    ["🤖"] = ply:IsBot(),
                    ["🛡"] = ply:IsAdmin(),
                    ["👍"] = ply:IsPlayingTaunt(),
                    ["⛩"] = ply:HasGodMode(),
                    ["💡"] = ply:FlashlightIsOn(),
                    ["💀"] = not ply:Alive(),
                    ["🕴"] = ply:GetMoveType() == MOVETYPE_NOCLIP,
                    ["💤"] = ply:IsAFK(),
                    --[""] = ply:IsMuted(),
                    --[""] = ply:IsSpeaking(),
                }
                local emojistr = ""
                for emoji,yes in pairs(emojis) do
                    if yes then
                        emojistr = " " .. emojistr .. emoji
                    end
                end
                discordrelay.ExecuteWebhook(discordrelay.webhookid, discordrelay.webhooktoken, {
                    ["username"] = discordrelay.username,
                    ["avatar_url"] = discordrelay.avatar,
                    ["embeds"] = {
                        [1] = {
                            ["author"] = {
                                ["name"] = string.gsub(ply:Nick(), "<.->","") .. emojistr,
                                ["icon_url"] = cache[commid] or "https://i.imgur.com/ovW4MBM.png",
                                ["url"] = "http://steamcommunity.com/profiles/" .. commid
                            },
                            ["title"] = "",
                        -- ["description"] = ,
                            ["fields"] = {
                            [1] = {
                                ["name"] = "<:poseparameter:289507359699632129>",
                                ["value"] = ply:Ping(),
                                ["inline"] = true

                            },
                            [2] = {
                                ["name"] = ":heartpulse:",
                                ["value"] = ply:Health(),
                                ["inline"] = true
                            },
                            [3] = {
                                ["name"] = ":clock:",
                                ["value"] = string.NiceTime(ply:TimeConnected()),
                                ["inline"] = true
                            },
                            [4] = {
                                ["name"] = ":first_place:",
                                ["value"] = (ply.GetLevel and ply:GetLevel() or 0),
                                ["inline"] = true

                            },
                        },
                            ["type"] = "rich",
                            ["color"] = (ply:IsAFK() and 0xffff00 or (ply:Alive() and 0x00b300 or 0xb30000))
                        }
                    }
                })
            else
                discordrelay.ExecuteWebhook(discordrelay.webhookid, discordrelay.webhooktoken, {
                    ["username"] = discordrelay.username,
                    ["avatar_url"] = discordrelay.avatar,
                    ["embeds"] = {
                        [1] = {
                        ["description"] = ":interrobang: Couldn't find that User",
                            ["type"] = "rich",
                            ["color"] = 0xb30000
                        }
                    }
                })
            end
        end
    end
end

function info.Remove()
    if discordrelay.modules.info then
        discordrelay.modules.info = nil
    end
end

--return info
return info