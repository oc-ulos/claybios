-- system information
local gpu,screen=component.list("gpu")(),component.list("screen")()
local function write()end
if gpu and screen then
  gpu=component.proxy(gpu)
  gpu.bind(screen)
  local w,h=gpu.maxResolution()
  gpu.setResolution(w,h)
  gpu.fill(1,1,w,h," ")
  local _y=0
  write=function(text,y)
    _y=y or(_y+1)
    gpu.fill(1,_y,w,1," ")
    gpu.set(1,_y,text)
  end
  if config[4] then
    local splash = {
      --#include "src/logo.lua"
    }
    for i, line in ipairs(splash) do
      local xo = 1
      _y=math.max(_y,i+1)
      for _, ent in ipairs(line) do
        gpu.setForeground(ent[1])
        gpu.setBackground(ent[2])
        gpu.set(xo, i, ent[3])
        xo = xo + utf8.len(ent[3])
      end
    end
    gpu.setForeground(0xFFFFFF)
    gpu.setBackground(0)
  end
else
  gpu,screen=nil,nil
end
write("PrismBIOS @[{os.date('%Y%m%d.%H.%M')}]")
write("Total memory: "..math.floor(computer.totalMemory()/1024).."KB")
local components=0
for _ in component.list() do components=components+1 end
write("Component count: "..components)
