local function run(msg, matches )
  if matches[1] == "user" then
    return "telegram.me/"..msg.from.username
  end
  if matches[1] == "User" then
    return "telegram.me/"..msg.from.username
  end

return {
  patterns ={
    "^user$",
    "^User$"
    
 },
  run = run
}
