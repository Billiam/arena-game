local defaultLanguage = 'en'
local currentLanguage = nil
local strings = {}

local languages = {
  en = true
}
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



--function Translate:get(key)
--
--
--  return strings[key] or 'Untranslated'
--end

function Translate:languages()
  return languages
end

return Translate