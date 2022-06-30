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

-- score tracking
local score = 0


-- set up our sound effects; later, we can just index this table and
-- call each entry's `play` method
    sounds = {
        ['move'] = love.audio.newSource('sounds/byte_move.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score_point.wav', 'static'),
        ['collision'] = love.audio.newSource('sounds/collision.wav', 'static')
    }

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
    love.graphics.setFont(smallFont)


    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true,
        canvas = false
    })


    byte = Bit(0, VIRTUAL_HEIGHT - 50, VIRTUAL_WIDTH/2, VIRTUAL_WIDTH/2)
    
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
        sounds['move']:play()
    elseif love.keyboard.isDown('right') and byte.x == 0 then
        byte.x = byte.x + VIRTUAL_WIDTH / 2
        byte.y = VIRTUAL_HEIGHT - 50
        byte.width = VIRTUAL_WIDTH / 2
        byte.height = VIRTUAL_HEIGHT / 2
        sounds['move']:play()
    end

    if gameState == 'start' then
        obstacleGeneration()
        -- this is to loop through the list of obstacles and update falling speed of obstacle
        for _, i in ipairs(obstacleList) do
            i:update(dt)        
    
            if i.y > VIRTUAL_HEIGHT and i.didCountPoint == false then
                sounds['score']:play()
                score = score + 1
                i.didCountPoint = true
                return score
            elseif byte:collides(i) == true then
                sounds['collision']:play()
                gameState = 'done'
            end
        end
    end
end 

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'done' then 
            gameState = 'start'
            score = 0
            numOfObstacles = 1
            obstacleList = {}
        elseif gameState == 'welcome' then
            gameState = 'start'
            score = 0
           --numOfObstacles = 1
           --obstacleList = {}
        end
    end
end


function love.draw()
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    -- begin drawing with push, in our virtual resolution
    push:start()

    -- before starting game
    if gameState == 'welcome' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Welcome to Doge!', 0, 25, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Move left and right to dodge the obstacles!', 0, 50, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to begin!', 0, 75, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'start' then 
        displayScore()
        byte:render()
        for _, i in ipairs(obstacleList) do
            i:render()
        end
    elseif gameState == 'done' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Score to beat: ' .. tostring(score), 0, 30, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to restart!', 0, 50, VIRTUAL_WIDTH, 'center')
    end
    
    push:finish()
end


function displayScore()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255/255, 0, 255/255)
    love.graphics.print('Score: ' .. tostring(score))
    love.graphics.setColor(255, 255, 255, 140/255)
end

function obstacleGeneration()
    if numOfObstacles == 1 then
        obstacleList[numOfObstacles] = Obstacle(0, -VIRTUAL_WIDTH/2, VIRTUAL_WIDTH/2, VIRTUAL_WIDTH/2)
        numOfObstacles = numOfObstacles + 1
    else
        if obstacleList[numOfObstacles - 1].y > obstacleList[numOfObstacles - 1].height + obstacleList[numOfObstacles -1].trailing then
            obstacleList[numOfObstacles] = Obstacle(0, -VIRTUAL_WIDTH/2, VIRTUAL_WIDTH/2, VIRTUAL_WIDTH/2)
            --table.insert(obstacleList,Obstacle:new(0, 0, VIRTUAL_WIDTH/2, VIRTUAL_WIDTH/2))
            numOfObstacles = numOfObstacles + 1
        end
    end
end

