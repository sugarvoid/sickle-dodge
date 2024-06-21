--Sickle.lua

Sickle = {}
Sickle.__index = Sickle


local ice_sickle_sheet= love.graphics.newImage("asset/image/ice_sickle_sheet.png")
local sickle_grid = anim8.newGrid(16, 16, ice_sickle_sheet:getWidth(), ice_sickle_sheet:getHeight())

function Sickle:new(_x, _y, _moving_dir, _speed)
    local instance = setmetatable({}, Sickle)

    instance.animations = {
        regular = anim8.newAnimation(sickle_grid(('1-2'), 1), 0.1),
        shatter = anim8.newAnimation(sickle_grid(('3-8'), 1), 0.02, 'pauseAtEnd')
    }

    instance.curr_animation = instance.animations["regular"]

    --instance.image = love.graphics.newImage("asset/image/ice_sickle.png")
    instance.x = 0
    instance.y = 0
    instance.moving_dir = _moving_dir
    instance.alive = true
    instance.rotation = 0
    instance.life_timer = 200
    instance.speed = _speed
    instance.max_speed = 200
    instance.acceleration = 4000
    instance.friction = 3500
    instance.w = 16--instance.image:getWidth()
    instance.h = 16--instance.image:getHeight()
    instance.hitbox = { x = instance.x, y = instance.y, w = instance.w - 12, h = instance.h - 3 }
    instance.body = world:newRectangleCollider(instance.x, instance.y, instance.w - 12, instance.h - 3)
    instance.body:setType("dynamic")
    instance.body:setCollisionClass("Sickle")
    instance.body:setGravityScale(0)
    instance.body:setObject(instance)
    instance.body:setFixedRotation(true)
    instance.body:setPosition(_x, _y)
    instance:set_rotation()
    instance.body:setLinearVelocity(instance.speed * instance.moving_dir[1], instance.speed * instance.moving_dir[2])

    return instance
end

function Sickle:update(dt)
    self.curr_animation:update(dt)

    
    self.x = self.body:getX()
    self.y = self.body:getY()
    self.life_timer = self.life_timer - 1
    

    if self.body:enter("Ground") then
       self:shatter()

    end
    if self.curr_animation.status == "paused" then
        self.life_timer = 0

    end
end

function Sickle:shatter()
     --todo: Play break animation
     self.alive = false
     self.body:setLinearVelocity(0, 0)
     
     self.curr_animation = self.animations["shatter"]
     self.body:setActive(false)
end

function Sickle:on_hit()
    print("I hit the player")
end

function Sickle:draw()
    --self.curr_animation:draw(self.spr_sheet, self.x, self.y, math.rad(self.rotation), self.facing_dir, 1, self.w/2, self.h/2)
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

function Sickle:reset()
end