local function run(msg, matches )
  if matches[1] == "Help>" then
    return "قابلیت های من:\n\nInfo\n\nId\n\nuser\n\nCalc\n\n"
  end
end

return {
  patterns ={
    "^([Hh]elp>)"
 },
  run = run
}
