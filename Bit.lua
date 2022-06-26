--[[

This is the Bit class which represents the object the user moves to avoid obstacles.

Bit will only move in the left and right directions and score a point for each obstacle
the Bit clears.

]]

Bit = Class{}

function Bit:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

end

function Bit:collides(obstacle)
    -- if y of obstacle is greater than y of the Bit then that means they collides (from top-down)
    -- if x of obstacle is the same as x of the Bit and both objects are occupying the range of y then that means a collision
    if obstacle.y > self.y and obstacle.x == self.x then
    return true
    end
end

function Bit:scores(obstacle)
    if obstacle.y < self.y and obstacle.x ~= self.y then
    score = score + 1
    return score
end
end

function Bit:reset()
    self.y = VIRTUAL_HEIGHT - self.y
    self.x = VIRTUAL_HEIGHT - self.x
    self.dx = 0
    self.dy = 0
end


function Bit:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end