require 'level'

function love.load()
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

  gamestate = 'intro'

end

function love.update(dt)
  particles:update(dt)
  if gamestate == 'intro' then
    -- nothing
  elseif gamestate == 'chooser' then
    -- nothing
  else -- level
    level:update()
  end
end

function love.draw()
  love.graphics.draw(particles, 0, 0)
  if gamestate == 'intro' then
    love.graphics.draw(img['intro'], 0, 0)
    love.graphics.draw(img['hex'], 256, 576, 0, 1, 1, 48, 48)
    love.graphics.draw(img['hex'], 768, 576, 0, 1, 1, 48, 48)
    love.graphics.setFont(font)
    love.graphics.printf('Play', 258, 560, 0, 'center')
    love.graphics.printf('Exit', 770, 560, 0, 'center')
  elseif gamestate == 'chooser' then
    for i = 1, 10 do
      for j = 1, 8 do
        love.graphics.draw(img['hex'], 93.1*i, 85.3*j, 0, 1, 1, 48, 48)
        love.graphics.printf(i+j*10-10, 93.1*i, 85.3*j-13, 0, 'center')
      end
    end
  else -- level
    level:draw()
  end
end

function love.mousepressed(x, y, button)
  if gamestate == 'intro' then
    if math.abs(y-560) < 40 then
      if math.abs(x-256) < 40 then
        love.audio.play(snd['click'])
        gamestate = 'chooser'
      end
      if math.abs(x-768) < 40 then
        love.audio.play(snd['click'])
        love.event.push('q')
      end
    end
  elseif gamestate == 'chooser' then
    local lvlnum = 0
    for i = 1, 10 do
      for j = 1, 8 do
        if math.abs(x-93.1*i) < 40 and math.abs(y-85.3*j) < 40 then
          lvlnum = i+j*10-10
        end
      end
    end
    if lvlnum > 0 then
      level = Level:new(lvlnum)
      gamestate = 'level'
      love.audio.play(snd['click'])
    end
  else -- level
    level:click(x, y, button)
  end
end

function love.keypressed(key, unicode)
  if gamestate == 'intro' then
    if key == 'escape' then
      love.event.push('q')
    end
  elseif gamestate == 'chooser' then
    if key == 'escape' then
      gamestate = 'intro'
    end
  else -- level
    if key == 'escape' then
      gamestate = 'chooser'
      level = nil
    elseif key == 'w' then
      love.audio.play(snd['win'])
      level.winning = 0.0001
    end
  end
end
