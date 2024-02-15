protocol = ""
hostname = "MAIN"

-- LOG LEVELS:
-- 0 = DEBUG
-- 1 = INFO (default)
-- 2 = WARN
-- 3 = ERROR

loglevel = 0

function log(message, level, source)
  -- name, color
  local logLevelInfo = {
    {"DEBUG", colors.lightGray},
    {"INFO", colors.lightBlue},
    {"WARN", colors.orange},
    {"ERROR", colors.red}
  }

  -- file output here
  
  if message == nil then
    log("Attempted to log empty string", 2)
  end

  local leftSpacing = 12

  if level == nil then
    level = 1
  end

  if source == nil then
    source = "CORE"
  end

  source = logLevelInfo[level + 1][1]..">"..source

  if level == 3 then
    error(message)
  end

  if level >= loglevel then
    local message = string.upper(source)..string.rep(" ", leftSpacing - #source)..message

    local originalTextColor = term.getTextColor()

    term.setTextColor(logLevelInfo[level + 1][2])
    print(message)
    term.setTextColor(originalTextColor)
  end

end

function init(protocolToInit, hostnameToInit)
  term.setCursorPos(1, 1)
  term.clear()

  log("Loading")

  log("Checking for modem", 0)
  peripheral.find("modem", rednet.open)

  if rednet.isOpen() == false then
    log("No modem connected", 3)
    return false
  end

  protocol = protocolToInit
  hostname = hostnameToInit or hostname

  rednet.host(protocol, hostname)
  log(protocol.."://"..hostname.." initialized")
  return true
end


function splitBySeparator(inputstr, sep)
  log(inputstr, 0, "SPLIT")

  if sep == nil then
    sep = "/"
  end

  local array = {}

  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(array, str)
  end

  return array
end

function verifyRemoteHost(remote)
  log("Checking "..remote.." availability", 0)

  local hostID = rednet.lookup("LYMJ", remote)

  if hostID == nil then
    term.clear()
    term.setCursorPos(1, 1)
    log("Server "..remote.." could not be reached", 3)
    return false
  end
  return hostID
end

function readFile(filename)
  local fileHandle = fs.open(filename, "r")
  local fileContent = nil

  if fileHandle ~= nil then
    fileContent = fileHandle.readAll()
    fileHandle.close()
  end

  return fileContent
end

function saveConfig(key, value)
  log("Saving config "..key.." = "..value, 0)

  local config = grabConfig()
  config[key] = value

  local configFile = fs.open("/mahjong/config", "w")
  for k,v in pairs(config) do
    configFile.write(k.."="..v.."\n")
  end

  configFile.flush()
  configFile.close()
end

function grabConfig()
  log("Grabbing config ", 0)

  local configFile = fs.open("/mahjong/config", "r")
  local configValues = string.upper(configFile.readAll())
  configFile.close()

  local indexedArray = splitBySeparator(configValues, "\n")
  
  local configArray = {} 

  for k,v in pairs(indexedArray) do
    local keypair = splitBySeparator(v:gsub("%s+", ""), "=")

    if keypair[2] == nil then
      keypair[2] = ""
    end

    configArray[keypair[1]] = keypair[2]
  end

  return configArray
end

return { 
  log = log,
  init = init, 
  verifyRemoteHost = verifyRemoteHost, 
  readFile = readFile,
  grabConfig = grabConfig, 
  saveConfig = saveConfig, 
  splitBySeparator = splitBySeparator, 
  runTimer = runTimer
}