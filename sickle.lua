
--Sickle.lua

Sickle = {}
Sickle.__index = Sickle


--love.graphics.setDefaultFilter("nearest", "nearest")

-- local Sickle_img = love.graphics.newImage("Sickle.png")



function Sickle:new()
    local instance = setmetatable({}, Sickle)
    instance.image = love.graphics.newImage("ice_sickle.png")
    instance.x = 0
    instance.y = 0
    instance.moving_dir = {0,0}
    instance.rotation = 0
    instance.life_timer = 120
    instance.speed = nil
    

    instance.vel_y = 0
    instance.vel_x = 0
    instance.max_speed = 200
    instance.acceleration = 4000
    instance.friction = 3500

    instance.w= instance.image:getWidth()
    instance.h= instance.image:getHeight()
    instance.hitbox = {x = instance.x, y= instance.y, w= instance.w-8, h =instance.h-3}
    instance.body = world:newRectangleCollider(instance.x, instance.y, instance.hitbox.w, instance.hitbox.h)
    instance.body:setType("kinematic")
    instance.body:setCollisionClass('Sickle')
    instance.body:setObject(self)

    --instance.body:setX(instance.x)
    --instance.body:setY(instance.y)
    --self.body:setY() = instance.y

    return instance
end

function Sickle:update(dt)

    --vel_x = self.speed
    self.body:setLinearVelocity((self.speed * self.moving_dir[1]),self.speed * self.moving_dir[2])
    self.x = self.body:getX()
    self.y = self.body:getY()
    --print(self.x, self.y)
            
end


function Sickle:on_hit()
    print("I hit the player")
end

function Sickle:draw()
    --draw_hitbox(self, "#FF0000")
    love.graphics.draw(self.image, self.x, self.y, 0, 1, 1, self.w/2, self.h/2)
end



function Sickle:reset()

end