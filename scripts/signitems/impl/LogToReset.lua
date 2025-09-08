-- 大肉逻辑
local CommonSignItemBase = require("scripts.signitems.base.CommonSignItemBase")
local SignItemBase = require("scripts.signitems.base.SignItemBase")

local LogToReset = setmetatable({}, { __index = CommonSignItemBase })
LogToReset.__index = LogToReset

-- 构造函数
function LogToReset:new()
    local inst = setmetatable(CommonSignItemBase:new(), self)
    return inst
end

function LogToReset:getItems()
    return "[Ll]og"
end
-- 容错处理,按理来说永远不会被调用
function LogToReset:read(_, text, sign_inst)
    return false;
end
function CommonSignItemBase:give(giver, item, sign_inst)
    if (not SignItemBase:give(giver, item, sign_inst)) then
        return false
    end
    -- 将槽位的代表连同新鲜度一起掉落
    for _, slot in ipairs(sign_inst.slots) do
        TheSim:SpawnPrefab(slot.prefab):DoTaskInTime(0, function(p)
            if not slot.freshness == nil then
                p.components.perishable:SetPercent(slot.freshness)
            end
        end)
    end
    -- 直接清空数据
    sign_inst.slots = {}
end
return LogToReset
