local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local A = S:NewModule("Announce", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")

A.modName = L["施法通告"]
A.order = 15
function A:GetOptions()
	local options = {
		group1 = {
			type = "group", order = 1,
			name = "",guiInline = true,
			args = {
				Open = {
				type = "toggle",
				name = L["施法通告"],
				desc = L["只是通告自己施放的法术"],
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
					name = L["启用打断通告"],
					order = 1,
				},
				Channel = {
					type = "toggle",
					name = L["启用治疗大招通告"],
					order = 2,
				},
				Mislead = {
					type = "toggle",
					name = L["启用误导通告"],
					order = 3,
				},
				BaoM = {
					type = "toggle",
					name = L["启用保命技能通告"],
					order = 4,
				},
				Give = {
					type = "toggle",
					name = L["启用给出大招通告"],
					desc = L["包含天使,痛苦压制,保护等等"],
					order = 5,
				},
				Resurrect = {
					type = "toggle",
					name = L["启用复活技能通告"],
					order = 6,
				},
				Heal = {
					type = "toggle",
					name = L["启用团队减伤通告"],
					order = 7,
				},
			}
		},
	}
	return options
end
function A:Info()
	local baoming = {
		[GetSpellInfo(871)] = true,	-- 盾墙
		[GetSpellInfo(12975)] = true,	--破釜沉舟
		[GetSpellInfo(97462)] = true,	--集结呐喊
		[GetSpellInfo(642)] = true,	--圣盾术
		[GetSpellInfo(86659)] = true,	--远古列王守卫
		[GetSpellInfo(31821)] = true,	--虔诚光环
		[GetSpellInfo(31850)] = true,	--炽热防御者
		[GetSpellInfo(498)] = true,	--圣佑术
		[GetSpellInfo(48707)] = true,	--反魔法护罩
		[GetSpellInfo(50461)] = true,	--反魔法领域
		[GetSpellInfo(48792)] = true,	--冰封之韧
		[GetSpellInfo(106922)] = true, --30%血
		[GetSpellInfo(61336)] = true,	--生存本能
		[GetSpellInfo(115213)] = true, 	--慈悲庇护
		[GetSpellInfo(115176)] = true, 	--禅悟冥想
		[GetSpellInfo(115203)] = true, 	--壮胆酒
	}
	local baomingstring = "保命技能包含:\n"
	for k,v in pairs(baoming) do
		baomingstring = baomingstring..k..", "
	end
	baomingstring = baomingstring.."\n"
	local heal = {
		--治疗
		[GetSpellInfo(62618)] = true, 	--真言术:障
		[GetSpellInfo(98008)] = true,  -- 灵魂链接图腾
		[GetSpellInfo(31821)] = true,  -- 光环掌握(NQ)
		[GetSpellInfo(16190)] = true,  --SM 潮汐
		[GetSpellInfo(31821)] = true,  -- 光环掌握(NQ)
		[GetSpellInfo(724)] = true, --光束泉
		[GetSpellInfo(15286)] = true,  -- 吸血鬼的拥抱 *
		--test
		--(586) = true,
	}
	local healstring = "团队减伤技能包含:\n"
	for k,v in pairs(heal) do
		healstring = healstring..k..", "
	end
	healstring = healstring.."\n"
	--通道技能
	local cl = {		
		[GetSpellInfo(64843)] = true,  -- 神圣赞美诗 *
		[GetSpellInfo(64901)] = true,	-- 希望圣歌
		[GetSpellInfo(740)] = true,  -- 宁静(ND) *
	}
	local clstring = "治疗大招包含:\n"
	for k,v in pairs(cl) do
		clstring = clstring..k..", "
	end
	clstring = clstring.."\n"
	--给的技能
	local givelist = {
		[GetSpellInfo(116849)] = true, 	--作茧缚命
		[GetSpellInfo(29166)] = true,	-- 激活
		[GetSpellInfo(33206)] = true, 	--痛苦压制
		[GetSpellInfo(47788)] = true, 	--守护之魂
		[GetSpellInfo(1022)] = true,	--保护之手
		[GetSpellInfo(1038)] = true,	--拯救之手
		[GetSpellInfo(6940)] = true,	--牺牲之手
		[GetSpellInfo(114039)] = true,	--纯净之手
		[GetSpellInfo(115310)] = true,  --五气归元
		[GetSpellInfo(115176)] = true,  --冥思禅功
	}
	local giveliststring = "治疗给出大招包含:\n"
	for k,v in pairs(givelist) do
		giveliststring = giveliststring..k..", "
	end
	giveliststring = giveliststring.."\n"
	local resurrect = {
		[GetSpellInfo(20484)] = true,	-- 复生
		[GetSpellInfo(61999)] = true,	-- 复活盟友
		[GetSpellInfo(20707)] = true,	-- 灵魂石复活	
	}
	local restring = "复活技能包含:\n"
	for k,v in pairs(resurrect) do
		restring = restring..k..", "
	end
	restring = restring.."\n"
	local mislead = {
		[GetSpellInfo(34477)] = true,	-- 误导
		[GetSpellInfo(57934)] = true,	-- 偷天
	}
	local misstring = "误导类包含:\n"
	for k,v in pairs(mislead) do
		misstring = misstring..k..", "
	end
	misstring = misstring.."\n"
	return baomingstring..healstring..clstring..giveliststring..restring..misstring
end
function A:Initialize()
	self:UpdateSet()
end

S:RegisterModule(A:GetName())