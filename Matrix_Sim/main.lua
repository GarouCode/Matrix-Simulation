function love.load()
    blue_pills = {}
    red_pills = {}
    spawn_timer = 0
    spawn_cooldown = 100
    red_pill_timer = 0
    red_pill_cooldown = 100
    a = 0

 --   create_bluepills()
end



function create_bluepills()
    radius = 20

    local p = {
        x = 200,
        y = 200,
        mode = "fill",
        r = radius,
        seg = 100,
        width = radius * 2,
        height = radius * 2,
        type = "blue",
        movement = true
    }
    table.insert(blue_pills, p)
end

function create_redpills()
    radius = 20

    local p = {
        x = 200,
        y = 200,
        mode = "fill",
        r = radius,
        seg = 100,
        width = radius * 2,
        height = radius * 2,
        type = "red",
        movement = true
    }
    table.insert(red_pills, p)
end


function move_pills(pills)
    if pills.type == "blue" then
        if pills.movement == true then
            pills.x = pills.x + 1
            if pills.x > 400 then
                pills.movement = false
            end
        end

        if pills.movement == false then
            pills.x = pills.x - 1
            if pills.x < 100 then
                pills.movement = true
            end
        end
    end

    if pills.type == "red" then
        if pills.movement == true then
            pills.y = pills.y + 1
            if pills.y > 400 then
                pills.movement = false
            end
        end

        if pills.movement == false then
            pills.y = pills.y - 1
            if pills.y < 100 then
                pills.movement = true
            end
        end
    end
end

function isMouseOver(entity)
    local mouse_x, mouse_y = love.mouse.getPosition()
    return mouse_x >= (entity.x - entity.r) and mouse_x <= (entity.x + entity.r ) and
           mouse_y >= (entity.y - entity.r) and mouse_y <= (entity.y + entity.r)
end




function love.update(dt)
    if #blue_pills > 0 then
        red_pill_timer = red_pill_timer + 1
    end

    if red_pill_timer >= red_pill_cooldown then
        a = math.random(0, 1)
        if a == 1 then
            create_redpills()
            a = 0
        end
        red_pill_timer = 0
    end

    if spawn_timer <= 0 then
        if love.keyboard.isDown("z") then
            create_bluepills()
            spawn_timer = 1
        end
    end

    if spawn_timer > 0 then
        spawn_timer = spawn_timer + 1
        if spawn_timer >= spawn_cooldown then
            spawn_timer = 0
        end
    end

    for _, pill in ipairs(blue_pills) do
        move_pills(pill)
    end

    for _, pill in ipairs(red_pills) do
        move_pills(pill)
    end
end



function love.draw()
    for _, pill in ipairs(blue_pills) do
        love.graphics.setColor(0, 0, 1)
        love.graphics.circle(pill.mode, pill.x, pill.y, pill.r, pill.seg)
        love.graphics.setColor(0, 1, 0)
        love.graphics.rectangle("line", pill.x - pill.r, pill.y - pill.r, pill.width, pill.height)

        if isMouseOver(pill) then
            love.graphics.setColor(1, 1, 1)  -- White background
            love.graphics.rectangle("fill", pill.x + 60, pill.y, 100, 40)  -- Pop-up box

            love.graphics.setColor(0, 0, 0)  -- Black text
            love.graphics.print("Bluepill Info", pill.x + 65, pill.y + 10)
        end
    end


    for _, pill in ipairs(red_pills) do
        love.graphics.setColor(1, 0, 0)
        love.graphics.circle(pill.mode, pill.x, pill.y, pill.r, pill.seg)
        love.graphics.setColor(0, 1, 0)
        love.graphics.rectangle("line", pill.x - pill.r, pill.y - pill.r, pill.width, pill.height)

        if isMouseOver(pill) then
            love.graphics.setColor(1, 1, 1)  -- White background
            love.graphics.rectangle("fill", pill.x + 60, pill.y, 100, 40)  -- Pop-up box

            love.graphics.setColor(0, 0, 0)  -- Black text
            love.graphics.print("Redpill Info", pill.x + 65, pill.y + 10)
        end
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Blue Pills Count: " .. #blue_pills, 10, 10)
    love.graphics.print("spawn_timer: " .. spawn_timer, 10, 23)
    love.graphics.print("Red Pills Count: " .. #blue_pills, 10, 33)
    love.graphics.print("Red pill spawn_timer: " .. spawn_timer, 10, 43)

end