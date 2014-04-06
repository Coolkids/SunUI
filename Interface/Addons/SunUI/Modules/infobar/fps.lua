local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local IB = S:GetModule("InfoBar")

function IB:CreateFPS()
	local A = S:GetModule("Skins")
	local stat = CreateFrame("Frame", "InfoPanel2", TopInfoPanel or UIParent)
	stat:SetFrameStrata("BACKGROUND")
	stat:SetFrameLevel(3)
	stat:EnableMouse(true)

	stat.text = S:CreateFS(stat, nil, nil, IB.font)
	stat.text:SetPoint("LEFT", InfoPanel1, "RIGHT", 20, 0)
	stat:SetAllPoints(stat.text)
	
	stat.icon = stat:CreateTexture(nil, "OVERLAY")
	stat.icon:SetSize(8, 8)
	stat.icon:SetPoint("RIGHT", stat, "LEFT", -5, 0)
	stat.icon:SetTexture(IB.backdrop)
	A:CreateShadow(stat, stat.icon)
	local function color(num)
		local r, g, b = S:ColorGradient(num/24, IB.InfoBarStatusColor[1][1], IB.InfoBarStatusColor[1][2], IB.InfoBarStatusColor[1][3], 
																			IB.InfoBarStatusColor[2][1], IB.InfoBarStatusColor[2][2], IB.InfoBarStatusColor[2][3],
																			IB.InfoBarStatusColor[3][1], IB.InfoBarStatusColor[3][2], IB.InfoBarStatusColor[3][3])
		stat.icon:SetVertexColor(r, g, b, 0.8)
	end
	local int = 1
	local function Update(self, t)
		int = int - t
		if int < 0 then
			local fps = floor(GetFramerate())
			color(fps)
			stat.text:SetText(fps.."|cffffd700fps|r")
			int = 1
		end
	end

	stat:SetScript("OnUpdate", Update) 
end