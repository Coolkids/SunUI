local S, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB

local AddOn = {}
--[[
function AddOn.插件名字()

end
--]]
AddOn["DBM-Core"] = function()
	if not IsAddOnLoaded("DBM-Core") then return end
	if S.db.IsSetDBM then return end
	DBM_SavedOptions.Enabled = true
	DBM_SavedOptions["SpecialWarningFontColor"] = {
		0.40,
		0.78,
		1,
	}
	DBM_SavedOptions["ShowWarningsInChat"] = false
	DBM_SavedOptions["HideBossEmoteFrame"] = true
	DBM_SavedOptions["DisableCinematics"] = true
	DBT_PersistentOptions["DBM"].Scale = 1
	DBT_PersistentOptions["DBM"].HugeScale = 1
	DBT_PersistentOptions["DBM"].ExpandUpwards = false
	DBT_PersistentOptions["DBM"].BarXOffset = 0
	DBT_PersistentOptions["DBM"].BarYOffset = 18
	DBT_PersistentOptions["DBM"].HugeBarXOffset = 0
	DBT_PersistentOptions["DBM"].HugeBarYOffset = 18
	DBT_PersistentOptions["DBM"].IconLeft = true
	DBT_PersistentOptions["DBM"].IconRight = false	
	DBT_PersistentOptions["DBM"].Flash = false
	DBT_PersistentOptions["DBM"].FadeIn = true
	DBT_PersistentOptions["DBM"].TimerX = 420
	DBT_PersistentOptions["DBM"].TimerY = -29
	DBT_PersistentOptions["DBM"].TimerPoint = "TOPLEFT"
	DBT_PersistentOptions["DBM"].StartColorR = S.myclasscolor.r
	DBT_PersistentOptions["DBM"].StartColorG = S.myclasscolor.g
	DBT_PersistentOptions["DBM"].StartColorB = S.myclasscolor.b
	DBT_PersistentOptions["DBM"].EndColorR = S.myclasscolor.r
	DBT_PersistentOptions["DBM"].EndColorG = S.myclasscolor.g
	DBT_PersistentOptions["DBM"].EndColorB = S.myclasscolor.b
	DBT_PersistentOptions["DBM"].Width = 130
	DBT_PersistentOptions["DBM"].Height = 20
	DBT_PersistentOptions["DBM"].HugeWidth = 155
	DBT_PersistentOptions["DBM"].HugeTimerPoint = "TOP"
	DBT_PersistentOptions["DBM"].HugeTimerX = -150
	DBT_PersistentOptions["DBM"].HugeTimerY = -207
	DBT_PersistentOptions["DBM"].Texture = S["media"].normal
	S.db.IsSetDBM = true
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event, addon)
	if event == "PLAYER_ENTERING_WORLD" then
		for addon in pairs(AddOn) do
			if IsAddOnLoaded(addon) then
				AddOn[addon]()
				AddOn[addon] = nil
			end
		end
	elseif event == "ADDON_LOADED" then
		if AddOn[addon] then
			AddOn[addon]()
			AddOn[addon] = nil
		end
	end
end)