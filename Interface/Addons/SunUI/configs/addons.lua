local S, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB

local AddOn_Init = {}
local AddOn_Enable = {}
--[[
function AddOn.插件名字()

end
--]]
AddOn_Enable["DBM-Core"] = function()
	if S.db.IsSetDBM then return end
	DBM_AllSavedOptions["Default"].WarningFont = S["media"].font
	DBM_AllSavedOptions["Default"].WarningFontStyle = S["media"].fontflag
	DBM_AllSavedOptions["Default"].WarningIconRight = false
	DBM_AllSavedOptions["Default"].WarningIconLeft = false
	
	DBM_AllSavedOptions["Default"].SpecialWarningFontColor = {
		0.40,
		0.78,
		1,
	}
	DBM_AllSavedOptions["Default"].ShowWarningsInChat = false
	DBM_AllSavedOptions["Default"].HideBossEmoteFrame = true
	DBM_AllSavedOptions["Default"].DisableCinematics = true
	
	DBT_AllPersistentOptions["Default"]["DBM"].Scale = 1
	DBT_AllPersistentOptions["Default"]["DBM"].HugeScale = 1
	DBT_AllPersistentOptions["Default"]["DBM"].ExpandUpwards = false
	DBT_AllPersistentOptions["Default"]["DBM"].BarXOffset = 0
	DBT_AllPersistentOptions["Default"]["DBM"].BarYOffset = 18
	DBT_AllPersistentOptions["Default"]["DBM"].HugeBarXOffset = 0
	DBT_AllPersistentOptions["Default"]["DBM"].HugeBarYOffset = 18
	DBT_AllPersistentOptions["Default"]["DBM"].IconLeft = true
	DBT_AllPersistentOptions["Default"]["DBM"].IconRight = false	
	DBT_AllPersistentOptions["Default"]["DBM"].Flash = false
	DBT_AllPersistentOptions["Default"]["DBM"].FadeIn = true
	DBT_AllPersistentOptions["Default"]["DBM"].TimerX = 420
	DBT_AllPersistentOptions["Default"]["DBM"].TimerY = -29
	DBT_AllPersistentOptions["Default"]["DBM"].TimerPoint = "TOPLEFT"
	DBT_AllPersistentOptions["Default"]["DBM"].StartColorR = S.myclasscolor.r
	DBT_AllPersistentOptions["Default"]["DBM"].StartColorG = S.myclasscolor.g
	DBT_AllPersistentOptions["Default"]["DBM"].StartColorB = S.myclasscolor.b
	DBT_AllPersistentOptions["Default"]["DBM"].EndColorR = S.myclasscolor.r
	DBT_AllPersistentOptions["Default"]["DBM"].EndColorG = S.myclasscolor.g
	DBT_AllPersistentOptions["Default"]["DBM"].EndColorB = S.myclasscolor.b
	DBT_AllPersistentOptions["Default"]["DBM"].Width = 130
	DBT_AllPersistentOptions["Default"]["DBM"].Height = 20
	DBT_AllPersistentOptions["Default"]["DBM"].HugeWidth = 155
	DBT_AllPersistentOptions["Default"]["DBM"].HugeTimerPoint = "TOP"
	DBT_AllPersistentOptions["Default"]["DBM"].HugeTimerX = -150
	DBT_AllPersistentOptions["Default"]["DBM"].HugeTimerY = -207
	DBT_AllPersistentOptions["Default"]["DBM"].Texture = S["media"].normal
	S.db.IsSetDBM = true
end

AddOn_Enable["BigWigs"] = function()
	LoadAddOn("BigWigs_Core")
	LoadAddOn("BigWigs_Plugins")
	LoadAddOn("BigWigs_Options")
end
AddOn_Init["BigWigs_Plugins"] = function()
	if S.db.IsSetBW then return end
	local bars = BigWigs and BigWigs:GetPlugin("Bars")
	if bars then
		bars.db.profile.barStyle = "SunUI"
		bars.db.profile.font = "SunUI Font"
		bars.db.profile.BigWigsAnchor_width = 130
		bars.db.profile.BigWigsAnchor_x = 170
		bars.db.profile.BigWigsAnchor_y = 740
		bars.db.profile.BigWigsEmphasizeAnchor_width = 130
		bars.db.profile.BigWigsEmphasizeAnchor_x = 340
		bars.db.profile.BigWigsEmphasizeAnchor_y = 595
		bars.db.profile.emphasizeGrowup = true
	end
	local mess = BigWigs and BigWigs:GetPlugin("Messages")
	if mess then
		mess.db.profile.font = "SunUI Font"
		mess.db.profile.fontSize = 20
		mess.db.profile.BWMessageAnchor_x = 595
		mess.db.profile.BWMessageAnchor_y = 405
		mess.db.profile.BWEmphasizeMessageAnchor_x = 595
		mess.db.profile.BWEmphasizeMessageAnchor_y = 595
		mess.db.profile.BWEmphasizeCountdownMessageAnchor_x = 520
		mess.db.profile.BWEmphasizeCountdownMessageAnchor_y = 610
	end
	local prox = BigWigs and BigWigs:GetPlugin("Proximity")
	if prox then
		prox.db.profile.font = "SunUI Font"
		prox.db.profile.objects.ability = false
	end
	BigWigs3IconDB.hide = true
	BigWigs:GetPlugin("Super Emphasize").db.profile.font = "SunUI Font"
	BigWigs:GetPlugin("Alt Power").db.profile.font = "SunUI Font"
	S.db.IsSetBW = true
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event, addon)
	if event == "PLAYER_ENTERING_WORLD" then
		for addon in pairs(AddOn_Enable) do
			if IsAddOnLoaded(addon) then
				AddOn_Enable[addon]()
				AddOn_Enable[addon] = nil
			end
		end
	elseif event == "ADDON_LOADED" then
		if AddOn_Init[addon] then
			AddOn_Init[addon]()
			AddOn_Init[addon] = nil
		end
	end
end)