Sickle = {}
Sickle.__index = Sickle


local ice_sickle_sheet = love.graphics.newImage("asset/image/ice_sickle_sheet.png")
local sickle_grid = anim8.newGrid(16, 16, ice_sickle_sheet:getWidth(), ice_sickle_sheet:getHeight())
local break_sfx = love.audio.newSource("asset/audio/ice_break.wav", "static")

break_sfx:setVolume(0.1)

function Sickle:new(_x, _y, _moving_dir, _speed)
    local _sickle = setmetatable({}, Sickle)

    _sickle.animations = {
        default = anim8.newAnimation(sickle_grid(('1-2'), 1), 0.1),
        shatter = anim8.newAnimation(sickle_grid(('3-8'), 1), 0.02, 'pauseAtEnd')
    }
    _sickle.curr_animation = _sickle.animations["default"]
    _sickle.x = 0
    _sickle.y = 0
    _sickle.moving_dir = _moving_dir
    _sickle.alive = true
    _sickle.rotation = 0
    _sickle.life_timer = 300
    _sickle.speed = _speed
    _sickle.max_speed = 200
    _sickle.acceleration = 4000
    _sickle.friction = 3500
    _sickle.w, _sickle.h = _sickle.curr_animation:getDimensions()
    _sickle.hitbox = { x = _sickle.x, y = _sickle.y, w = _sickle.w - 12, h = _sickle.h - 3 }
    _sickle.body = world:newRectangleCollider(_sickle.x, _sickle.y, _sickle.w - 12, _sickle.h - 3)
    _sickle.body:setType("dynamic")
    _sickle.body:setCollisionClass("Sickle")
    _sickle.body:setGravityScale(0)
    _sickle.body:setObject(_sickle)
    _sickle.body:setFixedRotation(true)
    _sickle.body:setPosition(_x, _y)
    _sickle:set_rotation()
    _sickle.body:setLinearVelocity(_sickle.speed * _sickle.moving_dir[1], _sickle.speed * _sickle.moving_dir[2])

    return _sickle
end

function Sickle:update(dt)
    self.curr_animation:update(dt)
    self.x = self.body:getX()
    self.y = self.body:getY()
    self.life_timer = self.life_timer - 1

    if self.body:enter("Ground") then
        self:shatter()
        break_sfx:stop()
        break_sfx:play()
    end

    if self.curr_animation.status == "paused" then
        self.life_timer = 0
    end
end

function Sickle:shatter()
    self.alive = false
    self.body:setLinearVelocity(0, 0)
    self.curr_animation = self.animations["shatter"]
    self.body:setActive(false)
end

function Sickle:draw()
    self.curr_animation:draw(ice_sickle_sheet, self.x, self.y, math.rad(self.rotation), 1, 1, self.w / 2, self.h / 2)
end

function Sickle:set_rotation()
    if do_tables_match(self.moving_dir, { 1, 0 }) then
        self.body:setAngle(math.rad(90))
        self.rotation = 0
    elseif do_tables_match(self.moving_dir, { -1, 0 }) then
        self.body:setAngle(math.rad(90))
        self.rotation = 180
    elseif do_tables_match(self.moving_dir, { 0, 1 }) then
        self.rotation = 90
    end
end
