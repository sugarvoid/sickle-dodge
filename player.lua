
--Player.lua

Player = {}
Player.__index = Player


love.graphics.setDefaultFilter("nearest", "nearest")

-- local player_img = love.graphics.newImage("player.png")



function Player:new()
    local instance = setmetatable({}, Player)
    instance.image = love.graphics.newImage("player.png")
    instance.x = 50
    instance.y = 105
    instance.is_moving_left=false
    instance.is_moving_right=false
    
    instance.jump= false
    instance.jumps_left = 2
    instance.speed = 150
    instance.vel_y = 25
    instance.vel_x = 0
    instance.max_speed = 200
    instance.acceleration = 4000
    instance.friction = 3500

    instance.w= instance.image:getWidth()
    instance.h= instance.image:getHeight()
    instance.hitbox = {x = instance.x, y= instance.y, w= instance.w-8, h =instance.h-3}
    instance.physics = {}
    instance.physics.body = love.physics.newBody(world, instance.x, instance.y, "dynamic")
    instance.physics.body:setFixedRotation(true)
    instance.physics.shape = love.physics.newRectangleShape(instance.hitbox.w, instance.hitbox.h)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)

    return instance
end

function Player:update(dt)
    self:sync_physics()
    -- dx=0
    --         dy=0
    --         if self.is_moving_left then
    --             self.x = self.x - self.speed * dt
    --         end
    --         if self.is_moving_right then
    --             self.x = self.x + self.speed * dt
    --         end

    --         -- Jump
    --         if self.jump and self.jumps_left >=1 then
    --             self.vel_y = -7
    --             self.y = self.y - 30
    --             self.jumps_left = self.jumps_left - 1
    --             self.jump = false 
    --         end

    --         self.x = (self.x + dx) --* dt
    --         self.y = (self.y + dy) --* dt

    --         if not check_collision(self.hitbox, platfrom.hitbox) then
    --             --self.vel_y = self.vel_y + 60
    --             --dy = dy + self.vel_y
    --             self.y = self.y + 70 * dt
    --             else
    --                 self.jumps_left = 2
    --         end

            
            self.hitbox.x = self.x+3
            self.hitbox.y = self.y+2
end

function Player:sync_physics()
    self.x = self.physics.body:getX()
    self.y = self.physics.body:getY()
    self.physics.body:setLinearVelocity(self.vel_x, self.vel_y)
end

function Player:resetPos()
    self.x = -400
    self.y= 300
end

function Player:draw()
    draw_hitbox(self, "#FF0000")
    love.graphics.draw(self.image, self.x, self.y)
end



function Player:reset()

end