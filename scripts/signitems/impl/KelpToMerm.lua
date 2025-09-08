-- 大肉逻辑
local CommonSignItemBase = require("scripts.signitems.base.CommonSignItemBase")

local KelpToMerm = setmetatable({}, { __index = CommonSignItemBase })
KelpToMerm.__index = KelpToMerm

-- 构造函数
function KelpToMerm:new()
    local inst = setmetatable(CommonSignItemBase:new(), self)
    return inst
end

function KelpToMerm:getItems()
    return "[Kk]elp|[Kk]elp*[Ff]ronds"
end

function KelpToMerm:getTalkers()
    return "[Mm]erm"
end

function KelpToMerm:getId()
    return "KelpToMerm";
end

return KelpToMerm
