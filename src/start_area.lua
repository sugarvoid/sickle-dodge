StartArea = {}
StartArea.__index = StartArea


function StartArea:new(callback)
    local _start_area = setmetatable({}, StartArea)
    _start_area.image = love.graphics.newImage("asset/image/start_start_area.png")
    _start_area.x = 60
    _start_area.y = 85
    _start_area.w = _start_area.image:getWidth()
    _start_area.h = _start_area.image:getHeight()
    _start_area.ox = _start_area.w / 2
    _start_area.oy = _start_area.h / 2

    _start_area.hitbox = { x = _start_area.x, y = _start_area.y, w = _start_area.w, h = _start_area.h }

    _start_area.body = love.physics.newBody(world, _start_area.x, _start_area.y, "static")
    _start_area.shape = love.physics.newRectangleShape(_start_area.w, _start_area.h)



    _start_area.fixture = love.physics.newFixture(_start_area.body, _start_area.shape)
    --_start_area.body:setPosition(_start_area.x, _start_area.y)
    _start_area.body:setAwake(true)
    _start_area.fixture:setUserData({ obj_type = "StartStartArea", owner = _start_area })

    _start_area.fixture:setCategory(5)
    _start_area.fixture:setMask(1)





    return _start_area
end

function StartArea:draw()
    love.graphics.rectangle("line", self.x, self.y, 16, 16)
    --love.graphics.draw(self.image, self.x, self.y, 0, 1, 1, self.ox, self.oy)
end
