--[[ UMFAL - Unified Multi-File Applications Loader
     Should be placed in /lib
	 Author - AtomicScience
]]
local filesystem = require("filesystem")
local unicode = require("unicode")

local umfal = {}
-----------------------
-- Metatable functions
-----------------------
local function getBlankUmfalWithMeta()
    local umfal = {}
    umfal.applicationFunctions = {}

    local metatable = {}
    function metatable.__call(self, appName)
        -- Application should be already initialized when library is called as a function
        return self[appName] or error("Application " .. appName .. " was not initialized")
    end

    setmetatable(umfal, metatable)

    return umfal
end

local function getBlankApplicationWithMeta(appName, path)
    local blankApplication = {}
    blankApplication.name = appName
    blankApplication.path = path

    for methodName, method in pairs(umfal.applicationFunctions) do
        blankApplication[methodName] = method
    end

    local metatable = {}

    metatable.__index = function (application, nodeName)
        local node = application:loadNode({nodeName})

        blankApplication[nodeName] = node

        return node
    end

    setmetatable(blankApplication, metatable)


    return blankApplication
end
-----------------------
-- Library functions
-----------------------
umfal = getBlankUmfalWithMeta()

-- The simplest way to initialize application is to use an absolute path initializator
-- For instance, your app is placed on /home/myApp, and its entry point is /home/myApp/main.lua
-- So, you can utilize `initAppFromAbsolute` as such: `umfal.initAppFromAbsolute("myApp", "/home/myApp")`
-- But it's not recommended to use this function, since it forces users to store your app at the exact
-- filesystem location - use relative initializator instead (see below)
function umfal.initAppFromAbsolute(appName, path)
    local application = getBlankApplicationWithMeta(appName, path)

    if not umfal.applicationFolderExists(path) then
        error("Failed to find an application " .. appName .. " on path " .. path)
    end

    umfal[appName] = application

    return application
end

-- The second way (and the best one) to initialize application is to use a relative path initializator
-- For instance, your app is placed on /home/myApp, and its entry point is /home/myApp/main.lua
-- So, in this case you can utilize `initAppFromRelative` as such: `umfal.initAppFromRelative("myApp")` ("myApp" here
-- is just and ID that other files of yours will use to find initialized app later), and it will automatically detect 
-- and set /home/myApp as application's root.
-- However, for example, if our `main.lua` is placed at /home/myApp/run/main.lua, the before-mentioned code won't work
-- So, that's when `level delta` parameter kicks in - now we should run `umfal.initAppFromRelative("myApp", 2)` to point
-- on /home/myApp, instead of /home/myApp/run
function umfal.initAppFromRelative(appName, levelDelta)
    -- TODO: abstain from application NAME and rather use an application IDENTIFIER, or ID
    if appName == nil then
        error("Application name must be provided")
    end
    levelDelta = levelDelta or 1

    local pathToRunningScript = umfal.getPathToRunningScript()

    local resolvedPath = umfal.resolveRelativePath(pathToRunningScript, levelDelta)

    return umfal.initAppFromAbsolute(appName, resolvedPath)
end

-----------------------
-- File functions
-----------------------
-- Function was copied from MineOS' System library
function umfal.getPathToRunningScript()
    local info
    for runLevel = 0, math.huge do
        info = debug.getinfo(runLevel)
        if info then
            if info.what == "main" then
                return info.source:sub(2, -1)
            end
        else
            error("Failed to get debug info for runlevel " .. runLevel)
        end
    end
end

function umfal.resolveRelativePath(path, levelDelta)
    return umfal.concat(path, string.rep("/..", levelDelta))
end

-----
-- File checking functions
-----
function umfal.applicationFolderExists(path)
    return filesystem.isDirectory(path)
end

-- Three functions below are just a copy from Filesystem API
-- That's because MineOS's Filesystem API does not have them
local function segments(path)
    local parts = {}
    for part in path:gmatch("[^\\/]+") do
      local current, up = part:find("^%.?%.$")
      if current then
        if up == 2 then
          table.remove(parts)
        end
      else
        table.insert(parts, part)
      end
    end
    return parts
end

function umfal.canonical(path)
    local result = table.concat(segments(path), "/")
    if unicode.sub(path, 1, 1) == "/" then
      return "/" .. result
    else
      return result
    end
end

function umfal.concat(...)
    local set = table.pack(...)
    for index, value in ipairs(set) do
      checkArg(index, value, "string")
    end
    return umfal.canonical(table.concat(set, "/"))
end
-----------------------
-- Application functions
-----------------------

function umfal.applicationFunctions:nodeIsFolder(node)
    local pathToNode = self:resolvePathToNodeAsFolder(node)

    return filesystem.isDirectory(pathToNode)
end

function umfal.applicationFunctions:nodeIsLuaScript(node)
    local pathToNode = self:resolvePathToNodeAsModule(node)

    return filesystem.exists(pathToNode) and not filesystem.isDirectory(pathToNode)
end

function umfal.applicationFunctions:nodeIsValid(node)
    local isModule = self:nodeIsLuaScript(node)
    local isFolder = self:nodeIsFolder(node)

    return isModule or isFolder
end

function umfal.applicationFunctions:resolvePathToNodeAsFolder(node)
    local relativePath = self:nodeToRelativePath(node)

    return umfal.concat(self.path, relativePath)
end

function umfal.applicationFunctions:resolvePathToNodeAsModule(node)
    return self:resolvePathToNodeAsFolder(node) .. ".lua"
end

-- {one, two, three} -> "one/two/three"
function umfal.applicationFunctions:nodeToRelativePath(node)
    return table.concat(node, "/")
end

function umfal.applicationFunctions:loadNode(node)
    local loadedNode, reason = self:attemptToLoadNode(node)

    if not loadedNode then
        local nodeName = node[#node]
        error("Failed to load node `" .. nodeName .. "`: " .. reason)
    end

    return loadedNode
end

function umfal.applicationFunctions:attemptToLoadNode(node)
    if not self:nodeIsValid(node) then
        return nil, "file does not exist"
    end

    if self:nodeIsFolder(node) then
        return self:getEmptyFolder(node), nil
    elseif self:nodeIsLuaScript(node) then
        return self:loadModule(node), nil
    else
        return nil, "file is not a .lua script"
    end
end

function umfal.applicationFunctions:getEmptyFolder(node)
    local emptyFolder = {}
    emptyFolder.node = node

    local metatable = {}

    function metatable.__index(folder, nodeName)
        local newNode = self:appendToNode(folder.node, nodeName)
        local loadedNode = self:loadNode(newNode)

        emptyFolder[nodeName] = loadedNode

        return loadedNode
    end

    setmetatable(emptyFolder, metatable)

    return emptyFolder
end

function umfal.applicationFunctions:loadModule(node)
    local pathToModule = self:resolvePathToNodeAsModule(node)

    local loadedModule = dofile(pathToModule)

    if not loadedModule then
        local nodeName = node[#node]
        error("Failed to load module `" .. nodeName .. "`: module returned nil after execution")
    end

    return loadedModule
end

function umfal.applicationFunctions:appendToNode(node, nodeName)
    local newNode = {}

    for i = 1, #node do
        newNode[i] = node[i]
    end

    table.insert(newNode, nodeName)

    return newNode
end

return umfal