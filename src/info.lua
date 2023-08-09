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
else
  gpu,screen=nil,nil
end
write("ClayBIOS @[{os.date('%Y%m%d.%H.%M')}]")
write("Total memory: "..math.floor(computer.totalMemory()/1024).."KB")
local components=0
for _ in component.list() do components=components+1 end
write("Component count: "..components)
