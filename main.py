# Asteroids

import pygame as pg
import random
import math
from os import path

PlayerPolygonVertices = [(10, 0), (-10, -10), (-5, 0), (-10, 10)]

# setup screen
WIDTH = 800
HEIGHT = 600
FPS = 60
TITLE = "Asteroids"
BGCOLOR = (0, 0, 0)

# initialize pygame and create window
pg.init()
pg.mixer.init()
screen = pg.display.set_mode((WIDTH, HEIGHT))
pg.display.set_caption(TITLE)
clock = pg.time.Clock()

bulletList = []
bulletPolygonVertices = [(0, 0), (0, 10), (10, 10), (10, 0)]
class Bullet():
    def __init__(self, x, y, angle):
        self.x = x
        self.y = y
        self.angle = angle
        self.speed = 10
        self.vertices = bulletPolygonVertices
        self.width = 10
        self.height = 10
        self.alive = True

    def update(self):
        self.x += math.cos(math.radians(self.angle)) * self.speed
        self.y += math.sin(math.radians(self.angle)) * self.speed

        # wrap around screen
        if self.x > WIDTH or self.x < 0 or self.y > HEIGHT or self.y < 0:
            self.alive = False

        # rotate vertices
        self.vertices = []
        for vertex in bulletPolygonVertices:
            rotatedVertex = self.rotatePoint(vertex[0], vertex[1], self.angle)
            self.vertices.append((rotatedVertex[0] + self.x, rotatedVertex[1] + self.y))

        for asteroid in AstroidList:
            if self.collision(asteroid):
                self.alive = False
                AstroidList.remove(asteroid)
                for i in range(10):
                    particle = ExplosionParticles(asteroid.x, asteroid.y, random.randrange(0, 360))
                    particleList.append(particle)

    def collision(self, other):
        return self.x < other.x + other.width and self.x + self.width > other.x and self.y < other.y + other.height and self.y + self.height > other.y

    def rotatePoint(self, x, y, angle):
        s = math.sin(math.radians(angle))
        c = math.cos(math.radians(angle))
        newX = x * c - y * s
        newY = x * s + y * c
        return (newX, newY)

    def draw(self):
        pg.draw.polygon(screen, (255, 255, 255), self.vertices)

particleList = []
# star polygon
particlePolygonVertices = [
    (0, 0),
    (0, 5),
    (1, 1),
    (5, 0),
    (1, -1),
    (0, -5),
    (-1, -1),
    (-5, 0),
    (-1, 1)
]
class ExplosionParticles():
    # explosion particles
    def __init__(self, x, y, angle):
        self.x = x
        self.y = y
        self.angle = angle
        self.speed = random.randrange(1, 10)
        self.vertices = particlePolygonVertices
        self.width = 10
        self.height = 10
        self.alive = True
        self.decayTimer = 1
        # colour is a changing hue dark red
        self.decayTimer = 1
        self.colour = (random.randrange(16, 128), 0, 0)

    def update(self):
        # wrap around screen
        if self.x > WIDTH or self.x < 0 or self.y > HEIGHT or self.y < 0:
            self.alive = False

        # decay
        self.decayTimer -= 1 / FPS
        if self.decayTimer <= 0:
            self.alive = False

        self.x += math.cos(math.radians(self.angle)) * self.speed
        self.y += math.sin(math.radians(self.angle)) * self.speed

        # rotate vertices
        """  self.vertices = []
        for vertex in particlePolygonVertices:
            rotatedVertex = self.rotatePoint(vertex[0], vertex[1], self.angle)
            self.vertices.append((rotatedVertex[0] + self.x, rotatedVertex[1] + self.y)) """

    def rotatePoint(self, x, y, angle):
        s = math.sin(math.radians(angle))
        c = math.cos(math.radians(angle))
        newX = x * c - y * s
        newY = x * s + y * c
        return (newX, newY)
    
    def draw(self):
        # set alpha to decay timer, draw a circle
        pg.draw.circle(screen, self.colour, (int(self.x), int(self.y)), 5)


class Player():
    def __init__(self):
        self.x = WIDTH / 2
        self.y = HEIGHT / 2
        self.width = 20
        self.height = 20
        self.angle = 0
        self.speed = 0
        self.maxSpeed = 5
        self.acceleration = 0.1
        self.deceleration = 0.05
        self.rotationSpeed = 3
        self.vertices = PlayerPolygonVertices
        self.shootDelay = 0.1
        self.shootTimer = 0

    def update(self):
        self.speed -= self.deceleration
        if self.speed < 0:
            self.speed = 0
        self.x += math.cos(math.radians(self.angle)) * self.speed
        self.y += math.sin(math.radians(self.angle)) * self.speed

        self.shootTimer -= 1 / FPS

        keys = pg.key.get_pressed()
        if keys[pg.K_UP] or keys[pg.K_w]:
            self.speed += self.acceleration
            if self.speed > self.maxSpeed:
                self.speed = self.maxSpeed
        if keys[pg.K_LEFT] or keys[pg.K_a]:
            self.angle -= self.rotationSpeed
        if keys[pg.K_RIGHT] or keys[pg.K_d]:
            self.angle += self.rotationSpeed
        if keys[pg.K_SPACE] and self.shootTimer <= 0:
            bullet = Bullet(self.x, self.y, self.angle)
            bulletList.append(bullet)
            self.shootTimer = self.shootDelay

        # wrap around screen
        if self.x > WIDTH:
            self.x = 0
        if self.x < 0:
            self.x = WIDTH
        if self.y > HEIGHT:
            self.y = 0
        if self.y < 0:
            self.y = HEIGHT

        # rotate vertices
        self.vertices = []
        for vertex in PlayerPolygonVertices:
            rotatedVertex = self.rotatePoint(vertex[0], vertex[1], self.angle)
            self.vertices.append((rotatedVertex[0] + self.x, rotatedVertex[1] + self.y))

    def rotatePoint(self, x, y, angle):
        s = math.sin(math.radians(angle))
        c = math.cos(math.radians(angle))
        newX = x * c - y * s
        newY = x * s + y * c
        return (newX, newY)

    def draw(self):
        pg.draw.polygon(screen, (255, 255, 255), self.vertices)

AstroidPolygonVertices = [(10, 0), (5, 5), (0, 10), (-5, 5), (-10, 0), (-5, -5), (0, -10), (5, -5)]

AstroidList = []

class Asteroid():
    def __init__(self):
        self.x = random.randrange(0, WIDTH)
        self.y = random.randrange(0, HEIGHT)
        self.width = 20
        self.height = 20
        self.angle = random.randrange(0, 360)
        self.speed = random.randrange(1, 5)
        self.vertices = AstroidPolygonVertices

    def update(self):
        self.x += math.cos(math.radians(self.angle)) * self.speed
        self.y += math.sin(math.radians(self.angle)) * self.speed

        # wrap around screen
        if self.x > WIDTH:
            self.x = 0
        if self.x < 0:
            self.x = WIDTH
        if self.y > HEIGHT:
            self.y = 0
        if self.y < 0:
            self.y = HEIGHT

        # rotate vertices
        self.vertices = []
        for vertex in AstroidPolygonVertices:
            rotatedVertex = self.rotatePoint(vertex[0], vertex[1], self.angle)
            self.vertices.append((rotatedVertex[0] + self.x, rotatedVertex[1] + self.y))

    def rotatePoint(self, x, y, angle):
        s = math.sin(math.radians(angle))
        c = math.cos(math.radians(angle))
        newX = x * c - y * s
        newY = x * s + y * c
        return (newX, newY)
    
    def collision(self, other):
        return self.x < other.x + other.width and self.x + self.width > other.x and self.y < other.y + other.height and self.y + self.height > other.y
    
    def draw(self):
        pg.draw.polygon(screen, (255, 255, 255), self.vertices)

player = Player()

while True:
    # Process input
    for event in pg.event.get():
        if event.type == pg.QUIT:
            pg.quit()
            quit()
    # Update
    player.update()
    for asteroid in AstroidList:
        asteroid.update()
    for bullet in bulletList:
        if bullet.alive == False:
            bulletList.remove(bullet)
        else:
            bullet.update()

    for particle in particleList:
        if particle.alive == False:
            particleList.remove(particle)
        else:
            particle.update()

    # Spawn asteroids
    if len(AstroidList) < 10:
        AstroidList.append(Asteroid())
    
    # Draw
    screen.fill(BGCOLOR)
    # draw player polygon
    player.draw()
    # draw asteroids
    for asteroid in AstroidList:
        asteroid.draw()
    # draw bullets
    for bullet in bulletList:
        bullet.draw()
    # draw particles
    for particle in particleList:
        particle.draw()

    pg.display.flip()
    clock.tick(FPS)