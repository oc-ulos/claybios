local a,A,b,c,d,e,j,i,h,g="@[{io.open('compressed.lua','rb'):read('a'):gsub('\\([^z])','\\\\%1'):gsub('\"','\\\"'):gsub('[\r\n]',function(c)return'\\'..c:byte()end)}]",assert,1,'',''while b<=#a do
e=c.byte(a,b)b=b+1
for k=0,7 do h=c.sub
g=h(a,b,b)if e>>k&1<1 and b<#a then
i=c.unpack('>I2',a,b)j=1+(i>>4)g=h(d,j,j+(i&15)+2)b=b+1
end
b=b+1
c=c..g
d=h(d..g,-4^6)end
end
A(load(c))()
