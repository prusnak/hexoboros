require 'snake'
require 'hexhelper'

Level = {}
Level.__index = Level

function Level:new(filename)
  local o = {}
  setmetatable(o, Level)
  o.snakes = {}
  for l in love.filesystem.lines('levels/' .. filename .. '.lvl') do
    table.insert(o.snakes, Snake:new(l))
  end
  return o
end

function Level:draw()
  love.graphics.draw(img['back'], 0, 0)
  love.graphics.draw(img['header'], 768, 16)

  for i = 1, 5 do
    love.graphics.draw(img['slot'], 768, i*128)
    love.graphics.draw(img['slot'], 898, i*128)
  end

  for i = 1, 9 do
    for j = 1, hexcnts[i] do
      px = hexx(i,j)
      py = hexy(i,j)
      love.graphics.draw(img['hex'], px, py, 0, 1, 1, 48, 48 )
      love.graphics.print(i..','..j, px+8, py+22)
    end
  end

  for i = 1, # self.snakes do
    s = self.snakes[i]
    s:draw()
  end

end
