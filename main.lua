function love.load()
    require "helpers"
    require "conf"
    require "assets"

    -- Get screen width and height
    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()
    -- Assign background image and its properties into a table
    bg = {}
    bgImg = bgRoadStart
    bg.width = bgImg:getWidth()
    bg.height = bgImg:getHeight()
    bg.y = -bg.height -screenHeight * 2

    --Set up player properties in a table
    player = {}
    player.width = playerImg:getWidth()
    player.height = playerImg:getHeight()
    player.x = screenWidth / 2 - player.width / 2
    player.y = screenHeight / 1.3
    player.speed = 500
    player.turn_spd = 175
    -- Variables to check collisions and pickup items
    player.collision = false
    player.pickup = false
    
    -- Set distance traveled. It increases with every passed vehicle's speed
    distanceTraveled = 0  
    -- Set score, list of vehicles and list of items
    score = 0
    listOfVehicles = {}
    listOfItems = {}
    
    -- Pre-spawn first vehicle
    generateVehicle = spawnVehicle()
    -- Play music
    bgm:play()
    bgm:setLooping(true)
    bgm:setVolume(0.6)
end

function love.update(dt)
    -- Start time counter for race start
    time = love.timer.getTime()

    -- Set controls to move player left and right and speed up or brake
    if love.keyboard.isDown("right") and time > 3 then
        -- Limit movement to the right side of the road
        if player.x + player.width >= screenWidth - screenWidth / 6 then
            player.x = player.x
        else
            player.x = player.x + player.turn_spd * dt
        end
    elseif love.keyboard.isDown("left") and time > 3 then
        -- Limit movement to the left side of the road
        if player.x <= screenWidth / 6 then
            player.x = player.x
        else
            player.x = player.x - player.turn_spd * dt
        end
    end
    -- Accelerate
    if love.keyboard.isDown("up") and time > 3 and player.collision == false then
        player.speed = 800
    elseif love.keyboard.isDown("down") and time > 3 and player.collision == false then
    -- Brake
        player.speed = 300
    else
    -- Default speed
        player.speed = 500
    end

    -- Control movement of vehicles and respawn
    if generateVehicle == 3 and time > 5 and player.collision == false then
        truck.y = truck.y + truck.speed * dt
        -- Remove vehicles when offscreen, update traveled distance and spawn bonus item
        if truck.y > screenHeight then
            distanceTraveled = distanceTraveled + truck.speed
            table.remove(listOfVehicles, 1)
            spawnVehicle()
            if distanceTraveled > 400 then
                createCash()
            end
        end
    elseif generateVehicle == 2 and time > 5 and player.collision == false then
        drunkCar.y = drunkCar.y + drunkCar.speed * dt
        drunkCarTurns(dt)
        if drunkCar.y > screenHeight then
            distanceTraveled = distanceTraveled + drunkCar.speed
            table.remove(listOfVehicles, 1)
            spawnVehicle()
        end
    elseif generateVehicle == 1 and time > 5 and player.collision == false then
        car.y = car.y + car.speed * dt
        if car.y > screenHeight then
            distanceTraveled = distanceTraveled + car.speed
            table.remove(listOfVehicles, 1)
            spawnVehicle()
            if distanceTraveled > 400 then
                createCash()
            end
        end
    end

    -- Behavior of item
    if listOfItems[1] then
        cash.y = cash.y + cash.speed * dt
        -- Remove the item from table when it passes the screen
        if cash.y > screenHeight then
            table.remove(listOfItems, 1)
        end
    end
    -- Pick up item
    if listOfItems[1] then
        checkCollItem(player, listOfItems)
        if player.pickup == true then
            pickup:play()
        end
    end
    -- Check collision with vehicles
    checkColl(player, listOfVehicles)
    
    -- Start race
    if time >= 2 and time <= 2.2 then
        start1:play()
    elseif time >= 3 and time <= 3.2 then
        start1:play()
    elseif time >= 4 and time <= 4.2 then
        start2:play()
    elseif time > 4.2 and player.collision == false then
        bg.y = bg.y + player.speed * dt
    end
    -- Load second part of background
    if bg.y >= -5 and bg.y <= 5 then
        bgImg = bgRoadEnd
        bg.y = bg.y - bg.height
    end

    -- Lose condition
    if player.collision == true then
        -- Game Over
        gameLost(listOfItems)
        -- Behavior after collision: Separate vehicle from player
        listOfVehicles[1].y = listOfVehicles[1].y - listOfVehicles[1].speed * dt
    end
    -- Win condition
    if bgImg == bgRoadEnd and bg.y >= -800 then
        stopSpawn()
        gameWon(dt)
    end
end

function love.draw()
    -- Draw background        
    love.graphics.draw(bgImg, 0, bg.y, 0, screenWidth / bg.width)
    -- Draw score
    love.graphics.setColor(0, 0 , 0)
    love.graphics.rectangle("fill", 5, screenWidth / 15, 130, 35)
    love.graphics.setColor(181/255, 131/255, 45/255)
    love.graphics.setFont(gameFont)
    love.graphics.print("Score: " .. score, 10, screenWidth / 15)

    -- Draw controls info and credits
    if time < 4.2 then
        love.graphics.setColor(0, 0 , 0)
        -- For controls bg
        love.graphics.rectangle("fill", screenWidth / 5, screenHeight / 3, 480, 90)
        -- For credits bg
        love.graphics.rectangle("fill", screenWidth - screenWidth / 4, screenHeight - screenHeight / 5, 180, 100)
        love.graphics.setColor(181/255, 131/255, 45/255)
        love.graphics.setFont(winFont)
        love.graphics.printf("Use arrow keys to move \n Avoid vehicles and pick up cash", screenWidth / 5, screenHeight / 3, 480, "center")
        love.graphics.setFont(gameFont)
        love.graphics.printf("Music by: \n Zen_Man (pixabay.com)",  screenWidth - screenWidth / 4, screenHeight - screenHeight / 5, 180, "center")
    end
    
    -- Draw player and vehicles
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(playerImg, player.x, player.y)
    if generateVehicle == 3 then
        -- Draw trucks
        love.graphics.draw(truckSheet, trucks[truckNo], truck.x, truck.y)
    elseif generateVehicle == 2 then
        -- Draw cars
        love.graphics.draw(drunkCarSheet, drunkCars[drunkCarNo], drunkCar.x, drunkCar.y)
    else
        love.graphics.draw(carSheet, cars[carNo], car.x, car.y)
    end

    -- Draw item
    if listOfItems[1] ~= nil and time > 5 then
        love.graphics.draw(cashImg, cash.x, cash.y)
    end
   
    -- Win condition
    if bgImg == bgRoadEnd and bg.y >= -800 then
        love.graphics.setColor(0, 0 , 0)
        love.graphics.rectangle("fill", screenWidth - screenWidth / 1.23, screenHeight / 5, 500, 180)
        love.graphics.setColor(181/255, 131/255, 45/255)
        love.graphics.setFont(winFont)
        love.graphics.printf("Congratulations! \n You have won with a score of " .. score .. "\n Press Esc to quit", screenWidth - screenWidth / 1.23, screenHeight / 5, 500, "center")
        love.graphics.setColor(1, 1, 1, 1)
    end

    -- Lose condition
    if player.collision == true then
        love.graphics.setColor(0, 0 , 0)
        love.graphics.rectangle("fill", screenWidth - screenWidth / 1.23, screenHeight / 4, 500, 180)
        love.graphics.setColor(181/255, 131/255, 45/255)
        love.graphics.setFont(winFont)
        love.graphics.printf("You lost! \n Try again. \n \n Press Esc to quit", screenWidth - screenWidth / 1.23, screenHeight / 3.8, 500, "center")
        love.graphics.setColor(1, 1, 1, 1)
    end
end
