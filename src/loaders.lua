-- disk loaders
-- cursed macros!
-- original code:
-- local pattern,sector,part,meta="PATTERN",drive.readSector(SECTOR),{}
-- meta=pattern:unpack(sector)
-- VERIFIER;
-- part.label=meta[NAME]
-- repeat
--   sector = sector:sub(32)
--   meta=pattern:unpack(sector)
--   meta[NAME]=meta[NAME]:gsub('\0','')
--   if #meta[NAME]>0 then
--     part[#part+1]={start=meta[START],size=meta[SIZE],boot=BOOTCOND,type=meta[PTYPE]}
--   end
-- until #sector <= 32
-- return part
--@[{(function()function _G.part_reader(pattern,sector,verifier,name,start,size,bootcond,ptype) return "local pattern,sector,part,meta='"..pattern.."',drive.readSector("..sector.."),{};meta=pattern:unpack(sector)"..verifier..";part.label=meta["..name.."]repeat sector = sector:sub(32)meta=pattern:unpack(sector)meta["..name.."]=meta["..name.."]:gsub('\\0','')if #meta["..name.."]>0 then part[#part+1]={start=meta["..start.."],size=meta["..size.."],boot="..bootcond..",type=meta["..ptype.."]}end until #sector <= 32 return part"end end)()}]
local loaders={osdi={read=function(drive)
@[{part_reader("<I4I4c8I3c13",1,'if meta[1]~=1 or meta[2]~=0 or meta[3]~="OSDI\\xAA\\xAA\\85\\85" then return end',5,1,2,'meta[4]&512>0',3)}]
end},mtpt={read=function(drive)
@[{part_reader(">c20c4I4I4",'drive.getSectorCapacity()','if meta[2]~="mtpt"then return end',1,3,4,'meta[2]=="boot"',2)}]
end}}