--[[
Class file the the animal class, extends the actor class




--]]








function GetFirstAnimals(amount)
    local ret = {}
    for i=1, amount, 1 do
        -- Add an animal to ret
        ret[i] = {}
    end
    return ret
end