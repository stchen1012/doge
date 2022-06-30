Obstacle = Class{}

function Obstacle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 40
    self.didCountPoint = false
    -- set some spacing between obstacle and Bit to make game playable
    self.trailing = 13    
    -- avoid method being called recursively
    self:generateRandom()
end

function Obstacle:generateRandom()
    -- seed the RNG so that calls to random are always random
    math.randomseed(os.time())
    
    random_number = math.random(-10,10)

    if random_number < 0 then 
        position = 1
    else
        position = 2
    end
    
    -- this positions the obstacle in the left lane
    if position == 1 then
        self.x = 0
    -- this positions the obstacle in the right lane
    elseif position == 2 then
        self.x = self.width
    end
end


function Obstacle:update(dt)
    self.y = self.y + self.dy * dt
end

function Obstacle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end