--GemCounter v0.2
-- Displays how many red/blue/yellow gems you have
-- Written by Killakhan
-- http://www.wowinterface.com/downloads/author-259436.html

local GemCounter = {}
local addon = GemCounter
local addonName = "GC"
local redGems, blueGems, yellowGems, prismaticGems = 0, 0, 0, 0
local blueTexture = "Interface\\Icons\\inv_misc_cutgemsuperior2"
local redTexture =  "Interface\\Icons\\inv_misc_cutgemsuperior6"
local yellowTexture =  "Interface\\Icons\\inv_misc_cutgemsuperior"
local prismaticTexture = "Interface\\Icons\\INV_Jewelcrafting_DragonsEye02"
local Red_localized, Blue_localized, Yellow_localized, Green_localized, Purple_localized, Orange_localized

addon.f = CreateFrame("Frame", addonName.."main", CharacterFrame)
addon.f:SetScript("OnShow", function(self)
      -- print("on show")
      addon.GetGems()
end)

addon.f:SetScript("OnEvent", function(self, event, ...) 
      if addon[event] then 
         return addon[event](addon, event, ...) 
      end 
end)

addon.f:RegisterEvent("UNIT_INVENTORY_CHANGED")
addon.f:RegisterEvent("PLAYER_LOGIN")

function addon:PLAYER_LOGIN(event, ...)
	Red_localized = select(7, GetItemInfo(52255))
	Blue_localized = select(7, GetItemInfo(52235))
	Yellow_localized = select(7, GetItemInfo(52267))
	Green_localized = select(7, GetItemInfo(52245))
	Purple_localized = select(7, GetItemInfo(52213))
	Orange_localized = select(7, GetItemInfo(52222))
	addon.GetGems()
end
function addon:UNIT_INVENTORY_CHANGED(event, unit)
	if not unit == "player" then return end
	self:PLAYER_LOGIN()
end

for i = 1, 4 do
   addon["button"..i] = PaperDollItemsFrame:CreateTexture(addonName.."button"..i, "OVERLAY")
   local frame = addon["button"..i]
   frame:SetHeight(15)
   frame:SetWidth(15)
   frame.text = PaperDollItemsFrame:CreateFontString(addonName.."text"..i, "OVERLAY", "NumberFontNormal")
   frame.text:SetPoint("LEFT", frame, "RIGHT", 5, 0)
   frame.text:SetText("")
   if i == 1 then
      frame:SetPoint("TOPLEFT", CharacterFrame, "TOPLEFT", 5, -5)
   else
      frame:SetPoint("TOP", addon["button"..(i-1)], "BOTTOM")
   end
end
addon.button1:SetTexture(blueTexture)
addon.button1.text:SetTextColor(0, 0.6, 1)
addon.button2:SetTexture(redTexture)
addon.button2.text:SetTextColor(1, 0.4, 0.4)
addon.button3:SetTexture(yellowTexture)
addon.button3.text:SetTextColor(1, 1, 0)
addon.button4:SetTexture(prismaticTexture)
addon.button4.text:SetTextColor(1, 1, 1)

function addon.GetGems()
	redGems, blueGems, yellowGems, prismaticGems = 0, 0, 0, 0
	for i = 1, 18 do
		local gem1, gem2, gem3
		gem1, gem2, gem3 = GetInventoryItemGems(i)
		if gem1 then
			addon.GetGemColors(gem1)
			addon.GetPrismatic(gem1)
		end
		if gem2 then
			addon.GetGemColors(gem2)
			addon.GetPrismatic(gem2)
		end
		if gem3 then
			addon.GetGemColors(gem3)
			addon.GetPrismatic(gem3)
		end
	end
	addon.button1.text:SetText(blueGems) 
	addon.button2.text:SetText(redGems)
	addon.button3.text:SetText(yellowGems)
	if prismaticGems == 0 then
		addon.button4:Hide()
		addon.button4.text:SetText("")
	else
		addon.button4:Show()
		addon.button4.text:SetText(prismaticGems)
	end
end

function addon.GetPrismatic(gem)
	local testGem = (select(10, GetItemInfo(gem)))
	if testGem then
		if testGem:find("dragonseye") then
			prismaticGems = prismaticGems + 1
		end
	end
end

function addon.GetGemColors(gem)
   --print("checking .. " .. gem)
   local testGem = (select(7, GetItemInfo(gem)))
   if testGem == Red_localized then
      redGems = redGems + 1
   elseif testGem == Blue_localized then
      blueGems = blueGems + 1
   elseif testGem == Yellow_localized then
      yellowGems = yellowGems + 1
   elseif testGem == Green_localized then
      blueGems = blueGems + 1
      yellowGems = yellowGems + 1
   elseif testGem == Purple_localized then
      redGems = redGems + 1
      blueGems = blueGems + 1
   elseif testGem == Orange_localized then
      redGems = redGems + 1
      yellowGems = yellowGems + 1
   else
      return
   end
   
end

