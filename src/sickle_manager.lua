

WAVES = {
    all_top = {
        {20, -10, {0, 1}},
        {50, -10, {0, 1}},
        {80, -10, {0, 1}},
    },
    bottom_left = {
        {-6, 96, {1, 0}},
        {-6, 96 - 8, {1, 0}},
        {-6, 96 - 16, {1, 0}},
    },
    right_2sec = {
        {240+10, 106, {-1, 0}},
    },
    left_all = {
        {-20, 104, {1, 0}},
        {-62, 59 - 8, {1, 0}},
        {-131, 106 - 16, {1, 0}},
        {-171, 61 - 16, {1, 0}},
    }
}




local function test_function()
    print('2 sec')
end


local update_actions = {
    [1] = nil,
    [2] = test_function,
    [3] = nil,
    --[4] = function() spawn_sickles(WAVES.left_all, 200) end,
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

sickle_manager = {
    --TODO: bring in sec timer
    --TODO: Make left side timer for sickle
}

function sickle_manager:update(dt)
    for s in all(active_sickles) do
        if s.life_timer <= 0 then
            del(active_sickles, s)
        end
    end
end

function sickle_manager:on_every_second(seconds_in)
    local action = update_actions[seconds_in]
    if action then
        action()
    else
        -- Handle invalid input
    end
end
