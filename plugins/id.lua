local function usernameinfo (user)
    if user.username then
        return '@'..user.username
    end
    if user.print_name then
        return user.print_name
    end
    local text = ''
    if user.first_name then
        text = user.last_name..' '
    end
    if user.lastname then
        text = text..user.last_name
    end
    return text
end

local function whoisname(cb_extra, success, result)
    chat_type = cb_extra.chat_type
    chat_id = cb_extra.chat_id
    user_id = result.peer_id
    user_username = result.username
    if chat_type == 'chat' then
        send_msg('chat#id'..chat_id, '👤 '..lang_text(chat_id, 'user')..' @'..user_username..' ('..user_id..')', ok_cb, false)
    elseif chat_type == 'channel' then
        send_msg('channel#id'..chat_id, '👤 '..lang_text(chat_id, 'user')..' @'..user_username..' ('..user_id..')', ok_cb, false)
    end
end

local function whoisid(cb_extra, success, result)
    chat_id = cb_extra.chat_id
    user_id = cb_extra.user_id
    if cb_extra.chat_type == 'chat' then
        send_msg('chat#id'..chat_id, '👤 '..lang_text(chat_id, 'user')..' @'..result.username..' ('..user_id..')', ok_cb, false)
    elseif cb_extra.chat_type == 'channel' then
        send_msg('channel#id'..chat_id, '👤 '..lang_text(chat_id, 'user')..' @'..result.username..' ('..user_id..')', ok_cb, false)
    end
end

local function channelUserIDs (extra, success, result)
    local receiver = extra.receiver
    print('Result')
    vardump(result)
    local text = ''
    for k,user in ipairs(result) do
        local id = user.peer_id
        local username = usernameinfo (user)
        text = text..("%s - %s\n"):format(username, id)
    end
    send_large_msg(receiver, text)
end

local function get_id_who(extra, success, result)
    result = backward_msg_format(result)
    local msg = result
    local chat = msg.to.id
    local user = msg.from.id
    if msg.to.type == 'chat' then
        send_msg('chat#id'..msg.to.id, '🆔 '..lang_text(chat, 'user')..' ID: '..msg.from.id, ok_cb, false)
    elseif msg.to.type == 'channel' then
        send_msg('channel#id'..msg.to.id, '🆔 '..lang_text(chat, 'user')..' ID: '..msg.from.id, ok_cb, false)
    end
end

local function returnids (extra, success, result)
    local receiver = extra.receiver
    local chatname = result.print_name
    local id = result.peer_id
    local text = ('ID for chat %s (%s):\n'):format(chatname, id)
    for k,user in ipairs(result.members) do
        local username = usernameinfo(user)
        local id = user.peer_id
        local userinfo = ("%s - %s\n"):format(username, id)
        text = text .. userinfo
    end
    send_large_msg(receiver, text)
end

local function run(msg, matches)
    local receiver = get_receiver(msg)
    local chat = msg.to.id
    -- Id of the user and info about group / channel
    if matches[1] == "!id" then
        if permissions(msg.from.id, msg.to.id, "id") then
            if msg.to.type == 'channel' then
                send_msg(msg.to.peer_id, '🔠 '..lang_text(chat, 'supergroupName')..': '..msg.to.print_name:gsub("_", " ")..'\n👥 '..lang_text(chat, 'supergroup')..' ID: '..msg.to.id..'\n🆔 '..lang_text(chat, 'user')..' ID: '..msg.from.id, ok_cb, false)
            elseif msg.to.type == 'chat' then
                send_msg(msg.to.peer_id, '🔠 '..lang_text(chat, 'chatName')..': '..msg.to.print_name:gsub("_", " ")..'\n👥 '..lang_text(chat, 'chat')..' ID: '..msg.to.id..'\n🆔 '..lang_text(chat, 'user')..' ID: '..msg.from.id, ok_cb, false)
            end
        end
    elseif matches[1] == 'whois' then
        if permissions(msg.from.id, msg.to.id, "whois") then
            chat_type = msg.to.type
            chat_id = msg.to.id
            if msg.reply_id then
                get_message(msg.reply_id, get_id_who, {receiver=get_receiver(msg)})
                return
            end
            if is_id(matches[2]) then
                print(1)
                user_info('user#id'..matches[2], whoisid, {chat_type=chat_type, chat_id=chat_id, user_id=matches[2]})
                return
            else
                local member = string.gsub(matches[2], '@', '')
                resolve_username(member, whoisname, {chat_id=chat_id, member=member, chat_type=chat_type})
                return
            end
        else
            return '🚫 '..lang_text(msg.to.id, 'require_mod')
        end
    elseif matches[1] == 'chat' or matches[1] == 'channel' then
        if permissions(msg.from.id, msg.to.id, "whois") then
            local type = matches[1]
            local chanId = matches[2]
            -- !ids? (chat) (%d+)
            if chanId then
                local chan = ("%s#id%s"):format(type, chanId)
                if type == 'chat' then
                    chat_info(chan, returnids, {receiver=receiver})
                else
                    channel_get_users(chan, channelUserIDs, {receiver=receiver})
                end
            else
                -- !id chat/channel
                local chan = ("%s#id%s"):format(msg.to.type, msg.to.id)
                if msg.to.type == 'channel' then
                    channel_get_users(chan, channelUserIDs, {receiver=receiver})
                end
                if msg.to.type == 'chat' then
                    chat_info(chan, returnids, {receiver=receiver})
                end
            end
        else
            return '🚫 '..lang_text(msg.to.id, 'require_mod')
        end
    end
end

return {
  patterns = {
    "^!(whois)$",
    "^!id$",
    "^!ids? (chat)$",
    "^!ids? (channel)$",
    "^!(whois) (.*)$"
  },
  run = run
}
