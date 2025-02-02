--local moonshine = require 'moonshine'

function love.load()
  --  effect = moonshine(moonshine.effects.filmgrain)
  --      .chain(moonshine.effects.vignette)
  --  effect.filmgrain.size = 2

    game_state = "start_menu"
    zion = false

    blue_pills = {}
    red_pills = {}

    skills = {
        vitality = 0,
        agility = 0,
        intellect = 0,
        wisdom = 0,
        charisma = 0,
        luck = 0,
        focus_code = 0
    }

    spawn_timer = 0
    spawn_cooldown = 100
    red_pill_timer = 0
    red_pill_cooldown = 200
    a = 0

    zion_hall = {
        x1=200,
        y1=200,
        width=50,
        height=180
    }

    names = {
        a = {"Aaron", "Ash", "Alex"},
        b = {"Beck", "Beatrice", "Brett"},
        c = {"Charlie", "Carlos", "Carmen"},
        d = {"Daniela", "David", "Drake"}
    }    

    selections = {
        pill = nil
    }
    selected_blue_pill = {}

    selection_cooldown_start = 0
    selection_cooldown = 0

    UI = {
        location = {
            x1 = 10,
            y1 = 10,
            width = 300,
            height = 180
        },
        color = {0, 0.5, 0, 0.3}
    }

 --   create_bluepills()
end

-----------------------------------------
-------------- MECHANICS ----------------
-----------------------------------------

function gather_name(name_list)
    local keys = {} -- storage for name_list keys
    for key in pairs(name_list) do -- inserts main list keys
        table.insert(keys, key)
    end
    local letter = keys[math.random(1, #keys)] -- gathers a random letter from list of keys
    local name = name_list[letter] -- uses letter and stores the names in dict
    local gathered_name = name[math.random(1, #name)]
    return gathered_name
end

function skill_roll(skills)
    local skill_order = {
        "vitality", "agility", "intellect", "wisdom", "charisma", "luck", "focus_code"
    } -- helps with keeping the order of the skills
    local skills_to_roll = {} -- empty list to add the skills & their values
        for _, skill_name in ipairs(skill_order) do -- iterate through the order of the skills
            skills[skill_name] = math.random(1, 12) -- checks and adds value to each skill in the global skills
                                                    -- LUA can compare strings & variables in lists :O!!!!
            table.insert(skills_to_roll, { name = skill_name, value = skills[skill_name]}) 
        end
    return skills_to_roll
end

function create_bluepills()
    radius = 15

    local p = {
        x = 200,
        y = 200,
        mode = "fill",
        r = radius,
        seg = 100,
        width = radius * 2,
        height = radius * 2,
        type = "blue",
        skillset = skill_roll(skills),
        name = gather_name(names),
        color={0, 0, 1},
        movement = true
    }
    table.insert(blue_pills, p)
end

function create_redpills()
    radius = 15

    local p = {
        x = 200,
        y = 200,
        mode = "fill",
        r = radius,
        seg = 100,
        width = radius * 2,
        height = radius * 2,
        type = "red",
        name = gather_name(names),
        color={1, 0, 0},
        movement = true
    }
    table.insert(red_pills, p)
end

function switch_pills(pill, blue_pills, red_pills)
    for i = #blue_pills, 1, -1 do
        if blue_pills[i] == pill then
            table.remove(blue_pills, i)
            break
        end
    end

        pill.type="red"
        pill.color={1, 0, 0}
        table.insert(red_pills, pill)
end


function move_pills(pills)
    if pills.type == "blue" then
        if pills.movement == true then
            pills.x = pills.x + 1.2
            if pills.x > 700 then
                pills.movement = false
            end
        end

        if pills.movement == false then
            pills.x = pills.x - 1.2
            if pills.x < 100 then
                pills.movement = true
            end
        end
    end

    if pills.type == "red" then
        if pills.movement == true then
            pills.y = pills.y + 1.2
            if pills.y > 600 then
                pills.movement = false
            end
        end

        if pills.movement == false then
            pills.y = pills.y - 1.2
            if pills.y < 20 then
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


-----------------------------------------
-------------- MECHANICS ----------------
-----------------------------------------





-----------------------------------------
-------------- GAME UPDATE --------------
-----------------------------------------

function start_menu()
    if love.keyboard.isDown('z') then
        game_state = "zion_main_screen"
    end
end


function zion_main_screen()
    if love.keyboard.isDown('n') then
        game_state = "main_game_screen"
    end
end

function main_game_state()

if selection_cooldown_start == 1 then
    selection_cooldown = selection_cooldown + 1
end

for i, pill in ipairs(blue_pills) do
    local mouseOver = isMouseOver(pill)
    local leftClick = love.mouse.isDown(1)
    local rightClick = love.mouse.isDown(2)

    move_pills(pill)

    if mouseOver and leftClick then
        if selections.pill == nil then
           selections.pill = pill
           selection_cooldown_start = 1
        elseif selection_cooldown >= 10 and selections.pill == pill then
            switch_pills(selections.pill, blue_pills, red_pills)
            selections.pill = nil
            selection_cooldown_start = 0
            selection_cooldown = 0
        end
    elseif rightClick then
        selections.pill = nil
        selection_cooldown_start = 0
        selection_cooldown = 0
    end
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

for _, pill in ipairs(red_pills) do
    move_pills(pill)
end
end


function love.update(dt)
    
    if game_state == "start_menu" then
        start_menu()
    elseif game_state == "zion_main_screen" then
        zion_main_screen()
    elseif game_state == "main_game_screen" then
        main_game_state()
    end

end



function love.draw()
  --  effect(function()
   --     love.graphics.rectangle("fill", 300, 200, 200, 200)
   -- end)

    if game_state == "start_menu" then
        love.graphics.setColor(1, 1, 1)  -- White background
        love.graphics.rectangle("fill", 60, 60, 170, 40)  -- Pop-up box
        love.graphics.print("Welcome to the thunderdome....")

    elseif game_state == "zion_main_screen" then

        love.graphics.setColor(0, 0.5, 0, 0.3)
        love.graphics.rectangle("fill", zion_hall.x1, zion_hall.y1, zion_hall.width, zion_hall.height)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Click n to grather red pills", 10, 10)

    elseif game_state == "main_game_screen" then

   ----- INFO UI -----
    love.graphics.setColor(unpack(UI.color))
    love.graphics.rectangle("fill", UI.location.x1, UI.location.y1, UI.location.width, UI.location.height)




    for i, pill in ipairs(blue_pills) do
        love.graphics.setColor(pill.color)
        love.graphics.circle(pill.mode, pill.x, pill.y, pill.r, pill.seg)
        if selections.pill == pill then
            love.graphics.setColor(0, 1, 0)
            love.graphics.rectangle("line", pill.x - pill.r, pill.y - pill.r, pill.width, pill.height)
            love.graphics.setColor(1, 1, 1)  -- Black text
            love.graphics.print("Turn " .. pill.name .. " into a red pill? (Click again to turn)", UI.location.x1 + 5, UI.location.y1 + 10)
            local x = 5
            local y = 30
            for i, skill in ipairs(pill.skillset) do
               -- print("Skill: " .. skill.name .. " Value: " .. skill.value)  -- Debugging line
                love.graphics.print(skill.name .. ": " .. skill.value, UI.location.x1 + x, UI.location.y1 + y)
                y = y + 20
            end        
        elseif isMouseOver(pill) and selections.pill == nil then
            love.graphics.setColor(1, 1, 1)  -- White background
            love.graphics.rectangle("fill", pill.x + 60, pill.y, 170, 40)  -- Pop-up box
            love.graphics.setColor(0, 0, 0)  -- Black text
            love.graphics.print("Bluepill Name: " .. pill.name, pill.x + 65, pill.y + 10)
        end
    end


    for i, pill in ipairs(red_pills) do
        love.graphics.setColor(pill.color)
        love.graphics.circle(pill.mode, pill.x, pill.y, pill.r, pill.seg)
        love.graphics.setColor(0, 1, 0)

        if isMouseOver(pill) then
            love.graphics.setColor(1, 1, 1)  -- White background
            love.graphics.rectangle("fill", pill.x + 60, pill.y, 170, 40)  -- Pop-up box

            love.graphics.setColor(0, 0, 0)  -- Black text
            love.graphics.print("Redpill Name: " .. pill.name, pill.x + 65, pill.y + 10)
        end
    end

    love.graphics.setColor(1, 1, 1)
--    love.graphics.print("Blue Pills Count: " .. #blue_pills, 10, 10)
--    love.graphics.print("spawn_timer: " .. spawn_timer, 10, 24)
--    love.graphics.print("Red Pills Count: " .. #red_pills, 10, 37)
end
end