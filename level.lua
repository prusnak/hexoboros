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
  o.winning = 0.0
  o.title = filename
  return o
end

function Level:draw()
  love.graphics.setColor(255, 255, 255, 224)
  for i = 1, 9 do
    for j = 1, hexcnts[i] do
      local px = hexx(i,j)
      local py = hexy(i,j)
      if hex_valid(i,j) then
        if self.winning > 0.0 then
          px = px + math.random(0,6*self.winning*self.winning)
          py = py + math.random(0,6*self.winning*self.winning)
        end
        love.graphics.draw(img['hex'], px, py, 0, 1, 1, 48, 48)
        -- love.graphics.print(i..','..j, px+8, py+22)
      end
    end
  end
  love.graphics.setColor(255, 255, 255, 255)

  for i = 1, # self.snakes do
    s = self.snakes[i]
    if self.selected == i then
      s:draw(true)
    else
      s:draw(false, self.winning)
    end
  end
  for i = 1, # self.snakes do
    s = self.snakes[i]
    if self.selected == i then
      s:draw_head(true)
    else
      s:draw_head(false, self.winning)
    end
  end

  if self.winning > 0.75 then
    local a = (self.winning - 0.75) * 4
    love.graphics.setColor(255, 255, 255, a*a*255)
    love.graphics.rectangle('fill', 0, 0, 1024, 768)
  end
  love.graphics.setColor(255, 255, 255, 255)

  love.graphics.print(self.title, 10, 10)

end

function Level:click(x, y, button)
  if self.winning > 0 then
    return
  end
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
          self:check_finished()
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
            self:check_finished()
          else
            love.audio.play(snd['movebad'])
          end
        end
        if button == 'm' then
          if s:try(nil, nil, (s.orient + 5) % 6) then
            s.orient = (s.orient + 5) % 6
            love.audio.play(snd['moveok'])
            self:check_finished()
          else
            love.audio.play(snd['movebad'])
          end
        end
      end
    end
  end
end

function Level:check_finished()

  local edges = {}
  local visited = {}
  for i = 1, # self.snakes do
    start = self.snakes[i].starti*100 + self.snakes[i].startj
    fin = self.snakes[i]:try()
    if fin then
      fin = fin[1]*100 + fin[2]
      edges[start] = fin
    end
  end
  c = self.snakes[1].starti*100 + self.snakes[1].startj
  c = edges[c]
  l = 0
  while c and not visited[c] do
    visited[c] = true
    c = edges[c]
    l = l + 1
  end
  if l == # self.snakes then
    love.audio.play(snd['win'])
    level.winning = 0.0001
  end
end

function Level:update()
  if self.winning > 0.0 then
    self.winning = self.winning + love.timer.getDelta()/6
    particles:setColor(8, 246, 255, self.winning*128, 255, 255, 255, 128)
  end
  if self.winning > 1.0 then
    particles:setColor(8, 246, 255, 0, 255, 255, 255, 128)
    if self.title == 'level1' then
      level = Level:new('level2')
    else
      level = nil
    end
  end
end
