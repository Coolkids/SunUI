-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Core = LibStub("AceAddon-3.0"):GetAddon("Core")

-- Init
DB["Modules"]["UnitFrame"] = {}
local Module = DB["Modules"]["UnitFrame"]

-- LoadSettings
function Module.LoadSettings()
	local Default = {
		["FontSize"] = 10,
--size		
		["Width"] = 240,
		["Height"] = 25,
		["Scale"] = 1,
		["PetWidth"] = 123,
		["PetHeight"] = 15,
		["PetScale"] = 0.9,
		["BossWidth"] = 196,
		["BossHeight"] = 22,	
		["BossScale"] = 1,		
		["Alpha3D"] = 0,
-- true or false		
		["ReverseHPbars"] = false,	 --fill health bars from right to left instead of standard left -> right direction
		["showtot"] = true,				-- Target of Target
		["showpet"] = true,				-- Player's pet
		["showfocus"] = true,				-- Focus target + target of focus target
		["showparty"] = false,				-- Party frames
		["showboss"] = true,				-- Boss frames
		["showarena"] = true,			-- Arena frames
		["EnableSwingTimer"] = false,
		["EnableBarFader"] = false,
		["ClassColor"] = false,
--castbar
		["playerCBuserplaced"] = false,	-- false to lock player cast bar to the player frame
		["PlayerCastBarHeight"] = 20,
		["PlayerCastBarWidth"] = 460,
		["targetCBuserplaced"] = false,	-- false to lock target cast bar to the target frame
		["TargetCastBarHeight"] = 20,
		["TargetCastBarWidth"] = 240,
		["focusCBuserplaced"] = true,		-- false to lock focus cast bar to the focus frame
		["FocusCastBarHeight"] = 20,
		["FocusCastBarWidth"] = 200,
	}
	if not UnitFrameDB then UnitFrameDB = {} end
	for key, value in pairs(Default) do
		if UnitFrameDB[key] == nil then UnitFrameDB[key] = value end
	end
	wipe(Default)
end

-- ResetToDefault
function Module.ResetToDefault()
	wipe(UnitFrameDB)
end

-- BuildGUI
function Module.BuildGUI()
	if DB["Config"] then
		DB["Config"]["UnitFrame"] =  {
			type = "group", order = 9,
			name = L["头像框体"],
			args = {
				group1 = {
					type = "group", order = 1,
					name = "大小",guiInline = true,
					args = {
						FontSize = {
							type = "range", order = 1,
							name = L["头像字体大小"],
							min = 2, max = 28, step = 1,
							get = function() return UnitFrameDB.FontSize end,
							set = function(_, value) UnitFrameDB.FontSize = value end,
						},
						Width = {
							type = "input",
							name = L["玩家与目标框体宽度"],
							desc = L["玩家与目标框体宽度"],
							order = 2,
							get = function() return tostring(UnitFrameDB.Width) end,
							set = function(_, value) UnitFrameDB.Width = tonumber(value) end,
						},
						Height = {
							type = "input",
							name = L["玩家与目标框体高度"],
							desc = L["玩家与目标框体高度"],
							order = 3,
							get = function() return tostring(UnitFrameDB.Height) end,
							set = function(_, value) UnitFrameDB.Height = tonumber(value) end,
						},
						Scale = {
							type = "range", order = 4,
							name = L["头像缩放大小"], desc = L["头像缩放大小"],
							min = 0.2, max = 2, step = 0.1,
							get = function() return UnitFrameDB.Scale end,
							set = function(_, value) UnitFrameDB.Scale = value end,
						},
						PetWidth = {
							type = "input",
							name = L["宠物ToT焦点框体宽度"],
							order = 5,
							get = function() return tostring(UnitFrameDB.PetWidth) end,
							set = function(_, value) UnitFrameDB.PetWidth = tonumber(value) end,
						},
						PetHeight = {
							type = "input",
							name = L["宠物ToT焦点框体高度"],
							order = 6,
							get = function() return tostring(UnitFrameDB.PetHeight) end,
							set = function(_, value) UnitFrameDB.PetHeight = tonumber(value) end,
						},
						PetScale = {
							type = "range", order = 7,
							name = L["宠物ToT焦点缩放大小"],
							min = 0.2, max = 2, step = 0.1,
							get = function() return UnitFrameDB.PetScale end,
							set = function(_, value) UnitFrameDB.PetScale = value end,
						},
						BossWidth = {
							type = "input",
							name = L["Boss小队竞技场框体宽度"],
							desc = L["Boss小队竞技场框体宽度"],
							order = 8,
							get = function() return tostring(UnitFrameDB.BossWidth) end,
							set = function(_, value) UnitFrameDB.BossWidth = tonumber(value) end,
						},
						BossHeight = {
							type = "input",
							name = L["Boss小队竞技场框体高度"],
							desc = L["Boss小队竞技场框体高度"],
							order = 9,
							get = function() return tostring(UnitFrameDB.BossHeight) end,
							set = function(_, value) UnitFrameDB.BossHeight = tonumber(value) end,
						},
						BossScale = {
							type = "range", order = 10,
							name = L["Boss小队竞技场缩放大小"],
							min = 0.2, max = 2, step = 0.1,
							get = function() return UnitFrameDB.BossScale end,
							set = function(_, value) UnitFrameDB.BossScale = value end,
						},
						Alpha3D = {
							type = "range", order = 11,
							name = L["头像透明度"],
							min = 0, max = 1, step = 0.1,
							get = function() return UnitFrameDB.Alpha3D end,
							set = function(_, value) UnitFrameDB.Alpha3D = value end,
						},
					}
				},
				group2 = {
					type = "group", order = 2,
					name = " ",guiInline = true,
					args = {
						ReverseHPbars = {
							type = "toggle", order = 1,
							name = L["反转血条"],			
							get = function() return UnitFrameDB.ReverseHPbars end,
							set = function(_, value) UnitFrameDB.ReverseHPbars = value end,
						},
						showtot = {
							type = "toggle", order = 2,
							name = L["开启目标的目标"],			
							get = function() return UnitFrameDB.showtot end,
							set = function(_, value) UnitFrameDB.showtot = value end,
						},
						showpet = {
							type = "toggle", order = 3,
							name = L["开启宠物框体"],			
							get = function() return UnitFrameDB.showpet end,
							set = function(_, value) UnitFrameDB.showpet = value end,
						},
						showfocus = {
							type = "toggle", order = 4,
							name = L["开启焦点框体"],			
							get = function() return UnitFrameDB.showfocus end,
							set = function(_, value) UnitFrameDB.showfocus = value end,
						},
						showparty = {
							type = "toggle", order = 5,
							name = L["开启小队框体"],			
							get = function() return UnitFrameDB.showparty end,
							set = function(_, value) UnitFrameDB.showparty = value end,
						},
						showboss = {
							type = "toggle", order = 6,
							name = L["开启boss框体"],			
							get = function() return UnitFrameDB.showboss end,
							set = function(_, value) UnitFrameDB.showboss = value end,
						},
						showarena = {
							type = "toggle", order = 7,
							name = L["开启竞技场框体"],			
							get = function() return UnitFrameDB.showarena end,
							set = function(_, value) UnitFrameDB.showarena = value end,
						},
						EnableSwingTimer = {
							type = "toggle", order = 8,
							name = L["开启物理攻击计时条"],			
							get = function() return UnitFrameDB.EnableSwingTimer end,
							set = function(_, value) UnitFrameDB.EnableSwingTimer = value end,
						},
						EnableBarFader = {
							type = "toggle", order = 9,
							name = L["开启头像渐隐"],			
							get = function() return UnitFrameDB.EnableBarFader end,
							set = function(_, value) UnitFrameDB.EnableBarFader = value end,
						},
						ClassColor = {
							type = "toggle", order = 10,
							name = L["开启头像职业血条颜色"],			
							get = function() return UnitFrameDB.ClassColor end,
							set = function(_, value) UnitFrameDB.ClassColor = value end,
						},
					}
				},
				group3 = {
					type = "group", order = 3,
					name = " ",guiInline = true,
					args = {
						playerCBuserplaced = {
							type = "toggle", order = 1,
							name = L["锁定玩家施法条到玩家头像"],			
							get = function() return UnitFrameDB.playerCBuserplaced end,
							set = function(_, value) UnitFrameDB.playerCBuserplaced = value end,
						},
						PlayerCastBarWidth = {
							type = "input",
							name = L["玩家施法条宽度"],
							desc = L["玩家施法条宽度"],
							order = 2,
							get = function() return tostring(UnitFrameDB.PlayerCastBarWidth) end,
							set = function(_, value) UnitFrameDB.PlayerCastBarWidth = tonumber(value) end,
						},
						PlayerCastBarHeight = {
							type = "input",
							name = L["玩家施法条高度"],
							desc = L["玩家施法条高度"],
							order = 3,
							get = function() return tostring(UnitFrameDB.PlayerCastBarHeight) end,
							set = function(_, value) UnitFrameDB.PlayerCastBarHeight = tonumber(value) end,
						},
						NewLine = {
							type = "description", order = 4,
							name = "\n",					
						},
						targetCBuserplaced = {
							type = "toggle", order = 5,
							name = L["锁定目标施法条到目标框体"],			
							get = function() return UnitFrameDB.targetCBuserplaced end,
							set = function(_, value) UnitFrameDB.targetCBuserplaced = value end,
						},
						TargetCastBarWidth = {
							type = "input",
							name = L["目标施法条宽度"],
							desc = L["目标施法条宽度"],
							order = 6,
							get = function() return tostring(UnitFrameDB.TargetCastBarWidth) end,
							set = function(_, value) UnitFrameDB.TargetCastBarWidth = tonumber(value) end,
						},
						TargetCastBarHeight = {
							type = "input",
							name = L["目标施法条高度"],
							desc = L["目标施法条高度"],
							order = 7,
							get = function() return tostring(UnitFrameDB.TargetCastBarHeight) end,
							set = function(_, value) UnitFrameDB.TargetCastBarHeight = tonumber(value) end,
						},
						NewLine = {
							type = "description", order = 8,
							name = "\n",					
						},
						focusCBuserplaced = {
							type = "toggle", order = 9,
							name = L["锁定焦点施法条到焦点框体"],			
							get = function() return UnitFrameDB.focusCBuserplaced end,
							set = function(_, value) UnitFrameDB.focusCBuserplaced = value end,
						},
						FocusCastBarWidth = {
							type = "input",
							name = L["焦点施法条宽度"],
							desc = L["焦点施法条宽度"],
							order = 10,
							get = function() return tostring(UnitFrameDB.FocusCastBarWidth) end,
							set = function(_, value) UnitFrameDB.FocusCastBarWidth = tonumber(value) end,
						},
						FocusCastBarHeight = {
							type = "input",
							name = L["焦点施法条高度"],
							desc = L["焦点施法条高度"],
							order = 11,
							get = function() return tostring(UnitFrameDB.FocusCastBarHeight) end,
							set = function(_, value) UnitFrameDB.FocusCastBarHeight = tonumber(value) end,
						},
					}
				},
			}
		}
	end
end