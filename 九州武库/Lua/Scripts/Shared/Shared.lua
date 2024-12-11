activeCharge = { }

Hook.Add("roundEnd", "Charge.resetonend", function()
    for i,v in pairs(activeCharge) do
        local light = i.GetComponentString("LightComponent")
        light.isOn = false
    end
    activeCharge = { }
end)

Hook.Add("character.death", "Charge.resetOndead", function(character)  --Reset on death
    if activeCharge == nil or character == nil then return end
    for i,v in pairs(activeCharge) do
        if v == character then
            local light = i.GetComponentString("LightComponent")
            light.isOn = false
            activeCharge[i] = nil
        end
    end
end)

Hook.Add("item.use", "Charge.itemused", function(item, usingCharacter)
    if item == nil or  usingCharacter == nil then return end
    local identifier = item.Prefab.Identifier.Value
    local methodtorun = JZ_Main.ItemMethods[identifier]
    if(methodtorun~=nil) then 
        methodtorun(item, usingCharacter)
        return
    end
end)

JZ_Main.ItemMethods = {}

JZ_Main.ItemMethods.tsm_jz_m57detonator = function(item, usingCharacter)
    if usingCharacter == nil or activeCharge == nil then return end
    for i,v in pairs(activeCharge) do
        if v == usingCharacter then
            i.Condition = 0
            activeCharge[i] = nil
        end
    end
end

JZ_Main.ItemMethods.tsm_jz_c4 = function(item, usingCharacter)
    if usingCharacter == nil then return end
    activeCharge[item] = usingCharacter
    local light = item.GetComponentString("LightComponent")
    light.isOn = true
end