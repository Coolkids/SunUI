-- *****************************************************
-- ** BubbleBobble by hankthetank
-- *****************************************************
local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local


local events = {
	CHAT_MSG_SAY = "chatBubbles", CHAT_MSG_YELL = "chatBubbles",
	CHAT_MSG_PARTY = "chatBubblesParty", CHAT_MSG_PARTY_LEADER = "chatBubblesParty",
	CHAT_MSG_MONSTER_SAY = "chatBubbles", CHAT_MSG_MONSTER_YELL = "chatBubbles", CHAT_MSG_MONSTER_PARTY = "chatBubblesParty",
}

-- WorldFrame frames are always uiScaled it seems
local function FixedScale(len)
	return GetScreenHeight() * len / 768
end

local function RotateCoordPair(x, y, ox, oy, a, asp)
	y = y / asp
	oy = oy / asp
	return ox + (x - ox) * math.cos(a) - (y - oy) * math.sin(a),
		(oy + (y - oy) * math.cos(a) + (x - ox) * math.sin(a)) * asp
end

-- Clip + rotate texture
local function SetRotatedTexCoords(tex, left, right, top, bottom, width, height, angle, originx, originy)
	local ratio, angle, originx, originy = width / height, math.rad(angle), originx or 0.5, originy or 1
	local LRx, LRy = RotateCoordPair(left, top, originx, originy, angle, ratio)
	local LLx, LLy = RotateCoordPair(left, bottom, originx, originy, angle, ratio)
	local ULx, ULy = RotateCoordPair(right, top, originx, originy, angle, ratio)
	local URx, URy = RotateCoordPair(right, bottom, originx, originy, angle, ratio)
	tex:SetTexCoord(LRx, LRy, LLx, LLy, ULx, ULy, URx, URy)
end

-- Skin a new frame
local function SkinFrame(frame)
	for i = 1, select("#", frame:GetRegions()) do
		local region = select(i, frame:GetRegions())
		if region:GetObjectType() == "FontString" then
			frame.text = region
		elseif region:GetObjectType() == "Texture" then
			region:SetTexture(nil)
		end
	end
	
	-- Chat text
	frame.text:SetFontObject(GameFontNormal)
	frame.text:SetJustifyH("LEFT")

	-- Border
	frame:ClearAllPoints()
	frame:SetPoint("TOPLEFT", frame.text, -FixedScale(3), FixedScale(3))
	frame:SetPoint("BOTTOMRIGHT", frame.text, FixedScale(3), -FixedScale(3))
	frame:CreateShadow(0.5)
	frame:SetFrameStrata("BACKGROUND")
	frame:SetClampedToScreen(false)
	frame:HookScript("OnHide", function() frame.inUse = false end)
end

-- Update a frame
local function UpdateFrame(frame, guid, name)
	if not frame.text then SkinFrame(frame) end
	frame.inUse = true
	local class
	if guid ~= nil and guid ~= "" then
		_, class, _, _, _, _ = GetPlayerInfoByGUID(guid)
	end
	
	if name then
		local color = RAID_CLASS_COLORS[class] or { r = 0, g = 0, b = 0 }
		frame.shadow:SetBackdropBorderColor(color.r, color.g, color.b)
	end
		
end

-- Find chat bubble with given message
local function FindFrame(msg)
	for i = 1, WorldFrame:GetNumChildren() do
		local frame = select(i, WorldFrame:GetChildren())
		if not frame:GetName() and not frame.inUse then
			for i = 1, select("#", frame:GetRegions()) do
				local region = select(i, frame:GetRegions())
				if region:GetObjectType() == "FontString" and region:GetText() == msg then
					return frame
				end
			end

		end
	end
end

local f = CreateFrame("Frame")
for event, cvar in pairs(events) do f:RegisterEvent(event) end

f:SetScript("OnEvent", function(self, event, msg, sender, _, _, _, _, _, _, _, _, _, guid)
	if GetCVarBool(events[event]) then
		f.elapsed = 0
		f:SetScript("OnUpdate", function(self, elapsed)
			self.elapsed = self.elapsed + elapsed
			local frame = FindFrame(msg)
			if frame or self.elapsed > 0.3 then  --0.3
				f:SetScript("OnUpdate", nil)
				if frame then UpdateFrame(frame, guid, sender) end
			end
		end)
	end
end)
