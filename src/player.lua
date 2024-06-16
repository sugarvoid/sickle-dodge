
--Player.lua

Player = {}
Player.__index = Player

local anim8 = require("lib.anim8")

function Player:new()
    local instance = setmetatable({}, Player)
    instance.spr_sheet = love.graphics.newImage("asset/image/player_sheet.png")
    instance.image = love.graphics.newImage("asset/image/player.png")
    local s_grid = anim8.newGrid(16, 16, instance.spr_sheet:getWidth(),instance.spr_sheet:getHeight())
    instance.animations = {
        idle = anim8.newAnimation(s_grid(('1-6'), 1), 0.1),
        death = nil
    }
    --TODO: create way for current animation. and way to change them
    instance.alpha = 255
    instance.is_alive = true
    instance.is_ghost = false
    instance.x = 50
    instance.y = 10
    instance.is_moving_left=false
    instance.is_moving_right=false
    instance.tmr_standing_still = Timer:new(60*4, function() print("player frozen")end, true)
    instance.tmr_standing_still:start()
    instance.jumps_left = 2
    instance.speed = 100
    instance.vel_y = 50
    instance.vel_x = 0
    instance.max_speed = 120
    instance.acceleration = 30
    instance.friction = 3500
    instance.is_moving = false

    instance.w= instance.image:getWidth()
    instance.h= instance.image:getHeight()
    instance.hitbox = {x = instance.x, y= instance.y, w= instance.w-8, h =instance.h-3}
    instance.body = world:newRectangleCollider(instance.x, instance.y, instance.hitbox.w, instance.hitbox.h)
    instance.body:setType("dynamic")
    instance.body:setCollisionClass('Player')
    instance.body:setObject(self)
    
    instance.body:setFixedRotation(true)
    return instance
end

function Player:update(dt)
    if self.is_alive then
        self.animations.idle:update(dt)
        self.tmr_standing_still:update()
        self.is_moving = (self.is_moving_left or self.is_moving_right)
        if self.body:enter("Ground") then
            print("on floor")
            self.jumps_left = 2
        end

        if self.body:enter("Sickle") and not self.is_ghost then
            local death_x, death_y = self.body:getPosition()
            local collision_data = self.body:getEnterCollisionData("Sickle")
            local sickle = collision_data.collider:getObject()
            print(collision_data.collider:getObject())
            self.is_alive = false
            --sickle:on_hit()
            --TODO: Fix death marker placement. If player is on top of sickle, it spawns too high. 
            
            self.body:setAwake(false)
            self:die({death_x, death_y})
        end
                
        local vel_x, vel_y = self.body:getLinearVelocity()
        if self.is_moving_left then
        
        vel_x = clamp(-self.max_speed, vel_x + -self.acceleration, 0)
        self.body:setLinearVelocity(vel_x,vel_y)
            --self.body.x = self.body.x - self.speed * dt
        end
        if self.is_moving_right then
        vel_x = clamp(self.max_speed, vel_x + self.acceleration, 0)
        self.body:setLinearVelocity(vel_x,vel_y)
        --self.body.x = self.body.x + self.speed * dt
        end


            --print(self.is_moving)
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
    
            
end

function Player:jump()
    -- Jump
    local vel_x, vel_y = self.body:getLinearVelocity()
    if self.jumps_left == 2 then -- First jump
        self.body:applyLinearImpulse(0, -55, self.body:getX(), self.body:getY() + (self.h / 2))
        --vel_y = -50
        --self.y = self.y - 30
        self.jumps_left = self.jumps_left - 1
        --self.jump = false
        elseif self.jumps_left == 1 then -- Double jump
            self.body:setLinearVelocity(vel_x,0)
            self.body:applyLinearImpulse(0, (-55*0.8))
            self.jumps_left = self.jumps_left - 1
    end
end

function Player:die(pos)
    print("Player death animation")
    player_attempt = player_attempt + 1
    spawn_death_marker(pos[1], pos[2])
    -- go_to_gameover(false)
end

function Player:draw()
    --draw_hitbox(self, "#FF0000")
    love.graphics.setColor(love.math.colorFromBytes(255, 255, 255, self.alpha))
    self.animations.idle:draw(self.spr_sheet, self.x, self.y, 0, 1, 1, self.w/2, self.h/2)
    --love.graphics.draw(self.image, self.x, self.y, 0, 1, 1, self.w/2, self.h/2)
    love.graphics.setColor(255,255,255)
end


function Player:reset()

end