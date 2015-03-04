local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB
local A = S:GetModule("Skins")

----------------------------------------------------------------------------------------
--	BigWigs skin(by Affli)
----------------------------------------------------------------------------------------
-- Init some tables to store backgrounds
local freebg = {}

-- Styling functions
local createbg = function()
	local bg = CreateFrame("Frame")
	bg:CreateShadow("Background")
	return bg
end

local function freestyle(bar)
	-- Reparent and hide bar background
	local bg = bar:Get("bigwigs:sunui:bg")
	if bg then
		bg:ClearAllPoints()
		bg:SetParent(UIParent)
		bg:Hide()
		freebg[#freebg + 1] = bg
	end

	-- Reparent and hide icon background
	local ibg = bar:Get("bigwigs:sunui:ibg")
	if ibg then
		ibg:ClearAllPoints()
		ibg:SetParent(UIParent)
		ibg:Hide()
		freebg[#freebg + 1] = ibg
	end

	-- Replace dummies with original method functions
	bar.candyBarBar.SetPoint = bar.candyBarBar.OldSetPoint
	bar.candyBarIconFrame.SetWidth = bar.candyBarIconFrame.OldSetWidth
	bar.SetScale = bar.OldSetScale

	-- Reset Positions
	-- Icon
	bar.candyBarIconFrame:ClearAllPoints()
	bar.candyBarIconFrame:SetPoint("TOPLEFT")
	bar.candyBarIconFrame:SetPoint("BOTTOMLEFT")
	bar.candyBarIconFrame:SetTexCoord(0.07, 0.93, 0.07, 0.93)

	-- Status Bar
	bar.candyBarBar:ClearAllPoints()
	bar.candyBarBar:SetPoint("TOPRIGHT")
	bar.candyBarBar:SetPoint("BOTTOMRIGHT")

	-- BG
	bar.candyBarBackground:SetAllPoints()

	-- Duration
	bar.candyBarDuration:ClearAllPoints()
	bar.candyBarDuration:SetPoint("RIGHT", bar.candyBarBar, "RIGHT", -2, 0)

	-- Name
	bar.candyBarLabel:ClearAllPoints()
	bar.candyBarLabel:SetPoint("LEFT", bar.candyBarBar, "LEFT", 2, 0)
	bar.candyBarLabel:SetPoint("RIGHT", bar.candyBarBar, "RIGHT", -2, 0)
end

local applystyle = function(bar)
	-- General bar settings
	bar:SetHeight(10)
	bar:SetScale(1)
	bar.OldSetScale = bar.SetScale
	bar.SetScale = S.dummy

	-- Create or reparent and use bar background
	local bg = nil
	if #freebg > 0 then
		bg = table.remove(freebg)
	else
		bg = createbg()
	end
	bg:SetParent(bar)
	bg:ClearAllPoints()
	bg:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
	bg:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)
	bg:SetFrameStrata("BACKGROUND")
	bg:Show()
	bar:Set("bigwigs:sunui:bg", bg)

	-- Create or reparent and use icon background
	local ibg = nil
	if bar.candyBarIconFrame:GetTexture() then
		if #freebg > 0 then
			ibg = table.remove(freebg)
		else
			ibg = createbg()
		end
		ibg:SetParent(bar)
		ibg:ClearAllPoints()
		ibg:SetPoint("TOPLEFT", bar.candyBarIconFrame, "TOPLEFT", 0, 0)
		ibg:SetPoint("BOTTOMRIGHT", bar.candyBarIconFrame, "BOTTOMRIGHT", 0, 0)
		ibg:SetFrameStrata("BACKGROUND")
		ibg:Show()
		bar:Set("bigwigs:sunui:ibg", ibg)
	end

	-- Setup timer and bar name fonts and positions
	bar.candyBarLabel:SetFont(S["media"].font, S["media"].fontsize, S["media"].fontflag)
	bar.candyBarLabel:SetShadowOffset(S.mult, -S.mult)
	bar.candyBarLabel:SetJustifyH("LEFT")
	bar.candyBarLabel:ClearAllPoints()
	bar.candyBarLabel:SetPoint("LEFT", bar, "LEFT", 0, 10)

	bar.candyBarDuration:SetFont(S["media"].font, S["media"].fontsize, S["media"].fontflag)
	bar.candyBarDuration:SetShadowOffset(S.mult, -S.mult)
	bar.candyBarDuration:SetJustifyH("RIGHT")
	bar.candyBarDuration:ClearAllPoints()
	bar.candyBarDuration:SetPoint("RIGHT", bar, "RIGHT", 0, 10)

	-- Setup bar positions and look
	bar.candyBarBar:ClearAllPoints()
	bar.candyBarBar:SetAllPoints(bar)
	bar.candyBarBar.OldSetPoint = bar.candyBarBar.SetPoint
	bar.candyBarBar.SetPoint = S.dummy
	bar.candyBarBar:SetStatusBarTexture(S["media"].normal)
	if not bar.data["bigwigs:emphasized"] == true then bar.candyBarBar:SetStatusBarColor(S.myclasscolor.r, S.myclasscolor.g, S.myclasscolor.b, 1) end
	bar.candyBarBackground:SetTexture(nil)

	-- Setup icon positions and other things
	bar.candyBarIconFrame:ClearAllPoints()
	bar.candyBarIconFrame:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", -28, 0)
	bar.candyBarIconFrame:SetSize(20, 20)
	bar.candyBarIconFrame.OldSetWidth = bar.candyBarIconFrame.SetWidth
	bar.candyBarIconFrame.SetWidth = S.dummy
	bar.candyBarIconFrame:SetTexCoord(0.1, 0.9, 0.1, 0.9)
end

local function registerStyle()
	if not BigWigs then return end
	local bars = BigWigs:GetPlugin("Bars")
	if bars then
		bars:RegisterBarStyle("SunUI", {
			apiVersion = 1,
			version = 1,
			GetSpacing = function(bar) return S:Scale(13) end,
			ApplyStyle = applystyle,
			BarStopped = freestyle,
			GetStyleName = function() return "SunUI" end,
		})
		
	end
end


local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if event == "ADDON_LOADED" then
		if addon == "BigWigs_Plugins" then
			registerStyle()
			f:UnregisterEvent("ADDON_LOADED")
		end
	end
end)
