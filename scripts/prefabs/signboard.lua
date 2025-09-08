local assets = {
    Asset("ANIM", "anim/sign_home.zip"), -- 复用原版木牌动画
}

local function CanTalk(ent)
    return ent ~= nil and ent.components ~= nil and ent.components.talker ~= nil
end

-- 正则表达式匹配 检测玩家标签或者空串以及正则匹配预制体名称
local function MatchString(ent, dist)
    if dist == "player" then
        return ent:HasTag("player")
    end
    if ent == nil then
        return false
    end
    if dist == "" then
        return true
    end
    if ent.prefab == nil or dist == nil then
        return false
    end
    return string.find(ent.prefab, dist) ~= nil
end


-- 物品与角色映射表
-- 物品 → 生物筛选规则
local ITEM_RULES = {
    meat = { rule="[Pp]ig",callback = function(inst)

    end },
    carrot = "[Bb]unny|[Rr]abbit",
    kelp = "[Mm]erm",
    -- 包含了三穿档的所有鸟
    seeds = "[Cc]row|[Rr]obin|[Cc]anary|[Bb]ird|[Pp]uffin|[Pp]olly|[Dd]oydoy|[Pp]arrot|[Tt]oucan|[Ss]eagull|[Cc]ormorant|[Ss]eagull|[Kk]ingfisher|[Pp]igeon",
    banana = "[Mm]onkey|[Pp]rime*[Mm]ate",
    cutgrass = "player",
    twigs = ""
}

local function DropAllItems(inst)
    if inst.slots then
        for _, slot in ipairs(inst.slots) do
            local loot = SpawnPrefab(slot.prefab)
            if loot then
                if slot.freshness and loot.components.perishable then
                    loot.components.perishable:SetPercent(slot.freshness)
                end
                inst.components.lootdropper:FlingItem(loot)
            end
        end
        inst.slots = {}
    end
end

local function OnAcceptItem(inst, giver, item)
    if not inst.components.sign or not inst.components.sign.text or inst.components.sign.text == "" then
        giver.components.talker:Say("木牌没有内容，不能给予！")
        return false
    end

    local prefab = item.prefab
    local perish = item.components.perishable and item.components.perishable:GetPercent() or nil

    -- 草/树枝逻辑
    if prefab == "cutgrass" or prefab == "twigs" then
        for _, slot in ipairs(inst.slots) do
            if slot.prefab == prefab then
                DropAllItems(inst)
                return false
            end
        end
    end

    -- 已有同类代表则拒绝
    for _, slot in ipairs(inst.slots) do
        if slot.prefab == prefab then
            giver.components.talker:Say("已经有这种物品了！")
            return false
        end
    end

    table.insert(inst.slots, { prefab = prefab, freshness = perish })
    item:Remove()
    inst._hasitems:set(true)
    return true
end

local function OnRead(inst, reader)
    if not inst.components.sign or not inst.components.sign.text or inst.components.sign.text == "" then
        return
    end

    local text = inst.components.sign.text
    for _, slot in ipairs(inst.slots) do
        local target_tag = ITEM_MAP[slot.prefab]
        if target_tag then
            local ents = TheSim:FindEntities(inst.Transform:GetWorldPosition(), TUNING.READ_RADIUS, { target_tag })
            for _, ent in ipairs(ents) do
                if ent.components.talker then
                    ent.components.talker:Say(text, #text * TUNING.READ_INTERVAL)
                end
            end
        end
    end
end

local function OnGiveRot(inst, giver, item)
    if item.prefab ~= "spoiled_food" then
        return false
    end

    if inst.slots and #inst.slots > 0 then
        local removed = table.remove(inst.slots, 1)
        if removed then
            local loot = SpawnPrefab(removed.prefab)
            if loot then
                inst.components.lootdropper:FlingItem(loot)
            end
            giver.components.talker:Say("已挤出一个槽位！")
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("sign_home")
    inst.AnimState:SetBuild("sign_home")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("structure")
    inst:AddTag("sign")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")

    inst:AddComponent("sign")
    inst.slots = {}

    -- RPC or custom actions绑定
    inst:ListenForEvent("readsign", OnRead)
    inst.OnAcceptItem = OnAcceptItem
    inst.OnGiveRot = OnGiveRot

    return inst
end

return Prefab("signboard", fn, assets)
