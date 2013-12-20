-- *****************************************************
-- ** BubbleBobble by hankthetank
-- *****************************************************
local S, L, DB, _, C = unpack(select(2, ...))
local _
local settings = {
	bg = {
		texture = "Interface\\Buttons\\WHITE8x8",
		color = {0, 0, 0, 0.5},
		tile = false,
	},
	bd = {
		texture = "Interface\\Tooltips\\UI-Tooltip-Border",
		size = 3,
		color = {0, 0, 0},
	},
	tail = {
		bgTexture = "Interface\\AddOns\\SunUI\\Media\\BubbleBobble\\tailbg",
		bdTexture = "Interface\\AddOns\\SunUI\\Media\\BubbleBobble\\tailbd",
	},
	showSender = false,
}

-- *****************************************************
-- ** End of settings
-- *****************************************************

-- Events & corresponding cVars
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
		end
	end
	
	-- Chat text
	frame.text:SetFontObject(GameFontNormal)
	--frame.text:SetFont(unpack(settings.fontText))
	frame.text:SetJustifyH("LEFT")
	
	-- Sender text
	if settings.showSender then
		frame.sender = frame:CreateFontString()
		frame.sender:SetPoint("TOP", 0, -5)
		frame.sender:SetPoint("LEFT", frame.text)
		frame.sender:SetPoint("RIGHT", frame.text)
		frame.sender:SetFontObject(GameFontNormal)
		--frame.sender:SetFont(unpack(settings.fontSender))
		frame.sender:SetJustifyH("LEFT")
	end
	
	-- Border
	frame:ClearAllPoints()
	frame:SetPoint("TOPLEFT", frame.text, -10, settings.showSender and 10 + FixedScale(settings.fontSender[2]) or 10)
	frame:SetPoint("BOTTOMRIGHT", frame.text, 10, -10)
	frame:SetBackdrop({
		edgeFile = settings.bd.texture,
		edgeSize = settings.bd.size,
		insets = {
			top = settings.bd.inset,
			bottom = settings.bd.inset,
			left = settings.bd.inset,
			right = settings.bd.inse
		}
	})
	frame:SetBackdropBorderColor(unpack(settings.bd.color))
	
	-- Backdrops have no actual tiling
	local bg = frame:CreateTexture(nil, "BACKGROUND")
	bg:SetAllPoints()
	bg:SetTexture(settings.bg.texture, settings.bg.tile)
	bg:SetVertexColor(unpack(settings.bg.color))
	bg:SetHorizTile(settings.bg.tile)
	bg:SetVertTile(settings.bg.tile)
	
	-- Rework tail / bottom edge
	local bottom, tail
	for i = 1, select("#", frame:GetRegions()) do
		local region = select(i, frame:GetRegions())
		if region:GetObjectType() == "Texture" then
			if ({region:GetPoint()})[1] == "BOTTOMLEFT" and region:GetPoint(2) then
				bottom = region
			elseif region:GetTexture() == "Interface\\Tooltips\\ChatBubble-Tail" then
				tail = region
			end
		end
	end
	
	tail:ClearAllPoints()
	tail:SetSize(FixedScale(16), FixedScale(16))
	tail:SetPoint("TOPLEFT", frame, "BOTTOMLEFT",10, 1 / FixedScale(1))
	tail:SetTexture(settings.tail.bgTexture)
	tail:SetVertexColor(unpack(settings.bg.color))
	
	tailBd = frame:CreateTexture()
	tailBd:SetAllPoints(tail)
	tailBd:SetTexture(settings.tail.bdTexture)
	tailBd:SetVertexColor(unpack(settings.bd.color))
	
	-- Make tail break bottom edge
	bottom:SetPoint("BOTTOMRIGHT", tail, "TOPLEFT")
	local bottom2 = frame:CreateTexture(nil, "BORDER")
	bottom2:SetTexture(settings.bd.texture)
	SetRotatedTexCoords(bottom2, 0.375, 0.5, 0, 1, 64, 8, -90, 0.5, 1)
	bottom2:SetVertexColor(unpack(settings.bd.color))
	bottom2:SetHeight(bottom:GetHeight())
	bottom2:SetPoint("LEFT", tail, "RIGHT", -FixedScale(8), 0)
	bottom2:SetPoint("BOTTOMRIGHT", frame, -settings.bd.size, 0)
	
	frame:HookScript("OnHide", function() frame.inUse = false end)
end

-- Update a frame
local function UpdateFrame(frame, guid, name)
	if not frame.text then SkinFrame(frame) end
	frame.inUse = true
	
	if settings.showSender then
		local class
		if guid ~= nil and guid ~= "" then
			_, class, _, _, _, _ = GetPlayerInfoByGUID(guid)
		end
		
		if name then
			local color = RAID_CLASS_COLORS[class] or { r = 1, g = 1, b = 1 }
			frame.sender:SetText(("|cFF%2x%2x%2x%s|r"):format(color.r * 255, color.g * 255, color.b * 255, name))
			if frame.text:GetWidth() < frame.sender:GetWidth() then
				frame.text:SetWidth(frame.sender:GetWidth())
			end
		end
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
			if frame or self.elapsed > 0.3 then
				f:SetScript("OnUpdate", nil)
				if frame then UpdateFrame(frame, guid, sender) end
			end
		end)
	end
end)
