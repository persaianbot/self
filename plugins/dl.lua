do

local function run(msg, matches)
  if not is_sudo(msg) then
    return "Ø´Ù…Ø§ Ø¯Ø³ØªØ±Ø³ÛŒ Ø§Ø±Ø³Ø§Ù„ ÙØ§ÛŒÙ„ Ø¨Ù‡ Ø³Ø±ÙˆØ± Ø±Ø§ Ù†Ø¯Ø§Ø±ÛŒØ¯\nSudo : @ninaco"
  end
  local receiver = get_receiver(msg)
  if matches[1] == 'dl' then
    
    local file = matches[3]
    
    if matches[2] == 'sticker' and not matches[4] then
      send_document(receiver, "./media/"..file..".webp", ok_cb, false)
    end
  
    if matches[2] == 'file' then
      local extension = matches[4]
      send_document(receiver, "./media/"..file..'.'..extension, ok_cb, false)
    end
    
    if matches[2] == 'plugin' then
      send_document(receiver, "./plugins/"..file..".lua", ok_cb, false)
    end

    if matches[2] == 'manual' and is_admin(msg) then
      local ruta = matches[3]
      local document = matches[4]
      send_document(receiver, "./"..ruta.."/"..document, ok_cb, false)
    end
  
  end
  
  if matches[1] == 'extensions' then
    return 'ÛŒØ§ÙØª Ù†Ø´Ø¯'
  end
  
  if matches[1] == 'list' and matches[2] == 'files' then
    return 'Ù„ÛŒØ³ØªÛŒ ÛŒØ§ÙØª Ù†Ø´Ø¯'
    --send_document(receiver, "./media/files/files.txt", ok_cb, false)
  end
end

return {
  description = "Kicking ourself (bot) from unmanaged groups.",
  usage = {
    "!list files : EnvÃ­a un archivo con los nombres de todo lo que se puede enviar",
    "!extensions : EnvÃ­a un mensaje con las extensiones para cada tipo de archivo permitidas",
    "!dl sticker <nombre del sticker> : EnvÃ­a ese sticker del servidor",
    "!dl file <nombre del archivo> <extension del archivo> : EnvÃ­a ese archivo del servidor",
    "!dl plugin <Nombre del plugin> : EnvÃ­a ese archivo del servidor",
    "!dl manual <Ruta de archivo> <Nombre del plugin> : EnvÃ­a un archivo desde el directorio TeleSeed",
  },
  patterns = {
  "^([Dd]l) (.*) (.*) (.*)$",
  "^([Dd]l) (.*) (.*)$",
  "^([Dd]l) (.*)$",
  "^[!/](list) (files)$",
  "^[!/](extensions)$"
  },
  run = run
}
end
