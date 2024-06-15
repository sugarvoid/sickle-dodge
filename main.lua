--! main.lua

require("lib.color")

local font
local sounds
local debug = ""
local gamestate -- 0 = menu, 1 = game, 2 = gameover
local screenWidth = 240
local screenHeight = 136

dead_sickles = {}
local active_sickles = {}

love.graphics.setDefaultFilter("nearest", "nearest")

local sickle_img = love.graphics.newImage("ice_sickle.png")

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
        moving_dir={0,0},
        life_timer=60,
        speed=0,
        draw=function(self)
            love.graphics.draw(self.image, self.x, self.y)
        end
})

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
        y=92,
        image = love.graphics.newImage("platform.png"),
        draw=function(self)
            love.graphics.draw(self.image, self.x, self.y)
        end,
    }

    test_sickle = sickle:new()

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
    if love.keyboard.isDown('d') then                    -- When the player presses and holds down the "D" button:
		player.x = player.x + (player.speed * dt)    -- The player moves to the right.
	elseif love.keyboard.isDown('a') then                -- When the player presses and holds down the "A" button:
		player.x = player.x - (player.speed * dt)    -- The player moves to the left.
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
    test_sickle:draw()
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

