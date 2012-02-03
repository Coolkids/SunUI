local ADDON_NAME, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "oUF_Freebgrid was unable to locate oUF install.")

-- This is a stripped and modified oUF MovableFrames to fit my needs.
-- freebaser

local round = function(n)
    return math.floor(n * 1e5 + .5) / 1e5
end

local getPoint = function(obj)
    local UIx, UIy = UIParent:GetCenter()
    local Ox, Oy = obj:GetCenter()

    -- Frame doesn't really have a positon yet.
    if(not Ox) then return end

    local UIS = UIParent:GetEffectiveScale()
    local OS = obj:GetEffectiveScale()

    local UIWidth, UIHeight = UIParent:GetRight(), UIParent:GetTop()

    local LEFT = UIWidth / 3
    local RIGHT = UIWidth * 2 / 3

    local point, x, y
    if(Ox >= RIGHT) then
        point = 'RIGHT'
        x = obj:GetRight() - UIWidth
    elseif(Ox <= LEFT) then
        point = 'LEFT'
        x = obj:GetLeft()
    else
        x = Ox - UIx
    end

    local BOTTOM = UIHeight / 3
    local TOP = UIHeight * 2 / 3

    if(Oy >= TOP) then
        point = 'TOP' .. (point or '')
        y = obj:GetTop() - UIHeight
    elseif(Oy <= BOTTOM) then
        point = 'BOTTOM' .. (point or '')
        y = obj:GetBottom()
    else
        if(not point) then point = 'CENTER' end
        y = Oy - UIy
    end

    return string.format(
    '%s\031%s\031%d\031%d',
    point, 'UIParent', round(x * UIS / OS),  round(y * UIS / OS)
    )
end

local savePosition = function(anchor)
	local _DB = ns.db.Freebgridomf2Char or {}

    local style, identifier  = "Freebgrid", anchor:GetName()
    if(not _DB[style]) then _DB[style] = {} end

    _DB[style][identifier] = getPoint(anchor)
	ns.db.Freebgridomf2Char = _DB

end

local setframe
do
    local OnDragStart = function(self)
        self:StartMoving()
        self:ClearAllPoints()
    end

    local OnDragStop = function(self)
        self:StopMovingOrSizing()
        savePosition(self)
    end

    setframe = function(frame)
        frame:SetHeight(ns.db.height)
        frame:SetWidth(ns.db.width)
        frame:SetFrameStrata"TOOLTIP"
        frame:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background";})
        frame:EnableMouse(true)
        frame:SetMovable(true)
        frame:SetClampedToScreen(true)
        frame:RegisterForDrag"LeftButton"
        frame:SetBackdropBorderColor(0, .9, 0)
        frame:SetBackdropColor(0, .9, 0)
        frame:Hide()

        frame:SetScript("OnDragStart", OnDragStart)
        frame:SetScript("OnDragStop", OnDragStop)

        frame.name = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        frame.name:SetPoint"CENTER"
        frame.name:SetJustifyH"CENTER"
        frame.name:SetFont(GameFontNormal:GetFont(), 12)
        frame.name:SetTextColor(1, 1, 1)

        return frame
    end
end

local anchorpool = {}

function ns.restoreDefaultPosition ()
	if not ns.db then return end
	local _DB = ns.db.Freebgridomf2Char or {}
	
    for _, anchor in next, anchorpool do
		local style, identifier = "Defaults", anchor:GetName()

		if(_DB[style] and _DB[style][identifier]) then 
			local scale = anchor:GetScale()
			local point, parentName, x, y = string.split('\031', _DB[style][identifier])
			anchor:ClearAllPoints();
			anchor:SetPoint(point, parentName, point, x / scale, y / scale)
		end
	end
end

function ns.restorePosition()
	local _DB = ns.db.Freebgridomf2Char or {}
	for _, anchor in next, anchorpool do
        local style, identifier = "Freebgrid", anchor:GetName()

		if(_DB[style] and _DB[style][identifier]) then 
			local scale = anchor:GetScale()
			local point, parentName, x, y = string.split('\031', _DB[style][identifier])
			anchor:ClearAllPoints();
			anchor:SetPoint(point, parentName, point, x / scale, y / scale)
		end
    end
end

function ns:Anchors()
	if not anchorpool["oUF_FreebgridRaidFrame"] then
		local raidframe = CreateFrame("Frame", "oUF_FreebgridRaidFrame", UIParent)
		setframe(raidframe)
		raidframe.ident = "Raid"
		raidframe.name:SetText("Raid")
		raidframe:SetPoint("LEFT", UIParent, "LEFT", 8, 0)
		anchorpool["oUF_FreebgridRaidFrame"] = raidframe
	end
	
	if not anchorpool["oUF_FreebgridPetFrame"] then
		local petframe = CreateFrame("Frame", "oUF_FreebgridPetFrame", UIParent)
		setframe(petframe)
		petframe.ident = "Pet"
		petframe.name:SetText("Pet")
		petframe:SetPoint("LEFT", UIParent, "LEFT", 250, 0)
		anchorpool["oUF_FreebgridPetFrame"] = petframe
	end
	
	if not anchorpool["oUF_FreebgridMTFrame"] then
		local mtframe = CreateFrame("Frame", "oUF_FreebgridMTFrame", UIParent)
		setframe(mtframe)
		mtframe.ident = "MT"
		mtframe.name:SetText("MT")
		mtframe:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 8, -60)
		anchorpool["oUF_FreebgridMTFrame"] = mtframe
	end
	ns.restorePosition()
end

local _LOCK
function ns:Movable()

    if(not _LOCK) then
        for k, frame in next, anchorpool do
            frame:Show()
        end
        _LOCK = true
    else
        for k, frame in next, anchorpool do
            frame:Hide()
        end
        _LOCK = nil
    end
end

Freebgrid_NS = ns
