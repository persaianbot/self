local function run(msg, matches )
  if matches[1] == "Id" then
    return "‌‌"..msg.from.id
  end
  if matches[1] == "id" then
    return "‌‌"..msg.from.id
  end
end
return {
  patterns ={
    "^Id$",
    "^id$"
},
  run = run
}
