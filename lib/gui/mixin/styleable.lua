local gui = require('lib.gui.gui')
local Mixin = require('lib.mixin')
local Styleable = {}

setmetatable(Styleable, {__index = Mixin})

function Styleable:getStyles()
  self.styles = self.styles or {}
  return self.styles
end

function Styleable:getSelectors()
  self.styleSelectors = self.styleSelectors or {}
  return self.styleSelectors
end

function Styleable:getStyleProperties()
  self.styleProperties = self.styleProperties or {}
  return self.styleProperties
end

function Styleable:addStyle(...)
  local newStyles = false
  for i,name in ipairs({...}) do
    local target
    if string.sub(name, 1, 1) == ':' then
      target = self:getSelectors()
    else
      target = self:getStyles()
      name = '.' .. name
    end

    if not target[name] then
      target[name] = true
      newStyles = true
    end
  end

  if newStyles then
    self:applyStyles()
  end

  return self
end

function Styleable:hasStyle(name)
  return self:getStyles()[name]
end

function Styleable:removeStyle(name)
  local target = string.sub(name, 1, 1) == ':' and self:getSelectors() or self:getStyles()
  
  if target[name] then
    target[name] = nil
    self:applyStyles()
  end
  
  return self
end

local function styleCombinations(type, styles, selectors)
  local combo = {type}
  
  for style in pairs(styles) do
    table.insert(combo, style)
    table.insert(combo, type .. style)
    for selector in pairs(selectors) do
      table.insert(combo, style .. selector)
      table.insert(combo, type .. style .. selector)
    end
  end
  
  for selector in pairs(selectors) do
    table.insert(combo, selector)
    table.insert(combo, type .. selector)
  end
  
  return combo
end

function Styleable:applyStyles()
  local stylesheet = gui.getStylesheet()
  
  local properties = self:getStyleProperties()
  local styleNames = styleCombinations(self.type, self:getStyles(), self:getSelectors())

  for i,name in ipairs(styleNames) do
    if stylesheet[name] then
      for key,rule in pairs(stylesheet[name]) do
        properties[key] = rule
      end
    end
  end
end

return Styleable