local S, L, P = unpack(select(2, ...))
local JP = S:GetModule("JPack")
if GetLocale() == "zhCN" or GetLocale() == "zhTW" then return end

JP.TYPE_BAG = "Bag"
JP.TYPE_FISHWEAPON = "Fishing Poles"
JP.TYPE_MISC = "Miscellaneous" -- subType of [Mining Pick] id:2901

JP.JPACK_ORDER={"Hearthstone","##Mounts","Mining Pick","Skinning Knife","Fishing Pole","#Fishing Poles",
"#Weapon","#Armor","#Weapon##Other","#Armor##Other","#Recipe",
"#Quest","##Elemental","##Metal & Stone","##Herb","#Gem","##Jewelcrafting",
"#Consumable","##Cloth","#Trade Goods","##Meat","#","Fish Oil","Soul Shard","#Miscellaneous"}
JP.JPACK_DEPOSIT={"##Elemental","##Metal & Stone","##Herb","#Jewelcrafting","#Container"}
JP.JPACK_DRAW={"#Quest"}

JP["HELP"] = "Type '/jpack help' for help."
JP["COMPLETE"] = "Pack up complete..."
JP["WARN"] = "Please drop the item holding on your mouse. Don't click/hold item, money, skills while packing."
JP["Unknown command"] = "Unknown command"

-- Help info
JP["Slash command"] = "Slash command"
JP["Pack"] = "Pack"
JP["Set sequence to ascend"] = "Set sequence to asc"
JP["Set sequence to descend"] = "Set sequence to desc"
JP["Save to the bank"] = "Save to the bank"
JP["Load from the bank"] = "Load from the bank"
JP["Packup guildbank"] = 'Packup guildbank'
JP["Print help info"] = "Print help info"
