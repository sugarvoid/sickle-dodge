--Sickle = {}
--Sickle.__index = Sickle

Sickle = Object:extend("Sickle")


local ice_sickle_sheet = love.graphics.newImage("asset/image/ice_sickle_sheet.png")
local sickle_grid = anim8.newGrid(16, 16, ice_sickle_sheet:getWidth(), ice_sickle_sheet:getHeight())
local break_sfx = love.audio.newSource("asset/audio/ice_break.wav", "static")

break_sfx:setVolume(0.1)


function Sickle:new(_x, _y, _moving_dir, _speed)
    --local _sickle = setmetatable({}, Sickle)

    self.animations = {
        default = anim8.newAnimation(sickle_grid(('1-2'), 1), 0.1),
        shatter = anim8.newAnimation(sickle_grid(('3-8'), 1), 0.02, 'pauseAtEnd')
    }
    self.curr_animation = self.animations["default"]
    self.x = 0
    self.y = 0
    self.moving_dir = _moving_dir
    self.alive = true
    self.rotation = 0
    self.life_timer = 300
    self.speed = _speed
    self.w, self.h = self.curr_animation:getDimensions()
    self.body = love.physics.newBody(world, self.x, self.y, "dynamic")
    self.shape = love.physics.newRectangleShape(self.w - 12, self.h - 3)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData({ obj_type = "Sickle", owner = self })
    self.fixture:setCategory(1)
    self.fixture:setMask(1)
    self.body:setGravityScale(0)
    self.body:setFixedRotation(true)
    self.body:setPosition(_x, _y)
    self:set_rotation()
    self.body:setLinearVelocity(self.speed * self.moving_dir[1], self.speed * self.moving_dir[2])
    return self
end

function Sickle:update(dt)
    self.curr_animation:update(dt)
    if self.alive then
        self.x = self.body:getX()
        self.y = self.body:getY()
    end

    self.life_timer = self.life_timer - 1

    if self.curr_animation.status == "paused" then
        self.life_timer = 0
    end
end

function Sickle:on_ground_contact()
    self:shatter()
end

function Sickle:shatter()
    self.alive = false
    self.body:destroy()
    self.curr_animation = self.animations["shatter"]
    break_sfx:stop()
    break_sfx:play()
end

function Sickle:draw()
    --TODO: Only draw if on screen
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
