local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local A = E:NewModule("Announce", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")

A.modName = "施法通告"
A.order = 15

A.baoming = {
	[871]    = true,	-- 盾墙
	[12975]  = true,	-- 破釜沉舟
	[97462]  = true,	-- 集结呐喊
	--[2565]   = true,	-- 盾牌格挡
	[642]    = true,	-- 圣盾术
	[86659]  = true,	-- 远古列王守卫
	[31821]  = true,	-- 虔诚光环
	[31850]  = true,	-- 炽热防御者
	[498]    = true,	-- 圣佑术
	--[48707]  = true,	-- 反魔法护罩
	[50461]  = true,	-- 反魔法领域
	[48792]  = true,	-- 冰封之韧
	--[55233]  = true,	-- 吸血鬼之血
	[61336]  = true,	-- 生存本能
	[22812]  = true,	-- 树皮术
	[115176] = true, 	-- 禅悟冥想
	[115203] = true, 	-- 壮胆酒
	[122278] = true, 	-- 躯不坏
	[122783] = true, 	-- 散魔功
	[88611]  = true, 	-- 烟雾弹
}
A.heal = {
	--治疗
	[62618] = true,  -- 真言术:障
	[98008] = true,  -- 灵魂链接图腾
	[31821] = true,  -- 虔诚光环
	--[724]   = true,  -- 光明之泉
	[15286] = true,  -- 吸血鬼的拥抱 *
}
A.cl = {		
	[64843] = true,  -- 神圣赞美诗 *
	[740]   = true,  -- 宁静(ND) *
}
A.givelist = {
	[116849] = true, 	-- 作茧缚命
	[102342] = true, 	-- 铁木树皮
	[33206]  = true, 	-- 痛苦压制
	[47788]  = true, 	-- 守护之魂
	[1022]   = true,	-- 保护之手
	--[1038]   = true,	-- 拯救之手
	[6940]   = true,	-- 牺牲之手
	--[114039] = true,	-- 纯净之手
	[1044]   = true,	-- 自由之手
}
A.resurrect = {
	[20484]  = true,	-- 复生
	[61999]  = true,	-- 复活盟友
	[20707]  = true,	-- 灵魂石复活
	[126393] = true,	-- 永恒守护者
}
A.mislead = {
	[34477]  = true,	-- 误导
	[57934]  = true,	-- 嫁祸诀窍
}

function A:GetOptions()
	local options = {
		type = "group",
		name = A.modName,
		childGroups = "tree",
		get = function(info) return E.db.Announce[ info[#info] ] end,
		set = function(info, value) E.db.Announce[ info[#info] ] = value end,
		args = {
			group1 = {
				type = "group", order = 1,
				name = "",guiInline = true,
				args = {
					Open = {
					type = "toggle",
					name = "施法通告",
					desc = "只是通告自己施放的法术",
					order = 1,
					get = function(info) return self.db.Open end,
					set = function(info, value) 
						self.db.Open = value
						self:UpdateSet() 
					end,
					},
				}
			},
			group2 = {
				type = "group", order = 2, guiInline = true, disabled = function(info) return not self.db.Open end,
				name = "",
				args = {
					Interrupt = {
						type = "toggle",
						name = "打断通告",
						order = 1,
					},
					Channel = {
						type = "toggle",
						name = "治疗大招通告",
						order = 2,
					},
					Mislead = {
						type = "toggle",
						name = "误导通告",
						order = 3,
					},
					BaoM = {
						type = "toggle",
						name = "保命技能通告",
						order = 4,
					},
					Give = {
						type = "toggle",
						name = "给出大招通告",
						desc = "包含天使,痛苦压制,保护等等",
						order = 5,
					},
					Resurrect = {
						type = "toggle",
						name = "复活技能通告",
						order = 6,
					},
					Heal = {
						type = "toggle",
						name = "团队减伤通告",
						order = 7,
					},
				}
			}
		}
	}
	return options
end

function A:Info()
	local baomingstring = "保命技能通告"..":\n"
	for k,v in pairs(self.baoming) do
		baomingstring = baomingstring..S:GetSpell(k)..", "
	end
	baomingstring = baomingstring.."\n"
	
	local healstring = "团队减伤通告"..":\n"
	for k,v in pairs(self.heal) do
		healstring = healstring..S:GetSpell(k)..", "
	end
	healstring = healstring.."\n"
	
	local clstring = "治疗大招通告"..":\n"
	for k,v in pairs(self.cl) do
		clstring = clstring..S:GetSpell(k)..", "
	end
	clstring = clstring.."\n"
	
	
	local giveliststring = "给出大招通告"..":\n"
	for k,v in pairs(self.givelist) do
		giveliststring = giveliststring..S:GetSpell(k)..", "
	end
	giveliststring = giveliststring.."\n"
	
	local restring = "复活技能通告"..":\n"
	for k,v in pairs(self.resurrect) do
		restring = restring..S:GetSpell(k)..", "
	end
	restring = restring.."\n"
	
	local misstring = "误导通告"..":\n"
	for k,v in pairs(self.mislead) do
		misstring = misstring..S:GetSpell(k)..", "
	end
	misstring = misstring.."\n"
	return baomingstring..healstring..clstring..giveliststring..restring..misstring
end
function A:Initialize()
	self.db = E.db.Announce
	self:UpdateSet()
end

E:RegisterModule(A:GetName())
