if GetLocale() ~= "zhTW" then return end
local L

-----------------------
-- Brawlers --
-----------------------
L= DBM:GetModLocalization("Brawlers")

L:SetGeneralLocalization({
	name = "基本設置"
})

L:SetWarningLocalization({
	specWarnYourTurn	= "輪到你上場了!"
})

L:SetOptionLocalization({
	specWarnYourTurn	= "輪到你上時顯示特別警告",
	SpectatorMode		= "當旁觀戰鬥時顯示警告/計時器"
})

L:SetMiscLocalization({
--	Bizmo			= "Bizmo",
	--I wish there was a better way to do this....so much localizing. :(
--	Rank			= "Rank (%d+)",--Experimental "Entering arena" detection by scanning for Rank plus number
--	EnteringArena1	= "Now entering the arena",
--	EnteringArena2	= "Here's our challenger",
--	EnteringArena3	= "Look out... here comes",
--	EnteringArena4	= "Put your hands together",
	Rank1			= "第1階",
	Rank2			= "第2階",
	Rank3			= "第3階",
	Rank4			= "第4階",
	Rank5			= "第5階",
	Rank6			= "第6階",
	Rank7			= "第7階",
	Rank8			= "第8階",
	Victory1		= "是我們的贏家",
	Victory2		= "恭喜",
	Victory3		= "非常好",
	Victory4		= "獲勝!",
	Victory5		= "竟然還活著",
	Victory6		= "贏得漂亮",
	Lost1			= "麻煩請你把自己的屍體搬走",
	Lost2			= "你到底有沒有在打",
	Lost3			= "能不能找個牧師還是什麼的來一下",
	Lost4			= "回去排好隊再來試一次",
	Lost5			= "結局...不盡如人意",
	Lost6			= "繼續加油",
	Lost7			= "要做煎蛋，你就得先打幾個蛋",
	Lost8			= "名字叫",--LoL at fight club reference here
	Lost9			= "想辦法別死這麼大"
})

------------
-- Rank 1 --
------------
L= DBM:GetModLocalization("BrawlRank1")

L:SetGeneralLocalization({
	name = "鬥陣俱樂部: Rank 1"
})

------------
-- Rank 2 --
------------
L= DBM:GetModLocalization("BrawlRank2")

L:SetGeneralLocalization({
	name = "鬥陣俱樂部: Rank 2"
})

------------
-- Rank 3 --
------------
L= DBM:GetModLocalization("BrawlRank3")

L:SetGeneralLocalization({
	name = "鬥陣俱樂部: Rank 3"
})

------------
-- Rank 4 --
------------
L= DBM:GetModLocalization("BrawlRank4")

L:SetGeneralLocalization({
	name = "鬥陣俱樂部: Rank 4"
})

------------
-- Rank 5 --
------------
L= DBM:GetModLocalization("BrawlRank5")

L:SetGeneralLocalization({
	name = "鬥陣俱樂部: Rank 5"
})

------------
-- Rank 6 --
------------
L= DBM:GetModLocalization("BrawlRank6")

L:SetGeneralLocalization({
	name = "鬥陣俱樂部: Rank 6"
})

------------
-- Rank 7 --
------------
L= DBM:GetModLocalization("BrawlRank7")

L:SetGeneralLocalization({
	name = "鬥陣俱樂部: Rank 7"
})

------------
-- Rank 8 --
------------
L= DBM:GetModLocalization("BrawlRank8")

L:SetGeneralLocalization({
	name = "鬥陣俱樂部: Rank 8"
})
