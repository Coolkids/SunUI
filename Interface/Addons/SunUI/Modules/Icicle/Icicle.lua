local S, L, DB, _, C = unpack(select(2, ...))
local IC = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("Icicle", "AceEvent-3.0")
local SunUIConfig = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("SunUIConfig")

----Config----
local iconsize = 22
local xoff = 0
local yoff = 22

---------------

local IcicleReset = {
	[11958] = {"Deep Freeze", "Ice Block", "Icy Veins", "Ring of Frost"},
	[14185] = {"Sprint", "Vanish", "Shadowstep", "Evasion", "Kick", "Dismantle", "Smoke Bomb", "Kick", "Dismantle"},  --with prep glyph "Kick", "Dismantle", "Smoke Bomb"
	[23989] = {"Deterrence", "Silencing Shot", "Scatter Shot", "Rapid Fire", "Kill Shot"},
}

local db = {}
local eventcheck = {}
local purgeframe = CreateFrame("frame")
local plateframe = CreateFrame("frame")
local TrinketTex = "Interface\\Icons\\INV_Jewelry_TrinketPVP_01"
local count = 0
local width
local Sfont
local size

local IcicleInterrupts = {"Mind Freeze", "Skull Bash", "Silencing Shot", "Counterspell", "Rebuke", "Silence", "Kick", "Wind Shear", "Pummel", "Shield Bash", "Spell Lock", "Strangulate"}

local addicons = function(name, f)
	local num = #db[name]
	if not width then width = f:GetWidth() end
	if num * iconsize + (num * 2 - 2) > width then
		size = (width - (num * 2 - 2)) / num
		Sfont = ceil(size - size / 2)
	else 
		size = iconsize
		Sfont = ceil(size - size / 2)
	end
	for i = 1, #db[name] do
		db[name][i]:ClearAllPoints()
		db[name][i]:Width(size)
		db[name][i]:Height(size)
		db[name][i].cooldown:SetFont(DB.Font ,Sfont, "OUTLINE")
		if i == 1 then
			db[name][i]:Point("TOPLEFT", f, xoff, yoff)
		else
			db[name][i]:Point("TOPLEFT", db[name][i-1], size + 2, 0)
		end
	end
end

local hideicons = function(name, f)
	f.icicle = 0
	for i = 1, #db[name] do
		db[name][i]:Hide()
		db[name][i]:SetParent(nil)
	end
	f:SetScript("OnHide", nil)
end

local icontimer = function(icon)
	local itimer = ceil(icon.endtime - GetTime())
	if not Sfont then Sfont = ceil(iconsize - iconsize / 2) end
	if itimer >= 60 then
		icon.cooldown:SetFont(DB.Font ,Sfont, "OUTLINE")
		icon.cooldown:SetText(ceil(itimer/60).."m")
	elseif itimer < 60 and itimer >= 1 then
		icon.cooldown:SetFont(DB.Font ,Sfont, "OUTLINE")
		icon.cooldown:SetText(itimer)
	else
		icon.cooldown:SetText(" ")
		icon:SetScript("OnUpdate", nil)
	end	
end

		
local sourcetable = function(Name, spellID, spellName)
	if not db[Name] then db[Name] = {} end
	local _, _, texture = GetSpellInfo(spellID)
	local duration = DB.IcicleCds[spellID]
	local icon = CreateFrame("frame", nil, UIParent)
	icon.texture = icon:CreateTexture(nil, "BORDER")
	icon.texture:SetAllPoints(icon)
	icon.texture:SetTexture(texture)
	icon.texture:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	icon:CreateShadow()
	icon.endtime = GetTime() + duration
	icon.cooldown = icon:CreateFontString(nil, "OVERLAY")
	icon.cooldown:SetTextColor(0.7, 1, 0)
	icon.cooldown:SetAllPoints(icon)
	icon.name = spellName
	--[[ for k, v in ipairs(IcicleInterrupts) do
		if v == spellName then
			local iconBorder = icon:CreateTexture(nil, "OVERLAY")
			CreateShadow(icon, iconBorder)
		end
	end ]]
	if spellID == 14185 or spellID == 23989 or spellID == 11958 then
		for k, v in ipairs(IcicleReset[spellID]) do			
			for i = 1, #db[Name] do
				if db[Name][i] then
					if db[Name][i].name == v then
						if db[Name][i]:IsVisible() then
							local f = db[Name][i]:GetParent()
							if f.icicle and f.icicle ~= 0 then
								f.icicle = 0
							end
						end
						db[Name][i]:Hide()
						db[Name][i]:SetParent(nil)
						tremove(db[Name], i)
						count = count - 1
					end
				end
			end
		end
	else
		for i = 1, #db[Name] do
			if db[Name][i] then
				if db[Name][i].name == spellName then
					if db[Name][i]:IsVisible() then
						local f = db[Name][i]:GetParent()
						if f.icicle then
							f.icicle = 0
						end
					end
					db[Name][i]:Hide()
					db[Name][i]:SetParent(nil)
					tremove(db[Name], i)
					count = count - 1
				end
			end
		end
	end
	tinsert(db[Name], icon)
	icon:SetScript("OnUpdate", function()
		icontimer(icon)
	end)
end
		
local onpurge = 0
local uppurge = function(self, elapsed)
	onpurge = onpurge + elapsed
	if onpurge >= .33 then
		onpurge = 0
		if count == 0 then
			plateframe:SetScript("OnUpdate", nil)
			purgeframe:SetScript("OnUpdate", nil)
		end
		for k, v in pairs(db) do
			for i, c in ipairs(v) do
				if c.endtime < GetTime() then
					if c:IsVisible() then
						local f = c:GetParent()
						if f.icicle then
							f.icicle = 0
						end
					end
					c:Hide()
					c:SetParent(nil)
					tremove(db[k], i)
					count = count - 1
				end
			end
		end
	end
end
		
local onplate = 0
local getplate = function(frame, elapsed)
	onplate = onplate + elapsed
	if onplate > .33 then
		onplate = 0
		local num = WorldFrame:GetNumChildren()
		for i = 1, num do
			local f = select(i, WorldFrame:GetChildren())
			if f:GetName() then
				local a = f:GetName()
				if a:find("NamePlate") then
					if not f.icicle then f.icicle = 0 end
					if f:IsVisible() then
						local eman = select(2, f:GetChildren()):GetRegions()
						local name = eman:GetText()
						--print(a, name)
						if db[name] ~= nil then
							if f.icicle ~= db[name] then
								f.icicle = #db[name]
								for i = 1, #db[name] do
									db[name][i]:SetParent(f)
									db[name][i]:Show()
								end
								addicons(name, f)
								f:SetScript("OnHide", function()
									hideicons(name, f)
								end)
							end
						end
					end
				end
			end
		end
	end
end


function IC:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
	--test
	-- if not plateframe:GetScript("OnUpdate") then
		-- plateframe:SetScript("OnUpdate", getplate)
		-- purgeframe:SetScript("OnUpdate", uppurge)
	-- end
	local _, eventType, _, _, srcName, srcFlags, _, _, _, _, _, spellID, spellName = ...
	if DB.IcicleCds[spellID] and bit.band(srcFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) ~= 0 then
		local Name = strmatch(srcName, "[%P]+")
		if eventType == "SPELL_CAST_SUCCESS" or eventType == "SPELL_AURA_APPLIED" or eventType == "SPELL_MISSED" or eventType == "SPELL_SUMMON" then
			if not eventcheck[Name] then eventcheck[Name] = {} end
			if not eventcheck[Name][spellName] or GetTime() >= eventcheck[Name][spellName] + 1 then
				count = count + 1
				sourcetable(Name, spellID, spellName)
				eventcheck[Name][spellName] = GetTime()
			end
			if not plateframe:GetScript("OnUpdate") then
				plateframe:SetScript("OnUpdate", getplate)
				purgeframe:SetScript("OnUpdate", uppurge)
			end
		end
	end
end

function IC:PLAYER_ENTERING_WORLD(event, ...)
	wipe(db)
	wipe(eventcheck)
	count = 0
end
function IC:UpdateSet()
	if C["Icicle"] then
		IC:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		IC:RegisterEvent("PLAYER_ENTERING_WORLD")
	else
		IC:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		IC:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
end
function IC:OnInitialize()
	C = SunUIConfig.db.profile.MiniDB
	self:UpdateSet()
end