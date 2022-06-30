

push = require 'push'
Class = require 'class'

require 'Bit'
require 'Obstacle'


--size of our actual window
WINDOW_WIDTH = 200
WINDOW_HEIGHT = 400

-- size we're trying to emulate with push
VIRTUAL_WIDTH = 100
VIRTUAL_HEIGHT = 200

-- create array to track generated obstacles
obstacleList = {}

numOfObstacles = 1

--[[
    Called just once at the beginning of the game; used to set up
    game objects, variables, etc. and prepare the game world.
]]
function love.load()
    -- set love's default filter to "nearest-neighbor", which essentially
    -- means there will be no filtering of pixels (blurriness), which is
    -- important for a nice crisp, 2D look
    love.graphics.setDefaultFilter('nearest', 'nearest')


    love.window.setTitle('Doge')

    smallFont = love.graphics.newFont('font.ttf', 8)
    scoreFont = love.graphics.newFont('font.ttf', 10)

    love.graphics.setFont(smallFont)


    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true,
        canvas = false
    })


    byte = Bit(0, VIRTUAL_HEIGHT - 50, VIRTUAL_WIDTH/2, VIRTUAL_WIDTH/2)
    

    --obstacle_random = obstacle:generate_random()

    gameState = 'welcome'

end


function love.update(dt)
       -- regardless of state
       if love.keyboard.isDown('left') and byte.x > 0 then
        -- byte is on the left side and needs to be moved to the right
        byte.x = 0
        byte.y = VIRTUAL_HEIGHT - 50
        byte.width = VIRTUAL_WIDTH / 2
        byte.height = VIRTUAL_HEIGHT / 2
        
    elseif love.keyboard.isDown('right') and byte.x == 0 then
        byte.x = byte.x + VIRTUAL_WIDTH / 2
        byte.y = VIRTUAL_HEIGHT - 50
        byte.width = VIRTUAL_WIDTH / 2
        byte.height = VIRTUAL_HEIGHT / 2
    end



    --obstacle:generateRandom(dt)
    if gameState == 'start' then
        obstacleGeneration()
    end

    -- this is to loop through the list of obstacle and update falling speed of obstacle
    for _, i in ipairs(obstacleList) do
        -- print('update dt')
        i:update(dt)

        if byte:collides(i) == true then
            gameState = 'done'
        end

    end

end 

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        gameState = 'start'
    end
end


function love.draw()
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    -- begin drawing with push, in our virtual resolution
    push:start()
 
    -- display FPS for debugging; simply comment out to remove
    -- displayFPS()


    -- before starting game
    if gameState == 'welcome' then
    love.graphics.setFont(smallFont)
        love.graphics.printf('Welcome to Doge!', 0, 25, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Move left and right to dodge the obstacles!', 0, 50, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to begin!', 0, 75, VIRTUAL_WIDTH, 'center')
    
    elseif gameState == 'start' then
        -- display score 
        displayScore()
        byte:render()
        -- obstacle:render()

        for _, i in ipairs(obstacleList) do
            --print('render')
            i:render()
        end



    elseif gameState == 'done' then
        print('game over')
        --love.graphics.setFont(largeFont)
        --love.graphics.printf('Try to beat your score of ' .. tostring(displayScore) '..',
        --    0, 10, VIRTUAL_WIDTH, 'center')   
        --love.graphics.setFont(smallFont)
        --love.graphics.printf('Press Enter to restart!', 0, 30, VIRTUAL_WIDTH, 'center')
    end

    -- end our drawing to push
    push:finish()
end



--[[
    Renders the current FPS.
]]
function displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255/255, 0, 255/255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
    love.graphics.setColor(255, 255, 255, 255)
end


function displayScore()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255/255, 0, 255/255)
    love.graphics.print('Score: ')
    love.graphics.setColor(255, 255, 255, 255)
end

function obstacleGeneration()
    -- check for location of y before deploying new obstacle
    -- numOfObstacles = 0
    -- print('num of obstacles: ')
    -- print(numOfObstacles)
    if numOfObstacles == 1 then
        -- print("inside of the 0 check for obstacle generation")
--[[         obstacle = Obstacle(0, -VIRTUAL_WIDTH/2, VIRTUAL_WIDTH/2, VIRTUAL_WIDTH/2)
        obstacleList[numOfObstacles] = obstacle ]]
        obstacleList[numOfObstacles] = Obstacle(0, -VIRTUAL_WIDTH/2, VIRTUAL_WIDTH/2, VIRTUAL_WIDTH/2)
        numOfObstacles = numOfObstacles + 1
    else
        -- print("inside of the else statement obstacle generation")
        if obstacleList[numOfObstacles -1 ].y > obstacleList[numOfObstacles - 1].height + obstacleList[numOfObstacles -1].trailing then
            obstacleList[numOfObstacles] = Obstacle(0, -VIRTUAL_WIDTH/2, VIRTUAL_WIDTH/2, VIRTUAL_WIDTH/2)
            --table.insert(obstacleList,Obstacle:new(0, 0, VIRTUAL_WIDTH/2, VIRTUAL_WIDTH/2))
            numOfObstacles = numOfObstacles + 1
        end
    end
    
    -- reference last position of y in the array to deploy new obstacle
end
