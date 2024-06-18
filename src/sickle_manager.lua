
-- sickle_manager.lua

SickleManager = {}
SickleManager.__index = SickleManager


local function make_sickle(_x, _y, _dir, _speed)

	local new_sickle = Sickle:new(_x, _y, _dir, _speed)

	--new_sickle.moving_dir=_dir
	--new_sickle.x=_x
	--new_sickle.y=_y
    --new_sickle.body:setPosition(_x, _y)
    --new_sickle.speed = _speed
    --new_sickle.life_timer = 150
	--add(active_sickles, new_sickle)
    return new_sickle
end




local WAVES = {
    top_full = {
        {20, -10, {0, 1}},
        {50, -10, {0, 1}},
        {80, -10, {0, 1}},
    },
    left_low = {
        {-18, 87, {1, 0}},
        {-77, 88, {1, 0}},
        {-76, 88 - 16, {1, 0}},
        {-141,87},
    },
    right_low_single = {
        {250, 106, {-1, 0}},
    },
    left_high_single = {
        
    },
    left_full = {
        {-20, 104, {1, 0}},
        {-62, 59 - 8, {1, 0}},
        {-131, 106 - 16, {1, 0}},
        {-171, 61 - 16, {1, 0}},
    },
    top_right = {
        {79,-80, {0, 1}},
        {121,-21, {0, 1}},
        {184, -21, {0, 1}},
        {145, -80, {0, 1}},
        {121, -136, {0, 1}},
        {187, -136, {0, 1}},
    },
    top_left = {
        {87,-17, {0,1}},
        {56,-133, {0,1}},
        {141,-132, {0,1}},
        {173,-17, {0,1}},
        {56,-58, {0,1}},
        {85,-185, {0,1}},
        {170,-184, {0,1}},
        {142,-58, {0,1}},
    },
    top_all = {
        {59,-99, {0,1}},
        {117,-47, {0,1}},
        {119,-155, {0,1}},
        {182,-97, {0,1}},
        {60,-13, {0,1}},
        {183,-14, {0,1}},
    },
    right_high = {
        {347,106, {-1,0}},
        {538,78, {-1,0}},
        {254,77, {-1,0}},
        {345,52, {-1,0}},
        {436,81, {-1,0}},
    },
    right_low = {
        {271,102, {-1,0}},
        {288,59, {-1,0}},
        {346,59, {-1,0}},
        {360,101, {-1,0}},
        {458,102, {-1,0}},
        {473,59, {-1,0}},
    },
    left_high = {
        {-266,75, {1,0}},
        {-177,74, {1,0}},
        {-93,76, {1,0}},
        {-11,75, {1,0}},
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

local function test_function()
    print('this is the 2sec test function')
end

function SickleManager:new()
    local instance = setmetatable({}, SickleManager)
    instance.active_sickles = {}
    instance.timers ={}
    instance.tmr_every_2s = Timer:new(60*2, function() instance:spawn_sickles(WAVES.right_2sec, 150)end, true)
    table.insert(instance.timers, instance.tmr_every_2s)
    
    --TODO: bring in sec timer
    --TODO: Make left side timer for sickle
    instance.update_actions = {
        [1] = nil,
        [2] = test_function,
        [3] = nil,
        [4] = function() instance:spawn_sickles(WAVES.left_full, 200) end,
        [5] = nil,
        [6] = nil,
        [7] = nil,
        [8] = nil,
        [9] = nil,
        [10] = nil,
        [11] = nil,
        [12] = nil,
        [13] = nil,
        [14] = nil,
        [15] = nil,
        [16] = nil,
        [17] = nil,
        [18] = nil,
        [19] = nil,
        [20] = nil,
        [21] = nil,
        [22] = nil,
        [23] = nil,
        [24] = nil,
        [25] = nil,
        [26] = nil,
        [27] = nil,
        [28] = nil,
        [29] = nil,
        [30] = nil,
        [31] = nil,
        [32] = nil,
        [33] = nil,
        [34] = nil,
        [35] = nil,
        [36] = nil,
        [37] = nil,
        [38] = nil,
        [39] = nil,
        [40] = nil,
        [41] = nil,
        [42] = nil,
        [43] = nil,
        [44] = nil,
        [45] = nil,
        [46] = nil,
        [47] = nil,
        [48] = nil,
        [49] = nil,
        [50] = nil,
        [51] = nil,
        [52] = nil,
        [53] = nil,
        [54] = nil,
        [55] = nil,
        [56] = nil,
        [57] = nil,
        [58] = nil,
        [59] = nil,
        [60] = nil,
    }
    return instance
end





function SickleManager:reset()
    self.tmr_every_2s:start()
end





function SickleManager:update(dt)
    --self.tmr_every_2s:update()
    for t in all(self.timers) do
        t:update()
    end
    for s in all(self.active_sickles) do
        s:update(dt)
        if s.life_timer <= 0 then
            del(self.active_sickles, s)
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
        -- Handle invalid input
    end
end

function SickleManager:spawn_sickles(pattern, speed)
    for p in all(pattern) do
        --print(p)
        --print("------")
        --print("x: ".. p[1])
       -- print("y: ".. p[2])
        --print("moving_dir: {"..p[3][1]..","..p[3][2].."}")
        --print("speed: "..speed)
       -- print("------")
        --for s in all(p) do
            --print(s)
            --print(sickle[1])
            --print(s)
            --print(s)
        local n_s = make_sickle(p[1], p[2], {p[3][1] , p[3][2]}, speed) 
        
        table.insert(self.active_sickles, n_s)
       --end
    end
end
