--jump_sfx.lua

JumpSfx = {}
JumpSfx.__index = JumpSfx


local jump_effect_sheet = love.graphics.newImage("asset/image/jump_effect.png")
local jump_grid = anim8.newGrid(8, 8, jump_effect_sheet:getWidth(), jump_effect_sheet:getHeight())

function JumpSfx:new()
    local _jump_sfx = setmetatable({}, JumpSfx)
    _jump_sfx.curr_animation = anim8.newAnimation(jump_grid(('1-6'), 1), 0.07, 'pauseAtEnd')
    _jump_sfx.x = 0
    _jump_sfx.y = 0
    _jump_sfx.alive = true
    _jump_sfx.life_timer = 300

    return _jump_sfx
end

function JumpSfx:update(dt)
    self.curr_animation:update(dt)

    --self.life_timer = self.life_timer - 1

    if self.curr_animation.status == "paused" then
        -- Animation over
    end
end

function JumpSfx:do_animation(_x, _y)
    self.x = _x
    self.y = _y + 4
    self.curr_animation:resume()
    self.curr_animation:gotoFrame(1)
    
end

function JumpSfx:shatter()
    --todo: Play break animation
    self.alive = false
    self.body:setLinearVelocity(0, 0)

    self.curr_animation = self.animations["shatter"]
    self.body:setActive(false)
end



function JumpSfx:draw()
    --self.curr_animation:draw(self.spr_sheet, self.x, self.y, math.rad(self.rotation), self.facing_dir, 1, self.w/2, self.h/2)
    self.curr_animation:draw(jump_effect_sheet, self.x, self.y, 0, 1, 1, 4, 4)
end



function JumpSfx:reset()
end
