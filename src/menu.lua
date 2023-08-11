-- menus?

local function waitkey(timeout)
  local maxtime=computer.uptime()+(timeout or math.huge)
  repeat
    local time=computer.uptime()
    local signal={computer.pullSignal(maxtime-time)}
    if signal[1]=="key_down" then
      return signal[4]
    end
  until time>=maxtime
end

local function menu(title,options,timeout,default)
  write(title)
  for i=1,#options do
    write(("%d) %s"):format(i, options[i]))
  end
  if default then write("Default is ".. default) end
  local selected=default or 0
  local maxtime=computer.uptime()+(timeout or math.huge)
  repeat
    local time=computer.uptime()
    local signal={computer.pullSignal(maxtime-time)}
    if signal[1]=="key_down" then
      local num=tonumber(string.char(math.max(0,math.min(255,signal[3]))))
      if options[num] then return num end
      if signal[3] == 10 and options[default] then return default end
    end
  until time>=maxtime
  return default
end

write("Press F12 for configuration")
write("")
if waitkey(math.max(0.1,config[c.timeout])) == 88 then
  while true do
    local opt = menu("Select an option:", {"Exit", "Clear boot address", "Set timeout ("..config[c.timeout]..")", "Toggle play beep ("..config[c.beep]..")", "Show logo on boot ("..config[c.logo]..")"})
    write("")
    if opt == 1 then
      computer.shutdown(true)
    elseif opt == 2 then
      config[c.boot] = ""
      save()
      write("Boot address cleared.")
    elseif opt == 3 then
      write("Enter new timeout (current "..config[c.timeout].."):")
      while true do
        local signal={computer.pullSignal()}
        if signal[1]=="key_down" then
          local num=tonumber(string.char(math.max(0,math.min(255,signal[3]))))
          if num then
            config[c.timeout]=num
            write("Timeout set.")
            break
          end
        end
      end
      save()
    elseif opt == 4 then
      config[c.beep]=math.abs(config[c.beep]-1)
      save()
    elseif opt == 5 then
      config[c.logo]=math.abs(config[c.logo]-1)
      save()
    end
  end
end

local bootable={}
local selected=0
for i=1,#drives do
  local drive=drives[i]
  for j=1,#drive.ptt do
    if drive.ptt[j] and drive.ptt[j].boot then
      bootable[#bootable+1]={drive=drive.drive,start=drive.ptt[j].start,size=drive.ptt[j].size,type=drive.ptt[j].type,label=drive.ptt[j].label,part=j}
      if drive.address == config[c.boot] and j == config[c.partition] then
        selected = #bootable
      end
    end
  end
end

if #bootable==0 then
  computer.beep("....")
  write("No bootable medium found.")
  while true do computer.pullSignal() end
elseif #bootable>1 then
  local options={}
  for i=1,#bootable do
    local t=bootable[i]
    options[i]=string.format("%s type %s",t.label or t.drive.address:sub(1,8),t.type)
  end
  selected=menu("Please select a boot device.",options,options[selected]and config[c.timeout]or math.huge,selected)
elseif selected == 0 then
  selected = 1
end
local boot=bootable[selected]
write("Booting from "..boot.drive.address:sub(1,8)..","..boot.part)
config[c.boot]=boot.drive.address
config[c.partition]=boot.part
save()
function computer.getBootAddress()
  local addr = boot.drive.address
  if boot.type~="managed" then
    addr=addr..","..boot.part
  end
  return addr
end
local ok,err=xpcall(function()
  assert(load((readers[boot.type] or readers.generic)(boot),"="..boot.drive.address:sub(1,8)))()
end, debug.traceback)
if not ok and err then
  for line in err:gsub("\t","  "):gmatch("[^\n]+") do
    write(line)
  end
end
while true do computer.pullSignal() end
