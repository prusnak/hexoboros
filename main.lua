require 'level'

function love.load()
  img = {}
  img['back'] = love.graphics.newImage('images/back.jpg')
  img['hex'] = love.graphics.newImage('images/hex.png')
  img['slot'] = love.graphics.newImage('images/slot.png')
  img['header'] = love.graphics.newImage('images/header.png')
  img['snakeH'] = love.graphics.newImage('images/snakeh.png')
  img['snakeS'] = love.graphics.newImage('images/snakes.png')
  img['snakeT'] = love.graphics.newImage('images/snaket.png')
  img['snakel'] = love.graphics.newImage('images/snakel.png')
  img['snakeL'] = love.graphics.newImage('images/snakell.png')
  img['snaker'] = love.graphics.newImage('images/snaker.png')
  img['snakeR'] = love.graphics.newImage('images/snakerr.png')
  snd = {}
  snd['movebad'] = love.audio.newSource('sounds/movebad.ogg', 'static')
  snd['moveok'] = love.audio.newSource('sounds/moveok.ogg', 'static')
  level = Level:new('level2')
end

function love.update()
end

function love.draw()
  level:draw()
end

function love.mousepressed(x, y, button)
  level:click(x, y, button)
end

function love.mousereleased(x, y, button)
end

function love.keypressed(key, unicode)
  if key == 'escape' then
    love.event.push('q')
  end
end

function love.keyreleased(key, unicode)
end

function love.focus(f)
end

function love.quit()
end
