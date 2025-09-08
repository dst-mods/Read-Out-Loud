-- 大肉逻辑
local CommonSignItemBase = require("scripts.signitems.base.CommonSignItemBase")

local CutgrassToPlayer = setmetatable({}, { __index = CommonSignItemBase })
CutgrassToPlayer.__index = CutgrassToPlayer

-- 构造函数
function CutgrassToPlayer:new()
    local inst = setmetatable(CommonSignItemBase:new(), self)
    return inst
end

function CutgrassToPlayer:getItems()
    return "[Cc]ut*[Gg]rass"
end

function CommonSignItemBase:read(_, text, sign_inst)
    if not sign_inst or not sign_inst.slots or #sign_inst.slots == 0 then
        return
    end
    -- 遍历槽位
    for _, slot in ipairs(sign_inst.slots) do
        -- 匹配查看是否是自己所绑定的槽位
        if not self:match(slot.prefab, sign_inst) then
            goto continue
        end
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
            if self:canTalk(target) and target.HasTag("player") then
                target.components.talker:Say(text, #text * TUNING.READ_INTERVAL)
            end
        end
        :: continue ::
    end
end
function CutgrassToPlayer:getId()
    return "CutgrassToPlayer";
end
return CutgrassToPlayer
