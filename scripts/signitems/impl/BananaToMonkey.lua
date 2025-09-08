-- 大肉逻辑
local CommonSignItemBase = require("scripts.signitems.base.CommonSignItemBase")

local BananaToMonkey = setmetatable({}, { __index = CommonSignItemBase })
BananaToMonkey.__index = BananaToMonkey

-- 构造函数
function BananaToMonkey:new()
    local inst = setmetatable(CommonSignItemBase:new(), self)
    return inst
end

function BananaToMonkey:getItems()
    return "[Bb]anana"
end

function BananaToMonkey:getTalkers()
    return "[Mm]onkey|[Pp]rime*[Mm]ate"
end
function BananaToMonkey:getId()
    return "BananaToMonkey";
end
return BananaToMonkey
