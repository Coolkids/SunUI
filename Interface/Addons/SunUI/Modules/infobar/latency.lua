local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local IB = S:GetModule("InfoBar")

function IB:CreateLatency()
	local A = S:GetModule("Skins")
	local stat = CreateFrame("Frame", "InfoPanel1", TopInfoPanel or UIParent)
	stat:SetFrameStrata("BACKGROUND")
	stat:SetFrameLevel(3)
	stat:EnableMouse(true)
	
	stat.text = S:CreateFS(stat, nil, nil, IB.font)
	stat.text:SetPoint("LEFT", TopInfoMoveHeader, "LEFT", 0, 0)
	stat:SetAllPoints(stat.text)
	
	stat.icon = stat:CreateTexture(nil, "OVERLAY")
	stat.icon:SetSize(8, 8)
	stat.icon:SetPoint("RIGHT", stat, "LEFT", -5, 0)
	stat.icon:SetTexture(IB.backdrop)
	
	A:CreateShadow(stat, stat.icon)
	local function colorlatency(latency)
		if latency < 100 then
			stat.icon:SetVertexColor(100/255, 210/255, 100/255, 0.8)
		elseif (latency >= 100 and latency < 200) then
			stat.icon:SetVertexColor(232/255, 218/255, 15/255, 0.8)
		else
			stat.icon:SetVertexColor(210/255, 100/255, 100/255, 0.8)
		end
	end
	local function colorfont(latency, fonttext)
		if latency < 100 then
			fonttext:SetTextColor(100/255, 210/255, 100/255, 0.8)
		elseif (latency >= 100 and latency < 200) then
			fonttext:SetTextColor(232/255, 218/255, 15/255, 0.8)
		else
			fonttext:SetTextColor(210/255, 100/255, 100/255, 0.8)
		end
	end
	
	
	local latencyHomedata,latencyWorlddata = {}, {}
	local infoframe = IB:CreateInfoFrame(stat, 2, 4, 220, 115)
	infoframe:Hide()
	infoframe["t1"]:SetText(L["本地延迟"])
	infoframe["t1"]:SetTextColor(0.75, 0.9, 1)
	infoframe["t2"]:SetText(L["世界延迟"])
	infoframe["t2"]:SetTextColor(0.75, 0.9, 1)
	infoframe["l1n1"]:SetText(L["当前值"])
	infoframe["l1n1"]:SetTextColor(255, 215, 0)
	infoframe["l1n2"]:SetText(L["最小值"])
	infoframe["l1n2"]:SetTextColor(255, 215, 0)
	infoframe["l1n3"]:SetText(L["最大值"])
	infoframe["l1n3"]:SetTextColor(255, 215, 0)
	infoframe["l1n4"]:SetText(L["平均值"])
	infoframe["l1n4"]:SetTextColor(255, 215, 0)
	infoframe["l2n1"]:SetText(L["当前值"])
	infoframe["l2n1"]:SetTextColor(255, 215, 0)
	infoframe["l2n2"]:SetText(L["最小值"])
	infoframe["l2n2"]:SetTextColor(255, 215, 0)
	infoframe["l2n3"]:SetText(L["最大值"])
	infoframe["l2n3"]:SetTextColor(255, 215, 0)
	infoframe["l2n4"]:SetText(L["平均值"])
	infoframe["l2n4"]:SetTextColor(255, 215, 0)
	
	local int2 = -1
	local function UpdateInfo(self, t)
		int2 = int2 - t
		if int2 < 0 then
			local _, _, latencyHome, latencyWorld = GetNetStats()
			
			
			local homemin, homemax, homerms = latencyHomedata[1], latencyHomedata[#latencyHomedata], 0
			local worldmin, worldmax, worldrms = latencyWorlddata[1], latencyWorlddata[#latencyWorlddata], 0
			for i=1, #latencyHomedata do
				homerms = homerms + latencyHomedata[i]
			end
			homerms = math.floor(homerms/#latencyHomedata)
			for i=1, #latencyWorlddata do
				worldrms = worldrms + latencyWorlddata[i]
			end
			worldrms = math.floor(worldrms/#latencyWorlddata)
		

			infoframe["l1v1"]:SetText(latencyHome.."ms")
			colorfont(latencyHome, infoframe["l1v1"])
			infoframe["l1v2"]:SetText(homemin.."ms")
			colorfont(homemin, infoframe["l1v2"])
			infoframe["l1v3"]:SetText(homemax.."ms")
			colorfont(homemax, infoframe["l1v3"])
			infoframe["l1v4"]:SetText(homerms.."ms")
			colorfont(homerms, infoframe["l1v4"])
			infoframe["l2v1"]:SetText(latencyWorld.."ms")
			colorfont(latencyWorld, infoframe["l2v1"])
			infoframe["l2v2"]:SetText(worldmin.."ms")
			colorfont(worldmin, infoframe["l2v2"])
			infoframe["l2v3"]:SetText(worldmax.."ms")
			colorfont(worldmax, infoframe["l2v3"])
			infoframe["l2v4"]:SetText(worldrms.."ms")
			colorfont(worldrms, infoframe["l2v4"])
			int2 = 1
		end
	end
	
	local int = -1
	local function Update(self, t)
		int = int - t
		if int < 0 then
			local _, _, latencyHome, latencyWorld = GetNetStats()
			local maxo = max(latencyHome, latencyWorld)
			colorlatency(maxo)
			latencyHomedata = IB:InsertTable(latencyHome, latencyHomedata)
			latencyWorlddata = IB:InsertTable(latencyWorld, latencyWorlddata)
			stat.text:SetText(maxo.."|cffffd700ms|r")
			int = 1
		end
	end
	
	
	stat:SetScript("OnEnter", function(self)
		IB:PositionInfoFrame(infoframe, stat)
		infoframe:Show()
		infoframe:SetScript("OnUpdate", UpdateInfo)
	end)
	stat:SetScript("OnLeave", function() 
		infoframe:Hide() 
		infoframe:SetScript("OnUpdate", nil) 
	end)
	stat:SetScript("OnMouseDown", function(self, button) 
		ToggleFrame(GameMenuFrame)
	end)
	
	stat:SetScript("OnUpdate", Update) 
end