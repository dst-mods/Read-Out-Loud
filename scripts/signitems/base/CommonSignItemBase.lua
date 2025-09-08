-- 普通处理,抽象出这层是为了复用逻辑以及后续版本逻辑变更能快速切换
local SignItemBase = require("scripts.signitems.base.SignItemBase")

local CommonSignItemBase = setmetatable({}, { __index = SignItemBase })
CommonSignItemBase.__index = CommonSignItemBase

-- 构造函数
function CommonSignItemBase:new()
    local inst = setmetatable(SignItemBase:new(), self)
    return inst
end

-- 抽象方法：子类必须实现，返回匹配规则（字符串或正则表达式）
function CommonSignItemBase:getItems()
    error("getItems() must be implemented by subclass")
end

function CommonSignItemBase:getId()
    return "1"
end
-- 重写 match 方法
function CommonSignItemBase:match(ent, sign_inst)
    if ent == nil or ent.prefab == nil then
        return false
    end

    local dist = self:getItems()
    local matched = false
    if dist and dist ~= "" then
        -- 使用 string.find 支持正则表达式
        matched = string.find(ent.prefab, dist) ~= nil
    end

    -- 调用父类 match 做额外判断（比如是否可说话）
    return matched
end

-- 给予物品给木牌
function CommonSignItemBase:give(giver, item, sign_inst)
    if not SignItemBase.give(self, giver, item, sign_inst) then
        return false
    end
    local prefab = item.prefab
    local perish = item.components.perishable and item.components.perishable:GetPercent() or nil
    local id = self.getId();
    -- 初始化 slots
    sign_inst.slots = sign_inst.slots or {}
    local currentSlot;
    for _, slot in ipairs(sign_inst.slots) do
        if slot.prefab == prefab then
            currentSlot = slot;
            for _, value in ipairs(currentSlot.values) do
                -- 已有同类则拒绝
                if value.id == id then
                    if giver.components.talker then
                        giver.components.talker:Say("已经有这种物品了！")
                    end
                    return false
                end
            end
        end
    end
    -- 追加到木牌槽位
    if currentSlot == nil then
        currentSlot = { prefab = prefab, freshness = perish, values = {} }
        table.insert(sign_inst.slots, currentSlot)
    end
    -- 排他性
    if self:exclusiveness() then
        -- 清空values
        currentSlot.values = {}
    else
        -- 否则，清理掉之前排他性的
        local newValues = {}
        for _, value in ipairs(currentSlot.values) do
            if not value.exclusiveness then
                table.insert(newValues, value)
            end
        end
        currentSlot.values = newValues
    end
    -- 否则清理掉 exclusiveness等于true的数据
    table.insert(currentSlot.values, { id = id, exclusiveness = self:exclusiveness() });

    item:Remove()

    -- 更新木牌状态
    if sign_inst._hasitems then
        sign_inst._hasitems:set(true)
    end

    return true
end

function CommonSignItemBase:getTalkers()
    error("getTalkers() must be implemented by subclass")
end

function SignItemBase:read(_, text, sign_inst)
    if not sign_inst or not sign_inst.slots or #sign_inst.slots == 0 then
        return
    end
    -- 获取可读者
    local talkers = self:getTalkers()
    if not talkers or string.trim(talkers) == "" then
        return
    end
    -- 遍历槽位
    for _, slot in ipairs(sign_inst.slots) do
        -- 匹配查看是否是自己所绑定的槽位
        if not self:match(slot.prefab, sign_inst) then
            goto continue
        end
        -- 没找到就跳过
        local found = false
        for _, value in ipairs(slot.values) do
            if string.find(self:getId(), value.id) then
                found = true
                break
            end
        end
        if not found then
            goto continue
        end
        local x, y, z = sign_inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, TUNING.READ_RADIUS)

        for _, target in ipairs(ents) do
            if self:canTalk(target) and target.prefab and string.find(target.prefab, talkers) then
                target.components.talker:Say(text, #text * TUNING.READ_INTERVAL)
            end
        end
        :: continue ::
    end
end

return CommonSignItemBase
