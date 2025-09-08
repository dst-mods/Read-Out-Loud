-- 大肉逻辑
local CommonSignItemBase = require("scripts.signitems.base.CommonSignItemBase")

local SeedsToBird = setmetatable({}, { __index = CommonSignItemBase })
SeedsToBird.__index = SeedsToBird

-- 构造函数
function SeedsToBird:new()
    local inst = setmetatable(CommonSignItemBase:new(), self)
    return inst
end

function SeedsToBird:getItems()
    return "[Ss]eeds"
end

function SeedsToBird:getTalkers()
    return "[Cc]row|[Rr]obin|[Cc]anary|[Bb]ird|[Pp]uffin|[Pp]olly|[Dd]oydoy|[Pp]arrot|[Tt]oucan|[Ss]eagull|[Cc]ormorant|[Ss]eagull|[Kk]ingfisher|[Pp]igeon"
end
function SeedsToBird:getId()
    return "SeedsToBird";
end
return SeedsToBird
