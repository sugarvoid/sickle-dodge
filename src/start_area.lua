StartArea = {}
StartArea.__index = StartArea


function StartArea:new(callback)
    local _start_area = setmetatable({}, StartArea)
    _start_area.x = 90
    _start_area.y = 100
    _start_area.w = 16
    _start_area.h = 16
    _start_area.fill = 0
    _start_area.max_fill = 100
    _start_area.ox = _start_area.w / 2
    _start_area.oy = _start_area.h / 2
    _start_area.tmr_player_in = Timer:new(60 * 4, function() callback() end, true)
    _start_area.tmr_player_in:start()
    return _start_area
end

function StartArea:update(dt)
    
end

function StartArea:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.fill)
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
    --love.graphics.draw(self.image, self.x, self.y, 0, 1, 1, self.ox, self.oy)
end
