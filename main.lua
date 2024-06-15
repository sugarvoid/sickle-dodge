--! main.lua

require("lib.color")

local Timer = require("timer")

local font
local sounds
local debug = ""
local gamestate -- 0 = menu, 1 = game, 2 = gameover
local screenWidth = 240
local screenHeight = 136

dead_sickles = {}
local active_sickles = {}
local is_paused = false

love.graphics.setDefaultFilter("nearest", "nearest")

local sickle_img = love.graphics.newImage("ice_sickle.png")

local my_timer = Timer:new(60*5, function() print("Timer finished!") end, true)
my_timer:start()

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
        {128 + 12, 96, {-1, 0}},
    },
}


local obj= {
    new=function(self,tbl)
            tbl=tbl or {}
            setmetatable(tbl,{
                __index=self
            })
            return tbl
        end
}

local sickle = obj:new({
        x=30,
        y=30,
        image = sickle_img,
        w= sickle_img:getWidth(),
        h= sickle_img:getHeight(),
        moving_dir={1,0},
        rotation = 0,
        life_timer=120,
        speed=200,
        update=function(self, dt)
            self.x = (self.x + self.moving_dir[1] * self.speed * dt)
            self.y = (self.y + self.moving_dir[2] * self.speed * dt)
            self.life_timer = self.life_timer - 1
        end,
        draw=function(self)
            love.graphics.draw(self.image, self.x, self.y)
        end,
})

function update_for_1_second()
    print('1 sec')
end

function update_for_2_seconds()
    print('2 sec')
end

function update_for_3_seconds()
    print('3 sec')
end


sickle_manager = {
    update_checker = function(self, seconds_in)
        local update_actions = {
            [1] = update_for_1_second,
            [2] = update_for_2_seconds,
            [3] = update_for_3_seconds,
            [4] = function() self:spawn_sickles({pattern = all_top, speed = 3}) end,
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
    
        local action = update_actions[seconds_in]
        if action then
            action()
        else
            -- Handle invalid input
        end
    end
}

--create loadFont() function in lib

function love.load()
    
    print('set filter')
    window = {translateX = 40, translateY = 40, scale = 4, width = 240, height = 136}
    --love.window.setMode(screenWidth*4, screenHeight*4)
    
    font = love.graphics.newFont("font/mago2.ttf", 64)
    background = love.graphics.newImage("TEMP_background.png")
    
    player = {
    
        x = 50,
        y = 50,
        speed = 150, 
        image = love.graphics.newImage("player.png"),
        update=function(self)
            
        end,
        draw=function(self)
            love.graphics.draw(self.image, self.x, self.y)
        end,
    }

    

    platfrom = {
        x=40,
        y=110,
        image = love.graphics.newImage("platform.png"),
        draw=function(self)
            love.graphics.draw(self.image, self.x, self.y)
        end,
    }

    test_sickle = sickle:new()
    table.insert(active_sickles, test_sickle)

    gamestate = 1
    score = 0
    font:setFilter("nearest")
    love.graphics.setFont(font)
    --sounds = load_sounds()
    resize(240*4, 136*4)
end

print('player')


function spawn_sickle(_x, _y, _dir)

	local new_sickle = table.remove(dead_sickles, 1)
	new_sickle.dir=_dir
	new_sickle.x=_x
	new_sickle.y=_y

	add(active_sickles, new_sickle)
end

function spawn_sickles(self, pattern, speed)
    for _, s in ipairs(pattern) do
        local n_s = spawn_sickle({pos = {s[1], s[2]}, moving_dir = s[3], groups = self.sickle_group})
        n_s.speed = speed
        n_s.life_timer = 60
        table.insert(active_sickles, n_s)
    end
end


function load_sickles()
    
	new_sickle = sickle:new() 
	new_sickle.dir=_dir
	new_sickle.x=_x
	new_sickle.y=_y
	
	add(dead_sickles,new_sickle)
end



function love.keypressed(key)
    if key == "escape" then
            love.event.quit()
        end

    if gamestate == 0 then
        if key == "space" then
            gamestate = 1
        end
    end

    if gamestate == 2 then
        if key == "r" then
            love.load()
        end
    end

    if gamestate == 1 then
        return
    end
end


function love.update(dt)
    my_timer:update()
    if gamestate == 0 then
        update_menu()
    elseif gamestate == 1 then
        if not is_paused then
            update_game(dt)
        end
        
    else
        update_gameover(dt)
    end
end

function update_menu()
    return
end


function update_game(dt)
    if love.keyboard.isDown('d') then                    -- When the player presses and holds down the "D" button:
		player.x = player.x + (player.speed * dt)    -- The player moves to the right.
	elseif love.keyboard.isDown('a') then                -- When the player presses and holds down the "A" button:
		player.x = player.x - (player.speed * dt)    -- The player moves to the left.
	end
    for s in all(active_sickles) do
        s:update(dt)
        if s.life_timer <= 0 then
            local _s = s
            table.insert(dead_sickles, s)
            del(active_sickles, s)
        end
    end
end


function update_gameover(dt)
    return
end


function love.draw()
    love.graphics.scale(4)
    love.graphics.draw(background, 0, 0)
    player:draw()
    platfrom:draw()
    
    if gamestate == 0 then
        draw_menu()
    end
    if gamestate == 1 then
        draw_game()
    end
    if gamestate == 2 then
        draw_gameover()
    end
end


--#region Draw Functions
function draw_menu()
    --changeFontColor("#ffbf40")
end


function draw_game()
    for s in all(active_sickles) do
        s:draw()
    end
end


function draw_gameover()
    return
end


function resize (w, h) -- update new translation and scale:
	local w1, h1 = window.width, window.height -- target rendering resolution
	local scale = math.min (w/w1, h/h1)
	window.translateX, window.translateY, window.scale = (w-w1*scale)/2, (h-h1*scale)/2, scale
end

function love.resize (w, h)
	resize (w, h) -- update new translation and scale
end



--#endregion Draw Functions




function playSound(sound)
    love.audio.stop(sound)
    love.audio.play(sound)
end




---
-- Clamps a value to a certain range.
-- @param min - The minimum value.
-- @param val - The value to clamp.
-- @param max - The maximum value.
--
function clamp(min, val, max)
    return math.max(min, math.min(val, max));
end



--tables
add=table.insert

function all(list)
  local i = 0
  return function() i = i + 1; return list[i] end
end

--for v in all(t) do
--    print(v)  -- prints 1, 3, 5, 7, 9
--end

count=table.getn

function del(t,a)
	for i,v in ipairs(t) do
		if v==a then
			t[i]=t[#t]
			t[#t]=nil
			return
		end
	end
end

