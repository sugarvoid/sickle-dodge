
require("src.const")




is_debug_on = false

if is_debug_on then
    love.profiler = require('lib.profile')
end

love = require("love")
lume = require("lib.lume")
anim8 = require("lib.anim8")
logger = require("lib.log")

world = love.physics.newWorld(0, 950, true)

love.graphics.setDefaultFilter("nearest", "nearest")
-- Load Assets
-- TODO: Add get_asset function to all
local title_music = love.audio.newSource("asset/audio/snowy_c.ogg", "stream")
local bg_music = love.audio.newSource("asset/audio/8_bit_iced_village.ogg", "stream")
local snow_flake = get_asset("image", SNOWFLAKE_FILE)
local death_marker = love.graphics.newImage('asset/image/death_marker.png')
local background = get_asset("image", BACKGROUND_FILE)
local title_img = love.graphics.newImage("asset/image/title.png")
local pause_img = love.graphics.newImage("asset/image/pause.png")




require("lib.color")
require("src.player")
require("src.block")
require("src.platform")
require("src.sickle_manager")
require("src.sickle")
require("lib.kgo.debug")
require("lib.kgo.timer")
require("src.start_area")


local font = nil


gamestate = nil
local death_markers = {}
local seconds_left = 60
local tick = 0
local player_attempt = 0
local is_paused = false


--gamestate = "title"


local snow_system = love.graphics.newParticleSystem(snow_flake, 1000)
local player = Player:new()
local platfrom = Platform:new()
local sickle_manager = SickleManager:new()
--local start_block = Block:new()
local start_area = StartArea:new(start_game)

function love.load()
    if is_debug_on then
        logger.level = logger.Level.DEBUG
        logger.debug("Entering debug mode")
        love.profiler.start()
    else
        logger.level = logger.Level.INFO
        logger.info("logger in INFO mode")
    end
    local joysticks = love.joystick.getJoysticks()
    contected_controller = joysticks[1]
    init_snow()
    load_game()
    window = { translateX = 0, translateY = 0, scale = 4, width = GAME_W, height = GAME_H }
    width, height = love.graphics.getDimensions()
    love.window.setMode(width, height, { resizable = true, borderless = false })
    resize(width, height)
    bg_music:setLooping(true)
    title_music:setLooping(true)
    title_music:play()
    title_music:setVolume(0.3)
    bg_music:setVolume(0.3)
    world:setCallbacks(beginContact, endContact, preSolve, postSolve)
    font = love.graphics.newFont("asset/font/mago2.ttf", 16)
    love.graphics.setFont(font)
    gamestate = gamestates.title
    font:setFilter("nearest")
end

function reset_game()
    player_attempt = player_attempt + 1
    seconds_left = 30
    sickle_manager:reset()
    player:reset()
end

function init_snow()
    snow_system:setParticleLifetime(5, 10)
    snow_system:setEmissionRate(100)
    snow_system:setEmissionArea("normal", 240/4, 0)
    snow_system:setSpeed(1, 3)
    snow_system:setPosition(240 / 2, -6)
    snow_system:setSizes(0.7, 0.6, 0.5)
    snow_system:setSizeVariation(1)
    snow_system:setSpinVariation(1)
    snow_system:setLinearAcceleration(-2, 3, 2, 10)
    snow_system:setColors(1, 1, 1, 1, 1, 1, 1, 0)
end

function start_game()
    --start_area = nil
    gamestate = gamestates.game
    title_music:stop()
    bg_music:stop()
    bg_music:play()
    reset_game()
end

function on_player_win()
    gamestate = gamestates.win
end

function love.joystickpressed(joystick, button)
    -- 1 = X
    -- 7 = pause
   logger.debug(button)
   if button == 1 then
    player:jump()
   end
end

function love.keypressed(key)
    logger.debug(key)
    if key == "escape" then
        --love.event.quit()
        toggle_pause()
    end

    if is_paused then
        if key == "up" then
            logger.debug("Pressed up on pause menu")
            -- TODO: Make the button start the game 
            -- start_game()
        elseif key == "down" then
            logger.debug("Pressed down on pause menu")
        end
    else

    end

    if key == "m" then
        if bg_music:isPlaying() then
            bg_music:pause()
        else
            bg_music:play()
        end
    end

    if gamestate == gamestates.game then
        if key == "space" or key == "w" then
            player:jump()
        end
    end

    if gamestate == gamestates.retry then
        if key == "space" or key == "w" then
            reset_game()
            gamestate = gamestates.game
        end
    end

    if gamestate == gamestates.title then
        if key == "space" or key == "w" then
            player:jump()
            -- TODO: Make the button start the game 
            -- start_game()
        end
    end

    if is_debug_on then
        for i = 1, 9 do
            if key == (tostring(i)) then
                sickle_manager.debug_key_functions[key]()
            end
        end
    end
end

function love.update(dt)
    snow_system:update(dt)
    if check_collision(player.hitbox, start_area) then
        start_area:increase()
    else
        start_area:decrease()
    end
    if gamestate == gamestates.title then
        update_title(dt)
    elseif gamestate == gamestates.game then
        update_game(dt)
    else
        update_gameover(dt)
    end
    if is_debug_on then
        love.window.setTitle("Sickle Dodge - " .. tostring(love.timer.getFPS()))
    end
end

function update_title(dt)
    start_area:update(dt)
    player:update(dt)
    world:update(dt)
end

function update_game(dt)
    tick = tick + 1
    if seconds_left >= 1 then
        if tick == 60 then
            seconds_left = seconds_left - 1
            tick = 0
            sickle_manager:on_every_second(seconds_left)
        end
    end
    if seconds_left == 0 then
        save_game()
        gamestate = gamestates.win
    end
    world:update(dt)
    sickle_manager:update(dt)
    player:update(dt)
    
end

function update_gameover(dt)
    return
end

function spawn_death_marker(_x, _y)
    table.insert(death_markers, { _x, _y })
end

function love.joystickremoved(joystick)
    local js = joystick
    contected_controller = nil
    print(js:getName())
end

function love.joystickadded(joystick)
    contected_controller = joystick
    print()
end

function love.draw()
    love.graphics.translate(window.translateX, window.translateY)
    love.graphics.scale(window.scale)
    love.graphics.draw(background, 0, 0)
    draw_snow()

    if gamestate == gamestates.title then
        draw_title()
        --start_block:draw()
        start_area:draw()
        platfrom:draw()
        player:draw()
    end
    if gamestate == gamestates.game then
        draw_game()
    end
    if gamestate == gamestates.retry then
        draw_gameover()
    end
    if gamestate == gamestates.win then
        draw_win()
    end

    if is_paused then
        draw_pause()
    end

    if 1 == 1 then
        love.graphics.print("gs: " .. tostring(get_gs_str(gamestate)), 0, 0, 0, 0.8, 0.8)
        love.graphics.print("fps: " .. tostring(love.timer.getFPS()), 0, 8, 0, 0.8, 0.8)
    end

    
end

function draw_title()
    --love.graphics.print("[space] to play", 70, 80, 0, 1, 1)
    love.graphics.draw(title_img, 50, 30, 0, 0.19, 0.19)
end

function draw_pause()
    love.graphics.draw(pause_img, 0, 0)
    love.graphics.print("_", 49, 48)
    love.graphics.print("Resume", 57, 50, 0, 0.8, 0.8)
    love.graphics.print("option 2", 57, 58, 0, 0.8, 0.8)
    love.graphics.print("quit", 57, 66, 0, 0.8, 0.8)

end

function toggle_pause()
    is_paused = not is_paused
end



-- if gamestate == "pre_game" then
--     elseif gamestate == "game" then
--     elseif gamestate == "retry" then
--     else -- won
--     end

function draw_game()

    love.graphics.push("all")
    draw_hud()
    love.graphics.pop()

    draw_world()
    
    platfrom:draw()
    player:draw()

    if gamestate == "title" then
        draw_title()
        --start_block:draw()
        start_area:draw()
        print("pre_game")
    elseif gamestate == "game" then
        sickle_manager:draw()
        --draw_death_markers()
    elseif gamestate == "retry" then
        --draw_death_markers()
        draw_gameover()
    else -- won
        draw_win()
    end

    if gamestate ~= "title" then
        draw_death_markers()
        draw_time_left()
    end

    



    
    
    --player:draw()
    --platfrom:draw()
    --sickle_manager:draw()
    --draw_death_markers()
    
end

function draw_time_left()
    love.graphics.setColor(love.math.colorFromBytes(255, 255, 255, 100))
    love.graphics.print(seconds_left, 110, 15, 0, 3, 3)
    love.graphics.setColor(255, 255, 255)
end

function draw_world()
    for _, body in pairs(world:getBodies()) do
        for _, fixture in pairs(body:getFixtures()) do
            local shape = fixture:getShape()

            if shape:typeOf("CircleShape") then
                local cx, cy = body:getWorldPoints(shape:getPoint())
                love.graphics.circle("fill", cx, cy, shape:getRadius())
            elseif shape:typeOf("PolygonShape") then
                love.graphics.polygon("fill", body:getWorldPoints(shape:getPoints()))
            else
                love.graphics.line(body:getWorldPoints(shape:getPoints()))
            end
        end
    end
end

function draw_death_markers()
    for dm in all(death_markers) do
        love.graphics.draw(death_marker, dm[1], dm[2], 0, 0.2, 0.2, death_marker:getWidth() / 2,
            death_marker:getHeight() / 2)
    end
end

function draw_snow()
    love.graphics.draw(snow_system, 0, -6)
end

function draw_hud()
    love.graphics.print("Attempt: " .. tostring(player_attempt), 180, 0, 0, 1, 1)
end

function draw_gameover()
    --draw_snow()
    --draw_death_markers()
    --platfrom:draw()
    --draw_hud()
    -- FIXME: Can I remove this??? 
    love.graphics.print(seconds_left, 110, 15, 0, 3, 3)
    if math.floor(love.timer.getTime()) % 2 == 0 then
        love.graphics.print("jump to try again", 65, 70, 0, 1, 1)
    end
end

function draw_win()
    --draw_snow()
    --draw_death_markers()
    --platfrom:draw()
    --draw_hud()
    if math.floor(love.timer.getTime()) % 2 == 0 then
        love.graphics.print("you win", 60, 70, 0, 1, 1)
        love.graphics.print("thanks for playing", 60, 80, 0, 1, 1)
    end
end

function play_sound(_sound)
    love.audio.stop(_sound)
    love.audio.play(_sound)
end

function go_to_gameover()
    gamestate = gamestates.retry
end

function clamp(_min, _val, _max)
    return math.max(_min, math.min(_val, _max));
end

function all(_list)
    local i = 0
    return function()
        i = i + 1; return _list[i]
    end
end

function del(_table, _item)
    for i, v in ipairs(_table) do
        if v == _item then
            _table[i] = _table[#_table]
            _table[#_table] = nil
            return
        end
    end
end

function check_collision(a, b)
    return a.x < b.x + b.w and
        b.x < a.x + a.w and
        a.y < b.y + b.h and
        b.y < a.y + a.h
end

function do_tables_match(_table_1, _table_2)
    return table.concat(_table_1) == table.concat(_table_2)
end

function save_game()
    data = {}
    data.has_won = true
    serialized = lume.serialize(data)
    love.filesystem.write("sickle.sav", serialized)
end

function load_game()
    if love.filesystem.getInfo("sickle.sav") then
        file = love.filesystem.read("sickle.sav")
        data = lume.deserialize(file)
        player.has_won = data.has_won or false
        if is_debug_on then
            player.has_won = false
        end
    end
end

function beginContact(a, b, coll)
    --x, y = coll:getNormal()
    obj_a = a:getUserData()
    obj_b = b:getUserData()

    logger.debug(obj_a.obj_type .. " hit " .. obj_b.obj_type)

    -- Checking contact vector to prevent player from clinging to side of platform
    if obj_a.obj_type == "Player" and obj_b.obj_type == "Ground" and coll:getNormal() ~= { 1, 0 } then
        player:on_ground_contact()
    end
    if obj_a.obj_type == "Player" and obj_b.obj_type == "Sickle" then
        --FIXME: Player "ghosting" not working
        player:on_sickle_contact(obj_b.owner)
    end
    if obj_a.obj_type == "Ground" and obj_b.obj_type == "Sickle" then
        obj_b.owner:on_ground_contact()
    end
end

function endContact(a, b, coll) end

function preSolve(a, b, coll) end

function postSolve(a, b, coll, normalimpulse, tangentimpulse) end

function resize(w, h)                          -- update new translation and scale:
    local w1, h1 = window.width, window.height -- target rendering resolution
    local scale = math.min(w / w1, h / h1)
    window.translateX, window.translateY, window.scale = (w - w1 * scale) / 2, (h - h1 * scale) / 2, scale
end

function love.resize(w, h)
    resize(w, h) -- update new translation and scale
end

function love.quit()
    logger.info("The application is closing.")
    -- Perform your cleanup tasks here.
    -- For example, save game progress, release resources, write to log files, etc.
    if is_debug_on then
        love.profiler.stop()
        print(love.profiler.report(30))
    end

    -- Returning false or no value will allow the application to quit normally.
    -- If you return true from this callback, it will prevent the quit from happening.
end
