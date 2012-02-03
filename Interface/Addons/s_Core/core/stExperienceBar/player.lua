local S, C, L, DB = unpack(select(2, ...))
--Bar Height and Width
local barHeight, barWidth = 10*S.Scale(1), Minimap:GetWidth()+3

--Where you want the fame to be anchored
--------AnchorPoint, AnchorTo, RelativePoint, xOffset, yOffset
local Anchor = { "TOP", Minimap, "TOP", 0, barHeight}

--Fonts
local showText = true -- Set to false to hide text
local mouseoverText = true -- Set to true to only show text on mouseover
local font,fontsize,flags = DB.Font, 7*S.Scale(1), "THINOUTLINE"

--Textures
local barTex = DB.Statusbar
local flatTex = DB.Statusbar

-----------------------------------------------------------
-- Don't edit past here unless you know what your doing! --
-----------------------------------------------------------

--Prefix for naming frames
local aName = "stExperienceBar_"

--Create Background and Border
local Frame = CreateFrame("frame", aName.."Frame", UIParent)
Frame:SetHeight(barHeight)
Frame:SetWidth(barWidth)
Frame:SetPoint(unpack(Anchor))
S.MakeBG(Frame, 0)

local xpBorder = CreateFrame("frame", aName.."xpBorder", Frame)
xpBorder:SetHeight(barHeight)
xpBorder:SetWidth(barWidth)
xpBorder:SetPoint("TOP", Frame, "TOP", 0, 0)


local xpOverlay = xpBorder:CreateTexture(nil, "BORDER", xpBorder)
xpOverlay:ClearAllPoints()
xpOverlay:SetPoint("TOPLEFT", xpBorder, "TOPLEFT", 2, -2)
xpOverlay:SetPoint("BOTTOMRIGHT", xpBorder, "BOTTOMRIGHT", -2, 2)
xpOverlay:SetTexture(barTex)
xpOverlay:SetVertexColor(.05,.05,.05, 0.2)
S.MakeTexShadow(xpBorder, xpOverlay, 3)
--Create xp status bar
local xpBar = CreateFrame("StatusBar",  aName.."xpBar", xpBorder, "TextStatusBar")
--xpBar:SetWidth(barWidth-4)
--xpBar:SetHeight(GetWatchedFactionInfo() and (barHeight-7) or barHeight-4)
xpBar:SetPoint("TOPRIGHT", xpBorder, "TOPRIGHT", -2, -2)
xpBar:SetPoint("BOTTOMLEFT", xpBorder, "BOTTOMLEFT", 2, 2)
xpBar:SetStatusBarTexture(barTex)
xpBar:SetStatusBarColor(.5, 0, .75)

--Create Rested XP Status Bar
local restedxpBar = CreateFrame("StatusBar", aName.."restedxpBar", xpBorder, "TextStatusBar")
--restedxpBar:SetWidth(barWidth-4)
--restedxpBar:SetHeight(GetWatchedFactionInfo() and (barHeight-7) or barHeight-4)
restedxpBar:SetPoint("TOPRIGHT", xpBorder, "TOPRIGHT", -2, -2)
restedxpBar:SetPoint("BOTTOMLEFT", xpBorder, "BOTTOMLEFT", 2, 2)
restedxpBar:SetStatusBarTexture(barTex)
restedxpBar:Hide()

--Create reputation status bar
local repBorder = CreateFrame("frame", aName.."repBorder", Frame)
repBorder:SetHeight(5)
repBorder:SetWidth(Frame:GetWidth())
repBorder:SetPoint("BOTTOM", Frame, "BOTTOM", 0, 0)


local repOverlay = repBorder:CreateTexture(nil, "BORDER", Frame)
repOverlay:ClearAllPoints()
repOverlay:SetPoint("TOPLEFT", repBorder, "TOPLEFT", 2, -2)
repOverlay:SetPoint("BOTTOMRIGHT", repBorder, "BOTTOMRIGHT", -2, 2)
repOverlay:SetTexture(barTex)
repOverlay:SetVertexColor(.05,.05,.05, 0.2)
S.MakeTexShadow(repBorder, repOverlay, 3)
local repBar = CreateFrame("StatusBar", aName.."repBar", repBorder, "TextStatusBar")
--repBar:SetWidth(barWidth-4)
--repBar:SetHeight(st.IsMaxLevel() and barHeight-4 or 2)
repBar:SetPoint("TOPRIGHT", repBorder, "TOPRIGHT", -2, -2)
repBar:SetPoint("BOTTOMLEFT", repBorder, "BOTTOMLEFT", 2, 2)
repBar:SetStatusBarTexture(barTex)

--Create frame used for mouseover, clicks, and text
local mouseFrame = CreateFrame("Frame", aName.."mouseFrame", Frame)
mouseFrame:SetAllPoints(Frame)
mouseFrame:EnableMouse(true)
	
--Create XP Text
local Text = mouseFrame:CreateFontString(aName.."Text", "OVERLAY")
Text:SetFont(font, fontsize, flags)
Text:SetPoint("CENTER", xpBorder, "CENTER", 0, 1)
if mouseoverText == true then
	Text:SetAlpha(0)
end

--Set all frame levels (easier to see if organized this way)
Frame:SetFrameLevel(0)
xpBorder:SetFrameLevel(0)
repBorder:SetFrameLevel(0)
restedxpBar:SetFrameLevel(1)
repBar:SetFrameLevel(2)
xpBar:SetFrameLevel(2)
mouseFrame:SetFrameLevel(3)

local function updateStatus()
	local XP, maxXP = UnitXP("player"), UnitXPMax("player")
	local restXP = GetXPExhaustion()
	local percXP = floor(XP/maxXP*100)
	
	if st.IsMaxLevel() then
		xpBorder:Hide()
		repBorder:SetHeight(barHeight)
		if not GetWatchedFactionInfo() then
			Frame:Hide()
		else
			Frame:Show()
		end
		
		local name, rank, minRep, maxRep, value = GetWatchedFactionInfo()
		Text:SetText(format("%d / %d (%d%%)", value-minRep, maxRep-minRep, (value-minRep)/(maxRep-minRep)*100))
	else		
		xpBar:SetMinMaxValues(min(0, XP), maxXP)
		xpBar:SetValue(XP)
			
		if restXP then
			Text:SetText(format("%s/%s (%s%%|cffb3e1ff+%d%%|r)", st.ShortValue(XP), st.ShortValue(maxXP), percXP, restXP/maxXP*100))
			restedxpBar:Show()
			restedxpBar:SetStatusBarColor(0, .4, .8)
			restedxpBar:SetMinMaxValues(min(0, XP), maxXP)
			restedxpBar:SetValue(XP+restXP)
		else
			restedxpBar:Hide()
			Text:SetText(format("%s/%s (%s%%)", st.ShortValue(XP), st.ShortValue(maxXP), percXP))
		end
		
		if GetWatchedFactionInfo() then
			xpBorder:SetHeight(barHeight-(repBorder:GetHeight()-1))
			repBorder:Show()
		else
			xpBorder:SetHeight(barHeight)
			repBorder:Hide()
		end
	end
	
	if GetWatchedFactionInfo() then
		local name, rank, minRep, maxRep, value = GetWatchedFactionInfo()
		repBar:SetMinMaxValues(minRep, maxRep)
		repBar:SetValue(value)
		repBar:SetStatusBarColor(unpack(st.FactionInfo[rank][1]))
	end
	
	--Setup Exp Tooltip
	mouseFrame:SetScript("OnEnter", function()
		if mouseoverText == true then
			Text:SetAlpha(1)
		end


		GameTooltip:SetOwner(mouseFrame, "ANCHOR_BOTTOMLEFT", -3, barHeight)
		GameTooltip:ClearLines()
		if not st.IsMaxLevel() then
			GameTooltip:AddLine(L["经验值"])
			GameTooltip:AddLine(string.format('XP: %s/%s (%d%%)', st.ShortValue(XP), st.ShortValue(maxXP), (XP/maxXP)*100))
			GameTooltip:AddLine(string.format(L["剩余"], st.ShortValue(maxXP-XP)))
			if restXP then
				GameTooltip:AddLine(string.format(L["休息"], st.ShortValue(restXP), restXP/maxXP*100))
			end
		end
		if GetWatchedFactionInfo() then
			local name, rank, min, max, value = GetWatchedFactionInfo()
			if not st.IsMaxLevel() then GameTooltip:AddLine(" ") end
			GameTooltip:AddLine(string.format(L["阵营"], name))
			GameTooltip:AddLine(string.format(L["状态"]..st.Colorize(rank)..'%s|r', st.FactionInfo[rank][2]))
			GameTooltip:AddLine(string.format(L["声望"], st.CommaValue(value-min), st.CommaValue(max-min), (value-min)/(max-min)*100))
			GameTooltip:AddLine(string.format(L["剩余"], st.CommaValue(max-value)))
		end
		GameTooltip:Show()
	end)
	mouseFrame:SetScript("OnLeave", function()
		GameTooltip:Hide()
		if mouseoverText == true then
			Text:SetAlpha(0)
		end
	end)
	
	-- Right click menu
	--[[local function sendReport(dest, rep)--Destination, if Reputation rep = true
		if rep == true then 
			local name, rank, min, max, value = GetWatchedFactionInfo()
			SendChatMessage("我在 "..name.." 的聲望為 "..st.FactionInfo[rank][2].." "..(value-min).."/"..(max-min).." ("..floor((((value-min)/(max-min))*100)).."%).",dest)
		else
			local XP, maxXP = UnitXP("player"), UnitXPMax("player")
			SendChatMessage("我目前的經驗值： "..st.CommaValue(XP).."/"..st.CommaValue(maxXP).." ("..floor((XP/maxXP)*100).."%) ",dest)
		end
	end
			
	local reportFrame = CreateFrame("Frame", "stExperienceReportMenu", UIParent)
	if UnitLevel("player") ~= MAX_PLAYER_LEVEL then
		local reportList = {
			{text = "發送經驗信息至:",
				isTitle = true, notCheckable = true, notClickable = true,
				func = function()  end},
			{text = "小隊",
				func = function() 
					if GetNumPartyMembers() > 0 then
						sendReport("PARTY")
					else
						print("[stExp] 你必須在一個隊伍中")
					end
				end},
			{text = "工會",
				func = function()
					if IsInGuild() then
						sendReport("GUILD")
					else
						print("[stExp] 你必須在一個公會中")
					end
				end},
			{text = "團隊",
				func = function() 
					if GetNumRaidMembers() > 0 then
						sendReport("RAID")
					elseif GetNumPartyMembers() > 0 then
						sendReport("PARTY")
					else
						print("[stExp] 你必須在一個團隊中")
					end
				end},
			{text = "目標",
				func = function()
					if UnitName("target") then 
						local XP, maxXP = UnitXP("player"), UnitXPMax("player")
						SendChatMessage("我目前的經驗值： "..st.CommaValue(XP).."/"..st.CommaValue(maxXP).." ("..floor((XP/maxXP)*100).."%) ","WHISPER",nil,UnitName("target"))
					end
				end},
			{text = "發送聲望信息至:",
				isTitle = true, notCheckable = true, notClickable = true,
				func = function()  end},
			{text = "小隊",
				func = function() 
					if GetNumPartyMembers() > 0 then
						sendReport("PARTY", true)
					else
						print("[stExp] 你必須在一個隊伍中")
					end
				end},
			{text = "工會",
				func = function()
					if IsInGuild() then
						sendReport("GUILD", true)
					else
						print("[stExp] 你必須在一個公會中")
					end
				end},
			{text = "團隊",
				func = function() 
					if GetNumRaidMembers() > 0 then
						sendReport("RAID", true)
					elseif GetNumPartyMembers() > 0 then
						sendReport("PARTY", true)
					else
						print("[stExp] 你必須在一個團隊中")
					end
				end},
			{text = "目標",
				func = function() 
					if UnitName("target") then 
						local name, rank, min, max, value = GetWatchedFactionInfo()
						SendChatMessage("我在 "..name.." 的聲望為 "..st.FactionInfo[rank][2].." "..(value-min).."/"..(max-min).." ("..floor((((value-min)/(max-min))*100)).."%).","WHISPER",nil,UnitName("target"))
					end
				end},
			}
			mouseFrame:SetScript("OnMouseUp", function(self, btn)
			if btn == "RightButton" then
				EasyMenu(reportList, reportFrame, self, 0, 0, "menu", 2)
			end
		end)
	else
		local reportList = {
			{text = "發送聲望信息至:",
				isTitle = true, notCheckable = true, notClickable = true,
				func = function()  end},
			{text = "小隊",
				func = function() 
					if GetNumPartyMembers() > 0 then
						sendReport("PARTY", true)
					else
						print("[stExp] 你必須在一個隊伍中")
					end
				end},
			{text = "工會",
				func = function()
					if IsInGuild() then
						sendReport("GUILD", true)
					else
						print("[stExp] 你必須在一個公會中")
					end
				end},
			{text = "團隊",
				func = function() 
					if GetNumRaidMembers() > 0 then
						sendReport("RAID", true)
					elseif GetNumPartyMembers() > 0 then
						sendReport("PARTY", true)
					else
						print("[stExp] 你必須在一個團隊中")
					end
				end},
			{text = "目標",
				func = function() 
					if UnitName("target") then 
						local name, rank, min, max, value = GetWatchedFactionInfo()
						SendChatMessage("我在 "..name.." 的聲望為 "..st.FactionInfo[rank][2].." "..(value-min).."/"..(max-min).." ("..floor((((value-min)/(max-min))*100)).."%).","WHISPER",nil,UnitName("target"))
					end
				end},
			}
			mouseFrame:SetScript("OnMouseUp", function(self, btn)
			if btn == "RightButton" then
				EasyMenu(reportList, reportFrame, self, 0, 0, "menu", 2)
			end
		end)
	end--]]
end



-- Event Stuff -----------
--------------------------
local frame = CreateFrame("Frame",nil,UIParent)
--Event handling
frame:RegisterEvent("PLAYER_LEVEL_UP")
frame:RegisterEvent("PLAYER_XP_UPDATE")
frame:RegisterEvent("UPDATE_EXHAUSTION")
frame:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE")
frame:RegisterEvent("UPDATE_FACTION")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", updateStatus)