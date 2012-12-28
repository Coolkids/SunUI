local S, L, DB, _, C = unpack(select(2, ...))

L.TYPE_BAG = "Bag"
L.TYPE_FISHWEAPON = "Fishing Poles"
L.TYPE_MISC = "Miscellaneous" -- subType of [Mining Pick] id:2901

JPACK_ORDER={"Hearthstone","##Mounts","Mining Pick","Skinning Knife","Fishing Pole","#Fishing Poles",
"#Weapon","#Armor","#Weapon##Other","#Armor##Other","#Recipe",
"#Quest","##Elemental","##Metal & Stone","##Herb","#Gem","##Jewelcrafting",
"#Consumable","##Cloth","#Trade Goods","##Meat","#","Fish Oil","Soul Shard","#Miscellaneous"}
JPACK_DEPOSIT={"##Elemental","##Metal & Stone","##Herb","#Jewelcrafting","#Container"}
JPACK_DRAW={"#Quest"}

L["HELP"] = "Type '/jpack help' for help."
L["COMPLETE"] = "Pack up complete..."
L["WARN"] = "Please drop the item holding on your mouse. Don't click/hold item, money, skills while packing."
L["Unknown command"] = "Unknown command"

-- Help info
L["Slash command"] = "Slash command"
L["Pack"] = "Pack"
L["Set sequence to ascend"] = "Set sequence to asc"
L["Set sequence to descend"] = "Set sequence to desc"
L["Save to the bank"] = "Save to the bank"
L["Load from the bank"] = "Load from the bank"
L["Packup guildbank"] = 'Packup guildbank'
L["Print help info"] = "Print help info"
