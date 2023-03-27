--[[ Modules ]]--


local assets = require("assets")
local vector = require("vector")


--[[ Planets and Ships ]]--


---Adds snap points to each planet so ships don't keep trying to snap
---to the point in the middle (and end up on top of each other).
---Only adds 7 points (1 central, 6 outer) to minimise collisions, since
---having all 8 players on the same planet is extremely unlikely.
---@param planets table<table<string>>
local add_snap_points_to_planets = function(planets)

    local NUM_POINTS = 6
    local DISTANCE = 2

    local SNAP_POINTS = {
        {
            position = { 0, 0, 0 },
            rotation = { 0, 0, 0 },
            rotation_snap = true,
            -- tags = { "Ship" },
        }
    }

    for i = 1, NUM_POINTS do
        table.insert(SNAP_POINTS, {
            position = vector.shift_vector(
                { 0, 0, 0 },
                i * (360 / NUM_POINTS),
                DISTANCE),
            rotation = { 0, 0, 0 },
            rotation_snap = true,
            -- tags = { "Ship" },
        })
    end

    for _, group in ipairs(planets) do
        for i, guid in ipairs(group) do
            local planet = getObjectFromGUID(guid)
            planet.setSnapPoints(SNAP_POINTS)
        end
    end

end


---This function adjusts the rotation of planets to face the centre,
---and positions the planet scripting zones more directly over each one.
---No gameplay changes, just a consistency pass.
---@param planets table<table<string>>
---@param planet_zones table<table<string>>
local fix_planets = function(planets, planet_zones)
    for i = 1, 8 do
        for j = 1, 5 do
            local planet = getObjectFromGUID(planets[i][j])
            local zone = getObjectFromGUID(planet_zones[i][j])
            local rotation = { 0, vector.get_angle(planet.getPosition()), 0 }
            planet.setRotation(rotation)
            zone.setRotation(rotation)
            zone.setPosition(planet.getPosition())
            zone.setScale({ 3, 5, 3 })
        end
    end
end


---This function tags player ships with their colour and "Ship",
---so gameplay scripts know what they are. It also gives ships a value of 1,
---so you can select a bunch of them and the game will add them together.
---@param ship_stacks table<table<string, string>>
local fix_ship_stacks = function(ship_stacks)
    for colour, group in pairs(ship_stacks) do
        for __, guid in ipairs(group) do
            local stack = getObjectFromGUID(guid)
            stack.value = 1
            stack.setTags({ colour, "Ship" })
            stack.setRotation({ 0, vector.get_angle(stack.getPosition()), 0 })
        end
    end
end


--[[ Player Hands and Hidden Zones ]]--


---The hidden zones in each player area are slightly too high,
---which means you can see cards resting in the boxes beneath them.
---This function fixes that by moving them downwards slightly.
---@param hidden_zones table<string>
local fix_hidden_zones = function(hidden_zones)

    local POS_Y = -0.2

    for i, guid in ipairs(hidden_zones) do
        local object = getObjectFromGUID(guid)
        local position = object.getPosition()
        position.y = POS_Y
        object.setPosition(position)
    end

end


---This function makes player hand positions consistent
---(green and purple are offset differently) and makes them
---slightly wider to fit more cards.
local fix_player_hands = function()

    local POS_Y = 4
    local SCALE = { 18, 9, 6 } -- wider than default

    for i, hand in ipairs(Hands.getHands()) do
        hand.setScale(SCALE)
        local position = hand.getPosition()
        if position.x == -53 then position.x = -52.5 end -- green/purple
        if position.x == 52 then position.x = 52.5 end -- red/orange
        if position.z == -52 then position.z = -52.5 end -- yellow/blue
        if position.z == 52 then position.z = 52.5 end -- black/white
        position.y = POS_Y
        hand.setPosition(position)
    end

end


--[[ Global ]]--


local setup = {}


function setup.run()

    -- planets and ship stacks
    add_snap_points_to_planets(assets.planets)
    fix_planets(assets.planets, assets.planet_zones)
    fix_ship_stacks(assets.ship_stacks)

    -- player hands and hidden zones
    fix_hidden_zones(assets.hidden_zones)
    fix_player_hands()

end


return setup
