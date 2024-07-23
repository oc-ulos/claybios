local drives={}
for addr in component.list("drive",true)do
  local drive=component.proxy(addr)
  for k,loader in pairs(loaders) do
    local pt=loader.read(drive)
    if pt then
      drives[#drives+1]={address=addr,drive=drive,ptt=pt,pt=k}
    end
  end
end
for addr in component.list("filesystem") do
  drives[#drives+1]={address=addr,drive=component.proxy(addr),ptt={{boot=component.invoke(addr,"exists","/init.lua"),type="managed",label=component.invoke(addr,"getLabel")}},pt="managed"}
end
