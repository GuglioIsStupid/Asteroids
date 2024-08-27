local Asteroid = Object:extend{}

local asteroidPolygonVertices = {
    {10, 0}, 
    {5, 5}, 
    {0, 10}, 
    {-5, 5}, 
    {-10, 0}, 
    {-5, -5}, 
    {0, -10}, 
    {5, -5}
}

function Asteroid:new()
    self.x, self.y = love.math.random(0, WIDTH), love.math.random(0, HEIGHT)
    self.width = 20
    self.height = 20
    self.angle = love.math.random(0, 360)
    self.speed = love.math.random(50, 75)
    self.vertices = asteroidPolygonVertices
    self.colour = {love.math.random(64, 156), 0, 0}
end

function Asteroid:update(dt)
    self.x = self.x + math.cos(math.rad(self.angle)) * self.speed * dt
    self.y = self.y + math.sin(math.rad(self.angle)) * self.speed * dt

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
    for _, vert in ipairs(asteroidPolygonVertices) do
        local rotatedVertex = {rotatePoint(vert[1], vert[2], self.angle)}
        table.insert(self.vertices, rotatedVertex[1] + self.x)
        table.insert(self.vertices, rotatedVertex[2] + self.y)
    end
end

function Asteroid:draw()
    local lastColor = {love.graphics.getColor()}
    love.graphics.setColor(self.colour[1]/255, self.colour[2]/255, self.colour[3]/255)
    love.graphics.polygon("fill", unpack(self.vertices))
    love.graphics.setColor(lastColor)
end

return Asteroid