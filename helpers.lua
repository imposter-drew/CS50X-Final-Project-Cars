-- This file is for all the functions

-- Generate random vehicles
function spawnVehicle()
    generateVehicle = love.math.random(1, 3)
    if generateVehicle == 3 then
        createTruck()
        return generateVehicle
    elseif generateVehicle == 2 then
        createDrunkCar()
        return generateVehicle
    else
        createCar() 
        return generateVehicle
    end
end

-- Create the cars and truck positions. They spawn at random on x axis and offscreen on y axis
function createCar()
    car = {}
    car.x = love.math.random(screenWidth / 6 + 35, screenWidth - screenWidth / 6 - 65)
    car.y = love.math.random(-380, -350)
    car.width = 51
    car.height = 99
    car.speed = love.math.random(280, 335)
    -- Get a random number for the sprite in the sprite sheet
    carNo = love.math.random(1, 3)  
    -- Insert car into the table for drawing
    table.insert(listOfVehicles, car)
end
function createTruck()
    truck = {}
    truck.x = love.math.random(screenWidth / 6 + 35, screenWidth - screenWidth / 6 - 75)
    truck.y = love.math.random(-320, -300)
    truck.width = 55
    truck.height = 103
    truck.speed = love.math.random(240, 290)
    -- Get a random number for the sprite in the sprite sheet
    truckNo = love.math.random(1, 4)
    -- Insert truck into the table for drawing
    table.insert(listOfVehicles, truck)
end
function createDrunkCar()
    drunkCar = {}
    drunkCar.x = love.math.random(screenWidth / 6 + 35, screenWidth - screenWidth / 6 - 65)
    drunkCar.y = love.math.random(-345, -320)
    drunkCar.width = 45
    drunkCar.height = 86
    drunkCar.speed = love.math.random(260, 320)
    -- Random position to turn towards player
    drunkCar.turnTime = love.math.random(50, screenHeight / 2.2)
    -- Random number for the sprite in the sprite sheet
    drunkCarNo = love.math.random(1, 4)
    -- Insert car into the table for drawing
    table.insert(listOfVehicles, drunkCar)
end

-- Set beavior of the drunk car (move towards the player)
function drunkCarTurns(dt)
    -- When there's no collision, drive towards player
    if drunkCar.y > drunkCar.turnTime and player.collision == false then
        -- Check x position to turn right or left
        if drunkCar.x + drunkCar.width < player.x then
            drunkCar.x = drunkCar.x + 60 * dt
        elseif drunkCar.x > player.x + player.width then
            drunkCar.x = drunkCar.x - 60 * dt
        end
    elseif player.collision == true then
        drunkCar.x = drunkCar.x
    end
end

-- Generate bonus item. Add 100 score when pickup
function createCash()
    cash = {}
    cash.width = cashImg:getWidth()
    cash.height = cashImg:getHeight()
    cash.speed = 350
    cash.y = love.math.random(-330, -300)
    -- Set random spawn position away from the vehicles
    local vehicle = listOfVehicles[1]
    cash.x = love.math.random(screenWidth / 6 + (cash.width * 2), screenWidth - screenWidth / 6 - (cash.width * 2))
    if cash.x <= vehicle.x + vehicle.width + 10 and cash.x + cash.width >= vehicle.x - 10 then
        createCash()
    else
        table.insert(listOfItems, cash)    
    end
    
end

--Check if player collides with vehicles
function checkColl(player, listOfVehicles)
    local vehicle = listOfVehicles[1]
    -- If player hit a vehicle
    if player.x + 2 <= vehicle.x + vehicle.width - 2
    and player.x + player.width - 2 >= vehicle.x + 2
    and player.y + 2 <= vehicle.y + vehicle.height - 2
    and player.y + player.height - 2 >= vehicle.y + 2 then
        player.collision = true
        collision:play()
    end
end

-- Game lost. Stop player movement
function gameLost(listOfItems)
    player.turn_spd = 0
    player.speed = 0
    if listOfItems[1] ~= nil then
        listOfItems[1].speed = 0
    end
end
-- Game won. Stop all movement
function stopSpawn()
    generateVehicle = 4
    listOfVehicles[1].speed = 0
end
function gameWon(dt)
    player.turn_spd = 0
    player.speed = 0
    player.y = player.y - 500 * dt
    if listOfItems[1] == cash then
        listOfItems[1].speed = 0
    end
    bg.y = -800
end

-- Check collisions with item
function checkCollItem(player, listOfItems)
    local item = listOfItems[1]
    -- If player picks up item
    if player.x + 5 <= item.x + item.width
    and player.x + player.width - 5 >= item.x
    and player.y + 10 <= item.y + item.height
    and player.y + player.height - 5 >= item.y then
        --Increase score and disappear item
        score = score + 100
        player.pickup = true
        table.remove(listOfItems, 1)
    else
        player.pickup = false
    end
end

-- Set keys to quit and to play brake sound effect
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "down" then
        pBrake:play()
    end
end