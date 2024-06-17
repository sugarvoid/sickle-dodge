

WAVES = {
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
        {79,-80},
        {121,-21},
        {184, -21},
        {145, -80},
        {121, -136},
        {187, -136},
    },
    top_left = {
        {87,-17},
        {56,-133},
        {141,-132},
        {173,-17},
        {56,-58},
        {85,-185},
        {170,-184},
        {142,-58},
    },
    top_all = {
        {59,-99},
        {117,-47},
        {119,-155},
        {182,-97},
        {60,-13},
        {183,-14},
    },
    right_high = {
        {347,106},
        {538,78},
        {254,77},
        {345,52},
        {436,81},
    },
    right_low = {
        {271,102},
        {288,59},
        {346,59},
        {360,101},
        {458,102},
        {473,59},
    },
    left_high = {
        {-266,75},
        {-177,74},
        {-93,76},
        {-11,75},
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
