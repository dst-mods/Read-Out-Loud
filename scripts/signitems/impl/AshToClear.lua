-- 大肉逻辑
local CommonSignItemBase = require("scripts.signitems.base.CommonSignItemBase")
local SignItemBase = require("scripts.signitems.base.SignItemBase")

local AshToClear = setmetatable({}, { __index = CommonSignItemBase })
AshToClear.__index = AshToClear

-- 构造函数
function AshToClear:new()
    local inst = setmetatable(CommonSignItemBase:new(), self)
    return inst
end

function AshToClear:getItems()
    return "[Aa]sh|[Aa]shes"
end
-- 容错处理,按理来说永远不会被调用
function AshToClear:read(_, text, sign_inst)
    return false;
end
function CommonSignItemBase:give(giver, item, sign_inst)
    if(not SignItemBase:give(giver, item, sign_inst)) then
        return false
    end
    -- 直接清空数据
    sign_inst.slots = {}
end
return AshToClear
