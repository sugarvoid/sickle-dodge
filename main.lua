--! main.lua

love = require("love")
require("lib.color")
require("src.player")
require("src.sickle_manager")
require("src.sickle")


Timer = require("lib.kgo.timer")
wf = require 'lib.windfield'


world = wf.newWorld(0, 950, false)
world:addCollisionClass('Player')
world:addCollisionClass('Sickle', { ignores = { "Player" } })
world:addCollisionClass('Ground')



love.graphics.setDefaultFilter("nearest", "nearest")

local font
local sounds
local debug = ""
local gamestate
--[[
    0=title,
    0.1=credit,
    0.2=info,
    1 = game,
    1.1 = retry,
    2=win
]]
local screenWidth = 240
local screenHeight = 136
player_attempt = 1


local active_sickles = {}
local death_markers = {}
local is_paused = false
local seconds_in = 0
local frames = 0
local tick = 0



local platform_img = love.graphics.newImage("asset/image/platform.png")
local snow_flake = love.graphics.newImage('asset/image/snow.png')
local death_marker = love.graphics.newImage('asset/image/death_marker.png')
local background = love.graphics.newImage("asset/image/background.png")

local snow_system = love.graphics.newParticleSystem(snow_flake, 1000)
snow_system:setParticleLifetime(5, 15) -- Particles live at least 2s and at most 5s.
snow_system:setEmissionRate(50)
snow_system:setSizeVariation(1)
snow_system:setSpinVariation(1)
snow_system:setLinearAcceleration(2, 1, -2, 10) -- Random movement in all directions.
snow_system:setColors(1, 1, 1, 1, 1, 1, 1, 0)   -- Fade to transparency.

local snow_system2 = snow_system:clone()

local player = Player:new()
local sickle_manager = SickleManager:new()



--local every_2s = Timer:new(60*2, function() spawn_sickles(WAVES.right_2sec, 150)end, true)
--every_2s:start()


function love.load()
    --window = {translateX = 40, translateY = 40, scale = 4, width = 240, height = 136}
    --love.window.setMode(screenWidth*4, screenHeight*4)
    font = love.graphics.newFont("asset/font/mago2.ttf", 16)
    
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
    gamestate = 1
    font:setFilter("nearest")
    love.graphics.setFont(font)
    --sounds = load_sounds()
    --resize(240*4, 136*4)
end

function reset_game()
    sickle_manager:reset()
    player:reset()
end

--TODO: Move to speperate file
function draw_hitbox(obj, color)
    love.graphics.push("all")
    changeFontColor(color)
    love.graphics.rectangle("line", obj.hitbox.x, obj.hitbox.y, obj.hitbox.w, obj.hitbox.h)
    love.graphics.pop()
end




-- function spawn_sickles(pattern, speed)
--     for p in all(pattern) do
--         --print(p)
--         --print("------")
--         --print("x: ".. p[1])
--        -- print("y: ".. p[2])
--         --print("moving_dir: {"..p[3][1]..","..p[3][2].."}")
--         --print("speed: "..speed)
--        -- print("------")
--         --for s in all(p) do
--             --print(s)
--             --print(sickle[1])
--             --print(s)
--             --print(s)
--         local n_s = spawn_sickle(p[1], p[2], {p[3][1] , p[3][2]}, speed) 
        
--         table.insert(active_sickles, n_s)
--        --end
--     end
-- end


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
            gamestate = 1
        end
    end

    if gamestate == 1 then
        if key == "space" then
            player:jump()
        end
    end
end


function love.update(dt)
    snow_system:update(dt)
    snow_system2:update(dt)

    --every_2s:update()
    tick = tick + 1
    if tick == 60 then
        seconds_in = seconds_in + 1
        tick = 0
        sickle_manager:on_every_second(seconds_in)
    end
    if seconds_in == 60 then
        -- TODO: Player has won
    end
    if gamestate == 0 then
        update_menu()
    elseif gamestate == 1 then
        if not is_paused then
            world:update(dt)
            sickle_manager:update(dt)
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
    -- for s in all(active_sickles) do
    --     s:update(dt)
    --     if s.life_timer <= 0 then
    --         del(active_sickles, s)
    --     end
    -- end
end


function update_gameover(dt)
    return
end

function spawn_death_marker(_x, _y)
    add(death_markers, {_x,_y})
end

function love.draw()
    
    love.graphics.scale(4)

 

    love.graphics.draw(background, 0, 0)
    
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
    love.graphics.push("all")
    love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 0, 0, 0, 1, 1)
    love.graphics.print("Attempt: "..tostring(player_attempt), 180, 0, 0, 1, 1)
    love.graphics.pop()
    
    
    love.graphics.draw(snow_system, 150, -20)
    love.graphics.draw(snow_system, 50, -20)

    player:draw()
    platfrom:draw()
    world:draw()
    sickle_manager:draw()
    -- for s in all(active_sickles) do
    --     s:draw()
    -- end
    for dm in all(death_markers) do
        love.graphics.draw(death_marker, dm[1], dm[2],0,0.2, 0.2, death_marker:getWidth()/2, death_marker:getHeight()/2)
    end

    love.graphics.setColor(love.math.colorFromBytes(255, 255, 255, 130))
    --self.curr_animation:draw(self.spr_sheet, self.x, self.y, math.rad(self.rotation), self.facing_dir, 1, self.w/2, self.h/2)
    --love.graphics.draw(self.image, self.x, self.y, 0, 1, 1, self.w/2, self.h/2)
    love.graphics.print( seconds_in, 110, 15, 0, 3, 3)
    love.graphics.setColor(255,255,255)


    

    if not player.is_alive then
        love.graphics.print("[jump] to try again",60, 70, 0, 1, 1)
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


function go_to_gameover(success)
    gamestate = 2
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

  function do_tables_match( a, b )
    return table.concat(a) == table.concat(b)
end
