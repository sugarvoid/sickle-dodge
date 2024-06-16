
--Player.lua

Player = {}
Player.__index = Player


love.graphics.setDefaultFilter("nearest", "nearest")

-- local player_img = love.graphics.newImage("player.png")



function Player:new()
    local instance = setmetatable({}, Player)
    instance.image = love.graphics.newImage("player.png")
    instance.x = 50
    instance.y = 10
    instance.is_moving_left=false
    instance.is_moving_right=false
    
    --instance.jump= false
    instance.jumps_left = 2
    instance.speed = 140
    instance.vel_y = 50
    instance.vel_x = 0
    instance.max_speed = 200
    instance.acceleration = 4000
    instance.friction = 3500

    instance.w= instance.image:getWidth()
    instance.h= instance.image:getHeight()
    instance.hitbox = {x = instance.x, y= instance.y, w= instance.w-8, h =instance.h-3}
    instance.body = world:newRectangleCollider(instance.x, instance.y, instance.hitbox.w, instance.hitbox.h)
    instance.body:setType("dynamic")
    instance.body:setCollisionClass('Player')
    instance.body:setObject(self)
    return instance
end

function Player:update(dt)

    if self.body:enter("Ground") then
        print("on floor")
        self.jumps_left = 2
    end

    if self.body:enter("Sickle") then
        local collision_data = self.body:getEnterCollisionData("Sickle")
        local sickle = collision_data.collider:getObject()
        print(collision_data.collider:getObject())
        --sickle:on_hit()
        self:die()
    end
                
    local vel_x, vel_y = self.body:getLinearVelocity()
    --local vel_y=0
             if self.is_moving_left then
                vel_x = -self.speed
                self.body:setLinearVelocity(vel_x,vel_y)
                 --self.body.x = self.body.x - self.speed * dt
             end
             if self.is_moving_right then
                vel_x = self.speed
                self.body:setLinearVelocity(vel_x,vel_y)
                --self.body.x = self.body.x + self.speed * dt
             end

            

            
    --         self.x = (self.x + dx) --* dt
    --         self.y = (self.y + dy) --* dt

    --         if not check_collision(self.hitbox, platfrom.hitbox) then
    --             --self.vel_y = self.vel_y + 60
    --             --dy = dy + self.vel_y
    --             self.y = self.y + 70 * dt
    --             else
    --                 self.jumps_left = 2
    --         end

            
            --self.hitbox.x = self.x+3
            --self.hitbox.y = self.y+2
            self.x = self.body:getX()
            self.y = self.body:getY()
            --print(self.x, self.y)
            
end

function Player:jump()
    -- Jump
    if self.jumps_left == 2 then
        print("jump")
        self.body:applyLinearImpulse(0, -55)
        --vel_y = -50
        --self.y = self.y - 30
        self.jumps_left = self.jumps_left - 1
        --self.jump = false
        elseif self.jumps_left == 1 then
            print("double jump")
            self.body:applyLinearImpulse(0, (-55*0.8))
            self.jumps_left = self.jumps_left - 1
    end
end

function Player:die()
    print("Player death animation")
end

function Player:resetPos()
    self.x = -400
    self.y= 300
end

function Player:draw()
    --draw_hitbox(self, "#FF0000")
    love.graphics.draw(self.image, self.x, self.y, 0, 1, 1, self.w/2, self.h/2)
end



function Player:reset()

end