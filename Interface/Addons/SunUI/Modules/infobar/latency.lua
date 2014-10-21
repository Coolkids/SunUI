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
	local int = 1
	local latencyHomedata,latencyWorlddata = {}, {}
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
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
		GameTooltip:ClearLines()
		GameTooltip:AddLine(L["延迟"], 0, .6, 1)
		GameTooltip:AddLine("最近10分钟数据")
		GameTooltip:AddLine(" ")
		local _, _, latencyHome, latencyWorld = GetNetStats()
		local bandwidth = GetAvailableBandwidth()
		
		
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
		
		
		GameTooltip:AddLine(L["本地延迟"], 0.75, 0.9, 1)
		GameTooltip:AddDoubleLine("最小值", homemin)
		GameTooltip:AddDoubleLine("最大值", homemax)
		GameTooltip:AddDoubleLine("平均值", homerms)
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(L["世界延迟"], 0.75, 0.9, 1)
		GameTooltip:AddDoubleLine("最小值", worldmin)
		GameTooltip:AddDoubleLine("最大值", worldmax)
		GameTooltip:AddDoubleLine("平均值", worldrms)
		
		if bandwidth ~= 0 then
			GameTooltip:AddDoubleLine(L["带宽"]..": " , string.format("%.2f Mbps", bandwidth),0.69, 0.31, 0.31,0.84, 0.75, 0.65)
			GameTooltip:AddDoubleLine(L["下载"]..": " , string.format("%.2f%%", GetDownloadedPercentage() *100),0.69, 0.31, 0.31, 0.84, 0.75, 0.65)
		end
		GameTooltip:Show()
	end)
	stat:SetScript("OnLeave", function() GameTooltip:Hide() end)
	stat:SetScript("OnMouseDown", function(self, button) 
		ToggleFrame(GameMenuFrame)
	end)
	
	stat:SetScript("OnUpdate", Update) 
end