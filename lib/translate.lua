local defaultLanguage = 'es'
local currentLanguage = nil
local strings = {}

local languages = {}

for i,filename in ipairs(love.filesystem.getDirectoryItems('translation')) do
  languages[filename:gsub('%.lua$', '')] = true
end

local Translate = {}
setmetatable(Translate, {
  __index = function(self, key)

    if not currentLanguage then
      Translate:setLanguage(defaultLanguage)
    end

    return strings[key] or 'Untranslated'
  end
})

function Translate:setLanguage(lang)
  if not languages[lang] then
    error('Language not supported')
  end

  currentLanguage = lang
  strings = require('translation.' .. currentLanguage)
end

function Translate:languages()
  return languages
end

return Translate