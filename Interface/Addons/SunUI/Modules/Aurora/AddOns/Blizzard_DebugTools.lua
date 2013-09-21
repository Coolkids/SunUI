local S, L, DB, _, C = unpack(select(2, ...))

local r, g, b = DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b
local AuroraConfig = DB.AuroraConfig
DB.AuroraModules["Blizzard_DebugTools"] = function()
		ScriptErrorsFrame:SetScale(UIParent:GetScale())
		ScriptErrorsFrame:SetSize(386, 274)
		ScriptErrorsFrame:DisableDrawLayer("OVERLAY")
		ScriptErrorsFrameTitleBG:Hide()
		ScriptErrorsFrameDialogBG:Hide()
		S.CreateBD(ScriptErrorsFrame)
		S.CreateSD(ScriptErrorsFrame)

		FrameStackTooltip:SetScale(UIParent:GetScale())
		FrameStackTooltip:SetBackdrop(nil)

		local bg = CreateFrame("Frame", nil, FrameStackTooltip)
		bg:SetPoint("TOPLEFT")
		bg:SetPoint("BOTTOMRIGHT")
		bg:SetFrameLevel(FrameStackTooltip:GetFrameLevel()-1)
		S.CreateBD(bg, .6)
	
		S.ReskinClose(ScriptErrorsFrameClose)
		S.ReskinScroll(ScriptErrorsFrameScrollFrameScrollBar)
		for i = 1, ScriptErrorsFrame:GetNumChildren() do
			local child = select(i, ScriptErrorsFrame:GetChildren())
			if child:GetObjectType() == "Button" and not child:GetName() then
				S.Reskin(child)
			end
		end
end