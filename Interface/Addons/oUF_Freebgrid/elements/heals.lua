local _, ns = ...
local oUF =  ns.oUF or oUF
assert(oUF, "oUF_Freebgrid was unable to locate oUF install.")

local Update = function(self, event, unit)
    if self.unit ~= unit then return end

    local overflow = ns.db.healoverflow and 1.20 or 1
    local myIncomingHeal = UnitGetIncomingHeals(unit, "player") or 0
    local allIncomingHeal = UnitGetIncomingHeals(unit) or 0

    local health = self.Health:GetValue()
    local _, maxHealth = self.Health:GetMinMaxValues()

    if ( health + allIncomingHeal > maxHealth * overflow ) then
        allIncomingHeal = maxHealth * overflow - health
    end

    if ( allIncomingHeal < myIncomingHeal ) then
        myIncomingHeal = allIncomingHeal
        allIncomingHeal = 0
    else
        allIncomingHeal = allIncomingHeal - myIncomingHeal
    end

    self.myHealPredictionBar:SetMinMaxValues(0, maxHealth) 
    if ns.db.healothersonly then
        self.myHealPredictionBar:SetValue(0)
    else
        self.myHealPredictionBar:SetValue(myIncomingHeal)
    end
    self.myHealPredictionBar:Show()

    self.otherHealPredictionBar:SetMinMaxValues(0, maxHealth)
    self.otherHealPredictionBar:SetValue(allIncomingHeal)
    self.otherHealPredictionBar:Show()
end

local Enable = function(self)
    if self.freebHeals then
        if ns.db.healbar then
            self.myHealPredictionBar = CreateFrame('StatusBar', nil, self.Health)
            if ns.db.orientation == "VERTICAL" then
                self.myHealPredictionBar:SetPoint("BOTTOMLEFT", self.Health:GetStatusBarTexture(), "TOPLEFT", 0, 0)
                self.myHealPredictionBar:SetPoint("BOTTOMRIGHT", self.Health:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
                self.myHealPredictionBar:SetSize(0, ns.db.height)
                self.myHealPredictionBar:SetOrientation"VERTICAL"
            else
                self.myHealPredictionBar:SetPoint("TOPLEFT", self.Health:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
                self.myHealPredictionBar:SetPoint("BOTTOMLEFT", self.Health:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
                self.myHealPredictionBar:SetSize(ns.db.width, 0)
            end
            self.myHealPredictionBar:SetStatusBarTexture("", "BORDER")
            self.myHealPredictionBar:GetStatusBarTexture():SetTexture(ns.db.myhealcolor.r, ns.db.myhealcolor.g, ns.db.myhealcolor.b, ns.db.myhealcolor.a)
            self.myHealPredictionBar:Hide()

            self.otherHealPredictionBar = CreateFrame('StatusBar', nil, self.Health)
            if ns.db.orientation == "VERTICAL" then
                self.otherHealPredictionBar:SetPoint("BOTTOMLEFT", self.myHealPredictionBar:GetStatusBarTexture(), "TOPLEFT", 0, 0)
                self.otherHealPredictionBar:SetPoint("BOTTOMRIGHT", self.myHealPredictionBar:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
                self.otherHealPredictionBar:SetSize(0, ns.db.height)
                self.otherHealPredictionBar:SetOrientation"VERTICAL"
            else
                self.otherHealPredictionBar:SetPoint("TOPLEFT", self.myHealPredictionBar:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
                self.otherHealPredictionBar:SetPoint("BOTTOMLEFT", self.myHealPredictionBar:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
                self.otherHealPredictionBar:SetSize(ns.db.width, 0)
            end
            self.otherHealPredictionBar:SetStatusBarTexture("", "BORDER")
            self.otherHealPredictionBar:GetStatusBarTexture():SetTexture(ns.db.otherhealcolor.r, ns.db.otherhealcolor.g, ns.db.otherhealcolor.b, ns.db.otherhealcolor.a)
            self.otherHealPredictionBar:Hide() 

            self:RegisterEvent('UNIT_HEAL_PREDICTION', Update)
            self:RegisterEvent('UNIT_MAXHEALTH', Update)
            self:RegisterEvent('UNIT_HEALTH', Update)
        end

        local healtext = self.Health:CreateFontString(nil, "OVERLAY")
        healtext:SetPoint("BOTTOM")
        healtext:SetShadowOffset(1.25, -1.25)
        healtext:SetFont(ns.db.fontPath, ns.db.fontsizeEdge, ns.db.outline)
        healtext:SetWidth(ns.db.width)
        self.Healtext = healtext

        if ns.db.healtext then
            if ns.db.healothersonly then
                self:Tag(healtext, "[freebgrid:othersheals]")
            else
                self:Tag(healtext, "[freebgrid:heals]")
            end
        else
            self:Tag(healtext, "[freebgrid:def]")
        end
    end
end

local Disable = function(self)
    if self.freebHeals then
        if ns.db.healbar then
            self:UnregisterEvent('UNIT_HEAL_PREDICTION', Update)
            self:UnregisterEvent('UNIT_MAXHEALTH', Update)
            self:UnregisterEvent('UNIT_HEALTH', Update)
        end
    end
end

oUF:AddElement('freebHeals', Update, Enable, Disable)
