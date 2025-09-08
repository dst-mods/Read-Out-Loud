-- 大肉逻辑
local CommonSignItemBase = require("scripts.signitems.base.CommonSignItemBase")

local TwigsToAll = setmetatable({}, { __index = CommonSignItemBase })
TwigsToAll.__index = TwigsToAll

-- 构造函数
function TwigsToAll:new()
    local inst = setmetatable(CommonSignItemBase:new(), self)
    return inst
end

function TwigsToAll:getItems()
    return "[Tt]wigs"
end

function TwigsToAll:getId()
    return "TwigsToAll";
end
function TwigsToAll:getTalkers()
    return "*";
end
function TwigsToAll:exclusiveness()
    return true;
end

return TwigsToAll
