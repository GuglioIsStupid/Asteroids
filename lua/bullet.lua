local Bullet = Object:extend()

local bulletPolygonVertices = {
    {0, 0},
    {0, 10},
    {10, 10},
    {10, 0}
}

function Bullet:new(x, y, angle)
    self.x, self.y = x, y
    self.angle = angle
    self.speed = 250
    self.vertices = bulletPolygonVertices
    self.width = 10
    self.height = 10
    self.alive = true
end

function Bullet:update(dt)
    self.x = self.x + math.cos(math.rad(self.angle)) * self.speed * dt
    self.y = self.y + math.sin(math.rad(self.angle)) * self.speed * dt

    if self.y < 0 then
        for _ = 1, 15 do
            table.insert(particles, Particle(self.x, self.y, "top"))
        end
        self.alive = false
    elseif self.y > HEIGHT then
        for _ = 1, 15 do
            table.insert(particles, Particle(self.x, self.y, "bottom"))
        end
        self.alive = false
    elseif self.x < 0 then
        for _ = 1, 15 do
            table.insert(particles, Particle(self.x, self.y, "left"))
        end
        self.alive = false
    elseif self.x > WIDTH then
        for _ = 1, 15 do
            table.insert(particles, Particle(self.x, self.y, "right"))
        end
        self.alive = false
    end

    self.vertices = {}
    for i, vert in ipairs(bulletPolygonVertices) do
        local rotatedVertex = {rotatePoint(vert[1], vert[2], self.angle)}
        table.insert(self.vertices, rotatedVertex[1] + self.x)
        table.insert(self.vertices, rotatedVertex[2] + self.y)
    end

    for i, asteroid in ipairs(asteroids) do
        if collision(self, asteroid) then
            self.alive = false
            table.remove(asteroids, i)
            score = score + 1
            for _ = 1, 25 do
                table.insert(particles, Particle(asteroid.x, asteroid.y, ""))
            end
        end
    end
end

function Bullet:draw()
    if #self.vertices < 2 then return end 
    love.graphics.polygon("fill", unpack(self.vertices))
end

return Bullet