
Obstacle = Class{}

function Obstacle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 5
    -- set some spacing between obstacle and Bit to make game playable
    self.trailing = 3
    
    -- avoid method being called recursively
    self:generateRandom()
end



-- random generation of obstacles

function Obstacle:generateRandom()
    -- seed the RNG so that calls to random are always random
    math.randomseed(os.time())
    
    random_number = math.random(-50,50)

    if random_number < 0 then 
        position = 1
    else
        position = 2
    end
    
    -- this positions the obstacle in the left lane
    if position == 1 then
        self.x = 0
        -- self.y = self.y + self.height 
        -- self.y = self.y + self.dy * dt
    -- this positions the obstacle in the right lane
    elseif position == 2 then
        self.x = self.width
        -- self.y = self.height + self.y
        -- self.y = self.y + self.dy * dt
    end
end


function Obstacle:update(dt)
    self.y = self.y + self.dy * dt
end

function Obstacle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end