-- sickle_manager.lua

SickleManager = {}
SickleManager.__index = SickleManager


local function make_sickle(_x, _y, _dir, _speed)
    local new_sickle = Sickle:new(_x, _y, _dir, _speed)
    return new_sickle
end

local WAVES = {
    top_full = {
        { 50, -10, { 0, 1 } },
        { 60, -10, { 0, 1 } },
        { 70, -10, { 0, 1 } },
        { 90, -10, { 0, 1 } },
    },
    left_low = {
        { -10,  100, { 1, 0 } },
        { -70,  100, { 1, 0 } },
        { -120, 100, { 1, 0 } },
        { -170, 100, { 1, 0 } },
    },
    right_low_single = {
        { 250, 114, { -1, 0 } },
    },
    left_high_single = {
        { 50, -10, { 0, 1 } },
    },
    left_full = {
        { -20,  104,      { 1, 0 } },
        { -62,  59 - 8,   { 1, 0 } },
        { -131, 106 - 16, { 1, 0 } },
        { -171, 61 - 16,  { 1, 0 } },
    },
    top_right = {
        { 121, -21,  { 0, 1 } },
        { 184, -21,  { 0, 1 } },
        { 79,  -80,  { 0, 1 } },
        { 145, -80,  { 0, 1 } },
        { 121, -136, { 0, 1 } },
        { 187, -136, { 0, 1 } },
    },
    top_left = {
        { 87,  -17,  { 0, 1 } },
        { 56,  -133, { 0, 1 } },
        { 141, -132, { 0, 1 } },
        { 173, -17,  { 0, 1 } },
        { 56,  -58,  { 0, 1 } },
        { 85,  -185, { 0, 1 } },
        { 170, -184, { 0, 1 } },
        { 142, -58,  { 0, 1 } },
    },
    top_all = {
        { 59,  -99,  { 0, 1 } },
        { 117, -47,  { 0, 1 } },
        { 119, -155, { 0, 1 } },
        { 182, -97,  { 0, 1 } },
        { 60,  -13,  { 0, 1 } },
        { 183, -14,  { 0, 1 } },
    },
    right_high = {
        { 347, 106, { -1, 0 } },
        { 538, 78,  { -1, 0 } },
        { 254, 77,  { -1, 0 } },
        { 345, 52,  { -1, 0 } },
        { 436, 81,  { -1, 0 } },
    },
    right_low = {
        { 271, 102, { -1, 0 } },
        { 288, 59,  { -1, 0 } },
        { 346, 59,  { -1, 0 } },
        { 360, 101, { -1, 0 } },
        { 458, 102, { -1, 0 } },
        { 473, 59,  { -1, 0 } },
    },
    left_high = {
        { -266, 80, { 1, 0 } },
        { -177, 80, { 1, 0 } },
        { -93,  80, { 1, 0 } },
        { -11,  80, { 1, 0 } },
    },
    final_wave = {
        {},
        {},
        {},
        {},
        {},
        {},
        {},
        {},
        {},
    }
}

function SickleManager:new(win_func)
    local _sickle_manager = setmetatable({}, SickleManager)
    _sickle_manager.active_sickles = {}
    _sickle_manager.timers = {}
    _sickle_manager.tmr_every_2s = Timer:new(60 * 2,
        function() _sickle_manager:spawn_sickles(WAVES.right_low_single, 180) end, true)
    
    table.insert(_sickle_manager.timers, _sickle_manager.tmr_every_2s)
    --TODO: Make left side timer for sickle
    _sickle_manager.update_actions = {
        [20] = nil,
        [29] = function() _sickle_manager:spawn_sickles(WAVES.top_left, 100) end,
        [28] = nil,
        [27] = function() _sickle_manager:spawn_sickles(WAVES.top_right, 100) end,
        [26] = function() _sickle_manager.tmr_every_2s:start() end,
        [25] = function() _sickle_manager:spawn_sickles(WAVES.left_low, 130) end,
        [24] = nil,
        [23] = function() _sickle_manager:spawn_sickles(WAVES.left_low, 170) end,
        [22] = nil,
        [21] = function() _sickle_manager:spawn_sickles(WAVES.left_high, 100) end,
        [20] = nil,
        [19] = nil,
        [18] = function() _sickle_manager:spawn_sickles(WAVES.left_full, 150) end,
        [17] = nil,
        [16] = nil,
        [15] = function() _sickle_manager:spawn_sickles(WAVES.top_right, 120) end,
        [14] = nil,
        [13] = function() _sickle_manager:spawn_sickles(WAVES.top_all, 120) end,
        [12] = nil,
        [11] = function() _sickle_manager:spawn_sickles(WAVES.top_left, 150) end,
        [10] = nil,
        [9] = nil,
        [8] = nil,
        [7] = function() _sickle_manager:spawn_sickles(WAVES.left_low, 120) end,
        [6] = nil,
        [5] = function() _sickle_manager:spawn_sickles(WAVES.top_full, 200) end,
        [4] = nil,
        [3] = function() _sickle_manager:spawn_sickles(WAVES.right_high, 130) end,
        [2] = function() _sickle_manager:spawn_sickles(WAVES.left_full, 150) end,
        [1] = on_player_win,
    }
    return _sickle_manager
end

function SickleManager:reset()
    self.tmr_every_2s:stop()

    for k in pairs(self.active_sickles) do
        self.active_sickles[k].body:destroy()
        self.active_sickles[k] = nil
    end
end

function SickleManager:update(dt)
    for t in all(self.timers) do
        t:update()
    end

    for s in all(self.active_sickles) do
        s:update(dt)
        if s.life_timer <= 0 then
            s.body:destroy()
            del(self.active_sickles, s)
        else

        end
    end
end

function SickleManager:draw()
    for s in all(self.active_sickles) do
        s:draw()
    end
end

function SickleManager:on_every_second(seconds_in)
    local action = self.update_actions[seconds_in]
    if action then
        action()
    else
        return
    end
end

function SickleManager:spawn_sickles(pattern, speed)
    for p in all(pattern) do
        local n_s = make_sickle(p[1], p[2], { p[3][1], p[3][2] }, speed)
        table.insert(self.active_sickles, n_s)
    end
end
