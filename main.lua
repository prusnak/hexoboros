class = require '30log'

require 'level'

function love.resize(w, h)
  width, height = w, h
  scale = height * 4 / 3 / 1024
  if particles then
    particles:setPosition(width / 2, height / 2)
    particles:reset()
  end
end

function love.load()

  love.resize(love.graphics.getWidth(), love.graphics.getHeight())

  img = {}
  img['fire'] = love.graphics.newImage('images/fire.png')
  img['hex'] = love.graphics.newImage('images/hex.png')
  img['hex-light'] = love.graphics.newImage('images/hex-light.png')
  img['intro'] = love.graphics.newImage('images/intro.png')
  snd = {}
  snd['movebad'] = love.audio.newSource('sounds/movebad.ogg', 'static')
  snd['moveok'] = love.audio.newSource('sounds/moveok.ogg', 'static')
  snd['win'] = love.audio.newSource('sounds/win.ogg', 'static')
  snd['click'] = love.audio.newSource('sounds/click.ogg', 'static')
  snd['music'] = love.audio.newSource('sounds/music.ogg')
  font = love.graphics.newFont('images/cs_regular.ttf', 22)

  particles = love.graphics.newParticleSystem(img['fire'], 200)
  particles:setPosition(width / 2, height / 2)
  particles:setOffset(0, 0)
  particles:setBufferSize(1000)
  particles:setEmissionRate(200)
  particles:setEmitterLifetime(-1)
  particles:setParticleLifetime(5)
  particles:setColors(8, 246, 255, 0, 255, 255, 255, 128)
  particles:setSizes(1, 3)
  particles:setSpeed(150, 300)
  particles:setDirection(math.rad(90))
  particles:setSpread(math.rad(360))
  particles:setLinearAcceleration(0, 0, 0, 0)
  particles:setRotation(math.rad(0), math.rad(0))
  particles:setSpin(math.rad(0.5), math.rad(1), 1)
  particles:setRadialAcceleration(0)
  particles:setTangentialAcceleration(0)
  particles:start()

  snd['music']:setLooping(true)
  love.audio.play(snd['music'])

  gamestate = 'intro'

end

function love.update(dt)
  particles:update(dt)
  if gamestate == 'intro' then
    -- nothing
  else -- level
    level:update()
  end
end

function love.draw()
  love.graphics.draw(particles, 0, 0)
  if gamestate == 'intro' then
    love.graphics.draw(img['intro'], width / 2, height / 2, 0, scale, scale, 512, 384)
    love.graphics.draw(img['hex'], width / 4, height * 0.75, 0, scale, scale, 48, 48)
    love.graphics.draw(img['hex'], width * 0.75, height * 0.75, 0, scale, scale, 48, 48)
    love.graphics.setFont(font)
    love.graphics.print('Play', width / 4, height * 0.75 - 5 * scale, 0, scale, scale, font:getWidth('Play') / 2, 0)
    love.graphics.print('Exit', width * 0.75, height * 0.75 - 5 * scale, 0, scale, scale, font:getWidth('Exit') / 2, 0)
  else -- level
    level:draw()
  end
end

function love.mousepressed(x, y, button)
  if gamestate == 'intro' then
    if math.abs(y - height * 0.75) < 40 then
      if math.abs(x - width / 4) < 40 then
        love.audio.play(snd['click'])
        gamestate = 'level'
        level = Level:new(nil)
      end
      if math.abs(x- width * 0.75) < 40 then
        love.audio.play(snd['click'])
        love.event.push('quit')
      end
    end
  else -- level
    level:click(x, y, button)
  end
end

function love.keypressed(key, unicode)
  if gamestate == 'intro' then
    if key == 'escape' then
      love.event.push('quit')
    end
  else -- level
    if key == 'escape' then
      gamestate = 'intro'
      level = nil
    elseif key == 'w' then
      love.audio.play(snd['win'])
      level.winning = 0.0001
    end
  end
end
