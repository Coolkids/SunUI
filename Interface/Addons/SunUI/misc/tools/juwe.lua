local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local disabled = false
local button

local tip = CreateFrame('GameTooltip', 'GemStatsTip')
local line1 = tip:CreateFontString()
local line2 = tip:CreateFontString()
local line3 = tip:CreateFontString()

tip:AddFontStrings(tip:CreateFontString(), tip:CreateFontString())
tip:AddFontStrings(line1, tip:CreateFontString())
tip:AddFontStrings(line2, tip:CreateFontString())
tip:AddFontStrings(line3, tip:CreateFontString())

local JEWELCRAFTING_S = GetSpellInfo(25229)
local GEM_S = '%+[0-9]+.*'

local match = string.match

local function GetGemStats(id)
    tip:SetOwner(WorldFrame, 'ANCHOR_NONE')
    tip:SetTradeSkillItem(id)

    if(tip:IsShown()) then
        return match(line1:GetText() or '', GEM_S) or match(line2:GetText() or '', GEM_S) or match(line3:GetText() or '', GEM_S)
    end
end

local function Update()
    if(GetTradeSkillLine() ~= JEWELCRAFTING_S) then
        if(button) then
            button:Hide()
        end

        return
    else
        button:Show()
    end

    if(not IsTradeSkillReady()) then return end
    if(disabled) then return end

    local filterBar = TradeSkillFilterBar:IsShown()
    for index = 1, TRADE_SKILLS_DISPLAYED, 1 do
        local buttonIndex = filterBar and index + 1 or index

        local button = _G['TradeSkillSkill' .. buttonIndex]
        if(button) then
            local stats = GetGemStats(button:GetID())
            if(stats) then
                _G['TradeSkillSkill' .. buttonIndex .. 'Text']:SetText(stats)
            end
        end
    end
end

local f = CreateFrame('Frame')
f:RegisterEvent('ADDON_LOADED')
f:SetScript('OnEvent', function(self, event, name)
    if(name == 'Blizzard_TradeSkillUI') then
        button = CreateFrame('Button', 'SomeRandomButton123', TradeSkillFrame, 'UIPanelButtonTemplate')
        button:SetPoint('TOPRIGHT', TradeSkillFrameCloseButton, 'TOPLEFT', -4, -1)
        button:SetSize(15, 15)
        button:SetText(' J')
        button:SetScript('OnClick', function()
            disabled = not disabled
            TradeSkillFrame_Update()
        end)
		local A = S:GetModule("Skins")
		A:Reskin(button)
        hooksecurefunc('TradeSkillFrame_Update', Update)
		self:UnregisterEvent('ADDON_LOADED')
    end
end)