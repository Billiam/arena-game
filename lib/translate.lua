local Config = require('model.config')
local beholder = require('vendor.beholder')

local defaults = {
  LANGUAGE = 'en',
  CONFIG_KEY = 'language',
  DIRECTORY = 'translation',
  EVENT = 'LANGUAGE_UPDATE'
}

local languageIndex
local strings = {}
local languages = {}
local languageList = {}

local currentLanguage

local Translate = {}

setmetatable(Translate, {
  __index = function(self, key)

    if not currentLanguage then
      Translate:load()
    end

    return strings[key] or 'Untranslated ' ..currentLanguage .. '[' .. key .. ']'
  end
})

function Translate:loadLanguages()
  local availableLanguages = love.filesystem.getDirectoryItems(defaults.DIRECTORY)
  table.sort(availableLanguages)

  for i,filename in ipairs(availableLanguages) do
    local name = filename:gsub('%.lua$', '')

    table.insert(languageList, name)
    languages[name] = i
  end
end

function Translate:load()
  local lang = Config:get(defaults.CONFIG_KEY)

  if lang and languages[lang] then
    Translate:setLanguage(lang)
  else
    Translate:setLanguage(defaults.LANGUAGE)
  end
end

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
    error('Language (' .. lang .. ') not supported')
  end

  languageIndex = languages[lang]

  currentLanguage = lang

  strings = require('translation.' .. currentLanguage)

  Config:set(defaults.CONFIG_KEY, lang)
  beholder.trigger(defaults.EVENT)
end

function Translate:languages()
  return languages
end

Translate:loadLanguages()

return Translate