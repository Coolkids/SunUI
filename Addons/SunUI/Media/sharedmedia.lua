local LSM = LibStub("LibSharedMedia-3.0")

if LSM == nil then return end

for i=1,18 do
	LSM:Register("statusbar","SunUI StatusBar"..i, "Interface\\AddOns\\SunUI\\media\\statusbars\\statusbar"..i)
	--LSM:Register("font",string, Â·¾¶, 255)
end