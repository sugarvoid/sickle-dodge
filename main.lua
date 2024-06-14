--! main.lua

require("lib.color")

local font
local sounds
local debug = ""
local gamestate -- 0 = menu, 1 = game, 2 = gameover
local screenWidth = 240
local screenHeight = 136


--create loadFont() function in lib

function love.load()
    
    print('set filter')
    window = {translateX = 40, translateY = 40, scale = 4, width = 240, height = 136}
    --love.window.setMode(screenWidth*4, screenHeight*4)
    love.graphics.setDefaultFilter("nearest", "nearest")
    font = love.graphics.newFont("font/mago2.ttf", 64)
    background = love.graphics.newImage("TEMP_background.png")
    
    player = {
    
        x = 50,
        y = 50,
        image = love.graphics.newImage("player.png"),
        update=function(self)
            
        end,
        draw=function(self)
            love.graphics.draw(self.image, self.x, self.y)
        end,
    }

    platfrom = {
        x=40,
        y=92,
        image = love.graphics.newImage("platform.png"),
        draw=function(self)
            love.graphics.draw(self.image, self.x, self.y)
        end,
    }

    gamestate = 0
    score = 0
    font:setFilter("nearest")
    love.graphics.setFont(font)
    --sounds = load_sounds()
    resize(240*4, 136*4)
end

print('player')






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
    if gamestate == 0 then
        update_menu()
    elseif gamestate == 1 then
        update_game(dt)
    else
        update_gameover(dt)
    end
end

function update_menu()
    return
end


function update_game(dt)
    return
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
    return
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




