local beholder = require('vendor.beholder')

local defaultLanguage = 'en'

local currentLanguage
local languageIndex

local strings = {}

local languages = {}
local languageList = {}

local availableLanguages = love.filesystem.getDirectoryItems('translation')
table.sort(availableLanguages)

for i,filename in ipairs(availableLanguages) do
  local name = filename:gsub('%.lua$', '')

  table.insert(languageList, name)
  languages[name] = i
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

function Translate:setLanguageIndex(index)
  self:setLanguage(languageList[((index - 1) % #languageList) + 1])
end

function Translate:previousLanguage()
  self:setLanguageIndex(languageIndex - 1)
end

function Translate:nextLanguage()
  self:setLanguageIndex(languageIndex + 1)
end

function Translate:currentLanguage()
  return currentLanguage
end

function Translate:setLanguage(lang)
  if not languages[lang] then
    error('Language not supported')
  end

  languageIndex = languages[lang]

  currentLanguage = lang
  strings = require('translation.' .. currentLanguage)

  beholder.trigger('LANGUAGE_UPDATE')
end

function Translate:languages()
  return languages
end

return Translate