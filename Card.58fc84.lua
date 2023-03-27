--[[ Modules ]]--


local assets = require("assets")
local setup = require("setup")
local dominion = require("dominion")


--[[ Functions ]]--


function onLoad(save_data)

    local table = getObjectFromGUID(assets.table)

    setup.run()
    -- fixes planets and ship stacks
    -- fixes player hands and hidden zones

    table.setSnapPoints({})
    -- Gets rid of the snap points under planets
    -- (we added replacements during setup)

    Physics.setGravity({ x = 0, y = -50, z = 0 })
    -- changes gravity to be 1.0 instead of 0.5
    -- for some reason this doesn't update in the UI. but it does work

    dominion.fix_card_backs()
    -- fixes dominion card backs when in player hands

end


-- --[[ Modules ]]--
