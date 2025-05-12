if SERVER then return end

LuaUserData.MakeFieldAccessible(Descriptors["Barotrauma.Items.Components.Wearable"], "wearableSprites")

local TEXTURE_CONFIG = {
    DEFAULT = {
        path = "%ModDir%/Jobgear/helmets/lm_helmet.png",
        sourceRect = Rectangle(0, 0, 0, 0),
        origin = Vector2(0.53, 0.56)
    },
    faceshield = {
        path = "%ModDir%/Jobgear/helmets/lm_helmet_faceshield.png",
        sourceRect = Rectangle(0, 0, 0, 0),
        origin = Vector2(0.53, 0.56)
    },
    protectivejaw = {
        path = "%ModDir%/Jobgear/helmets/lm_helmet_protectivejaw.png",
        sourceRect = Rectangle(0, 0, 0, 0),
        origin = Vector2(0.53, 0.56)
    },

    heavy = {
        path = "%ModDir%/Jobgear/helmets/lm_helmet_heavy.png",
        sourceRect = Rectangle(0, 0, 0, 0),
        origin = Vector2(0.53, 0.56)
    },

    nvd = {
        path = "%ModDir%/Jobgear/helmets/lm_helmet_nvd.png",
        sourceRect = Rectangle(0, 0, 0, 0),
        origin = Vector2(0.53, 0.56)
    },

    protectivejaw_nvd = {
        path = "%ModDir%/Jobgear/helmets/lm_helmet_protectivejaw_nvd.png",
        sourceRect = Rectangle(0, 0, 0, 0),
        origin = Vector2(0.53, 0.56)
    },

    ed = {
        path = "%ModDir%/Jobgear/helmets/lm_helmet_ed.png",
        sourceRect = Rectangle(0, 0, 0, 0),
        origin = Vector2(0.53, 0.56)
    },

    protectivejaw_ed = {
        path = "%ModDir%/Jobgear/helmets/lm_helmet_protectivejaw_ed.png",
        sourceRect = Rectangle(0, 0, 0, 0),
        origin = Vector2(0.53, 0.56)
    },

    THERMAL = {
        ON = {
            path = "%ModDir%/Jobgear/lm_helmet_thermalgoggles_on.png",
            sourceRect = Rectangle(0, 0, 0, 0),
            origin = Vector2(0.53, 0.56)
        },
        OFF = {
            path = "%ModDir%/Jobgear/lm_helmet_thermalgoggles_off.png",
            sourceRect = Rectangle(0, 0, 0, 0),
            origin = Vector2(0.53, 0.56)
        }
    },
    protectivejaw_THERMAL = {
        ON = {
            path = "%ModDir%/Jobgear/lm_helmet_protectivejaw_thermalgoggles_off.png",
            sourceRect = Rectangle(0, 0, 0, 0),
            origin = Vector2(0.53, 0.56)
        },
        OFF = {
            path = "%ModDir%/Jobgear/lm_helmet_protectivejaw_thermalgoggles_on.png",
            sourceRect = Rectangle(0, 0, 0, 0),
            origin = Vector2(0.53, 0.56)
        }
    }
}

--=== 状态记录 ===--
local textureState = {
    currentMode = "DEFAULT",      -- 当前模式
    thermalOn = false,            -- 热成像状态
    nightVisionOn = false         -- 夜视状态
}

--=== 预加载纹理 ===--
local loadedTextures = {}
Hook.Add("lm_helmets", function()
    -- 加载基础贴图
    for mode, config in pairs(TEXTURE_CONFIG) do
        if not config.ON then -- 非状态贴图
            loadedTextures[mode] = Game.TextureManager.LoadTexture(config.path)
        end
    end

    -- 加载状态贴图
    loadedTextures.THERMAL_ON = Game.TextureManager.LoadTexture(TEXTURE_CONFIG.THERMAL.ON.path)
    loadedTextures.THERMAL_OFF = Game.TextureManager.LoadTexture(TEXTURE_CONFIG.THERMAL.OFF.path)
    loadedTextures.NIGHT_ON = Game.TextureManager.LoadTexture(TEXTURE_CONFIG.protectivejaw_THERMAL.ON.path)
    loadedTextures.NIGHT_OFF = Game.TextureManager.LoadTexture(TEXTURE_CONFIG.protectivejaw_THERMAL.OFF.path)
end)

--=== 核心切换函数 ===--
local function SwitchTexture(item, mode)
    local cmp = item.GetComponentString("Wearable")
    if not cmp or not cmp.wearableSprites[1].Sprite then return end

    local sprite = cmp.wearableSprites[1].Sprite

    -- 处理状态贴图
    if mode == "THERMAL" then
        textureState.thermalOn = not textureState.thermalOn
        local state = textureState.thermalOn and "ON" or "OFF"
        sprite.Texture = loadedTextures["THERMAL_"..state]
        sprite.SourceRect = TEXTURE_CONFIG.THERMAL[state].sourceRect
        sprite.RelativeOrigin = TEXTURE_CONFIG.THERMAL[state].origin
        return
    elseif mode == "protectivejaw_THERMAL" then
        textureState.protectivejaw_THERMALOn = not textureState.protectivejaw_THERMALOn
        local state = textureState.protectivejaw_THERMALOn and "ON" or "OFF"
        sprite.Texture = loadedTextures["protectivejaw_THERMAL_"..state]
        sprite.SourceRect = TEXTURE_CONFIG.protectivejaw_THERMAL[state].sourceRect
        sprite.RelativeOrigin = TEXTURE_CONFIG.protectivejaw_THERMAL[state].origin
        return
    end

    -- 处理普通贴图
    if TEXTURE_CONFIG[mode] then
        textureState.currentMode = mode
        sprite.Texture = loadedTextures[mode]
        sprite.SourceRect = TEXTURE_CONFIG[mode].sourceRect
        sprite.RelativeOrigin = TEXTURE_CONFIG[mode].origin
    end
end

--=== 使用示例 ===--
-- 绑定到快捷键（示例）
Hook.Add("client.roundStart", function()
    -- F1键切换默认模式
    Game.KeyBind(key.F1, function()
        local item = GetEquippedItem() -- 需要实现获取当前装备物品的函数
        if item then SwitchTexture(item, "DEFAULT") end
    end)

    -- F2键切换热成像模式（带状态切换）
    Game.KeyBind(key.F2, function()
        local item = GetEquippedItem()
        if item then SwitchTexture(item, "THERMAL") end
    end)
end)
