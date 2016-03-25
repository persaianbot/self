local function run(msg, matches )
  if matches[1] == "git" then
    return "https://github.com/BeatBotTeam/Self-Bot
  end
end

return {
  patterns ={
    "^([Gg]it)"
 },
  run = run
}
