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
  return o
end

function Snake:draw_head(transparent, winning)
  if transparent then
    alpha = 128
  else
    alpha = 255
  end
  local rgba
  if self.idx == 1 then
    rgba = {249, 23, 32, alpha}
  elseif self.idx == 2 then
    rgba = {255, 209, 0, alpha}
  elseif self.idx == 3 then
    rgba = {114, 222, 58, alpha}
  elseif self.idx == 4 then
    rgba = {0, 214, 253, alpha}
  elseif self.idx == 5 then
    rgba = {214, 0, 253, alpha}
  elseif self.idx == 6 then
    rgba = {58, 114, 222, alpha}
  end
  if winning and winning > 0.0 then
    rgba[1] = rgba[1] + winning*(255-rgba[1])
    rgba[2] = rgba[2] + winning*(255-rgba[2])
    rgba[3] = rgba[3] + winning*(255-rgba[3])
  end
  rx = hexx(self.starti, self.startj)
  ry = hexy(self.starti, self.startj)
  if (love.timer.getTime()*30-4) % 30 < 2 then
    love.graphics.setColor(255, 255, 255, alpha)
  else
    love.graphics.setColor(rgba)
  end
  love.graphics.draw(img['fire'], rx, ry, 0, 2, 2, 16, 16)
  love.graphics.draw(img['fire'], rx, ry, 0, 2, 2, 16, 16)
  love.graphics.draw(img['fire'], rx, ry, 0, 2, 2, 16, 16)
  love.graphics.draw(img['fire'], rx, ry, 0, 2, 2, 16, 16)
  love.graphics.setColor(255, 255, 255, 255)
end

function Snake:draw(transparent, winning)
  local blink = 0
  if transparent then
    alpha = 128
  else
    alpha = 255
  end
  local rgba
  if self.idx == 1 then
    rgba = {249, 23, 32, alpha}
  elseif self.idx == 2 then
    rgba = {255, 209, 0, alpha}
  elseif self.idx == 3 then
    rgba = {114, 222, 58, alpha}
  elseif self.idx == 4 then
    rgba = {0, 214, 253, alpha}
  elseif self.idx == 5 then
    rgba = {214, 0, 253, alpha}
  elseif self.idx == 6 then
    rgba = {58, 114, 222, alpha}
  end
  if winning and winning > 0.0 then
    rgba[1] = rgba[1] + winning*(255-rgba[1])
    rgba[2] = rgba[2] + winning*(255-rgba[2])
    rgba[3] = rgba[3] + winning*(255-rgba[3])
  end
  love.graphics.setColor(rgba)
  local ci = self.starti
  local cj = self.startj
  local co = self.orient
  for c in string.gmatch(self.str, '.') do
    rx = hexx(ci, cj)
    ry = hexy(ci, cj)
    if not rx or not ry then
      break
    end
    -- render
    if c == 'H' then
      -- nothing
    elseif c == 'S' then
      -- nothing
    elseif c == 'T' then
      -- nothing
    elseif c == 'l' then
      co = (co + 5) % 6
    elseif c == 'L' then
      co = (co + 4) % 6
    elseif c == 'r' then
      co = (co + 1) % 6
    elseif c == 'R' then
      co = (co + 2) % 6
    end
    if c ~= 'H' then
      for i = 1, 16 do
        if (love.timer.getTime()*30-blink) % 30 < 2 then
          love.graphics.setColor(255, 255, 255, alpha)
        end
        love.graphics.draw(img['fire'], lx+(rx-lx)/16*i, ly+(ry-ly)/16*i, 0, 1, 1, 16, 16)
        love.graphics.setColor(rgba)
        blink = blink + 1
      end
    end
    lx = rx
    ly = ry
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

function Snake:try(newi, newj, newo)
  local ci = newi or self.starti
  local cj = newj or self.startj
  local co = newo or self.orient
  for c in string.gmatch(self.str, '.') do
    if not hex_valid(ci, cj) then
      return false
    end
    -- walk through
    if c == 'l' then
      co = (co + 5) % 6
    elseif c == 'L' then
      co = (co + 4) % 6
    elseif c == 'r' then
      co = (co + 1) % 6
    elseif c == 'R' then
      co = (co + 2) % 6
    elseif c == 'T' then
      return {ci,cj}
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
