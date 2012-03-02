local _, _, _, DB = unpack(select(2, ...))
if not IsAddOnLoaded("BigWigs") then return end

local dummy = function()end
local styled = false

local buttonsize=15--23
local font= DB.Font
local tex="Interface\\TargetingFrame\\UI-StatusBar.blp"
local backdropcolor={.3,.3,.3}
local backdrop={
		bgFile = "Interface\\Buttons\\WHITE8x8",
		edgeFile = "Interface\\Buttons\\WHITE8x8",
		tile = false, tileSize = 0, edgeSize = 1, 
		insets = { left = -1, right = -1, top = -1, bottom = -1}
	}
local function gen_backdrop(ds)
	if ds then
		ds:SetBackdrop(backdrop)
		ds:SetBackdropColor(.1,.1,.1,1)
		ds:SetBackdropBorderColor(0,0,0,1)
	end
end

--buttonsize = 17
-- init some tables to store backgrounds
local freebg = {}

-- styling functions
local createbg = function()
	local bg = CreateFrame("Frame")
	gen_backdrop(bg)
	return bg
end

local function freestyle(bar)

	-- reparent and hide bar background
	local bg = bar:Get("bigwigs:MonoUI:barbg")
	if bg then
		bg:ClearAllPoints()
		bg:SetParent("UIParent")
		bg:Hide()
		freebg[#freebg + 1] = bg
	end

	-- reparent and hide icon background
	local ibg = bar:Get("bigwigs:MonoUI:iconbg")
	if ibg then
		ibg:ClearAllPoints()
		ibg:SetParent("UIParent")
		ibg:Hide()
		freebg[#freebg + 1] = ibg
	end

	-- replace dummies with original method functions
	bar.candyBarBar.SetPoint=bar.candyBarBar.OldSetPoint
	bar.candyBarIconFrame.SetWidth=bar.candyBarIconFrame.OldSetWidth
	--bar.SetScale=bar.OldSetScale

	--Reset Positions
	--Icon
	bar.candyBarIconFrame:ClearAllPoints()
	bar.candyBarIconFrame:SetPoint("TOPLEFT")
	bar.candyBarIconFrame:SetPoint("BOTTOMLEFT")
	bar.candyBarIconFrame:SetTexCoord(0.07, 0.93, 0.07, 0.93)

	--Status Bar
	bar.candyBarBar:ClearAllPoints()
	bar.candyBarBar:SetPoint("TOPRIGHT")
	bar.candyBarBar:SetPoint("BOTTOMRIGHT")

	--BG
	bar.candyBarBackground:SetAllPoints()

	--Duration
	bar.candyBarDuration:ClearAllPoints()
	bar.candyBarDuration:SetPoint("RIGHT", bar.candyBarBar, "RIGHT", -2, 0)

	--Name
	bar.candyBarLabel:ClearAllPoints()
	bar.candyBarLabel:SetPoint("LEFT", bar.candyBarBar, "LEFT", 2, 0)
	bar.candyBarLabel:SetPoint("RIGHT", bar.candyBarBar, "RIGHT", -2, 0)	
end

local applystyle = function(bar)

	-- general bar settings
	bar.OldHeight = bar:GetHeight()
	--bar.OldScale = bar:GetScale()
	--bar.OldSetScale=bar.SetScale
	--bar.SetScale=dummy
	bar:SetHeight(buttonsize/2.5)
	--bar:SetScale(1)

	-- create or reparent and use bar background
	local bg = nil
	if #freebg > 0 then
		bg = table.remove(freebg)
	else
		bg = createbg()
	end

	bg:SetParent(bar)
	bg:ClearAllPoints()
	bg:SetPoint("TOPLEFT", bar, "TOPLEFT", -2, 2)
	bg:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 2, -2)
	bg:SetFrameStrata("BACKGROUND")
	bg:Show()
	--bar:Set("bigwigs:Default:barbg", bg)

	-- create or reparent and use icon background
	local ibg = nil
	if bar.candyBarIconFrame:GetTexture() then
		if #freebg > 0 then
			ibg = table.remove(freebg)
		else
			ibg = createbg()
		end
		ibg:SetParent(bar)
		ibg:ClearAllPoints()
		ibg:SetPoint("TOPLEFT", bar.candyBarIconFrame, "TOPLEFT", -2, 2)
		ibg:SetPoint("BOTTOMRIGHT", bar.candyBarIconFrame, "BOTTOMRIGHT", 2, -2)
		ibg:SetFrameStrata("BACKGROUND")
		ibg:Show()
		--bar:Set("bigwigs:MonoUI:iconbg", ibg)
		--gen_backdrop(ibg)
	end

	-- setup timer and bar name fonts and positions
	bar.candyBarLabel:SetFont(font, 11, "OUTLINE")
	bar.candyBarLabel:SetShadowColor(0, 0, 0, 0)
	bar.candyBarLabel:SetJustifyH("LEFT")
	bar.candyBarLabel:ClearAllPoints()
	bar.candyBarLabel:SetPoint("LEFT", bar, "LEFT", 4, buttonsize/1.5)

	bar.candyBarDuration:SetFont(font, 11, "OUTLINE")
	bar.candyBarDuration:SetShadowColor(0, 0, 0, 0)
	bar.candyBarDuration:SetJustifyH("RIGHT")
	bar.candyBarDuration:ClearAllPoints()
	bar.candyBarDuration:SetPoint("RIGHT", bar, "RIGHT", -4, buttonsize/1.5)

	-- setup bar positions and look
	bar.candyBarBar.OldPoint, bar.candyBarBar.Anchor, bar.candyBarBar.OldPoint2, bar.candyBarBar.XPoint, bar.candyBarBar.YPoint  = bar.candyBarBar:GetPoint()
	bar.candyBarBar:ClearAllPoints()
	bar.candyBarBar:SetAllPoints(bar)
	bar.candyBarBar.OldSetPoint = bar.candyBarBar.SetPoint
	bar.candyBarBar.SetPoint=dummy
	bar.candyBarBar:SetStatusBarTexture(tex)
	bar.candyBarBackground:SetTexture(unpack(backdropcolor))

	-- setup icon positions and other things
	bar.candyBarIconFrame.OldPoint, bar.candyBarIconFrame.Anchor, bar.candyBarIconFrame.OldPoint2, bar.candyBarIconFrame.XPoint, bar.candyBarIconFrame.YPoint  = bar.candyBarIconFrame:GetPoint()
	bar.candyBarIconFrame.OldWidth = bar.candyBarIconFrame:GetWidth()
	bar.candyBarIconFrame.OldHeight = bar.candyBarIconFrame:GetHeight()
	bar.candyBarIconFrame.OldSetWidth = bar.candyBarIconFrame.SetWidth
	bar.candyBarIconFrame.SetWidth=dummy
	bar.candyBarIconFrame:ClearAllPoints()
	bar.candyBarIconFrame:SetPoint("BOTTOMRIGHT", bar, "BOTTOMLEFT", -5, 0)	
	bar.candyBarIconFrame:SetSize(buttonsize, buttonsize)
	bar.candyBarIconFrame:SetTexCoord(0.08, 0.92, 0.08, 0.92)
end


local function RegisterStyle()
	if not BigWigs then return end
	local bars = BigWigs:GetPlugin("Bars", true)
	local prox = BigWigs:GetPlugin("Proximity", true)
	if bars then
		bars:RegisterBarStyle("MonoUI", {
			apiVersion = 1,
			version = 1,
			GetSpacing = function(bar) return buttonsize end,
			ApplyStyle = applystyle,
			BarStopped = freestyle,
			GetStyleName = function() return "MonoUI" end,
		})
		if not cfg.StyleBW then
			bars:SetBarStyle("Default")
		else
			bars:SetBarStyle("MonoUI")
		end
	end
end

local function PositionBWAnchor()
	if not BigWigsAnchor then return end
	BigWigsAnchor:ClearAllPoints()
	BigWigsAnchor:SetPoint("BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -5, 8)		
end


local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if event == "ADDON_LOADED" and addon == "BigWigs_Plugins" then
		RegisterStyle()
		f:UnregisterEvent("ADDON_LOADED")
--[[ 	elseif event == "PLAYER_ENTERING_WORLD" then
		LoadAddOn("BigWigs")
		LoadAddOn("BigWigs_Core")
		LoadAddOn("BigWigs_Plugins")
		LoadAddOn("BigWigs_Options")
		if not BigWigs then return end
		BigWigs:Enable()
		BigWigsOptions:SendMessage("BigWigs_StartConfigureMode", true)
		BigWigsOptions:SendMessage("BigWigs_StopConfigureMode")
		PositionBWAnchor()
	elseif event == "PLAYER_REGEN_DISABLED" then
		PositionBWAnchor()
	elseif event == "PLAYER_REGEN_ENABLED" then
		PositionBWAnchor() ]]
	end
end)



-- Load DBM varriables on demand
local SetBW = function()
if(BigWigs3DB) then table.wipe(BigWigs3DB) end
	BigWigs3DB = {
		["namespaces"] = {
			["BigWigs_Plugins_Tip of the Raid"] = {
				["profiles"] = {
					["Default"] = {
						["automatic"] = false,
					},
				},
			},
			["BigWigs_Plugins_Colors"] = {
				["profiles"] = {
					["Default"] = {
						["Important"] = {
							["BigWigs_Plugins_Colors"] = {
								["default"] = {0.8, 0.35, 0.28, 1},
							},
						},
						["barEmphasized"] = {
							["BigWigs_Plugins_Colors"] = {
								["default"] = {0.75, 0.28, 0.24},
							},
						},
						["flashshake"] = {
							["BigWigs_Plugins_Colors"] = {
								["default"] = {0.34, 0.38, 0.1, 1},
							},
						},
					},
				},
			},
			["BigWigs_Plugins_Bars"] = {
				["profiles"] = {
					["Default"] = {
						["BigWigsEmphasizeAnchor_y"] = 202,
						["BigWigsAnchor_width"] = 200,
						["BigWigsAnchor_y"] = 8,
						["BigWigsEmphasizeAnchor_x"] = 620,
						["emphasizeGrowup"] = true,
						["BigWigsAnchor_x"] = 356,
						["BigWigsEmphasizeAnchor_width"] = 202,
						["barStyle"] = "MonoUI",
						["font"] = "Friz Quadrata TT",
						["emphasizeScale"] = 1.1,
						["interceptMouse"] = false,
					},
				},
			},
			["BigWigs_Plugins_Proximity"] = {
				["profiles"] = {
					["Default"] = {
						["fontSize"] = 20,
						["width"] = 140,
						["objects"] = {
							["ability"] = false,
						},
						["posy"] = 110,
						["posx"] = 927,
						["height"] = 120,
						["font"] = "Friz Quadrata TT",
					},
				},
			},
			["BigWigs_Plugins_Messages"] = {
				["profiles"] = {
					["Default"] = {
						["outline"] = "OUTLINE",
						["fontSize"] = 20,
						["monochrome"] = false,
						["BWEmphasizeMessageAnchor_x"] = 612,
						["font"] = "Friz Quadrata TT",
						["BWEmphasizeMessageAnchor_y"] = 622,
						["BWMessageAnchor_y"] = 585,
						["BWMessageAnchor_x"] = 612,
					},
				},
			},
			["BigWigs_Plugins_Tip of the Raid"] = {
				["profiles"] = {
					["Default"] = {
						["automatic"] = false,
					},
				},
			},
		},
		["profiles"] = {
			["Default"] = {
				["shake"] = false,
			},
		},
	}
	BigWigs3IconDB = {
		["hide"] = true,
	}
end
SLASH_SETBW1 = "/setbw"
SlashCmdList["SETBW"] = function() SetBW() ReloadUI() end
