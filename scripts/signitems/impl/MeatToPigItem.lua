-- 大肉逻辑
local CommonSignItemBase = require("scripts.signitems.base.CommonSignItemBase")

local MeatToPigItem = setmetatable({}, { __index = CommonSignItemBase })
MeatToPigItem.__index = MeatToPigItem

-- 构造函数
function MeatToPigItem:new()
    local inst = setmetatable(CommonSignItemBase:new(), self)
    return inst
end

function MeatToPigItem:getItems()
    return "[Mm]eat"
end

function MeatToPigItem:getTalkers()
    return "[Pp]ig"
end
function MeatToPigItem:getId()
    return "MeatToPigItem";
end
return MeatToPigItem
