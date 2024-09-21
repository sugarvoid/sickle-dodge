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

    _platform.body = love.physics.newBody(world, _platform.x, _platform.y, "static")
    _platform.shape = love.physics.newRectangleShape(_platform.w, _platform.h)

    

    _platform.fixture = love.physics.newFixture(_platform.body, _platform.shape)
    --_platform.body:setPosition(_platform.x, _platform.y)
    _platform.body:setAwake(true)
    _platform.fixture:setUserData({obj_type="Ground", owner=_platform})

    _platform.fixture:setCategory(3)
    _platform.fixture:setMask(3)


    


    return _platform
end

function Platform:draw()
    love.graphics.draw(self.image, self.x, self.y)
    draw_hitbox(self.hitbox, "#EE4B2B")
end
