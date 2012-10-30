local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("SunUI fixPX")
--  自动设置聊天框体和UI缩放
local _
local function SetChatFrame()
	ChatFrame1:ClearAllPoints()
	ChatFrame1:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 3, 33)
	ChatFrame1:SetWidth(327)
	ChatFrame1:SetHeight(122)
	-- 聊天频道职业染色
	local channels = {"SAY","EMOTE","YELL","GUILD","OFFICER","GUILD_ACHIEVEMENT","ACHIEVEMENT","WHISPER","PARTY","PARTY_LEADER","RAID","RAID_LEADER","RAID_WARNING","BATTLEGROUND","BATTLEGROUND_LEADER","CHANNEL1","CHANNEL2","CHANNEL3","CHANNEL4","CHANNEL5","CHANNEL6","CHANNEL7",}	
	for i, v in ipairs(channels) do
		ToggleChatColorNamesByClassGroup(true, v)
	end
	ChatFrame1:SetClampedToScreen(false)
end
local resolution = GetCVar('gxResolution')
local screenheight = tonumber(string.match(resolution, "%d+x(%d+)"))
local screenwidth = tonumber(string.match(resolution, "(%d+)x+%d"))
local eyefinity
function SetUIScale()
	
	local lowversion = false

	if screenwidth < 1600 then
			lowversion = true
	elseif screenwidth >= 3840 or (UIParent:GetWidth() + 1 > screenwidth) then
		local width = screenwidth
		local height = screenheight
	
		-- because some user enable bezel compensation, we need to find the real width of a single monitor.
		-- I don't know how it really work, but i'm assuming they add pixel to width to compensate the bezel. :P

		-- HQ resolution
		if width >= 9840 then width = 3280 end                   	                -- WQSXGA
		if width >= 7680 and width < 9840 then width = 2560 end                     -- WQXGA
		if width >= 5760 and width < 7680 then width = 1920 end 	                -- WUXGA & HDTV
		if width >= 5040 and width < 5760 then width = 1680 end 	                -- WSXGA+

		-- adding height condition here to be sure it work with bezel compensation because WSXGA+ and UXGA/HD+ got approx same width
		if width >= 4800 and width < 5760 and height == 900 then width = 1600 end   -- UXGA & HD+

		-- low resolution screen
		if width >= 4320 and width < 4800 then width = 1440 end 	                -- WSXGA
		if width >= 4080 and width < 4320 then width = 1360 end 	                -- WXGA
		if width >= 3840 and width < 4080 then width = 1224 end 	                -- SXGA & SXGA (UVGA) & WXGA & HDTV

		if width < 1600 then
			lowversion = true
		end
		
		-- register a constant, we will need it later for launch.lua
		eyefinity = width
	end

	if lowversion == true then
		ResScale = 0.9
	else
		ResScale = 1
	end
	return ResScale
end

SlashCmdList["AutoSet"] = function()
	if not UnitAffectingCombat("player") then
		SetChatFrame()
		local ResScale = SetUIScale()
	SetCVar("useUiScale", 1)
	SetCVar("uiScale", ResScale)
	--ReloadUI()
	end
end
SLASH_AutoSet1 = "/AutoSet"
SlashCmdList["SetChat"] = function()
	SetChatFrame()
end
SLASH_SetChat1 = "/setchat"

--fix 1px
--------------------------------------------------------
-- Graphics Settings
--------------------------------------------------------
if screenwidth < 1600 then
			lowversion = true
	elseif screenwidth >= 3840 or (UIParent:GetWidth() + 1 > screenwidth) then

		local width = screenwidth
		local height = screenheight
	
		-- because some user enable bezel compensation, we need to find the real width of a single monitor.
		-- I don't know how it really work, but i'm assuming they add pixel to width to compensate the bezel. :P

		-- HQ resolution
		if width >= 9840 then width = 3280 end                   	                -- WQSXGA
		if width >= 7680 and width < 9840 then width = 2560 end                     -- WQXGA
		if width >= 5760 and width < 7680 then width = 1920 end 	                -- WUXGA & HDTV
		if width >= 5040 and width < 5760 then width = 1680 end 	                -- WSXGA+

		-- adding height condition here to be sure it work with bezel compensation because WSXGA+ and UXGA/HD+ got approx same width
		if width >= 4800 and width < 5760 and height == 900 then width = 1600 end   -- UXGA & HD+

		-- low resolution screen
		if width >= 4320 and width < 4800 then width = 1440 end 	                -- WSXGA
		if width >= 4080 and width < 4320 then width = 1360 end 	                -- WXGA
		if width >= 3840 and width < 4080 then width = 1224 end 	                -- SXGA & SXGA (UVGA) & WXGA & HDTV

		if width < 1600 then
			lowversion = true
		end
		
		-- register a constant, we will need it later for launch.lua
		eyefinity = width
	end
	
-- the ui doesn't reload if ratio stay the same, we need to force reload if it happen.
local function NeedReloadUI()
	local resolution = Graphics_ResolutionDropDown
	local x, y = resolution:getValues()
	local oldratio = screenwidth / screenheight
	local newratio = x / y
	local oldreso = GetCVar("gxResolution")
	local newreso = x.."x"..y
	
	if (oldratio == newratio) and (oldreso ~= newreso) then
		ReloadUI()
	end
end

local Graphic = CreateFrame("Frame")
Graphic:RegisterEvent("PLAYER_ENTERING_WORLD")
Graphic:SetScript("OnEvent", function(self, event)
	-- we adjust UIParent to screen #1 if Eyefinity is found
	if eyefinity then
		local width = eyefinity
		local height = screenheight
		
		-- if autoscale is off, find a new width value of UIParent for screen #1.
		if  height > 1200 then
			local h = UIParent:GetHeight()
			local ratio = screenheight / h
			local w = eyefinity / ratio
			
			width = w
			height = h			
		end
		
		UIParent:SetSize(width, height)
		UIParent:ClearAllPoints()
		UIParent:SetPoint("CENTER")
	end

	-- require a reload when graphics option changes, even if Standard Blizzard UI doesn't really need it.
	VideoOptionsFrameOkay:HookScript("OnClick", NeedReloadUI)
	VideoOptionsFrameApply:HookScript("OnClick", NeedReloadUI)
	
	-- unload
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end)

function Module:OnInitialize()
	if C["MiniDB"]["uiScale"] == nil then 
		C["MiniDB"]["uiScale"] = SetUIScale()
	end
	local mult = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")/C["MiniDB"]["uiScale"]
	local function scale(x)
		return (mult*math.floor(x/mult+.5)) 
	end
	S.mult = mult
	S.Scale = function(x) return scale(x) end
end