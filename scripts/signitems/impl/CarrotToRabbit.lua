-- 大肉逻辑
local CommonSignItemBase = require("scripts.signitems.base.CommonSignItemBase")

local CarrotToRabbit = setmetatable({}, { __index = CommonSignItemBase })
CarrotToRabbit.__index = CarrotToRabbit

-- 构造函数
function CarrotToRabbit:new()
    local inst = setmetatable(CommonSignItemBase:new(), self)
    return inst
end

function CarrotToRabbit:getItems()
    return "[Cc]arrot"
end

function CarrotToRabbit:getTalkers()
    return "[Bb]unny|[Rr]abbit"
end
function CarrotToRabbit:getId()
    return "CarrotToRabbit";
end
return CarrotToRabbit
