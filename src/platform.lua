
--platform.lua

Platform = {}
Platform.__index = Platform


function Platform:new()
    local instance = setmetatable({}, Platform)
    instance.image = love.graphics.newImage("asset/image/platform.png")


    instance.x = 40
    instance.y = 120

    instance.w = instance.image:getWidth()
    instance.h = instance.image:getHeight()
    --instance.physics = {}


    instance.hitbox = { x = instance.x, y = instance.y, w = instance.w, h = instance.h }
    instance.body = world:newRectangleCollider(instance.hitbox.x, instance.hitbox.y, instance.hitbox.w, instance.hitbox
    .h)
    instance.body:setType("static")
    instance.body:setCollisionClass('Ground')






    return instance
end

function Platform:update(dt)

            
end




function Platform:draw()
    love.graphics.draw(self.image, self.x, self.y)
end
