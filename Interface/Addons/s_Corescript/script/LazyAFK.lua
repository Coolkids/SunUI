--[[Thanks to AFK Timer by leethal for the majority of the timer code!]]
local S, C, L, DB = unpack(s_Core)
local AFK, hour, minute
local total = 0
local afk_minutes = 0
local afk_seconds = 0
local update = 0
local interval = 1.0

local frame = CreateFrame("Frame")
frame:Hide();
frame:SetHeight(160)
frame:SetWidth(350)
frame:SetPoint("CENTER", UIParent)
frame:EnableMouse(true)
frame:SetMovable(true)
frame:SetUserPlaced(true)
frame:SetClampedToScreen(true)
frame:SetScript("OnMouseDown", frame.StartMoving)
frame:SetScript("OnMouseUp", frame.StopMovingOrSizing)
frame:CreateShadow("Background")
local font = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
font:SetText("你处于AFK状态!")
font:SetPoint("TOP", frame, "TOP", 0, -20)
local timer = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
timer:SetText("0:00")
timer:SetPoint("TOP", frame, "TOP", 0, -55)

function button_OnClick()
    frame:Hide();
	if UnitIsAFK("player") then
        SendChatMessage("", "AFK");
        timer:SetText("0:00")
    end
end

local button = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
button:SetHeight(25)
button:SetWidth(125)
button:SetPoint("BOTTOM", frame, "BOTTOM", 0, 15)
button:SetText("我回来了!!")
button:RegisterForClicks("AnyUp")
button:SetScript("OnClick", button_OnClick)
S.Reskin(button)
local close = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -8, -8)
close:SetText("X")
close:SetHeight(25)
close:SetWidth(25)
S.Reskin(close)
function frame_OnLoad(self)
    self:SetScript("OnEvent", frame_OnEvent)
	self:RegisterEvent("PLAYER_FLAGS_CHANGED");
end

function frame_OnEvent(self, event, ...)
	if (event == "PLAYER_FLAGS_CHANGED") then
		if UnitIsAFK("player") then
			frame:Show();
            AFK = true
            hour, minute = GetGameTime()
            frame:SetScript("OnUpdate", frame_OnUpdate)
        else
            AFK = false
            total = 0
            frame:SetScript("OnUpdate", nil)
		end
	end
end

function frame_OnUpdate(self, elapsed)
	if AFK == true then
		update = update + elapsed
		if update > interval then
			total = total + 1
			frame_ParseSeconds(total)
			update = 0
		end
	end
end

function frame_ParseSeconds(num)
	local minutes = afk_minutes
	local seconds = afk_seconds
	if num >= 60 then
		minutes = floor(num / 60)
		seconds = tostring(num - (minutes * 60))
		frame_DisplayTime(minutes, seconds)
	else
		minutes = 0
		seconds = num
        frame_DisplayTime(minutes, seconds)
	end
	afk_minutes = tostring(minutes)
	afk_seconds = tostring(seconds)
end

function frame_DisplayTime(minutes, seconds)
	timer:SetText(tostring(minutes)..":"..string.format("%02d", tostring(seconds)))
end

frame_OnLoad(frame);