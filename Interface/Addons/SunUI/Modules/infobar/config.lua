﻿local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local IB = S:NewModule("InfoBar", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")
IB.modName = L["信息条"]
IB.order = 10
IB.InfoBarStatusColor = {{210/255, 100/255, 100/255}, {1, 1, 125/255}, {0, 125/255, 1}}
IB.backdrop = "Interface\\ChatFrame\\ChatFrameBackground"
IB.font = "Interface\\Addons\\SunUI\\media\\ROADWAY.TTF"
function IB:GetOptions()
	local options = {
		infobar1 = {
			type = "toggle",
			name = L["启动信息条1"],
			order = 1,
		},
		group1 = {
			type = "group", order = 2,disabled = function(info) return not self.db.infobar1 end,
			name = " ",guiInline = true,
			args = {
				topback = {
					type = "toggle",
					name = L["顶部背景"],
					order = 1,
				},
				latency = {
					type = "toggle",
					name = L["延时"],
					order = 2,
				},
				fps = {
					type = "toggle",
					name = "FPS",
					order = 3,
				},
				memory = {
					type = "toggle",
					name = L["内存"],
					order = 4,
				},
				currenry = {
					type = "toggle",
					name = L["金币"],
					order = 5,
				},
			}
		},
		infobar2 = {
			type = "toggle",
			name = L["启动信息条2"],
			order = 3,
		},
		group2 = {
			type = "group", order = 4,disabled = function(info) return not self.db.infobar2 end,
			name = " ",guiInline = true,
			args = {
				bottomback = {
					type = "toggle",
					name = L["底部背景"],
					order = 1,
				},
				clock = {
					type = "toggle",
					name = L["时钟"],
					order = 2,
				},
				durability = {
					type = "toggle",
					name = L["耐久"],
					order = 3,
				},
				dungeonhelper = {
					type = "toggle",
					name = L["地城"],
					order = 4,
				},
				specs = {
					type = "toggle",
					name = L["天赋"],
					order = 5,
				},
			}
		},
	}
	return options
end

function IB:CreateInfoFrame(parent, line, row, width, height)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetSize(width,  height)
	frame:SetClampedToScreen(true)
	frame:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", 0, -5)
	frame:SetFrameStrata("DIALOG")
	frame:CreateShadow("Background")
	--第一行标题
	
	local last;
	--第一行列名
	
	for li=1, line do
		frame["t"..li] = S:CreateFS(frame, S["media"].fontsize+3, "LEFT");
		if(li==1)then 
			frame["t"..li]:SetPoint("TOPLEFT", 10, -5)
		else
			frame["t"..li]:SetPoint("TOPLEFT", 10, -60*(li-1))
		end
		--列名
		for i=1, row do
			frame["l"..li.."n"..i] = S:CreateFS(frame);
			if (i==1) then 
				frame["l"..li.."n"..i]:SetPoint("TOPLEFT", frame["t"..li], "BOTTOMLEFT", 0, -5)
			else
				frame["l"..li.."n"..i]:SetPoint("LEFT", last, "RIGHT", 10, 0)
			end
			last = frame["l"..li.."n"..i];
		end
		--值
		for i1=1, row do
			frame["l"..li.."v"..i1] = S:CreateFS(frame);
			frame["l"..li.."v"..i1]:SetPoint("TOP", frame["l"..li.."n"..i1], "BOTTOM", 0, -5)
		end
	end
	return frame
end

function IB:PositionInfoFrame(frame, parent)
	frame:ClearAllPoints()
	local screenQuadrant = S:GetScreenQuadrant(parent)
	if screenQuadrant:find("TOP") then
		frame:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", 0, -5)
	else
		frame:SetPoint("BOTTOMLEFT", parent, "TOPLEFT", 0, 5)
	end
end

function IB:InsertTable(data, t)
	tinsert(t, data)
	if #t > 600 then
		tremove (t, 1)
	end
	table.sort(t)
	return t
end

function IB:ColorText(num, total)

	local r, g, b = S:ColorGradient(num/total, IB.InfoBarStatusColor[1][1], IB.InfoBarStatusColor[1][2], IB.InfoBarStatusColor[1][3], 
																			IB.InfoBarStatusColor[2][1], IB.InfoBarStatusColor[2][2], IB.InfoBarStatusColor[2][3],
																			IB.InfoBarStatusColor[3][1], IB.InfoBarStatusColor[3][2], IB.InfoBarStatusColor[3][3])
	return {r, g, b}
end

function IB:CreateTopBack()
	if not self.db.topback then return end
	local top = CreateFrame("Frame", "TopInfoPanel", oUF_PetBattleFrameHider)
	top:SetHeight(20)
	top:SetFrameStrata("BACKGROUND")
	top:SetFrameLevel(0)
	top:SetPoint("TOP", UIParent, 0, 3)
	top:SetPoint("LEFT", UIParent)
	top:SetPoint("RIGHT", UIParent)
	top:CreateShadow("Background")
	
end

function IB:CreateBottomBack()
	if not self.db.bottomback then return end
	local bottom = CreateFrame("Frame", "BottomInfoPanel", oUF_PetBattleFrameHider)
	bottom:SetHeight(20)
	bottom:SetFrameStrata("BACKGROUND")
	bottom:SetFrameLevel(0)
	bottom:CreateShadow("Background")
	bottom:SetPoint("BOTTOM", UIParent, 0, -3)
	bottom:SetPoint("LEFT", UIParent)
	bottom:SetPoint("RIGHT", UIParent)

end

function IB:CreateTopHeader()
	if not self.db.infobar1 then return end
	
	local TopInfoMoveHeader = CreateFrame("Frame", "TopInfoMoveHeader", UIParent)
	TopInfoMoveHeader:SetSize(80, 15)
	TopInfoMoveHeader:SetPoint("TOPLEFT", "Minimap", "TOPRIGHT", 20, 13)
	S:CreateMover(TopInfoMoveHeader, "TopInfoMoveHeaderMover", L["信息条1"], true, nil, "ALL,GENERAL")
	
	if self.db.topback then self:CreateTopBack() end
	if self.db.latency then self:CreateLatency() end
	if self.db.fps then self:CreateFPS() end
	if self.db.memory then self:CreateMemory() end
	if self.db.currenry then self:CreateCurrenry() end
end

function IB:CreateBottomHeader()
	if not self.db.infobar2 then return end
	
	local BottomInfoMoveHeader = CreateFrame("Frame", "BottomInfoMoveHeader", UIParent)
	BottomInfoMoveHeader:SetSize(80, 15)
	BottomInfoMoveHeader:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 20, 2)
	S:CreateMover(BottomInfoMoveHeader, "BottomInfoMoveHeaderMover", L["信息条2"], true, nil, "ALL,GENERAL")	
		
	if self.db.bottomback then self:CreateBottomBack() end
	if self.db.clock then self:CreateClock() end
	if self.db.durability then self:CreateDurability() end
	if self.db.dungeonhelper then self:CreateDungeonhelper() end
	if self.db.specs then self:CreateSpecs() end
end

function IB:Initialize()
	self:CreateTopHeader()
	self:CreateBottomHeader()
end

S:RegisterModule(IB:GetName())