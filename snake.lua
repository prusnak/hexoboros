require 'hexhelper'

Snake = {}
Snake.__index = Snake

-- orientation
--   3
-- 2   4
-- 1   5
--   0

function Snake:new(str)
  local o = {}
  setmetatable(o, Snake)
  o.str = str
  o.starti = 5
  o.startj = 5
  o.orient = 0
  return o
end

function Snake:draw()
  cx = hexx(self.starti, self.startj)
  cy = hexy(self.starti, self.startj)
  co = self.orient
  for c in string.gmatch(self.str, '.') do
    -- render
    if c == 'H' then
      love.graphics.draw(img['snakeH'], cx, cy, hexorient[co+1], 1, 1, 48, 48)
    elseif c == 'S' then
      love.graphics.draw(img['snakeS'], cx, cy, hexorient[co+1], 1, 1, 48, 48)
    elseif c == 'T' then
      love.graphics.draw(img['snakeT'], cx, cy, hexorient[co+1], 1, 1, 48, 48)
    elseif c == 'l' then
      love.graphics.draw(img['snakel'], cx, cy, hexorient[co+1], 1, 1, 48, 48)
      co = (co + 5) % 6
    elseif c == 'L' then
      love.graphics.draw(img['snakeL'], cx, cy, hexorient[co+1], 1, 1, 48, 48)
      co = (co + 4) % 6
    elseif c == 'r' then
      love.graphics.draw(img['snaker'], cx, cy, hexorient[co+1], 1, 1, 48, 48)
      co = (co + 1) % 6
    elseif c == 'R' then
      love.graphics.draw(img['snakeR'], cx, cy, hexorient[co+1], 1, 1, 48, 48)
      co = (co + 2) % 6
    end
    -- update
    cx = cx - math.sin(hexorient[co+1])*85
    cy = cy + math.cos(hexorient[co+1])*81
  end
end
