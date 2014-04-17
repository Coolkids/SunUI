local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local MT = S:GetModule("MiniTools")

local imsg

function MT:UpdateCombatSet()
	if self.db.combat then
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		self:RegisterEvent("PLAYER_REGEN_DISABLED")
	else
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
		self:UnregisterEvent("PLAYER_REGEN_DISABLED")
	end
end

function MT:initCombatDate()
	imsg = CreateFrame("Frame", nil, UIParent)
	imsg:SetSize(418, 72)
	imsg:SetPoint("TOP", 0, -190)
	imsg:Hide()
	imsg.bg = imsg:CreateTexture(nil, 'BACKGROUND')
	imsg.bg:SetTexture([[Interface\LevelUp\LevelUpTex]])
	imsg.bg:SetPoint('BOTTOM')
	imsg.bg:SetSize(326, 103)
	imsg.bg:SetTexCoord(0.00195313, 0.63867188, 0.03710938, 0.23828125)
	imsg.bg:SetVertexColor(1, 1, 1, 0.6)

	imsg.lineTop = imsg:CreateTexture(nil, 'BACKGROUND')
	imsg.lineTop:SetDrawLayer('BACKGROUND', 2)
	imsg.lineTop:SetTexture([[Interface\LevelUp\LevelUpTex]])
	imsg.lineTop:SetPoint("TOP")
	imsg.lineTop:SetSize(418, 7)
	imsg.lineTop:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)

	imsg.lineBottom = imsg:CreateTexture(nil, 'BACKGROUND')
	imsg.lineBottom:SetDrawLayer('BACKGROUND', 2)
	imsg.lineBottom:SetTexture([[Interface\LevelUp\LevelUpTex]])
	imsg.lineBottom:SetPoint("BOTTOM")
	imsg.lineBottom:SetSize(418, 7)
	imsg.lineBottom:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)

	imsg.text = imsg:CreateFontString(nil, 'ARTWORK', 'GameFont_Gigantic')
	imsg.text:SetPoint("BOTTOM", 0, 16)
	imsg.text:SetTextColor(1, 0.82, 0)
	imsg.text:SetJustifyH("CENTER")
	
	local timer = 0

	imsg:SetScript("OnShow", function(self)
		timer = 0
		self:SetScript("OnUpdate", function(self, elasped)
			timer = timer + elasped
			if (timer<0.5) then self:SetAlpha(timer*2) end
			if (timer>1.5 and timer<2) then self:SetAlpha((2-timer)*2) end
			if (timer>=2 ) then self:Hide() end
		end)
	end)
	
	self:UpdateCombatSet()
end

function MT:PLAYER_REGEN_DISABLED()
	imsg.text:SetTextColor(1, 0, 0)
	imsg.text:SetText(ENTERING_COMBAT)
	imsg:Show()
end
function MT:PLAYER_REGEN_ENABLED()
	imsg.text:SetTextColor(1, 0.82, 0)
	imsg.text:SetText(LEAVING_COMBAT)
	imsg:Show()
end	


