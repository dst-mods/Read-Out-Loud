-- 抽象类,提供抽象方法和默认逻辑处理
local SignItemBase = {}
SignItemBase.__index = SignItemBase

-- 构造函数
-- prefab: 对应物品 prefab 名称
-- dist: 匹配规则，可以是正则或空字符串
-- 构造函数可以空或者接收一些通用配置
function SignItemBase:new()
    local inst = setmetatable({}, self)
    return inst
end

-- 是否匹配某个实体
function SignItemBase:match(ent, sign_inst)
    return false
end

-- 判断是否能说话
function SignItemBase:canTalk(item)
    return item ~= nil and item.components and item.components.talker
end

-- 木牌内容朗读
-- ent: 被朗读的实体
-- text: 木牌文字
-- sign_inst: 木牌实例
function SignItemBase:read(ent, text, sign_inst)
    error("SignItemBase:read() is abstract! Subclass must implement this method.")
end
function SignItemBase:exclusiveness()
    return false
end
-- 木牌给予物品
-- giver: 给予者
-- item: 给予物品实体
-- sign_inst: 木牌实例，包含槽位数据
function SignItemBase:give(giver, item, sign_inst)
    if not sign_inst or not sign_inst.components.sign or not sign_inst.components.sign.text
            or sign_inst.components.sign.text == "" then
        if giver.components.talker then
            giver.components.talker:Say("木牌没有内容，不能给予！")
        end
        return false
    end
    return true
end

return SignItemBase