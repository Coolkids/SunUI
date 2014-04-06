local RayWatcherConfig = LibStub("AceAddon-3.0"):NewAddon("RayWatcherConfig", "AceConsole-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("RayWatcherConfig", false)
local db = {}
local groupname = {}
local defaults = {}
local testing = false
local DEFAULT_WIDTH = 800
local DEFAULT_HEIGHT = 500
local AC = LibStub("AceConfig-3.0")
local ACD = LibStub("AceConfigDialog-3.0")
local ACR = LibStub("AceConfigRegistry-3.0")
local _, ns = ...

function RayWatcherConfig:LoadDefaults()
	defaults.profile = {}
	defaults.profile.RayWatcher = {}
	for i,v in pairs(ns.modules) do
		groupname[i] = i
		defaults.profile[i] = defaults.profile[i] or {}
		for ii,vv in pairs(v) do
			if type(vv) ~= 'table' then
				defaults.profile[i][ii] = vv
			end
		end
	end
end	

function RayWatcherConfig:OnInitialize()	
	RayWatcherConfig:RegisterChatCommand("rw2", "ShowConfig")
	self.OnInitialize = nil
end

function RayWatcherConfig:ShowConfig() 
	ACD[ACD.OpenFrames.RayWatcherConfig and "Close" or "Open"](ACD,"RayWatcherConfig") 
end

function RayWatcherConfig:Load()
	self:LoadDefaults()
	-- Create savedvariables
	self.db = LibStub("AceDB-3.0"):New("RayWatcherDB", defaults)
	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")
	db = self.db.profile
	db.RayWatcher.idinput = nil
	db.RayWatcher.filterinput = nil
	db.RayWatcher.unitidinput = nil
	db.RayWatcher.casterinput = nil
	self:SetupOptions()
end

function RayWatcherConfig:OnProfileChanged(event, database, newProfileKey)
	SStaticPopup_Show("CFG_RELOAD")
end

function RayWatcherConfig:SetupOptions()
	AC:RegisterOptionsTable("RayWatcherConfig", self.GenerateOptions)
	ACD:SetDefaultSize("RayWatcherConfig", DEFAULT_WIDTH, DEFAULT_HEIGHT)

	--Create Profiles Table
	self.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db);
	AC:RegisterOptionsTable("RayWatcherProfiles", self.profile)
	self.profile.order = -10
	
	self.SetupOptions = nil
end

function RayWatcherConfig.GenerateOptions()
	if RayWatcherConfig.noconfig then assert(false, RayWatcherConfig.noconfig) end
	if not RayWatcherConfig.Options then
		RayWatcherConfig.GenerateOptionsInternal()
		RayWatcherConfig.GenerateOptionsInternal = nil
	end
	return RayWatcherConfig.Options
end

function RayWatcherConfig.GenerateOptionsInternal()
	local function UpdateGroup()
		local current = db.RayWatcher.GroupSelect or next(groupname)
		db.RayWatcher.GroupSelect = current
		local buffs = RayWatcherConfig.Options.args.RayWatcher.args.buffs.values
		local debuffs = RayWatcherConfig.Options.args.RayWatcher.args.debuffs.values
		local cooldowns = RayWatcherConfig.Options.args.RayWatcher.args.cooldowns.values
		local itemcooldowns = RayWatcherConfig.Options.args.RayWatcher.args.itemcooldowns.values
		wipe(buffs)
		wipe(debuffs)
		wipe(cooldowns)
		wipe(itemcooldowns)
		for i in pairs(ns.modules[current].BUFF or {}) do
			if i ~= "unitIDs" and ns.modules[current].BUFF[i] then
				local info = GetSpellInfo(i) or "无效ID"
				buffs[i] = info.."("..i..")"
			end
		end
		for i in pairs(ns.modules[current].DEBUFF or {}) do
			if i ~= "unitIDs" and ns.modules[current].DEBUFF[i] then
				local info = GetSpellInfo(i) or "无效ID"
				debuffs[i] = info.."("..i..")"
			end
		end
		for i in pairs(ns.modules[current].CD or {}) do
			if ns.modules[current].CD[i] then
				local info = GetSpellInfo(i) or "无效ID"
				cooldowns[i] = info.."("..i..")"
			end
		end
		for i in pairs(ns.modules[current].itemCD or {}) do
			if ns.modules[current].itemCD[i] then
				local info = GetItemInfo(i) or "无效物品"
				itemcooldowns[i] = info.."("..i..")"
			end
		end
		if next(buffs) == nil then
			RayWatcherConfig.Options.args.RayWatcher.args.buffs.hidden  = true
		else
			RayWatcherConfig.Options.args.RayWatcher.args.buffs.hidden  = false			
		end
		if next(debuffs) == nil then
			RayWatcherConfig.Options.args.RayWatcher.args.debuffs.hidden  = true
		else
			RayWatcherConfig.Options.args.RayWatcher.args.debuffs.hidden  = false			
		end
		if next(cooldowns) == nil then
			RayWatcherConfig.Options.args.RayWatcher.args.cooldowns.hidden  = true
		else
			RayWatcherConfig.Options.args.RayWatcher.args.cooldowns.hidden  = false			
		end
		if next(itemcooldowns) == nil then
			RayWatcherConfig.Options.args.RayWatcher.args.itemcooldowns.hidden  = true
		else
			RayWatcherConfig.Options.args.RayWatcher.args.itemcooldowns.hidden  = false			
		end
	end
	
	local function UpdateInput(id, filter)
		db.RayWatcher.idinput = tostring(id)
		db.RayWatcher.filterinput = filter
		local current = db.RayWatcher.GroupSelect
		db.RayWatcher.unitidinput = ns.modules[current][filter][id].unitID
		db.RayWatcher.casterinput = ns.modules[current][filter][id].caster
	end

	--[[ StaticPopupDialogs["CFG_RELOAD"] = {
		text = L["改变参数需重载应用设置"],
		button1 = ACCEPT,
		button2 = CANCEL,
		OnAccept = function() ReloadUI() end,
		timeout = 0,
		whileDead = 1,
	} ]]
	
	RayWatcherConfig.Options = {
		type = "group",
		name = "|cff7aa6d6Ray|r|cffff0000W|r|cff7aa6d6atcher|r",
		args = {
			RayWatcher_Header = {
				order = 1,
				type = "header",
				name = L["版本"].."2.0",--..GetAddOnMetadata("RayWatcher", "Version"),
				width = "full",		
			},
			ToggleAnchors = {
				order = 2,
				type = "execute",
				name = L["解锁锚点"],
				func = function()
					ns.TestMode()
					testing = not testing
				end,
			},
			RayWatcher = {
				order = 3,
				type = "group",
				name = L["选项"],
				get = function(info) UpdateGroup() return (db.RayWatcher[ info[#info] ] or next(groupname)) end,
				set = function(info, value) db.RayWatcher[ info[#info] ] = value; SStaticPopup_Show("CFG_RELOAD") end,
				args = {
					GroupSelect = {
						order = 1,
						type = "select",
						name = L["选择一个分组"],
						set = function(info, value)
							db.RayWatcher[ info[#info] ] = value
							UpdateGroup()
						end,
						values = groupname,						
					},
					disabled = {
						type = 'toggle',
						name = L["启用该组"],
						order = 2,
						set = function(info, value)
							db[db.RayWatcher.GroupSelect].disabled = not value
							if db[db.RayWatcher.GroupSelect].disabled then
								ns.modules[db.RayWatcher.GroupSelect]:Disable()
								print("|cff7aa6d6Ray|r|cffff0000W|r|cff7aa6d6atcher|r: "..db.RayWatcher.GroupSelect.."已禁用")
							else
								ns.modules[db.RayWatcher.GroupSelect]:Enable()
								print("|cff7aa6d6Ray|r|cffff0000W|r|cff7aa6d6atcher|r: "..db.RayWatcher.GroupSelect.."已启用")
							end
						end,
						get = function() return not db[db.RayWatcher.GroupSelect].disabled end,
						disabled = function(info) return not db.RayWatcher.GroupSelect end,
					},
					spacer = {
						type = 'description',
						name = '',
						desc = '',
						order = 3,
					},
					mode = {
						order = 4,
						name = L["模式"],
						set = function(info, value)
							db[db.RayWatcher.GroupSelect].mode = value
							ns.modules[db.RayWatcher.GroupSelect].mode = value
							ns.modules[db.RayWatcher.GroupSelect]:ApplyStyle()
							db[db.RayWatcher.GroupSelect].direction = ns.modules[db.RayWatcher.GroupSelect].direction
							db[db.RayWatcher.GroupSelect].barwidth = ns.modules[db.RayWatcher.GroupSelect].barwidth
						end,
						get = function() return (db[db.RayWatcher.GroupSelect].mode or "ICON") end,
						disabled = function(info) return not db.RayWatcher.GroupSelect or db[db.RayWatcher.GroupSelect].disabled end,
						type = "select",
						width = "half",
						values = {
							["ICON"] = L["图标"],
							["BAR"] = L["计时条"],
						},
					},	
					spacer2 = {
						type = 'description',
						name = '',
						desc = '',
						width = "half",
						order = 5,
					},
					direction = {
						order = 6,
						name = L["增长方向"],
						set = function(info, value)
							db[db.RayWatcher.GroupSelect].direction = value
							ns.modules[db.RayWatcher.GroupSelect].direction = value
							ns.modules[db.RayWatcher.GroupSelect]:ApplyStyle()
						end,
						get = function() return db[db.RayWatcher.GroupSelect].direction end,
						disabled = function(info) return not db.RayWatcher.GroupSelect or db[db.RayWatcher.GroupSelect].disabled end,
						width = "half",
						type = "select",
						values = function()
							if db[db.RayWatcher.GroupSelect].mode == "BAR" then
								return {
									["UP"] = L["上"],
									["DOWN"] = L["下"],
								}
							else
								return {
									["UP"] = L["上"],
									["DOWN"] = L["下"],
									["LEFT"] = L["左"],
									["RIGHT"] = L["右"],
								}
							end
						end,
					},	
					spacer3 = {
						type = 'description',
						name = '',
						desc = '',
						order = 7,
					},					
					size = {
						order = 8,
						name = L["图标大小"],
						set = function(info, value)
							db[db.RayWatcher.GroupSelect].size = value
							ns.modules[db.RayWatcher.GroupSelect].size = value
							ns.modules[db.RayWatcher.GroupSelect]:ApplyStyle()
						end,
						get = function() return db[db.RayWatcher.GroupSelect].size end,
						disabled = function(info) return not db.RayWatcher.GroupSelect or db[db.RayWatcher.GroupSelect].disabled end,
						type = "range",
						min = 20, max = 80, step = 1,
					},
					barWidth = {
						order = 9,
						name = L["计时条长度"],
						set = function(info, value)
							db[db.RayWatcher.GroupSelect].barwidth = value
							ns.modules[db.RayWatcher.GroupSelect].barwidth = value
							ns.modules[db.RayWatcher.GroupSelect]:ApplyStyle()
						end,
						get = function() return (db[db.RayWatcher.GroupSelect].barwidth or 150) end,
						hidden = function(info) return db[db.RayWatcher.GroupSelect].mode ~= "BAR" end,
						type = "range",
						min = 50, max = 300, step = 1,
					},
					iconSide = {
						order = 10,
						name = L["图标位置"],
						set = function(info, value)
							db[db.RayWatcher.GroupSelect].iconside = value
							ns.modules[db.RayWatcher.GroupSelect].iconside = value
							ns.modules[db.RayWatcher.GroupSelect]:ApplyStyle()
						end,
						get = function() return (db[db.RayWatcher.GroupSelect].iconside or "LEFT") end,
						hidden = function(info) return db[db.RayWatcher.GroupSelect].mode ~= "BAR" end,
						type = "select",
						width = "half",
						values = {
							["LEFT"] = L["左"],
							["RIGHT"] = L["右"],
						},
					},
					spacer4 = {
						type = 'description',
						name = '',
						desc = '',
						order = 11,
					},
					buffs = {
						order = 12,
						type = "select",
						name = L["已有增益监视"],
						set = function(info, value) UpdateInput(value, "BUFF") end,
						disabled = function(info) return not db.RayWatcher.GroupSelect or db[db.RayWatcher.GroupSelect].disabled end,
						values = {},
					},
					debuffs = {
						order = 13,
						type = "select",
						name = L["已有减益监视"],
						set = function(info, value) UpdateInput(value, "DEBUFF") end,
						disabled = function(info) return not db.RayWatcher.GroupSelect or db[db.RayWatcher.GroupSelect].disabled end,
						values = {},
					},
					cooldowns = {
						order = 14,
						type = "select",
						name = L["已有冷却监视"],
						set = function(info, value) UpdateInput(value, "CD") end,
						disabled = function(info) return not db.RayWatcher.GroupSelect or db[db.RayWatcher.GroupSelect].disabled end,
						values = {},
					},
					itemcooldowns = {
						order = 15,
						type = "select",
						name = L["已有物品冷却监视"],
						set = function(info, value) UpdateInput(value, "itemCD") end,
						disabled = function(info) return not db.RayWatcher.GroupSelect or db[db.RayWatcher.GroupSelect].disabled end,
						values = {},
					},
					spacer5 = {
						type = 'description',
						name = '',
						desc = '',
						width = "full",
						order = 16,
					},
					idinput = {
						order = 17,
						type = "input",
						name = L["ID"],
						get = function(info, value) return db.RayWatcher[ info[#info] ] end,
						set = function(info, value) db.RayWatcher[ info[#info] ] = value end,
						disabled = function(info) return not db.RayWatcher.GroupSelect or db[db.RayWatcher.GroupSelect].disabled end,
					},
					filterinput = {
						order = 18,
						name = L["类型"],
						get = function(info, value) return db.RayWatcher[ info[#info] ] end,
						set = function(info, value) db.RayWatcher[ info[#info] ] = value end,
						disabled = function(info) return not db.RayWatcher.GroupSelect or db[db.RayWatcher.GroupSelect].disabled end,
						width = "half",
						type = "select",
						values = {
							["BUFF"] = L["增益"],
							["DEBUFF"] = L["减益"],
							["CD"] = L["冷却"],
							["itemCD"] = L["物品冷却"],
						},
					},
					unitidinput = {
						order = 19,
						type = "select",
						name = L["监视对象"],
						get = function(info, value) return db.RayWatcher[ info[#info] ] end,
						set = function(info, value) db.RayWatcher[ info[#info] ] = value end,
						disabled = function(info) return(db.RayWatcher.filterinput~="BUFF" and db.RayWatcher.filterinput~="DEBUFF") or db[db.RayWatcher.GroupSelect].disabled end,
						width = "half",
						values = {
							["player"] = L["玩家"],
							["target"] = L["目标"],
							["focus"] = L["焦点"],
							["pet"] = L["宠物"],
						},
					},
					casterinput = {
						order = 20,
						type = "select",
						name = L["施法者"],
						get = function(info, value) return db.RayWatcher[ info[#info] ] end,
						set = function(info, value) db.RayWatcher[ info[#info] ] = value end,
						hidden = function(info) return(db.RayWatcher.filterinput~="BUFF" and db.RayWatcher.filterinput~="DEBUFF") or db[db.RayWatcher.GroupSelect].disabled end,
						width = "half",
						values = {
							["player"] = L["玩家"],
							["target"] = L["目标"],
							["focus"] = L["焦点"],
							["pet"] = L["宠物"],
							["all"] = L["任何人"],
						},
					},
					spacer7 = {
						type = 'description',
						name = '',
						desc = '',
						width = "full",
						order = 21,
					},
					addbutton = {
						order = 22,
						type = "execute",
						name = L["添加"],
						desc = L["添加到当前分组"],
						width = "half",
						disabled = function(info) return (not db.RayWatcher.filterinput or not db.RayWatcher.idinput) or db[db.RayWatcher.GroupSelect].disabled end,
						func = function()
							db[db.RayWatcher.GroupSelect][db.RayWatcher.filterinput] = db[db.RayWatcher.GroupSelect][db.RayWatcher.filterinput] or {}
							db[db.RayWatcher.GroupSelect][db.RayWatcher.filterinput][tonumber(db.RayWatcher.idinput)] = {
								["caster"] = db.RayWatcher.casterinput,
								["unitID"] = db.RayWatcher.unitidinput,
							}
							ns.modules[db.RayWatcher.GroupSelect][db.RayWatcher.filterinput] = ns.modules[db.RayWatcher.GroupSelect][db.RayWatcher.filterinput] or {}
							ns.modules[db.RayWatcher.GroupSelect][db.RayWatcher.filterinput][tonumber(db.RayWatcher.idinput)] = {
								["caster"] = db.RayWatcher.casterinput,
								["unitID"] = db.RayWatcher.unitidinput,
							}
							UpdateGroup()
							if not testing then
								ns.modules[db.RayWatcher.GroupSelect]:Update()
							end
						end,
					},
					deletebutton = {
						order = 23,
						type = "execute",
						name = L["删除"],
						desc = L["从当前分组删除"],
						width = "half",
						disabled = function(info) return (not db.RayWatcher.idinput or not db.RayWatcher.filterinput or not ns.modules[db.RayWatcher.GroupSelect][db.RayWatcher.filterinput] or not ns.modules[db.RayWatcher.GroupSelect][db.RayWatcher.filterinput][tonumber(db.RayWatcher.idinput)]) or db[db.RayWatcher.GroupSelect].disabled end,
						func = function()
							db[db.RayWatcher.GroupSelect][db.RayWatcher.filterinput] = db[db.RayWatcher.GroupSelect][db.RayWatcher.filterinput] or {}
							db[db.RayWatcher.GroupSelect][db.RayWatcher.filterinput][tonumber(db.RayWatcher.idinput)] = false
							ns.modules[db.RayWatcher.GroupSelect][db.RayWatcher.filterinput] = ns.modules[db.RayWatcher.GroupSelect][db.RayWatcher.filterinput] or {}
							ns.modules[db.RayWatcher.GroupSelect][db.RayWatcher.filterinput][tonumber(db.RayWatcher.idinput)] = false
							UpdateGroup()
							if not testing then
								ns.modules[db.RayWatcher.GroupSelect]:Update()
							end
						end,
					},
				},
			},
		},
	}
	
	RayWatcherConfig.Options.args.profiles = RayWatcherConfig.profile
end