-- configuration

--[[
boot address (36)
timeout (1)
play beep (1)
show logo (1)
]]
local pattern="<c36I1I1I1"
local eeprom=component.proxy((component.list("eeprom")()))
local data=eeprom.getData()
local config={pattern:unpack(data..("\1"):rep(pattern:packsize()-#data))}
local function save()
  eeprom.setData(pattern:pack(table.unpack(config)))
end
if config[3]~=0 then
  computer.beep(".")
end
