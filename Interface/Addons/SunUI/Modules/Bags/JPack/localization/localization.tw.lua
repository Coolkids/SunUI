local S, L, P = unpack(select(2, ...))
local JP = S:GetModule("JPack")
if GetLocale() ~= "zhTW" then return end

JP.TYPE_BAG = "容器"
JP.TYPE_FISHWEAPON = "魚竿"
JP.TYPE_MISC = "雜項"

JP.JPACK_ORDER = {"爐石","##坐騎","採礦鎬","剝皮小刀","寶石匠的工具箱","簡單的磨粉機","魚竿","#魚竿","#武器","#護甲","#武器##其它","#護甲##其它","#配方","#任務","##元素材料","##金屬與石頭","##草藥","#材料","##珠宝","#消耗品","##布料","#商人","##肉類","#","魚油","灵魂碎片","#其它"}
JP.JPACK_DEPOSIT = {"#商人","#材料","##草藥","##肉類","#珠寶","#容器"}
JP.JPACK_DRAW = {"#任務"}

JP["HELP"] = "輸入'/jpack help'獲取幫助."
JP["COMPLETE"] = "整理完畢..."
JP["WARN"] = "請先拿掉你鼠標上的物品. 整理時不要抓起物品、金錢、法術."
JP["Unknown command"] = "未知指令"

-- Help info
JP["Slash command"] = "命令"
JP["Pack"] = "整理"
JP["Set sequence to ascend"] = "正序整理"
JP["Set sequence to descend"] = "逆序整理"
JP["Save to the bank"] = "保存到銀行"
JP["Load from the bank"] = "從銀行取出"
JP["Print help info"] = "顯示幫助"
