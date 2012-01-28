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
  ci = self.starti
  cj = self.startj
  co = self.orient
  for c in string.gmatch(self.str, '.') do
    -- render
    if c == 'H' then
      love.graphics.draw(img['snakeH'], hexx(ci, cj), hexy(ci, cj), hexorient[co+1], 1, 1, 48, 48)
    elseif c == 'S' then
      love.graphics.draw(img['snakeS'], hexx(ci, cj), hexy(ci, cj), hexorient[co+1], 1, 1, 48, 48)
    elseif c == 'T' then
      love.graphics.draw(img['snakeT'], hexx(ci, cj), hexy(ci, cj), hexorient[co+1], 1, 1, 48, 48)
    elseif c == 'l' then
      love.graphics.draw(img['snakel'], hexx(ci, cj), hexy(ci, cj), hexorient[co+1], 1, 1, 48, 48)
      co = (co + 5) % 6
    elseif c == 'L' then
      love.graphics.draw(img['snakeL'], hexx(ci, cj), hexy(ci, cj), hexorient[co+1], 1, 1, 48, 48)
      co = (co + 4) % 6
    elseif c == 'r' then
      love.graphics.draw(img['snaker'], hexx(ci, cj), hexy(ci, cj), hexorient[co+1], 1, 1, 48, 48)
      co = (co + 1) % 6
    elseif c == 'R' then
      love.graphics.draw(img['snakeR'], hexx(ci, cj), hexy(ci, cj), hexorient[co+1], 1, 1, 48, 48)
      co = (co + 2) % 6
    end
    -- update
    if co == 0 then
      cj = cj + 1
    elseif co == 1 then
      ci = ci - 1
      if ci >= 5 then
        cj = cj +1
      end
    elseif co == 2 then
      ci = ci - 1
      if ci < 5 then
        cj = cj - 1
      end
    elseif co == 3 then
      cj = cj - 1
    elseif co == 4 then
      ci = ci + 1
      if ci > 5 then
        cj = cj - 1
      end
    elseif co == 5 then
      ci = ci + 1
      if ci <= 5 then
        cj = cj + 1
      end
    end
  end
end
