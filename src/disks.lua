local drives={}
for addr in component.list("drive")do
  local drive=component.proxy(drive)
  for k,loader in pairs(loaders) do
    local pt=loader.read(drive)
    if pt then
      drives[#drives+1]={address=addr,drive=drive,ptt=k,pt=pt}
    end
  end
end
for addr in component.list("filesystem") do
  drives[#drives+1]={address=addr,drive=component.proxy(addr),pt="managed"}
end
