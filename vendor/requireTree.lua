--extracted from https://github.com/kikito/fay

local lfs   = love.filesystem

local cache = {}

local function toFSPath(requirePath) return requirePath:gsub("%.", "/") end
local function toRequirePath(fsPath) return fsPath:gsub('/','.') end
local function noExtension(path)     return path:gsub('%.lua$', '') end

local function requireTree(requirePath, sort)
  if not cache[requirePath] then
    local result = {}

    local fsPath = toFSPath(requirePath)
    local entries = lfs.getDirectoryItems(fsPath)

    if sort then
      table.sort(entries)
    end

    for _,entry in ipairs(entries) do
      fsPath = toFSPath(requirePath .. '.' .. entry)
      if lfs.isDirectory(fsPath) then
        result[entry] = requireTree(toRequirePath(fsPath), sort)
      else
        entry = noExtension(entry)
        result[entry] = require(toRequirePath(requirePath .. '/' .. entry))
      end
    end

    cache[requirePath] = result
end

  return cache[requirePath]
end

return requireTree