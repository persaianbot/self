f not is_sudo(msg) or is_admin1(msg) and is_realm(msg) then
		return "You cant create groups!"
	end
        group_name = matches[2]
        group_type = 'group'
        return create_group(msg)
    end

	--[[ Experimental
	if matches[1] == 'createsuper' and matches[2] then
	if not is_sudo(msg) or is_admin1(msg) and is_realm(msg) then
		return "You cant create groups!"
	end
        group_name = matches[2]
        group_type = 'super_group'
        return create_group(msg)
    end]]

    if matches[1] == 'createrealm' and matches[2] then
	if not is_sudo(msg) or not is_admin1(msg) and is_realm(msg) then
		return  "You cant create groups!"
	end
        group_name = matches[2]
        group_type = 'realm'
        return create_realm(msg)
    end

    local data = load_data(_config.moderation.data)
    local receiver = get_receiver(msg)
			if matches[1] == 'setabout' and matches[2] == 'group' and is_realm(msg) then
				local target = matches[3]
				local about = matches[4]
				return set_description(msg, data, target, about)
			end
			if matches[1] == 'setabout' and matches[2] == 'sgroup'and is_realm(msg) then
				local channel = 'channel#id'..matches[3]
				local about_text = matches[4]
				local data_cat = 'description'
				local target = matches[3]
				channel_set_about(channel, about_text, ok_cb, false)
				data[tostring(target)][data_cat] = about_text
				save_data(_config.moderation.data, data)
				return "Description has been set for ["..matches[2]..']'
			end
			if matches[1] == 'setrules' then
				rules = matches[3]
				local target = matches[2]
				return set_rules(msg, data, target)
			end
			if matches[1] == 'lock' then
				local target = matches[2]
				if matches[3] == 'name' then
					return lock_group_name(msg, data, target)
				end
				if matches[3] == 'member' then
					return lock_group_member(msg, data, target)
				end
				if matches[3] == 'photo' then
					return lock_group_photo(msg, data, target)
				end
				if matches[3] == 'flood' then
					return lock_group_flood(msg, data, target)
				end
				if matches[2] == 'arabic' then
					return lock_group_arabic(msg, data, target)
				end
				if matches[3] == 'links' then
					return lock_group_links(msg, data, target)
				end
				if matches[3] == 'spam' then

					return lock_group_spam(msg, data, target)
				end
				if matches[3] == 'rtl' then
					return unlock_group_rtl(msg, data, target)
				end
				if matches[3] == 'sticker' then
					return lock_group_sticker(msg, data, target)
				end
			end
			if matches[1] == 'unlock' then
				local target = matches[2]
				if matches[3] == 'name' then
					return unlock_group_name(msg, data, target)
				end
				if matches[3] == 'member' then
					return unlock_group_member(msg, data, target)
				end
				if matches[3] == 'photo' then
					return unlock_group_photo(msg, data, target)
				end
				if matches[3] == 'flood' then
					return unlock_group_flood(msg, data, target)
				end
				if matches[3] == 'arabic' then
					return unlock_group_arabic(msg, data, target)
				end
				if matches[3] == 'links' then
					return unlock_group_links(msg, data, target)
				end
				if matches[3] == 'spam' then
					return unlock_group_spam(msg, data, target)
				end
				if matches[3] == 'rtl' then
					return unlock_group_rtl(msg, data, target)
				end
				if matches[3] == 'sticker' then
					return unlock_group_sticker(msg, data, target)
				end
			end

		if matches[1] == 'settings' and matches[2] == 'group' and data[tostring(matches[3])]['settings'] then
			local target = matches[3]
			text = show_group_settingsmod(msg, target)
			return text.."\nID: "..target.."\n"
		end
		if  matches[1] == 'settings' and matches[2] == 'sgroup' and data[tostring(matches[3])]['settings'] then
			local target = matches[3]
			text = show_supergroup_settingsmod(msg, target)
			return text.."\nID: "..target.."\n"
		end

		if matches[1] == 'setname' and is_realm(msg) then
			local settings = data[tostring(matches[2])]['settings']
			local new_name = string.gsub(matches[2], '_', ' ')
			data[tostring(msg.to.id)]['settings']['set_name'] = new_name
			save_data(_config.moderation.data, data)
			local group_name_set = data[tostring(msg.to.id)]['settings']['set_name']
			local to_rename = 'chat#id'..msg.to.id
			rename_chat(to_rename, group_name_set, ok_cb, false)
			savelog(msg.to.id, "Realm { "..msg.to.print_name.." }  name changed to [ "..new_name.." ] by "..name_log.." ["..msg.from.id.."]")
        end

		if matches[1] == 'setgpname' and is_admin1(msg) then
		    local new_name = string.gsub(matches[3], '_', ' ')
		    data[tostring(matches[2])]['settings']['set_name'] = new_name
		    save_data(_config.moderation.data, data)
		    local group_name_set = data[tostring(matches[2])]['settings']['set_name']
		    local chat_to_rename = 'chat#id'..matches[2]
			local channel_to_rename = 'channel#id'..matches[2]
		    rename_chat(to_rename, group_name_set, ok_cb, false)
			rename_channel(channel_to_rename, group_name_set, ok_cb, false)
			savelog(matches[3], "Group { "..group_name_set.." }  name changed to [ "..new_name.." ] by "..name_log.." ["..msg.from.id.."]")
		end

    	if matches[1] == 'help' and is_realm(msg) then
      		savelog(msg.to.id, name_log.." ["..msg.from.id.."] Used /help")
     		return help()
    	end
		--[[if matches[1] == 'set' then
			if matches[2] == 'loggroup' and is_sudo(msg) then
				local target = msg.to.peer_id
                savelog(msg.to.peer_id, name_log.." ["..msg.from.id.."] set as log group")
				return set_log_group(target, data)
			end
		end
		if matches[1] == 'rem' then
			if matches[2] == 'loggroup' and is_sudo(msg) then
				local target = msg.to.id
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] set as log group")
				return unset_log_group(target, data)
			end
		end]]
		if matches[1] == 'kill' and matches[2] == 'chat' and matches[3] then
			if not is_admin1(msg) then
				return
			end
			if is_realm(msg) then
				local receiver = 'chat#id'..matches[3]
				return modrem(msg),
				print("Closing Group: "..receiver),
				chat_info(receiver, killchat, {receiver=receiver})
			else
				return 'Error: Group '..matches[3]..' not found'
			end
		end
		if matches[1] == 'kill' and matches[2] == 'realm' and matches[3] then
			if not is_admin1(msg) then
				return
			end
			if is_realm(msg) then
				local receiver = 'chat#id'..matches[3]
				return realmrem(msg),
				print("Closing realm: "..receiver),
				chat_info(receiver, killrealm, {receiver=receiver})
			else
				return 'Error: Realm '..matches[3]..' not found'
			end
		end
		if matches[1] == 'rem' and matches[2] then
			-- Group configuration removal
			data[tostring(matches[2])] = nil
			save_data(_config.moderation.data, data)
			local groups = 'groups'
			if not data[tostring(groups)] then
				data[tostring(groups)] = nil
				save_data(_config.moderation.data, data)
			end
			data[tostring(groups)][tostring(matches[2])] = nil
			save_data(_config.moderation.data, data)
			send_large_msg(receiver, 'Chat '..matches[2]..' removed')
		end

		if matches[1] == 'chat_add_user' then
		    if not msg.service then
		        return
		    end
		    local user = 'user#id'..msg.action.user.id
		    local chat = 'chat#id'..msg.to.id
		    if not is_admin1(msg) and is_realm(msg) then
				  chat_del_user(chat, user, ok_cb, true)
			end
		end
		if matches[1] == 'addadmin' then
		    if not is_sudo(msg) then-- Sudo only
				return
			end
			if string.match(matches[2], '^%d+$') then
				local admin_id = matches[2]
				print("user "..admin_id.." has been promoted as admin")
				return admin_promote(msg, admin_id)
			else
			  local member = string.gsub(matches[2], "@", "")
				local mod_cmd = "addadmin"
				chat_info(receiver, username_id, {mod_cmd= mod_cmd, receiver=receiver, member=member})
			end
		end
		if matches[1] == 'removeadmin' then
		    if not is_sudo(msg) then-- Sudo only
				return
			end
			if string.match(matches[2], '^%d+$') then
				local admin_id = matches[2]
				print("user "..admin_id.." has been demoted")
				return admin_demote(msg, admin_id)
			else
			local member = string.gsub(matches[2], "@", "")
				local mod_cmd = "removeadmin"
				chat_info(receiver, username_id, {mod_cmd= mod_cmd, receiver=receiver, member=member})
			end
		end
		if matches[1] == 'support' and matches[2] then
			if string.match(matches[2], '^%d+$') then
				local support_id = matches[2]
				print("User "..support_id.." has been added to the support team")
				support_add(support_id)
				return "User ["..support_id.."] has been added to the support team"
			else
				local member = string.gsub(matches[2], "@", "")
				local receiver = get_receiver(msg)
				local get_cmd = "addsupport"
				resolve_username(member, res_user_support, {get_cmd = get_cmd, receiver = receiver})
			end
		end
		if matches[1] == '-support' then
			if string.match(matches[2], '^%d+$') then
				local support_id = matches[2]
				print("User "..support_id.." has been removed from the support team")
				support_remove(support_id)
				return "User ["..support_id.."] has been removed from the support team"
			else
				local member = string.gsub(matches[2], "@", "")
				local receiver = get_receiver(msg)
				local get_cmd = "removesupport"
				resolve_username(member, res_user_support, {get_cmd = get_cmd, receiver = receiver})
			end
		end
		if matches[1] == 'type'then
             local group_type = get_group_type(msg)
			return group_type
		end
		if matches[1] == 'list' then
			if matches[2] == 'admins' then
				return admin_list(msg)
			end
		--	if matches[2] == 'support' and not matches[2] then
			--	return support_list()
		--	end
		end
		
		if matches[1] == 'list' and matches[2] == 'groups' then
			if msg.to.type == 'chat' or msg.to.type == 'channel' then
				groups_list(msg)
				send_document("chat#id"..msg.to.id, "./groups/lists/groups.txt", ok_cb, false)
				send_document("channel#id"..msg.to.id, "./groups/lists/groups.txt", ok_cb, false)
				return "Group list created" --group_list(msg)
			elseif msg.to.type == 'user' then
				groups_list(msg)
				send_document("user#id"..msg.from.id, "./groups/lists/groups.txt", ok_cb, false)
				return "Group list created" --group_list(msg)
			end
		end
		if matches[1] == 'list' and matches[2] == 'realms' then
			if msg.to.type == 'chat' or msg.to.type == 'channel' then
				realms_list(msg)
				send_document("chat#id"..msg.to.id, "./groups/lists/realms.txt", ok_cb, false)
				send_document("channel#id"..msg.to.id, "./groups/lists/realms.txt", ok_cb, false)
				return "Realms list created" --realms_list(msg)
			elseif msg.to.type == 'user' then
				realms_list(msg)
				send_document("user#id"..msg.from.id, "./groups/lists/realms.txt", ok_cb, false)
				return "Realms list created" --realms_list(msg)
			end
		end
   		if matches[1] == 'res' and is_momod(msg) then
      		local cbres_extra = {
        		chatid = msg.to.id
     		}
      	local username = matches[2]
      	local username = username:gsub("@","")
      	savelog(msg.to.id, name_log.." ["..msg.from.id.."] Used /res "..username)
      	return resolve_username(username,  callbackres, cbres_extra)
    end
end

return {
  patterns = {
    "^[#!/](creategroup) (.*)$",
    "^[#!/](createsuper) (.*)$",
    "^[#!/](createrealm) (.*)$",
    "^[#!/](setabout) (%d+) (.*)$",
    "^[#!/](setrules) (%d+) (.*)$",
    "^[#!/](setname) (.*)$",
    "^[#!/](setgpname) (%d+) (.*)$",
    "^[#!/](setname) (%d+) (.*)$",
    "^[#!/](lock) (%d+) (.*)$",
    "^[#!/](unlock) (%d+) (.*)$",
    "^[#!/](mute) (%d+)$",
    "^[#!/](unmute) (%d+)$",
    "^[#!/](settings) (.*) (%d+)$",
    "^[#!/](wholist)$",
    "^[#!/](who)$",
    "^[#!/]([Ww]hois) (.*)",
    "^[#!/](type)$",
    "^[#!/](kill) (chat) (%d+)$",
    "^[#!/](kill) (realm) (%d+)$",
    "^[#!/](rem) (%d+)$",
    "^[#!/](addadmin) (.*)$", -- sudoers only
    "^[#!/](removeadmin) (.*)$", -- sudoers only
    "^[#!/](support)$",
    "^[#!/](support) (.*)$",
    "^[#!/](-support) (.*)$",
    "^[#!/](list) (.*)$",
    "^[#!/](log)$",
    "^[#!/](help)$",
    "^!!tgservice (.+)$",
},
  run = run
}
end
