-- timer.lua

Timer = {}
Timer.__index = Timer

function Timer:new(finished_time, callback, _loop)
    local obj = setmetatable({}, Timer)
    obj.time = 0
    obj.loop = _loop
    obj.is_paused = true
    obj.finished_time = finished_time or 1
    obj.is_finished = false
    obj.is_running = false
    obj.on_done_func = callback or function() obj:print_done() end
    return obj
end

function Timer:update()
    if not self.is_finished and not self.is_paused then
        self.time = self.time + 1
        if self.time > self.finished_time then
            self.is_finished = true
            self.is_running = false
            self:on_done()
        end
    end
end

function Timer:start()
    self.time = 0
    self.is_finished = false
    self.is_running = true
    self.is_paused = false
end

function Timer:stop()
    self.time = 0
    self.is_running = false
end

function Timer:pause()
    self.is_paused = not self.is_paused
end

function Timer:print_done()
    print("I'm done")
end

function Timer:on_done()
    self.on_done_func()
    if self.loop == true then
        self:start()
    end
end

return Timer
