require 'level'

function love.load()
  img = {}
  img['fire'] = love.graphics.newImage('images/fire.png')
  img['hex'] = love.graphics.newImage('images/hex.png')
  img['intro'] = love.graphics.newImage('images/intro.png')
  snd = {}
  snd['movebad'] = love.audio.newSource('sounds/movebad.ogg', 'static')
  snd['moveok'] = love.audio.newSource('sounds/moveok.ogg', 'static')
  snd['win'] = love.audio.newSource('sounds/win.ogg', 'static')
  snd['click'] = love.audio.newSource('sounds/click.ogg', 'static')
  snd['music'] = love.audio.newSource('sounds/music.ogg')
  font = love.graphics.newFont('images/cs_regular.ttf', 22)

  particles = love.graphics.newParticleSystem(img['fire'], 200)
  particles:setPosition(512, 384)
  particles:setOffset(0, 0)
  particles:setBufferSize(1000)
  particles:setEmissionRate(200)
  particles:setLifetime(-1)
  particles:setParticleLife(5)
  particles:setColor(8, 246, 255, 0, 255, 255, 255, 128)
  particles:setSize(1, 3, 1)
  particles:setSpeed(150, 300)
  particles:setDirection(math.rad(90))
  particles:setSpread(math.rad(360))
  particles:setGravity(0, 0)
  particles:setRotation(math.rad(0), math.rad(0))
  particles:setSpin(math.rad(0.5), math.rad(1), 1)
  particles:setRadialAcceleration(0)
  particles:setTangentialAcceleration(0)
  particles:start()

  snd['music']:setLooping(true)
  love.audio.play(snd['music'])
end

function love.update(dt)
  particles:update(dt)
  if level then
    level:update()
  end
end

function love.draw()
  love.graphics.draw(particles, 0, 0)
  if not level then
    love.graphics.draw(img['intro'], 0, 0)
    love.graphics.draw(img['hex'], 256, 576, 0, 1, 1, 48, 48)
    love.graphics.draw(img['hex'], 768, 576, 0, 1, 1, 48, 48)
    love.graphics.setFont(font)
    love.graphics.printf('start', 258, 560, 0, 'center')
    love.graphics.printf('exit', 770, 560, 0, 'center')
  else
    level:draw()
  end
end

function love.mousepressed(x, y, button)
  if not level then
    if math.abs(y-560) < 40 then
      if math.abs(x-256) < 40 then
        love.audio.play(snd['click'])
        level = Level:new('level1')
      end
      if math.abs(x-768) < 40 then
        love.audio.play(snd['click'])
        love.event.push('q')
      end
    end
  else
    level:click(x, y, button)
  end
end

function love.mousereleased(x, y, button)
end

function love.keypressed(key, unicode)
  if key == 'escape' then
    love.event.push('q')
  end
  if key == 'w' then
    level:check_finished()
  end
end

function love.keyreleased(key, unicode)
end

function love.focus(f)
end

function love.quit()
end
