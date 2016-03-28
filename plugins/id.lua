local function run(msg, matches )
  if matches[1] == "Id" then
    return "id :"..msg.from.id
  end
end
return {
  patterns ={
    "^([Ii]d)"
},
  run = run
}
