
--platform.lua

Platform = {}
Platform.__index = Platform


function Platform:new()
    local _platform = setmetatable({}, Platform)
    _platform.image = love.graphics.newImage("asset/image/platform.png")
    _platform.x = 40
    _platform.y = 120
    _platform.w = _platform.image:getWidth()
    _platform.h = _platform.image:getHeight()
    _platform.hitbox = { x = _platform.x, y = _platform.y, w = _platform.w, h = _platform.h }
    _platform.body = world:newRectangleCollider(_platform.hitbox.x, _platform.hitbox.y, _platform.hitbox.w, _platform.hitbox.h)
    _platform.body:setType("static")
    _platform.body:setCollisionClass("Ground")
    _platform.body:setObject(_platform)

    return _platform
end


function Platform:draw()
    love.graphics.draw(self.image, self.x, self.y)
end
