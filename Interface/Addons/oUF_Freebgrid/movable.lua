local ADDON_NAME, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "oUF_Freebgrid was unable to locate oUF install.")

-- This is a stripped and modified oUF MovableFrames to fit my needs.
-- freebaser

local _DB

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

local saveDefaultPosition = function(anchor)
    local style, identifier = "Freebgrid", anchor:GetName()
    if(not _DB.__INITIAL) then
        _DB.__INITIAL = {}
    end

    if(not _DB.__INITIAL[style]) then
        _DB.__INITIAL[style] = {}
    end

    if(not _DB.__INITIAL[style][identifier]) then	
        _DB.__INITIAL[style][identifier] = getPoint(anchor)
    end
end

local savePosition = function(anchor)
    local style, identifier  = "Freebgrid", anchor:GetName()
    if(not _DB[style]) then _DB[style] = {} end

    _DB[style][identifier] = getPoint(anchor)
end

local setframe
do
    local OnDragStart = function(self)
        saveDefaultPosition(self)
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

local restoreDefaultPosition = function(style, identifier)
    -- We've not saved any default position for this style.
    if(not _DB.__INITIAL or not _DB.__INITIAL[style] or not _DB.__INITIAL[style][identifier]) then return end

    local anchor
    for _, frame in next, anchorpool do
        if frame:GetName() == identifier then
            anchor = frame
        end
    end
    if not anchor then return end

    local scale = anchor:GetScale()
    local SetPoint = getmetatable(anchor).__index.SetPoint;

    (anchor):ClearAllPoints();

    local point, parentName, x, y = string.split('\031', _DB.__INITIAL[style][identifier])
    SetPoint(anchor, point, parentName, point, x / scale, y / scale)

    -- We don't need this anymore
    _DB.__INITIAL[style][identifier] = nil
    if(not next(_DB.__INITIAL[style])) then
        _DB[style] = nil
    end
end

local function restorePosition(anchor)
    local style, identifier = "Freebgrid", anchor:GetName()
    -- We've not saved any custom position for this style.
    if(not _DB[style] or not _DB[style][identifier]) then return end

    local scale = anchor:GetScale()
    local SetPoint = getmetatable(anchor).__index.SetPoint;

    -- Hah, a spot you have to use semi-colon!
    -- Guess I've never experienced that as these are usually wrapped in do end
    -- statements.
    (anchor).SetPoint = restorePosition;
    (anchor):ClearAllPoints();

    -- damn it Blizzard, _how_ did you manage to get the input of this function
    -- reversed. Any sane person would implement this as: split(str, dlm, lim);
    local point, parentName, x, y = string.split('\031', _DB[style][identifier])
    SetPoint(anchor, point, parentName, point, x / scale, y / scale)
end

function ns:Anchors()
    local raidframe = CreateFrame("Frame", "oUF_FreebgridRaidFrame", UIParent)
    setframe(raidframe)
    raidframe.ident = "Raid"
    raidframe.name:SetText("Raid")
    raidframe:SetPoint("LEFT", UIParent, "LEFT", 666, -270)                        -- 团队框体移动位置
    anchorpool["oUF_FreebgridRaidFrame"] = raidframe

    local petframe = CreateFrame("Frame", "oUF_FreebgridPetFrame", UIParent)
    setframe(petframe)
    petframe.ident = "Pet"
    petframe.name:SetText("Pet")
    petframe:SetPoint("LEFT", UIParent, "LEFT", 300, -270)                        -- 宠物框体移动位置
    anchorpool["oUF_FreebgridPetFrame"] = petframe

    local mtframe = CreateFrame("Frame", "oUF_FreebgridMTFrame", UIParent)
    setframe(mtframe)
    mtframe.ident = "MT"
    mtframe.name:SetText("MT")
    mtframe:SetPoint("LEFT", UIParent, "LEFT", 360, -270)                   -- MT框体移动位置
    anchorpool["oUF_FreebgridMTFrame"] = mtframe

    for _, frame in next, anchorpool do
        restorePosition(frame)
    end
end

do
    local frame = CreateFrame"Frame"
    frame:RegisterEvent"ADDON_LOADED"
    frame:SetScript("OnEvent", function(self, event, addon)
        if addon ~= ADDON_NAME then return end

        if ns.db and ns.db.omfChar then
            _DB = Freebgridomf2Char or {}
            Freebgridomf2Char = _DB
        else
            _DB = Freebgridomf2 or {}
            Freebgridomf2 = _DB
        end

        self:UnregisterEvent"ADDON_LOADED"
    end)
end

do
    local opt = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
    opt:Hide()

    opt.parent = ADDON_NAME
    opt.name = "oUF: MovableFrames"
    opt:SetScript("OnShow", function(self)
        local title = self:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
        title:SetPoint('TOPLEFT', 16, -16)
        title:SetText'oUF: MovableFrames'

        local subtitle = self:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
        subtitle:SetHeight(40)
        subtitle:SetPoint('TOPLEFT', title, 'BOTTOMLEFT', 0, -8)
        subtitle:SetPoint('RIGHT', self, -32, 0)
        subtitle:SetNonSpaceWrap(true)
        subtitle:SetWordWrap(true)
        subtitle:SetJustifyH'LEFT'
        subtitle:SetText('Type /freeb to toggle frame anchors.')

        local scroll = CreateFrame("ScrollFrame", nil, self)
        scroll:SetPoint('TOPLEFT', subtitle, 'BOTTOMLEFT', 0, -8)
        scroll:SetPoint("BOTTOMRIGHT", 0, 4)

        local scrollchild = CreateFrame("Frame", nil, self)
        scrollchild:SetPoint"LEFT"
        scrollchild:SetHeight(scroll:GetHeight())
        scrollchild:SetWidth(scroll:GetWidth())

        scroll:SetScrollChild(scrollchild)
        scroll:UpdateScrollChildRect()
        scroll:EnableMouseWheel(true)

        local slider = CreateFrame("Slider", nil, scroll)

        local backdrop = {
            bgFile = [[Interface\ChatFrame\ChatFrameBackground]], tile = true, tileSize = 16,
            edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]], edgeSize = 16,
            insets = {left = 4, right = 4, top = 4, bottom = 4},
        }

        local createOrUpdateMadnessOfGodIhateGUIs
        local OnClick = function(self)
            scroll.value = slider:GetValue()
            _DB[self.style][self.ident] = nil

            if(not next(_DB[self.style])) then
                _DB[self.style] = nil
            end

            restoreDefaultPosition(self.style, self.ident)

            return createOrUpdateMadnessOfGodIhateGUIs()
        end

        local OnEnter = function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
            GameTooltip:SetText(DELETE)
        end

        function createOrUpdateMadnessOfGodIhateGUIs()
            local data = self.data or {}

            local slideHeight = 0
            local numStyles = 1
            for style, styleData in next, _DB do
                if(style ~= '__INITIAL') then
                    if(not data[numStyles]) then
                        local box = CreateFrame('Frame', nil, scrollchild)
                        box:SetBackdrop(backdrop)
                        box:SetBackdropColor(.1, .1, .1, .5)
                        box:SetBackdropBorderColor(.3, .3, .3, 1)

                        if(numStyles == 1) then
                            box:SetPoint('TOP', 0, -12)
                        else
                            box:SetPoint('TOP', data[numStyles - 1], 'BOTTOM', 0, -16)
                        end
                        box:SetPoint'LEFT'
                        box:SetPoint('RIGHT', -30, 0)

                        local title = box:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
                        title:SetPoint('BOTTOMLEFT', box, 'TOPLEFT', 8, 0)
                        box.title = title

                        data[numStyles] = box
                    end

                    -- Fetch the box and update it
                    local box = data[numStyles]
                    box.title:SetText(style)

                    local rows = box.rows or {}
                    local numFrames = 1
                    for unit, points in next, styleData do
                        if(not rows[numFrames]) then
                            local row = CreateFrame('Button', nil, box)

                            row:SetBackdrop(backdrop)
                            row:SetBackdropBorderColor(.3, .3, .3)
                            row:SetBackdropColor(.1, .1, .1, .5)

                            if(numFrames == 1) then
                                row:SetPoint('TOP', 0, -8)
                            else
                                row:SetPoint('TOP', rows[numFrames-1], 'BOTTOM')
                            end

                            row:SetPoint('LEFT', 6, 0)
                            row:SetPoint('RIGHT', -25, 0)
                            row:SetHeight(24)

                            local anchor = row:CreateFontString(nil, nil, 'GameFontHighlight')
                            anchor:SetPoint('RIGHT', -10, 0)
                            anchor:SetPoint('TOP', 0, -4)
                            anchor:SetPoint'BOTTOM'
                            anchor:SetJustifyH'RIGHT'
                            row.anchor = anchor

                            local label = row:CreateFontString(nil, nil, 'GameFontHighlight')
                            label:SetPoint('LEFT', 10, 0)
                            label:SetPoint('RIGHT', anchor)
                            label:SetPoint('TOP', 0, -4)
                            label:SetPoint'BOTTOM'
                            label:SetJustifyH'LEFT'
                            row.label = label

                            local delete = CreateFrame("Button", nil, row)
                            delete:SetWidth(16)
                            delete:SetHeight(16)
                            delete:SetPoint('LEFT', row, 'RIGHT')

                            delete:SetNormalTexture[[Interface\Buttons\UI-Panel-MinimizeButton-Up]]
                            delete:SetPushedTexture[[Interface\Buttons\UI-Panel-MinimizeButton-Down]]
                            delete:SetHighlightTexture[[Interface\Buttons\UI-Panel-MinimizeButton-Highlight]]

                            delete:SetScript("OnClick", OnClick)
                            delete:SetScript("OnEnter", OnEnter)
                            delete:SetScript("OnLeave", GameTooltip_Hide)
                            row.delete = delete

                            rows[numFrames] = row
                        end

                        -- Fetch row and update it:
                        local row = rows[numFrames]
                        local point, _, x, y = string.split('\031', points)
                        row.anchor:SetFormattedText('%11s %4s %4s', point, x, y)
                        row.label:SetText(anchorpool[unit].ident)

                        row.delete.style = style
                        row.delete.ident = unit
                        row:Show()

                        numFrames = numFrames + 1
                    end

                    box.rows = rows

                    local height = (numFrames * 24) - 8
                    slideHeight = slideHeight + height + 16
                    box:SetHeight(height)
                    box:Show()

                    -- Hide left over rows we aren't using:
                    while(rows[numFrames]) do
                        rows[numFrames]:Hide()
                        numFrames = numFrames + 1
                    end

                    numStyles = numStyles + 1
                end
            end

            -- Hide left over boxes we aren't using:
            while(data[numStyles]) do
                data[numStyles]:Hide()
                numStyles = numStyles + 1
            end

            self.data = data
            local height = slideHeight - scroll:GetHeight()
            if(height > 0) then
                slider:SetMinMaxValues(0, height)
            else
                slider:SetMinMaxValues(0, 0)
            end

            slider:SetValue(scroll.value or 0)
        end

        slider:SetWidth(16)

        slider:SetPoint("TOPRIGHT", -8, -24)
        slider:SetPoint("BOTTOMRIGHT", -8, 24)

        local up = CreateFrame("Button", nil, slider)
        up:SetPoint("BOTTOM", slider, "TOP")
        up:SetWidth(16)
        up:SetHeight(16)
        up:SetNormalTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Up")
        up:SetPushedTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Down")
        up:SetDisabledTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Disabled")
        up:SetHighlightTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Highlight")

        up:GetNormalTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
        up:GetPushedTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
        up:GetDisabledTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
        up:GetHighlightTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
        up:GetHighlightTexture():SetBlendMode("ADD")

        up:SetScript("OnClick", function(self)
            local box = self:GetParent()
            box:SetValue(box:GetValue() - box:GetHeight()/2)
        end)

        local down = CreateFrame("Button", nil, slider)
        down:SetPoint("TOP", slider, "BOTTOM")
        down:SetWidth(16)
        down:SetHeight(16)
        down:SetNormalTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Up")
        down:SetPushedTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Down")
        down:SetDisabledTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Disabled")
        down:SetHighlightTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Highlight")

        down:GetNormalTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
        down:GetPushedTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
        down:GetDisabledTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
        down:GetHighlightTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
        down:GetHighlightTexture():SetBlendMode("ADD")

        down:SetScript("OnClick", function(self)
            local box = self:GetParent()
            box:SetValue(box:GetValue() + box:GetHeight()/2)
        end)

        slider:SetThumbTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
        local thumb = slider:GetThumbTexture()
        thumb:SetWidth(16)
        thumb:SetHeight(24)
        thumb:SetTexCoord(1/4, 3/4, 1/8, 7/8)

        slider:SetScript("OnValueChanged", function(self, val, ...)
            local min, max = self:GetMinMaxValues()
            if(val == min) then up:Disable() else up:Enable() end
            if(val == max) then down:Disable() else down:Enable() end

            scroll.value = val
            scroll:SetVerticalScroll(val)
            scrollchild:SetPoint('TOP', 0, val)
        end)

        opt:SetScript("OnShow", function()
            return createOrUpdateMadnessOfGodIhateGUIs()
        end)

        return createOrUpdateMadnessOfGodIhateGUIs()
    end)

    ns.movableopt = opt
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
