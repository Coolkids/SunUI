local L = setmetatable({}, {__index = function(t, k) t[k] = k return k end})
if GetLocale()=="zhTW" or GetLocale()=="zhCN" then
	L["Too frequently!!"] = "不要頻繁觀察,否則將失效."
	L["You can now inspect others."] = "現在你可以觀察其他玩家了."
	L["You can not inspect players from other realm."] = "禁止觀察其他伺服器的玩家."
	L["Please remove the old InspectLess addon, LibInspectLess-1.0 is the new name and you should not use them together"] = "發現老版本的InspectLess插件, 請刪除. LibInspectLess-1.0是它的新名字, 不能同時使用兩個."
	L["Request receive no response, player '%s' might just logged off. And because the buggy BLIZZARD, you are probably forbidden to inspect until you restart your client."] = "觀察請求沒有返回結果,玩家'%s'可能剛剛退出游戲,由于暴雪的bug,你很可能在重啟客戶端之前都無法觀察了."
end

local MAJOR, MINOR = "LibInspectLess-1.0", tonumber(("$Rev: 15 $"):match("(%d+)"))

local lib = LibStub:NewLibrary(MAJOR, MINOR)
if not lib then return end

lib.events = lib.events or  LibStub("CallbackHandler-1.0"):New(lib)
lib.frame = lib.frame or CreateFrame("Frame", MAJOR.."_Frame")

--==========================================================================================
LibInspectLessInterval = 1		--use '/run LibInspectLessInterval=3' etc to change.
LibInspectLessDebug = false

assert(not IsAddOnLoaded("InspectLess") and not InspectLessInterval, L["Please remove the old InspectLess addon, LibInspectLess-1.0 is the new name and you should not use them together"]);

SlashCmdList["INSPECTLESS"] = function(msg)
	if not msg or msg=="" then
		DEFAULT_CHAT_FRAME:AddMessage("InspectLess: Interval = "..LibInspectLessInterval, 1, 1, 0)
	elseif strlower(msg)=="debug" then 
		LibInspectLessDebug = not LibInspectLessDebug
		DEFAULT_CHAT_FRAME:AddMessage("InspectLess: Debug = "..tostring(LibInspectLessDebug), 1, 1, 0)
	elseif tonumber(msg) and tonumber(msg)>0.1 then
		LibInspectLessInterval = tonumber(msg)
		DEFAULT_CHAT_FRAME:AddMessage("InspectLess: Interval = "..tonumber(msg), 1, 1, 0)
	end
end
SLASH_INSPECTLESS1 = "/inspectless";
SLASH_INSPECTLESS2 = "/lil";
SLASH_INSPECTLESS3 = "/libinspectless";

local waiting = 0 --timer
local BlockingAllForNextManual = false
local ManualCalling = false
local ShowResumeMessage = false
local InspectLessLastGUID = nil  --上次的观察人员，如果上次的观察和目前的不一样，间隔到了将自动观察, 如果一样，应该判断是否READY，如果已经READY了，最好再发一次READY消息
local InspectOtherRealmWarned = false

function lib:debug(msg, r, g, b)
	if LibInspectLessDebug then DEFAULT_CHAT_FRAME:AddMessage(tostring(msg), r or 0.5, g or 0.5, b or 0.5) end
end

--==========================================================================================
local f = lib.frame
f:UnregisterAllEvents()
f:RegisterEvent("ADDON_LOADED");
f:RegisterEvent("INSPECT_READY");
f:SetScript("OnEvent", function(self, event, ...)
	return lib[event](lib, ...)
end)

f:SetScript("OnUpdate", function(self,elapsed)
	if waiting > 0 then
		waiting = waiting - elapsed
		if waiting<=0 and (BlockingAllForNextManual or ShowResumeMessage) then
			--DEFAULT_CHAT_FRAME:AddMessage("InspectLess: "..L["You can now inspect others."], 0.8, 1, 0)
			ShowResumeMessage = false
		end

		if waiting<=0 then
			lib:debug("end waiting")
			local locked = (lib.unit or lib.guid) and not lib.ready
			if locked then
				--DEFAULT_CHAT_FRAME:AddMessage("InspectLess: "..string.format(L["Request receive no response, player '%s' might just logged off. And because the buggy BLIZZARD, you are probably forbidden to inspect until you restart your client."], lib.name), 0.8, 1, 0)
			end
			InspectLessLastGUID = nil
			lib:debug("fire InspectLess_Next");
			lib.events:Fire("InspectLess_Next", locked)
		end
	end
end)

function lib:hook(name, func)
	assert(type(_G[name])=="function", "Bad arg1, string function name expected")
	assert(type(func)=="function", "Bad arg2, function expected")

	lib.origins = lib.origins or {}
	lib.hooks = lib.hooks or {}

	if not lib.origins[name] then
		lib.origins[name] = _G[name]
		_G[name] = function(...) return lib.hooks[name](...) end
	end
	lib.hooks[name] = func
end

--Hook and protect the ClearInspectPlayer function
lib:hook("ClearInspectPlayer", function(unit)
	--do nothing
end)

--Hook and protect the NotifyInspect function
lib:hook("NotifyInspect", function(unit)
	local pass = false
	if ManualCalling then
		if waiting > 0 then
			BlockingAllForNextManual = true
			lib:debug("manual inspecting blocked.");
		else
			pass = true
		end
	else
		if waiting > 0 then
			--lib:debug("addon inspecting blocked.");
		else
			if not BlockingAllForNextManual then
				InspectLessLastGUID = UnitGUID(unit)
				pass = true
			end
		end
	end

	if pass then
		waiting = LibInspectLessInterval
		lib.fail = false
		lib.ready = false
		lib.done = false
		lib.origins["ClearInspectPlayer"]()
		lib.unit = unit
		lib.name = UnitName(unit)
		lib.guid = UnitGUID(unit)
		lib.manual = ManualCalling

		lib.origins["NotifyInspect"](unit)	--origin call

		if ManualCalling then BlockingAllForNextManual = false end

		lib:debug( (ManualCalling and "manual" or "addon").." inspecting done.".."    "..UnitName(unit));
	end
end)

function lib:ADDON_LOADED(addon)
	if addon=="Blizzard_InspectUI" then
		lib:hook("InspectPaperDollFrame_SetLevel", function()
			if InspectFrame.unit then
				local _, class = UnitClass(InspectFrame.unit); 
				if class and RAID_CLASS_COLORS[class] then 
					lib.origins["InspectPaperDollFrame_SetLevel"]()
				end
			end
		end)

		local BlizzardInspectHook = function(name, unit_or_self)
			ManualCalling = true
			
			local unit = name=="InspectFrame_Show" and unit_or_self or unit_or_self.unit
			lib:debug(name..": "..unit.." last: "..tostring(InspectLessLastGUID));

			if waiting > 0 then
				--block InspectFrame from showing
				if unit and InspectLessLastGUID == UnitGUID(unit) then
					lib:debug("use last, fail="..tostring(lib.fail), 1, 1, 1)

					if lib.fail then --last inspect not get all item.
						lib.checkTimer = 0
						lib.checker:SetScript("OnUpdate", lib.CheckOnUpdate)
					end

					if name=="InspectFrame_Show" then
						InspectFrame.unit = unit;
						InspectSwitchTabs(1);
						ShowUIPanel(InspectFrame);
						InspectFrame_UpdateTabs();
					elseif name=="InspectFrame_UnitChanged" then
						InspectPaperDollFrame_OnShow(unit_or_self);
						SetPortraitTexture(InspectFramePortrait, unit);
						InspectFrameTitleText:SetText(UnitName(unit));
						InspectFrame_UpdateTabs();
						if ( InspectPVPFrame:IsShown() ) then
							InspectPVPFrame_OnShow();
						end
					end

					BlockingAllForNextManual = false
					InspectLessLastGUID = nil
				else
					BlockingAllForNextManual = true
					ShowResumeMessage = true
					--DEFAULT_CHAT_FRAME:AddMessage("InspectLess: "..L["Too frequently!!"], 1, 0.8, 0)
				end
			else
				lib.origins[name](unit_or_self)
			end
			ManualCalling = false
			
		end
		lib:hook("InspectFrame_Show", function(unit)
			return BlizzardInspectHook("InspectFrame_Show", unit)
		end)

		lib:hook("InspectFrame_UnitChanged", function(self)
			return BlizzardInspectHook("InspectFrame_UnitChanged", self)
		end)
	end
end

lib.checker = lib.checker or CreateFrame("Frame")
function lib:INSPECT_READY(guid)
	self.ready = true
	self:debug("fired InspectReady "..guid);
	self.events:Fire("InspectLess_InspectReady", guid);

	self.checkTimer = 0
	self.checker:SetScript("OnUpdate", self.CheckOnUpdate)
end

lib.failCount = 0
function lib:CheckOnUpdate(elapsed)
	if lib.checkTimer >= 0 then
		lib.checkTimer = lib.checkTimer -elapsed
		if lib.checkTimer < 0 then
			lib:debug("updating")
			local unit = lib:FindUnit(lib.guid)
			if not unit then
				--在檢查的時候, 已經找不到單位了, 比如mouseover已經移走了
				lib.failCount = lib.failCount+1
				lib:debug("failcount "..lib.failCount);
				if lib.failCount>=3 then
					lib.fail = true
					lib.failCount = 0
					lib.checkTimer = 0
					lib.checker:SetScript("OnUpdate", nil)
					lib:debug("fired ItemFail, "..lib.unit);
					lib.events:Fire("InspectLess_InspectItemFail", lib.unit, lib.guid)
				else
					lib.checkTimer = 0.1
				end
			else
				local done = lib:GetInspectItemLinks(unit)
				lib:debug("checked "..tostring(done));
				if done then
					lib.done = true
					lib.failCount = 0
					lib.checkTimer = 0
					lib.checker:SetScript("OnUpdate", nil)
					lib:debug("fired ItemReady, "..unit);
					lib.events:Fire("InspectLess_InspectItemReady", unit, lib.guid)
				else
					lib.checkTimer = 0.2
				end
			end
		end
	end
end

function lib:FindUnit(guid)
	assert(guid, "Here guid should not be nil.")
	if UnitGUID(lib.unit)==guid then
		return lib.unit
	elseif InspectFrame and InspectFrame:IsVisible() and InspectFrame.unit and UnitGUID(InspectFrame.unit)==guid then
		return InspectFrame.unit
	else
		--experimental
		if GetNumRaidMembers() then
			for i=1, GetNumRaidMembers() do
				if UnitGUID("raid"..i)==guid then
					return "raid"..i
				end
			end
		elseif GetNumPartyMembers() then
			for i=1, GetNumPartyMembers() do
				if UnitGUID("party"..i)==guid then
					return "party"..i
				end
			end
		else
			if UnitGUID("player")==guid then return "player" end
			if UnitGUID("target")==guid then return "target" end
			if UnitGUID("focus")==guid then return "focus" end
		end
	end
end

function lib:GetInspectItemLinks(unit)
	local done = true
	for i=1, 18 ,1 do
		if GetInventoryItemTexture(unit, i) and not GetInventoryItemLink(unit, i) then
			--GetTexture always return stuff but GetLink is not.
			done = false
		end
	end
	return done
end

function lib:GetUnit()
	local u = lib.unit
	if u and lib.guid==UnitGUID(u) and UnitIsVisible(u) and UnitIsConnected(u) and CanInspect(u) and UnitClass(u) then
		return u
	end
end

function lib:GetGUID()
	return lib.guid
end

function lib:IsReady()
	return lib.ready
end

function lib:IsDone()
	return lib.done
end

function lib:IsFail()
	return lib.done
end