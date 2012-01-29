require 'snake'
require 'hexhelper'

Level = {}
Level.__index = Level

function Level:new(filename)
  local o = {}
  setmetatable(o, Level)
  o.snakes = {}
  o.tiles = {}
  i = 1
  for l in love.filesystem.lines('levels/' .. filename .. '.lvl') do
    if i < 7 then
      if string.sub(l, 1, 1) ~= '-' then
        table.insert(o.snakes, Snake:new(i, l))
      end
    else
      table.insert(o.tiles, l)
    end
    i = i + 1
  end
  o.selected = nil
  return o
end

function Level:draw()
  love.graphics.draw(img['back'], 0, 0)

  for i = 1, 9 do
    for j = 1, hexcnts[i] do
      px = hexx(i,j)
      py = hexy(i,j)
      if hex_valid(i,j) then
        love.graphics.draw(img['hex'], px, py, 0, 1, 1, 48, 48 )
        love.graphics.print(i..','..j, px+8, py+22)
      end
    end
  end

  for i = 1, # self.snakes do
    s = self.snakes[i]
    if self.selected == i then
      s:draw(true)
    else
      s:draw()
    end
  end

end

function Level:click(x, y, button)
  -- find clicked tile
  ci = nil
  cj = nil
  for i = 1, 9 do
    for j = 1, hexcnts[i] do
      rx = hexx(i,j)
      ry = hexy(i,j)
      if rx and ry and math.abs(rx-x) < 40 and math.abs(ry-y) < 40 then
        ci = i
        cj = j
      end
    end
  end
  -- was there a tile click?
  if ci and cj then
    if self.selected then -- holding snake ? => drop it
      if self.snakes[self.selected]:try(ci, cj, nil) then
        local conflict
        conflict = false
        for i = 1, # self.snakes do -- test if there is no other snake's head
          if i ~= self.selected and self.snakes[i].starti == ci and self.snakes[i].startj == cj then
            conflict = true
          end
        end
        if conflict == false then
          self.snakes[self.selected].starti = ci
          self.snakes[self.selected].startj = cj
          love.audio.play(snd['moveok'])
        else
          love.audio.play(snd['movebad'])
        end
      else
        love.audio.play(snd['movebad'])
      end
      self.selected = nil
      return
    end
    for i = 1, # self.snakes do -- find snake
      s = self.snakes[i]
      if s.starti == ci and s.startj == cj then
        if button == 'l' then
          self.selected = i
        end
        if button == 'r' then
          if s:try(nil, nil, (s.orient + 1) % 6) then
            s.orient = (s.orient + 1) % 6
            love.audio.play(snd['moveok'])
          else
            love.audio.play(snd['movebad'])
          end
        end
        if button == 'm' then
          if s:try(nil, nil, (s.orient + 5) % 6) then
            s.orient = (s.orient + 5) % 6
            love.audio.play(snd['moveok'])
          else
            love.audio.play(snd['movebad'])
          end
        end
      end
    end
  end
end
