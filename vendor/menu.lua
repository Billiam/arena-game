--[[
Simple Menu Library
by nkorth

Requires: love2d
Recommended: hump.gamestate

Public Domain - feel free to hack and redistribute this as much as you want.
]]--
return {
  new = function()
    local width = 300
    local itemHeight = 20
    local margin = 0
    local paddingLeft = 5

    return {
      items = {},
      selected = 1,
      animOffset = 0,


      addItem = function(self, name, action)

        table.insert(self.items, {
          name = name,
          action = action
        })
      end,

      setDimensions = function(self, w, h, m, pl)
        width = w or width
        itemHeight = h or itemHeight
        margin = m or margin
        paddingLeft = pl or paddingLeft
      end,

      reset = function(self)
        self.selected = 1
        self.animOffset = 0
      end,

      update = function(self, dt)
        self.animOffset = self.animOffset / (1 + dt*20)
      end,

      height = function(self)
        return #self.items == 0 and 0 or itemHeight * #self.items + margin * (#self.items - 1)
      end,

      draw = function(self, x, y, textColor, activeTextColor, highlightColor)
        local fontHeight = love.graphics.getFont():getHeight()
        local fontOffset = itemHeight/2 - fontHeight/2

        textColor = textColor or {255, 255, 255, 128}
        activeTextColor = activeTextColor or { 255, 255, 255 }
        highlightColor = highlightColor or { 255, 255, 255, 128 }

        love.graphics.setColor(unpack(highlightColor))
        love.graphics.rectangle('fill', x, y + (itemHeight + margin)*(self.selected-1) + (self.animOffset * itemHeight), width, itemHeight)

        for i, item in ipairs(self.items) do
          if self.selected == i then
            love.graphics.setColor(unpack(activeTextColor))
          else
            love.graphics.setColor(unpack(textColor))
          end

          love.graphics.print(item.name, x + paddingLeft, y + (itemHeight + margin)*(i-1) + fontOffset)
        end

        love.graphics.setColor(255, 255, 255, 255)
      end,

      keypressed = function(self, key)
        if key == 'up' then
          if self.selected > 1 then
            self.selected = self.selected - 1
            self.animOffset = self.animOffset + 1
          else
            self.selected = #self.items
            self.animOffset = self.animOffset - (#self.items-1)
          end
        elseif key == 'down' then
          if self.selected < #self.items then
            self.selected = self.selected + 1
            self.animOffset = self.animOffset - 1
          else
            self.selected = 1
            self.animOffset = self.animOffset + (#self.items-1)
          end
        elseif key == 'return' then
          if self.items[self.selected].action then
            self.items[self.selected]:action()
          end
        end
      end
    }
  end
}