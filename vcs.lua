args = {...}
if args[1] == nil then
  print("Usage: vcs [name] <version>")
  print("If no version is supplied, latest will be downloaded.")
  return
end

local rq = args[1]
local ver = args[2] or "latest"

peripheral.find("modem", rednet.open)
mainid = rednet.lookup("vcs", "main")

print("VCS://MAIN == #"..tostring(mainid))
print("REQUESTING "..rq.." "..ver)
rednet.send(mainid, (rq.."/"..ver), "vcs")

print("Request sent successfully, waiting...")
print("Timing out in 400t...")
rednet.host("vcsr", "receiving")

local filesleft = true
local currentoutput = nil

while (filesleft) do

  local cpuid, message = rednet.receive("vcsr", 20)
      
  if string.sub(message, 1, 7) == "FILE://" then
    filename = string.sub(message, 8)
    if io.output() ~= nil then
      io.close()
    end           
           
    if filename == "END" then
      print("FILE://END")
      filesleft = false
    else  
      print("-> "..filename)
      currentoutput = rq.."/"..filename
      file = fs.open(currentoutput, "w")
    end
 
  elseif currentoutput == nil then
    print("ERROR: No FILE:// header found in protocol")
  else
    file.write(message)
  end

end

print("Exiting...")
