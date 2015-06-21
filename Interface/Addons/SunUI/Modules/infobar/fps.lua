local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local IB = S:GetModule("InfoBar")

function IB:CreateFPS()
	local A = S:GetModule("Skins")
	local stat = CreateFrame("Frame", "InfoPanel2", TopInfoPanel or UIParent)
	stat:SetFrameStrata("BACKGROUND")
	stat:SetFrameLevel(3)
	stat:EnableMouse(true)

	stat.text = S:CreateFS(stat, nil, nil, IB.font)
	if InfoPanel1 then
		stat.text:SetPoint("LEFT", InfoPanel1, "RIGHT", 20, 0)
	else
		stat.text:SetPoint("LEFT", TopInfoMoveHeader, "LEFT", 0, 0)
	end
	
	stat.icon = stat:CreateTexture(nil, "OVERLAY")
	stat.icon:SetSize(8, 8)
	stat.icon:SetPoint("RIGHT", stat.text, "LEFT", -5, 0)
	stat.icon:SetTexture(IB.backdrop)
	A:CreateShadow(stat, stat.icon)

	stat:SetPoint("TOPLEFT", stat.icon)
	stat:SetPoint("BOTTOMLEFT", stat.icon)
	stat:SetPoint("TOPRIGHT", stat.text)
	stat:SetPoint("BOTTOMRIGHT", stat.text)

	local function color(num)
		local r, g, b = S:ColorGradient(num/24, IB.InfoBarStatusColor[1][1], IB.InfoBarStatusColor[1][2], IB.InfoBarStatusColor[1][3], 
																			IB.InfoBarStatusColor[2][1], IB.InfoBarStatusColor[2][2], IB.InfoBarStatusColor[2][3],
																			IB.InfoBarStatusColor[3][1], IB.InfoBarStatusColor[3][2], IB.InfoBarStatusColor[3][3])
		stat.icon:SetVertexColor(r, g, b, 0.8)
	end
	
	local function colorfont(num2, fonttext)
		local num = tonumber(num2)
		if num > 60 then
			fonttext:SetTextColor(210/255, 100/255, 100/255, 0.8)
		elseif (num >= 24 and num < 60) then
			fonttext:SetTextColor(232/255, 218/255, 15/255, 0.8)
		else
			fonttext:SetTextColor(100/255, 210/255, 100/255, 0.8)
		end
	end
	
	local int = -1
	local fpsdata = {}
	
	local infoframe = IB:CreateInfoFrame(stat, 1, 4, 220, 70)
	infoframe:Hide()
	infoframe["t1"]:SetText(FPS_ABBR)
	infoframe["t1"]:SetTextColor(0.75, 0.9, 1)
	infoframe["l1n1"]:SetText(L["当前值"])
	infoframe["l1n1"]:SetTextColor(255, 215, 0)
	infoframe["l1n2"]:SetText(L["最小值"])
	infoframe["l1n2"]:SetTextColor(255, 215, 0)
	infoframe["l1n3"]:SetText(L["最大值"])
	infoframe["l1n3"]:SetTextColor(255, 215, 0)
	infoframe["l1n4"]:SetText(L["平均值"])
	infoframe["l1n4"]:SetTextColor(255, 215, 0)
	
	local function Update(self, t)
		int = int - t
		if int < 0 then
			local fps = floor(GetFramerate())
			color(fps)
			fpsdata = IB:InsertTable(fps, fpsdata)
			stat.text:SetText(fps.."|cffffd700fps|r")
			int = 1
		end
	end
	
	local int2 = -1
	local function UpdateInfo(self, t)
		int2 = int2 - t
		if int2 < 0 then
			local fpsmin, fpsmax, fpsrms = fpsdata[1], fpsdata[#fpsdata], 0
			local fps = floor(GetFramerate())
			
			for i=1, #fpsdata do
				fpsrms = fpsrms + fpsdata[i]
			end
			fpsrms = format("%0.1f", fpsrms/#fpsdata)

			infoframe["l1v1"]:SetText(fps)
			colorfont(fps, infoframe["l1v1"])
			infoframe["l1v2"]:SetText(fpsmin)
			colorfont(fpsmin, infoframe["l1v2"])
			infoframe["l1v3"]:SetText(fpsmax)
			colorfont(fpsmax, infoframe["l1v3"])
			infoframe["l1v4"]:SetText(fpsrms)
			colorfont(fpsrms, infoframe["l1v4"])
			int2 = 1
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
	
	stat:SetScript("OnUpdate", Update) 
end