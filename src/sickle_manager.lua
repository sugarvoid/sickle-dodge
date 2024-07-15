-- sickle_manager.lua

SickleManager = {}
SickleManager.__index = SickleManager



local DIRECTIONS = {
    DOWN = { 0, 1 },
    LEFT = { -1, 0 },
    UP = { 0, -1 },
    RIGHT = { 1, 0 }
}


local function make_sickle(_x, _y, _dir, _speed)
    local new_sickle = Sickle:new(_x, _y, _dir, _speed)
    return new_sickle
end

local WAVES = {
    top_left = {
        { 50,  -10, DIRECTIONS.DOWN },
        { 60,  -10, DIRECTIONS.DOWN },
        { 70,  -10, DIRECTIONS.DOWN },
        { 100, -10, DIRECTIONS.DOWN },
    },
    left_low = {
        { -10,  110, DIRECTIONS.RIGHT },
        { -80,  110, DIRECTIONS.RIGHT },
        { -150, 110, DIRECTIONS.RIGHT },
        { -190, 110, DIRECTIONS.RIGHT },
    },
    right_low_single = {
        { 250, 114, DIRECTIONS.LEFT },
    },
    left_high_single = {
        { -10, 100, DIRECTIONS.RIGHT },
    },
    left_full = {
        { -20,  110, DIRECTIONS.RIGHT },
        { -62,  80,  DIRECTIONS.RIGHT },
        { -130, 110, DIRECTIONS.RIGHT },
        { -150, 110, DIRECTIONS.RIGHT },
        { -170, 110, DIRECTIONS.RIGHT },
    },
    top_right = {
        { 121, -21,  DIRECTIONS.DOWN },
        { 184, -21,  DIRECTIONS.DOWN },
        { 121, -80,  DIRECTIONS.DOWN },
        { 184, -80,  DIRECTIONS.DOWN },
        { 121, -136, DIRECTIONS.DOWN },
        { 187, -136, DIRECTIONS.DOWN },
    },
    top_full_a = {
        { 87,  -17,  DIRECTIONS.DOWN },
        { 56,  -133, DIRECTIONS.DOWN },
        { 141, -132, DIRECTIONS.DOWN },
        { 173, -17,  DIRECTIONS.DOWN },
        { 56,  -58,  DIRECTIONS.DOWN },
        { 85,  -185, DIRECTIONS.DOWN },
        { 170, -184, DIRECTIONS.DOWN },
        { 142, -58,  DIRECTIONS.DOWN },
    },
    top_full_b = {
        { 59,  -99,  DIRECTIONS.DOWN },
        { 117, -47,  DIRECTIONS.DOWN },
        { 119, -155, DIRECTIONS.DOWN },
        { 182, -97,  DIRECTIONS.DOWN },
        { 60,  -13,  DIRECTIONS.DOWN },
        { 183, -14,  DIRECTIONS.DOWN },
    },
    right_high = {
        { 347, 106, DIRECTIONS.LEFT },
        { 538, 78,  DIRECTIONS.LEFT },
        { 254, 77,  DIRECTIONS.LEFT },
        { 345, 52,  DIRECTIONS.LEFT },
        { 436, 81,  DIRECTIONS.LEFT },
    },
    right_low = {
        { 271, 102, DIRECTIONS.LEFT },
        { 288, 59,  DIRECTIONS.LEFT },
        { 346, 59,  DIRECTIONS.LEFT },
        { 360, 101, DIRECTIONS.LEFT },
        { 458, 102, DIRECTIONS.LEFT },
        { 473, 59,  DIRECTIONS.LEFT },
    },
    left_high = {
        { -200, 90,  DIRECTIONS.RIGHT },
        { -150, 100, DIRECTIONS.RIGHT },
        { -80,  90,  DIRECTIONS.RIGHT },
        { -10,  100, DIRECTIONS.RIGHT },
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

function SickleManager:new()
    local _sickle_manager = setmetatable({}, SickleManager)
    _sickle_manager.active_sickles = {}
    _sickle_manager.timers = {}
    _sickle_manager.tmr_every_2s = Timer:new(60 * 2,
        function() _sickle_manager:spawn_sickles(WAVES.right_low_single, 160) end, true)
    _sickle_manager.tmr_every_4s = Timer:new(60 * 4,
        function() _sickle_manager:spawn_sickles(WAVES.left_high_single, 190) end, true)

    table.insert(_sickle_manager.timers, _sickle_manager.tmr_every_2s)
    table.insert(_sickle_manager.timers, _sickle_manager.tmr_every_4s)

    _sickle_manager.update_actions = {
        [30] = nil,
        [29] = function() _sickle_manager:spawn_sickles(WAVES.top_left, 100) end,
        [28] = nil,
        [27] = function() _sickle_manager:spawn_sickles(WAVES.top_right, 100) end,
        [26] = function() _sickle_manager.tmr_every_2s:start() end,
        [25] = function() _sickle_manager:spawn_sickles(WAVES.left_high, 150) end,
        [24] = nil,
        [23] = function() _sickle_manager:spawn_sickles(WAVES.left_low, 130) end,
        [22] = nil,
        [21] = function() _sickle_manager:spawn_sickles(WAVES.left_high, 100) end,
        [20] = nil,
        [19] = nil,
        [18] = function() _sickle_manager:spawn_sickles(WAVES.left_full, 150) end,
        [17] = nil,
        [16] = nil,
        [15] = function() _sickle_manager:spawn_sickles(WAVES.top_right, 120) end,
        [14] = nil,
        [13] = function() _sickle_manager:spawn_sickles(WAVES.top_full_a, 120) end,
        [12] = nil,
        [11] = function() _sickle_manager:spawn_sickles(WAVES.top_left, 150) end,
        [10] = nil,
        [9] = nil,
        [8] = nil,
        [7] = function() _sickle_manager:spawn_sickles(WAVES.left_low, 120) end,
        [6] = nil,
        [5] = function() _sickle_manager:spawn_sickles(WAVES.top_full_a, 200) end,
        [4] = nil,
        [3] = function() _sickle_manager:spawn_sickles(WAVES.right_high, 130) end,
        [2] = function() _sickle_manager:spawn_sickles(WAVES.left_full, 150) end,
        [1] = on_player_win,
    }
    _sickle_manager.debug_key_functions = {
        ["1"] = function() _sickle_manager:spawn_sickles(WAVES.left_high_single, 90) end,
        ["2"] = function() _sickle_manager:spawn_sickles(WAVES.top_full_b, 90) end,
        ["3"] = function() _sickle_manager:spawn_sickles(WAVES.top_left, 90) end,
        ["4"] = function() _sickle_manager:spawn_sickles(WAVES.top_right, 90) end,
        ["5"] = function() _sickle_manager:spawn_sickles(WAVES.left_full, 90) end,
        ["6"] = function() _sickle_manager:spawn_sickles(WAVES.left_high, 90) end,
        ["7"] = function() _sickle_manager:spawn_sickles(WAVES.left_low, 90) end,
        ["8"] = function() _sickle_manager:spawn_sickles(WAVES.right_high, 90) end,
        ["9"] = function() _sickle_manager:spawn_sickles(WAVES.right_low, 90) end,
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

function SickleManager:on_every_second(_seconds_in)
    local action = self.update_actions[_seconds_in]
    if action then
        action()
    else
        return
    end
end

function SickleManager:spawn_sickles(_pattern, _speed)
    for p in all(_pattern) do
        local n_s = make_sickle(p[1], p[2], { p[3][1], p[3][2] }, _speed)
        table.insert(self.active_sickles, n_s)
    end
end
