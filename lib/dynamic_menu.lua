local Menu = require('vendor.menu')

local DynamicMenu = {
  menu = nil
}

DynamicMenu.__index = DynamicMenu
DynamicMenu.mt  = {
  __index = function(self, key)
    return DynamicMenu[key] and DynamicMenu[key] or self.menu[key]
  end
}

function DynamicMenu.create()
  local instance = {
    list = {},
    menu = Menu.new()
  }
  setmetatable(instance, DynamicMenu.mt)
  return instance
end

function DynamicMenu:setup()
  for i,item in ipairs(self.list) do
    item.update(item.menuData)
  end
end

function DynamicMenu:addItem(config, setup)
  if type(config) == 'function' then
    setup = config
    config = {}
  end

  local item = {
    update = setup,
    menuData = config
  }

  self.menu:addItem(item.menuData)
  item.update(item.menuData)

  table.insert(self.list, item)
end

return DynamicMenu