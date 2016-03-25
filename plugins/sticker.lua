local function download(msg, success, result, matches)
  local receiver = get_receiver(msg)
  if success then
    local file = 'sticker/' .. msg.from.id .. '.webp'
    print('File downloaded to:', result)
    os.rename(result, file)
    print('File moved to:', file)
    send_large_msg(receiver, 'please send /make for create sticker\n@BeatBot_Team :))', ok_cb, false)
    redis:del("file:jpeg")
  else
    print('Error downloading: '..msg.id)
    send_large_msg(receiver, 'Failed, please try again!', ok_cb, false)
  end
end
local function run(msg,matches)

    if msg.media then
        if msg.media.type == 'photo' and redis:get("file:jpeg") then
          if redis:get("file:jpeg") == 'waiting' then
            load_photo(msg.id, download, msg)
          end
        end
    end
    if matches[1] == 'sticker' then
      redis:set("file:jpeg", "waiting")
      return 'Please send me photo now\n @Mosy15 :)) '
end
    if matches[1] == 'make' then
            local receiver = get_receiver(msg)
                  send_document(receiver, "./sticker/"..msg.from.id..".webp", ok_cb, false)

      return 'by @Mosy15 :)) '
end

    return
end
return {
  patterns = {
    "^[/!](make)$",
  "^[!/](sticker)$",
  "%[(photo)%]",
  },
  run = run,
}
