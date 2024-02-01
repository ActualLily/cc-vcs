term.setCursorPos(1, 1)
term.clear()

peripheral.find("modem", rednet.open)
rednet.host("vcs", "main")

<<<<<<< HEAD
if rednet.isOpen() == false then
=======
if rednet.isOpen() == false do
>>>>>>> 3f74a9c2025152975b7c1550b5b2427707f784e7
  error("No modem connected")
end

print("VCS://MAIN LISTENING...")

function findBeforeFirstSlash(str)
  local firstSlash = 0

  for i = 1, string.len(str) do
    if str.sub(str, i, i) == "/" then
      firstSlash = i
      return string.sub(str, 0, firstSlash)
    end
  end

  return nil
end

function findAfterLastSlash(str)
  local lastSlash = 0

  for i = 1, string.len(str) do
    if string.sub(str, i, i) == "/" then
      lastSlash = i
    end
  end

  return string.sub(str, lastSlash + 1)
end

function getTableSize(table)
  local size = 0
  for n in pairs(table) do
    size = size + 1
  end
  return size
end

while (true) do
  local cpuid, message = rednet.receive("vcs")

  -- Expected: warez/ver

  local ver = findAfterLastSlash(message)
  local warez = findBeforeFirstSlash(message)

  print("CPU #" .. cpuid .. " requested " .. warez .. ver)

  if ver == "latest" then
    versionlist = fs.find("vcs/" .. warez .. "/*")
    ver = findAfterLastSlash(versionlist[#versionlist + 1 - 1])
  end

  local path = "vcs/" .. warez .. "/" .. ver

  local files = fs.find(path .. "/*")
  print(getTableSize(files) .. " entries found in " .. path)

  os.sleep(1)

  for n, i in pairs(files) do
    print("-> " .. i)
    rednet.send(cpuid, "FILE://" .. findAfterLastSlash(i), "vcsr")

    for line in io.lines(i) do
      rednet.send(cpuid, line .. "\n", "vcsr")
    end
  end
  print("CPU #" .. cpuid .. " FINISHED")
  rednet.send(cpuid, "FILE://END", "vcsr")
  print()
end
