local _, ns = ...
local oUF =  ns.oUF or oUF
assert(oUF, "oUF_Freebgrid was unable to locate oUF install.")

local class = select(2, UnitClass("player"))
local indicator = ns.media.indicator
local symbols = ns.media.symbols

local update = .2

local Enable = function(self)
    if(self.freebIndicators) then
        self.AuraStatusTL = self.Health:CreateFontString(nil, "OVERLAY")
        self.AuraStatusTL:ClearAllPoints()
        self.AuraStatusTL:SetPoint("TOPLEFT", self.Health, 0, -1)
        self.AuraStatusTL:SetFont(indicator, ns.db.indicatorsize, "THINOUTLINE")
        self.AuraStatusTL.frequentUpdates = update
        self:Tag(self.AuraStatusTL, ns.classIndicators[class]["TL"])

        self.AuraStatusTR = self.Health:CreateFontString(nil, "OVERLAY")
        self.AuraStatusTR:ClearAllPoints()
        self.AuraStatusTR:SetPoint("TOPRIGHT", self.Health, 2, -1)
        self.AuraStatusTR:SetFont(indicator, ns.db.indicatorsize, "THINOUTLINE")
        self.AuraStatusTR.frequentUpdates = update
        self:Tag(self.AuraStatusTR, ns.classIndicators[class]["TR"])

        self.AuraStatusBL = self.Health:CreateFontString(nil, "OVERLAY")
        self.AuraStatusBL:ClearAllPoints()
        self.AuraStatusBL:SetPoint("BOTTOMLEFT", self.Health, 0, 0)
        self.AuraStatusBL:SetFont(indicator, ns.db.indicatorsize, "THINOUTLINE")
        self.AuraStatusBL.frequentUpdates = update
        self:Tag(self.AuraStatusBL, ns.classIndicators[class]["BL"])
	
		self.AuraStatusRC = self.Health:CreateFontString(nil, "OVERLAY")
        self.AuraStatusRC:ClearAllPoints()
        self.AuraStatusRC:SetPoint("RIGHT", self.Health, 2, -1)
        self.AuraStatusRC:SetFont(symbols, ns.db.symbolsize-2 , "THINOUTLINE")
        self.AuraStatusRC.frequentUpdates = update
        self:Tag(self.AuraStatusRC, ns.classIndicators[class]["RC"])

        self.AuraStatusBR = self.Health:CreateFontString(nil, "OVERLAY")
        self.AuraStatusBR:ClearAllPoints()
        self.AuraStatusBR:SetPoint("BOTTOMRIGHT", self.Health, 6, -2)
        self.AuraStatusBR:SetFont(symbols, ns.db.symbolsize, "THINOUTLINE")
        self.AuraStatusBR.frequentUpdates = update
        self:Tag(self.AuraStatusBR, ns.classIndicators[class]["BR"])

        self.AuraStatusCen = self.Health:CreateFontString(nil, "OVERLAY")
        self.AuraStatusCen:SetPoint("TOP")
        self.AuraStatusCen:SetJustifyH("CENTER")
        self.AuraStatusCen:SetFont(ns.db.fontPath, ns.db.fontsizeEdge, ns.db.outline)
        self.AuraStatusCen:SetShadowOffset(1.25, -1.25)
        self.AuraStatusCen:SetWidth(ns.db.width)
        self.AuraStatusCen.frequentUpdates = update
        self:Tag(self.AuraStatusCen, ns.classIndicators[class]["Cen"])
    end
end

oUF:AddElement('freebIndicators', nil, Enable, nil)
