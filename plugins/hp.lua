local function run(msg, matches )
  if matches[1] == "Help>" then
    return "قابلیت های من:\n\n🔱Info: دریافت اطلاعات خود\n🆔Id: دریافت ای دی خود\n➰user: دریافت یوزر خود\n✖Clac: ماشین حساب\n🔱By: @Mosy15"
  end
end

return {
  patterns ={
    "^([Hh]elp>)"
 },
  run = run
}
