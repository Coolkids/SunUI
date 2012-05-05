local S, C, L, DB = unpack(select(2, ...))
 
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("Stancebar", "AceEvent-3.0")
function Module:OnInitialize()
	C = ActionBarDB
    local num = NUM_SHAPESHIFT_SLOTS
    local bar = CreateFrame("Frame","SunUIStanceBar",UIParent, "SecureHandlerStateTemplate")
    bar:SetWidth(C["ButtonSize"]*6+C["ButtonSpacing"]*(6-1))
    bar:SetHeight(C["ButtonSize"])
    bar:SetHitRectInsets(-10, -10, -10, -10)
    bar:SetScale(C["StanceBarSacle"])
    MoveHandle.SunUIStanceBar = S.MakeMove(bar, "SunUI姿态栏", "stancebar", C["StanceBarSacle"])

    ShapeshiftBarFrame:SetParent(bar)
    ShapeshiftBarFrame:EnableMouse(false)
    
    for i=1, num do
		local button = _G["ShapeshiftButton"..i]
		button:SetSize(C["ButtonSize"], C["ButtonSize"])
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", bar, 0,0)
		else
			local previous = _G["ShapeshiftButton"..i-1]      
			button:SetPoint("LEFT", previous, "RIGHT", C["ButtonSpacing"], 0)
		end
    end
    
    local function MoveShapeshift()
		ShapeshiftButton1:SetPoint("BOTTOMLEFT", bar, 0,0)
    end
    hooksecurefunc("ShapeshiftBar_Update", MoveShapeshift);
end 