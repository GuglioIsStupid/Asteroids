local Player = Object:extend()

local playerPolygonVertices = {
    {10, 0},
    {-10, 10},
    {-5, 0}, 
    {-10, 10}
}

function Player:new()
    self.x, self.y = love.graphics.getWidth()/2, love.graphics.getHeight()/2
    self.width, self.height = 20, 20
    self.angle = 0
    self.speed = 0 
    self.maxSpeed = 125
    self.accel = 100
    self.decel = 115
    self.rotSpeed = 6
    self.vertices = playerPolygonVertices
    self.shootDelay = 0.1
    self.shootTimer = 0
end

function Player:update(dt)
    if self.speed < 0 then self.speed = 0 end
    self.x = self.x + math.cos(math.rad(self.angle)) * self.speed * dt
    self.y = self.y + math.sin(math.rad(self.angle)) * self.speed * dt

    self.shootTimer = self.shootTimer - dt

    if love.keyboard.isDown("up", "w") then
        self.speed = self.speed + self.accel * dt
        if self.speed > self.maxSpeed then
            self.speed = self.maxSpeed
        end
    else
        self.speed = self.speed - self.decel * dt
    end
    if love.keyboard.isDown("left", "a") then
        self.angle = self.angle - self.rotSpeed 
    end
    if love.keyboard.isDown("right", "d") then
        self.angle = self.angle + self.rotSpeed 
    end
    if love.keyboard.isDown("space") and self.shootTimer < 0 then
        table.insert(bullets, Bullet(self.x, self.y, self.angle))
        self.shootTimer = self.shootDelay
    end

    if self.x > WIDTH then
        self.x = 0
    elseif self.x < 0 then
        self.x = WIDTH
    elseif self.y > HEIGHT then
        self.y = 0
    elseif self.y < 0 then
        self.y = HEIGHT
    end

    self.vertices = {}
    for _, vert in ipairs(playerPolygonVertices) do
        local rotatedVertex = {rotatePoint(vert[1], vert[2], self.angle)}
        table.insert(self.vertices, rotatedVertex[1] + self.x)
        table.insert(self.vertices, rotatedVertex[2] + self.y)
    end
end

function Player:draw()
    love.graphics.polygon("fill", unpack(self.vertices))
end

return Player