-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Core = LibStub("AceAddon-3.0"):GetAddon("Core")
local Module = Core:NewModule("Congig", "AceConsole-3.0")
local Version = 1204
if DB.Nuke == true then return end
function Module:SetDefault()
	SlashCmdList.AutoSet()
	CoreVersion = Version
	-- 聊天频道职业染色
	ToggleChatColorNamesByClassGroup(true, "SAY")
	ToggleChatColorNamesByClassGroup(true, "EMOTE")
	ToggleChatColorNamesByClassGroup(true, "YELL")
	ToggleChatColorNamesByClassGroup(true, "GUILD")
	ToggleChatColorNamesByClassGroup(true, "GUILD_OFFICER")
	ToggleChatColorNamesByClassGroup(true, "OFFICER")
	ToggleChatColorNamesByClassGroup(true, "GUILD_ACHIEVEMENT")
	ToggleChatColorNamesByClassGroup(true, "ACHIEVEMENT")
	ToggleChatColorNamesByClassGroup(true, "WHISPER")
	ToggleChatColorNamesByClassGroup(true, "PARTY")
	ToggleChatColorNamesByClassGroup(true, "PARTY_LEADER")
	ToggleChatColorNamesByClassGroup(true, "RAID")
	ToggleChatColorNamesByClassGroup(true, "RAID_LEADER")
	ToggleChatColorNamesByClassGroup(true, "RAID_WARNING")
	ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND")
	ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND_LEADER")   
	ToggleChatColorNamesByClassGroup(true, "CHANNEL1")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL2")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL3")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL4")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL5")
end

MoveHandle = {}
DB["Modules"] = {}
DB["Config"] = {
	ResetToDefault = {
		type = "execute",
		name = L["恢复默认设置"],
		order = 1,
		func = function()
			StaticPopupDialogs["sure"] = {
			text = L["恢复默认标语"],
				button1 = OKAY,
				button2 = CANCEL,
			OnAccept = function()
				for _, value in pairs(DB["Modules"]) do value.ResetToDefault() end
				Module:SetDefault()
				ReloadUI()
				end,
			OnCancel = function()
				end,
			timeout = 0,
			hideOnEscape = 0,
			}
			StaticPopup_Show("sure")
	end
	},
	UnLock = {
		type = "execute",
		name = L["解锁框体"],
		order = 2,
		func = function()
			if not UnitAffectingCombat("player") then
				SlashCmdList.rabs("unlock")
				SlashCmdList.OUF_MOVABLEFRAMES()
				for _, value in pairs(MoveHandle) do value:Show() end
			end		
		end,
	},
	Lock = {
		type = "execute",
		name = L["锁定框体"],
		order = 3,
		func = function()
			if not UnitAffectingCombat("player") then
				SlashCmdList.rabs("lock")
				SlashCmdList.OUF_MOVABLEFRAMES()
				for _, value in pairs(MoveHandle) do value:Hide() end
			end
		end,
	},
	Reload = {
		type = "execute",
		name = L["应用(重载界面)"],
		order = 4,
		func = function() ReloadUI() end
	},
}

function Module:ShowConfig()
	LibStub("AceConfigDialog-3.0"):SetDefaultSize("SunUI Config", 850, 600)
	LibStub("AceConfigDialog-3.0"):Open("SunUI Config")
end

function Module:BuildGameMenuButton()
	local Button = CreateFrame("Button", "SunUIGameMenuButton", GameMenuFrame, "GameMenuButtonTemplate")
	S.Reskin(Button)
	Button:SetSize(GameMenuButtonHelp:GetWidth(), GameMenuButtonHelp:GetHeight())
	Button:SetText("|cffDDA0DDSun|r|cff44CCFFUI|r")
	Button:SetPoint(GameMenuButtonHelp:GetPoint())
	Button:SetScript("OnClick", function()
		HideUIPanel(GameMenuFrame)
		Module:ShowConfig()
	end)
	GameMenuButtonHelp:SetPoint("TOP", Button, "BOTTOM", 0, -1)
	GameMenuFrame:SetHeight(GameMenuFrame:GetHeight()+Button:GetHeight())	
end

function Module:OnInitialize()
	for _, value in pairs(DB["Modules"]) do
		value.LoadSettings()
		value.BuildGUI()
	end
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("SunUI Config", {
		type = "group",
		name = "|cffDDA0DDSun|r|cff44CCFFUI|r",
		args = DB["Config"],
	})
	Module:RegisterChatCommand("SunUI", "ShowConfig")
end

function Module:OnEnable()
	Module:BuildGameMenuButton()
	if not CoreVersion or (CoreVersion < Version) then
		StaticPopupDialogs["SunUI"] = {
			text = L["欢迎标语"],
			button1 = OKAY,
			OnAccept = function()
				Module:SetDefault()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = 1,
			hideOnEscape = 0,
		}
		StaticPopup_Show("SunUI")
	end
end

