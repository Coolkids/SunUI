local S, L, DB, _, C = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("oces", "AceEvent-3.0")
local TEXT = "Scroll" --button text
local VZ = GetSpellInfo(7411)
local loc = GetLocale()
if loc == "deDE" then
	TEXT = "Rolle"
elseif loc == "frFR" then
	TEXT = "Parchemin"
elseif (loc == "esES") or (loc == "esMX") then
	TEXT = "Pergamino"
elseif loc == "ruRU" then
	TEXT = "Свиток"
elseif loc == "koKR" then
elseif loc == "zhCN" then
	TEXT = "附魔羊皮纸"
elseif loc == "zhTW" then
	TEXT = "附魔皮紙"
end

function Module:ADDON_LOADED(event, addon)
	if addon == "Blizzard_TradeSkillUI" then
		local oldfunc = TradeSkillFrame_SetSelection
		local f=CreateFrame("Button","TradeSkillCreateScrollButton",TradeSkillFrame,"UIPanelButtonTemplate")
		f:SetPoint("TOPRIGHT",TradeSkillCreateButton,"TOPLEFT", -5, 0)
		f:SetSize(130,TradeSkillCreateButton:GetHeight())
		f:SetScript("OnClick",function()
			DoTradeSkill(TradeSkillFrame.selectedSkill)
			UseItemByName(38682)
		end)
		S.Reskin(f)
		
		function TradeSkillFrame_SetSelection(id)
			oldfunc(id)
			local skillName,_,_,_,altVerb = GetTradeSkillInfo(id)
			if IsTradeSkillGuild() or IsTradeSkillLinked() then
				f:Hide()
			elseif (altVerb and CURRENT_TRADESKILL==VZ) or (altVerb and loc:find("zh")) then
				f:Show()
				local creatable = 1
				if not skillName then
					creatable = nil
				end
				local scrollnum = GetItemCount(38682)
				TradeSkillCreateScrollButton:SetText(TEXT.." ("..scrollnum..")")
				if scrollnum == 0 then
					creatable = nil
				end
				for i=1,GetTradeSkillNumReagents(id) do
					local _,_,reagentCount,playerReagentCount = GetTradeSkillReagentInfo(id,i)
					if playerReagentCount < reagentCount then
						creatable = nil
					end
				end
				if creatable then
					TradeSkillCreateScrollButton:Enable()
				else
					TradeSkillCreateScrollButton:Disable()
				end
			else
				f:Hide()
			end
		end
	end
end
function Module:OnInitialize()
	Module:RegisterEvent("ADDON_LOADED")
end