# Cars
### Video Showcase:  <https://youtu.be/C4jc8pcB5AE>
### Description:
A game using Lua with LÖVE

### Overview:
This project is inspired in the old racing games from Atari console. It consists on a Top-down 2D Racing game where the main goal is to get to the finish line and avoid incoming vehicles. In the road there are random bonus item that the player can pick up and increase his score. When the player crashes against other vehicle, the game is over. When the player reaches the finish line the game is won with the current score.

There are three types of vehicles that are randomly generated (Cars, Trucks and Drunk Cars) and spawn at random positions, one after the other. The bonus item also spawns at random position.

The game controls are the arrow keys (up, down, left, right) for player movement, and Escape key to quit.


### Project Folders:
### -assets
This folder stores all the in-game assets that are drawn in the screen when the game runs. There is a sprite for the bonus item (which is essentially cash), and a couple of sheets for the cars and for the trucks. Those are basically the skins that will be picked and drawn at random (as quads) to create the feeling of diversity when one of the vehicles pops on screen. They are all treated as the same "object" by their type. 

There are also two images `RoadStart.png` and `RoadEnd.png` that are used to draw the background. To create the sensation of moving forwards, instead of moving the player the images scroll down on the y axis. I decided to create two of them since merging them into one resulted in a very large image (too many pixels) and that created a conflict of drawing the background when the game runs. So instead of a single background image, it gets replaced by `RoadEnd.png` when `RoadStart.png` passes over the screen.

There is also an icon for the application window, and the specific font used in game to show the score, the instructions and credits.

### -sounds
This folder stores all in game sounds. As it is a short game there aren't many sounds to play, only for the basic events like collisions, pickup, brake, and background music. There's also a beep sound for indicating the start of the race.


### Project Files:
### -assets.lua
This file is for loading and setting up all assets mentioned above. The fonts, the sprites and quads, the sounds and the background images, they all get assigned into variables and tables for use in the `main.lua` file. I decided to treat them apart to clear up the main file from some code lines.

### -conf.lua
This short file is to set up the game configuration for the window title and icon. I did not set the Fullscreen mode so the game will run in a window.

### -helpers.lua
This file is to set all the functions in order. I decided to treat them apart to clear up the main file from some code lines and make it easier to read. 
So, there is a first a function called `spawnVehicle()` to generate a random vehicle to draw on screen based on a number (1 to 3). The resulting number is returned for further work (as to draw and update the vehicle's behavior). The vehicle generated can be a car, a truck or a drunk car, and each of them have their very own characteristics that you can see in the following `createTruck(), createCar()` and `createDrunkCar()` functions.

The `createTruck(), createCar()` and `createDrunkCar()` functions basically set up the vehicle that will be drawn lately in the code and insert it into a table called `listOfVehicles`. To create this feeling of change and diversity all of the vehicles' x and y positions and the speed they move are randomly generated. Even for the same type of vehicle (a truck for example) the spawn position and the speed it moves, will differ every time that is generated. 
In addition, the `drunkCar` table includes a `turnTime` variable which basically sets a point on screen where the vehicle begins to move towards the player. This behavior is set in the `drunkCarTurns()` function to add some difficulty to the game.

The `createCash()` function is very similar to the previous ones to create the vehicles. This one is to set up the bonus item that player can pick up when it spawns. Similarly, to the vehicles the position will be randomly generated on the x and y axis and if it detects that can collide with a vehicle, it will call a recursion on this `createCash()` function to generate another random location.

There is also a function called `checkColl()` to check if there is any collision between the player's vehicle and the randomly generated vehicles. When a collision is detected a "crash" sound is played and the game will be lost. When the game when is lost, a `gameLost()` function is called and everything freezes, including the player's movement and controls. The same thing happens when the player gets to the finish line and the game is won.

Next there is a function `checkCollItem()` which basically checks if the player's vehicle collides with the bonus item. If it does then the score increases in 100 points and the item disappear.

Lastly there is the `love.keypressed()` function which is set to "listen" to two keys: the down arrow key (as with the controls) to play the brake sound, and the `Escape` key to quit the application.

### -main.lua
In this file, because of the Lua programming language there is three functions: `love.load(), love.update()` and `love.draw()`
Inside `love.load()` the required files (helpers, assets, and conf) are included first. Then a table called `bg` is created to store the background image properties.

Another table called `player` is created immediately after to set up all the player's vehicle properties like the position on x and y axis, the height and width of the sprite assigned, the moving speed (forward and to the sides) and a couple Booleans to determine if there is a collision with another vehicle or if it picks up an item.

Then a couple variables to set the distance traveled by the player and to keep track of the score, along with two empty tables that will be filled/emptied with vehicles and the bonus item as they will be generated later on.

Lastly the background music is set up to play in a loop and the first vehicle is generated with a call to the `spawnVehicle()` function.

In the second part, the `love.update()` function starts with a time counter which will indicate when the race begins. After that, there is a set of conditionals that set up the keyboard controls so the player's vehicle can move left/right, accelerate and brake. There is also a move limit where the player vehicle cannot go, for example, outside of the road.

After keyboard controls are set, it comes the random vehicle generation and its movement. There are three types of vehicles (as said previously) and they all spawn after 5 seconds have passed. Their movement is downwards on the y axis and every time a vehicle passes over the screen the variable `distanceTraveled` is updated (adding the speed of the named vehicle) and the vehicle is removed from the table called `listOfVehicles`. 
One thing to note is the call to the `createCash()` function in two of the three vehicle's scenarios when distance traveled is over 400. That call will generate the bonus item every time for the player to pick up. The behavior of the bonus item is defined afterwards which move in a simple straight line downwards on the y axis. After the bonus item pass over, if not picked up, it gets removed from the table called `listOfItems`.

After all is set, then a couple functions are called to check if there is any collision with vehicles or with the bonus item for pick it up. When the item is picked up it plays a sound effect.

Next the race starts. After a couple seconds (and a couple sounds) the background movement begins. When it reaches the top limit on the y axis, the background image changes to the one with the finish line drawn on it.

Then the win and lose conditions are set so the game stops if it collides with a vehicle and the game ends when the player reach the finish line drawn in the background image.

In the last part of the file there is the `love.draw()` function and it starts by drawing the background (passing the variable bgImg as an argument). Then the score is drawn with a black rectangle in the back for easy reading. The font and color are set, and also the credits for the music used in the game.

After that, all the vehicles are drawn according to the `generateVehicle` variable and the sprite sheets previously loaded in the `assets.lua` file. The player vehicle is also drawn taking as argument the playerImg variable and coordinates. After that, there's a check if there is an item in the table `listOfItems` to be drawn on screen too.

In the end there is a Win/Lose check so the game can pop the appropriate Congratulations/Game Over message on screen.

And that's all for this simple racing game. It is open to add some more extra features in the future like more vehicles popping on screen simultaneously (to add some difficulty), or different types of objects like oil spots and roadblocks that the player's vehicle should also avoid. Maybe a fuel meter could be interesting so the vehicle stops when the tank is empty and the game is over.
