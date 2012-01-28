require 'hexhelper'

Snake = {}
Snake.__index = Snake

-- orientation
--   3
-- 2   4
-- 1   5
--   0

function Snake:new(idx, str)
  local o = {}
  setmetatable(o, Snake)
  o.idx = idx
  o.starti = tonumber(string.sub(str,1,1))
  o.startj = tonumber(string.sub(str,2,2))
  o.orient = tonumber(string.sub(str,3,3))
  o.str = string.sub(str,4,-1)
  print (o.starti)
  print (o.startj)
  print (o.orient)
  print (o.str)
  return o
end

function Snake:draw(transparent)
  if transparent then
    alpha = 128
  else
    alpha = 255
  end
  if self.idx == 1 then
    love.graphics.setColor(255, 0, 0, alpha)
  elseif self.idx == 2 then
    love.graphics.setColor(0, 255, 0, alpha)
  elseif self.idx == 3 then
    love.graphics.setColor(0, 0, 255, alpha)
  elseif self.idx == 4 then
    love.graphics.setColor(0, 255, 255, alpha)
  elseif self.idx == 5 then
    love.graphics.setColor(255, 0, 255, alpha)
  elseif self.idx == 6 then
    love.graphics.setColor(255, 255, 0, alpha)
  end
  if not self.starti or not self.startj then
    ci = 5
    cj = 5
    scale = 0.2
    dx = 0
    dy = 0
  else
    ci = self.starti
    cj = self.startj
    scale = 1
    dx = 0
    dy = 0
  end
  co = self.orient
  for c in string.gmatch(self.str, '.') do
    rx = hexx(ci, cj)
    ry = hexy(ci, cj)
    if rx then
      rx = rx*scale + dx
    end
    if ry then
      ry = ry*scale + dy
    end
    if not rx or not ry then
      break
    end
    -- render
    if c == 'H' then
      love.graphics.draw(img['snakeH'], rx, ry, hexorient[co+1], scale, scale, 48, 48)
    elseif c == 'S' then
      love.graphics.draw(img['snakeS'], rx, ry, hexorient[co+1], scale, scale, 48, 48)
    elseif c == 'T' then
      love.graphics.draw(img['snakeT'], rx, ry, hexorient[co+1], scale, scale, 48, 48)
    elseif c == 'l' then
      love.graphics.draw(img['snakel'], rx, ry, hexorient[co+1], scale, scale, 48, 48)
      co = (co + 5) % 6
    elseif c == 'L' then
      love.graphics.draw(img['snakeL'], rx, ry, hexorient[co+1], scale, scale, 48, 48)
      co = (co + 4) % 6
    elseif c == 'r' then
      love.graphics.draw(img['snaker'], rx, ry, hexorient[co+1], scale, scale, 48, 48)
      co = (co + 1) % 6
    elseif c == 'R' then
      love.graphics.draw(img['snakeR'], rx, ry, hexorient[co+1], scale, scale, 48, 48)
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
  love.graphics.setColor(255, 255, 255, 255)
end
