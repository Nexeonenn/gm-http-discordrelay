local rcon = {}
local discordrelay = discordrelay

function rcon.Handle(input,previous,future)
	if discordrelay.util.startsWith(input.content, "rcon") then
		discordrelay.util.IsAdmin(input.author.id, function(access)
			if access then
				game.ConsoleCommand(string.sub(input.content, 6, #input.content) .. "\n")
				discordrelay.ExecuteWebhook(discordrelay.webhookid, discordrelay.webhooktoken, {
					["embeds"] = {
						[1] = {
						["description"] = ":ok_hand:",
							["type"] = "rich",
							["color"] = 0x182687
						}
					}
				})

			else
				discordrelay.ExecuteWebhook(discordrelay.webhookid, discordrelay.webhooktoken, {
					["embeds"] = {
						[1] = {
							["description"] = ":no_entry: **Access denied!**",
							["type"] = "rich",
							["color"] = 0x700000
						}
					}
				})
			end
		end)
	end
end

function rcon.Remove()
	if discordrelay.modules.rcon then
		discordrelay.modules.rcon = nil
	end
end

return rcon