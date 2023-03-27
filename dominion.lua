--[[ Modules ]]--


local dominion = {}


--[[ Functions ]]--


dominion.fix_card_backs = function()

    local DELAY = 0.2

    local CARD_NAMES = {
        "Alchemist", "Angler", "Aristocrat", "Bride", "Daredevil", "Diplomat", "Doppelganger", "Engineer", "Explorer", "Greenhorn", "Host", "Joker", "Judge", "Laser", "Lizard", "Love", "Mesmer", "Mirage", "Muckraker", "Pentaform", "Pickpocket", "Pirate", "Quartermaster", "Reactor", "Tourist", "Usurper", "Voyager", "Whirligig", "Yin-Yang", "Ace",
    }

    local REWARD_NAMES = {
        "Victory Boon", "Solar Wind", "Ship Zap", "Rebirth", "Omni-Zap", "Rift 1", "Rift 2", "Rift 2", "Rift 3", "Kicker x4", "Kicker x2", "Kicker x2", "Kicker x1", "Kicker x-1", "Intimidate -09", "Intimidate 19", "Intimidate 29", "Intimidate 39", "Reinforcement +4", "Reinforcement +X", "Retreat", "Retreat", "Negotiate (Self Defense)", "Negotiate (Right of Refusal)", "Negotiate (Faulty Translator)", "Negotiate (Epic Oratory)", "Morph", "Attack 21/12", "Attack 12/21", "Attack 12/21", "Attack 03/30", "Attack 02/20",
    }

    ---@param deck_guid string
    ---@param parameters table<any>
    ---@param names table<string>
    local fix_deck = function(deck_guid, names, parameters)

        if reverse == nil then reverse = false end

        local deck = getObjectFromGUID(deck_guid)

        deck.setCustomObject(parameters)
        deck.reload()
        deck = getObjectFromGUID(deck_guid)

        for i, card in ipairs(deck.getObjects()) do
            Wait.time(function()
                deck.takeObject({
                    guid = card.guid, smooth = false,
                    callback_function = function(taken)
                        if deck.getName() == "Dominion: Flare" then
                            if 30 - i < 1 then
                                taken.setName("Ace Flare")
                            else
                                taken.setName(names[30-i] .. " Flare")
                            end
                        else
                            taken.setName(names[i])
                        end
                            deck.putObject(taken)
                    end,
                })
            end, i * DELAY)
        end

    end

    fix_deck("64fd15", CARD_NAMES, {
        face = "<Cosmic Encounter>ce_s_e5_aliens.png",
        back = "<Cosmic Encounter>ce_s_basegame_aliens_back.png",
        width = 6, height = 5, number = 30,
        back_is_hidden = true, -- this is the important part
    })

    fix_deck("e86720", CARD_NAMES, {
        face = "<Cosmic Encounter>ce_s_e5_flare.png",
        back = "<Cosmic Encounter>ce_s_basegame_cosmic_back.jpg",
        width = 6, height = 5, number = 30,
        back_is_hidden = true, -- the important part again
    })

    fix_deck("8ff5b0", REWARD_NAMES, {
        face = "<Cosmic Encounter>ce_s_e5_cosmic.png",
        back = "<Cosmic Encounter>ce_s_e1_rewards_back.png",
        width = 7, height = 5, number = 32,
        back_is_hidden = true,
    })

end

return dominion
