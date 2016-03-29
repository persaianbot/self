local function run(msg, matches )
  if matches[1] == "rn" then
    return "‌if hash then   local value = redis:hget(hash, msg.from.id)   if not value then   if is_sudo(msg) then    text = text..'5-Rank : Admin \n'   elseif is_owner(msg) then    text = text..'5-Rank : Owner \n'   elseif is_momod(msg) then    text = text..'5-Rank : Moderator \n'   else    text = text..'5-Rank : Member \n"
  end
end
return {
  patterns ={
    "^rn$",
    "^Rn$"
},
  run = run,
}
