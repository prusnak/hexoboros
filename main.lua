require 'level'

function love.load()
  img = {}
  img['fire'] = love.graphics.newImage('images/fire.png')
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

  particles = love.graphics.newParticleSystem(img['fire'], 200)
  particles:setPosition(512, 384)
  particles:setOffset(0, 0)
  particles:setBufferSize(1000)
  particles:setEmissionRate(200)
  particles:setLifetime(-1)
  particles:setParticleLife(5)
  particles:setColor(8, 246, 255, 0, 255, 255, 255, 128)
  particles:setSize(1, 3, 1)
  particles:setSpeed(150, 300 )
  particles:setDirection(math.rad(90))
  particles:setSpread(math.rad(360))
  particles:setGravity(0, 0)
  particles:setRotation(math.rad(0), math.rad(0))
  particles:setSpin(math.rad(0.5), math.rad(1), 1)
  particles:setRadialAcceleration(0)
  particles:setTangentialAcceleration(0)
  particles:start()
  level = Level:new('level1')
end

function love.update(dt)
  particles:update(dt)
end

function love.draw()
  love.graphics.draw(particles, 0, 0)
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
