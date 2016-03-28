local function run(msg, matches )
  if matches[1] == "Ip" then
    return "id :"..msg.from.id
  end
end
return {
  patterns ={
    "^([Ii]p)"
},
  run = run
}
