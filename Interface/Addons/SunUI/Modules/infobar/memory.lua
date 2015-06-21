local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local IB = S:GetModule("InfoBar")

function IB:CreateMemory()
	local A = S:GetModule("Skins")
	local stat = CreateFrame("Frame", "InfoPanel3", TopInfoPanel or UIParent)
	stat:SetFrameStrata("BACKGROUND")
	stat:SetFrameLevel(3)
	stat:EnableMouse(true)

	stat.text = S:CreateFS(stat, nil, nil, IB.font)
	stat.text:SetPoint("LEFT", InfoPanel2 or InfoPanel1, "RIGHT", 20, 0)
	
	stat.icon = stat:CreateTexture(nil, "OVERLAY")
	stat.icon:SetSize(8, 8)
	stat.icon:SetPoint("RIGHT", stat.text, "LEFT", -5, 0)
	stat.icon:SetTexture(IB.backdrop)
	stat.icon:SetVertexColor(unpack(IB.InfoBarStatusColor[3]))
	A:CreateShadow(stat, stat.icon)

	stat:SetPoint("TOPLEFT", stat.icon)
	stat:SetPoint("BOTTOMLEFT", stat.icon)
	stat:SetPoint("TOPRIGHT", stat.text)
	stat:SetPoint("BOTTOMRIGHT", stat.text)
	
	local function sortdesc(a, b) return a[2] > b[2] end
	local function formatmem(val,dec)
		return format(format("%%.%df %s", dec or 1, val > 1024 and "MB" or "KB"), val / (val > 1024 and 1024 or 1))
	end
	local function gradient(perc)
		perc = perc > 1 and 1 or perc < 0 and 0 or perc -- Stay between 0-1
		local seg, relperc = math.modf(perc*2)
		local r1, g1, b1, r2, g2, b2 = select(seg * 3 + 1, 1, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0) -- R -> Y -> G
		local r, g, b = r1 + (r2 - r1) * relperc, g1 + (g2 - g1) * relperc, b1 + (b2 - b1) * relperc
		return format("|cff%02x%02x%02x", r * 255, g * 255, b * 255), r, g, b
	end
	local memoryt = {}
	stat.total = 0
	stat.hovered = false
	stat.textnum = 0
	local int = -1
	local int2 = -1
	local maxnum = 5
	local function OnUpdate(self, t)
		int = int - t
		int2 = int2 - t
		if int < 0 then
			UpdateAddOnMemoryUsage()
			--print(GetTime())
			for i = 1, GetNumAddOns() do self.total = self.total + GetAddOnMemoryUsage(i) end
			
			local text = self.total >= 1024 and format("%.1f|cffffd700mb|r", self.total / 1024) or format("%.0f|cffffd700kb|r", self.total)
			stat.textnum = self.total
			stat.text:SetText(text)
			local r, g, b = S:ColorGradient(self.total/(35 * 1024), IB.InfoBarStatusColor[3][1], IB.InfoBarStatusColor[3][2], IB.InfoBarStatusColor[3][3], 
                                                               IB.InfoBarStatusColor[2][1], IB.InfoBarStatusColor[2][2], IB.InfoBarStatusColor[2][3],
                                                               IB.InfoBarStatusColor[1][1], IB.InfoBarStatusColor[1][2], IB.InfoBarStatusColor[1][3])
       		stat.icon:SetVertexColor(r, g, b)
       		self.total = 0
			if InCombatLockdown() then
               int = 30
           	else
               int = 5
           	end
		end
		if int2 < 0 then
			if self.hovered then self:GetScript("OnEnter")(self) end
			int2 = 0.5
		end
	end

	local function OnEnter(self)
		self.hovered = true
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
		GameTooltip:ClearLines()
		local lat, r = select(4, GetNetStats()), 750
		GameTooltip:AddDoubleLine(
			format("|cffffffff%s|r %s, %s%s|r %s", floor(GetFramerate()), FPS_ABBR, gradient(1 - lat / r), lat,MILLISECONDS_ABBR),
			format("%s: |cffffffff%s", ADDONS, formatmem(self.textnum)), 0.4, 0.78, 1, 0.4, 0.78, 1)
		GameTooltip:AddLine(" ")
		
		if not self.timer or self.timer + 5 < time() then
			self.timer = time()
			collectgarbage()
			UpdateAddOnMemoryUsage()
			for i = 1, #memoryt do memoryt[i] = nil end
			for i = 1, GetNumAddOns() do
				local addon, name = GetAddOnInfo(i)
				if IsAddOnLoaded(i) then tinsert(memoryt, {name or addon, GetAddOnMemoryUsage(i)}) end
			end
			table.sort(memoryt, sortdesc)
		end
		local exmem = 0
		for i,t in ipairs(memoryt) do
			if i > maxnum and not IsAltKeyDown() then
				exmem = exmem + t[2]
			else
				local color = t[2] <= 512 and {0,1} -- 0 - 100
					or t[2] <= 1024 and {0.75,1} -- 100 - 512
					or t[2] <= 2560 and {1,1} -- 512 - 1mb
					or t[2] <= 5120 and {1,0.75} -- 1mb - 2.5mb
					or t[2] <= 7680 and {1,0.5} -- 2.5mb - 5mb
					or {1,0.1} -- 5mb +
				GameTooltip:AddDoubleLine(t[1], formatmem(t[2]), 1, 1, 1, color[1], color[2], 0)
			end
		end
		if exmem > 0 and not IsAltKeyDown() then
			local more = #memoryt - maxnum
			GameTooltip:AddDoubleLine(format("%d %s (%s)", more, HIDE, ALT_KEY), formatmem(exmem), 0.75, 0.90, 1, 0.75, 0.90, 1)
		end
		GameTooltip:AddDoubleLine(" ", "--------------", 1, 1, 1, 0.5, 0.5, 0.5)
		
		local bandwidth = GetAvailableBandwidth()
		if bandwidth ~= 0 then
			GameTooltip:AddDoubleLine(L["带宽"], format("%s ".."Mbps", S:Round(bandwidth, 2)), 0.75, 0.90, 1, 1, 1, 1)
			GameTooltip:AddDoubleLine(L["下载"], format("%s%%", floor(GetDownloadedPercentage() * 100 + 0.5)), 0.75, 0.90, 1, 1, 1, 1)
			GameTooltip:AddLine(" ")
		end
		GameTooltip:AddDoubleLine(L["暴雪插件内存"], formatmem(gcinfo() - self.textnum), 0.75, 0.90, 1, 1, 1, 1)
		GameTooltip:AddDoubleLine(L["总内存使用"], formatmem(collectgarbage"count"), 0.75, 0.90, 1, 1, 1, 1)
		GameTooltip:Show()
	end


	stat:SetScript("OnEnter", OnEnter)
	stat:SetScript("OnLeave", function(self) self.hovered = false GameTooltip:Hide() end)
	stat:SetScript("OnUpdate", OnUpdate) 

	stat:HookScript("OnMouseDown", function(self, button)
		if button == "LeftButton" then
			UpdateAddOnMemoryUsage()
			local before = gcinfo()
			collectgarbage("collect")
			UpdateAddOnMemoryUsage()
			S:Print(L["共释放内存"], formatmem(before - gcinfo()))
			self.timer, int = nil, 5
			self:GetScript("OnEnter")(self)
		elseif button == "RightButton" then
			if AddonList:IsShown() then
				AddonList_OnCancel()
			else
				--PlaySound("igMainMenuOption")
				ShowUIPanel(AddonList)
			end
		end
   end)
end