local S, L, DB, _, C = unpack(select(2, ...))
local _
--- 專業技能提升 [你的附魔技能提升到102→附魔 102]
ERR_SKILL_UP_SI = "%s   |cff1eff00%d|r"
if GetLocale() == "zhCN" then  
--- 提示AH賣出
ERR_AUCTION_SOLD_S = "|cff1eff00%s|r |cffffffff已卖出.|r"
--- 上下線提示，下線紅色上線綠色
BN_INLINE_TOAST_FRIEND_OFFLINE = "\124TInterface\\FriendsFrame\\UI-Toast-ToastIcons.tga:16:16:0:0:128:64:2:29:34:61\124t%s|cffFF7F50离线了|r."
BN_INLINE_TOAST_FRIEND_ONLINE = "\124TInterface\\FriendsFrame\\UI-Toast-ToastIcons.tga:16:16:0:0:128:64:2:29:34:61\124t%s|cff00C957上线了|r."
end
if GetLocale() == "zhTW" then  
BN_INLINE_TOAST_FRIEND_OFFLINE = "\124TInterface\\FriendsFrame\\UI-Toast-ToastIcons.tga:16:16:0:0:128:64:2:29:34:61\124t%s|cffFF7F50離線了|r."
BN_INLINE_TOAST_FRIEND_ONLINE = "\124TInterface\\FriendsFrame\\UI-Toast-ToastIcons.tga:16:16:0:0:128:64:2:29:34:61\124t%s|cff00C957上線了|r."
ERR_AUCTION_SOLD_S = "|cff1eff00%s|r |cffffffff已賣出.|r"
end

