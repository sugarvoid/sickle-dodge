--! main.lua

love = require("love")

require("lib.color")
require("src.player")
require("src.platform")
require("src.sickle_manager")
require("src.sickle")


Timer = require("lib.kgo.timer")
wf = require 'lib.windfield'
lume = require("lib.lume")

world = wf.newWorld(0, 950, false)
world:addCollisionClass('Player')
world:addCollisionClass('Sickle', { ignores = { "Player" } })
world:addCollisionClass('Ground')



love.graphics.setDefaultFilter("nearest", "nearest")

local font = nil
local gamestates = {
    title = 0,
    credit = 0.1,
    info = 0.2,
    game = 1,
    retry = 1.1,
    win = 2
}
local gamestate = nil
local death_markers = {}
local is_paused = true
local seconds_in = 0
local frames = 0
local tick = 0



longest_time = nil
player_attempt = 1

local bg_music = love.audio.newSource("asset/audio/8_bit_iced_village.ogg", "stream")
bg_music:setVolume(0.5)
local snow_flake = love.graphics.newImage('asset/image/snow.png')
local death_marker = love.graphics.newImage('asset/image/death_marker.png')
local background = love.graphics.newImage("asset/image/background.png")
local title_img = love.graphics.newImage("asset/image/title.png")
local snow_system = love.graphics.newParticleSystem(snow_flake, 1000)
local player = Player:new()
local platfrom = Platform:new()
local sickle_manager = SickleManager:new()


function love.load()
    init_snow()
    load_game()
    font = love.graphics.newFont("asset/font/mago2.ttf", 16)
    gamestate = gamestates.title
    font:setFilter("nearest")
    love.graphics.setFont(font)
end

function reset_game()
    seconds_in = 0
    sickle_manager:reset()
    player:reset()
    
    is_paused = false
end

function init_snow()
    snow_system:setParticleLifetime(5, 15)
    snow_system:setEmissionRate(100)
    snow_system:setEmissionArea("normal", 240, 0)
    snow_system:setSpeed(1, 3)
    snow_system:setPosition(0, -6)
    snow_system:setSizes(0.7, 0.6, 0.5)
    snow_system:setSizeVariation(1)
    snow_system:setSpinVariation(1)
    snow_system:setLinearAcceleration(-2, 3, 2, 10)
    snow_system:setColors(1, 1, 1, 1, 1, 1, 1, 0)
end

function start_game()
    reset_game()
end

function love.keypressed(key)
    if key == "escape" then
            love.event.quit()
        end

    if gamestate == gamestates.game then
        if key == "space" or key == "w" then
            player:jump()
        end
    end

    if gamestate == gamestates.retry then
        if key == "space" then
            reset_game()
            
            gamestate = gamestates.game
            
        end
    end

    if gamestate == gamestates.title then
        if key == "space" then
            gamestate = gamestates.game
            bg_music:stop()
            bg_music:play()
            start_game()
        end
    end
end


function love.update(dt)
    snow_system:update(dt)
    tick = tick + 1
    if tick == 60 then
        seconds_in = seconds_in + 1
        tick = 0
        sickle_manager:on_every_second(seconds_in)
    end
    if seconds_in == 60 then
        -- TODO: Player has won
    end
    if gamestate == gamestates.title then
        update_menu()
    elseif gamestate == gamestates.game then
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
    end
	if love.keyboard.isDown('a') then
        player.is_moving_left = true  
        else
            player.is_moving_left = false
	end

    player:update(dt)
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

    if gamestate == gamestates.title then
        draw_title()
    end
    if gamestate == gamestates.game then    
        draw_game()
    end
    if gamestate == gamestates.retry then
        draw_gameover()
    end
end


--#region Draw Functions
function draw_title()
    --love.graphics.print("Sickle Dodge",40, 40, 0, 1, 1)
    --love.graphics.print("[jump] to play",70, 80, 0, 1, 1)
    love.graphics.draw(title_img, 50, 45, 0, 0.19, 0.19)
end

function draw_game()
    love.graphics.push("all")
    love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 0, 0, 0, 1, 1)
    draw_hud()
    love.graphics.pop()
    draw_snow()
    player:draw()
    platfrom:draw()
    world:draw()
    sickle_manager:draw()
    draw_death_markers()
    love.graphics.setColor(love.math.colorFromBytes(255, 255, 255, 130))
    love.graphics.print( seconds_in, 110, 15, 0, 3, 3)
    love.graphics.setColor(255,255,255)
end

function draw_death_markers()
    for dm in all(death_markers) do
        love.graphics.draw(death_marker, dm[1], dm[2],0,0.2, 0.2, death_marker:getWidth()/2, death_marker:getHeight()/2)
    end
end

function draw_snow()
    love.graphics.draw(snow_system, 0, -6)
end

function draw_hud()
    love.graphics.print("Attempt: "..tostring(player_attempt), 180, 0, 0, 1, 1)
end

function draw_gameover()
    draw_snow()
    draw_death_markers()
    platfrom:draw()
    draw_hud()
    if math.floor(love.timer.getTime()) % 2 == 0 then
        love.graphics.print("[jump] to try again",60, 70, 0, 1, 1)
      end
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


function go_to_gameover()
    gamestate = gamestates.retry
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


function save_game()
    data = {}
    data.longest_time = 13
    data.has_won = false
    serialized = lume.serialize(data)
    love.filesystem.write("sickle.sav", serialized)
end

function load_game()

    if love.filesystem.getInfo("sickle.sav") then
        file = love.filesystem.read("sickle.sav")
        data = lume.deserialize(file)

        longest_time = data.longest_time
        player.has_won = data.has_won or false

    end
end