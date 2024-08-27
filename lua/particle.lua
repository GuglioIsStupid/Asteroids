local Particle = Object:extend()

function Particle:new(x, y, dis)
    self.x, self.y = x, y
    self.dis = dis
    self.angle = 0
    local shade = love.math.random(0, 100)
    self.colour = {shade, shade, shade}
    if dis == "top" then
        self.angle = love.math.random(0, 180)
    elseif dis == "bottom" then
        self.angle = love.math.random(180, 360)
    elseif dis == "left" then
        self.angle = love.math.random(270, 450)
    elseif dis == "right" then
        self.angle = love.math.random(90, 270)
    else
        self.angle = love.math.random(0, 360)
        self.colour = {love.math.random(16, 238), 0, 0}
    end
    self.speed = love.math.random(50, 200)
    self.width = 10
    self.height = 10
    self.decayTimer = 1
end

function Particle:update(dt)
    self.decayTimer = self.decayTimer - dt
    if self.decayTimer <= 0 then
        self = nil
        return
    end

    self.x = self.x + math.cos(math.rad(self.angle)) * self.speed * dt
    self.y = self.y + math.sin(math.rad(self.angle)) * self.speed * dt
end

function Particle:draw()
    local lastColor = {love.graphics.getColor()}
    love.graphics.setColor(self.colour[1]/255, self.colour[2]/255, self.colour[3]/255, self.decayTimer)
    love.graphics.circle("fill", self.x, self.y, 5)
    love.graphics.setColor(lastColor)
end

return Particle