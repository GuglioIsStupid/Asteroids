local BGCOLOR = {0, 0, 0}

bullets, particles, asteroids = {}, {}, {}

score = 0

WIDTH, HEIGHT = love.graphics.getDimensions()

function rotatePoint(v1, v2, angle)
    local s = math.sin(math.rad(angle))
    local c = math.cos(math.rad(angle))
    local newX = v1 * c - v2 * s 
    local newY = v1 * s + v2 * c
    return newX, newY
end

function collision(self, other)
    return self.x < other.x + other.width and self.x + self.width > other.x and self.y < other.y + other.height and self.y + self.height > other.y
end

Object = require("class")
Player = require("player")
Player = Player()
Bullet = require("bullet")
Particle = require("particle")
Asteroid = require("asteroid")

local font = love.graphics.newFont(24)
love.graphics.setFont(font)

for _ = 1, 10 do
    table.insert(asteroids, Asteroid())
end

function love.update(dt)
    Player:update(dt)
    for i, bullet in ipairs(bullets) do
        bullet:update(dt)
        if not bullet.alive then
            table.remove(bullets, i)
        end
    end
    for i, particle in ipairs(particles) do
        particle:update(dt)
        if particle.decayTimer < 0 then
            table.remove(particles, i)
        end
    end
    if #asteroids < 10 then
        table.insert(asteroids, Asteroid())
    end
    for _, asteroid in ipairs(asteroids) do
        asteroid:update(dt)
    end
end

function love.draw()
    Player:draw()
    for _, bullet in ipairs(bullets) do
        bullet:draw()
    end
    for _, particle in ipairs(particles) do
        particle:draw()
    end
    for _, asteroid in ipairs(asteroids) do
        asteroid:draw()
    end

    love.graphics.print("SCORE: " .. score .. "\nFPS: " .. love.timer.getFPS())
end