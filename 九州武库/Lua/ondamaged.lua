local TSMArmor = {
    bleeding = "tsm_armor_bleeding",
    acidburn = "tsm_armor_burn",
    burn = "tsm_armor_burn",
    lacerations = "tsm_armor_lacerations",
    stun = "tsm_armor_stun",
    blunttrauma = "tsm_armor_blunttrauma",
    huskinfection = "tsm_armor_huskinfection",
    paralysis = "tsm_armor_paralysis",
    triton_7L = "tsm_armor_triton",
    triton_9C = "tsm_armor_triton",
    triton_burn = "tsm_armor_triton",
    tsm_bl = "tsm_armor_triton",
    bitewounds = "tsm_armor_bitewounds",
    explosiondamage = "tsm_armor_explosiondamage",
    gunshotwound = "tsm_armor_gunshotwound",
    morbusinepoisoning = "tsm_armor_poisons",
    sufforinpoisoning = "tsm_armor_poisons",
    cyanidepoisoning = "tsm_armor_poisons",
    opiateoverdose = "tsm_armor_poisons",
    drunk = "tsm_armor_poisons",
    deliriuminepoisoning = "tsm_armor_poisons",
}

local ArmorResistance = {
    tsm_armor_bleeding = 0.8,
    tsm_armor_lacerations = 0.75,
    tsm_armor_burn = 0.7,
    tsm_armor_stun = 0.45,
    tsm_armor_blunttrauma = 0.7,
    tsm_armor_huskinfection = 1,
    tsm_armor_paralysis = 0.9,
    tsm_armor_triton = 0.7,
    tsm_armor_bitewounds = 0.75,
    tsm_armor_explosiondamage = 0.7,
    tsm_armor_gunshotwound = 0.7,
    tsm_armor_poisons = 0.7
}

local function Clamp(n, min, max)
    if n < min then
        n = min
    elseif n > max then
        n = max
    end

    return n
end

Hook.Add("character.applyDamage", "TSM.ondamaged", function(characterHealth, attackResult, hitLimb)
    if
        characterHealth == nil or
        attackResult == nil
    then return end

    local character = characterHealth.Character
    if
        character == nil or
        character.IsDead or
        character.Inventory == nil
    then return end

    local armor = character.Inventory.GetItemInLimbSlot(InvSlotType.OuterClothes)
    if
        armor == nil or
        armor.OwnInventory == nil
    then return end

    for affliction in attackResult.Afflictions do
        local identifier = affliction.Prefab.Identifier.Value

        if characterHealth.GetAffliction(TSMArmor[identifier]) and affliction.Strength > 0 then
            for item in armor.OwnInventory.AllItemsMod do
                if item.Prefab.Identifier.Value == TSMArmor[identifier] then
                    local surplusResistance  = Clamp(characterHealth.GetResistance(affliction.Prefab) - 1, 0, ArmorResistance[TSMArmor[identifier]])

                    item.Condition = item.Condition - affliction.Strength * (ArmorResistance[TSMArmor[identifier]] - surplusResistance)

                    break
                end
            end
        end
    end
end)