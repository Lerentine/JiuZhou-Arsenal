if SERVER then return end

LuaUserData.MakeFieldAccessible(Descriptors["Barotrauma.Items.Components.Wearable"], "wearableSprites")

local sprite_size = 500

local function update_sprite(item)
    if not item.GetComponentString("Wearable").IsActive then return end

    local item0 = item.OwnInventory.GetItemAt(0)
    local item1 = item.OwnInventory.GetItemAt(1)
    local item2 = item.OwnInventory.GetItemAt(2)
    local row = 0
    local col = 0
    if item0 ~= nil then
        if item0.Prefab.Identifier == "tsm_ballistic_faceshield_big" then
            col = 1
        elseif item0.Prefab.Identifier == "tsm_ballistic_faceshield_small" then
            col = 1
        elseif item0.Prefab.Identifier == "tsm_helmet_screen" then
            col = 6
        else
            if item0.Prefab.Identifier == "tsm_helmet_nvd" then
                col = 4
            elseif item0.Prefab.Identifier == "tsm_helmet_thermalgoggles" then
                col = 2
            end
            if item.GetComponentString("CustomInterface").customInterfaceElementList[1].state then
                col = col + 1
            end
        end
    end
    if item1 ~= nil then
        if item1.Prefab.Identifier == "tsm_protective_jaw" then
            row = 1
        elseif item1.Prefab.Identifier == "tsm_helmet_diving" then
            row = 4
        elseif item1.Prefab.Identifier == "tsm_helmet_diving1" then
            row = 5
        end
    end
    if item2 ~= nil then
        if item2.Prefab.Identifier == "tsm_helmet_flashlight" then
            row = row + 2
        end
    end

    item.GetComponentString("Wearable").wearableSprites[1].Sprite.SourceRect = Rectangle(col * sprite_size, row * sprite_size, sprite_size, sprite_size)
end

Hook.Add("item.equip", "tsm_equip_helmet", function(item, character)
    if item.HasTag("tsm_hashelmetinterface") then
        update_sprite(item)
    end
end)

Hook.Add("tsm_helmet_update", "tsm_update_helmet", function(effect, deltaTime, item, targets, worldPosition)
    update_sprite(item)
end)

Hook.Patch("Barotrauma.Items.Components.CustomInterface", "TickBoxToggled", function(instance, ptable)
    item = instance.item
    if item.HasTag("tsm_hashelmetinterface") then
        update_sprite(item)
        if Character.Controlled == item.Equipper then
            if instance.customInterfaceElementList[1].state then
                instance.PlaySound(ActionType.OnUse)
            else
                instance.PlaySound(ActionType.OnSecondaryUse)
            end
        end
    end
end, Hook.HookMethodType.After)