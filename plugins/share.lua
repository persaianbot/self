do

function run(msg, matches)
send_contact(get_receiver(msg), "+989330661790", "Mosy", ":)", ok_cb, false)
end

return {
patterns = {
"^([Ss]hare)$"

},
run = run
}

end
