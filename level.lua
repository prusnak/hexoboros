require 'snake'
require 'hexhelper'

Level = class()

function Level:__init(filename)
  self.snakes = {}
  self.tiles = {}
  if filename then
    i = 1
    for l in love.filesystem.lines('levels/' .. filename .. '.lvl') do
      if i < 7 then
        if string.sub(l, 1, 1) ~= '-' then
          table.insert(self.snakes, Snake:new(i, l))
        end
      else
        table.insert(self.tiles, l)
      end
      i = i + 1
    self.title = filename
  end
  else
    table.insert(self.snakes, Snake:new(1, '124HlT'))
    table.insert(self.snakes, Snake:new(2, '415HlT'))
    table.insert(self.snakes, Snake:new(3, '810HlT'))
    table.insert(self.snakes, Snake:new(4, '941HlT'))
    table.insert(self.snakes, Snake:new(5, '682HlT'))
    table.insert(self.snakes, Snake:new(6, '263HlT'))
    table.insert(self.tiles, '.........')
    table.insert(self.tiles, '.........')
    table.insert(self.tiles, '.........')
    table.insert(self.tiles, '.........')
    table.insert(self.tiles, '.........')
    table.insert(self.tiles, ' ....... ')
    table.insert(self.tiles, '  .....  ')
    table.insert(self.tiles, '   ...   ')
    table.insert(self.tiles, '    .    ')
    self.title = 'random'
  end
  self.selected = nil
  self.winning = 0.0
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
        love.graphics.draw(img['hex'], px, py, 0, scale, scale, 48, 48)
      end
    end
  end

  if self.selected then
    local t = self.snakes[self.selected]:try()
    for k = 1, # t do
      local tx = hexx(t[k][1], t[k][2])
      local ty = hexy(t[k][1], t[k][2])
      love.graphics.draw(img['hex-light'], tx, ty, 0, scale, scale, 64, 64)
    end
  end

  love.graphics.setColor(255, 255, 255, 255)

  for i = 1, # self.snakes do
    s = self.snakes[i]
    s:draw(self.winning)
  end
  for i = 1, # self.snakes do
    s = self.snakes[i]
    s:draw_head(self.winning)
  end

  love.graphics.print('Level: ' .. self.title, 10, 10, 0, scale, scale)
  love.graphics.draw(img['hex'], width - 48 * scale, 48 * scale, 0, scale, scale, 48, 48)
  love.graphics.print('Menu', width - 48 * scale, (48 - 5) * scale, 0, scale, scale, font:getWidth('Menu') / 2, 0)

  if self.winning > 0.75 then
    local a = (self.winning - 0.75) * 4
    love.graphics.setColor(255, 255, 255, a*a*255)
    love.graphics.rectangle('fill', 0, 0, width, height)
  end
  love.graphics.setColor(255, 255, 255, 255)

end

function Level:click(x, y, button)
  if self.winning > 0 then
    return
  end
  -- menu clicked
  if x > width - 88 * scale and y < 88 * scale then
      gamestate = 'intro'
      level = nil
      return
  end
  -- find clicked tile
  ci = nil
  cj = nil
  for i = 1, 9 do
    for j = 1, hexcnts[i] do
      rx = hexx(i,j)
      ry = hexy(i,j)
      if rx and ry and math.abs(rx-x) < 40 * scale and math.abs(ry-y) < 40 * scale then
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
        if button == 1 then
          self.selected = i
        end
        if button == 2 then
          if s:try(nil, nil, (s.orient + 1) % 6) then
            s.orient = (s.orient + 1) % 6
            love.audio.play(snd['moveok'])
            self:check_finished()
          else
            love.audio.play(snd['movebad'])
          end
        end
        if button == 3 then
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
      fin = fin[# fin]
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
    particles:setColors(8, 246, 255, self.winning*128, 255, 255, 255, 128)
  end
  if self.winning > 1.0 then
    particles:setColors(8, 246, 255, 0, 255, 255, 255, 128)
    level = Level:new(nil)
    gamestate = 'level'
  end
end
