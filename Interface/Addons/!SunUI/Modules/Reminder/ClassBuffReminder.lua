-- Engines
local S, C, L, DB = unpack(select(2, ...))
if DB.Nuke == true then return end
local Core = LibStub("AceAddon-3.0"):GetAddon("Core")
local Module = Core:NewModule("ClassBuffReminder", "AceEvent-3.0")
local ClassBuff, BuffFrame = {}, {}
local ClassBuffList = {
	["DRUID"] = {
		-- 平衡
		[1] = {
			
		},
		-- 野性战斗
		[2] = {
			
		},
		-- 恢复
		[3] = {
			
		},
	},
	["MAGE"] = {
		-- 奥术
		[1] = {
			-- 分组 1
			[1] = {
				 7302, -- 霜甲术
				 6117, -- 法师护甲
				30482, -- 熔岩护甲	
			},
		},
		-- 火焰
		[2] = {
			-- 分组 1
			[1] = {
				 7302, -- 霜甲术
				 6117, -- 法师护甲
				30482, -- 熔岩护甲	
			},			
		},
		-- 冰霜
		[3] = {
			-- 分组 1
			[1] = {
				 7302, -- 霜甲术
				 6117, -- 法师护甲
				30482, -- 熔岩护甲	
			},			
		},
	},	
	["HUNTER"] = {
		-- 野兽控制
		[1] = {
			-- 分组 1
			[1] = {
				13165, -- 雄鹰守护
				 5118, -- 猎豹守护
				20043, -- 野性守护
				82661, -- 灵狐守护
			},
		},
		-- 射击
		[2] = {
			-- 分组 1
			[1] = {
				13165, -- 雄鹰守护
				 5118, -- 猎豹守护
				20043, -- 野性守护
				82661, -- 灵狐守护
			},			
		},
		-- 生存
		[3] = {
			-- 分组 1
			[1] = {
				13165, -- 雄鹰守护
				 5118, -- 猎豹守护
				20043, -- 野性守护
				82661, -- 灵狐守护
			},			
		},
	},	
	["PRIEST"] = {
		-- 戒律
		[1] = {
			-- 分组 1
			[1] = {
				  588, -- 心灵之火
				73413, -- 心灵意志
			},
		},
		-- 神圣
		[2] = {
			-- 分组 1
			[1] = {
				  588, -- 心灵之火
				73413, -- 心灵意志
			},		
		},
		-- 暗影
		[3] = {
			-- 分组 1
			[1] = {
				  588, -- 心灵之火
				73413, -- 心灵意志
			},	
			[2] = {
				15286, -- 吸血鬼拥抱
			},	
			[3] = {
				15473, -- 暗影形态
			},	
		},
	},	
	["ROGUE"] = {
		-- 刺杀
		[1] = {
		
		},
		-- 战斗
		[2] = {
			
		},
		-- 敏锐
		[3] = {
			
		},
	},	
	["SHAMAN"] = {
		-- 元素战斗
		[1] = {
			-- 分组 1
			[1] = {
				52127, -- 水之护盾
				  324, -- 闪电之盾
			},
		},
		-- 增强
		[2] = {
			-- 分组 1
			[1] = {
				52127, -- 水之护盾
				  324, -- 闪电之盾
			},			
		},
		-- 恢复
		[3] = {
			-- 分组 1
			[1] = {
				 52127, -- 水之护盾
				   324, -- 闪电之盾
			},			
		},
	},	
	["PALADIN"] = {
		-- 神圣
		[1] = {
			-- 分组 1
			[1] = {
				20154, -- 正义圣印
				20164, -- 公正圣印
				20165, -- 洞察圣印
				31801, -- 真理圣印
			},
			-- 分组 2
			[2] = {
				  465, -- 虔诚光环
				 7294, -- 惩戒光环
				19746, -- 专注光环
				19891, -- 抗性光环
			},	
		},
		-- 防护
		[2] = {
			-- 分组 1
			[1] = {
				  25780, -- 正义之怒
			},	
			-- 分组 2
			[2] = {
				20154, -- 正义圣印
				20164, -- 公正圣印
				20165, -- 洞察圣印
				31801, -- 真理圣印
			},
			-- 分组 3
			[3] = {
				  465, -- 虔诚光环
				 7294, -- 惩戒光环
				19746, -- 专注光环
				19891, -- 抗性光环
			},
		},
		-- 惩戒
		[3] = {
			-- 分组 1
			[1] = {
				20154, -- 正义圣印
				20164, -- 公正圣印
				20165, -- 洞察圣印
				31801, -- 真理圣印
			},
			-- 分组 2
			[2] = {
				  465, -- 虔诚光环
				 7294, -- 惩戒光环
				19746, -- 专注光环
				19891, -- 抗性光环
			},			
		},
	},	
	["WARLOCK"] = {
		-- 痛苦
		[1] = {
			-- 分组 1
			[1] = {
				 28176, -- 邪甲术
				   687, -- 魔甲术
			},
		},
		-- 恶魔学识
		[2] = {
			-- 分组 1
			[1] = {
				 28176, -- 邪甲术
				   687, -- 魔甲术
			},			
		},
		-- 毁灭
		[3] = {
			-- 分组 1
			[1] = {
				 28176, -- 邪甲术
				   687, -- 魔甲术
			},			
		},
	},	
	["DEATHKNIGHT"] = {
		-- 鲜血
		[1] = {
			-- 分组 1
			[1] = {
				48263, -- 鲜血灵气
			},
			-- 分组 2
			[2] = {
				57330, -- 寒冬号角
				 8076, -- 大地之力
				 6673, -- 战斗怒吼
				93435, -- 勇气咆哮		
			},			
		},
		-- 冰霜
		[2] = {
			-- 分组 1
			[1] = {
				48265, -- 邪恶灵气
				48266, -- 冰霜灵气
			},
			-- 分组 2
			[2] = {
				57330, -- 寒冬号角
				 8076, -- 大地之力
				 6673, -- 战斗怒吼
				93435, -- 勇气咆哮		
			},				
		},
		-- 邪恶
		[3] = {
			-- 分组 1
			[1] = {
				48265, -- 邪恶灵气
				48266, -- 冰霜灵气
			},
			-- 分组 2
			[2] = {
				57330, -- 寒冬号角
				 8076, -- 大地之力
				 6673, -- 战斗怒吼
				93435, -- 勇气咆哮		
			},				
		},
	},	
	["WARRIOR"] = {
		-- 武器
		[1] = {
			-- 分组 1
			[1] = {
				 6673, -- 战斗怒吼
				 8076, -- 大地之力
				57330, -- 寒冬号角
				93435, -- 勇气咆哮		
			},
		},
		-- 狂怒
		[2] = {
			-- 分组 1
			[1] = {
				 6673,-- 战斗怒吼
				 8076, -- 大地之力
				57330, -- 寒冬号角
				93435, -- 勇气咆哮		
			},			
		},
		-- 防护
		[3] = {
			-- 分组 1
			[1] = {
				  469, -- 命令怒吼
				 6307, -- 血之契印
				90364, -- 其拉虫群坚韧
				72590, -- 坚韧
				21562, -- 真言术：韧
			},			
		},
	},
}

local function OnEvent_PLAYER_ENTERING_WORLD(event, ...)
	for _, value in pairs(BuffFrame) do value:SetAlpha(0) end
	local i = 0
	for key, value in pairs(ClassBuff) do
		local flag = 0
		for _, temp in pairs(value) do
			local Name, _, Icon = select(1, GetSpellInfo(temp))
			if UnitAura("player", Name) then flag = 1 end
		end
		if flag == 0 then
			local Name, _, Icon = select(1, GetSpellInfo(value[1]))
			i = i + 1
			BuffFrame[i].Icon:SetTexture(Icon)
			BuffFrame[i].Icon:SetTexCoord(.1, .9, .1, .9)
			BuffFrame[i].Text:SetText(format(Name))
			BuffFrame[i]:SetAlpha(1)
		end
	end
end
local function OnEvent_ACTIVE_TALENT_GROUP_CHANGED(event, ...)
	ClassBuff = ClassBuffList[DB.MyClass][GetPrimaryTalentTree() or 1]
	for key, value in pairs(ClassBuff) do
		local Button = CreateFrame("Frame", nil, UIParent)
		Button:Size(ReminderDB.ClassBuffSize, ReminderDB.ClassBuffSize)
		Button:CreateShadow()
		Button.Icon = Button:CreateTexture(nil, "ARTWORK")
		Button.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		Button.Icon:SetAllPoints()
		Button.Text = S.MakeFontString(Button, 11*S.Scale(1))
		Button.Text:Point("TOP", Button, "BOTTOM", 0, -10)
		if key == 1 then
			MoveHandle.Class = S.MakeMoveHandle(Button, L["缺少药剂buff提示"], "Class")
		else
			Button:Point("LEFT", BuffFrame[key-1], "RIGHT", ReminderDB.ClassBuffSpace, 0)
		end
		Button:SetAlpha(0)	
		tinsert(BuffFrame, Button)
	end
end
local function OnEvent_PLAYER_REGEN_DISABLED(event, ...)
	for _, value in pairs(BuffFrame) do
		value:SetAlpha(0)
	end
	local i = 0
	for key, value in pairs(ClassBuff) do
		local flag = 0
		for _, temp in pairs(value) do
			local Name, _, Icon = select(1, GetSpellInfo(temp))
			if UnitAura("player", Name) then flag = 1 end
		end
		if flag == 0 then
			local Name, _, Icon = select(1, GetSpellInfo(value[1]))
			i = i + 1
			BuffFrame[i].Icon:SetTexture(Icon)
			BuffFrame[i].Icon:SetTexCoord(.1, .9, .1, .9)
			BuffFrame[i].Text:SetText(format(Name))
			BuffFrame[i]:SetAlpha(1)
		end
	end
	if i ~= 0 and ReminderDB.ClassBuffSound then PlaySoundFile(DB.Warning) end
end
local function OnEvent_UNIT_AURA(event, unit, ...)
	if unit ~= "player" then return end
	for _, value in pairs(BuffFrame) do value:SetAlpha(0) end
	local i = 0
	for key, value in pairs(ClassBuff) do
		local flag = 0
		for _, temp in pairs(value) do
			local Name, _, Icon = select(1, GetSpellInfo(temp))
			if UnitAura("player", Name) then flag = 1 end
		end
		if flag == 0 then
			local Name, _, Icon = select(1, GetSpellInfo(value[1]))
			i = i + 1
			BuffFrame[i].Icon:SetTexture(Icon)
			BuffFrame[i].Icon:SetTexCoord(.1, .9, .1, .9)
			BuffFrame[i].Text:SetText(format(Name))
			BuffFrame[i]:SetAlpha(1)
		end
	end
end

function Module:OnEnable()
	if not ReminderDB.ShowClassBuff then return end
	OnEvent_ACTIVE_TALENT_GROUP_CHANGED()
	Module:RegisterEvent("UNIT_AURA", OnEvent_UNIT_AURA)
	Module:RegisterEvent("PLAYER_REGEN_DISABLED", OnEvent_PLAYER_REGEN_DISABLED)
	Module:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", OnEvent_ACTIVE_TALENT_GROUP_CHANGED)
	Module:RegisterEvent("PLAYER_ENTERING_WORLD", OnEvent_PLAYER_ENTERING_WORLD)
end

