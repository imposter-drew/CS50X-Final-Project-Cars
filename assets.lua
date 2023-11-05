-- This file is for setting up all assets

gameFont = love.graphics.newFont("assets/SigmarOne-Regular.ttf", 19)
winFont = love.graphics.newFont("assets/SigmarOne-Regular.ttf", 24)

-- Load images
playerImg = love.graphics.newImage("assets/player.png")
truckSheet = love.graphics.newImage("assets/truck1.png")
carSheet = love.graphics.newImage("assets/car1.png")
drunkCarSheet = love.graphics.newImage("assets/drunkcar1.png")
bgRoadStart = love.graphics.newImage("assets/RoadStart.png")
bgRoadEnd = love.graphics.newImage("assets/RoadEnd.png")
cashImg = love.graphics.newImage("assets/cash.png")

-- Load quads from images
trucks = {}
for i = 0, 3 do
    table.insert(trucks, love.graphics.newQuad(i * 55, 0, 55, 103, truckSheet))
end
cars = {}
for i = 0, 2 do
    table.insert(cars, love.graphics.newQuad(i * 51, 0, 51, 99, carSheet))
end
drunkCars = {}
for i = 0, 3 do
    table.insert(drunkCars, love.graphics.newQuad(i * 45, 0, 45, 86, drunkCarSheet))
end

-- Load sounds
start1 = love.audio.newSource("sounds/start1.wav", "static")
start2 = love.audio.newSource("sounds/start2.wav", "static")
pickup = love.audio.newSource("sounds/pickup.mp3", "static")
collision = love.audio.newSource("sounds/collision.wav", "static")
pBrake = love.audio.newSource("sounds/brake.mp3", "static")
bgm = love.audio.newSource("sounds/bgm.mp3", "stream")