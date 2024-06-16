--! main.lua

wf = require 'lib.windfield'

world = wf.newWorld(0, 900, false)
--world:setGravity(0, 900)
world:addCollisionClass('Player')
world:addCollisionClass('Sickle', {ignores = {"Player"}})
world:addCollisionClass('Ground')

require("lib.color")
require("player")
require("sickle")

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


local seconds_in = 0
local frames = 0
local tick = 0

love.graphics.setDefaultFilter("nearest", "nearest")


local sickle_img = love.graphics.newImage("ice_sickle.png")
local platform_img = love.graphics.newImage("platform.png")




local player = Player:new()


local my_timer = Timer:new(60*5, function() print("Timer finished!") end, true)
my_timer:start()

local every_2s = Timer:new(60*2, function() spawn_sickles(WAVES.right_2sec, 150)end, true)
every_2s:start()



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
        {240+10, 96, {-1, 0}},
    },
    left_all = {
        {-20, 104, {1, 0}},
        {-62, 59 - 8, {1, 0}},
        {-131, 106 - 16, {1, 0}},
        {-171, 61 - 16, {1, 0}},
    }
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
            self.x = (self.x + (self.moving_dir[1] * self.speed * dt))
            self.y = (self.y + (self.moving_dir[2] * self.speed * dt))
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
            [4] = function() spawn_sickles(WAVES.left_all, 200) end,
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
    end,

}

--create loadFont() function in lib

function love.load()
    
    print('set filter')
    --window = {translateX = 40, translateY = 40, scale = 4, width = 240, height = 136}
    --love.window.setMode(screenWidth*4, screenHeight*4)
    
    font = love.graphics.newFont("font/mago2.ttf", 16)
    background = love.graphics.newImage("TEMP_background.png")
    

    platfrom = {
        x=40,
        y=120,
        image = platform_img,
        w= platform_img:getWidth(),
        h= platform_img:getHeight(),
        physics = {},
        
        init=function(self)
            self.hitbox = {x = self.x, y= self.y, w= self.w, h =self.h}
            body = world:newRectangleCollider(self.hitbox.x, self.hitbox.y, self.hitbox.w, self.hitbox.h)
            body:setType("static")
            body:setCollisionClass('Ground')
        end,
        draw=function(self)
            love.graphics.draw(self.image, self.x, self.y)
            draw_hitbox(self, "#FF0000")
            --love.graphics.push("all")
            --changeFontColor("#FF0000")
            --love.graphics.rectangle("line", self.hitbox.x, self.hitbox.y, self.hitbox.w, self.hitbox.h) 
            --love.graphics.pop()
        end,
    }
    platfrom:init()

    test_sickle = sickle:new()
    table.insert(active_sickles, test_sickle)

    gamestate = 1
    score = 0
    font:setFilter("nearest")
    love.graphics.setFont(font)
    --sounds = load_sounds()
    --resize(240*4, 136*4)
end


--TODO: Move to speperate file
function draw_hitbox(obj, color)
    love.graphics.push("all")
    changeFontColor(color)
    love.graphics.rectangle("line", obj.hitbox.x, obj.hitbox.y, obj.hitbox.w, obj.hitbox.h)
    love.graphics.pop()
end


function spawn_sickle(_x, _y, _dir, _speed)

	local new_sickle = Sickle:new()
    print(_x, _y)
	new_sickle.moving_dir=_dir
	--new_sickle.x=_x
	--new_sickle.y=_y
    new_sickle.body:setPosition(_x, _y)
    new_sickle.speed = _speed
    new_sickle.life_timer = 150
	--add(active_sickles, new_sickle)
    return new_sickle
end

function spawn_sickles(pattern, speed)
    --print(#pattern)
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
        local n_s = spawn_sickle(p[1], p[2], {p[3][1] , p[3][2]}, speed) 
        
        table.insert(active_sickles, n_s)
       --end
    end
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
        if key == "space" then
            player:jump()
        end
    end
end


function love.update(dt)
    my_timer:update()
    every_2s:update()
    tick = tick + 1
    if tick == 60 then
        seconds_in = seconds_in + 1
        tick = 0
        sickle_manager:update_checker(seconds_in)
    end
    if gamestate == 0 then
        update_menu()
    elseif gamestate == 1 then
        if not is_paused then
            world:update(dt)
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
    
    if love.keyboard.isDown('d') then
        player.is_moving_right = true 
    else
        player.is_moving_right = false   
    end            -- When the player presses and holds down the "D" button:
		--player.x = player.x + (player.speed * dt)    -- The player moves to the right.
	if love.keyboard.isDown('a') then
        player.is_moving_left = true  
        else
            player.is_moving_left = false                 -- When the player presses and holds down the "A" button:
		--player.x = player.x - (player.speed * dt)    -- The player moves to the left.
	end



    player:update(dt)
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
    love.graphics.push("all")
    love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 0, 0, 0, 1, 1)
    love.graphics.pop()
    player:draw()
    platfrom:draw()
    world:draw()
    love.graphics.print( seconds_in, 60, 20, 0, 3, 3)
    --love.graphics.pop()
   
    
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

function check_collision(a, b)
    return a.x < b.x+b.w and
           b.x < a.x+a.w and
           a.y < b.y+b.h and
           b.y < a.y+a.h
  end