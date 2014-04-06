local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local FE = S:GetModule("MiniTools")

---- SETTING HERE ---- ---- ---- ---- ----
local nfontsize = 17 -- This is Font Size
local nfontcolor = {1,0,0} -- This is Font color ({RED,GREEN,BLUE,ALPHA}, only values from 0 to 1), 1 is deff
local Yoffset = -100 -- "y" layout coordinate ("VERTICAL") - Zero starts from TOP-CENTER of ur monitor
local Xoffset = 0 -- "x" layout coordinate ("HORIZONTAL") - Zero starts from TOP-CENTER of ur monitor
local framestrata = "TOOLTIP" -- frame strata ("BACKGROUND", "LOW", "MEDIUM", "HIGH", "TOOLTIP")
local framelevel = 30 -- frame level
local holdtime = 0.1 -- hold time (seconds)
local fadeintime = 0.08 -- fadein time (seconds)
local fadeouttime = 0.16 -- fade out time (seconds)
-------------------------------------------
local FirstErrorFrame = CreateFrame ("Frame",nil,UIParent)
local SecondErrorFrame = CreateFrame ("Frame",nil,UIParent)
local TextOne = FirstErrorFrame:CreateFontString(nil, "OVERLAY")
local TextTwo = SecondErrorFrame:CreateFontString(nil, "OVERLAY")

--/Alert Switch
local state = 0
FirstErrorFrame:SetScript("OnHide",function() state = 0 end)

function FE:initDate()
	FirstErrorFrame:SetScript("OnUpdate", FadingFrame_OnUpdate)
	FirstErrorFrame.fadeInTime = fadeintime
	FirstErrorFrame.fadeOutTime = fadeouttime
	FirstErrorFrame.holdTime = holdtime
	FirstErrorFrame:Hide()
	FirstErrorFrame:SetFrameStrata(framestrata)
	FirstErrorFrame:SetFrameLevel(framelevel)

	SecondErrorFrame:SetScript("OnUpdate", FadingFrame_OnUpdate)
	SecondErrorFrame.fadeInTime = fadeintime
	SecondErrorFrame.fadeOutTime = fadeouttime
	SecondErrorFrame.holdTime = holdtime
	SecondErrorFrame:Hide()
	SecondErrorFrame:SetFrameStrata(framestrata)
	SecondErrorFrame:SetFrameLevel(framelevel)
	
	TextOne:SetShadowOffset(1,-1)
	TextOne:SetPoint("TOP", UIParent, Xoffset, Yoffset)
	TextOne:SetFont(S["media"].font,nfontsize,"LINE")
	TextOne:SetTextColor(unpack(nfontcolor))

	TextTwo:SetShadowOffset(1,-1)
	TextTwo:SetPoint("TOP", UIParent, Xoffset, Yoffset - nfontsize - 1)
	TextTwo:SetFont(S["media"].font,nfontsize,"LINE")
	TextTwo:SetTextColor(unpack(nfontcolor))
end	

function FE:UI_ERROR_MESSAGE(_, error)
	if state == 0 then 
		TextOne:SetText(error)
		FadingFrame_Show(FirstErrorFrame)
		state = 1
	 else 
		TextTwo:SetText(error)
		FadingFrame_Show(SecondErrorFrame)
		state = 0
	 end
end
local init = true
function FE:UpdateFastErrorSet()
	if init then
		self:initDate()
		init = false
	end
	if self.db.FastError then
		UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")
		self:RegisterEvent("UI_ERROR_MESSAGE")
	else
		UIErrorsFrame:RegisterEvent("UI_ERROR_MESSAGE")
		self:UnregisterEvent("UI_ERROR_MESSAGE")
	end
end