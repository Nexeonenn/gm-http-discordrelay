local messages = {}
local discordrelay = discordrelay

util.AddNetworkString("DiscordMessage")

function messages.Handle(input)
    if input.author.bot ~= true then
        local ret = input.content
        if input.mentions then
            for k,mention in pairs(input.mentions) do
                ret = string.gsub(input.content, "<@!?"..mention.id..">", "@"..mention.username)
            end
        end
        if input.attachments then
            for _,attachments in pairs(input.attachments) do
                ret = ret .. "\n" .. attachments.url
            end
        end
        net.Start( "DiscordMessage" )
            net.WriteString(string.sub(input.author.username,1,14))
            net.WriteString(string.sub(ret,1,400))
        net.Broadcast()
    end
end

return messages