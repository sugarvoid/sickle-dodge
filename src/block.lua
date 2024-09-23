Block = {}
Block.__index = Block


function Block:new(callback)
    local _block = setmetatable({}, Block)
    _block.image = love.graphics.newImage("asset/image/start_block.png")
    _block.x = 60
    _block.y = 70
    _block.w = _block.image:getWidth()
    _block.h = _block.image:getHeight()
    _block.ox = _block.w / 2
    _block.oy = _block.h / 2

    _block.hitbox = { x = _block.x, y = _block.y, w = _block.w, h = _block.h }

    _block.body = love.physics.newBody(world, _block.x, _block.y, "static")
    _block.shape = love.physics.newRectangleShape(_block.w, _block.h)



    _block.fixture = love.physics.newFixture(_block.body, _block.shape)
    --_block.body:setPosition(_block.x, _block.y)
    _block.body:setAwake(true)
    _block.fixture:setUserData({ obj_type = "StartBlock", owner = _block })

    _block.fixture:setCategory(5)
    _block.fixture:setMask(5)





    return _block
end

function Block:draw()
    love.graphics.draw(self.image, self.x, self.y, 0, 1, 1, self.ox, self.oy)
end
