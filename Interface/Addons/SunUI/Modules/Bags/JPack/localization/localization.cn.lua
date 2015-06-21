local S, L, P = unpack(select(2, ...))
local JP = S:GetModule("JPack")
if GetLocale() ~= "zhCN" then return end

JP.TYPE_BAG = "容器"
JP.TYPE_FISHWEAPON = "鱼竿"
JP.TYPE_MISC = "其它"

JP.JPACK_ORDER={"炉石","##坐骑","矿工锄","剥皮小刀","鱼竿","#鱼竿","#武器","#护甲",
"#武器##其它","#护甲##其它","#配方","#任务","##元素","##金属和矿石","##草药",
"#材料","##珠宝","#消耗品","##布料","#商品","##肉类","#","鱼油","灵魂碎片","#其它"}

JP.JPACK_DEPOSIT={"##元素","##金属和矿石","#材料","##草药","#珠宝","#容器"}
JP.JPACK_DRAW={"#任务","##草药"}

JP["HELP"] = "输入'/jpack help'获取帮助."
JP["COMPLETE"] = "整理完毕..."
JP["WARN"] = "请先拿掉你鼠标上的物品. 整理时不要抓起物品、金钱、法术."
JP["Unknown command"] = "未知命令"

-- Help info
JP["Slash command"] = "命令"
JP["Pack"] = "整理"
JP["Set sequence to ascend"] = "正序整理"
JP["Set sequence to descend"] = "逆序整理"
JP["Save to the bank"] = "保存到银行"
JP["Load from the bank"] = "从银行取出"
JP["Print help info"] = "显示帮助"
